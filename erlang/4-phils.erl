% Risolvere il problema dei filosofi a cena evitando deadlock, starvation,
%    busy waiting e facendo in modo che tutti i filosofi eseguano lo stesso
%    codice (nessun filosofo mancino...)

- module(phils) .
- export([main/0, table/2, philosofer/4]) .

- define(Nphils, 5) .
- define(Iterations, 100) .
% 5 filosofi 5 forchette servono due forchette per mangiare
% aka filosofi in deadlock

% Utils
sleep(Time) -> receive after Time * 1 -> ok end.

% Attore che gestisce l'assegnamento di forchette
table(FreeForks, Pending) ->
	Process_pending = 
		fun 
			Aux([]) -> ko ;
			Aux([R = {get, Phil, Fork1, Fork2}|Tl]) ->
				case lists:member(Fork1, FreeForks) and lists:member(Fork1, FreeForks) of
					% Se c'e' la forchetta restituisco ok
					% sbloccando il richiedente
					true ->
						Phil ! ok ,
						{ ok, FreeForks -- [Fork1] -- [Fork2], Pending -- [R] } ;
					% Altrimenti itero sulla code
					false -> Aux(Tl)
				end 
		end ,
	case Process_pending(Pending) of
		% Se ho assegnato una forchetta, reitero su tavolo
		{ok, FreeForks2, Pending2} -> table(FreeForks2, Pending2) ;
		% altrimenti attendo nuove richieste
		ko -> 
			receive
				% Se ricevo una richiesta di una forchetta
				T = {get, Phil, Fork1, Fork2} ->
					case lists:member(Fork1, FreeForks) and lists:member(Fork2, FreeForks) of
						% Se la ho la restituisco e reitero
						true ->
							Phil ! ok ,
							table(FreeForks -- [Fork1] -- [Fork2], Pending) ; % differenza simmetrica fra insiemi
						false -> 
							table(FreeForks, [T | Pending])
						end ;
				% Se qualcuno mi sblocca una forchetta reitero
				{free, Fork1, Fork2} ->
					table([Fork1, Fork2 |FreeForks], Pending)
			end
	end
.

% Philosofers
get_forks(Table, Fork1, Fork2) ->
	Table ! {get, self(), Fork1, Fork2} ,
	receive ok -> ok end
.

release_forks(Table, Fork1, Fork2) ->
	sleep(rand:uniform(10)) ,
	Table ! {free, Fork1, Fork2}
.

philosofer(Main, _, _, 0) -> Main ! exit ;

philosofer(Main, Table, Id, Ite) ->
	io:format("~p thinks (~p) ~n", [Id, Ite]) ,
	sleep(rand:uniform(3)) ,
	io:format("~p is hungry (~p)~n", [Id, Ite]) ,
	get_forks(Table, Id, (Id+1) rem ?Nphils) ,
	io:format("~p eats (~p)~n", [Id, Ite]) ,
	sleep(rand:uniform(2)) ,
	release_forks(Table, Id, (Id+1) rem ?Nphils) ,
	philosofer(Main, Table, Id, Ite - 1) 
.

main() ->
	Phils = lists:seq(0, ?Nphils) ,
	Table = spawn(?MODULE, table, [ Phils, [] ]) ,
	[ spawn(?MODULE, philosofer, [ self(), Table, Phil, ?Iterations ]) || Phil <- Phils ] ,
	[ receive exit -> io:format("Bye bye philosofer ~p~n", [Phil]) end || Phil <- Phils ]
.