# mailing

Il modulo serve a mandare una **newsletter**: lo stesso messaggio a tutte le persone iscritte a una o più
**liste**. Ogni invio si chiama *mailing*.

Le mail non partono tutte insieme: l'applicazione le prepara una alla volta e le mette nella **coda in
uscita** ( vedi il capitolo del modulo mail ), da cui partono con calma. Per una lista di qualche migliaio di
indirizzi possono servire alcune ore.

Si apre dalla voce **mailing** del menu.

## le liste
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: liste.view -->

Dalla linguetta **liste** si vedono le liste esistenti; un clic apre la scheda, dove si cambiano il nome e le
note. La linguetta **iscritti** della scheda elenca gli indirizzi iscritti alla lista.

Una lista si riempie in quattro modi:

- **a mano**, dalla linguetta *iscritti*, col pulsante di inserimento: si cerca l'indirizzo e lo si aggiunge;
- **da una categoria di anagrafica**, dagli strumenti della lista ( *popola la lista da una categoria* ): si
  iscrivono gli indirizzi di tutte le anagrafiche della categoria; chi è già iscritto resta com'è;
- **da un file**, dagli strumenti del mailing ( *importa CSV iscritti* o *importa iscritti da MailChimp* );
- **dal sito**, se il sito ha il modulo di iscrizione alla newsletter: chi si iscrive finisce da solo nelle
  liste previste.

Dalla scheda di un indirizzo mail in anagrafica, la linguetta **liste** mostra a quali liste è iscritto
l'indirizzo, e permette di aggiungerne o toglierne.

## chi riceve la newsletter
<!-- @pubblico: operatore, amministratore -->

Riceve la newsletter chi è iscritto a una delle liste del mailing, **tranne chi ha chiesto di non riceverla
più**. Nella linguetta *iscritti* della lista queste persone hanno la scritta **revocato**: restano iscritte,
ma vengono saltate.

Si smette di ricevere la newsletter in due modi:

- cliccando il link **in fondo a ogni mail**, che porta a una pagina dove si conferma la richiesta; molti
  programmi di posta mostrano anche un pulsante *annulla iscrizione* che fa la stessa cosa;
- su richiesta, dalla linguetta **privacy** della scheda anagrafica della persona, mettendo il consenso alle
  comunicazioni su *revocato*: vale per tutti i suoi indirizzi.

Togliere l'indirizzo dalle liste ( dalla linguetta *iscritti* della lista, o dalla linguetta *liste* della scheda
dell'indirizzo ) ferma i prossimi invii a quelle liste, ma l'indirizzo rientra se la lista viene ripopolata da una
categoria: per una richiesta di non ricevere più la newsletter si usa la linguetta *privacy*.

Chi si è tolto e poi si iscrive di nuovo dal sito torna a riceverla.

> **nota** — un indirizzo che compare in più liste dello stesso mailing, o in più anagrafiche, riceve la
> newsletter **una volta sola**.

## preparare e spedire un mailing
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: mailing.form -->

1. dalla linguetta **invii** si crea un nuovo mailing: si dà un nome, la **data e l'ora di invio** e si
   scelgono le **liste** a cui mandarlo;
2. nella linguetta **contenuti** si scrivono il **mittente**, l'**oggetto** e il **testo**, uno per ogni
   lingua; in alternativa, dagli strumenti, *applica un template* copia il testo da un template mail già
   pronto;
3. nella linguetta **file** si aggiungono gli eventuali allegati;
4. dagli strumenti, **invio di prova** manda la mail a un indirizzo a scelta, per vedere come arriva;
5. dagli strumenti, **prepara invio** calcola l'elenco dei destinatari, che compare nella linguetta
   **invio**. Le mail partono dalla data e ora indicate nel mailing.

Se dopo aver preparato l'invio si aggiungono iscritti alle liste, si può rilanciare *prepara invio*: si
aggiungono solo i nuovi, nessuno riceve la mail due volte.

In fondo a ogni mail viene aggiunta da sola la frase *ricevi questa mail perché sei iscritto alla nostra
newsletter; per non riceverla più clicca qui*.

## il follow-up
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: mailing.form.promemoria -->

Se c'è il modulo delle attività, la linguetta **follow-up** del mailing permette di programmare, per ogni
destinatario che ha un'anagrafica, un'attività da fare qualche giorno dopo l'invio ( per esempio una
telefonata ): si sceglie il tipo di attività, il responsabile, il titolo, quanti giorni aspettare e un testo.

## esportare una lista
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: mailing.tools -->

Dagli strumenti del mailing, **esporta iscritti di una lista** scarica un file CSV, apribile con un foglio
di calcolo, con gli iscritti alla lista. Chi ha chiesto di non ricevere più la newsletter non c'è.
