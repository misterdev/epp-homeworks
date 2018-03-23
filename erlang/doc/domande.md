### Why tail recursion
### How is the stack managed
### Mark & Sweep
- Divido la memoria in 2
- Ciclo sullo stack per markare le celle utilizzate
- Copio e compatto le celle markate nel nuovo heap
- Complessità per iterazione O(|heap_vivo|) 
- Complessità complessiva O(n^2)

### 15/03
- Ipotesi generazionale
- Gestione memoria GC generazionale
- Minor / Major
- Old / Young
- Minor: Puntatori Young -> Old
- Radici del grafo di visita (stack & old)
- Rappresentazione di 
- Pattern
- Pattern Matching, confronta le struttre e se positivo assegna le variabili
	- definizione di funzioni per casie
	- e nello switch
	- pattern irrefutabile

### 19/03
- Cosa sono le eccezioni, un modo per uscire da una serie di chiamate ricorsive (errore, successo es: ricerca in BST)
- Blocco finally, serve per eseguire codice (bilanciamento) sia in caso di eccezioni che no
- Il try catch annulla i benefici della ricorsione di coda, quindi non va usato in server

### 22/03
- Mobilità del codice, un attore chiama ricorsivamente se stesso su un'altra macchina con un altro pid. Per implementarlo senza problemi ci sono alcune soluzioni
	1. Si lascia un processo sulla macchina originaria che fa il farward dei messaggi
	2. Si gestisce il messaggio di "cambia il pid"
- La mobilità del codice può essere utile nel caso di bilanciamento del carico, indipendenza dall'hardware o in caso di trasferimenti dati corposi
- Tipi di uscita:
	1. Controllo di flusso che non arrivano a top level
	2. Errori (/0, no match) che arrivano a top level killando il processo
	3. Exit
		- Normal/Pid, terminazione normale
		- Non normal, i processi linkati muoiono
			1. Link, link bidirezionale all'intero set di processi linkati
			2. Monitor, link asimmetrico

### Perle
- I linguaggi funzionali non possono essere comunque puri perchè ci sono interazioni i/o
- I record sono comodi
	- prevengono bug {giuseppina, 12, 7, 1998}: qual è il mese e quale il giorno?
	- estensibilità, se voglio aggiungere CF al record sopra non devo modificare tutto il codice

