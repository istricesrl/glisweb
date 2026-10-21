# La pulizia delle todo: triage di un `TODO.md`

*Riferimento della skill `glisweb`, letto **su richiesta**: quando l'utente chiede di "pulire le todo",
"fare il triage del TODO", "vedere cosa è già chiuso", o quando un `TODO.md` è cresciuto tanto che
nessuno sa più cosa c'è dentro. Scritto il 12/10/2026 dopo la prima pulizia completa di polmasi
( 1272 righe, circa 400 voci aperte ), per volontà di Fabio: "è importante tenere pulite le liste e
tutti i claude che lavorano su glisweb dovrebbero saperlo fare in maniera efficiente". Le regole dei
marcatori, dei flag e del lock stanno in `cinque-file.md`: qui non si ripetono.*

## Perché serve, e perché si sbaglia

Un `TODO.md` che non si pota smette di essere una lista di cose da fare e diventa un archivio: voci
chiuse da settimane e mai traslocate, la stessa segnalazione scritta tre volte da tre sessioni, domande
al cliente che stanno solo nella testa di chi le ha pensate. Il carico misurato è falso, `todo.py -u`
mostra urgenze che non esistono, e ogni sessione paga a ogni turno righe che non servono.

Ma la pulizia è anche il posto dove si perde lavoro: una voce chiusa "perché sembra fatta" sparisce dal
TODO e nessuno la riapre. Per questo la procedura è costruita in modo che **nel dubbio la voce resti
aperta**, e che ogni chiusura abbia una prova scritta.

## I tre esiti, più uno

Ogni voce aperta ( `[ ]` ) finisce in uno di questi:

| esito | cosa vuol dire | cosa si fa |
|---|---|---|
| **già chiusa** | il lavoro è fatto e c'è la **prova**: una riga del `DONE.md`, del `CHAT.md`, il codice, il dato | `chiudi` ( `[v]` ) o `scarta` ( `[x]`, superata o non più vera ), con la prova nella nota |
| **serve una domanda** | non si chiude senza una risposta del cliente | se la domanda è **già stata mandata**: `[=]` con chi e da quando; se **non ancora**: la domanda va nel `CHAT.md` e la voce prende la nota che lo dice |
| **chiudibile in autonomia** | si può fare senza chiedere a nessuno | resta `[ ]`: è lavoro, non pulizia, e si fa in un'altra sessione |
| **doppione** | è la stessa cosa di un'altra voce | si uniscono, **solo dopo averle confrontate** ( vedi sotto ) |

⚠ **Una voce bloccata da una domanda non ancora fatta non ha un marcatore suo, e non deve averlo**:
`[=]` vuol dire "la palla è di un altro", e finché la domanda non è partita la palla è nostra. La voce
resta `[ ]` con la nota `-- domanda in CHAT.md › Da chiederle (GG/MM)`, e la domanda sta nel `CHAT.md`
in `### Da chiedergli alla prossima occasione` della persona giusta. Quando la domanda parte, la voce
passa a `[=]`.

## La procedura

**1. Elenco.** `todo.py` ( una riga per voce, col numero di riga del file ), salvato in un file della
scratchpad. Mai `cat` del `TODO.md`. Si fotografa anche `wc -l` e l'ora: servono a capire, dopo, se
qualcun altro ha scritto nel frattempo.

**2. Primo giro, a blocchi, con agenti.** Le voci si dividono in blocchi da 80-100 e ogni blocco va a
un agente **`model: "sonnet"`, in sola lettura**, che scrive un **TSV** nella scratchpad
( `riga \t esito \t prova o motivo` ) e restituisce solo i conteggi. Gli agenti leggono la voce con
`todo.py -v N`, cercano nel `DONE.md` e nel `CHAT.md` con `grep`, guardano codice e dati quando serve.
Nel prompt: le credenziali del DB stanno in `dev/src/shadow.json`, niente query pesanti in produzione,
niente scritture, nel dubbio l'esito è "resta aperta".

**3. Riverifica delle chiusure, con prova concreta.** Il primo giro è generoso: su polmasi un quarto
delle voci date per chiuse non lo era. Le candidate alla chiusura vanno a un **secondo** giro di
agenti, che deve trovare la prova **che copre tutta la voce** ( non una parte, non solo dev se la voce
dice anche stable ) e rispondere `CONFERMATA`, `SCARTATA` o `NO`. Solo `CONFERMATA` e `SCARTATA` si
applicano; `NO` resta aperta. Diffidare delle note generiche ( "prova nel DONE.md" senza riga ): una
nota che non dice dove sta la prova non è una prova, e nel `DONE.md` finisce così.

**4. Doppioni, uno a uno.** Il primo giro trova gruppi di voci simili; **simili non vuol dire uguali**.
Ogni gruppo si confronta voce per voce e prende uno di tre verdetti:

- `STESSO` — è lo stesso problema: si tiene la voce più completa ( la "superstite" ), ci si travasano i
  fatti che stanno solo nell'altra ( numeri, casi, vincoli ), e l'altra si scarta con la nota
  `doppione di <testo della superstite>`;
- `PARZIALE` — si sovrappongono ma una ha un pezzo in più: non si uniscono;
- `DIVERSI` — si somigliano solo nelle parole: non si toccano.

Su polmasi, di diciannove gruppi segnalati dal primo giro, solo sette erano `STESSO`.

**5. Le domande.** Per le voci "serve una domanda":

- si controlla se la domanda **è già partita**: `grep` nel `CHAT.md` ( sezioni *Aspetta lui/lei*, le
  `[x]` con `✅ MANDATO` ) e nel `DONE.md`. Se sì, la voce passa a `[=]` con
  `-- **Nome, dal GG/MM** — domanda N del GG/MM HH:MM: …, CHAT Aspetta lei`. Se la domanda è stata solo
  **scritta** e non mandata, non è partita;
- se non è partita, la si scrive nel `CHAT.md` con `voce-progetto.py <dominio> chat-aggiungi
  "Nome/Da chiederle alla prossima occasione" "( dalla TODO N ) contesto — **DA MANDARE**\n  > testo"`:
  il contesto per chi la manderà, il testo **pronto da incollare**, nel registro del cliente ( niente
  nomi di tabelle, niente gergo ). Se la domanda dice "ti mando…", quello che si manda va scritto lì;
- **una domanda per problema**: più voci che aspettano la stessa risposta prendono una domanda sola, e
  le altre la nota che rimanda a quella;
- **la persona giusta**: segreteria e direzione non si scambiano; una cosa che è "palla nostra" non
  diventa una domanda al cliente.

**6. Il report.** Prima di scrivere nel `TODO.md`, i risultati vanno in
`<progetto>/var/AAAAMMGG-triage-todo/triage.md` ( conteggi per esito e per area, l'elenco delle voci
con l'esito e la prova ): è quello che si mostra all'utente per avere il via, ed è la traccia di cosa è
stato chiuso e perché.

**7. L'applicazione, con `bin/applica-triage.py`.** Mai a mano: ogni chiusura toglie righe e sposta
tutte quelle sotto. Si costruisce un TSV `riga \t azione \t atteso \t nota`, con `atteso` preso **dal
`TODO.md` del momento** ( 30-40 caratteri dopo i flag ), e:

```bash
applica-triage.py verdetti.tsv              # prova a secco: controlla che ogni riga sia ancora la voce attesa
applica-triage.py verdetti.tsv --applica    # applica in ordine decrescente, ricontrollando riga per riga
```

Lo script è **tutto o niente** sul controllo: se una sola riga non torna, non scrive niente. Le
chiusure passano da `voce-progetto.py` ( trasloco nel `DONE.md`, promemoria degli avvisi ). Un verdetto
per riga: quando una voce ne ha due ( p.es. `[=]` e il travaso di un doppione ), o si fondono in una
nota sola, o si fanno **due passi**, ricalcolando i numeri di riga dal testo prima del secondo. Conviene
fare prima il passo che **aggiunge** note ( travasi, `[=]`, note delle domande ) e poi quello che
**toglie** voci ( chiusure, scarti, doppioni ), così le superstiti hanno già i fatti travasati quando
la gemella sparisce.

**8. La chiusura.** Se fra le chiuse c'è qualcosa che il cliente aspettava, il terzo gesto
( `### Da dirgli alla prossima occasione` ) vale anche qui. In conversazione restano i **conteggi**:
quante chiuse, quante scartate, quante in attesa, quante domande scritte, quanti doppioni uniti, quante
rimaste aperte. Non l'elenco: l'elenco sta nel report.

## Quello che la pulizia non è

- **Non è il momento di fare le voci "chiudibili in autonomia".** La pulizia dice cosa c'è da fare; il
  lavoro si fa dopo, in sessioni sue. Mettersi a sistemare una voce durante il triage è il modo sicuro
  di non finire né l'una né l'altro.
- **Non si riscrive il `TODO.md` intero**, mai: si tocca riga per riga, ancorati al testo, perché altre
  sessioni scrivono nello stesso file.
- **Non si cambia la priorità delle voci** per farle tornare: i flag li mette chi conosce il lavoro.
- Il triage dei rami di una sessione **non si fa nella sessione che li ha generati** ( vedi
  `contesto.md` ): la pulizia è una sessione a sé.
