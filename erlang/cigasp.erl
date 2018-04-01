% Scrivere un programma che risolva il Cigarette Smokers Problem ([wikipedia](https://en.wikipedia.org/wiki/Cigarette_smokers_problem)). La soluzione deve prevedere cinque attori: i 3 fumatori,
%    l'agente che mette sul tavolo gli ingredienti e il tavolo.

% Agents: 3 smokers, 1 arbiter, 1 table
% Supplies: tobacco, paper, matches

% Every Smoker has an infinite supply of one of the three ingredients 
% Arbiter randomly selects two of the supplies to place on the table
% The third Smoker takes the supplies and smokes for a while

- module(cigasp) .
- export([main/0, table/3, smoker/3, arbiter/4]) .

- define(Iterations, 100) .
- define(Materials, [tobacco, paper, matches]) .

% UTILS
sleep(N) -> receive after N * 1 -> ok end .

% AGENTS
table(Main, Inventory, Requests) ->
    io:format("- INVENTORY: ~p~n- REQUESTS: ~p~n", [Inventory, Requests]) ,
    Satisfy_pending =
        fun
            Aux( [] ) -> ko ;
            Aux( [ R = { get, _, [Supply1, Supply2] } |TL] ) ->
                case lists:member(Supply1, Inventory) and lists:member(Supply2, Inventory) of
                    true -> R ;
                    false -> Aux(TL)
                end
        end ,
    case Satisfy_pending(Requests) of
        R = { get, Smoker, [Supply1, Supply2] } -> 
            Smoker ! { self(), ok } ,
            io:format("T: ALLOWED TO SMOKE ~p and ~p ~n", [Supply1, Supply2 ]) ,
            table(Main, lists:delete(Supply1, lists:delete(Supply2, Inventory) ), lists:delete(R, Requests)) ;
        ko -> 
            receive
                { put, Supply } -> 
                    io:format("T: RECEIVED ~p~n", [Supply ]),
                    table(Main, Inventory ++ [Supply], Requests) ;
                R = { get, Smoker, [Supply1, Supply2] } -> 
                    io:format("T: REQUESTED SOME ~p and ~p ~n", [Supply1, Supply2 ]) ,
                    case lists:member(Supply1, Inventory) and lists:member(Supply2, Inventory) of
                        true -> 
                            Smoker ! { self(), ok } ,
                            io:format("T: ALLOWED TO SMOKE ~p and ~p ~n", [Supply1, Supply2 ]) ,
                            table(Main, lists:delete(Supply1, lists:delete(Supply2, Inventory) ), Requests) ;
                        false ->
                            table(Main, Inventory, Requests ++ [R])
                    end

            end
    end
.

% ARBITER

arbiter(Main, _, _, 0) -> Main ! { self(), exit } ;

arbiter(Main, Materials, Smokers, Iteration) ->
    ChosenMaterials = choose_materials(Materials) ,
    io:format("A: now smoking: ~p~n", [ChosenMaterials]) ,
    [ Smoker ! { place, ChosenMaterials } || Smoker <- Smokers ] ,
    arbiter(Main, Materials, Smokers, Iteration - 1 )
.

% SMOKER

choose_materials(Materials) -> 
    Ignored = rand:uniform(length(Materials)) ,
    Materials -- [lists:nth(Ignored, Materials)]
.

smoker(Main, Table, Material) ->
    receive
        { place, [Supply1, Supply2] } when Supply1 == Material orelse Supply2 == Material ->
            io:format("S: ~p -> I SEND MY MATERIAL~n", [Material]) ,
            Table ! { put, Material } ;
        { place, Supplies } ->
            io:format("S: ~p -> I NEED ~p~n", [Material, Supplies]) ,
            Table ! { get, self(), Supplies } ;
        { Table, ok } ->
            io:format("S: ~p -> I SMOKE~n", [Material]) ,
            sleep(rand:uniform(3)) , % Smokes for some time
            Main ! smoked 
    end ,
    smoker(Main, Table, Material)
.

main() ->
    Table = spawn(?MODULE, table, [self(), [], []]) ,
    Smokers = [ spawn(?MODULE, smoker, [self(), Table, Material]) || Material <- ?Materials ] ,
    Arbiter = spawn(?MODULE, arbiter, [self(), ?Materials, Smokers, ?Iterations]) ,
    receive { Arbiter, exit } -> io:format("ARBITER: ~p Smoking orders delivered! ~n", [?Iterations]) end ,
    [ receive smoked -> io:format("# ~p/~p Smoking completed! ~n", [I, ?Iterations]) end || I <- lists:seq(1, ?Iterations) ]
.