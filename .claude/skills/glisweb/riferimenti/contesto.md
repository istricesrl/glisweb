# Il contesto costa: il regolamento completo

*Riferimento della skill `glisweb`, letto **su richiesta**. Il file del framework
( `_etc/_claude/_claude.framework.md`, sezione "Il contesto costa" ) ne tiene l'essenziale, che è
caricato in ogni sessione; qui ci sono le regole per esteso e le misure che le motivano. Scritto il
24/09/2026 raccogliendo le regole che Fabio aveva dato a tutti i suoi Claude, perché valgano per
**ogni** Claude che lavora su un deploy glisweb, anche dove il `CLAUDE.md` globale non le porta.*

## Perché: il costo cresce col quadrato

Ogni richiesta rilegge **tutto** il contesto accumulato fino a quel punto: il costo di una sessione
non cresce col lavoro che ci si fa dentro, cresce **col quadrato della sua lunghezza**. Un file letto
al decimo turno di una sessione da cinquecento lo si ripaga quattrocentonovanta volte. Quattro ore in
una sessione sola costano molto più di quattro sessioni da un'ora, e con sessioni lunghe i crediti
finiscono a metà giornata.

Misure di Fabio, settembre 2026: una giornata vera da 210 chiamate ha letto **31 milioni di token per
166 mila scritti**, 188 a 1; su otto giorni e 7.363 chiamate, **il 44,8% delle chiamate stava sopra i
200k di contesto** e il 26% sopra i 300k. Su un modello con finestra da 1M l'autocompact non scatta da
solo: in quegli otto giorni zero volte.

## I file di istruzioni: il preambolo che si paga a ogni chiamata

Claude Code carica a ogni sessione il `CLAUDE.md` globale ( `~/.claude/CLAUDE.md` ), il `CLAUDE.md`
del progetto e i file che quest'ultimo importa con `@` — su glisweb `_etc/_claude/_claude.framework.md`.
Sopra i **150k caratteri** complessivi avvisa:

    3 instruction files add up to 189.2k chars, over the 150.0k-char total limit

È successo su bernispa il 24/09/2026: 99k di `CLAUDE.md` di progetto, 72k di file del framework, 17k
di globale. Rimedio applicato, ed è il modello da seguire:

- **il `CLAUDE.md` di progetto tiene regole e trappole, non trattazioni.** Le sezioni di dominio
  ( come funzionano i prezzi, il travaso dei dati, le etichette, la logistica ) sono **fatti**: vanno in
  `<progetto>/var/personalizzazioni/<area>.md`, un file per area, rimandate dalla voce 4 del `READ.md`
  ( *mappa delle personalizzazioni* ). Nel `CLAUDE.md` resta una tabella di rimando e, per ogni area,
  le poche trappole che fanno danno se non si sanno in anticipo, una riga ciascuna. Su bernispa: da 99k
  a 26k senza perdere una riga, perché i file sotto `var/` sono copie integrali;
- **il `CLAUDE.md` di progetto non ripete il framework né la skill**: le regole dei cinque file, del
  contesto, della chiusura valgono per tutti e stanno qui. Una copia di progetto diverge in silenzio;
- **il file del framework tiene l'essenziale**, e le trattazioni lunghe ( job, documentazione, cinque
  file, migrazioni ) stanno nei `riferimenti/` di questa skill, lette quando servono;
- **un blocco generato non si modifica a mano** ( per esempio il blocco `non-sprecare-contesto` del
  `CLAUDE.md` globale, che viene da `diffondi-server.sh` ): si corregge alla fonte.

Budget orientativo: **globale sotto 15k, framework sotto 45k, `CLAUDE.md` di progetto sotto 30k**. Una
sezione datata del `CLAUDE.md` di progetto che supera i 2k caratteri è quasi sempre trattazione.
Misurare costa una riga:

```bash
wc -c ~/.claude/CLAUDE.md CLAUDE.md dev/_etc/_claude/_claude.framework.md
awk '/^#+ /{if(t)printf "%6d %s\n",n,t; t=$0; n=0} {n+=length($0)+1} END{printf "%6d %s\n",n,t}' CLAUDE.md | sort -rn | head
```

⚠ Il preambolo, però, **non è il posto principale dove si risparmia**: misurato su 51 sessioni vale
circa 65k token di mediana, quasi tutti a tariffa di cache, meno di un terzo di una chiamata tipica. Il
resto è conversazione accumulata. **Si risparmia soprattutto facendo meno chiamate e sessioni più
corte**; i file snelli servono a non partire già pesanti e a non superare il limite.

## Un turno vale il contesto intero, anche per un `ls`

1. **I comandi indipendenti vanno in una chiamata sola**, separati da `;` o in un heredoc, con le
   intestazioni a dividere l'output. Vale anche per le letture: un comando che stampa tre file, non tre
   comandi.
2. **Quando i passi dipendono l'uno dall'altro ma la logica è meccanica, si scrive uno script** — un
   heredoc `python3 - <<'EOF'` o `bash` — che fa tutto il giro e stampa **il risultato, non i dati
   grezzi**. Cercare in venti file, confrontare due versioni, spostare sezioni da un file all'altro: è
   **una** chiamata, non cinque.
3. **Uno script che serve più di una volta non resta un heredoc**: va in `.claude/bin/` con un nome.

⚠ **Il limite, ed è onesto**: non si scrive uno script quando bisogna **guardare** un risultato per
decidere il passo successivo. Le verifiche non si saltano: si impacchettano.

## Leggere stretto

- `grep`, `sed -n '100,140p'`, `head` al posto del `cat` di un file grosso; `--short`, `--stat`,
  `| head` sull'output prolisso;
- **non si rilegge un file appena scritto** per verificare: se la scrittura fosse fallita si sarebbe
  visto un errore;
- **il `TODO.md` non si apre con `cat`**: si usa `~/.claude/bin/todo.py` ( una riga per voce; `-v <riga>`
  apre una voce sola con le sue note ). Il `DONE.md` si consulta con `grep`. Il `READ.md` e i file
  sotto `var/personalizzazioni/` si leggono **per sezione** ( `grep -n '^#'` e poi `sed -n` ), quella
  che serve.

## Il ramo si scrive, non si segue

*"Ogni cosa che i claude finiscono ne apre altre"* ( Fabio, 22/09/2026 ): è il vero moltiplicatore di
costo, perché un ramo seguito non costa il ramo, costa il contesto intero per tutti i turni che vengono
dopo. Quando dentro un lavoro spunta una cosa nuova che non fa parte della richiesta e non la blocca,
**va nel `TODO.md`** e in conversazione resta una riga sola, `annotato: <cosa>` — senza spiegarla e
senza proporre di farla. Si apre subito **solo se** blocca il lavoro in corso, scade oggi, o lo chiede
Fabio. A fine lavoro, due blocchi separati: cos'è chiuso e dove sta scritto, poi i rami **come
conteggio**. Il triage dei rami non si fa nella sessione che li ha generati.

## Il punto fermo lo dichiara Claude

*"Tutti i claude con cui interagisco mi rendono DIFFICILE fare clear"* ( Fabio, 15/09/2026 ).

⚠ **Dal 03/10/2026 "puoi fare `/clear`" è una garanzia, non un'impressione**: si dice solo se un
Claude nuovo può riprendere il lavoro **senza perdere dati né contesto**. Fabio deve poter azzerare
spesso senza incasinarsi. Prima di dirlo si controllano quattro cose; se ne manca una il `/clear` non
si propone: si dice cosa manca **e lo si sistema**, senza ripassarlo all'utente.

1. **niente in sospeso sul sistema**: commit fatti e pushati, nessun agente o processo in background
   che stia ancora lavorando, e ⚠ **niente da caricare in PROD** — un lavoro fatto in DEV e non
   caricato **non è un fronte chiuso**. Fabio, 02/10/2026: *"NON MI PROPORRE IL CLEAR SE C'È DA
   CARICARE SU PROD"*. Il `/clear` butterebbe via proprio il contesto che serve per caricare: quali
   file, quali righe di DB, con quali id su DEV. Il carico si prepara e si propone **nella stessa
   risposta**, il `/clear` viene dopo. Vale lo stesso per ogni passo ancora in mano nostra ( la
   notifica a chi ha chiesto la cosa, un collaudo ). ⚠ **Su `glisweb` e `glisdev` il commit va fatto
   su tutti e due**: l'hard link porta il contenuto ma non lo stato git, e una modifica fatta da una
   parte resta `M` dall'altra senza che nessuno la veda. Il fronte è chiuso solo quando tutti e due
   sono puliti e pushati e `sync-glisweb.sh` non elenca file non sincronizzati ( il 03/10/2026 un
   `/clear` è stato proposto con glisdev indietro di due commit );
2. **tutto ciò che resta aperto sta nel `TODO.md`**, coi tre flag di urgenza, rilevanza e impatto —
   **compreso il lavoro in più** fatto di propria iniziativa: migliorie, osservazioni, rischi,
   sviluppi consigliati. Farlo va bene, ma **si segnala in una riga e nello stesso turno si scrive nel
   `TODO.md`**: non si chiede "lo metto nel todo?", si mette. Quello che va detto o chiesto al cliente
   va nel `CHAT.md`;
3. **il lavoro grosso a metà ha un file che tiene il filo** — la voce del `TODO.md`, o una trattazione
   in `var/personalizzazioni/<area>.md` rimandata dal `READ.md` — con dove siamo, il prossimo passo
   preciso, le decisioni prese e perché, cosa si è provato e scartato. Deve bastare a un Claude nuovo
   per ripartire **senza fare domande**;
4. **niente vive solo in conversazione**: una decisione presa a voce va nei file di progetto, una
   domanda all'utente ancora senza risposta va nel `TODO.md`.

⚠ **Alla domanda "posso chiudere?" il primo gesto è `chiusura.py`**, dalla root del deploy:

    python3 dev/.claude/skills/glisweb/bin/chiusura.py          # --no-fetch per saltare il fetch

Raccoglie in un giro solo i fatti che stanno sul disco: git di `dev/` ( su glisweb e glisdev tutti e due,
più `sync-check.sh` ), quello che c'è da caricare fra `dev/` e `stable/` ( `rsync` di prova con gli
`--exclude` del `DEPLOY.md` ), i file standard toccati dopo l'ultimo aggiornamento ( stanotte diventano
disallineamenti ), i cinque file toccati oggi e il lock del `CHAT.md`, file `root:root` e copie di appoggio
nella document root, processi e tunnel ancora vivi, credenziali in chiaro nelle scratchpad, cron a data
fissa, codice HTTP del sito. Stampa ✗ bloccante, ⚠ da guardare, ✓ a posto. **Ogni ✗ si sistema o si dice
perché è voluto, ogni ⚠ si giudica**, e nella risposta vanno i numeri, non "è tutto a posto". Le quattro
verifiche qui sopra che sono di giudizio — l'aperto nel `TODO.md`, il filo, le decisioni prese in
conversazione, i carichi che non sono file ( righe di DB ) — restano a Claude: lo script le ricorda in
fondo, non le fa.

Vale **soprattutto dopo un `/clear`**: lo stato del disco non dipende dalla memoria della sessione. Il
06/10/2026 tre sessioni appena azzerate hanno risposto *"posso confermare solo lo stato git"*, e intanto
polmasi aveva 3 file di progetto da caricare in PROD e bernispa 6 file standard modificati a mano.

**La convergenza è un obiettivo di ogni turno, non un controllo finale**: ogni cosa che si apre si
deposita subito, così la sessione resta sempre a un passo dal `/clear`. La riga di chiusura è una delle
due:

- `clear sicuro: commit ok, PROD allineata, 3 voci nel TODO (1 urgente), filo in <file> — /clear`
- `clear non ancora: manca <cosa>, lo sistemo`

Il resto:

- **cosa si è chiuso e cosa viene dopo stanno separati**: il secondo blocco quasi sempre può aspettare;
- **una domanda in fondo va bene solo se è già anche nel `TODO.md`**, ed è **pesata** — urgenza,
  rilevanza ( chi l'aspetta ), impatto ( cosa si blocca ): *"vuoi che faccia X?"* da sola obbliga a
  restare lì;
- **è un obbligo, non una cortesia**: *"voglio SEMPRE essere avvisato quando posso fare /clear e quando
  devo fare /compact"* ( Fabio, 23/09/2026 ), e vale su ogni deploy;
- **fronte chiuso**: quando il lavoro appena finito passa i quattro controlli e quello che viene dopo
  non c'entra, **si propone il `/clear` di propria iniziativa**, nella stessa risposta che chiude il
  lavoro, a qualunque livello di contesto. Non si aspetta che sia l'utente a chiedere "posso fare
  clear?": il 23/09/2026 è successo esattamente questo, ed è il caso che la regola voleva evitare;
  quando cambia argomento si propone la pausa;
- **soglie**: sopra **120k** di contesto ( la statusline stampa `ctx <n>k` ) si **può** chiudere — se il
  fronte è finito si propone `/clear`, se è a metà si tira avanti tenendo d'occhio la statusline; sopra
  **180k** si **deve** intervenire e si dice quale dei due — `/clear` se il fronte è chiuso, `/compact`
  se è a metà e va portato a termine. Non si arriva a 250k sperando che finisca prima;
- **dopo screenshot o dump voluminosi**, e prima di cambiare progetto, è il momento buono per un
  `/clear`: un'immagine resta nel contesto e si ripaga a ogni turno;
- ⚠ **prima di proporlo, il punto va scritto dove va** ( `TODO.md`, `CHAT.md`, `DONE.md`, il commit ):
  azzerare senza aver scritto è l'unico modo di perdere qualcosa;
- ⚠ **chi decide è l'utente, ma la domanda si pone con la diagnosi**: non si gira il messaggio grezzo
  dell'hook, si dice *"siamo a 210k, questo fronte è chiuso — `/clear`"* oppure *"siamo a 210k e siamo
  a metà di X — `/compact` e proseguiamo"*. Quando l'hook `Stop` segnala la soglia, il messaggio va
  riportato in chiaro, non ignorato perché si sta finendo qualcosa.

## Browser, immagini, agenti

- **Sul browser il testo viene prima**: `get_page_text` o `read_page`, e lo screenshot solo se serve
  **vedere**, se il testo non c'è, o per cliccare a coordinate. Misurato: 49k caratteri a chiamata per
  gli screenshot contro 3,3k per il testo. Uno screenshot resta nel contesto fino alla fine della
  sessione: dopo averlo usato è un buon momento per il `/clear`;
- **gli agenti non ereditano le regole**: nel prompt di un agente che tocca il browser si ripete *"niente
  screenshot a prescindere: prima il testo"*;
- **`model` negli agenti non si omette mai**: un agente senza modello gira sul modello più caro. Gli
  agenti che **raccolgono** vanno su `sonnet`: raccogliere non è giudicare.

Niente di tutto questo giustifica lavorare peggio: non si salta un controllo che serve, non si tirano a
indovinare contenuti invece di leggerli, non si lascia un lavoro a metà per risparmiare. Si fa **lo
stesso lavoro, impacchettato meglio**.
