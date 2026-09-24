# anagrafica

> **nota** — primo impianto del 2026-09-20, ricavato dalla pagina *anagrafica* della wiki GitHub di
> `istricesrl/glisdev` ( ferma al 12/12/2025, archiviata in `var/20260916-wiki-github/glisdev/` ) e
> riverificato contro le maschere di oggi, che nel frattempo hanno più campi e più schede di quante
> la wiki ne descrivesse.

L'anagrafica è l'elenco delle **persone e delle organizzazioni** con cui si ha a che fare: clienti,
fornitori, collaboratori, produttori. È il modulo su cui si appoggiano quasi tutti gli altri, perché
un documento, un ordine o una spedizione hanno sempre qualcuno da una parte e qualcuno dall'altra.

Una persona **non si registra due volte** perché cambia il rapporto che ha con noi: la stessa
anagrafica può essere insieme cliente e fornitore, e ognuno di quei ruoli è una scheda in più sullo
stesso contatto.

## l'elenco delle anagrafiche
<!-- @pubblico: operatore, amministratore -->

È la maschera da cui si parte, e mostra una riga per contatto:

| colonna | contenuto |
|---|---|
| codice | il codice del contatto |
| contatto | nome e cognome, oppure la denominazione |
| telefoni | i recapiti telefonici |
| mail | gli indirizzi di posta |
| categorie | le categorie a cui il contatto appartiene |
| azioni | le icone delle azioni rapide |

L'elenco si ordina per contatto e si filtra con la ricerca in alto; un clic su una riga apre la
scheda. Come tutti gli elenchi si può scaricare in un foglio di calcolo, coi filtri che si stanno
usando.

> **nota** — le anagrafiche **archiviate non compaiono qui**: stanno nella linguetta *archiviate*,
> che è lo stesso elenco visto dall'altra parte.

Le altre linguette dell'area sono **categorie** ( i gruppi in cui si classificano i contatti ),
**ranking** ( la scala con cui si valutano clienti, fornitori e produttori ), **stampe** e
**azioni**.

## la scheda di un contatto
<!-- @pubblico: operatore, amministratore -->

La prima linguetta, *gestione*, tiene i dati che valgono per chiunque:

| campo | contenuto |
|---|---|
| sigla | il tipo di contatto, ed è la scelta che decide se è una **persona fisica** o una **organizzazione** |
| codice | il codice del contatto, univoco |
| nome, cognome, sesso | solo per le persone fisiche |
| denominazione | solo per le organizzazioni |
| soprannome | il modo in cui il contatto viene chiamato correntemente |
| note | annotazioni libere |

> **attenzione** — la **sigla si sceglie per prima**: da lei dipendono i campi che la scheda mostra e
> le linguette che compaiono.

Sotto i dati generali stanno i **sotto-elenchi**, uno per ogni cosa di cui può essercene più di una.
Si aggiunge una riga col più accanto al titolo del riquadro, e la si toglie col cestino della riga;
tutto diventa definitivo al salvataggio della scheda.

| sotto-elenco | cosa si compila |
|---|---|
| e-mail | indirizzo, se è una PEC, note |
| telefoni | numero, tipo ( fisso, cellulare, fax… ), note |
| URL | indirizzo del sito, tipologia, note |
| indirizzi | ruolo ( sede, spedizione, fatturazione… ), tipologia, via, civico, interno, località, CAP, comune |
| categorie | le categorie del contatto, una per riga |

## le schede dei ruoli
<!-- @pubblico: operatore, amministratore -->

Sono le linguette che si compilano **solo se quel rapporto c'è**. Tengono i dati che hanno senso per
quel ruolo e non per gli altri, ed è il motivo per cui la scheda generale resta corta:

| linguetta | cosa ci sta |
|---|---|
| cliente | ranking, agente, note commerciali; responsabile operativo, condizioni di vendita, note amministrative; codice fiscale, partita IVA, regime fiscale; codice destinatario SDI e PEC per la fatturazione elettronica; IBAN e settori ATECO |
| fornitore | ranking, condizioni di fornitura, codice fiscale e partita IVA, IBAN |
| produttore | ranking, condizioni di fornitura, codice fiscale e partita IVA, IBAN |
| collaboratore | note di collaborazione, codice fiscale e partita IVA, IBAN |
| relazioni | i legami con altri contatti: anagrafica principale, tipo di relazione, anagrafica collegata |
| privacy | l'elenco dei **consensi** raccolti: quale consenso, da che modulo è arrivato, che valore ha e quando |
| archiviazione | la data di archiviazione e le note che la spiegano |
| stampe | i documenti che si possono stampare per questo contatto |
| azioni | le operazioni disponibili sul contatto |

Se l'installazione ha i moduli che le gestiscono, compaiono anche le linguette delle **immagini**,
dei **video**, dei **file** allegati e dei **metadati**. Dove il modulo non c'è, la linguetta non
c'è: non è un permesso che manca.

## archiviare invece di cancellare
<!-- @pubblico: operatore, amministratore -->

Un contatto che non serve più **si archivia**, compilando la data nella linguetta *archiviazione*.
Da quel momento esce dall'elenco ordinario e si trova in *archiviate*, ma tutto ciò a cui era legato
— documenti, ordini, storico — resta leggibile.

La cancellazione vera esiste, ma serve per le righe sbagliate appena inserite: un contatto con dei
documenti dietro non si può cancellare, e l'applicazione lo rifiuta.

## l'archivio dell'anagrafica
<!-- @pubblico: amministratore -->

La voce di menu **archivio** raccoglie gli elenchi trasversali: tutti i telefoni, tutte le e-mail,
tutti gli URL, tutti gli IBAN, tutti gli indirizzi registrati, più le **tipologie di anagrafica** e i
**ruoli** che si possono usare nelle schede.

Servono a due cose: cercare un recapito quando non si sa a chi appartiene, e tenere in ordine le
tendine che compaiono nelle schede. Toccare una tipologia o un ruolo cambia ciò che vedono **tutti**,
quindi è un lavoro da fare di rado e con un motivo.

## quello che questo capitolo non dice ancora

- le **azioni rapide** della colonna *azioni* dell'elenco, una per una;
- cosa fanno esattamente le linguette **stampe** e **azioni**, che dipendono dalle stampe configurate
  sull'installazione;
- l'**account** collegato a un'anagrafica: chi entra nell'applicazione e con quali permessi è materia
  del modulo account, e va detto dove i due si incontrano;
- le **categorie** e il **ranking** visti dal lato di chi li imposta: a cosa servono nelle ricerche e
  nei listini.
