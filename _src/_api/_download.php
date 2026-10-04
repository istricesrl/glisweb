<?php

    /**
     * API di download standard
     * 
     * questo script ha il compito di gestire il download dei file
     * 
     * introduzione
     * ============
     * È conoscenza comune il fatto che di per sé il download dei file è sempre possibile tramite un server web posto che i file che si desidera
     * scaricare siano nella document root del server stesso e che l'utente con cui gira il server web abbia i permessi di lettura su tali file.
     * Ovviamente è possibile impedire il download di file specifici modificandone i permessi o creando delle regole apposite nel file .htaccess;
     * tuttavia questo approccio è insufficiente quando si tratta di file caricati tramite il CMS in quanto non è sempre possibile conoscerne
     * il nome e il percorso a priori. Inoltre, un approccio totalmente basato sulla configurazione del server web non terrebbe conto del fatto che
     * i download potrebbero essere gestiti anche in base a criteri interni all'applicazione.
     * 
     * Per ovviare a questo problema, tramite una regola del file .htaccess tutte le richieste di accesso ai file che si trovano nella cartella
     * var/ vengono reindirizzate a questo script che si occupa di verificare se l'utente è autorizzato a scaricare il file richiesto. La regola in
     * questione è la seguente ( il percorso viaggia in una variabile d'ambiente, non nella query string: vedi "origine dei parametri" ):
     * 
     * ```
     * RewriteRule ^var/(.+)$ _src/_api/_download.php [E=GLIS_DOWNLOAD:var/$1,L,QSA]
     * ```
     * 
     * Anche se attualmente il compito principale di questa API è quello di verificare l'autorizzazione al download, la sua peculiare posizione la
     * rende una candidata ottimale per il rilevamento di statistiche e altre attività di monitoraggio e controllo; ad esempio potrebbe essere
     * possibile in futuro contare il numero di download di file, eccetera.
     * 
     * integrazione con il modulo mailing
     * ----------------------------------
     * Attualmente l'integrazione più importante con questa API è quella con il modulo di mailing; tramite questa integrazione è possibile rilevare
     * la lettura delle mail inviate. In questo caso, il modulo di mailing inserisce un parametro __mailing__ nell'URL del file da scaricare e questo
     * script si occupa di riportare il dato rilevato nel database. Le regole specifiche per il mailing sono:
     * 
     * ```
     * RewriteRule ^mailing/([0-9]+)/var/(.+)$ _src/_api/_download.php [E=GLIS_DOWNLOAD:var/$2,E=GLIS_MAILING:$1,L,QSA]
     * RewriteRule ^mailing/([0-9]+)/([0-9]+)/var/(.+)$ _src/_api/_download.php [E=GLIS_DOWNLOAD:var/$3,E=GLIS_MAILING:$1,E=GLIS_MAILING_DST:$2,L,QSA]
     * ```
     * 
     */

    /**
     * inclusione del framework
     * ========================
     * 
     */

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // debug
    // print_r( $_GET );
    // print_r( $_REQUEST );
    // die();
    // ini_set('display_errors', 1);
    // ini_set('display_startup_errors', 1);
    // error_reporting(E_ALL);

    // variabile generale per il comportamento
    $authorized = false;

    /**
     * origine dei parametri
     * =====================
     *
     * Il percorso del file e gli identificativi del mailing li mette il .htaccess in variabili
     * d'ambiente ( E=GLIS_DOWNLOAD, E=GLIS_MAILING, E=GLIS_MAILING_DST ), che dopo la riscrittura
     * interna PHP vede col prefisso REDIRECT_. Fino al 04/10/2026 viaggiavano nella query string
     * ( ?__download__=var/$1 con QSA ), e il client poteva scavalcarli: bastava chiamare lo script
     * direttamente, oppure accodare un proprio __download__ a una URL var/..., perche' PHP tiene
     * l'ultimo dei parametri omonimi, che era quello del client. Ne veniva la lettura di qualunque
     * file del deploy, src/config.json compreso. Il client le variabili d'ambiente non le puo'
     * impostare, quindi quello che arriva da $_REQUEST qui non si guarda piu': lo si sovrascrive
     * col valore del .htaccess, cosi' le macro custom di download che leggono
     * $_REQUEST['__download__'] continuano a funzionare e vedono il valore buono.
     */

    // lettura delle variabili d'ambiente impostate dal .htaccess
    foreach( array( 'GLIS_DOWNLOAD' => '__download__', 'GLIS_MAILING' => '__mailing__', 'GLIS_MAILING_DST' => '__mailing_dst__' ) as $variabile => $parametro ) {

        // quello che manda il client non vale
        unset( $_REQUEST[ $parametro ], $_GET[ $parametro ], $_POST[ $parametro ] );

        // vale solo quello che ha messo il .htaccess
        if( isset( $_SERVER[ 'REDIRECT_' . $variabile ] ) ) {
            $_REQUEST[ $parametro ] = $_SERVER[ 'REDIRECT_' . $variabile ];
        } elseif( isset( $_SERVER[ $variabile ] ) ) {
            $_REQUEST[ $parametro ] = $_SERVER[ $variabile ];
        }

    }

    // gli identificativi del mailing sono numerici ( lo garantisce gia' la RewriteRule )
    foreach( array( '__mailing__', '__mailing_dst__' ) as $parametro ) {
        if( isset( $_REQUEST[ $parametro ] ) && ! ctype_digit( (string) $_REQUEST[ $parametro ] ) ) {
            unset( $_REQUEST[ $parametro ] );
        }
    }

    // senza percorso dal .htaccess lo script e' stato chiamato direttamente
    if( empty( $_REQUEST['__download__'] ) ) {
        http_response_code( 403 );
        header( 'Content-Type: text/plain; charset=utf-8' );
        die( 'accesso negato' );
    }

    /**
     * integrazione con il modulo mailing
     * ==================================
     * 
     */

    // se il file .htaccess ha popolato il parametro __mailing__
    if( isset( $_REQUEST['__mailing__'] ) ) {

        // se il file .htaccess ha popolato il parametro __mailing_dst__
        if( isset( $_REQUEST['__mailing_dst__'] ) ) {

            // log
            logger( 'rilevata lettura mailing #' . $_REQUEST['__mailing__'] . ' per mail #' . $_REQUEST['__mailing_dst__'], 'mailing' );

            // attività di lettura
            $read = array(
                'id_tipologia' => 35,
                'id_mailing' => $_REQUEST['__mailing__'],
                'data_attivita' => date( 'Y-m-d' ),
                'ora_fine' => date( 'H:i' ),
                'id_mail' => $_REQUEST['__mailing_dst__'],
                'nome' => 'apertura mail da mailing #' . $_REQUEST['__mailing__']
            );

            // recupero l'id_cliente
            $read['id_cliente'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id_anagrafica 
                FROM mail WHERE id = ?',
                array(
                    array( 's' => $_REQUEST['__mailing_dst__'] )
                )
            );

            // controllo che non ci siano attività di lettura già entro 4 ore
            $check = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT COUNT(*) 
                FROM attivita 
                WHERE id_tipologia = ? 
                AND id_mailing = ? 
                AND id_mail = ? 
                AND data_attivita = ? 
                AND ora_fine > ?',
                array(
                    array( 's' => 35 ),
                    array( 's' => $_REQUEST['__mailing__'] ),
                    array( 's' => $_REQUEST['__mailing_dst__'] ),
                    array( 's' => date( 'Y-m-d' ) ),
                    array( 's' => date( 'H:i', strtotime( '-4 hours' ) ) )
                )
            );

        } else {

            // log
            logger( 'rilevata lettura mailing #' . $_REQUEST['__mailing__'], 'mailing' );

            // attività di lettura
            $read = array(
                'id_tipologia' => 35,
                'id_mailing' => $_REQUEST['__mailing__'],
                'data_attivita' => date( 'Y-m-d' ),
                'ora_fine' => date( 'H:i' ),
                'nome' => 'apertura mail da mailing #' . $_REQUEST['__mailing__']
            );

            // controllo che non ci siano attività di lettura già entro 4 ore
            $check = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT COUNT(*) 
                FROM attivita 
                WHERE id_tipologia = ? 
                AND id_mailing = ? 
                AND data_attivita = ? 
                AND ora_fine > ?',
                array(
                    array( 's' => 35 ),
                    array( 's' => $_REQUEST['__mailing__'] ),
                    array( 's' => date( 'Y-m-d' ) ),
                    array( 's' => date( 'H:i', strtotime( '-4 hours' ) ) )
                )
            );

        }

        // inserimento attività di lettura
        if( empty( $check ) ) {

            // inserimento attività
            mysqlInsertRow(
                $cf['mysql']['connection'],
                $read,
                'attivita'
            );

        }

    }

    /**
     * attivazione dell'account tramite token (tk)
     * ===========================================
     *
     */

    // TODO
    if( isset( $_REQUEST['tk'] ) ) {
    }

    /**
     * pulizia e normalizzazione del nome del file
     * ===========================================
     * 
     */

    // ipotesi
    if( ! file_exists( DIR_BASE . $_REQUEST['__download__'] ) && strpos( $_REQUEST['__download__'], '+' ) !== false ) {
        $_REQUEST['__download__'] = str_replace( '+', ' ', $_REQUEST['__download__'] );
    }

    /**
     * confinamento in var/
     * ====================
     *
     * Si servono solo file sotto var/, e il controllo e' doppio. Il primo e' sul percorso cosi'
     * com'e' scritto: comincia con var/ e non ha segmenti vuoti, '.' o '..', ne' backslash o byte
     * nulli, quindi non puo' risalire da solo. Il secondo e' sul percorso risolto da realpath():
     * se un collegamento simbolico dentro var/ porta altrove nel deploy ( src/, _src/, etc/ ) il
     * file si rifiuta. Un collegamento che porta FUORI dal deploy invece resta servibile, perche'
     * e' cosi' che alcuni deploy montano archivi esterni ( gimbe, var/contenuti/rassegna/ ): li'
     * il collegamento l'ha messo chi amministra la macchina, e dal client non si raggiunge.
     */

    // controllo sul percorso scritto
    $segmentiDownload = explode( '/', $_REQUEST['__download__'] );
    $percorsoValido = ( $segmentiDownload[0] === 'var' && count( $segmentiDownload ) > 1 )
        && strpbrk( $_REQUEST['__download__'], "\\\0" ) === false
        && count( array_intersect( $segmentiDownload, array( '', '.', '..' ) ) ) === 0;

    // controllo sul percorso risolto
    if( $percorsoValido ) {
        $percorsoReale = realpath( DIR_BASE . $_REQUEST['__download__'] );
        $baseReale = rtrim( realpath( DIR_BASE ), '/' ) . '/';
        $varReale = rtrim( realpath( DIR_BASE . 'var' ), '/' ) . '/';
        if( $percorsoReale !== false && strpos( $percorsoReale, $baseReale ) === 0 && strpos( $percorsoReale, $varReale ) !== 0 ) {
            $percorsoValido = false;
        }
    }

    // fuori da var/ si nega
    if( ! $percorsoValido ) {
        logger( 'download negato fuori da var/: ' . $_REQUEST['__download__'], 'security', LOG_ERR );
        http_response_code( 403 );
        header( 'Content-Type: text/plain; charset=utf-8' );
        die( 'accesso negato' );
    }

    /**
     * logiche standard di protezione dei file
     * =======================================
     *
     */

    clearstatcache(true, DIR_BASE . $_REQUEST['__download__']);

    // nei messaggi il percorso relativo: quello assoluto rivela dove sta il deploy sul disco
    if (!is_file(DIR_BASE . $_REQUEST['__download__'])) {
        http_response_code(404);
        header('Content-Type: text/plain; charset=utf-8');
        die("File non trovato: " . $_REQUEST['__download__']);
    }

    if (!is_readable(DIR_BASE . $_REQUEST['__download__'])) {
        http_response_code(403);
        header('Content-Type: text/plain; charset=utf-8');
        die("File non leggibile da PHP: " . $_REQUEST['__download__']);
    }

    $size = filesize(DIR_BASE . $_REQUEST['__download__']);
    if ($size === false || $size === 0) {
        http_response_code(500);
        header('Content-Type: text/plain; charset=utf-8');
        die("File vuoto (per PHP) o size non disponibile: " . $_REQUEST['__download__']);
    }

    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $mimetype = $finfo->file(DIR_BASE . $_REQUEST['__download__']) ?: 'application/octet-stream';

    // debug
    // die( print_r( $finfo, true ) );
    // var_dump( DIR_BASE . $_REQUEST['__download__'] );
    // var_dump(filesize(DIR_BASE . $_REQUEST['__download__']));
    // var_dump( $mimetype );
    // var_dump( $finfo );
    // die();

    // verifico se il file è associato a oggetti del database
    $check = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT id FROM ( 
            SELECT id, path FROM file
            UNION
            SELECT id, path FROM immagini
        ) AS var
        WHERE var.path = ?',
        array(
            array( 's' => $_REQUEST['__download__'] )
        )
    );

    // autorizzo il download se il file non è associato a oggetti del database
    if( empty( $check ) ) {

        // autorizzazione
        $authorized = true;

    } else {

        // TODO qui anziché mettere semplicemente true vanno implementate le logiche
        // di protezione dei file associati a oggetti del database
        $authorized = true;

    }

    /**
     * logiche custom di protezione dei file
     * =====================================
     * 
     */

    // ricerca delle macro di download
    $arrayMacroBase             = glob( glob2custom( DIR_SRC_INC_MACRO . '_download.php' ), GLOB_BRACE );
    $arrayMacroModuli           = glob( glob2custom( DIR_MOD_ATTIVI_SRC_INC_MACRO . '_download.php' ), GLOB_BRACE );
    $arrayMacro                 = array_unique( array_merge( $arrayMacroBase , $arrayMacroModuli ) );

    // debug
    // die( print_r( $arrayMacro, true ) );

    // inclusione delle macro
    foreach( $arrayMacro as $fileMacro ) {
        require $fileMacro;
    }

    /**
     * download del file
     * =================
     * 
     */

    // debug
    // var_dump( $authorized );
    // die();

    // restituzione contenuto
    if( $authorized === true ) {

        /**
         * validatori di cache e richieste parziali
         * ========================================
         *
         * Finche' una cartella di var/ sfuggiva a questa API ( bastava un RewriteEngine On in un
         * .htaccess locale, come era per var/contenuti/ fino al 21/09/2026 ) i suoi file li
         * serviva Apache, che di suo manda Last-Modified, ETag e Accept-Ranges. Ricondurre quei
         * file qui dentro per poterli tracciare li faceva regredire in silenzio su tre fronti:
         * niente 304 sul secondo accesso, niente ripresa di un trasferimento interrotto, e un
         * Cache-Control: no-store ereditato dalla sessione che impedisce al browser perfino di
         * tenerne una copia. Su un PDF da 30 MB scaricato in diretta durante la presentazione di
         * un Rapporto, e' la differenza fra un download che riparte da dove si era rotto e uno
         * che ricomincia da capo ogni volta.
         *
         * Il Cache-Control e' 'private': i file di var/ non sono tutti pubblici, quindi si
         * consente la copia nel browser di chi ha fatto la richiesta ma non nelle cache
         * condivise, e si impone comunque la rivalidazione a ogni accesso.
         */
        $percorsoFile   = DIR_BASE . $_REQUEST['__download__'];
        $dimensioneFile = filesize( $percorsoFile );
        $modificaFile   = filemtime( $percorsoFile );
        $etag           = '"' . dechex( $dimensioneFile ) . '-' . dechex( $modificaFile ) . '"';

        // i validatori sostituiscono quelli che la sessione ha gia' emesso
        header_remove( 'Expires' );
        header_remove( 'Pragma' );
        header( 'Cache-Control: private, max-age=0, must-revalidate' );
        header( 'Last-Modified: ' . gmdate( 'D, d M Y H:i:s', $modificaFile ) . ' GMT' );
        header( 'ETag: ' . $etag );
        header( 'Accept-Ranges: bytes' );

        // il client ha gia' la copia buona: 304 e non si trasmette niente
        $etagClient = isset( $_SERVER['HTTP_IF_NONE_MATCH'] ) ? trim( $_SERVER['HTTP_IF_NONE_MATCH'] ) : NULL;
        $dataClient = isset( $_SERVER['HTTP_IF_MODIFIED_SINCE'] ) ? strtotime( $_SERVER['HTTP_IF_MODIFIED_SINCE'] ) : NULL;

        if( ( $etagClient !== NULL && $etagClient === $etag ) || ( $etagClient === NULL && $dataClient !== NULL && $dataClient >= $modificaFile ) ) {

            http_response_code( 304 );
            exit;

        }

        /**
         * richiesta parziale
         * ==================
         *
         * Si gestisce il solo intervallo singolo ( bytes=inizio-fine ), che e' quello che mandano
         * i browser e i gestori di download quando riprendono un trasferimento interrotto. Le
         * richieste multi-intervallo vogliono una risposta multipart/byteranges che qui non
         * servirebbe a nessuno: si ignorano e si risponde con il file intero, che e' un
         * comportamento lecito.
         */
        $inizio = 0;
        $fine   = $dimensioneFile - 1;
        $parziale = false;

        if( isset( $_SERVER['HTTP_RANGE'] ) && preg_match( '/^bytes=(\d*)-(\d*)$/', trim( $_SERVER['HTTP_RANGE'] ), $intervallo ) ) {

            if( $intervallo[1] === '' && $intervallo[2] === '' ) {

                // 'bytes=-' non chiede niente di sensato
                $parziale = false;

            } elseif( $intervallo[1] === '' ) {

                // suffisso: gli ultimi N byte
                $lunghezza = (int) $intervallo[2];
                $inizio    = max( 0, $dimensioneFile - $lunghezza );
                $parziale  = ( $lunghezza > 0 );

            } else {

                $inizio   = (int) $intervallo[1];
                $fine     = ( $intervallo[2] === '' ) ? $dimensioneFile - 1 : (int) $intervallo[2];
                $parziale = true;

            }

            // intervallo fuori dal file: 416 e si dice quanto e' lungo davvero
            if( $parziale && ( $inizio > $fine || $inizio >= $dimensioneFile ) ) {

                http_response_code( 416 );
                header( 'Content-Range: bytes */' . $dimensioneFile );
                exit;

            }

            if( $fine >= $dimensioneFile ) {
                $fine = $dimensioneFile - 1;
            }

        }

        // header
        header( 'content-type: ' . $mimetype );

        if( $parziale ) {

            http_response_code( 206 );
            header( 'Content-Range: bytes ' . $inizio . '-' . $fine . '/' . $dimensioneFile );

        }

        header( 'Content-Length: ' . ( $fine - $inizio + 1 ) );

        // debug
        // var_dump( $mimetype );
        // var_dump( DIR_BASE . $_REQUEST['__download__'] );
        // die();

        // download
        //
        // ATTENZIONE: qui non ci va file_get_contents(), che carica in memoria l'intero file
        // prima di mandarne un solo byte. Ogni worker Apache che serve un download si porta
        // dietro il peso del file: su un PDF da 29 MB ( il Rapporto GIMBE ) sono 29 MB di
        // picco PHP a richiesta contro i 2 MB di readfile(), che manda a blocchi. Con
        // mpm_prefork e MaxRequestWorkers a 150 la differenza e' fra qualche centinaio di
        // megabyte e una decina di gigabyte, cioe' fra reggere e farsi uccidere dall'OOM
        // killer proprio nel momento in cui il file serve: la presentazione in diretta di un
        // Rapporto, quando tutti scaricano nello stesso minuto.
        //
        // set_time_limit( 0 ) perche' un file grosso su una linea lenta puo' durare piu' del
        // max_execution_time: il download non e' calcolo, e non va interrotto a meta'.
        set_time_limit( 0 );

        if( ! $parziale ) {

            readfile( $percorsoFile );

        } else {

            // stesso principio di readfile(): si manda a blocchi, senza mai tenere in memoria
            // piu' di un blocco per volta, partendo dall'offset chiesto dal client
            $maniglia = fopen( $percorsoFile, 'rb' );

            if( $maniglia !== false ) {

                fseek( $maniglia, $inizio );
                $restano = $fine - $inizio + 1;

                while( $restano > 0 && ! feof( $maniglia ) ) {

                    $blocco = fread( $maniglia, min( 8192, $restano ) );

                    if( $blocco === false ) {
                        break;
                    }

                    echo $blocco;
                    $restano -= strlen( $blocco );

                    // il client puo' chiudere a meta': inutile continuare a leggere il disco
                    if( connection_aborted() ) {
                        break;
                    }

                }

                fclose( $maniglia );

            }

        }

    } else {

        // header
        http_response_code( 403 );
        header( 'content-type: text/plain' );

        // messaggio di errore
        echo 'accesso negato per ' . $_REQUEST['__download__'];

    }
