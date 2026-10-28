# GlisWeb — roadmap del server MCP

Questo file raccoglie l'analisi preliminare e le decisioni per dotare il framework di un server
[MCP ( Model Context Protocol )](https://modelcontextprotocol.io), cioè di un endpoint attraverso cui un
client come Claude Code, Claude Desktop o un agente qualsiasi può leggere e scrivere i dati di
un'applicazione glisweb e lanciarne i task, con i permessi dell'utente che si collega.

È un documento di lavoro: quando una fase è chiusa, la sua documentazione va dove appartiene ( il manuale
sviluppatore in `_usr/_docs/_read/` e i docblock dei file ) e qui ne resta un rimando.

## le decisioni prese

Il 28/10/2026, con Fabio:

| domanda | decisione |
|---|---|
| server, client o entrambi | **server**. Il client MCP ( il PHP che chiama server MCP esterni ) resta fuori |
| sola lettura o anche scrittura | **lettura e scrittura**, con la scrittura governata per singolo tool ( vedi sotto ) |
| chi lo usa | **qualunque sviluppatore che costruisce un'applicazione con glisweb**, sulla propria applicazione e per i propri utenti. Ogni deploy è il server MCP di sé stesso, e ogni utente vede solo quello che i suoi permessi gli consentono |
| token a lunga durata | **autorizzati**, come deroga consapevole rispetto ai meccanismi esistenti ( JWT giornaliero e API key di un'ora ) |
| privilegio nuovo | **autorizzato**: `ACCESSO_MCP` |

## il punto di partenza

Nel framework non c'è niente di MCP, ma quasi tutto quello che serve c'è già: la parte da scrivere davvero
è il protocollo JSON-RPC, che è piccolo.

### trasporto

Si usa lo **Streamable HTTP** della specifica: un solo endpoint che riceve una `POST` con un messaggio
JSON-RPC 2.0 e può rispondere con un semplice `application/json`, senza aprire uno stream SSE. È un
request/response puro, cioè esattamente il modello di esecuzione di Apache e PHP: niente processi
persistenti, niente sessioni lato server obbligatorie.

Il trasporto **stdio** ( per un Claude Code che gira sulla stessa macchina ) si può aggiungere più avanti
come `_src/_cli/_mcp.php`, sulla stessa libreria.

### cosa si riusa

| serve | precedente | applicazione |
|---|---|---|
| endpoint | `_src/_api/_<nome>.php`, raggiungibile come `api/<nome>` ( `.htaccess`, regola `^api/([a-zA-Z0-9_\-\.]+)$` ) | `_src/_api/_mcp.php`, risponde su `/api/mcp` **senza toccare `.htaccess`** |
| bootstrap leggero | `_src/_api/_rest.php` con `$cf['lvls']['skip']` | stesso elenco di runlevel da saltare ( pagine, twig, tracking ), con la stessa avvertenza sulle coppie `N0`/`N5` |
| configurazione | coppia `N0`/`N5`, es. `_570`/`_575.openai.php` | `_590.mcp.php` / `_595.mcp.php` ( 590 è libero ), namespace `mcp` a `profiles`, per accendere il server ambiente per ambiente |
| libreria | `_src/_lib/_<area>.tools.php` | `_src/_lib/_mcp.tools.php`: parsing JSON-RPC, registro dei tool, risposte ed errori |
| definizione dei tool | le pagine: `_src/_inc/_pages/`, `_mod/_<modulo>/_src/_inc/_pages/` e le controparti custom, raccolte da `_310.pages.php` | `_src/_inc/_mcp/`, `_mod/_<modulo>/_src/_inc/_mcp/`, `src/inc/mcp/`, `mod/<modulo>/src/inc/mcp/`: ogni modulo attivo porta i suoi tool, il progetto aggiunge i propri o sovrascrive quelli standard |
| autenticazione | `_210.auth.php` intercetta già `Authorization: Bearer` ( JWT ) e `gliswebAuthKey` ( Redis ) | i client MCP mandano proprio `Authorization: Bearer`: si aggiunge il riconoscimento del token a lunga durata nello stesso punto |
| autorizzazione | `controller()` con `$cf['auth']['permissions']`, e `checkTaskPrivilege()` per i task | i tool sulle entità passano da `controller()` come fa `_rest.php`, quindi l'ACL vale da sé; i tool che lanciano task controllano il privilegio del task |
| log | `logger( ..., 'rest' )` | `logger( ..., 'mcp' )`, con il nome del tool e l'utente, mai i dati |

### i vincoli

- **PHP 7.3.** `composer.json` fissa `platform.php` a 7.3.31. L'SDK PHP ufficiale di MCP chiede PHP 8.1 ed
  è a classi, il framework è procedurale: il protocollo si implementa a mano, nello stile del framework
  ( `array( … )`, funzioni in `_mcp.tools.php` ). I metodi da coprire sono pochi: `initialize`,
  `notifications/initialized`, `ping`, `tools/list`, `tools/call`, `resources/list`, `resources/read`.
  Stima: 300–500 righe.
- **L'header `Authorization`.** `_210.auth.php` lo legge con `apache_request_headers()`, che c'è solo con
  mod_php; dietro CGI/FPM Apache spesso non lo passa. Va verificato sui deploy reali ed eventualmente
  ripristinato con una regola `.htaccess` ( `E=HTTP_AUTHORIZATION:%{HTTP:Authorization}` ).
- **Gli hard link fra glisweb e glisdev.** I file nuovi si sviluppano su glisdev e si collegano con
  `sync-add.sh`, con commit su tutti e due i repository. `_src/_api/` oggi non è allineato fra i due
  ( a glisdev mancano `_soap/`, `_ics.php`, `_security.403.php`, `_emailable.*` ): prima di aggiungere
  `_mcp.php` conviene capire se è voluto.

## il token a lunga durata

Un client MCP si configura una volta e deve funzionare per settimane; il JWT scade a mezzanotte ( il salt è
`date( 'Y-m-d' )` ) e la API key dopo un'ora. Serve quindi un token per account, che l'utente genera
dall'interfaccia e incolla nella configurazione del client.

Proposta, da confermare in fase 2:

- **tabella** nuova nel canone, con la sua patch in `_usr/_database/_patch/`: account proprietario, nome
  parlante ( "Claude Code sul portatile" ), **hash** del token e mai il token in chiaro, eventuale
  scadenza, timestamp dell'ultimo uso, flag di attivazione, più le colonne `id_account_inserimento` /
  `timestamp_inserimento` / `id_account_aggiornamento` / `timestamp_aggiornamento` come ogni tabella del
  canone. Non si riusa `account.token`, che è il token del recupero password;
- **formato** riconoscibile ( un prefisso fisso più 64 caratteri esadecimali ), così `_210.auth.php` lo
  distingue da un JWT senza tentare la decodifica, e uno scanner di segreti lo trova se finisce in un
  repository;
- **il token si mostra una volta sola**, alla creazione; si revoca disattivandolo;
- **il login** segue la strada della API key: `_210.auth.php` trova l'account dall'hash e porta al blocco
  di login utente e hash della password, definendo una costante dedicata perché l'endpoint sappia come è
  entrato l'utente;
- **il perimetro**: in prima battuta il token vale solo su `api/mcp`, non sul resto delle API. Allargarlo
  è una decisione separata.

## il privilegio `ACCESSO_MCP`

Si dichiara in `_200.auth.php` accanto agli altri, e lo controlla `_src/_api/_mcp.php` prima di qualsiasi
metodo che non sia `initialize` o `ping`. Va a `roots`; per `staff` lo decide il progetto. Avere il
privilegio non dà accesso a niente di più: ogni tool resta soggetto ai permessi dell'utente.

## i tool

| famiglia | cosa fa | note |
|---|---|---|
| entità, lettura | elenco con filtri e paginazione, lettura di un record, anche in view mode | gli stessi parametri di `api/<entità>`, paginazione a 100 righe come in `_rest.php` |
| entità, scrittura | creazione, modifica, cancellazione | **spenta per default**, si accende entità per entità in configurazione; la cancellazione ricorsiva non si espone mai |
| task | lancio dei task di `_src/_api/_task/` e dei moduli | solo i task dichiarati esponibili; ognuno controlla già il proprio privilegio |
| resource | documentazione ( `_usr/_docs` ), stato del framework ( `_status/_framework.php` ) | `_status/_cf.php` solo per `roots` |

Le descrizioni dei tool ( `description` e `inputSchema` ) sono quelle che il modello legge per decidere
cosa chiamare: vanno scritte con la stessa cura dei docblock, e quelle delle entità si possono generare
dalla struttura delle tabelle.

## la sicurezza

Dare il CRUD di un gestionale a un modello linguistico ha rischi suoi, che il resto delle API non ha:

- **prompt injection**: un campo note scritto da un utente esterno può contenere istruzioni che il
  modello esegue con i permessi di chi è collegato. Da qui la scrittura spenta per default e la lista
  chiusa dei task;
- **dati personali**: quello che un tool restituisce finisce al fornitore del modello. Va previsto un
  mascheramento dei campi sensibili configurabile per entità, e va detto chiaramente nella
  documentazione che la responsabilità GDPR resta del titolare dell'applicazione;
- **mai esposti**: `CANCELLAZIONE_RICORSIVA`, `INVIO_DIRETTO_MAIL`, la gestione degli account e dei
  token stessi;
- **firewall**: le chiamate con token non valido danno punti all'IP come le altre richieste respinte
  ( `_security.403.php` ), e il limitatore di frequenza vale anche qui;
- **traccia**: ogni `tools/call` di scrittura si logga con utente, token, tool e id del record.

## le fasi

1. **MVP in lettura** — `api/mcp` su HTTP; `initialize`, `ping`, `tools/list`, `tools/call`; tool di
   lettura su un elenco chiuso di entità; resource di documentazione; autenticazione col Bearer JWT già
   esistente, che basta per provare con Claude Code; coppia `_590`/`_595` col server spento per default.
2. **token e privilegio** — tabella e patch, generazione e revoca da interfaccia, riconoscimento in
   `_210.auth.php`, `ACCESSO_MCP`.
3. **scrittura e task** — tool di scrittura attivabili per entità, task esponibili, mascheramento dei
   campi, log di scrittura.
4. **estensione** — tool dichiarati dai moduli e dai progetti, capitolo del manuale sviluppatore e
   quickstart "collegare Claude alla propria applicazione".
5. **facoltative** — trasporto stdio da CLI, OAuth 2.1 come da specifica MCP al posto del token statico.

## le domande ancora aperte

- dove si generano i token nell'interfaccia: nel profilo dell'utente, nella gestione account, o tutt'e due;
- se il token debba poter restringere i tool rispetto ai permessi dell'utente ( uno scope ) già in fase 2;
- se l'elenco delle entità esposte in lettura parta vuoto ( tutto da accendere ) o pieno ( tutto quello
  che l'utente può già vedere );
- quale versione della specifica MCP dichiarare in `initialize` e come gestire la negoziazione con i
  client più vecchi.
