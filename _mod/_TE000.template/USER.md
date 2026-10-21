# template di mail e SMS

Un **template** è il modello di un messaggio che l'applicazione manda da sola: la conferma di una
registrazione, l'avviso di un ordine, la risposta a una richiesta di contatto. Il template tiene il
testo con dei segnaposto, e al momento dell'invio l'applicazione ci mette dentro i dati veri — il
nome del destinatario, il numero dell'ordine — e mette il messaggio pronto nella coda delle mail o
degli SMS.

Correggere un template, quindi, **cambia tutti i messaggi che partiranno da lì in avanti**, e non
tocca quelli già in coda o già spediti.

Il modulo non ha una voce di menu propria: aggiunge la linguetta **template** alle sezioni *mail* e
*sms*, sotto *strumenti*. È riservato agli **amministratori**.

## i template mail
<!-- @pubblico: amministratore -->
<!-- @pagina: mail.template.view -->

L'elenco mostra una riga per template, ordinata per ruolo:

| colonna | contenuto |
|---|---|
| nome | il nome descrittivo del template |
| ruolo | il nome con cui l'applicazione lo cerca quando deve mandare quel messaggio |

Un clic su una riga apre la scheda, il più ne apre una nuova.

## la scheda di un template mail
<!-- @pubblico: amministratore -->
<!-- @pagina: mail.template.form -->

La linguetta *gestione* tiene i **dati generali**:

| campo | contenuto |
|---|---|
| nome | il nome descrittivo, per chi legge l'elenco |
| ruolo | il nome con cui l'applicazione cerca il template: deve essere **esattamente** quello che il modulo che manda il messaggio si aspetta |
| tipo | il motore che riempie i segnaposto; nello standard c'è solo *template manager Twig* |
| note | annotazioni libere |

> **attenzione** — il **ruolo** è il collegamento fra il template e il messaggio: cambiarlo, o
> scriverlo con una lettera diversa, vuol dire che l'applicazione non trova più il template e manda
> quello predefinito, o nessuno. Un template con lo stesso ruolo di uno predefinito **prende il suo
> posto**, ed è il modo in cui si personalizza un messaggio standard.

Le altre linguette compaiono se ci sono i moduli che le gestiscono:

| linguetta | cosa ci sta |
|---|---|
| contenuti | il messaggio vero e proprio, **una versione per lingua**: mittente, destinatari, destinatari CC e BCC, oggetto e testo |
| file | gli **allegati** che partono con ogni mail nata da questo template |
| azioni | le operazioni sul template; nello standard la pagina prepara i gruppi ma non ci mette riquadri |

> **nota** — i template si leggono all'avvio e restano in memoria: se una modifica **non si vede**
> nei messaggi che partono, prima di sospettare un guasto conviene premere *aggiornamento memcache*
> nella pagina strumenti ( vedi il capitolo *la pagina strumenti* ).

## i template SMS
<!-- @pubblico: amministratore -->
<!-- @pagina: sms.template.view -->

Nella sezione *sms* la linguetta **template** elenca i template degli SMS, con le stesse colonne di
quelli delle mail. Un clic su una riga apre la scheda, il più ne apre una nuova.

## la scheda di un template SMS
<!-- @pubblico: amministratore -->
<!-- @pagina: sms.template.form -->

La linguetta *gestione* è uguale a quella dei template mail: **nome**, **ruolo**, **tipo** e
**note**, con la stessa attenzione al ruolo. Un template salvato da qui è un template SMS.

Le altre linguette sono:

| linguetta | cosa ci sta |
|---|---|
| contenuti | il messaggio, **una versione per lingua**: nome e numero del mittente, destinatari e testo; non ci sono oggetto né allegati. Compare se c'è il modulo dei contenuti |
| azioni | le operazioni sul template; nello standard la pagina prepara i gruppi ma non ci mette riquadri |

> **nota** — i testi scritti nella linguetta *contenuti* di un template SMS **non vengono ancora
> usati** per comporre i messaggi: l'applicazione riconosce il template dal ruolo, ma il testo lo
> prende solo dai template predefiniti.

## quello che questo capitolo non dice ancora

- l'**elenco dei ruoli** che i moduli standard cercano, cioè quali messaggi si possono
  personalizzare e con quale nome;
- i **segnaposto** che si possono usare nel testo e nell'oggetto, messaggio per messaggio;
- la **latenza di invio** di un template, che la base dati prevede ma la scheda non mostra;
- cosa succede quando manca la versione nella **lingua** del destinatario.
