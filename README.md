# GlisWeb - framework per le applicazioni web
Questo è il framework GlisWeb, sviluppato a partire da una base di codice originariamente scritto da Fabio Mosti
<fabio.mosti@istricesrl.it> e Emiliano Volta all'inizio degli anni 2000, riordinato in un unico framework da
Fabio Mosti fra il 2000 e il 2005, e costantemente aggiornato fino alla versione attuale mantenuta in collaborazione
con il team di Istrice srl.

Grazie ai suoi vent'anni di storia, GlisWeb può garantire una stabilità e una robustezza senza pari, pur
essendo aggiornato alle più recenti conquiste delle tecnologie web. Modernità e tradizione si fondono in uno
strumento rigoroso ed elegante, grazie al quale è possibile realizzare con semplicità progetti estremamente
complessi.

GlisWeb è un framework leggero, ampiamente personalizzabile, pensato per realizzare siti e web application
nativamente rispettose degli standard e delle migliori pratiche vigenti nel mondo del web.

# installazione
GlisWeb può essere installato per due finalità distinte, per utilizzarlo nella realizzazione di un proprio progetto
oppure per contribuire allo sviluppo del framework. Poiché il primo caso è il più comune, iniziamo da quello.

## installazione per lo sviluppo di nuovi progetti
Potete installare GlisWeb semplicemente clonando il repository nella document root del vostro server web
(o del vostro sito se il server gestisce più siti); potete anche scaricare il sorgente e caricarlo sul vostro
server via FTP se utilizzate un hosting condiviso che non vi dà la possibilità di lanciare comandi via SSH.
È importante che nell'installazione e nel successivo uso del framework non alteriate né rimuoviate i file
LICENSE.md e README.md che fanno parte integrante del framework stesso e ne garantiscono la circolazione
come software Open Source.

### installazione tramite Git Clone
Se avete modo di utilizzare Git sulla macchina in cui volete installare il framework, è sufficiente clonare il
repository https://github.com/istricesrl/glisweb nella document root del sito, dopodiché lanciare composer update
per installare le dipendenze. Successivamente potrete replicare la procedura per aggiornare l'intallazione quando
dovesse rendersi necessario.

### installazione tramite FTP
Il framework non include le dipendenze installate con composer, per cui se dovete utilizzare FTP per installarlo
allora dovrete scaricare le dipendenze prima di effettuare l'upload. Scaricate GlisWeb in formato ZIP e scompattatelo,
o clonate il repository, dopodiché lanciate composer localmente nella cartella dove si trova il file composer.json.
Quando l'installazione delle librerie sarà completata, potrete installare il framework sul vostro server tramite FTP.

Una volta completato l'upload, utilizzate l'interfaccia fornita dal vostro provider per eseguire gli script SQL
allegati al framework (in _usr/_database/, eseguite prima mysql.schema.sql e poi mysql.data.sql) in modo da creare le
tabelle necessarie al suo funzionamento.

### installazione tramite console o SSH
Se potete accedere via SSH al server su cui volete installare GlisWeb, allora l'installazione risulterà più lineare.
Sarà sufficiente scaricare il framework come sopra, ma direttamente nella document root del sito su cui volete
installarlo, installare le dipendenze con composer e lanciare lo script shell allegato al framework
(_src/_sh/_gw.mysql.install.sh) per caricare il database. Lo script è interattivo e vi chiederà i dati del server
di database per eseguire gli script SQL allegati al framework.

Se avete appena installato (o non avete ancora installato) i server web e database, potreste trovare utile lo script di
setup dell'ambiente (_src/_sh/_gw.environment.setup.sh) che vi aiuterà a installare e configurare i servizi necessari
a far funzionare GlisWeb.

Un esempio di sequenza di comandi per l'installazione potrebbe essere la seguente, come più ampiamente illustrato nella
documentazione ufficiale per gli sviluppatori all'indirizzo https://glisweb.istricesrl.it/docs/:

    cd /var/www/html
    wget https://github.com/istricesrl/glisweb/archive/develop.zip
    unzip develop.zip
    mv -f ./glisweb-develop/{.,}* ./
    rmdir glisweb-develop
    rm -rf .github
    rm -f .gitignore
    rm -f develop.zip
    _src/_sh/_gw.permissions.reset.sh
    _src/_sh/_gw.mysql.install.sh
    _src/_sh/_gw.config.sh base
    composer update

Un video sull'installazione di GlisWeb è anche disponibile a questo indirizzo https://youtu.be/xzERaj20HJA:

[![Watch the video](https://img.youtube.com/vi/xzERaj20HJA/maxresdefault.jpg)](https://youtu.be/xzERaj20HJA)

Se sul server che state utilizzando è installato il progetto Calabash (https://github.com/istricesrl/calabash)
potete installare GlisWeb semplicemente lanciando dalla document root del progetto il comando:

    va.glisweb.install.sh .

Se desiderate la versione di sviluppo utilizzate:

    va.glisweb.install.sh . develop

L'aggiornamento delle librerie con Composer sarà già stato effettuato dallo script.

## installazione per contribuire al progetto
Se desiderate contribuire al progetto GlisWeb e siete in possesso di una chiave valida per il repository, potete seguire queste
istruzioni per installare il framework in modalità sviluppatore. Per prima cosa procuratevi il progetto Calabash (vedi sopra)
e installate il framework con il comando:

    va.glisweb.clone.sh /percorso/document/root

Vi verrà chiesto se volete fare il setup dell'ambiente LAMP, se sul vostro computer non è già installato l'ambiente LAMP potete
rispondere di sì e lo script provvederà a installarlo e configurarlo per voi. Successivamente, la procedura vi chiederà anche se
desiderate creare un database per il framework, e infine vi proporrà di avviare la configurazione guidata.

# configurazione
Potete iniziare rapidamente a configurare il deploy appena installato prelevando e personalizzando i file di esempio
che trovate in _usr/_config/_json/, è sufficiente utilizzarli come base per creare un unico file src/config.json che
verrà letto automaticamente dal framework. Per qualsiasi dubbio fate riferimento alla documentazione in _usr/_docs/
oppure se preferite potete fare il build con Doxigen dei file (utilizzando lo scritp _src/_sh/_gw.doxygen.build.sh) in modo
da poterli visualizzare via web, aggiungendo all'URL del vostro deploy il path _usr/_docs/_build/html/.

## esempi
Ricordate inoltre che trovate numerosi esempi e file utili nella cartella _usr/_examples/, che è un'ottima base di
partenza per iniziare a capire come funziona GlisWeb. Alcuni degli strumenti che troverete in questa cartella vi saranno
molto utili anche quando sarete divenuti più esperti!

# utilizzo
Utilizzare GlisWeb è semplice e intuitivo! Una guida per gli utenti è in fase di sviluppo ed è disponibile a questo
indirizzo http://s-url.it/gliswebdocs inoltre stiamo pubblicando una serie di video tutorial su questa playlist di YouTube
http://s-url.it/gliswebvideos. https://glisweb.istricesrl.it/prova

