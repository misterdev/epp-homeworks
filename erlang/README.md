# Erlang Homeworks

## Usage
1. Start the Erlang shell using `erl`
2. Compile the Erlang file `c(bstree).`
3. Run the program `bstree:main().`

## Programmazione funzionale

[1.](https://github.com/MisterDev/epp-homeworks/blob/master/erlang/bstree.erl#L20) Scrivere la funzione che rimuove una chiave da un BST

[2.](https://github.com/MisterDev/epp-homeworks/blob/master/erlang/bstree.erl#L26) Scrivere la funzione append senza usare una fold e usando una fold.
   La funzione implemenata è tail-ricorsiva? Altrimenti fornire un'altra
   implementazione tail ricorsiva.

[3.](https://github.com/MisterDev/epp-homeworks/blob/master/erlang/list.erl#L14) Scrivere la funzione che, data una lista e un predicato, ritorna due
   liste contenenti rispettivamente gli elementi della lista in input che
   soddisfano il predicato e quelli che non lo soddisfano. Fornire una
   implementazione usando la fold e una senza usare la fold.
   La funzione implemenata è tail-ricorsiva? Altrimenti fornire un'altra
   implementazione tail ricorsiva.

[4.](https://github.com/MisterDev/epp-homeworks/blob/master/erlang/sbstree.erl#L22) Implementare un BST che mantenga coppie chiave-valore nei nodi.
   Scrivere la funzione che, dato un BST, ritorni il valore associato a una
   chiave nel BST se esiste e not_present altrimenti. Implementare la funzione
   due volte: la prima senza usare eccezioni, la seconda usando un'eccezione
   locale.
   
## Programmazione concorrente

[1.](https://github.com/MisterDev/epp-homeworks/blob/master/erlang/phils.erl) Risolvere il problema dei filosofi a cena evitando deadlock, starvation,
   busy waiting e facendo in modo che tutti i filosofi eseguano lo stesso
   codice (nessun filosofo mancino...)
   
[2.](https://github.com/MisterDev/epp-homeworks/blob/master/erlang/cigasp.erl) Scrivere un programma che risolva il Cigarette Smokers Problem ([wikipedia](https://en.wikipedia.org/wiki/Cigarette_smokers_problem)). La soluzione deve prevedere cinque attori: i 3 fumatori,
   l'agente che mette sul tavolo gli ingredienti e il tavolo.
   
3. Risolvere il seguente problema: si vuole implementare un attore che
   gestisce una cella di memoria soggetta a transazioni. In particolare,
   il modulo deve implementare i seguenti metodi:
   Cella = init_transaction(Value):
        il processo chiamante crea la cella di memoria, inizializzandola a
        un valore. Questa operazione inizia la transazione. La funzione
        restituisce il PID dell'attore che implementa la cella.
   commit(Cella):
        segnala che la transazione è avvenuta con successo
   abort(Cella):
        segnala che la transazione è abortita: tutti i processi che hanno
        fatto una get del valore della Cella devono essere abortiti
   get(Cella):
        un processo contatta la Cella per leggerne il valore;
        così facendo si prepara anche ad abortire la computazione nel caso
        la transazione venga abortita
   await(Cella):
        il processo si blocca in attesa che la transazione venga abortita
        o committata.
   Scrivere un test che crei due celle A e B inizializzandole a 3 e 5 nelle
   rispettive transazioni. Successivamente ognuna delle due transazioni ha una
   probabilità pari a 1/2 di essere abortita e 1/2 di essere committata dopo 5s.
   In parallelo lanciare 3 attori: il primo fa get(A), await(A) e stampa A;
   il secondo fa lo stesso con B; il terzo fa get(A), get(B), await(A),
   await(B), stampa(A+B). Verificare che il comportamento sia quello opportuno
   ogni volta.
   
   Suggerimento: sfruttare i meccanismi link/monitor di Erlang; fornire una
   seconda soluzione senza sfruttare tali meccanismi
   
4. Migliorare l'implementazione dei futures vista in Erlang gestendo anche le
   eccezioni.
