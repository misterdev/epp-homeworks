% Scrivere un programma che risolva il Cigarette Smokers Problem ([wikipedia](https://en.wikipedia.org/wiki/Cigarette_smokers_problem)). La soluzione deve prevedere cinque attori: i 3 fumatori,
%    l'agente che mette sul tavolo gli ingredienti e il tavolo.

% Agents: 3 smokers, 1 arbiter, 1 table
% Supplies: tobacco, paper, matches

% Every Smoker has an infinite supply of one of the three ingredients 
% Arbiter randomly selects two of the supplies to place on the table
% The third Smoker takes the supplies and smokes for a while

- module(cigasp) .
- export([main/0, table/0, smoker/3, arbiter/3]) .

- define(ingredients, 3) .
- define(iterations, 2) .

% UTILS
sleep(N) -> receive after N * 100 -> ok end .

% AGENTS

table() -> 
    receive
        X -> io:format("RECEIVED ~p ~n", [X]),
        table()
    end
.

arbiter(Main, _, 0) -> Main ! exit ;

arbiter(Main, Smokers, Iteration) ->
    IgnoredSupply = rand:uniform( ?ingredients ) - 1 ,
    [ Smoker ! { place, lists:seq(0, ?ingredients - 1) -- [IgnoredSupply] } || Smoker <- Smokers ] ,
    sleep(rand:uniform(5)) ,
    arbiter(Main, Smokers, Iteration - 1 )
.


get_materials(Table, Supplies) ->
	Table ! { get, self(), Supplies }
	% receive ok -> ok end
.

smoker(Main, Table, SmokerId) ->
    receive
        { place, [Supply1, Supply2] } when Supply1 == SmokerId orelse Supply2 == SmokerId ->
            % io:format("~p JLKJLKJL, ~p ~p ~n", [SmokerId, Supply1, Supply2]) ,
            Table ! { put, SmokerId } ;
        { place, Supplies } ->
            % io:format("~p JLKJLKJL, ~p ~n", [SmokerId, Supplies]) ,
            get_materials(Table, Supplies) ,
            sleep(rand:uniform(5)) % Smokes for some time
        end ,
        smoker(Main, Table, SmokerId)
.
    % io:format("Smoker ~p waits materials~n", [SmokerId]) ,
    % get_materials(Table, SmokerId) ,
    % io:format("Smoker ~p is smoking~n", [SmokerId]) ,
    % sleep(rand:uniform(5)) ,
    % smoker(Main, Table, SmokerId) .

main() ->
    Table = spawn(?MODULE, table, []) ,
    Smokers = [ spawn(?MODULE, smoker, [self(), Table, SmokerId]) || SmokerId <- lists:seq(0, ?ingredients - 1) ] ,
    Arbiter = spawn(?MODULE, arbiter, [self(), Smokers, ?iterations]) 

    % Tup
    % SPAWN AGENT WITH SMOKERS PIDS
.