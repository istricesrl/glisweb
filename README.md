# GlisWeb - framework per le applicazioni web
Questo è il framework GlisWeb, sviluppato a partire da una base di codice originariamente scritto da Fabio Mosti
<fabio.mosti@istricesrl.it> e Emiliano Volta alla fine degli anni '90, riordinato in un unico framework da
Fabio Mosti nei primi anni 2000 e costantemente aggiornato fino alla versione attuale mantenuta in collaborazione
con il team di Istrice srl.

GlisWeb è un framework leggero, ampiamente personalizzabile, pensato per realizzare siti e web application
nativamente rispettose degli standard e delle migliori pratiche vigenti nel mondo del web.

## installazione
Potete installare GlisWeb semplicemente clonando il repository nella document root del vostro server web
(o del vostro sito se il server gestisce più siti); potete anche scaricare il sorgente e caricarlo sul vostro
server via FTP se utilizzate un hosting condiviso che non vi dà la possibilità di lanciare comandi via SSH.
È importante che nell'installazione e nel successivo uso del framework non alteriate né rimuoviate i file
LICENSE.md e README.md che fanno parte integrante del framework stesso e ne garantiscono la circolazione
come software Open Source.

### installazione tramite FTP
Il framework non include le dipendenze installate con composer, per cui se dovete utilizzare FTP per installarlo
allora dovrete scaricare le dipendenze prima di effettuare l'upload. Scaricate GlisWeb in formato ZIP e scompattatelo,
o clonate il repository, dopodiché lanciate composer localmente nella cartella dove si trova il file composer.json.
Quando l'installazione delle librerie sarà completata, potrete installare il framework sul vostro server tramite FTP.

Una volta completato l'upload, utilizzate l'interfaccia fornita dal vostro provider per eseguire gli script SQL
allegati al framework in modo da creare le tabelle necessarie al suo funzionamento.

### installazione tramite SSH
Se potete accedere via SSH al server su cui volete installare GlisWeb, allora l'installazione risulterà più lineare.
Sarà sufficiente scaricare il framework come sopra, ma direttamente nella document root del sito su cui volete
installarlo, e lanciare lo script shell allegato al framework per caricare il database.
