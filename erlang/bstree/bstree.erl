- module(bstree) .
- export([main/0]) .

empty() -> nil .

insert(K, nil) -> {node, K, nil, nil} ; 
insert(K, {node, K1, L, R}) when K < K1-> {node, K1, insert(K, L), R} ;
insert(K, {node, K1, L, R}) when K > K1-> {node, K1, L, insert(K, R)} ;
insert(_K, T) -> T .

foldl(_F, R, []) -> R ;
foldl(F, R, [H | TL]) -> foldl(F, F(H, R), TL) .

main() ->
	foldl(fun insert/2, empty(), [8, 3, 10, 14, 6, 7, 13, 4, 1, 3]) .

% Esercizi
% 1. Scrivere la funzione che rimuove una chiave da un BST
% 2. Scrivere la funzione append:
% 		- a mano
% 		- usando una fold