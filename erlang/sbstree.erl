% 4. Implementare un BST che mantenga coppie chiave-valore nei nodi.
%    Scrivere la funzione che, dato un BST, ritorni il valore associato a una
%    chiave nel BST se esiste e not_present altrimenti. Implementare la funzione
%    due volte: la prima senza usare eccezioni, la seconda usando un'eccezione
%    locale.

- module(sbstree) .
- export([main/0]) .

% Key value binary search tree
insert(K, V, nil) -> {node, K, V, nil, nil} ;
insert(K, V, {node, K1, V1, L, R}) when K1 > K ->
	{node, K1, V1, insert(K, V, L), R} ;
insert(K, V, {node, K1, V1, L, R}) when K > K1 ->
	{node, K1, V1, L, insert(K, V, R)} ;
insert(K, V, {node, K, _V1, L, R}) -> {node, K, V, L, R} .

foldl(_F, [], T) -> T ;
foldl(F, [{K, V}|TL], T) ->
	foldl(F, TL, F(K, V, T)).

% Search Key
getValue(_K, nil) -> not_present ;
getValue(K, { node, K1, V, L, R }) when K1 > K -> getValue(K, L) ;
getValue(K, { node, K1, V, L, R }) when K > K1 -> getValue(K, R) ;
getValue(_K, { node, _K, V, _L, _R } ) -> V .

main() ->
	Tree = foldl(fun insert/3, [{0, ciao}, {1, ciao1}, {4, ciao4}, {8, ciao8}, {17, ciao17}, {3, ciao3}], nil),
	% Tree = foldl(fun insert/3, [{0, ciao}], nil),
	getValue(18, Tree).
	% io:format("Executing").