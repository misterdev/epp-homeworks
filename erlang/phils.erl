- module(filosofi) .
- export([main/0, table/2, philosofer/4]) .

% 5 filosofi 5 forchette servono due forchette per mangiare
% aka filosofi in deadlock

% Attore che gestisce l'assegnamento di forchette
table(L, Pending) ->
	Process_pending = 
		fun 
			Aux([]) -> ko ;
			Aux([T = {get, Phil, X}|Tl]) ->
				case lists:member(X,L) of
					% Se c'e' la forchetta restituisco ok
					% sbloccando il richiedente
					true ->
						Phil ! ok ,
						{ ok, L -- [X], Pending -- [T] } ;
					% Altrimenti itero sulla code
					false -> Aux(Tl)
				end 
		end,
	case Process_pending(Pending) of
		% Se ho assegnato una forchetta, reitero su tavolo
		{ok, L2, Pending2} -> table(L2, Pending2) ;
		% altrimenti attendo nuove richieste
		ko -> 
			receive
				% Se ricevo una richiesta di una forchetta
				T = {get, Phil, X} ->
					case lists:member(X, L) of
						% Se la ho la restituisco e reitero
						true ->
							Phil ! ok ,
							table(L -- [X], Pending) ; % differenza simmetrica fra insiemi
						false -> 
							table(L, [T | Pending])
						end ;
				% Se qualcuno mi sblocca una forchetta reitero
				{free, X} ->
					table([X|L], Pending)
			end
	end.

get_fork(Table, X) ->
	Table ! {get, self(), X} ,
	receive ok -> ok end .

release_fork(Table, X) ->
	sleep(rand:uniform(10)) ,
	Table ! {free, X} .

sleep(N) -> receive after N * 10 -> ok end.

philosofer(Main, Table, N, Ite) when Ite > 0 ->
	io:format("~p thinks (~p) ~n", [N, Ite]) ,
	sleep(rand:uniform(3)) ,
	io:format("~p is hungry (~p)~n", [N, Ite]) ,
	get_fork(Table, N) ,
	get_fork(Table, (N+1) rem 5) ,
	io:format("~p eats (~p)~n", [N, Ite]) ,
	sleep(rand:uniform(2)) ,
	release_fork(Table, N) ,
	release_fork(Table, (N+1) rem 5) ,
	philosofer(Main, Table, N, Ite - 1) ;

philosofer(Main, _, _, 0) -> Main ! exit .

main() ->
	SEQ = lists:seq(0, 4),
	Table = spawn(?MODULE, table, [ SEQ, [] ]) ,
	[ philosofer(self(), Table, Phil, 5) || Phil <- SEQ ] ,
	[ receive exit -> io:format("Bye bye philosofer ~p~n", [Phil]) end || Phil <- SEQ ]
	.