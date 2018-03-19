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

% Search key
get_value(_K, nil) -> not_present ;
get_value(K, { node, K1, V, L, R }) when K1 > K -> get_value(K, L) ;
get_value(K, { node, K1, V, L, R }) when K > K1 -> get_value(K, R) ;
get_value(_K, { node, _K, V, _L, _R } ) -> V .

% Search key using exceptions
throw_value(_K, nil) -> throw(not_present) ;
throw_value(K, { node, K1, V, L, R }) when K1 > K -> throw_value(K, L) ;
throw_value(K, { node, K1, V, L, R }) when K > K1 -> throw_value(K, R) ;
throw_value(_K, { node, _K, V, _L, _R } ) -> throw({found, V}) .


main() ->
	Tree = foldl(fun insert/3, [{0, ciao}, {1, ciao1}, {4, ciao4}, {8, ciao8}, {17, ciao17}, {3, ciao3}], nil),
	% Tree = foldl(fun insert/3, [{0, ciao}], nil),
	% get_value(18, Tree).
	K = 4,
	try throw_value(K, Tree) catch
		{ found, V } -> io:format("Found: ~p~n", [V]) ;
		not_present -> io:format("Key not present: ~p~n", [K])
	end.
	% io:format("Executing").