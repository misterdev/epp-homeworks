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


### Perle
- I linguaggi funzionali non possono essere comunque puri perchè ci sono interazioni i/o
- I record sono comodi
	- prevengono bug {giuseppina, 12, 7, 1998}: qual è il mese e quale il giorno?
	- estensibilità, se voglio aggiungere CF al record sopra non devo modificare tutto il codice