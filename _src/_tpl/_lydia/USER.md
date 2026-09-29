# Lydia, il sito con l'area riservata

> **nota** — Lydia è un template **da riallineare**. È nato per una versione precedente del
> framework, e diverse pagine che lo nominano — il carrello, le schede prodotto, la ricerca — puntano
> ancora a quella versione e non a questo template. Fra le pagine standard di oggi l'unica che lo usa
> davvero è la **reimpostazione della password**. Questo capitolo descrive quello che il template
> disegna; i moduli di accesso e dell'account, in particolare, vanno provati sull'installazione prima
> di indicarli agli utenti, perché possono non comparire.

Lydia è un template per il **sito pubblico con un'area riservata**: oltre al menu e al contenuto ha
una barra delle categorie con la ricerca, le immagini di testata, la galleria, e le pagine per
entrare, gestire il proprio account e recuperare la password. È pensato per un sito di prodotti o di
servizi in cui il visitatore può anche diventare utente.

## com'è fatta la pagina

Dall'alto in basso:

| fascia | cosa contiene |
|---|---|
| **testata** | il logo, che riporta alla home page, e a destra due menu: una riga di **icone** e sotto le voci principali |
| **barra delle categorie** | una fascia grigia con il menu delle categorie e la **casella di ricerca**; resta ferma in cima mentre si scorre |
| **menu esteso** | dove il sito lo prevede, un secondo menu a tutta larghezza sotto le categorie |
| **sottomenu** | una riga di voci allineate a sinistra, sotto la barra |
| **immagini di testata** | un carosello di immagini che scorrono da sole, oppure una grande immagine fissa; solo sulle pagine che ne hanno |
| **contenuto** | *sei qui >* col percorso, il titolo, l'eventuale sottotitolo e il testo |
| **galleria** | le miniature delle immagini della pagina; un clic le apre ingrandite, una alla volta |
| **piedi** | due fasce grigie: la firma, e i link a *privacy*, *condizioni di fornitura* e *affiliazioni* |

Il percorso ( *sei qui > sezione > pagina* ) compare solo sulle pagine che stanno dentro una
sezione: sulle pagine di primo livello non c'è.

## menu e ricerca

Su schermo stretto i menu della testata e quello delle categorie si raccolgono ciascuno nel suo
pulsante con le **tre linee**; si preme per aprirli. Le sotto-voci compaiono elencate sotto la voce
a cui appartengono.

La **casella di ricerca** sta nella barra delle categorie: si scrive la parola e si preme la lente.
I risultati si aprono in una pagina a parte, che è del modulo di ricerca e non del template.

## entrare nell'area riservata

Quando si apre una pagina riservata senza essere entrati, al posto del contenuto compare il modulo
**accesso utenti registrati**: *username*, *password* e il pulsante *login*. Sotto c'è
**password dimenticata?**, che porta alla reimpostazione.

> **nota** — se il sito permette di registrarsi, accanto al modulo di accesso dovrebbe comparire
> quello di registrazione. Nel template standard quel pezzo **non c'è ancora**.

## il proprio account

La pagina dell'account ha due gruppi di campi e un pulsante in fondo per salvare:

| gruppo | campi |
|---|---|
| **i tuoi dati** | nome, cognome, e-mail, telefono, cellulare |
| **cambio password** | password corrente, nuova password, nuova password ripetuta |

Per cambiare la password bisogna compilare **tutti e tre** i campi del secondo gruppo, e le due
nuove devono coincidere; se si vogliono cambiare solo i dati, i campi della password si lasciano
vuoti.

## reimpostare la password

È una procedura in tre passaggi, tutti sulla stessa pagina:

1. si scrive l'**e-mail** con cui si è registrati e si conferma; se l'indirizzo corrisponde a un
   account, la pagina dice che è partita una mail, altrimenti dice che l'indirizzo non corrisponde a
   nessun account valido;
2. nella mail c'è un **link**: aprendolo si torna alla stessa pagina, che adesso chiede la **nuova
   password**;
3. si scrive la nuova password e si conferma: da quel momento vale quella.

In fondo alla pagina c'è sempre **torna alla home page**, per uscire dalla procedura a metà.

> **attenzione** — il link della mail vale **una volta sola**: usato per cambiare la password non
> funziona più, e un secondo tentativo va ricominciato dal primo passaggio. Se il link dice che *il
> token non è valido*, è questo il caso — oppure nel frattempo è stata chiesta un'altra mail, e vale
> solo l'ultima.

## cookie e protezione dei moduli

Il **banner dei cookie**, quando il sito ne ha bisogno, compare in fondo alla pagina come in tutti
i template del sito pubblico. I moduli di accesso, account e reimpostazione possono essere protetti
da **reCAPTCHA**: di norma non si vede niente, ma se il servizio ha un dubbio chiede di confermare di
non essere un programma prima di inviare.

## quello che questo capitolo non dice ancora

- come si presentano **carrello**, **schede prodotto** e **risultati di ricerca**, che appartengono a
  questo template ma oggi sono ancora disegnati per la versione precedente;
- a cosa servono le voci della **riga di icone** in testata, che cambiano da un sito all'altro;
- l'**uscita** dall'area riservata, che nel template standard non ha un pulsante;
- le figure: sarebbero utili lo scatto della pagina di reimpostazione della password nei suoi tre
  stati — e-mail, mail inviata, nuova password — e quello di una pagina di contenuto con percorso e
  galleria.
