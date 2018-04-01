- module(mcell2) .
- export([main/0, cell/2, actor1/2, actor2/2]) .
- compile({no_auto_import, [get/1]}) .

- define(Iterations, 10) .

% UTILS
sleep(Time) -> receive after Time -> ok end .

print(Message) -> io:format(Message) .
print(Message, Variables) -> io:format(Message, Variables) .

% CELL

cell(Val, Awaiters) ->
    receive
        { Pid, get } -> Pid ! { self(), Val }, cell(Val, Awaiters) ;
        { Pid, await } -> cell(Val, Awaiters ++ [Pid]) ;
        commit -> [ Pid ! { self(), commit} || Pid <- Awaiters], cell(Val, Awaiters)
    end
.

% Cell API

init_transaction(Val) ->
    Pid = spawn(?MODULE, cell, [Val, []]) ,
    print("|  > Cell1 ~p = ~p~n", [Pid, Val]) ,
    Pid
.

commit(Cell) ->
    Cell ! commit
.

abort(Cell) ->
    exit(Cell, kill)
.

get(Cell) ->
    Cell ! { self(), get },
    link(Cell) ,
    receive
        { Cell, Val } -> unlink(Cell), Val
    end
.

await(Cell) -> 
    Cell ! { self(), await } ,
    link(Cell) ,
    receive
        { Cell, commit } -> unlink(Cell), ok
    end
.

% TEST

abort_or_commit(Cell, CellId) ->
    Random = rand:uniform(2) ,
    case Random of
        1 -> abort(Cell), print("|  - ABORT Cell~p~n",[CellId]);
        2 -> commit(Cell), print("|  - COMMIT Cell~p~n",[CellId])
    end
.

actor1( Cell, CellId) -> 
    Val = get(Cell) ,
    await(Cell) ,
    print("|  = A1: GOT VALUE ~p FROM Cell~p~n", [Val, CellId]) ,
    exit(self(), ok)
.

actor2(Cell1, Cell2) -> 
    Val1 = get(Cell1) ,
    Val2 = get(Cell2) ,
    await(Cell1) ,
    await(Cell2) ,
    print("|  = A2: ~p + ~p = ~p~n", [Val1, Val2, Val1+Val2]) ,
    exit(self(), ok)
.

test(?Iterations) -> print("~n===== ALL TESTS COMPLETED =====~n") ;

test(Iterations) ->
    print("~n~n===== TEST ~p/~p STARTED =====~n", [Iterations+1, ?Iterations]) ,
    print("|~n|  +++ CELLS CREATED +++~n|~n") ,
    Cell1 = init_transaction(3) ,
    Cell2 = init_transaction(5) ,
    Pid1 = spawn(?MODULE, actor1, [Cell1, 1]) ,
    Pid2 = spawn(?MODULE, actor1, [Cell2, 2]) ,
    Pid3 = spawn(?MODULE, actor2, [Cell1, Cell2]) ,
    Pids = [Pid1, Pid2, Pid3] ,
    Monitors = [ erlang:monitor(process, Pid) || Pid <- Pids] ,
    print("|~n|  >>> NOW WAITING 5s <<<~n|~n") ,
    sleep(1000) ,
    abort_or_commit(Cell1, 1) ,
    abort_or_commit(Cell2, 2) ,
    [ receive {'DOWN', Monitor, process, _, _} -> erlang:demonitor(Monitor) end || Monitor <- Monitors] ,
    print("|~n----- TEST ~p/~p COMPLETED ----~n~n", [Iterations+1, ?Iterations]) ,
    test(Iterations + 1)
.

main() -> 
    test(0)
.