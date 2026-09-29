# account

Un **account** è la chiave con cui una persona entra nell'applicazione: un nome utente, una
password e i **gruppi** a cui appartiene, che decidono cosa vede e cosa può fare. L'account non è
la persona: la persona sta in anagrafica, e l'account le si aggancia. Per questo lo stesso contatto
può esistere per anni in anagrafica senza mai entrare nell'applicazione, e ottenere un account solo
il giorno in cui serve.

Nel menu la voce **account** sta sotto *anagrafica*, fra le sue sotto-voci.

> **solo amministratori** — l'elenco e la scheda degli account si aprono solo agli amministratori
> dell'installazione: decidere chi entra e con quali permessi non è un lavoro da distribuire.

## l'elenco degli account
<!-- @pubblico: amministratore -->
<!-- @pagina: account.view -->

Una riga per account:

| colonna | contenuto |
|---|---|
| account | il nome utente con cui si entra |
| anagrafica | il contatto a cui l'account è agganciato |
| e-mail | l'indirizzo usato per recuperare la password |
| gruppi | i gruppi di cui l'account fa parte |
| attivo | un segno di spunta se l'account può entrare |

Le linguette dell'area sono **account**, **gruppi** e **azioni**. Un clic su una riga apre la
scheda; ricerca, ordinamento ed esportazione funzionano come in tutti gli elenchi.

> **nota** — la linguetta *azioni* dell'elenco per ora **non contiene riquadri**: le esportazioni e
> le importazioni di account sono previste ma non ancora disponibili.

## la scheda di un account
<!-- @pubblico: amministratore -->
<!-- @pagina: account.form -->

La linguetta *gestione* tiene i dati di accesso:

| campo | contenuto |
|---|---|
| anagrafica | il contatto a cui l'account appartiene; si cerca scrivendo il nome |
| e-mail per recupero password | uno degli indirizzi di quel contatto, a cui arriva il link quando la password è dimenticata |
| username | il nome con cui si entra; obbligatorio |
| password | la password di accesso |
| attivo | se non è spuntato l'account esiste ma **non entra** |

Sotto i dati generali c'è il sotto-elenco dei **gruppi**: uno per riga, aggiunti col più e tolti col
cestino. È l'appartenenza ai gruppi a decidere quali voci di menu e quali maschere l'utente vede.

> **attenzione** — la tendina dell'*e-mail per recupero password* elenca gli indirizzi del contatto
> scelto in *anagrafica*, e si riempie **dopo aver salvato** la scheda con l'anagrafica impostata.
> Su un account nuovo si sceglie prima il contatto, si salva, e poi si sceglie l'indirizzo.

### la password

Il campo della password **si presenta sempre vuoto**, anche su un account che una password ce l'ha:
l'applicazione non la conserva in chiaro e quindi non può mostrarla. Lasciarlo vuoto e salvare
**non cambia** la password esistente; scriverci qualcosa e salvare la sostituisce.

> **esempio** — per sbloccare un utente che ha dimenticato la password, si apre la sua scheda, si
> scrive una password provvisoria, si salva e gliela si comunica. Se all'account è associata
> un'e-mail, l'utente può anche fare da solo dalla pagina di accesso.

Per **sospendere** un accesso — un collaboratore che non lavora più con noi, un utente di prova — si
toglie la spunta *attivo* e si salva: l'account resta, con i suoi gruppi, e si riattiva rimettendo
la spunta.

### le altre linguette

| linguetta | cosa ci sta |
|---|---|
| attribuzione | gli incarichi dell'account **dentro** un gruppo: gruppo, entità collegata, note, una riga per incarico |
| stampe | i documenti stampabili per l'account, se l'installazione ne ha configurati |
| azioni | le operazioni sull'account |

> **nota** — la linguetta *azioni* della scheda per ora è **vuota**: il riquadro per reimpostare la
> password e avvisare l'utente per posta è previsto ma non ancora disponibile. Nel frattempo si
> procede come nell'esempio qui sopra.

## i gruppi
<!-- @pubblico: amministratore -->
<!-- @pagina: gruppi.view -->

La linguetta **gruppi** elenca i gruppi dell'installazione, in ordine alfabetico. La scheda di un
gruppo ha due soli campi:

| campo | contenuto |
|---|---|
| genitore | il gruppo di cui questo è una suddivisione, se c'è |
| nome | il nome del gruppo; obbligatorio |

I gruppi sono l'unità con cui si danno i permessi: **non si dà un permesso a una persona**, la si
mette nel gruppo che ce l'ha. Chi arriva nuovo va quindi messo nello stesso gruppo di chi fa già
il suo lavoro, e un permesso che manca a tutti si chiede per il gruppo intero.

> **attenzione** — rinominare o cancellare un gruppo cambia quello che vedono **tutti** i suoi
> membri alla loro prossima pagina. I gruppi con cui l'installazione è nata sono quelli a cui le
> maschere danno i permessi, e non vanno toccati.

## quello che questo capitolo non dice ancora

- quali **gruppi** esistono di serie e cosa può fare ciascuno: dipende dai moduli attivi, e va
  descritto accanto alle maschere che ogni gruppo apre;
- a cosa serve in pratica l'**attribuzione**, e cosa va scritto in *entità collegata*;
- il **recupero della password** dal lato dell'utente, dalla pagina di accesso.
