% Scrivere un programma che risolva il Cigarette Smokers Problem ([wikipedia](https://en.wikipedia.org/wiki/Cigarette_smokers_problem)). La soluzione deve prevedere cinque attori: i 3 fumatori,
%    l'agente che mette sul tavolo gli ingredienti e il tavolo.

% Agents: 3 smokers, 1 arbiter, 1 table
% Supplies: tobacco, paper, matches

% Every Smoker has an infinite supply of one of the three ingredients 
% Arbiter randomly selects two of the supplies to place on the table
% The third Smoker takes the supplies and smoker for a while

- module(cigasp) .
- export([main/0, table/0, smoker/4]) .

- define(nsmokers, 3) .
- define(iterations, 10) .

% UTILS
sleep(N) -> receive after N * 100 -> ok end .

% AGENTS

table() -> ok.

arbiter() -> 
    sleep(rand:uniform(3)) .

get_materials(Table, SmokerId) ->
	Table ! {get, self(), lists:seq(0, ?nsmokers) --  [SmokerId]} ,
	receive ok -> ok end .

smoker(Main, Table, SmokerId, Iteration) when Iteration > 0 ->
    io:format("Smoker ~p waits materials~n", [SmokerId]) ,
    get_materials(Table, SmokerId) ,
    io:format("Smoker ~p is smoking~n", [SmokerId]) ,
    sleep(rand:uniform(5)) ,
    smoker(Main, Table, SmokerId, Iteration - 1) ;
    
smoker(Main, _, _, 0) ->
    Main ! exit .

main() ->
    Smokers = lists:seq(0, ?nsmokers) ,
    Table = spawn(?MODULE, table, []) ,
    [ spawn(?MODULE, smoker, [self(), Table, SmokerId, iterations]) || SmokerId <- Smokers ] 
    % SPAWN AGENT WITH SMOKERS PIDS
.