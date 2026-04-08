# nuova release e versione standard del framework GlisWeb
Questo file serve per orientarsi all'interno del framework GlisWeb; si tratta di una sorta di guida
generale, da tenere sotto mano mentre si studia il framework.

## architettura generale
Il framework GlisWeb, come ogni web application, risponde su chiamata e termina l'esecuzione inviando l'output al
richiedente. Quando il framework riceve una chiamata, questa viene gestita in primo luogo dal file /.htaccess (su
Apache) o dal file /index.php (su Nginx).

L'esecuzione viene a quel punto passata a una API in grado di gestire la richiesta; ad esempio, se viene richiesta
una pagina web, l'esecuzione passerà a /_src/_api/_pages.php (vedi sotto).

Una volta passata l'esecuzione all'API di competenza, questa si occuperà innanzitutto di fare il bootstrap del framework
includendo il file /_src/_config.php (si veda la documentazione del file per maggiori dettagli) il quale provvede a:

- dichiarare le funzioni core
- includere i file di configurazione
- includere le librerie
- predisporre l'ambiente
- eseguire i runlevel

Il funzionamento di /_src/_config.php è troppo complicato per essere riassunto qui, ma leggere questo file dovrebbe essere
il primo passo per chi vuole studiare il funzionamento del framework.

Una volta che l'esecuzione del kernel del framework è terminata, il controllo torna all'API chiamante che ha facoltà di
eseguire tutte le operazioni che vuole prima di terminare inviando l'output al richiedente.

## descrizione dei file
In questa sezione tutti i file e le cartelle del framework sono riportati in ordine logico, per dare un'idea dell'insieme.
Ogni file contiene poi i commenti dettagliati sul proprio funzionamento.

### /.gitignore
Questo file (il cui contenuto cambia fra sviluppo del framework e sviluppo dei progetti) impedisce che vengano caricati
nel repository Git del framework (o del progetto) file inutili o potenzialmente sensibili.

TODO nella vecchia versione il file .gitignore per i deploy è in /_usr/_deploy/_git/.gitignore e viene gestito tramite
/_src/_sh/_gw.upgrade.sh; valutare se è il posto giusto o se va spostato ad es. in /_usr/_examples/_config/_git/.

### /.htaccess
Questo file costituisce il punto di ingresso del framework, tutte le richieste in entrata vengono processate da questo file
che poi le rimanda al file PHP opportuno. In pratica il file .htaccess costituisce il motore di routing principale
del framework.

### /composer.json e /composer.lock
Il file composer.json include le dipendenze del framework che vengono gestite tramite composer; la cartella di installazione
per le librerie esterne è /_src/_lib/_ext/

strategia       | libreria                      | versione          | note
----------------|-------------------------------|-------------------|-----------------------------
require         | phpoffice/phpword             | *                 |
require         | phpoffice/phpspreadsheet      | *                 |
require         | phpoffice/phppresentation     | *                 |
require         | html2text/html2text           | *                 |
require         | phpmailer/phpmailer           | *                 |
require         | tecnickcom/tcpdf              | *                 |
require         | twig/twig                     | *                 |
require         | predis/predis                 | *                 |
require         | codeception/codeception       | *                 |
require         | codeception/module-phpbrowser | *                 |
require         | codeception/module-asserts    | *                 |
suggest         | twig/extra-bundle             | *                 |

### /_etc/_current.release e /_etc/_current.version
Il framework viene versionato con due diverse numerazioni, le release che seguono la classica notazione a tre stage (major.minor.bugfix)
e le versioni che sono numerate progressivamente con una timestamp (ad es. 20240502225937). La ragione di questa distinzione è che le
versioni vengono incrementate quotidianamente, mentre le release di rado, solo quando numerose versioni si sono accumulate.

L'aggiornamento della versione è fatto automaticamente tramite un git hook (/.git/hooks/pre-commit) ad ogni commit sul repository di
sviluppo del framework:

```
#!/bin/bash

BRANCH=`git rev-parse --abbrev-ref HEAD`
VERS=$(date '+%Y%m%d%H%M%S')
GITNAME=`basename $(git remote get-url origin)`

echo "repository: "$GITNAME

if [ -n "$( echo $GITNAME | grep 'glisweb' )" ]; then

echo "branch: "$BRANCH
echo "version: "$VERS

    echo $VERS > _etc/_current.version
    git add _etc/_current.version

    echo "aggiornamento della versione effettuato con successo"

fi
```

La versione invece viene modificata a mano quando si crea una nuova release branch.

### /_etc/_current.version
Vedi /_etc/_current.release.

### /_etc/_common/_lorem.conf
Questo file contiene il testo di prova del framework; si è optato per il classico Lorem Ipsum (https://lipsum.com/) dal momento che
la maggior parte dei grafici è già familiare con questo testo. Nel file /_src/_config/_420.pages.php viene processato il comando di una lettera
"m" per inserire il Lorem Ipsum come testo della pagina.

### /_etc/_dictionaries/_<dictionary>.<lang>-<country>.conf
Questi file contengono i dizionari per la traduzione automatica dei microcontenuti. La traduzione automatica dei microcontenuti viene
gestita tramite la macro Twig tr() dichiarata in /_src/_twig/_lib/_translation.twig. Un utilizzo tipico di tr() considerando che la variabile
ietf contenga la lingua corrente e che la traduzione che si desidera è presente in $ct['tr']['generic'] è il seguente:

```
{% import '_lib/_translation.twig' as trn %}
{{ trn.tr({ 'w': '<chiave>', 'l': ietf, 'v': tr.generic }) }}
```

I file dei dizionari vengono importati in $cf nel file /_src/_config/_090.translation.php e $cf['tr] viene collegato a $ct['tr] in
/_src/_config/_095.translation.php.

### /_etc/_dictionaries/_generic.cs-CZ.conf
Dizionario generico per la lingua ceca.

### /_etc/_dictionaries/_generic.de-DE.conf
Dizionario generico per la lingua tedesca.

### /_etc/_dictionaries/_generic.en-GB.conf
Dizionario generico per la lingua inglese britannica.

### /_etc/_dictionaries/_generic.en-US.conf
Dizionario generico per la lingua inglese statunitense.

### /_etc/_dictionaries/_generic.es-ES.conf
Dizionario generico per la lingua spagnola.

### /_etc/_dictionaries/_generic.fr-FR.conf
Dizionario generico per la lingua francese.

### /_etc/_dictionaries/_generic.hr-HR.conf
Dizionario generico per la lingua croata.

### /_etc/_dictionaries/_generic.hu-HU.conf
Dizionario generico per la lingua ungherese.

### /_etc/_dictionaries/_generic.it-IT.conf
Dizionario generico per la lingua italiana.

### /_etc/_dictionaries/_generic.ja-JP.conf
Dizionario generico per la lingua giapponese.

### /_etc/_dictionaries/_generic.pl-PL.conf
Dizionario generico per la lingua polacca.

### /_etc/_dictionaries/_generic.pt-BR.conf
Dizionario generico per la lingua portoghese brasiliana.

### /_etc/_dictionaries/_generic.pt-PT.conf
Dizionario generico per la lingua portoghese.

### /_etc/_dictionaries/_generic.ro-RO.conf
Dizionario generico per la lingua rumena.

### /_etc/_dictionaries/_generic.ru-RU.conf
Dizionario generico per la lingua russa.

### /_etc/_dictionaries/_generic.sv-SE.conf
Dizionario generico per la lingua svedese.

### /_etc/_doxygen/_doxygen.conf
Questo è il file di configurazione utilizzato per compilare la documentazione del framework tramite Doxygen (https://www.doxygen.nl/). La
compilazione della documentazione viene effettuata tramite lo script /_src/_sh/_doxygen.build.sh e i documenti compilati vengono salvati in
/_usr/_docs/_html/ per la versione HTML e in /_usr/_docs/_pdf/ per la versione PDF.

La documentazione viene generata a partire dai commenti al codice e dai file dox presenti in /_usr/_docs/_dox, ed è disponibile via browser
utilizzando il percorso /docs/index.html per l'HTML e /docs/pdf per il PDF.

TODO se è possibile, le varie opzioni di questo file andrebbero commentate una per una, magari facendo qui una tabella con il significato
di ogni opzione.

### /_etc/_robots/_deny.txt e /_etc/_robots/_robots.txt
Questi sono i file robots che vengono serviti richiedendo l'URL /robots.txt; nel file /.htaccess è presente un set di regole che in base al valore
della variabile d'ambiente %{ENV:STATUS} eroga il file corretto (deny per DEV e TEST, robots per PROD). La variabile di ambiente viene settata nel
file di configurazione dell'host di Apache per le varie configurazioni del sito:

```
<VirtualHost *:80>

    ...

    SetEnv STATUS DEV

    ...

</VirtualHost>
<IfModule mod_ssl.c>
<VirtualHost *:443>

    ...

    SetEnv STATUS DEV

    ...

</VirtualHost>
</IfModule>
```

Nella configurazione di PROD viene vietata l'indicizzazione di tutto il ramo /admin in quanto contiene le pagine del CMS, che non devono
per ovvi motivi apparire nei risultati di ricerca.

### /_etc/_robots/_robots.txt
Vedi /_etc/_robots/_deny.txt.

### /_etc/_security/_banned.words.conf
Questo file contiene una lista di parole vietate negli URL, che viene gestita da /_src/_inc/_macro/_security.php. Si tratta di un filtro
un po' grezzo ma funzionale, che blocca molti tipi di attacchi basati su URL.

### /_etc/_security/_common.passwords.conf
Questo file contiene un piccolo dizionario di password vietate per l'utente root. Il controllo viene effettuato in /_src/_api/_status/_framework.php
nella sezione sicurezza.

### /_mod/_01000.produzione/_src/_inc/_macro/_produzione.archivio.php
Questa è la macro dell'archivio del modulo produzione.

### /_mod/_01000.produzione/_src/_inc/_macro/_produzione.archivio.tools.php
Questa è la macro della pagina degli strumenti dell'archivio del modulo produzione.

### /_mod/_01000.produzione/_src/_inc/_macro/_produzione.php
Questa è la macro della dashboard del modulo produzione.

### /_mod/_01000.produzione/_src/_inc/_macro/_produzione.tools.php
Questa è la macro della pagina degli strumenti della dashboard del modulo produzione.

### /_mod/_01000.produzione/_src/_inc/_pages/_produzione.it-IT.php
In questo file vengono definite le pagine del modulo produzione.

### /_mod/_02000.commerciale/_src/_inc/_macro/_commerciale.archivio.php
Questa è la macro dell'archivio del modulo commerciale.

### /_mod/_02000.commerciale/_src/_inc/_macro/_commerciale.archivio.tools.php
Questa è la macro della pagina degli strumenti dell'archivio del modulo commerciale.

### /_mod/_02000.commerciale/_src/_inc/_macro/_commerciale.ciclo.attivo.php
Questa è la macro della dashboard del ciclo attivo del modulo commerciale.

### /_mod/_02000.commerciale/_src/_inc/_macro/_commerciale.ciclo.attivo.tools.php
Questa è la macro della pagina strumenti del ciclo attivo del modulo commerciale.

### /_mod/_02000.commerciale/_src/_inc/_macro/_commerciale.ciclo.passivo.php
Questa è la macro della dashboard del ciclo passivo del modulo commerciale.

### /_mod/_02000.commerciale/_src/_inc/_macro/_commerciale.ciclo.passivo.tools.php
Questa è la macro della pagina strumenti del ciclo passivo del modulo commerciale.

### /_mod/_02000.commerciale/_src/_inc/_macro/_commerciale.php
Questa è la macro della dashboard del modulo commerciale.

### /_mod/_02000.commerciale/_src/_inc/_macro/_commerciale.tools.php
Questa è la macro della pagina strumenti della dashboard del modulo commerciale.

### /_mod/_02000.commerciale/_src/_inc/_pages/_commerciale.it-IT.php
In questo file vengono definite le pagine del modulo commerciale.

### /_mod/_03000.contenuti/_src/_config/_750.controller.php
Questa è la controller del modulo contenuti, ha la funzione di caricare e salvare i file dei template modificati tramite il CMS.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.archivio.php
Questa è la macro della pagina di archivio del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.archivio.tools.php
Questa è la macro della pagina strumenti dell'archivio del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.php
Questa è la macro della dashboard del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.template.form.default.php
Questa è una macro di default inclusa dalle macro di gestione dei template del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.template.form.editor.php
Questa è la macro della pagina di modifica dei file dei template del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.template.form.php
Questa è la macro della pagina di gestione dei template del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.template.form.tools.php
Questa è la macro della pagina degli strumenti del form di gestione dei template del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.template.tools.php
Questa è la macro della pagina degli strumenti della vista template del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.template.view.php
Questa è la macro della pagina di vista dei template del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_macro/_contenuti.tools.php
Questa è la macro della pagina degli strumenti della dashboard del modulo contenuti.

### /_mod/_03000.contenuti/_src/_inc/_pages/_contenuti.it-IT.php
In questo file vengono definite le pagine del modulo contenuti.

### /_mod/_04000.catalogo/_src/_inc/_macro/_catalogo.archivio.php
Questa è la macro della pagina di archivio del catalogo.

### /_mod/_04000.catalogo/_src/_inc/_macro/_catalogo.archivio.tools.php
Questa è la macro della pagina degli strumenti dell'archivio del catalogo.

### /_mod/_04000.catalogo/_src/_inc/_macro/_catalogo.php
Questa è la macro della dashboard del modulo catalogo.

### /_mod/_04000.catalogo/_src/_inc/_macro/_catalogo.tools.php
Questa è la macro della pagina degli strumenti della dashboard del modulo catalogo.

### /_mod/_04000.catalogo/_src/_inc/_pages/_catalogo.it-IT.php
Qui vengono definite le pagine del modulo catalogo.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.archivio.php
Questa è la macro dell'archivio dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.archivio.reparti.view.php
Questa è la macro della pagina di vista dell'archivio reparti.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.archivio.tools.php
Questa è la macro della pagina degli strumenti dell'archivio amministrazione

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.ciclo.attivo.php
Questa è la macro della dashboard del ciclo attivo dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.ciclo.attivo.tools.php
Questa è la macro della pagina degli strumenti della dashboard del ciclo attivo dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.ciclo.passivo.php
Questa è la macro della dashboard del ciclo passivo dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.ciclo.passivo.tools.php
Questa è la macro della pagina degli strumenti del ciclo passivo dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.php
Questa è la macro della dashbaord dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.tools.php
Questa è la macro della pagina degli strumenti della dashboard dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_pages/_amministrazione.it-IT.php
Qui vengono definite le pagine del modulo amministrazione.

### /_mod/_AC000.account/_src/_inc/_controllers/_account.before.php
Questa controller viene eseguita al before di ogni elaborazione dell'entità account.

### /_mod/_AC000.account/_src/_inc/_macro/_account.form.php
Questa è la macro del form di gestione degli account.

### /_mod/_AC000.account/_src/_inc/_macro/_account.form.attribuzione.php
Questa è la macro della scheda attribuzione del form di gestione degli account.

### /_mod/_AC000.account/_src/_inc/_macro/_account.form.tools.php
Questa è la macro della pagina strumenti del form di gestione degli account.

### /_mod/_AC000.account/_src/_inc/_macro/_account.tools.php
Questa è la macro degli strumenti della view degli account.

### /_mod/_AC000.account/_src/_inc/_macro/_account.view.php
Questa è la macro della view degli account.

### /_mod/_AC000.account/_src/_inc/_macro/_gruppi.form.php
Questa è la macro della pagina di gestione dei gruppi.

### /_mod/_AC000.account/_src/_inc/_macro/_gruppi.form.tools.php
Questa è la macro della pagina strumenti della gestione dei gruppi.

### /_mod/_AC000.account/_src/_inc/_macro/_gruppi.view.php
QUesta è la macro della view dei gruppi.

### /_mod/_AC000.account/_src/_inc/_pages/_account.it-IT.php
Qui vengono definite le pagine del modulo account.

### /_mod/_AN000.anagrafica/_src/_api/_task/_anagrafica.view.static.popolazione.php
Questo task si occupa di ripopolare la view static dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_controllers/_anagrafica.finally.php
Questa controller viene eseguita al finally di ogni elaborazione dell'entità anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.anagrafica.indirizzi.form.php
Questa è la macro della pagina di gestione degli indirizzi.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.anagrafica.indirizzi.form.tools.php
Questa è la macro della pagina strumenti della gestione degli indirizzi.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.anagrafica.indirizzi.view.php
Questa è la macro della view degli indirizzi.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.iban.form.php
Questa è la macro della pagina di gestione degli IBAN.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.iban.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione degli IBAN.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.iban.view.php
Questa è la macro della view degli IBAN.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.mail.form.php
Questa è la macro della pagina di gestione delle mail.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.mail.form.tools.php
Questa è la macro della pagina strumenti della gestione delle mail.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.mail.view.php
Questa è la macro della view delle mail.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.php
Questa è la macro della dashboard dell'archivio dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.telefoni.form.php
Questa è la macro della pagina di gestione dei telefoni.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.telefoni.form.tools.php
Questa è la macro della pagina strumenti della gestione telefoni.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.telefoni.view.php
Questa è la macro della view dei telefoni.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.tipologie.anagrafica.form.php
Questa è la macro della pagina di gestione delle tipologie dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.tipologie.anagrafica.form.tools.php
Questa è la macro della pagina strumenti della gestione delle tipologie dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.tipologie.anagrafica.view.php
Questa è la macro della view delle tipologie dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.tools.php
Questa è la macro della pagina strumenti della dashboard dell'archivio dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.url.form.php
Questa è la macro della pagina di gestione degli URL.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.url.form.tools.php
Questa è la macro della pagina strumenti della gestione degli URL.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.archivio.url.view.php
Questa è la macro della view degli URL.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.archiviazione.php
Questa è la macro della scheda archiviazione della gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.cliente.php
Questa è la macro della scheda cliente della gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.collaboratore.php
Questa è la macro della scheda collaboratore della gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.default.php
Questa è la macro di default inclusa in tutte le schede della gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.fornitore.php
Questa è la macro della scheda fornitore della gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.php
Questa è la macro della pagina di gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.produttore.php
Questa è la macro della scheda produttore della pagina di gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.relazioni.php
Questa è la macro della scheda relazioni della pagina di gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.tools.php
Queata è la macro della pagina strumenti della gestione anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.stampe.php
Questa è la macro della scheda stampe dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.tools.php
Questa è la macro della pagina strumenti della view dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.view.archiviate.php
Questa è la macro della view delle anagrafiche archiviate.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_anagrafica.view.php
Questa è la macro della view delle anagrafiche.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_categorie.anagrafica.form.php
Questa è la macro della pagina di gestione delle categorie dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_categorie.anagrafica.form.anagrafiche.php
Questa è la macro della scheda anagrafiche della pagina di gestione delle categorie dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_categorie.anagrafica.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione delle categorie dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_categorie.anagrafica.form.tools.php
Questa è la macro della pagina strumenti della gestione delle categorie dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_categorie.anagrafica.tools.php
Questa è la macro della pagina strumenti della view delle categorie del'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_categorie.anagrafica.view.php
Questa è la macro della view delle categorie dell'anagrafica.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_ranking.form.php
Questa è la macro della pagina di gestione del ranking

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_ranking.form.anagrafiche.php
Questa è la macro della scheda anagrafiche della pagina di gestione ranking.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_ranking.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione ranking.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_ranking.form.tools.php
Questa è la macro della pagina strumenti della gestione ranking.

### /_mod/_AN000.anagrafica/_src/_inc/_macro/_ranking.view.php
Questa è la macro della view del ranking.

### /_mod/_AN000.anagrafica/_src/_inc/_pages/_anagrafica.it-IT.php
Qui vengono definite le pagine del modulo anagrafica.

### /_mod/_AN000.anagrafica/_src/_lib/_mysql.utils.add.php
Questa libreria contiene funzioni specifiche dell'anagrafica da aggiungere a /_src/_lib/_mysql.utils.php.

### /_mod/_AT000.attivita/_src/_api/_task/_attivita.archiviazione.php
Questo task si occupa di archiviare dei gruppi di attività.

### /_mod/_AT000.attivita/_src/_api/_task/_attivita.view.static.popolazione.php
Questo task si occupa di popolare la view statica delle attività.

### /_mod/_AT000.attivita/_src/_inc/_controllers/_attivita.finally.php
Questa controller viene eseguita al finally di ogni elaborazione dell'entità attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_anagrafica.form.attivita.php
Questa è la macro della scheda attività della gestione anagrafica.

### /_mod/_AT000.attivita/_src/_inc/_macro/_anagrafica.form.lavoro.php
Questa è la macro della scheda lavoro della gestione anagrafica.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.form.archiviazione.php
Questa è la macro della scheda archiviazione della gestione attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.form.php
Questa è la macro della pagina di gestione attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.form.tools.php
Questa è la macro della pagina strumenti della gestione attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.tools.php
Questa è la macro della pagina strumenti della view attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.view.archiviate.php
Questa è la macro della view delle attività archiviate.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.view.php
Questa è la macro della view delle attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.tipologie.attivita.form.php
Questa è la macro della pagina di gestione delle tipologie di attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.tipologie.attivita.form.tools.php
Questa è la macro della pagina degli strumenti della gestione delle tipologie di attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.tipologie.attivita.view.php
Questa è la macro della view delle tipologie di attività.

### /_mod/_AT000.attivita/_src/_inc/_pages/_anagrafica.it-IT.php
Qui vengono definite le pagine del modulo attività.

### /_mod/_AT000.attivita/_src/_inc/_pages/_produzione.it-IT.php
Qui vengono definite le pagine del modulo attività relative al modulo produzione.

### /_mod/_AT000.attivita/_src/_lib/_mysql.utils.add.php
In questa libreria vengono definite funzioni specifiche per le attività da aggiungere a /_src/_lib/_mysql.utils.php.

### /_mod/_CO000.contenuti/_src/_inc/_controllers/_contenuti.after.php
Questa controller viene eseguita dopo ogni ciclo di lavoro della funzione controller() per l'entità contenuti.

### /_mod/_CO000.contenuti/_src/_inc/_controllers/_contenuti.before.php
Questa controller viene eseguita prima di ogni ciclo di lavoro della funzione controller() per l'entità contenuti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.contenuti.php
Questa è la macro della scheda di gestione contenuti della pagina di gestione delle categorie prodotti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.menu.php
Questa è la macro della scheda di gestione dei menu della pagina di gestione delle categorie prodotti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.sem.php
Questa è la macro della scheda di gestione SEM/SMM della pagina di gestione delle categorie prodotti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.web.php
Questa è la macro della scheda di gestione web della pagina di gestione delle categorie prodotti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_catalogo.prodotti.form.contenuti.php
Questa è la macro della scheda di gestione contenuti della pagina di gestione prodotti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_catalogo.prodotti.form.sem.php
Questa è la macro della scheda di gestione SEM/SMM della pagina di gestione prodotti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_catalogo.prodotti.form.web.php
Questa è la macro della scheda di gestione web della pagina di gestione prodotti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.archivio.contenuti.form.php
Questa è la macro della dashboard dell'archivio dei contenuti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.archivio.contenuti.form.testo.php
Questa è la macro della pagina di gestione dell'archivio dei contenuti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.archivio.contenuti.form.tools.php
Questa è la macro della pagina degli strumenti della pagina di gestione dei contenuti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.archivio.contenuti.form.wysiwyg.php
Questa è la macro della scheda WYSIWYG della pagina di gestione contenuti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.archivio.contenuti.view.php
Questa è la macro della view dei contenuti.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.categorie.notizie.form.contenuti.php
Questa è la macro della pagina di gestione dei contenuti delle categorie di notizie.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.categorie.notizie.form.menu.php
Questa è la pagina di gestione dei menu delle categorie di notizie.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.categorie.notizie.form.sem.php
Questa è la macro della pagina di gestione SEM/SMM delle categorie di notizie.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.categorie.notizie.form.web.php
Questa è la pagina di gestione dei contenuti web delle categorie di notizie.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.notizie.form.contenuti.php
Questa è la macro della pagina di gestione dei contenuti delle notizie.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.notizie.form.sem.php
Questa è la macro della pagina di gestione SEM/SMM delle notizie.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.notizie.form.web.php
Questa è la macro della pagina di contenuti web delle notizie.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.pagine.form.contenuti.php
Questa è la macro della pagina di gestione dei contenuti delle pagine.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.pagine.form.javascript.php
Questa è la macro della scheda di gestione del javascript della pagina di gestione delle pagine.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.pagine.form.macro.php
Questa è la macro della scheda di gestione delle macro della pagina di gestione delle pagine.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.pagine.form.metadati.php
Questa è la macro della scheda di gestione metadati della pagina di gestione delle pagine.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_contenuti.pagine.form.sem.php
Quesa è la macro della pagina di gestione SEM/SMM delle pagine.

### /_mod/_CO000.contenuti/_src/_inc/_macro/_mail.template.form.contenuti.php
Questa è la macro della scheda contenuti della pagina di gestione dei template mail.

### /_mod/_CO000.contenuti/_src/_inc/_pages/_catalogo.it-IT.php
Questo file contiene le dichiarazioni delle pagine di gestione contenuti del catalogo prodotti.

### /_mod/_CO000.contenuti/_src/_inc/_pages/_contenuti.it-IT.php
Qui vengono definite le pagine del modulo contenuti.

### /_mod/_CO000.contenuti/_src/_inc/_pages/_mail.it-IT.php
Questo file contiene la dichiarazione delle pagine di gestione contenuti dei template mail.

### /_mod/_CT000.contatti/_src/_config/_030.common.php
In questo file vengono definiti i moduli di contatto standard del framework.

### /_mod/_CT000.contatti/_src/_config/_035.common.php
In questo file le configurazioni presenti in $cx vengono unite a $cf, inoltre $ct viene collegato a $cf tramite puntatore.

### /_mod/_CT000.contatti/_src/_config/_750.controller.php
Questa è la controller del modulo contatti, si occupa di gestire in primo luogo le richieste che arrivano dai moduli presenti
sul sito valutandole in base al prefisso __ct__.

### /_mod/_CT000.contatti/_src/_inc/_controllers/_form/_default.php
Questa è la controller standard del modulo di contatti di default.

### /_mod/_CT000.contatti/_src/_inc/_macro/_contenuti.contatti.form.archiviazione.php
Questa è la macro della pagina archiviazione della gestione contatti.

### /_mod/_CT000.contatti/_src/_inc/_macro/_contenuti.contatti.form.dati.php
Questa è la macro della pagina di gestione dati della gestione contatti.

### /_mod/_CT000.contatti/_src/_inc/_macro/_contenuti.contatti.form.php
Questa è la macro della pagina di gestione contatti.

### /_mod/_CT000.contatti/_src/_inc/_macro/_contenuti.contatti.form.tools.php
Questa è la macro della pagina strumenti della gestione contatti.

### /_mod/_CT000.contatti/_src/_inc/_macro/_contenuti.contatti.tools.php
Questa è la macro della pagina degli strumenti della view contatti.

### /_mod/_CT000.contatti/_src/_inc/_macro/_contenuti.contatti.view.archiviati.php
Questa è la macro della view dei contatti archiviati.

### /_mod/_CT000.contatti/_src/_inc/_macro/_contenuti.contatti.view.php
Questa è la macro della view dei contatti.

### /_mod/_CT000.contatti/_src/_inc/_pages/_contenuti.it-IT.php
Qui vengono definite le pagine del modulo contatti.

### /_mod/_CT000.contatti/_src/_lib/_mysql.utils.add.php
Questa libreria contiene funzioni specifiche per i contatti da aggiungere a /_src/_lib/_mysql.tools.php.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.aggregate.php
Questa è la macro della scheda aggregate della pagina di gestione delle righe dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.php
Questa è la macro della pagina di gestione delle righe dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.stampe.php
Questa è la macro della scheda stampe della pagine di gestione delle righe dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione delle righe dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.view.php
Questa è la macro della view delle righe dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.archiviazione.php
Questa è la macro della scheda archiviazione della pagina di gestione documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.documenti.articoli.php
Questa è la macro della scheda articoli della pagina di gestione documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.evasione.php
Questa è la macro della scheda evasione della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.pagamenti.php
Questa è la macro della scheda pagamenti della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.php
Questa è la macro della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.relazioni.php
Questa è la macro della scheda relazioni della pagina di gestione documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.form.php
Questa è la macro della pagina di gestione dei pagamenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione dei pagamenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.view.php
Questa è la macro della view dei pagamenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.view.php
Questa è la macro della view dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_pages/_amministrazione.it-IT.php
Questa è la macro della dashboard dell'amministrazione.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.articoli.view.php
Questa è la macro della view delle righe delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.archiviazione.php
Questa è la macro della scheda archiviazione della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.documenti.articoli.php
Questa è la macro della scheda articoli della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.pagamenti.php
Questa è la macro della scheda pagamenti della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.php
Questa è la macro della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.relazioni.php
Questa è la macro della scheda relazioni della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.pagamenti.view.php
Questa è la macro della view dei pagamenti delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.tools.php
Questa è la macro della scheda strumenti della view delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.view.archiviate.php
Questa è la macro della scheda archivio della view delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.view.php
Questa è la macro della view delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_pages/_amministrazione.it-IT.php
In questo file vengono dichiarate le pagine relative alle fatture per il modulo amministrazione.

### /_mod/_DO040.offerte/_src/_inc/_pages/_commerciale.it-IT.php
In questo file vengono dichiarate le pagine relative alle offerte per il modulo commerciale.

### /_mod/_FI000.file/_src/_inc/_controllers/_file.before.php
Questa controller viene innescata al before per ogni elaborazione della tabella file.

### /_mod/_FI000.file/_src/_inc/_macro/_contenuti.archivio.file.form.php
Questa è la macro della pagina di gestione dei file nell'archivio contenuti.

### /_mod/_FI000.file/_src/_inc/_macro/_contenuti.archivio.file.form.tools.php
Questa è la macro della pagina degli strumenti della gestione dei file nell'archivio contenuti.

### /_mod/_FI000.file/_src/_inc/_macro/_contenuti.archivio.file.view.php
Questa è la macro della vista dei file nell'archivio contenuti.

### /_mod/_FI000.file/_src/_inc/_macro/_mail.out.form.file.php
Questa è la macro di gestione dei file nella gestione delle mail in uscita.

### /_mod/_FI000.file/_src/_inc/_macro/_mail.sent.form.file.php
Questa è la macro di gestione dei file nella gestione delle mail inviate.

### /_mod/_FI000.file/_src/_inc/_macro/_mail.template.form.file.php
Questa è la macro della gestione file associati a un template mail.

### /_mod/_FI000.file/_src/_inc/_pages/_contenuti.it-IT.php
In questo file vengono definite le pagine del modulo file relative ai contenuti.

### /_mod/_FI000.file/_src/_inc/_pages/_mail.it-IT.php
In questo file vengono definite le pagine del modulo file relative alle mail.

### /_mod/_IM000.immagini/_src/_api/_task/_images.resize.php
Questo task seleziona un'immagine e la ridimensiona. Il framework supporta un meccanismo di scalatura automatica delle immagini
piuttosto sofisticato, oltre a un sistema per la conversione delle immagini in formato webp. Per maggiori dettagli sulla gestione
delle immagini da parte del framework si veda, oltre alla documentazione di questo file, anche quella dei file
/_src/_config/_360.image.php e /_src/_config/_365.image.php.

### /_mod/_IM000.immagini/_src/_inc/_macro/_anagrafica.form.immagini.php
Questa è la macro della scheda di gestione immagini dell'anagrafica.

### /_mod/_IM000.immagini/_src/_inc/_macro/_catalogo.articoli.form.immagini.php
Questa è la macro della scheda di gestione immagini della pagina di gestione articoli.

### /_mod/_IM000.immagini/_src/_inc/_macro/_catalogo.categorie.prodotti.form.immagini.php
Questa è la macro della scheda di gestione immagini della pagina di gestione delle categorie prodotti.

### /_mod/_IM000.immagini/_src/_inc/_macro/_catalogo.prodotti.form.immagini.php
Questa è la macro della scheda di gestione immagini della pagina di gestione dei prodotti.

### /_mod/_IM000.immagini/_src/_inc/_macro/_contenuti.archivio.immagini.form.php
Questa è la macro della pagina di gestione immagini dell'archivio contenuti.

### /_mod/_IM000.immagini/_src/_inc/_macro/_contenuti.archivio.immagini.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione immagini dell'archivio contenuti.

### /_mod/_IM000.immagini/_src/_inc/_macro/_contenuti.archivio.immagini.view.php
Questa è la macro della vista immagini dell'archivio contenuti.

### /_mod/_IM000.immagini/_src/_inc/_macro/_contenuti.categorie.notizie.form.immagini.php
Questa è la macro della scheda di gestione immagini della pagina di gestione delle categorie notizie.

### /_mod/_IM000.immagini/_src/_inc/_macro/_contenuti.notizie.form.immagini.php
Questa è la macro della scheda immagini della pagina di gestione delle notizie.

### /_mod/_IM000.immagini/_src/_inc/_macro/_contenuti.pagine.form.immagini.php
Questa è la macro della scheda immagini della pagina di gestione dei contenuti.

### /_mod/_IM000.immagini/_src/_inc/_pages/_anagrafica.it-IT.php
In questo file vengono definite le pagine relative alle immagini per l'anagrafica.

### /_mod/_IM000.immagini/_src/_inc/_pages/_catalogo.it-IT.php
In questo file vengono definite le pagine relative alle immagini per il catalogo.

### /_mod/_IM000.immagini/_src/_inc/_pages/_contenuti.it-IT.php
In questo file vengono definite le pagine relative alle immagini per i contenuti.

### /_mod/_MA000.mail/_src/_api/_task/_mail.queue.clean.out.php
Questo task pulisce la coda delle mail in uscita.

### /_mod/_MA000.mail/_src/_api/_task/_mail.queue.clean.sent.php
Questo task pulisce la coda delle mail inviate.

### /_mod/_MA000.mail/_src/_api/_task/_mail.queue.resend.php
Questo task riaccoda per l'invio una mail già inviata.

### /_mod/_MA000.mail/_src/_api/_task/_mail.queue.send.php
Questo task elabora la coda delle mail in uscita, inviando il primo messaggio in lista.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.out.after.php
Questa è la controller che interviene dopo l'elaborazione di ogni oggetto della coda delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.out.before.php
Questa è la controller che viene eseguita prima dell'elaborazione di ogni oggetto della coda delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.out.finally.php
Questa controller viene eseguita alla fine di tutte le elaborazioni della coda delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.sent.after.php
Questa controller viene eseguita dopo l'elaborazione di ogni oggetto della coda delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.sent.before.php
Questa controller viene eseguita prima di ogni elaborazione della coda delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.sent.finally.php
Questa controller viene eseguita alla fine delle elaborazioni di ogni oggetto della coda delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.out.form.php
Questa è la macro del modulo di gestione delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.out.form.tools.php
Questa è la macro della scheda tools del modulo di gestione delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.out.view.php
Questa è la macro della view delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.sent.form.php
Questa è la macro del modulo di gestione delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.sent.form.tools.php
Questa è la macro della scheda tools del modulo di gestione delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.sent.view.php
Questa è la macro della view delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.tools.php
Questa è la macro della scheda strumenti della coda delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_pages/_mail.it-IT.php
In questo file vengono definite le pagine del modulo mail.

### /_mod/_NO000.notizie/_src/_config/_030.common.php
In questo file vengono definite le variabili comuni e le costanti di base del modulo notizie.

### /_mod/_NO000.notizie/_src/_config/_035.common.php
In questo file le configurazioni comuni del modulo notizie vengono integrate con le configurazioni da file.

### /_mod/_NO000.notizie/_src/_config/_310.pages.php
Questo file si occupa di caricare i dati relativi all'albero delle categorie di notizie e delle notizie nell'albero generale
dei contenuti del sito.

### /_mod/_NO000.notizie/_src/_config/_420.pages.php
In questo file vengono caricati i dati specifici della categoria di notizie o della notizia correntemente visualizzata.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.categorie.notizie.form.archiviazione.php
Questa è la macro della scheda archiviazione del modulo di gestione delle categorie di notizie.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.categorie.notizie.form.php
Questa è la macro della pagina di gestione delle categorie di notizie.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.categorie.notizie.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione delle categorie di notizie.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.categorie.notizie.tools.php
Questa è la macro della scheda strumenti della vista delle categorie di notizie.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.categorie.notizie.view.archiviate.php
Questa è la macro della view delle categorie di notizie archiviate.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.categorie.notizie.view.php
Questa è la macro della view delle categorie di notizie.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.notizie.form.archiviazione.php
Questa è la macro della scheda archiviazione del modulo di gestione delle notizie.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.notizie.form.php
Questa è la macro del modulo di gestione delle notizie.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.notizie.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione delle notizie.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.notizie.tools.php
Questa è la macro della scheda strumenti della view delle notizie.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.notizie.view.archiviate.php
Questa è la macro della view delle notizie archiviate.

### /_mod/_NO000.notizie/_src/_inc/_macro/_contenuti.notizie.view.php
Questa è la macro della view delle notizie.

### /_mod/_NO000.notizie/_src/_inc/_pages/_contenuti.it-IT.php
In questo file vengono definite le pagine relative ai contenuti del modulo notizie.

### /_mod/_NO000.notizie/_src/_lib/_mysql.utils.add.php
Questa è una libreria di funzioni aggiuntive per MySQL del modulo notizie.

### /_mod/_PA000.pagine/_src/_config/_310.pages.php
In questo file la struttura delle pagine viene caricata nell'albero dei contenuti del sito.

### /_mod/_PA000.pagine/_src/_config/_420.pages.php
In questo file vengono caricati i dati specifici della pagina corrente.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.archivio.menu.view.php
Questa è la macro della view dei menu dell'archivio contenuti.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.form.archiviazione.php
Questa è la macro della scheda archiviazione del modulo di gestione delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.form.menu.php
Questa è la macro della scheda menu del modulo di gestione delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.form.php
Questa è la macro del modulo di gestione delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.tools.php
QUesta è la macro della scheda strumenti della view delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.view.archiviate.php
Questa è la macro della view delle pagine archiviate.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.view.php
Questa è la macro della view delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_pages/_contenuti.it-IT.php
In questo file vengono deifinite le pagine relative alla gestione delle pagine.

### /_mod/_PA000.pagine/_src/_lib/_mysql.utils.add.php
Questa è una libreria di funzioni MySQL aggiuntive del modulo pagine.

### /_mod/_PR000.prodotti/_src/_config/_030.common.php
In questo file vengono definite le variabili comuni del modulo prodotti.

### /_mod/_PR000.prodotti/_src/_config/_035.common.php
In questo file la configurazione comune del modulo prodotti viene integrata con la configurazione letta da file.

### /_mod/_PR000.prodotti/_src/_config/_310.pages.php
In questo file l'albero delle categorie dei prodotti e dei prodotti viene integrato con l'albero generale dei
contenuti del sito.

### /_mod/_PR000.prodotti/_src/_inc/_controllers/_articoli.finally.php
Questa controller viene eseguita alla fine di ogni gruppo di elaborazioni della tabella articoli.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.archiviazione.php
Questa è la macro della scheda archiviazione del modulo di gesitmà

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.caratteristiche.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.distinta.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.relazioni.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.tools.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.view.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.archiviazione.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.prodotti.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.tools.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.tools.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.view.archiviati.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.view.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.form.archiviazione.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.form.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.form.tools.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.tools.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.view.archiviati.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.view.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.archiviazione.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.articoli.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.caratteristiche.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.categorie.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.relazioni.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.tools.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.tools.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.view.archiviati.php
### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.view.php
### /_mod/_PR000.prodotti/_src/_inc/_pages/_catalogo.it-IT.php
### /_mod/_PR000.prodotti/_src/_lib/_mysql.utils.add.php
### /_mod/_TE000.template/_src/_inc/_macro/_mail.template.form.php
### /_mod/_TE000.template/_src/_inc/_macro/_mail.template.form.tools.php
### /_mod/_TE000.template/_src/_inc/_macro/_mail.template.view.php
### /_mod/_TE000.template/_src/_inc/_pages/_mail.it-IT.php
### /_mod/_TE000.template/_src/tpl/athena/mail.template.form.twig
### /_mod/_VI000.video/_src/_inc/_macro/_anagrafica.form.video.php
### /_mod/_VI000.video/_src/_inc/_macro/_catalogo.articoli.form.video.php
### /_mod/_VI000.video/_src/_inc/_macro/_catalogo.categorie.prodotti.form.video.php
### /_mod/_VI000.video/_src/_inc/_macro/_catalogo.prodotti.form.video.php
### /_mod/_VI000.video/_src/_inc/_macro/_contenuti.archivio.video.form.php
### /_mod/_VI000.video/_src/_inc/_macro/_contenuti.archivio.video.form.tools.php
### /_mod/_VI000.video/_src/_inc/_macro/_contenuti.archivio.video.view.php
### /_mod/_VI000.video/_src/_inc/_macro/_contenuti.categorie.notizie.form.video.php
### /_mod/_VI000.video/_src/_inc/_macro/_contenuti.notizie.form.video.php
### /_mod/_VI000.video/_src/_inc/_macro/_contenuti.pagine.form.video.php
### /_mod/_VI000.video/_src/_inc/_pages/_anagrafica.it-IT.php
### /_mod/_VI000.video/_src/_inc/_pages/_catalogo.it-IT.php
### /_mod/_VI000.video/_src/_inc/_pages/_contenuti.it-IT.php

### /_src/_config.php
Questo file costituisce il kernel del framework; è ampiamente documentato quindi si rimanda al sorgente per gli approfondimenti, in breve
comunque il suo compito è quello di includere tutti i componenti del framework per renderli disponibili al successivo codice sorgente. Qualsiasi
file PHP nel quale si desidera utilizzare il framework deve iniziare o comunque contenere la riga:

```
require '<percorso>_config.php';
```

Laddove <percorso> è il percorso necessario a raggiungere il file /_src/_config.php. Per complicare un po' le cose, il framework potrebbe essere
installato in una sotto cartella della document root, in questo caso è più sicuro usare:

```
// inclusione del framework
if( ! defined( 'INCLUDE_SUBDIR' ) ) {
    require '<percorso>_config.php';
} else {
    require INCLUDE_SUBDIR . '_config.php';
}
```

Laddove INCLUDE_SUBDIR è una costante definita dal file che chiama il framework dalla document root. Questo scenario di funzionamento è tipico del
server web Nginx, che differentemente da Apache non supporta i file .htaccess e quindi richiede che tutto il routing sia effettuato tramite il file
/index.php.

### /_src/_api/_bookmarks.php
Questa API si occupa di gestire la memorizzazione di elementi nello spazio di lavoro della sessione. Il meccanismo del "pin" di elementi in sessione
è molto comodo per portarsi dietro delle informazioni da una maschera all'altra, dove previsto dalla maschera stessa. Per ulteriori informazioni su
questo meccanismo si veda anche la documentazione dei file /_src/_config/_710.session.php e /_src/_config/_715.session.php, e dei file
/_src/_config/_770.bookmarks.php e /_src/_config/_775.bookmarks.php.

### /_src/_api/_cron.php
Questa API si occupa di eseguire i task periodici; solitamente viene richiamata dal cron di sistema tramite un file appositamente creato nella cartella
/etc/cron.d/. La creazione di questo file può essere eseguita in maniera semi automatica tramite lo script /_src/_sh/_crontab.install.sh. La gestione
dei task periodici è piuttosto complessa, per ulteriori dettagli si veda la documentazione del file /_src/_api/_cron.php.

### /_src/_api/_download.php
Questo file si occupa di erogare i download, verificando che l'utente sia autorizzato a scaricare il file che sta richiedendo; riceve le richieste
dalle regole del file .htaccess e fatti i dovuti controlli restituisce il file richiesto. Agisce in pratica come un guardiano della cartella
/var che contiene ordinati in sottocartelle i file caricati tramite il CMS. Si noti che alcune sotto cartelle di /var (come /var/log) sono protette
e l'accesso è impedito da regole apposite all'inizio di /.htaccess.

### /_src/_api/_job.php
Questa API consente l'esecuzione dei job in foreground; per ulteriori informazioni si veda la documentazione del file stesso oltre a quella del
file /_src/_api/_cron.php.

### /_src/_api/_osm.php
Questa API funge da proxy per le tele OSM, in modo da non sovraccaricare i server OSM.

### /_src/_api/_pages.php
Questo file ha lo scopo di renderizzare e erogare le pagine. Svolge numerose funzioni ed è ampiamente documentato, quindi si rimanda al sorgente
per i dettagli. In sintesi, riceve le richieste di pagina in base alle regole del file /.htaccess e le soddisfa tramite le informazioni in suo
possesso.

### /_src/_api/_rest.php
Questa API fondamentale per il funzionamento del framework gestisce tutte le chiamate REST in entrata. Per maggiori dettagli si rimanda alla
lettura del codice dell'API stessa.

### /_src/_api/_upload.php
Questa API è la controparte dell'uploader Javascript creato da /_src/_js/_lib/_uploader.js e si occupa di ricevere i dati e salvarli su disco.
Per maggiori dettagli si rimanda al codice dell'API stessa e al codice di /_src/_js/_lib/_uploader.js.

### /_src/_api/_user.php
Questa API consente il login dell'utente, è utilizzata per le integrazioni e per il dialogo con app e altri sistemi esterni. Tramite il meccanismo di
login è possibile ottenere un'API key temporanea per fare più rapidamente le chiamate successive. Per ulteriori dettagli sul meccanismo di login
tramite API key si vedano i commenti a questo file e ai file dev/_src/_config/_210.auth.php e dev/_src/_config/_220.auth.php.

### /_src/_api/_job/_test.job.php
Questo è un job di test.

### /_src/_api/_print/_default.csv.php
Questa stampa consente di stampare in CSV tutte le view del framework; è collegata al tasto "esporta in CSV" che si trova nelle view standard.

### /_src/_api/_report/_cookie.php
Questo report restituisce l'elenco di tutti i cookie presenti nel browser per il dominio corrente indicando se sono gestiti o meno dal
framework, il loro scopo e altre informazioni utili. Per accedere al report utilizzare il percorso /report/cookie.

### /_src/_api/_report/_import.php
Questo report innesca l'importazione dei file presenti in /var/spool/import/todo/*/ e /var/spool/import, e restituisce un report dettagliato delle
operazioni svolte. Normalmente l'importazione dei file è svolta dall'API cron, ma questo report può essere fondamentale per lo sviluppo, il test
e il debug dei nuovi tracciati di importazione. Per accedere al report utilizzare il percorso /report/import.

### /_src/_api/_status/_cf.php
Questa API di stato restituisce il contenuto, navigabile, dell'array $cf. Tutti i dati sensibili sono censurati tramite la funzione core array2censored()
per evitare problemi di sicurezza. Tramite una regola di /.htaccess l'accesso a questa API è possibile tramite l'URL speciale /cf.

### /_src/_api/_status/_framework.php
Questa API restituisce un report di auto diagnostica del framework, indicando lo stato corrente della piattaforma ed eventuali errori o warning. Si
tratta di un file piuttosto complesso, al cui sorgente si rimanda per approfondimenti. Una regola di /.htaccess rende disponibile questa API all'URL
speciale /status.

### /_src/_api/_status/_session.php
Questa API restituisce informazioni minimali sulla sessione corrente e viene interrogata in background dal template Athena (vedi il codice di
/_src/_tpl/_athena/src/js/main.js dove viene chiamata come /status/session).

### /_src/_api/_task/_framework.setup.php
TODO Questo task è ancora da implementare.

### /_src/_api/_task/_geografia.importazione.php
Questo task, piuttosto semplice, scarica i dati relativi alla geografia dalla versione corrente del framework:

- https://dataserver.istricesrl.com/geografia/01.update.stati.csv
- https://dataserver.istricesrl.com/geografia/02.update.regioni.csv
- https://dataserver.istricesrl.com/geografia/03.update.provincie.csv
- https://dataserver.istricesrl.com/geografia/04.update.comuni.csv

e li copia nella cartella DIR_VAR_SPOOL_IMPORT per sfruttare il normale sistema di importazione automatica dei file CSV del framework
(dev/_src/_config/_740.controller.php) e aggiornare le informazioni relative alla geografia per il deploy corrente.

### /_src/_api/_task/_log.clean.php
Questo semplice task si occupa di pulire la cartella /log; può funzionare in modalità soft (cancella solo i log nella cartella principale) o hard
(cancella ricorsivamente tutti i log).

### /_src/_api/_task/_memcache.clean.php
Questo task si occupa semplicemente di svuotare la memoria di memcache.

### /_src/_api/_task/_mysql.patch.php
Questo task si occupa di installare e aggiornare il database MySQL del deploy corrente. La logica di aggiornamento del database è piuttosto complessa ma
funzionale allo scopo di tenere aggiornati tutti i database di tutti i deploy senza dover eseguire le query a mano. Le componenti del sistema sono:

- l'API /_src/_api/_task/_mysql.patch.php
- i file di patch presenti in /_usr/_database/_patch

Il meccanismo di patch del database è illustrato nel dettaglio nel file /_src/_api/_task/_mysql.patch.php al quale si rimanda per approfondimenti.

### /_src/_api/_task/_pages.cache.clean.php
Questo task elimina la cache statica delle pagine (/var/cache/pages).

### /_src/_api/_task/_sitemap.clean.php
Questo task si occupa di eliminare le sitemap (da /var/sitemap).

### /_src/_api/_task/_test.cron.php
Questo è un semplice task di test, utile per verificare il funzionamento del sistema dei task ricorrenti; non fa altro che scrivere su un file di log quando
viene eseguito, in questo modo è facile fare dei test e del debug sul meccanismo dei task.

### /_src/_api/_task/_test.job.start.php
Questo task avvia un job di test.

### /_src/_api/_task/_twig.cache.clean.php
Questo task svuota la cache di Twig (/var/cache/twig).

### /_src/_config/_000.debug.php
Questo file di configurazione inizializza l'array $cf['debug'] e setta i default per le sue chiavi principali.

### /_src/_config/_005.debug.php
Questo file di configurazione integra $cf['debug'] con $cx['debug'] e collega $cf['debug'] a $ct['debug'].

### /_src/_config/_010.site.php
In questo file viene inizializzato l'array $cf['sites'] e viene definito il sito di default.

### /_src/_config/_015.site.php
In questo file l'array $cf['sites'] viene integrato con $cx['sites'] e $cf['sites'] viene collegato a $ct['sites']. Viene inoltre elaborato l'URL
corrente per capire in quale sito ci si trova, e popolato di conseguenza l'array $cf['site'].

### /_src/_config/_020.debug.php
In questo file vengono applicati i settaggi relativi al debug impostati precedentemente.

### /_src/_config/_025.site.php
In questo file vengono elaborate diverse impostazioni di $cf['site'] ricavate dai dati settati in precedenza; viene anche integrato l'array $cf['site'] con
$cx['site'] e infine $cf['site'] viene collegato a $ct['site'].

### /_src/_config/_030.common.php
In questo file vengono settate diverse variabili di utilità generale in $cf['common'] fra cui i codici di stato HTTP e il Lorem Ipsum visto sopra; vengono
inoltre recuperati i numeri di versione e release correnti e quelli del deploy corrente.

### /_src/_config/_035.common.php
In questo file l'array $cf['common'] viene integrato con $cx['common'] e collegato successivamente a $ct['common0].

### /_src/_config/_040.cache.php
In questo file vengono definite le configurazioni per le cache in uso sul sito. GlisWeb supporta Memcache, Redis, APCU e caching su disco.

### /_src/_config/_045.cache.php
In questo file vengono integrati i dati da $cx per le varie cache, effettuate le connessioni ai server di cache, collegati i profili e gli array $cf a $ct
relativamente alle varie cache. Da questo runlevel in poi il caching è disponibile.

### /_src/_config/_050.session.php
In questo file viene configurata la sessione PHP per utilizzare come backend in ordine di preferenza Redis, Memcache e il disco fisso.

### /_src/_config/_055.session.php
In questo file viene avviata la sessione PHP, quindi a partire da questo runlevel la sessione è disponibile. Vengono anche collegati $_SESSION a $cf['session']
e $cf['session'] a $ct['session'].

### /_src/_config/_060.privacy.php
TODO Questo runlevel e questa factory sono da riprogettare e migliorare.

### /_src/_config/_065.privacy.php
In questo file l'array $cf['privacy'] viene integrato con $cx['privacy'], con $cf['site']['privacy'] e con $_COOKIE['privacy']; viene inoltre collegato
a $ct['privacy']. Questo file gestisce inoltre l'invio dei moduli di consenso cookie $_REQUEST['__cookie__'] salvando le preferenze dell'utente in $cf['privacy']['cookie'].

### /_src/_config/_070.cache.php
Questo file si occupa di verificare se la risorsa richiesta dall'utente è presente nella cache statica dei contenuti, e nel caso la restituisce, interrompendo di fatto
l'esecuzione del framework. Questo è un importante meccanismo di risparmio delle risorse server, in quanto evita che vengano svolte operazioni potenzialmente onerose e di
fatto inutili, come la connessione al database.

### /_src/_config/_080.localization.php
In questo file viene creato e configurato l'array $cf['localization'], che contiene le informazioni relative alla localizzazione del framework. GlisWeb è nativamente
multilingua e il supporto per la localizzazione e la traduzione fa parte delle sue caratteristiche base.

### /_src/_config/_085.localization.php
In questo file l'array $cf['localization'] viene integrato con $cx['localization'] e collegato a $ct['localization'], dopodiché viene individuata la lingua corrente
tramite varie strategie.

### /_src/_config/_090.translation.php
In questo file viene creato l'array $cf['tr'] e vengono importati i dizionari presenti in /_etc/_dictionaries.

### /_src/_config/_095.translation.php
In questo file l'array $cf['tr'] viene integrato con $cx['tr'] e collegato a $ct['tr'].

### /_src/_config/_100.security.php
Questo file è vuoto e serve per le customizzazioni.

### /_src/_config/_110.google.php
In questo file vengono definiti i profili per i servizi Google sotto $cf['google']['profiles'].

### /_src/_config/_115.google.php
In questo file l'array $cf['google'] viene integrato con $cx['google'] e collegato a $ct['google']; inoltre viene collegato il profilo Google
per lo status corrente a $cf['google']['profile'].

### /_src/_config/_120.mysql.php
In questo file vengono definiti i server e i profili MySQL; viene inizializzato l'array $cf['mysql'].

### /_src/_config/_125.mysql.php
In questo file l'array $cf['mysql'] viene integrato con $cx['mysql'] e collegato a $ct['mysql']; viene inoltre collegato il profilo MySQL corrente
a $cf['mysql']['profile'], e infine vengono effettuate tutte le connessioni. Da questo runlevel in poi la connessione al database è disponibile
tramite la chiave $cf['mysql']['connection'].

### /_src/_config/_130.redirect.php
In questo file viene inizializzato l'array $cf['redirect'] dopodiché viene popolato con i dati eventualmente presenti nel file FILE_REDIRECT e
nella vista redirect_view del database.

### /_src/_config/_135.redirect.php
In questo file i redirect prelevati da filesystem e quelli prelevati da database vengono indicizzati in un unico array $cf['redirect']['index'].
L'array $cf['redirect'] viene integrato con $cx['redirect']; infine, viene verificato se l'URL corrente corrisponde a un redirect, e nel caso
la redirezione viene applicata tramite header http. In caso di redirect, l'esecuzione del framework termina qui.

### /_src/_config/_140.session.php
In questo file vengono gestiti i tag UTM in $cf['session']['utm'] e inizializzate le impostazioni per l'anti spam in $cf['session']['spam'].

### /_src/_config/_160.microsoft.php
In questo file vengono dichiarate le variabili relative ai profili Microsoft.

### /_src/_config/_165.microsoft.php
In questo file vengono applicate le configurazioni relative ai profili Microsoft.

### /_src/_config/_180.privacy.php
In questo file vengono lette dal database le impostazioni di privacy dei moduli e vengono riportate su $cf['privacy']['moduli']. Si noti che la parte relativa alla privacy è tuttora in costante sviluppo.

### /_src/_config/_190.localization.php
In questo file le informazioni di localizzazione vengono integrate con le informazioni presenti sul database.

### /_src/_config/_195.localization.php
In questo file vengono applicate le impostazioni relative alla lingua corrente.

### /_src/_config/_200.auth.php
In questo file vengono inizializzati gli array che servono per l'autenticazione sul framework; in particolare vengono aggiunti gli
utenti a $cf['auth']['accounts'] e i gruppi a $cf['auth']['groups']. I privilegi vengono inseriti in $cf['auth']['privileges']. I profili
di creazione degli account vengono inseriti in $cf['auth']['profili']. Secondariamente, viene inizializzato il salt per JWT. Ulteriori
dettagli sul funzionamento del sistema di autenticazione del framework possono essere reperite proprio nei commenti di questo file.

### /_src/_config/_205.auth.php
In questo file l'array $cf['auth'] viene integrato con $cx['auth'].

### /_src/_config/_210.auth.php
In questo file vengono svolte le operazioni di login. Le opzioni per identificare e autenticare gli utenti nel framework sono diverse e
comprendono:

- basic HTTP auth
- token JWT
- bearer token
- username e password

Gli utenti e tutte le relative informazioni possono essere letti dal database o dai file di configurazione. È una prassi comune e raccomandata
definire tramite file di configurazione l'utente root, in modo da poter accedere al framework anche in caso di malfunzionamento del database.

### /_src/_config/_220.auth.php
In questo file vengono gestiti il timeout della sessione e il logout.

### /_src/_config/_250.auth.php
In questo file viene dichiarato l'array $cf['auth']['permissions'] che definisce quali permessi hanno gli utenti su tutte le entità gestite
dal framework.

### /_src/_config/_255.auth.php
In questo file se c'è un login in corso vengono applicati i permessi all'account che si è appena connesso, in base a quanto stabilito dal runlevel
_250.auth.php.

### /_src/_config/_300.pages.php
In questo file viene verificato se i contenuti del sito sono già presenti in cache. Se lo sono, la chiave $cf['contents']['cached'] viene impostata
a false e il successivo runlevel _310.pages.php viene eseguito per intero. Viceversa, il grosso delle elaborazioni del runlevel _310.pages.php
viene saltato se i contenuti sono presenti in cache. I contenuti che vengono salvati in cache sono:

- $cf['contents']['cached']
- $cf['contents']['updated']
- $cf['contents']['pages']
- $cf['contents']['tree']
- $cf['contents']['index']
- $cf['contents']['reverse']
- $cf['contents']['shortcuts']

Per ulteriori dettagli si vedano i commenti al codice.

### /_src/_config/_310.pages.php
In questo file vengono letti tutti i file di configurazione delle pagine, popolando $cf['contents']['pages'] che viene poi successivamente integrato
da $cx['contents'] e da $cf['site']['contents'] se presenti. Al termine di questo runlevel tutti i dati delle pagine sono caricati e pronti per
l'indicizzazione e l'elaborazione.

### /_src/_config/_320.pages.php
In questo file l'elenco delle pagine viene elaborato per popolare alcuni indici necessari al funzionamento del sito, che sono:

- $cf['contents']['tree']
- $cf['contents']['index']
- $cf['contents']['shortcuts']
- $cf['contents']['reverse']

Questi indici sono necessari per la decodifica dell'URL richiesto e per la creazione dell'albero delle pagine, sul quale poggiano diversi elementi
di navigazione, fra cui i menù e le briciole di pane.

### /_src/_config/_330.pages.php
In questo file tutti i dati elaborati finora sui contenuti vengono salvati in cahce (Memcache) per utilizzi successivi.

### /_src/_config/_340.sms.php
In questo file vengono definiti i template SMS utilizzati dal framework. I template vengono definiti come array PHP e integrati con
i template presenti nel database.

### /_src/_config/_350.mail.php
In questo file vengono definiti i template mail utilizzati dal framework. I template vengono definiti come array PHP e integrati con
i template presenti nel database.

### /_src/_config/_355.mail.php
In questo file $cf['mail'] viene integrato con $cx['mail'].

### /_src/_config/_360.image.php
In questo file vengono definiti i formati immagine supportati dal framework. Il framework implementa un meccanismo di auto scalamento
delle immagini per ottimizzare la banda e supportare i tag HTML5 responsivi; i dettagli riguardanti gli orientamenti e le dimensioni di 
scalatura sono definiti in questo file.

### /_src/_config/_365.image.php
In questo file l'array $cf['image'] viene integrato con $cx['image'] e collegato a $ct['image'].

### /_src/_config/_380.twig.php
In questo file vengono definiti i profili di funzionamento del template manager Twig.

### /_src/_config/_385.twig.php
In questo file l'array $cf['twig'] viene integrato con $cx['twig']; inoltre viene definito il profilo corrente $cf['twig']['profile'] come link a
$cf['twig']['profiles'][ $cf['site']['status'] ]. Infine viene verificato che la cartella della cache di Twig, se necessaria, esista.

### /_src/_config/_400.rewrite.php
In questo file viene fatto il parsing dell'URL richiesto dal client e determinata la pagina corrente. Questo è un file cruciale per il 
funzionamento del framework e dev'essere studiato assieme a /_src/_api/_pages.php.

### /_src/_config/_420.pages.php
Questo runlevel è dedicato alle elaborazioni specifiche relative alla pagina corrente; fra le varie cose, vengono create le shortcut $ct['pages']
come link a $cf['contents']['pages'] e $ct['page'] come link a $cf['contents']['page']. Vengono inoltre effettuate varie elaborazioni specifiche
della pagina, fra cui l'elaborazione del menù a schede (se presente).

In questo file vengono inoltre gestiti i comandi di una lettera, fondamentali per il debug. I comandi gestiti qui sono:

comando         | effetto
----------------|-------------------------------------------------
t               | modifica il template della pagina (es. ?t=minerva)
s               | modifica lo schema della pagina (es. ?s=schema-prova)
c               | modifica il tema della pagina (es. ?c=natale)
m               | inserisce del lorem ipsum in $ct['page']['content'][ $cf['localization']['language']['ietf'] ] (es. ?m=5)

### /_src/_config/_430.security.php
File inserito per retrocompatibilità e customizzazione.

### /_src/_config/_510.smtp.php
In questo file vengono definiti i server e i profili SMTP.

### /_src/_config/_515.smtp.php
In questo file l'array $cf['smtp'] viene integrato con $cx['smtp'] e con $cf['site']['smtp']. Viene inoltre salvato il profilo SMTP attivo
in $cf['smtp']['profile'] e il server SMTP di default in $cf['smtp']['server'].

### /_src/_config/_520.mapquest.php
In questo file vengono definiti i server e i profili Mapquest.

### /_src/_config/_525.mapquest.php
In questo file l'array $cf['mapquest'] viene integrato con $cx['mapquest'] e collegato tramite puntatore a $ct['mapquest']. Vengono inoltre
definiti il profilo corrente in $cf['mapquest']['profile'] e il server corrente in $cf['mapquest']['server'].

### /_src/_config/_540.sms.php
In questo file vengono definiti i server e i profili SMS.

### /_src/_config/_545.sms.php
In questo file l'array $cf['sms'] viene integrato con $cx['sms']. Vengono inoltre definiti il profilo corrente in $cf['sms']['profile']
e il server corrente in $cf['sms']['server'].

### /_src/_config/_550.slack.php
In questo file vengono definiti i server e i profili Slack.

### /_src/_config/_555.slack.php
In questo file l'array $cf['slack'] viene integrato con $cx['slack'] e $cf['site']['slack'] e collegato tramite puntatore a $ct['slack'].
Viene inoltre definito il profilo corrente in $cf['slack']['profile'].

### /_src/_config/_560.archivium.php
In questo file vengono definiti i server e i profili Archivium.

### /_src/_config/_565.archivium.php
In questo file l'array $cf['archivium'] viene integrato con $cx['archivium'] e $cx['site']['archivium']; viene inoltre collegato
$cf['archivium'] a $ct['archivium'] e viene definito il profilo corrente in $cf['archivium']['profile'].

### /_src/_config/_570.openai.php
In questo file vengono definiti i server e i profili OpenAI.

### /_src/_config/_575.openai.php
In questo file viene integrato l'array $cf['openai'] con $cx['openai']; viene inoltre collegato $cf['openai'] a $ct['openai'] tramite puntatore.
Infine vengono impostati il profilo e il server corrente rispettivamente in $cf['openai']['profile'] e $cf['openai']['server'].

### /_src/_config/_580.ftp.php
In questo file vengono definiti i server e i profili FTP.

### /_src/_config/_585.ftp.php
In questo file l'array $cf['ftp'] viene integrato con $cx['ftp'] e $cx['site]['ftp']. Vengono inoltre definiti il profilo corrente
in $cf['ftp']['profile'] e il server corrente in $cf['ftp']['server'].

### /_src/_config/_600.common.php
In questo file vengono definiti i profili di funzionamento per le integrazioni con TeamSystem e Zucchetti.

### /_src/_config/_605.common.php
In questo file vengono integrati con la configurazione da file i profili di funzionamento per le integrazioni con TeamSystem e Zucchetti,
e vengono definiti i profili correnti.

### /_src/_config/_610.paypal.php
In questo file vengono definiti i profili di funzionamento di PayPal. Questi profili sono utilizzati dal modulo pagamenti per gestire il saldo
dei pagamenti, e non sono collegati al modulo e-commerce.

### /_src/_config/_615.paypal.php
In questo file i dati di funzionamento di PayPal vengono integrati con le direttive da file di configurazione, generali e per sito.
Vengono inoltre definite le scorciatoie e collegato $cf['paypal'] a $ct['paypal'].

### /_src/_config/_620.amazon.php
In questo file vengono definiti i profili di funzionamento di Amazon.

### /_src/_config/_625.amazon.php
In questo file i dati di Amazon vengono integrati con le direttive presenti nei file di configurazione generali e per sito; vengono
create le scorciatoie e l'array $cf['amazon'] viene collegato a $ct['amazon'].

### /_src/_config/_640.facebook.php
In questo file vengono definiti i profili di funzionamento di Facebook.

### /_src/_config/_645.facebook.php
In questo file i dati di Facebook vengono integrati con le direttive di configurazione da file, generali e per sito. Vengono definite le
scorciatoie e l'array $cf['facebook'] viene collegato a $ct['facebook'].

### /_src/_config/_680.hotjar.php
In questo file vengono definiti i profili di funzionamento di Hotjar.

### /_src/_config/_685.hotjar.php
In questo file i dati di Hotjar vengono integrati con le configurazioni da file, generiche e per sito. Vengono configurate le scorciatoie
e l'array $cf['hotjar'] viene collegato a $ct['hotjar'].

### /_src/_config/_710.session.php
In questo file vengono inizializzati gli array $_SESSION['__view__'], $_SESSION['__work__'], $_REQUEST['__err__'] e _REQUEST['__info__'].

### /_src/_config/_715.session.php
In questo file gli array $_SESSION['__view__'] e $_SESSION['__work__'] vengono integrati e collegati a $_REQUEST['__view__'], $_REQUEST['__work__'].

### /_src/_config/_720.privacy.php
In questo file i cookie vengono indicizzati per ID.

### /_src/_config/_730.controller.php
In questo file vengono inclusi gli eventuali parser di pagina. I parser sono un meccanismo tramite il quale il framework pre elabora
i dati presenti in $_REQUEST per prepararli al lavoro dei runlevel successivi.

### /_src/_config/_740.controller.php
Questo file gestisce l'importazione di dati in batch. Il meccanismo è molto potente ma anche complesso, e si rimanda alla documentazione del
file per i dettagli.

### /_src/_config/_750.controller.php
Questo file si occupa di gestire i blocchi dati in entrata e passarli alla controller(). Questo è il meccanismo con cui il framework gestisce
la maggior parte dei blocchi data in ingresso.

### /_src/_config/_760.controller.php
Questo file nel framework base è inserito solo per consentirne la customizzazione. Questo è il punto dove svolgere tutte le operazioni successive
all'esecuzione della controller.

### /_src/_config/_770.bookmarks.php
Questo file imposta i gruppi dell'area di lavoro per cui possono essere pinnati degli elementi. Il meccanismo dei bookmarks, o elementi pinnati,
è dettagliatamente illustrato nei commenti di questo file e del successivo /_src/_config/_775.bookmarks.php. Si vedano anche i commenti all'API
/_src/_api/_bookmarks.php; si veda anche la documentazione dei file /_src/_config/_710.session.php e /_src/_config/_715.session.php.

### /_src/_config/_775.bookmarks.php
Questo file integra la configurazione di $cf['bookmarks'] con $cx['bookmarks'] e imposta il collegamento a puntatore fra $cf['bookmarks']
e $ct['bookmarks'].

### /_src/_config/_790.job.php
Questo file si occupa di selezionare i job in foreground e renderli disponibili in $cf['jobs']['foreground'] e tramite link simbolico
in $ct['jobs']['foreground'].

### /_src/_config/_920.privacy.php
Questo file è a disposizione per la customizzazione.

### /_src/_config/_940.session.php
In questo file vengono salvate diverse informazioni utili sulla sessione, fra cui la timestamp dell'ultimo utilizzo.

### /_src/_config/_980.sitemap.php
Questo file si occupa di generare, se necessario, le sitemap. Per ulteriori informazioni si veda la documentazione del file stesso.

### /_src/_config/_990.debug.php
Questo file serve per il debug generale dei runlevel, in quanto conclude l'esecuzione del kernel space del framework. Da qui in poi l'esecuzione
passa alle macro di pagina e dev'essere debuggata di conseguenza.

### /_src/_css/_back2top.css
In questo file viene definito lo stile CSS per il tasto "torna su".

### /_src/_css/_main.css
Questo file contiene gli stili di base validi per tutti i template.

### /_src/_css/_selectbox.css
Questo file contiene gli stili per la tendina intelligente (combobox).

### /_src/_css/_terminale.css
Questo file contiene gli stili per il terminale (va verificato che siano ancora necessari perché risalgono alla versione precedente del framework).

### /_src/_img/_favicon.ico
Questa è la favicon di default del framework. Riguardo alla favicon, si devono tenere presenti diversi file primo fra tutti il file /.htaccess che
effettua il routing da /favicon.ico a /_src/_img/_favicon.ico a meno che /favicon.ico non esista. Questo è un modo deprecato di customizzare la favicon
dato che è disponibile un meccanismo molto più avanzato che consente di fornire al browser formati diversi di favicon.

Le favicon custom vanno collocate nella cartella /img/favicons/ (oppure /img/favicons/<idSito>/) dove vengono cercate dal file dev/_src/_api/_pages.php
e in particolare vengono cercati questi file:

    - android-icon-36x36.png
    - android-icon-48x48.png
    - android-icon-72x72.png
    - android-icon-96x96.png
    - android-icon-144x144.png
    - android-icon-192x192.png
    - apple-icon.png
    - apple-icon-57x57.png
    - apple-icon-60x60.png
    - apple-icon-72x72.png
    - apple-icon-76x76.png
    - apple-icon-114x114.png
    - apple-icon-120x120.png
    - apple-icon-144x144.png
    - apple-icon-152x152.png
    - apple-icon-180x180.png
    - apple-icon-precomposed.png
    - favicon.ico
    - favicon-16x16.png
    - favicon-32x32.png
    - favicon-96x96.png
    - ms-icon-70x70.png
    - ms-icon-144x144.png
    - ms-icon-150x150.png
    - ms-icon-310x310.png

Dal momento che la creazione di così tante icone può risultare tediosa, è possibile avvalersi di strumenti come https://www.favicon-generator.org/ in
attesa che il framework implementi una propria gestione della scalatura delle favicon.

### /_src/_inc/_controllers/_default.after.php
Questa controller viene eseguita dopo ogni ciclo di lavoro della funzione controller().

### /_src/_inc/_controllers/_default.append.php
Questa controller viene eseguita durante ogni ciclo di lavoro della funzione controller(), dopo la composizione della query e prima della sua esecuzione.

### /_src/_inc/_controllers/_default.before.php
Questa controller viene eseguita prima di ogni ciclo di lavoro della funzione controller().

### /_src/_inc/_controllers/_default.finally.php
Questa controller viene eseguita dopo ogni gruppo di cicli di lavoro della funzione controller(), cioè dopo il ciclo principale e dopo tutti i sotto cicli
per i subform.

### /_src/_inc/_macro/_app.php
Questa è la macro di pagina di default della pagina app. In standard non prevede particolari funzionalità, ma è pensata per essere customizzata.

### /_src/_inc/_macro/_dashboard.php
Questa è la macro di pagina della dashboard, la pagina principale dell'area admin.

### /_src/_inc/_macro/_dashboard.tools.php
Questa è la macro di pagina della dashboard tools, la pagina di strumenti della dashboard.

### /_src/_inc/_macro/_delete.php
Questa è la macro della pagina di cancellazione del template Athena e si occupa fra le altre cose di chiedere la conferma all'utente prima della cancellazione.

### /_src/_inc/_macro/_password.reset.php
Questa macro si occupa di gestire il cambio password. Per maggiori dettagli si rimanda al codice della macro stessa.

### /_src/_inc/_macro/_phpinfo.php
Questa macro si limita a visualizzare l'output di phpinfo() e a terminare l'esecuzione del framework.

### /_src/_inc/_macro/_security.php
Questo file implementa il firewall applicativo del framework ed è quindi cruciale per la sua sicurezza. Viene incluso da /_src/_config.php e si occupa
di filtrare le richieste potenzialmente dannose. Per i dettagli del suo funzionamento si vedano i commenti al codice.

### /_src/_inc/_macro/_strumenti.php
Questa è la macro della pagina strumenti del template Athena.

### /_src/_inc/_macro/_default/_default.form.php
Questa macro contiene le logiche comuni a tutte le pagine di tipo form.

### /_src/_inc/_macro/_default/_default.form.multilingua.php
Questa macro contiene le logiche necessarie al funzionamento dei form multilingua.

### /_src/_inc/_macro/_default/_default.tools.php
Questo file è una macro di default inclusa soprattutto da pagine che utilizzano lo schema metro.

### /_src/_inc/_macro/_default/_default.view.php
Questa macro contiene le logiche comuni a tutte le pagine di tipo view.

### /_src/_inc/_pages/_app.en-GB.php
Questo file contiene la dichiarazione delle pagine della web app standard del framework in inglese.

### /_src/_inc/_pages/_app.it-IT.php
Questo file contiene la dichiarazione delle pagine della web app standard del framework in italiano.

### /_src/_inc/_pages/_dashboard.it-IT.php
Questo file contiene la dichiarazione delle pagine della dashboard del CMS.

### /_src/_inc/_pages/_delete.it-IT.php
Questo file contiene la dichiarazione della pagina di cancellazione del CMS.

### /_src/_inc/_pages/_null.it-IT.php
Questo file contiene la dichiarazione della pagina NULL utilizzata per l'errore HTTP 404.

### /_src/_inc/_pages/_password.it-IT.php
Questo file contiene la dichiarazione delle pagine per il reset della password.

### /_src/_inc/_pages/_site.it-IT.php
Questo file è vuoto in modo che possa essere facilmente customizzato.

### /_src/_inc/_pages/_strumenti.it-IT.php
Questo file contiene la dichiarazione delle pagine strumenti del CMS.

### /_src/_js/_main.js
Questa libreria Javascript contiene le funzioni di utilità generale del framework, nonché le operazioni da eseguire al caricamento del DOM.

### /_src/_js/_lib/_rest.js
Questa libreria Javascript contiene funzioni che semplificano l'interazione con gli endpoint REST.

### /_src/_js/_lib/_selectbox.js
Questa libreria Javascript implementa una semplice combobox per il framework.

### /_src/_js/_lib/_uploader.js
Questa libreria Javascript implementa un semplice file uploader per il framework.

### /_src/_lib/_acl.utils.php
Questa libreria contiene le funzioni di utilità per la gestione dei permessi degli utenti.

### /_src/_lib/_apcu.tools.php
Questa libreria contiene le funzioni per l'utilizzo della cache APCU.

### /_src/_lib/_array.tools.php
Questa libreria contiene una collezione di funzioni per la manipolazione degli array.

### /_src/_lib/_controller.tools.php
Questa libreria contiene la funzione controller() e le sue funzioni di appoggio.

### /_src/_lib/_cryptography.tools.php
Questa libreria contiene alcuni strumenti per la gestione della crittografia.

### /_src/_lib/_csv.tools.php
Questa libreria contiene una collezione di strumenti per la manipolazione dei file e dei dati in formato CSV.

### /_src/_lib/_filesystem.tools.php
Questa libreria contiene una collezione di funzioni per la gestione dell'I/O sul filesystem.

### /_src/_lib/_fsv.tools.php
Questa libreria è ancora da implementare e dovrebbe contenere una collezione di funzioni per la gestione dei file a larghezza fissa.

### /_src/_lib/_ftp.tools.php
Questa libreria è ancora da implementare e dovrebbe contenere una collezione di funzioni per la gestione del protocollo FTP.

### /_src/_lib/_image.tools.php
Questa libreria contiene vari strumenti per la gestione delle immagini.

### /_src/_lib/_jwt.tools.php
Questa libreria contiene le funzioni per la gestione dei token JWT.

### /_src/_lib/_localization.tools.php
Questa libreria contiene funzioni utili per la localizzazione.

### /_src/_lib/_log.utils.php
Questa libreria è inserita solo per garantire la retrocompatibilità con il vecchio sistema di log del framework.

### /_src/_lib/_mail.tools.php
Questa libreria contiene diverse funzioni per la gestione delle mail e delle code delle mail.

### /_src/_lib/_memcache.tools.php
Questa libreria contiene funzioni per la gestione della cache su Memcache.

### /_src/_lib/_memcache.utils.php
Questa libreria contiene funzioni per la gestione della cache su Memcache.

### /_src/_lib/_menu.utils.php
Questa libreria contiene funzioni per la generazione dei menu di navigazione.

### /_src/_lib/_mysql.tools.php
Questa libreria contiene le funzioni necessarie alla gestione del database MySQL.

### /_src/_lib/_mysql.utils.php
Questa libreria contiene funzioni di varia utilità basate su MySQL.

### /_src/_lib/_output.tools.php
Questa libreria contiene funzioni per l'output.

### /_src/_lib/_random.tools.php
Questa libreria contiene funzioni utili per la generazione di dati casuali.

### /_src/_lib/_recaptcha.tools.php
Questa libreria contiene una collezione di funzioni per la gestione di Google reCaptcha.

### /_src/_lib/_redis.tools.php
Questa libreria contiene funzioni utili per gestire la cache di Redis.

### /_src/_lib/_rest.tools.php
Questa libreria contiene strumenti utili per la gestione delle chiamate REST.

### /_src/_lib/_rewrite.tools.php
Questa funzione contiene strumenti per il supporto alla gestione dell'URL rewriting.

### /_src/_lib/_string.tools.php
Questa libreria contiene una collezione di funzioni per la manipolazione delle stringhe.

### /_src/_lib/_xml.tools.php
Questa libreria contiene funzioni per la gestione dell'XML.

### /_src/_sh/_backup.run.sh
Questo script crea un backup del sito nella cartella genitore della document root.

### /_src/_sh/_codeception.init.sh
Questo script inizializza le cartelle e il codice per i test. TODO va riordinato e documentato.

### /_src/_sh/_codeception.run.sh
Questo script esegue i test di accettazione del framework; i test si basano sugli esempi contenuti in _usr/_examples/; per
ulteriori dettagli sul funzionamento dei test di accettazione del framework fare riferimento alla documentazione
presente in dev/_usr/_docs/_dox/_test.dox.

### /_src/_sh/_composer.update.sh
Questo file esegue l'aggiornamento delle librerie esterne tramite composer; può inoltre eseguire una pulizia delle librerie
attualmente installate se lanciato in modalità hard, questo è utile per risolvere problemi di aggiornamento di composer.

### /_src/_sh/_crontab.install.sh
Questo file installa il file crontab necessario a far funzionare le operazioni pianificate del framework. Il file viene
posizionato in /etc/cron.d/ in modo da sfruttare il cron di sistema. Per ulteriori informazioni sul sistema delle operazioni
pianificate del framework si veda la documentazione delle API /_src/_api/_cron.php e dev/_src/_api/_job.php.

### /_src/_sh/_deploy.run.sh
Questo script esegue il deploy dell'installazione corrente su un target indicato come argomento. L'argometo che specifica
il target deve corrispondere al nome del file di configurazione da utilizzare per il deploy, fra quelli disponibili
nella cartella /etc/deploy/; il nome del file va specificato al netto dell'estensione .properties:

```
./_src/_sh/_deploy.run.sh stable
```

### /_src/_sh/_doxygen.build.sh
Questo script compila la documentazione tramite Doxygen. Il framework è ampiamente documentato con commenti che Doxygen è in
grado di trasformare in documentazione HTML e PDF, e grazie a questo meccanismo è possibile risparmiare molto tempo sulla
scrittura di manualistica.

### /_src/_sh/_folders.check.sh
Questo script controlla che esistano le cartelle custom solitamente necessarie al funzionamento corretto del framework.

### /_src/_sh/_gw.clean.sh
Questo script effettua una pulitura dei file superflui del framework; può essere chiamato in modalità soft o hard a seconda
di quanto si vuole cancellare.

### /_src/_sh/_lamp.permissions.open.sh
Questo script resetta i permessi della document root del sito in modo che i file siano accessibili a più utenti possibile,
solitamente è una modalità utilizzata per sviluppo e debug; si noti che con i permessi aperti il framework non gira per
motivi di sicurezza.

### /_src/_sh/_lamp.permissions.secure.sh
Questo script resetta i permessi della document root del sito in modo che siano il più restrittivi possibile. Questa è la
modalità di funzionamento predefinita del framework.

### /_src/_sh/_lamp.setup.sh
Questo script fa il setup dell'ambiente LAMP necessario a far girare il framework.

### /_src/_sh/_memcached.list.keys.sh
Questo script elenca le chiavi presenti in Memcache.

### /_src/_sh/_nginx.permissions.secure.sh
Questo script normalizza i permessi per l'ambiente Nginx.

### /_src/_sh/_password.hash.sh
Questo script genera l'hash di una password in modo che possa essere utilizzata nella configurazione o nel database del
framework.

### /_src/_sh/_test.import.sh
Questo script genera dei file di test in /var/spool/import/todo e /var/spool/import per il test del sistema di importazione
file; si veda /_src/_config/_740.controller.php per i dettagli e /_src/_api/_report/_import.php per i test del sistema.

### /_src/_sh/_lib/_functions.sh
Questa libreria viene utilizzata dagli script shell del framework per svolgere alcuni compiti base come la gestione degli
argomenti da linea di comando.

### /_src/_twig/_inc/_analytics.head.twig
Questo file include il codice per Google Analytics posto che l'utente abbia prestato il consenso oppure che Analytics sia
configurato in modalità anonimizzazione IP.

### /_usr/_database/_patch/_010000999999.tables.sql
Questo file contiene le patch base necessarie alla creazione delle tabelle nel database del framework; per ulteriori informazioni
sul funzionamento del sistema di patch si vedano i commenti al file /_src/_api/_task/_mysql.patch.php.

### /_usr/_database/_patch/_030000999999.indexes.sql
Questo file contiene le patch base che creano gli indici delle tabelle nel database del framework.

### /_usr/_database/_patch/_040000999999.acl.sql
Questo file contiene le patch base che creano le tabelle di ACL nel database del framework.

### /_usr/_database/_patch/_050000999999.data.sql
Questo file contiene le patch base che popolano le tabelle nel database del framework.

### /_usr/_database/_patch/_060000999999.constraints.sql
Questo file contiene le patch base che creano i constraint fra le tabelle del database del framework.

### /_usr/_database/_patch/_070000999999.procedures.sql
Questo file contiene le patch base che creano le stored procedures e le functions del database del framework.

### /_usr/_database/_patch/_080000999999.static.sql
Questo file contiene le patch base che creano le tabelle per le view statiche del database del framework.

### /_usr/_database/_patch/_090000999999.views.sql
Questo file contiene le patch base che creano le view del database del framework.

### /_usr/_database/_patch/_100000999999.reports.sql
Questo file contiene le patch base che creano le tabelle di report nel database del framework.

## documentazione dei moduli

### CT000.contatti
Il modulo contatti consente di compiere azioni su blocchi di dati definiti liberamente, ad esempio provenienti da moduli di
contatto sul sito, moduli di registrazione, landing page, eccetera. Il principio di funzionamento del modulo è molto semplice,
lato front-end è sufficiente predisporre un form simile a questo:

```
{% if request.__ct__.default.__status__ == 'OK' %}
<p>
     modulo ricevuto, tutto ok!
</p>
{% else %}
<form method="post" action="" id="esempioform">
    <input type="text" name="__ct__[default][nome]">
    <input type="text" name="__ct__[default][mail]">
    {{ cms.formButton( { 'field': { 'text': 'INVIA' }, 'form': { 'id': 'esempioform', 'table': '__ct__', 'subtable': 'default' }, 'recaptcha': google.profile.recaptcha } ) }}
</form>
{% endif %}
```

Mentre lato back-end bisognerà definire se e quale controller attivare per gestire i dati provenienti dal modulo. Si può anche
non specificare una controller, in quanto i dati raccolti dal modulo contatti vengono comunque salvati sulla tabella contatti per
poter essere poi consultati in un secondo momento.

La configurazione del modulo può avvenire in diversi punti, tutti validi, ma probabilmente il migliore è il file /mod/CT000.contatti/src/config.yaml;
un esempio di configurazione minimale potrebbe essere il seguente:

```
contatti:
  nomemodulo:
    controller: 
        - "_mod/_CT000.contatti/_src/_inc/_controllers/_form/_nomemodulo.php"
```

## FAQ

### domande generali

#### quali sono le operazioni da svolgere per pubblicare una nuova release?
Per pubblicare una nuova release è necessario:

- incrementare il numero di versione
- creare una release branch da develop
- effettuare il debug e i test sulla release branch
- fare il merge della release branch su master e su develop

#### quali sono i comandi di una lettera disponibili nel framework?
Il framework supporta diversi comandi di una lettera che possono essere passati nell'URL per ottenere determinati effetti, solitamente utili
agli sviluppatori e ai tester.

comando     | implementato in                           | effetto
------------|-------------------------------------------|-------------------------------------------
b           | /_src/_config/_220.auth.php               | URL di ritorno
c           | /_src/_config/_420.pages.php              | forza il tema della pagina
j           | /_src/_config/_210.auth.php               | innesca il login via JWT
m           | /_src/_config/_420.pages.php              | inserisce il Lorem Ipsum come testo della pagina
q           | /_src/_api/_pages.php                     | aggiunge un report della velocità ai commenti della pagina
s           | /_src/_config/_420.pages.php              | forza lo schema della pagina
t           | /_src/_config/_420.pages.php              | forza il template della pagina
u           | /_src/_api/_pages.php                     | crea un commento HTML con il dump dell'array $ct a partire dal nodo indicato

#### come creo pagine statiche senza bisogno di configurare il framework?
È possibile creare contenuti statici che vengono serviti tramite il framework inserendoli nella cartella 
/usr/pages; è anche possibile creare delle sottocartelle. Una pagina HTML creata in /usr/pages/test.html sarà 
quindi raggiungibile, tramite un'apposita regola di /.htaccess, all'URL /test.html e una pagina creata in 
/usr/pages/prova/test.html sarà raggiungibile all'URL /prova/test.html.

Questo meccanismo consente di importare nel framework interi siti statici, in modo da poter utilizzare le
funzioni del framework che si desidera senza la necessità di riscrivere tutto.

#### voglio creare un nuovo template, come faccio?
Comincia studiando la documentazione su come sono strutturati i template in /_usr/_docs/_dox/_templates.dox.

#### che cos'è esattamente un'entità nel gergo del framework?
Un'entità è l'astrazione nel contesto del framework di un insieme di oggetti o concetti della vita reale. 
Solitamente corrisponde a una tabella nel database, e gli utenti hanno diversi tipi di permessi di interazione
con essa.

#### come aggiungo un nuovo metodo di pagamento al framework?
Dopo aver studiato il nuovo metodo di pagamento occorre capire come si può interfacciare al processo di pagamento
del framework. Tipicamente si dovrà creare una libreria per le funzioni di supporto, e almeno un listener per
gestire le comunicazioni in ingresso dal server del gestore del pagamento. A livello di configurazione è necessario
aggiungere il metodo di pagamento all'array dei metodi di pagamento. Prima di iniziare il processo di integrazione
studiare bene tutti i commenti al codice delle integrazioni già esistenti.

#### come definisco quali cookie utilizza il sito?
Per ogni cookie o gruppo di cookie che utilizzi devi definire un paragrafo di configurazione in $cf['privacy']['cookie'],
e precisamente:

- i cookie propri tecnici vanno sotto $cf['privacy']['cookie']['propri]['tecnici']
- i cookie propri di profilazione vanno sotto $cf['privacy']['cookie']['propri]['analitici']
- i cookie di terze parti tecnici vanno sotto $cf['privacy']['cookie']['terzi]['tecnici']
- i cookie di terze parti di profilazione vanno sotto $cf['privacy']['cookie']['terzi]['analitici']

Per una panoramica delle chiavi da inserire si vedano i commenti al codice del file /_src/_config/_060.privacy.php mentre
per comprendere come questi dati vengono letti e scritti sui cookie si veda /_src/_config/_065.privacy.php. Le
impostazioni dei cookie vengono poi lette dai file twig che compongono le pagine per decidere se inserire o meno il
codice che genera i cookie.

#### come creo una pagina tramite file di configurazione PHP?
Per creare una pagina tramite file di configurazione PHP è necessario creare o editare un file in /src/inc/pages, ad esempio
/src/inc/pages/site.it-IT.php e aggiungere il relativo paragrafo di configurazione. Un tipico paragrafo di configurazione
per una pagina avrà all'incirca questo aspetto:

```
$p['pagina.test'] = array(
    'id_sito'       => 1,
    'sitemap'       => true,
    'cacheable'     => true,
    'title'         => array( $l        => 'pagina di test' ),
    'description'   => array( $l        => 'questa è una pagina di test' ),
    'h1'            => array( $l        => 'ciao sono la pagina di prova' ),
    'template'      => array( 'path'    => '_src/_tpl/_aurora/', 'schema' => 'default.twig' ),
    'parent'        => array( 'id'      => NULL ),
    'menu'          => array( 'main'    => array( '' => array( 'label' => array( $l => 'pagina di test' ), 'priority' => '090' ) ) )
);
```

Per un approfondimento sui valori da assegnare alle varie chiavi, e per l'elenco delle chiavi disponibili, si faccia riferimento
alla documentazione del file /_src/_config/_310.pages.php.

Se stai personalilzzando pagine standard, copia in custom il file standard al quale vuoi aggiungere una pagina (ricordati di togliere
l'underscore iniziale); a questo punto puoi aggiungere la pagina. Ad esempio se vuoi aggiungere una pagina al file /_src/
_inc/_pages/_app.it-IT.php devi customizzarlo in /src/inc/pages/app.it-IT.php.

#### come creo una pagina tramite file di configurazione JSON o YAML?
Per creare una pagina tramite la configurazione estesa JSON/YAML è sufficiente aggiungere alla configurazione una chiave per la pagina,
con le relative sottochiavi. Ad esempio in JSON:

```
{
    [...]
    "contents": {
        "pages": {
            [...]
            "prova.pagina.json": {
                "id_sito": 1,
                "sitemap": true,
                "cacheable": true,
                "title": {
                    "it-IT": "pagina di prova da file JSON"
                },
                "description": {
                    "it-IT": "pagina di prova da file JSON"
                },
                "h1": {
                    "it-IT": "pagina di prova da file JSON"
                },
                "template": {
                    "path": "_src/_tpl/_aurora/",
                    "schema": "default.twig"
                },
                "parent": {
                    "id": null
                },
                "menu": {
                    "main": {
                        "": {
                            "label": {
                                "it-IT": "prova JSON"
                            },
                            "priority": 190
                        }
                    }
                }
            },
            [...]
        }
    }
    [...]
}
```

Ovviamente la stessa struttura appare molto più sintetica in YAML ma la sostanza è uguale:

```
[...]
contents:
  pages:
    [...]
    prova.pagina.yaml:
      id_sito: 1
      sitemap: true
      cacheable: true
      title:
        it-IT: pagina di prova da file YAML
      description:
        it-IT: pagina di prova da file YAML
      h1:
        it-IT: pagina di prova da file YAML
      template:
        path: _src/_tpl/_aurora/
        schema: default.twig
      parent:
        id: null
      menu:
        main:
          "":
            label:
              it-IT: prova YAML
            priority: 290
    [...]
[...]
```

#### come definisco staticamente i contenuti di una pagina già presente nell'array delle pagine?
Il framework controlla la cartella src/inc/contents/ per contenuto relativo a una data pagina; puoi creare un file in src/inc/contents/
con il nome uguale all'ID della pagina cui vuoi settare il contenuto ad es. <idPagina>.xx-XX.html. Per ulteriori dettagli su questo
meccanismo si veda la documentazione del file /_src/_api/_pages.php.

#### come definisco il contenuto di una pagina direttamente dal file di configurazione (PHP, JSON o YAML)?
Per definire il contenuto della pagina direttamente dalla configurazione è sufficiente valorizzare la chiave content e la relativa sotto
chiave per lingua. In PHP ad esempio questo si tradurrà in:

```
$p['pagina.test'] = array(
    'id_sito'       => 1,
    'sitemap'       => true,
    'cacheable'     => true,
    'title'         => array( $l        => 'pagina di test' ),
    'description'   => array( $l        => 'questa è una pagina di test' ),
    'h1'            => array( $l        => 'ciao sono la pagina di prova' ),
    'content'       => array( $l        => 'ciao sono il contenuto della pagina di prova' ),
    'template'      => array( 'path'    => '_src/_tpl/_aurora/', 'schema' => 'default.twig' ),
    'parent'        => array( 'id'      => NULL ),
    'menu'          => array( 'main'    => array( '' => array( 'label' => array( $l => 'pagina di test' ), 'priority' => '090' ) ) )
);
```

Analogamente, in JSON e in YAML si procederà aggiungendo la chiave con le relative sotto chiavi per lingua.

#### è possibile specificare delle configurazioni di pagina solo per uno specifico sito?
Sì certo, la chiave contents è valida anche come sotto chiave di ogni singolo sito, questo consente ad esempio di modificare il template di una
pagina presente in più siti a seconda del sito corrente.

#### come faccio a testare il meccanismo dei task ricorrenti?
Per prima cosa sincerati che il task di test funzioni correttamente se eseguito manualmente; ad esempio chiama l'URL /task/test.cron e sincerati che
l'esecuzione del task avvenga senza problemi. Una volta controllato questo, puoi procedere con il controllo dell'API cron.

Per verificare che il task venga eseguito anche dall'API cron, devi verificare che il task sia pianificato, ovvero controllare sul database
(SELECT * FROM `task`) che sia presente una riga per _src/_api/_task/_test.cron.php. Se la riga manca, aggiungila (vedi /_src/_api/_cron.php per i dettagli).

Una volta controllato che la tabella dei task contenga il task di test, puoi lanciare a mano l'API cron chiamando l'endpoint /api/cron, dopodiché
verifica che il file di test sia stato scritto correttamente nella cartella dei log.

Una volta che il funzionamento del sistema è stato verificato in modalità manuale puoi utilizzare lo script _crontab.install.sh per installare il file
di cron nella cartella /etc/cron.d/; a questo punto, il file di log dovrebbe venire scritto automaticamente ogni minuto.

#### come faccio a testare il meccanismo dei job?
Per testare un job devi innanzitutto inserire la riga relativa nella tabella dei job; puoi farlo manualmente oppure creare un task di avvio che lo faccia
in modo semi automatico (esistono un job di test e il relativo task di avvio già pronti nel framework). Come primo step, testa il job in foreground.

Per testare un job in foreground è necessario inserirlo nel database con il flag se_foreground settato; in questo caso, il job verrà ignorato dall'API
cron e sarà possibile eseguirlo solo manualmente tramite l'API job, il che è ottimo per il debug. Sincerati di aver inserito il job in modalità foreground
e chiama l'API job con l'ID del job da testare per controllare che tutto funzioni regolarmente.

Una volta che il test manuale è andato a buon fine, puoi mandare il job in background settando a NULL il campo se_foreground, e chiamare manualmente
l'API cron per verificare che venga effettivamente eseguito senza errori.

Se anche il test manuale tramite l'API cron va a buon fine, puoi attivare il cron di sistema e controllare che il lavoro del job venga incrementato ogni
minuto in modo automatico.

#### come funziona la distribuzione del framework GlisWeb tramite container Docker?
Il container della versione di sviluppo del framework GlisWeb è disponibile su https://hub.docker.com/repository/docker/istricesrl/glisdev/general e
può essere liberamente scaricata e lanciata. Per effettuare un test minimale è possibile predisporre un piccolo file di configurazione e lanciare
il container mappando la cartella in cui lo si è salvato. Si supponga ad esempio di creare il seguente file YAML in una cartella chiamata ./conf/:

```
sites:
  1:
    __label__: "test Docker"
    name:
      it-IT: "test Docker"
    protocols:
      DEV: "https"
    hosts: 
      DEV: ""
    domains:
      DEV: "localhost"
```

A questo punto è possibile lanciare il container con:

```
docker run -dit -p 8080:80 -v ./conf/:/var/www/html/src/config/ext/ istricesrl/glisdev:$1
```

Aprendo un browser su http://localhost:8080/status si dovrebbe vedere correttamente configurato il framework. Per fermare il container in esecuzione
è necessario conoscerne l'ID:

```
docker container list
```

e successivamente fermarlo con:

```
docker container stop <containerID>
```

Per entrare in un container ed esplorare i file (utile per vedere i file di log) utilizzare:

```
docker exec -it <containerId> bash
```

#### posso lanciare il container di Glisweb su Flatcar Linux?
Per un'introduzione veloce a Flatcar Linux si veda https://github.com/the-linux-nerd/esempi-linux/blob/master/distribuzioni/flatcar.md.
Una volta che avrete una Flatcar funzionante, potrete lanciare normalmente da Docker l'immagine del framework (vedi la relativa FAQ).

#### come creo una patch per il database?
Una patch per il database è un file contenente uno o più comandi SQL, opportunamente commentati per far capire al framework come deve considerarli.
Per mantenere la consistenza fra database e applicazione è necessario attenersi strettamente alle seguenti regole ogni volta che si desidera
modificare il database del framework:

- per prima cosa, modificare opportunamente i file di patch base in modo che la modifica si propaghi ai NUOVI database
- secondariamente, creare i file di patch necessari a propagare la modifica ai database ESISTENTI

Per creare un file di patch finalizzato al deploy di una modifica ai database esistenti, è necessario rispettare le seguenti regole:

- il file va inserito nella cartella /_usr/_database/_patch/
- il nome del file deve corrispondere alla timestamp corrente seguita da quattro nove al posto dell'orario (YYYYMMDD9999)
- i comandi all'interno del file vanno separati da un progressivo formato dalla timestamp corrente seguita da quattro cifre (vedi sotto)
- i simboli dei commenti e i pipe sono significativi e vengono utilizzati dal framework per decodificare il file, attenersi all'esempio

Per comprendere la struttura del file di patch, si osservi il seguente codice:

```
--
-- PATCH
-- aggiornamento della tabella matadati 2022/10/07
-- file 202210079999.sql
--

-- | 202210070010
ALTER TABLE `metadati`
    ADD COLUMN `id_tipologia_todo` int(11) DEFAULT NULL AFTER `id_pianificazione`,
    ADD UNIQUE KEY `unica_tipologia_todo` (`id_lingua`,`id_tipologia_todo`,`nome`),
    ADD KEY `id_tipologia_todo` (`id_tipologia_todo`);

-- | 202210070020
ALTER TABLE `metadati`
    ADD CONSTRAINT `metadati_ibfk_27` FOREIGN KEY (`id_tipologia_todo`) REFERENCES `tipologie_todo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- | 202210070030
CREATE OR REPLACE VIEW `metadati_view` AS
    SELECT
        [...]
    FROM metadati
        LEFT JOIN lingue ON lingue.id = metadati.id_lingua
;

-- | FINE FILE
```

Come si vede, il file inizia con una testatina commentata (in forma libera) nella quale è possibile inserire note e commenti alla patch. Seguono
tre sezioni introdotte dalla sequenza -- | seguita dalla timestamp più il progressivo, e infine la chiusura -- | FINE FILE. Ogni comando SQL
è contenuto in una sezione separata.

Per ulteriori informazioni sul funzionamento del sistema di patch del database si faccia riferimento alla documentazione del file
/_src/_api/_task/_mysql.patch.php.

#### come abilito la firma DKIM per la posta inviata dal framework?
Le chiavi DKIM vengono memorizzate in /etc/secret/<nomeDominio>; per utilizzarle è necessario aggiungere un record DKIM al proprio DNS. Lo script
/_src/_sh/_dkim.keygen.sh è pensato per aiutare in questo processo.

#### come inserisco un'immagine in una pagina del sito?
Per aggiungere un'immagine in una pagina del sito sfruttando il meccanismo di scalamento delle immagini nativo del framework è
necessario prima di tutto caricare l'immagine desiderata nella scheda immagini della pagina in questione. Assegnando un ordine e un
ruolo all'immagine sarà poi possibile richiamarla con la macro image() come segue:

```
{{ cms.image({ 'source': { 'ruolo': 'immagine', 'ordine': 10 }, 'site': site, 'page': page, 'image': image }) }}
```

Supponendo in questo caso che il ruolo assegnato sia 'immagine' e l'ordine assegnato sia '10'.

#### come configuro Google Analytics per misurare le visite al mio sito?
Devi compilare l'apposita sezione del file di configurazione; supponendo che tu abbia usato YAML, avrai qualcosa di simile:

```
google:
  profiles:
    DEV:
      analytics:
        ua: "IL-TUO-CODICE-ANALYTICS",
        anonymous": true
```

#### come funziona l'aggiornamento dei report di magazzino?
Di base l'aggiornamento dei report di magazzino viene attivata dalla controller su documenti_articoli nel modulo mastri. In pratica ogni volta che
una riga di documento viene salvata, le relative informazioni di magazzino vengono aggiornate.

#### come vengono salvate le preferenze di privacy degli utenti?
Le preferenze relative ai cookie vengono salvate in un cookie tecnico (vedi /_src/_config/_060.privacy.php e /_src/_config/_065.privacy.php) mentre
i consensi ai trattamenti dei dati e l'accettazione delle policy del sito vengono salvate nel database, e in particolare nella tabella
consensi_anagrafica.

Se si studia il codice del file /_mod/_CT000.contatti/_src/_config/_750.controller.php e quello della funzione associazioneConsensiContatto() si
vedrà esattamente dove i consensi prestati con i vari moduli presenti sul sito vengono intercettati, e come vengono poi salvati.

### template Athena
Questa sezione contiene domande specificamente relative all'utilizzo del template Athena.

#### qual è la struttura base di una pagina di tipo form?
Le pagine di tipo form possono essere create a partire da questa struttura base:

```
{# IMPORTAZIONE LIBRERIE #}
{% import '_lib/_default.twig' as cms %}
{% import '_lib/_form.twig' as frm %}
{% import 'lib/default.twig' as def %}

{# ESTENSIONE DELLO SCHEMA DI BASE #}
{% extends 'ext/main.twig' %}

{# BLOCCO PRINCIPALE DELLA PAGINA #}
{% block main %}
<!-- blocco {{ _self }}::main -->

{# MODULO PRINCIPALE #}
<section class="row flex-fill">
    <div class="col-md-12 d-flex flex-column">

        {# APERTURA DEL FORM #}
        {{ frm.openForm({ 'form': form, 'page': page, 'session': session, 'request': request }) }}

            {# SEZIONE GENERALE #}
            <fieldset>
                <legend>dati generali <small>{{ legend }}</small></legend>

            </fieldset>

            {# BOTTONI E COMANDI DEL MODULO #}
            <fieldset class="form-controls mt-auto">
                {{ def.controls( page, pages, ietf, session, form.table, request ) }}
            </fieldset>

        </form>
    </div>
</section>

<!-- fine blocco {{ _self }}::main -->
{% endblock main %}
```

### problemi frequenti

#### il framework mi chiede di rifare il login a ogni pagina che visito, perché?
Questo problema si manifesta solitamente quando SSL non è configurato correttamente; accedendo a una pagina HTTP e venendo
poi reindirizzati a una pagina HTTPS si perde il cookie di sessione e questo obbliga a rifare il login. Per verificare se
effettivamente il problema che riscontrate è questo, monitorate il cookie di sessione dalla scheda applicazione dei tools
per gli sviluppatori di Chrome o Firefox; se notate che il cookie appare e scompare randomicamente ogni volta che cambiate
pagina, allora il problema è questo. Sinceratevi che la versione HTTPS del sito sia configurata correttamente.
