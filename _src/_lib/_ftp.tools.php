<?php

    /**
     * libreria per la gestione del protocollo FTP
     * 
     * Questa libreria fornisce funzioni per connettersi a un server FTP, caricare e scaricare file, e navigare tra le cartelle del server.
     * 
     * introduzione
     * ============
     * Questa libreria è stata creata per semplificare l'interazione con i server FTP, permettendo di effettuare operazioni comuni come
     * connessione, caricamento e scaricamento di file, e navigazione tra le cartelle.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono suddivise in tre gruppi, le funzioni per la connessione al server, le funzioni per l'upload
     * e il download dei file, e le funzioni per il browsing del server.
     * 
     * funzioni per la connessione al server
     * -------------------------------------
     * Queste funzioni permettono di connettersi a un server FTP, effettuare il login e chiudere la connessione.
     * 
     * funzione                 | descrizione
     * -------------------------|---------------------------------------------------------------
     * ftpConnect()             | effettua la connessione a un server FTP
     * ftpClose()               | chiude la connessione al server FTP
     * 
     * funzioni per l'upload e il download
     * -----------------------------------
     * Queste funzioni permettono di caricare e scaricare file da un server FTP.
     * 
     * funzione                 | descrizione
     * -------------------------|---------------------------------------------------------------
     * ftpPutFile()             | carica un file su un server FTP
     * ftpGetFile()             | scarica un file da un server FTP
     * ftpGetUploadTypeByFile() | restituisce il tipo di trasferimento da utilizzare per un file
     * 
     * funzioni per il browsing del server
     * -----------------------------------
     * Queste funzioni permettono di esplorare il contenuto di un server FTP, elencando i file e le cartelle presenti.
     * 
     * funzione                 | descrizione
     * -------------------------|---------------------------------------------------------------
     * ftpListFiles()           | restituisce la lista dei file presenti in una cartella del server FTP
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * fullpath()                       | filesystem.tools
     * checkFolder()                    | filesystem.tools
     * isBinaryFile()                   | filesystem.tools
     * 
     * Inoltre, per funzionare correttamente, la libreria richiede che siano valorizzate le
     * seguenti costanti globali.
     *
     * costante                  | spiegazione
     * --------------------------|--------------------------------------------------------------
     * DIR_BASE                  | il percorso base dove lavorare (ad es. /var/www/)
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2025-05-24       | Fabio Mosti          | refactoring e documentazione della libreria
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    /**
     * FUNZIONI PER LA CONNESSIONE AL SERVER
     */

    /**
     * effettua la connessione a un server FTP
     * 
     * Questa funzione crea una connessione a un server FTP e imposta la modalità passiva (di default) oppure attiva.
     * Restituisce un oggetto connessione che può essere utilizzato per dare comandi, caricare e scaricare file, elencare
     * il contenuto del server, e così via. La variabile $srv è un array associativo che contiene i dati del server FTP:
     * - address: indirizzo del server FTP
     * - port: porta del server FTP (di default 21)
     * - username: nome utente per il login
     * - password: password per il login
     * 
     * @param       $srv        array       array associativo con i dati del server FTP
     * 
     * @return      resource    $conn       oggetto connessione al server FTP
     * 
     */
    function ftpConnect( $srv ) {

        $conn = ftp_connect( $srv['address'], $srv['port'], 5 );

        if( ! empty( $conn ) ) {

            $login = ftp_login( $conn, $srv['username'], $srv['password'] );

            if( $login == true ) {

                $pasw = ftp_pasv( $conn, true );

                // se sono riuscito ad impostare la modalità passiva
                if( $pasw == true ) {

                    return $conn;

                } else {

                    logger( 'impossibile impostare la modalità passiva', 'ftp', LOG_ERR );

                }

            } else {

                logger( 'impossibile effettuare il login', 'ftp', LOG_ERR );

            }

        } else {

            logger( 'impossibile connettersi al server FTP', 'ftp', LOG_ERR );

        }

        return false;

    }

    /**
     * chiude la connessione al server FTP
     * 
     * Questa funzione chiude la connessione al server FTP e rilascia le risorse utilizzate.
     * 
     * @param       $conn      resource    oggetto connessione al server FTP
     * 
     * @return      bool        true se la connessione è stata chiusa correttamente, false altrimenti
     * 
     */
    function ftpClose( $conn ) {

        return ftp_close( $conn );

    }

    /**
     * FUNZIONI PER L'UPLOAD E IL DOWNLOAD
     */

    /**
     * carica un file su un server FTP
     * 
     * Questa funzione carica un file su un server FTP.
     * 
     * @param       $conn       resource    oggetto connessione al server FTP
     * @param       $localFile  string      percorso del file locale da caricare
     * @param       $remoteFile string      percorso del file remoto dove caricare il file
     * 
     * @return      bool        true se il file è stato caricato correttamente, false altrimenti
     * 
     */
    function ftpPutFile( $conn, $localFile, $remoteFile ) {

        $localFile = fullpath( $localFile );

        $type = ftpGetUploadTypeByFile( $localFile );

        $dir = '/';
        $path = explode( '/', dirname( $remoteFile ) );
        foreach( $path as $chdir ) {
            $dir = $dir . $chdir . '/';
            $ftpDir = @ftp_chdir( $conn, $dir );
            if( empty( $ftpDir ) ) {
                $ftpDir = ftp_mkdir( $conn, $chdir );
                $ftpDir = ftp_chdir( $conn, $chdir );
            }
        }

        $result = ftp_put( $conn, $remoteFile, $localFile, $type );

        if( $result == false ) {
            logger( 'impossibile caricare il file ' . $localFile . ' su ' . $remoteFile, 'ftp', LOG_ERR );
            return false;
        }

        return true;

    }

    /**
     * scarica un file da un server FTP
     * 
     * Questa funzione scarica un file da un server FTP.
     * 
     * @param       $conn       resource    oggetto connessione al server FTP
     * @param       $remoteFile string      percorso del file remoto da scaricare
     * @param       $localFile  string      percorso del file locale dove salvare il file scaricato
     * 
     * @return      bool        true se il file è stato scaricato correttamente, false altrimenti
     * 
     */
    function ftpGetFile( $conn, $remoteFile, $localFile ) {

        $localFile = fullpath( $localFile );

        checkFolder( dirname( $localFile ) );

        $type = ftpGetUploadTypeByFile( $remoteFile );

        $result = ftp_get( $conn, $localFile, $remoteFile, $type );

        if( $result == false ) {
            logger( 'impossibile scaricare il file ' . $remoteFile . ' su ' . $localFile, 'ftp', LOG_ERR );
            return false;
        }

        return true;

    }

    /**
     * restituisce il tipo di trasferimento da utilizzare per un file
     * 
     * Questa funzione restituisce il tipo di trasferimento da utilizzare per un file.
     * 
     * @param       $f          string      percorso del file da analizzare
     * 
     * @return      int         tipo di trasferimento da utilizzare (FTP_BINARY o FTP_ASCII)
     * 
     */
    function ftpGetUploadTypeByFile( $f ) {

        fullpath( $f );

        if( isBinaryFile( $f ) ) {
            return FTP_BINARY;
        } else {
            return FTP_ASCII;
        }

    }

    /**
     * FUNZIONI PER IL BROWSING DEL SERVER
     */

    /**
     * restituisce la lista dei file presenti in una cartella del server FTP
     * 
     * Questa funzione restituisce la lista dei file presenti in una cartella del server FTP.
     * 
     * @param       $conn      resource    oggetto connessione al server FTP
     * @param       $path      string      percorso della cartella da esplorare (di default è la root '/')
     * 
     * @return      array       lista dei file presenti nella cartella
     * 
     */
    function ftpListFiles( $conn, $path = '/' ) {

        // ottengo la lista dei file
        $files = ftp_nlist( $conn, $path );

        // se non ho ottenuto nulla ritorno un array vuoto
        if( empty( $files ) ) {
            return array();
        }

        return $files;

    }
