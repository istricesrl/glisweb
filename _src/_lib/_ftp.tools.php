<?php

    /**
     * libreria per la gestione dei protocolli FTP e SFTP
     *
     * Questa libreria fornisce funzioni per connettersi a un server FTP o SFTP, caricare e scaricare file, e navigare tra le cartelle del server.
     *
     * introduzione
     * ============
     * Questa libreria è stata creata per semplificare l'interazione con i server FTP, permettendo di effettuare operazioni comuni come
     * connessione, caricamento e scaricamento di file, e navigazione tra le cartelle.
     *
     * Le stesse funzioni lavorano anche in SFTP, quando il server lo dichiara con la chiave protocol:
     *
     *     ftp:
     *       servers:
     *         produzione:
     *           protocol: "sftp"                            # ftp ( default ) | sftp
     *           address: "..."
     *           port: "22"                                  # default 21 per ftp, 22 per sftp
     *           username: "..."
     *           privkey: "etc/secret/sftp.produzione"       # chiave privata, relativa a DIR_BASE
     *           pubkey: "etc/secret/sftp.produzione.pub"    # chiave pubblica, la vuole ssh2_auth_pubkey_file()
     *           passphrase: "..."                           # facoltativa, nello shadow
     *           password: "..."                             # in alternativa alla chiave, nello shadow
     *           fingerprint: "..."                          # facoltativa, impronta MD5 esadecimale della host key
     *
     * Con privkey il login si fa con la chiave, altrimenti con la password; con fingerprint la connessione si rifiuta se
     * l'impronta della host key è diversa, con o senza i due punti e senza badare alle maiuscole. La chiave privata va fuori
     * dalla document root servita ( etc/secret/ ) e, con il libssh2 di Debian 10, in formato PEM ( ssh-keygen -m PEM ).
     *
     * In FTP la connessione è la risorsa di ftp_connect(), in SFTP un array con il protocollo, le risorse di ssh2_connect() e
     * di ssh2_sftp() e la cartella di partenza; chi la riceve da ftpConnect() la passa alle altre funzioni senza guardarci
     * dentro. In tutti e due i protocolli un percorso remoto senza la barra iniziale vale a partire dalla cartella in cui
     * il server fa entrare al login.
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
     * ftpConnect()             | effettua la connessione a un server FTP o SFTP
     * ftpClose()               | chiude la connessione al server FTP o SFTP
     *
     * funzioni per l'upload e il download
     * -----------------------------------
     * Queste funzioni permettono di caricare e scaricare file da un server FTP.
     *
     * funzione                 | descrizione
     * -------------------------|---------------------------------------------------------------
     * ftpPutFile()             | carica un file su un server FTP o SFTP
     * ftpGetFile()             | scarica un file da un server FTP o SFTP
     * ftpGetUploadTypeByFile() | restituisce il tipo di trasferimento da utilizzare per un file
     *
     * funzioni per il browsing del server
     * -----------------------------------
     * Queste funzioni permettono di esplorare il contenuto di un server FTP, elencando i file e le cartelle presenti.
     *
     * funzione                 | descrizione
     * -------------------------|---------------------------------------------------------------
     * ftpListFiles()           | restituisce la lista dei file presenti in una cartella del server FTP o SFTP
     * ftpGetFileTime()         | restituisce la data di ultima modifica di un file del server FTP o SFTP
     * ftpSftpPath()            | restituisce il percorso assoluto di un percorso remoto SFTP
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
     * Per l'SFTP serve l'estensione PHP ssh2 ( pacchetto php-ssh2 ); senza, ftpConnect() su un server SFTP scrive l'errore
     * nel log e restituisce false.
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
     * 2026-11-10       | Fabio Mosti          | SFTP con la chiave protocol, percorsi relativi alla cartella di login, ftpGetFileTime()
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
     * effettua la connessione a un server FTP o SFTP
     *
     * Questa funzione crea una connessione a un server FTP e imposta la modalità passiva (di default) oppure attiva.
     * Restituisce un oggetto connessione che può essere utilizzato per dare comandi, caricare e scaricare file, elencare
     * il contenuto del server, e così via. La variabile $srv è un array associativo che contiene i dati del server FTP:
     * - protocol: ftp ( default ) oppure sftp
     * - address: indirizzo del server FTP
     * - port: porta del server FTP (di default 21, 22 per l'SFTP)
     * - username: nome utente per il login
     * - password: password per il login
     * - privkey, pubkey, passphrase: chiave per il login SFTP, al posto della password
     * - fingerprint: impronta MD5 esadecimale della host key SFTP, se la si vuole verificare
     *
     * @param       $srv        array       array associativo con i dati del server FTP
     *
     * @return      mixed       $conn       oggetto connessione al server FTP o SFTP, false se la connessione non riesce
     *
     */
    function ftpConnect( $srv ) {

        // SFTP
        if( isset( $srv['protocol'] ) && strtolower( $srv['protocol'] ) == 'sftp' ) {

            if( ! function_exists( 'ssh2_connect' ) ) {
                logger( 'estensione ssh2 assente, impossibile usare l\'SFTP', 'ftp', LOG_ERR );
                return false;
            }

            $ssh = @ssh2_connect( $srv['address'], ( empty( $srv['port'] ) ) ? 22 : $srv['port'] );

            if( empty( $ssh ) ) {
                logger( 'impossibile connettersi al server SFTP', 'ftp', LOG_ERR );
                return false;
            }

            // verifica dell'impronta della host key
            if( ! empty( $srv['fingerprint'] ) ) {
                $impronta = ssh2_fingerprint( $ssh, SSH2_FINGERPRINT_MD5 | SSH2_FINGERPRINT_HEX );
                if( strtolower( str_replace( ':', '', $srv['fingerprint'] ) ) != strtolower( $impronta ) ) {
                    logger( 'impronta della host key SFTP diversa da quella attesa: ' . $impronta, 'ftp', LOG_ERR );
                    return false;
                }
            }

            // login con la chiave o con la password
            if( ! empty( $srv['privkey'] ) ) {
                $login = @ssh2_auth_pubkey_file( $ssh, $srv['username'], fullpath( $srv['pubkey'] ), fullpath( $srv['privkey'] ), ( isset( $srv['passphrase'] ) ) ? $srv['passphrase'] : '' );
            } else {
                $login = @ssh2_auth_password( $ssh, $srv['username'], $srv['password'] );
            }

            if( $login != true ) {
                logger( 'impossibile effettuare il login', 'ftp', LOG_ERR );
                return false;
            }

            $sftp = @ssh2_sftp( $ssh );

            if( empty( $sftp ) ) {
                logger( 'impossibile avviare il sottosistema SFTP', 'ftp', LOG_ERR );
                return false;
            }

            return array(
                'protocol'  => 'sftp',
                'ssh'       => $ssh,
                'sftp'      => $sftp,
                'home'      => rtrim( ssh2_sftp_realpath( $sftp, '.' ), '/' ) . '/'
            );

        }

        $conn = ftp_connect( $srv['address'], ( empty( $srv['port'] ) ) ? 21 : $srv['port'], 5 );

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
     * chiude la connessione al server FTP o SFTP
     *
     * Questa funzione chiude la connessione al server FTP e rilascia le risorse utilizzate.
     *
     * La connessione si riceve per riferimento perché in SFTP non si chiama ssh2_disconnect(): con l'estensione ssh2
     * 1.1.2, dopo che il wrapper ssh2.sftp:// è stato usato o con la risorsa di ssh2_sftp() ancora viva, manda in crash
     * PHP a fine script ( Apache risponde vuoto ). Si rilasciano invece le due risorse, e la sessione la chiude PHP
     * liberandole; dopo la chiusura la connessione SFTP non è più utilizzabile.
     *
     * @param       $conn      mixed       oggetto connessione restituito da ftpConnect()
     *
     * @return      bool        true se la connessione è stata chiusa correttamente, false altrimenti
     *
     */
    function ftpClose( &$conn ) {

        // SFTP
        if( is_array( $conn ) ) {
            $conn['sftp'] = NULL;
            $conn['ssh'] = NULL;
            return true;
        }

        return ftp_close( $conn );

    }

    /**
     * FUNZIONI PER L'UPLOAD E IL DOWNLOAD
     */

    /**
     * carica un file su un server FTP o SFTP
     *
     * Questa funzione carica un file su un server FTP, creando le cartelle che mancano. Un percorso remoto senza la barra
     * iniziale vale a partire dalla cartella di login, e in FTP la cartella corrente alla fine è quella di partenza.
     *
     * @param       $conn       mixed       oggetto connessione restituito da ftpConnect()
     * @param       $localFile  string      percorso del file locale da caricare
     * @param       $remoteFile string      percorso del file remoto dove caricare il file
     *
     * @return      bool        true se il file è stato caricato correttamente, false altrimenti
     *
     */
    function ftpPutFile( $conn, $localFile, $remoteFile ) {

        $localFile = fullpath( $localFile );

        // SFTP
        if( is_array( $conn ) ) {

            $remoteFile = ftpSftpPath( $conn, $remoteFile );

            if( @ssh2_sftp_stat( $conn['sftp'], dirname( $remoteFile ) ) === false ) {
                @ssh2_sftp_mkdir( $conn['sftp'], dirname( $remoteFile ), 0755, true );
            }

            $result = @copy( $localFile, ftpSftpUrl( $conn, $remoteFile, $link ) );
            ftpSftpUnlink( $conn, $link );

            if( $result == false ) {
                logger( 'impossibile caricare il file ' . $localFile . ' su ' . $remoteFile, 'ftp', LOG_ERR );
                return false;
            }

            return true;

        }

        $type = ftpGetUploadTypeByFile( $localFile );

        // percorso relativo alla cartella corrente, che si rimette a posto alla fine
        $cwd = ftp_pwd( $conn );
        if( substr( $remoteFile, 0, 1 ) != '/' ) {
            $remoteFile = rtrim( $cwd, '/' ) . '/' . $remoteFile;
        }

        $dir = '/';
        $path = explode( '/', dirname( $remoteFile ) );
        foreach( $path as $chdir ) {
            if( $chdir === '' ) {
                continue;
            }
            $dir = $dir . $chdir . '/';
            $ftpDir = @ftp_chdir( $conn, $dir );
            if( empty( $ftpDir ) ) {
                $ftpDir = ftp_mkdir( $conn, $chdir );
                $ftpDir = ftp_chdir( $conn, $chdir );
            }
        }

        $result = ftp_put( $conn, $remoteFile, $localFile, $type );

        @ftp_chdir( $conn, $cwd );

        if( $result == false ) {
            logger( 'impossibile caricare il file ' . $localFile . ' su ' . $remoteFile, 'ftp', LOG_ERR );
            return false;
        }

        return true;

    }

    /**
     * scarica un file da un server FTP o SFTP
     *
     * Questa funzione scarica un file da un server FTP.
     *
     * @param       $conn       mixed       oggetto connessione restituito da ftpConnect()
     * @param       $remoteFile string      percorso del file remoto da scaricare
     * @param       $localFile  string      percorso del file locale dove salvare il file scaricato
     *
     * @return      bool        true se il file è stato scaricato correttamente, false altrimenti
     *
     */
    function ftpGetFile( $conn, $remoteFile, $localFile ) {

        $localFile = fullpath( $localFile );

        checkFolder( dirname( $localFile ) );

        // SFTP
        if( is_array( $conn ) ) {
            $result = @copy( ftpSftpUrl( $conn, ftpSftpPath( $conn, $remoteFile ), $link ), $localFile );
            ftpSftpUnlink( $conn, $link );
        } else {
            $type = ftpGetUploadTypeByFile( $remoteFile );
            $result = ftp_get( $conn, $localFile, $remoteFile, $type );
        }

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
     * restituisce la lista dei file presenti in una cartella del server FTP o SFTP
     *
     * Questa funzione restituisce la lista dei file presenti in una cartella del server FTP; in SFTP i nomi sono preceduti
     * dal percorso della cartella, come li restituisce di solito ftp_nlist(), e senza . e ..
     *
     * @param       $conn      mixed       oggetto connessione restituito da ftpConnect()
     * @param       $path      string      percorso della cartella da esplorare (di default è la root '/')
     *
     * @return      array       lista dei file presenti nella cartella
     *
     */
    function ftpListFiles( $conn, $path = '/' ) {

        // SFTP
        if( is_array( $conn ) ) {
            $dir = ftpSftpPath( $conn, $path );
            $files = @scandir( ftpSftpUrl( $conn, $dir, $link ) );
            ftpSftpUnlink( $conn, $link );
            if( empty( $files ) ) {
                return array();
            }
            $lista = array();
            foreach( array_diff( $files, array( '.', '..' ) ) as $file ) {
                $lista[] = rtrim( $path, '/' ) . '/' . $file;
            }
            return $lista;
        }

        // ottengo la lista dei file
        $files = ftp_nlist( $conn, $path );

        // se non ho ottenuto nulla ritorno un array vuoto
        if( empty( $files ) ) {
            return array();
        }

        return $files;

    }

    /**
     * restituisce la data di ultima modifica di un file del server FTP o SFTP
     *
     * Questa funzione restituisce il timestamp Unix dell'ultima modifica di un file remoto, con ftp_mdtm() in FTP e
     * ssh2_sftp_stat() in SFTP. Serve per caricare un file solo se quello locale è più recente; non tutti i server FTP
     * danno la data, e chi chiama deve prevedere il false.
     *
     * @param       $conn       mixed       oggetto connessione restituito da ftpConnect()
     * @param       $remoteFile string      percorso del file remoto
     *
     * @return      mixed       il timestamp dell'ultima modifica, false se il file non c'è o il server non dà la data
     *
     */
    function ftpGetFileTime( $conn, $remoteFile ) {

        // SFTP
        if( is_array( $conn ) ) {
            $stat = @ssh2_sftp_stat( $conn['sftp'], ftpSftpPath( $conn, $remoteFile ) );
            return ( empty( $stat['mtime'] ) ) ? false : $stat['mtime'];
        }

        $time = @ftp_mdtm( $conn, $remoteFile );

        return ( $time < 0 ) ? false : $time;

    }

    /**
     * restituisce il percorso assoluto di un percorso remoto SFTP
     *
     * Questa funzione completa con la cartella di login un percorso remoto senza la barra iniziale; il wrapper ssh2.sftp://
     * vuole i percorsi assoluti.
     *
     * @param       $conn       array       oggetto connessione SFTP restituito da ftpConnect()
     * @param       $path       string      percorso remoto, assoluto o relativo alla cartella di login
     *
     * @return      string      il percorso assoluto
     *
     */
    function ftpSftpPath( $conn, $path ) {

        if( substr( $path, 0, 1 ) == '/' ) {
            return $path;
        }

        return $conn['home'] . $path;

    }

    /**
     * restituisce l'URL del wrapper ssh2.sftp:// per un percorso remoto SFTP assoluto
     *
     * Il wrapper legge il percorso come un URL e non lo decodifica: un # o un ? nel nome ne tronca il resto, che diventa
     * frammento o query ( var/contenuti/#21OTT.pdf diventa var/contenuti/, e copy() si ferma perché la destinazione è una
     * cartella ), e scritto come %23 o %3F resta letterale nel nome. Il 10/11/2026 la pubblicazione SFTP di gimbe ha
     * perso così 95 file. Per questi percorsi la funzione crea nella cartella di login un collegamento simbolico dal nome
     * neutro che punta al percorso vero, anche se non esiste ancora, e restituisce l'URL del collegamento, che chi la
     * chiama toglie con ftpSftpUnlink() dopo l'uso. Le funzioni ssh2_sftp_*() prendono il percorso così com'è e non
     * hanno bisogno di niente.
     *
     * @param       $conn       array       oggetto connessione SFTP restituito da ftpConnect()
     * @param       $path       string      percorso remoto assoluto
     * @param       $link       string      il collegamento creato, NULL se non è servito; modificato sul posto
     *
     * @return      string      l'URL da passare a copy(), scandir() e simili
     *
     */
    function ftpSftpUrl( $conn, $path, &$link = NULL ) {

        $link = NULL;

        if( strpbrk( $path, '#?' ) === false ) {
            return 'ssh2.sftp://' . intval( $conn['sftp'] ) . $path;
        }

        $link = $conn['home'] . '.glisweb.' . md5( $path . microtime( true ) . mt_rand() );

        if( @ssh2_sftp_symlink( $conn['sftp'], $path, $link ) === false ) {
            logger( 'impossibile creare il collegamento ' . $link . ' per ' . $path, 'ftp', LOG_ERR );
            $link = NULL;
        }

        return 'ssh2.sftp://' . intval( $conn['sftp'] ) . ( ( $link === NULL ) ? $path : $link );

    }

    /**
     * toglie il collegamento simbolico creato da ftpSftpUrl()
     *
     * @param       $conn       array       oggetto connessione SFTP restituito da ftpConnect()
     * @param       $link       string      il collegamento restituito da ftpSftpUrl(), NULL se non ce n'è
     *
     * @return      void
     *
     */
    function ftpSftpUnlink( $conn, $link ) {

        if( $link !== NULL ) {
            @ssh2_sftp_unlink( $conn['sftp'], $link );
        }

    }
