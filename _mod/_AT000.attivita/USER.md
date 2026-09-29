# attività

Un'**attività** è un pezzo di lavoro registrato: una telefonata, un intervento, una giornata su un
progetto, un promemoria per qualcosa da fare. Ogni attività può avere due facce, e la scheda le tiene
separate:

- la **programmazione**, cioè quello che si prevede di fare — quando, per quante ore, a chi tocca;
- l'**esecuzione**, cioè quello che si è fatto davvero — quando, per quante ore, chi l'ha fatto.

Un'attività può nascere come promemoria e diventare lavoro svolto compilando più tardi la parte
dell'esecuzione, oppure essere registrata direttamente come già fatta. In tutti e due i casi resta
**una riga sola**, e la differenza fra previsto e fatto si legge sulla stessa scheda.

Nel menu la voce **attività** sta nell'area *produzione*.

## l'elenco delle attività
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: produzione.attivita.view -->

Mostra le attività non archiviate, le più recenti in cima:

| colonna | contenuto |
|---|---|
| codice | il codice dell'attività, se ne ha uno |
| tipologia | il tipo di attività |
| data | la data dell'attività |
| inizio, fine | l'orario |
| riferimento | la persona a cui l'attività fa capo |
| cliente | il contatto per cui l'attività è stata svolta |
| attività | il nome dell'attività |
| ore | le ore registrate |

Le linguette dell'area sono:

| linguetta | cosa ci sta |
|---|---|
| attività | l'elenco qui sopra |
| tipologie | i tipi di attività che si possono scegliere nelle schede |
| stampe | i documenti stampabili dall'elenco, se l'installazione ne ha configurati |
| archiviate | le attività archiviate, con le stesse colonne |
| azioni | le operazioni sull'insieme delle attività, descritte più sotto |

## la scheda di un'attività
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: produzione.attivita.form -->

La linguetta *gestione* è divisa in quattro riquadri.

| riquadro | campi |
|---|---|
| dati generali | tipologia, codice, nome |
| programmazione | data, ora di inizio e di fine, ore previste, **incaricato**, note |
| esecuzione | data, ora di inizio e di fine, ore, **esecutore**, note |
| attribuzione | il **cliente** per cui si lavora |

Incaricato, esecutore e cliente sono contatti dell'anagrafica e si cercano scrivendone il nome.
L'incaricato è chi **dovrebbe** fare l'attività, l'esecutore chi l'ha **fatta**: spesso sono la
stessa persona, ma tenerli distinti permette di vedere i passaggi di mano.

> **esempio** — un intervento fissato per giovedì dalle 9 alle 11 si registra compilando la sola
> programmazione, con l'incaricato. Giovedì sera chi l'ha svolto apre la stessa scheda e compila
> l'esecuzione con le ore effettive: non si crea una seconda attività.

Le altre linguette sono **archiviazione** ( data e note che spiegano perché l'attività esce dagli
elenchi ) e **azioni**, che contiene il riquadro per ricalcolare i dati di riepilogo di questa sola
attività. Se l'installazione gestisce le pianificazioni, compare anche la linguetta
**pianificazioni**, per le attività che si ripetono.

## le tipologie
<!-- @pubblico: amministratore -->
<!-- @pagina: produzione.tipologie.attivita.view -->

La linguetta **tipologie** elenca i tipi di attività in ordine alfabetico. La scheda di una
tipologia ha un **nome** e, facoltativo, un **genitore**, per raggruppare le tipologie a più livelli
( per esempio *assistenza* con sotto *telefonica* e *in sede* ).

Toccare le tipologie cambia la tendina che tutti vedono nelle schede delle attività: si fa di rado e
con un motivo.

## le attività dalla scheda di un contatto
<!-- @pubblico: operatore, amministratore -->

Con questo modulo la scheda di un contatto in anagrafica si arricchisce di due linguette, che
guardano le attività da due lati diversi:

| linguetta | cosa elenca | inserimenti rapidi |
|---|---|---|
| attività | le attività svolte **per** quel contatto, cioè quelle in cui è il cliente | *attività svolta* ( data, tipologia, ore, nome, descrizione ) e *promemoria* ( data e orario previsti, tipologia, per chi è programmata, nome, descrizione ) |
| lavoro | le attività che quel contatto ha **svolto o deve svolgere**, come esecutore o come incaricato | *attività svolta* e *promemoria*, indicando il cliente su cui si è lavorato o si lavorerà |

Gli inserimenti rapidi aprono un riquadro sopra l'elenco e registrano l'attività senza lasciare la
scheda del contatto: la data è già impostata a oggi, e il contatto da cui si parte è già collegato.

Il clic su una riga delle due linguette apre la **scheda dell'attività**, la stessa che si apre
dall'elenco dell'area *produzione* e descritta più sopra; il pulsante per tornare indietro riporta
alla scheda del contatto.

## archiviare le attività
<!-- @pubblico: amministratore -->
<!-- @pagina: produzione.attivita.tools -->

Le attività si accumulano in fretta, e dopo qualche mese l'elenco è fatto soprattutto di cose chiuse.
Si possono archiviare una per una, dalla linguetta *archiviazione* della scheda, oppure a blocchi
dalla linguetta **azioni** dell'elenco:

| riquadro | cosa fa |
|---|---|
| archivia attività | chiede una data di inizio e una di fine e archivia tutte le attività di quel periodo |
| ripopola attività | ricalcola i dati di riepilogo di tutte le attività; serve quando l'elenco mostra valori che non corrispondono alle schede |

Per l'archiviazione a blocchi conta la **data programmata** o, se manca, quella di esecuzione. Le
attività archiviate escono dall'elenco ordinario e restano leggibili nella linguetta *archiviate*.

> **attenzione** — l'archiviazione a blocchi è riservata a chi ha un permesso specifico: se il
> riquadro risponde con un rifiuto, va chiesto a chi amministra l'installazione.

## quello che questo capitolo non dice ancora

- le **stampe** delle attività, che dipendono da quelle configurate sull'installazione;
- come le attività si legano ai **progetti**, ai **contratti** e alle **pianificazioni**, quando
  quei moduli sono attivi;
- come si leggono le **ore** registrate in un riepilogo per cliente o per persona.
