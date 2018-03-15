% 3. Scrivere la funzione che, data una lista e un predicato, ritorna due
%    liste contenenti rispettivamente gli elementi della lista in input che
%    soddisfano il predicato e quelli che non lo soddisfano. 
%    Fornire le implementazioni:
%    a. usando la fold
%    b. una senza usare la fold
%
%    La funzione implemenata è tail-ricorsiva? Altrimenti fornire un'altra
%    implementazione tail ricorsiva.

- module(list).
- export([main/1]).

% Filter using fold
filter([], _, SAT, NSAT) -> {SAT, NSAT} ;
filter([H|TL], P, SAT, NSAT) ->
    case P(H) of
        true ->
            filter(TL, P, SAT++[H], NSAT) ;
        false ->
            filter(TL, P, SAT, NSAT++[H])
    end.

isPositive(X) -> X > 0 . 

% Filter not using a fold

filter2([], SAT, NSAT) -> {SAT, NSAT} ;
filter2([H|TL], SAT, NSAT) ->
    case isPositive(H) of
        true ->
            filter2(TL, SAT++[H], NSAT) ;
        false ->
            filter2(TL, SAT, NSAT++[H])
    end.


main(LIST) ->
	% filter(LIST, fun (X) -> X > 0, [], []) .
	filter2(LIST, [], []) .



