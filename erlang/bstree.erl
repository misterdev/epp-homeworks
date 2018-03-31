% Homeworks
% 1. Scrivere la funzione che rimuove una chiave da un BST
% 2. Scrivere la funzione append senza usare una fold e usando una fold.
   % La funzione implemenata è tail-ricorsiva? Altrimenti fornire un'altra
   % implementazione tail ricorsiva.

- module(bstree) .
- export([main/0]) .

empty() -> nil .

insert(K, nil) -> {node, K, nil, nil} ; 
insert(K, {node, K1, L, R}) when K < K1 -> {node, K1, insert(K, L), R} ;
insert(K, {node, K1, L, R}) when K > K1 -> {node, K1, L, insert(K, R)} ;
insert(_K, T) -> T .

foldl(_F, R, []) -> R ;
foldl(F, R, [H | TL]) -> foldl(F, F(H, R), TL) .

% 1. REMOVE
remove(_K, nil) -> nil ;
remove(K, {node, K1, L, R}) when K < K1 -> {node, K1, remove(K, L), R} ;
remove(K, {node, K1, L, R}) when K > K1 -> {node, K1, L, remove(K, R)} ;
remove(_, {node, _, L, R}) -> append(R, L) .

% 2. APPEND
append(T1, nil) ->  T1 ;
append(nil, T2) -> T2 ;
% append({node, K, L, R}, T2) -> insert(K, append(L, append(R, T2))).
append({node, K, L, R}, T2) -> append(L, append(R, insert(K, T2)))) .

foldappend(_F, nil, RET) -> RET ;
foldappend(_F, T, nil) -> T ;
foldappend(F, {node, K, L, R}, RET) -> foldappend(F, R, foldappend(F, L, F(K, RET))) .


main() ->
	Tree = foldl(fun insert/2, empty(), [8, 3, 10, 14]),
	Tree2 = foldl(fun insert/2, empty(), [ 6, 7, 13, 4, 1, 3]),
	% append(Tree2, Tree).
	Tree3 = foldappend(fun insert/2, Tree, Tree2) ,
	remove(3, Tree3)
.