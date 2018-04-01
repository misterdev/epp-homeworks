- module(mcell) .
- export([main/0, cell/2, actor1/3, actor2/3]) .
- compile({no_auto_import, [get/1]}) .

- define(Iterations, 10) .
% UTILS
sleep(Time) -> receive after Time -> ok end .

print(Message) -> io:format(Message) .
print(Message, Variables) -> io:format(Message, Variables) .

% CELL

cell(Val, Awaiters) ->
    receive
        { Pid, get } -> Pid ! { self(), Val }, cell(Val, Awaiters), print("get~n") ;
        { Pid, await } -> cell(Val, Awaiters ++ [Pid]), print("await~n") ;
        commit -> [ Pid ! { self(), await, commit} || Pid <- Awaiters], cell(Val, Awaiters), print("commit~n") ;
        abort -> [ Pid ! { self(), await, abort} || Pid <- Awaiters], cell(Val, Awaiters), print("commit~n")
    end
.

% Cell API

init_transaction(Val) ->
    spawn(?MODULE, cell, [Val, []])
.

commit(Cell) ->
    Cell ! commit
.

abort(Cell) ->
    Cell ! abort
.

get(Cell) ->
    Cell ! { self(), get },
    receive
        { Cell, Val } -> Val
    end
.

await(Cell) -> 
    Cell ! { self(), await } ,
    receive
        { Cell, await, Res} -> Res
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

actor1(Main, Cell, CellId) -> 
    Val = get(Cell) ,
    % print("=A1: GOT VALUE ~p FROM ~p~n", [Val, Cell]) ,
    case await(Cell) of
        commit -> print("|  = A1: GOT VALUE ~p FROM Cell~p~n", [Val, CellId]) ;
        _ -> ko
    end ,
    Main ! exit
.

actor2(Main, Cell1, Cell2) -> 
    Val1 = get(Cell1) ,
    Val2 = get(Cell2) ,
    % print("=A2: ~p + ~p = ~p~n", [Val1, Val2, Val1+Val2]) ,
    % await(Cell1) ,
    % ,
    case { await(Cell1), await(Cell2) } of
        { commit, commit } -> print("|  = A2: ~p + ~p = ~p~n", [Val1, Val2, Val1+Val2]) ;
        _ -> ko
    end ,
    Main ! exit
.

test(?Iterations) -> print("~n===== ALL TESTS COMPLETED =====~n") ;

test(Iterations) ->
    Cell1 = init_transaction(3) ,
    Cell2 = init_transaction(5) ,
    spawn(?MODULE, actor1, [self(), Cell1, 1]) ,
    spawn(?MODULE, actor1, [self(), Cell2, 2]) ,
    spawn(?MODULE, actor2, [self(), Cell1, Cell2]) ,
    print("~n~n===== TEST ~p/~p STARTED =====~n", [Iterations+1, ?Iterations]) ,
    print("|~n|  +++ CELLS CREATED +++~n|~n") ,
    print("|  > Cell1 ~p~n", [Cell1]) ,
    print("|  > Cell2 ~p~n", [Cell2]) ,
    print("|~n|  >>> NOW WAITING 5s <<<~n|~n") ,
    sleep(2000) ,
    abort_or_commit(Cell1, 1) ,
    abort_or_commit(Cell2, 2) ,
    [ receive exit -> ok end || _ <- lists:seq(1, 3)] ,
    print("|~n----- TEST ~p/~p COMPLETED ----~n~n", [Iterations+1, ?Iterations]) ,
    test(Iterations + 1)
.

main() -> 
    test(0)
.