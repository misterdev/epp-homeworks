-module(futures).
-export([main/0, do_work/1]).

% Uso:
% c(futures).
% futures:main()
%
% Il codice mostra una semplice implementazione di futures in Erlang.
% L'implementazione assume che il codice eseguito dal future non sollevi
% eccezioni e non termini in maniera anomala. Il future inizia immediatamente
% a valuare il codice in un processo concorrente. Il valore ritornato dal
% processo concorrente viene correttamente memoized.
%
% Il test crea 5 futures: A,B,C,D,E. D fa forcing di A e C, E di B e C e
% la main di E e C. Pertanto sono possibili numerosi interleaving.

% codice eseguito dal nuovo attore

% UTILS
sleep(Time) -> receive after Time -> ok end.

do_work(F) ->
    R = try { success, F() }
        catch Exc -> { error, Exc }
        end ,
    Loop = fun Loop() ->
            receive
                    {yield, PID} -> PID ! {result, R}, Loop()
            end
    end,
    Loop()
.

make_future(F) ->
    spawn(?MODULE,do_work,[F])
.


yield(F) ->
    F ! { yield, self() } ,
    receive
            { result, { success, R} } -> R ;
            { result, { error, R} } -> throw(R)
    end
.

main() ->
    ResA = make_future(fun chiamoA/0) ,
    ResB = make_future(fun chiamoB/0) ,
    ResC = make_future(fun chiamoC/0) ,
    ResD = make_future(fun() ->
        io:format("D terminata ~p~n", [
            try yield(ResA) catch _ -> 0 end
            + 
            try yield(ResC) catch _ -> 0 end
        ]), 4 end),
    ResE = make_future(fun() ->
        io:format("E terminata ~p~n", [
            try yield(ResB) catch _ -> 0 end 
            + 
            try yield(ResC) catch _ -> 0 end
        ]), 4 end),
    yield(ResD) + yield(ResE)
.

chiamoA() ->
    sleep(rand:uniform(5)) ,
    throw(random_error) ,
    io:format("A terminata~n") ,
    3
.

chiamoB() ->
    sleep(rand:uniform(3)) ,
    io:format("B terminata~n") ,
    4
.

chiamoC() ->
    sleep(rand:uniform(2)) ,
    io:format("C terminata~n") ,
    5
.