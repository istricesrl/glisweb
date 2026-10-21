# mail

L'applicazione **non spedisce le mail nel momento in cui le scrive**: le mette in una **coda in
uscita**, e un lavoro automatico che gira a intervalli regolari le preleva una alla volta e le
consegna al server di posta. Quelle consegnate passano nella **coda delle inviate**, dove restano
come registro di ciò che è partito.

Questo modulo mostra le due code e permette di intervenire: vedere cosa sta per partire, forzare un
invio, rimettere in coda una mail già spedita, svuotare le code. Le mail non si scrivono da qui: le
producono gli altri moduli ( una conferma d'ordine, un avviso, una richiesta di contatto ), di norma
a partire da un **template** — vedi il capitolo del modulo template.

Si apre dalla voce **mail**, sotto *strumenti*, ed è riservato agli **amministratori**.

## le mail in uscita
<!-- @pubblico: amministratore -->
<!-- @pagina: mail.out.view -->

È la prima linguetta, *in uscita*: una riga per ogni mail che deve ancora partire.

| colonna | contenuto |
|---|---|
| invio previsto | data e ora da cui la mail può partire; *in uscita* se può partire subito |
| destinatari | i destinatari principali |
| CC, BCC | i destinatari in copia e in copia nascosta |
| oggetto | l'oggetto della mail |

Il giro automatico prende sempre **la prima mail pronta**: quella con la priorità più alta e, a
parità, quella prevista da più tempo. Una mail con l'invio previsto nel futuro aspetta il suo turno.

Le altre linguette della sezione sono **inviate**, **template** ( se c'è il modulo dei template ) e
gli **strumenti mail**.

> **nota** — se un invio non riesce, la mail **non si perde**: resta in coda, il numero dei
> tentativi cresce di uno e l'invio viene rimandato di tante ore quanti sono i tentativi fatti —
> un'ora dopo il primo errore, due dopo il secondo, e così via. Una mail che resta a lungo in questo
> elenco con l'invio sempre spostato in avanti è il segnale di un problema col server di posta o
> con l'indirizzo. Dopo dieci tentativi falliti ( o il numero impostato sull'installazione ) la mail
> **si ferma**: resta nell'elenco ma non viene più riprovata, e il titolo della sua scheda dice
> "ferma dopo N tentativi". Quando il problema è risolto la si fa ripartire con **invia
> immediatamente la mail** dagli strumenti della scheda, che azzera i tentativi. Una mail rimasta a metà di un giro interrotto torna in coda da sola dopo un'ora
> ( o il tempo impostato sull'installazione ).

## la scheda di una mail
<!-- @pubblico: amministratore -->
<!-- @pagina: mail.out.form -->

Un clic su una riga apre la scheda, divisa in quattro riquadri:

| riquadro | campi |
|---|---|
| mittente | l'indirizzo da cui la mail parte |
| destinatari | destinatari, destinatari CC, destinatari BCC |
| contenuto della mail | l'oggetto e il corpo, in un editor che mostra il codice HTML del messaggio |
| dati di invio | la data e l'ora previste per l'invio |

Gli indirizzi si scrivono nella forma consueta, *Nome Cognome &lt;indirizzo&gt;*, separati da
virgole quando sono più d'uno.

Se c'è il modulo dei file, la linguetta **file** elenca gli **allegati** della mail. L'ultima
linguetta, **strumenti**, ha un riquadro solo:

| riquadro | cosa fa |
|---|---|
| invia immediatamente la mail | tenta subito l'invio di **questa** mail, senza aspettare il giro automatico, e porta all'elenco delle inviate; una mail ferma per troppi tentativi riparte con i tentativi azzerati |

> **attenzione** — modificare a mano una mail in coda è un intervento da fare di rado: la mail è
> stata composta da un altro modulo, e la correzione vale solo per quella copia. Se l'errore è nel
> testo, va corretto nel **template** da cui la mail è nata, altrimenti si ripresenta alla prossima.

## le mail inviate
<!-- @pubblico: amministratore -->
<!-- @pagina: mail.sent.view -->

La linguetta *inviate* ha le stesse colonne della coda in uscita, ma la data è quella in cui la mail
**è partita davvero**; *data non registrata* vuol dire che la mail è partita ma l'applicazione non
è riuscita a segnarne l'ora. È il posto dove guardare quando qualcuno dice di non aver ricevuto una
mail: se è qui, l'applicazione l'ha consegnata al server di posta, e il resto del percorso non
dipende più da lei. Se c'è il modulo dei file, la linguetta **file** della mail inviata elenca gli
allegati con cui è partita.

## rimettere in coda una mail inviata
<!-- @pubblico: amministratore -->
<!-- @pagina: mail.sent.form -->

La scheda di una mail inviata è uguale a quella di una mail in uscita. La differenza sta nella
linguetta **strumenti**:

| riquadro | cosa fa |
|---|---|
| reinvia la mail | toglie la mail dalle inviate e la **rimette nella coda in uscita**, allegati compresi, e porta all'elenco delle mail in uscita |

Serve quando una mail è partita ma non è arrivata, o è arrivata a un indirizzo che nel frattempo è
stato corretto: si corregge l'indirizzo nella scheda, si salva, e la si rimette in coda.

## gli strumenti mail
<!-- @pubblico: amministratore -->
<!-- @pagina: mail.tools -->

L'ultima linguetta della sezione raccoglie le operazioni sulle code intere. Nel gruppo
**elaborazioni**:

| riquadro | cosa fa |
|---|---|
| invia la prossima mail in uscita | spedisce subito la prima mail della coda, **anche se il suo invio era previsto più avanti** |
| elabora coda mail in uscita | rimette in circolo **tutta** la coda: rende subito inviabili tutte le mail, comprese quelle programmate e quelle rimandate dopo un errore, e libera quelle rimaste bloccate da un giro interrotto; le mail ferme per troppi tentativi restano ferme. In quel momento **non spedisce niente**: le spedisce il giro automatico dal passaggio successivo, una alla volta ( chiede conferma ) |

Nel gruppo **code**:

| riquadro | cosa fa |
|---|---|
| svuotamento coda mail inviate | cancella il registro delle mail inviate ( chiede conferma ) |
| svuotamento coda mail in uscita | cancella tutte le mail in attesa **senza spedirle** ( chiede conferma ) |

> **attenzione** — i due svuotamenti **non si disfano**. Svuotare la coda in uscita vuol dire che
> quelle mail non partiranno mai; svuotare le inviate vuol dire perdere la prova che sono partite.

## quello che questo capitolo non dice ancora

- **ogni quanto** gira l'invio automatico e quante mail spedisce a ogni giro, che dipende da come è
  configurata l'installazione;
- la **priorità** di una mail, che decide l'ordine della coda ma non si vede né si cambia dalla
  scheda;
- i **server di posta** diversi da quello predefinito, che una mail può usare e che la scheda non
  mostra;
- la linguetta **file** vista da vicino: come si aggiunge o si toglie un allegato a una mail in coda.
