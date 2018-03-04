- module(bstree) .
- export([main/0]) .

empty() -> nil .

insert(K, nil) -> {node, K, nil, nil} ; 
insert(K, {node, K1, L, R}) when K < K1 -> {node, K1, insert(K, L), R} ;
insert(K, {node, K1, L, R}) when K > K1 -> {node, K1, L, insert(K, R)} ;
insert(_K, T) -> T .

foldl(_F, R, []) -> R ;
foldl(F, R, [H | TL]) -> foldl(F, F(H, R), TL) .

% APPEND
mappend(T1, nil) ->  T1 ;
mappend(nil, T2) -> T2 ;
mappend({node, K, L, R}, T2) -> insert(K, mappend(L, mappend(R, T2))).

foldtree(_F, RET, nil) -> RET ;
foldtree(_F, nil, T) -> T ;
foldtree(F, RET, {node, K, L, R}) -> foldtree(F, foldtree(F, F(K, RET), L), R) .

% REMOVE
remove(_K, nil) -> nil ;
remove(K, {node, K1, L, R}) when K < K1 -> {node, K1, remove(K, L), R} ;
remove(K, {node, K1, L, R}) when K > K1 -> {node, K1, L, remove(K, R)} ;
remove(_, {node, _, L, R}) -> mappend(R, L) .

main() ->
	Tree = foldl(fun insert/2, empty(), [8, 3, 10, 14]),
	Tree2 = foldl(fun insert/2, empty(), [ 6, 7, 13, 4, 1, 3]),
	% mappend(Tree2, Tree).
	Tree3 = foldtree(fun insert/2, Tree, Tree2) ,
	remove(3, Tree3) .




% Esercizi
% 1. Scrivere la funzione che rimuove una chiave da un BST
% 2. Scrivere la funzione append:
% 		- a mano 
% 		- usando una fold