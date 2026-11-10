<?php

    /**
     * 
     * richiede ad es. ?id=1&target=PROD
     * 
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_SISTEMA' );

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivata una pagina
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['id'] ) ) {

        // ID della pagina
        $status['id'] = $_REQUEST['id'];

        // verifico se è aspecificato il target
        if( ! empty( $_REQUEST['target'] ) && ! empty( $_REQUEST['target'] ) ) {

            // target della pagina
            $status['target'] = $_REQUEST['target'];

            // server target
            if( isset( $cf['mysql']['profiles'][ $_REQUEST['target'] ]['servers'] ) ) {

                // server
                $server = $cf['mysql']['servers'][ $cf['mysql']['profiles'][ $_REQUEST['target'] ]['servers'][0] ];

                // inizializzo la connessione al database target
                $cTarget = mysqli_init();

                // riduco il tempo massimo di connessione: senza, un target irraggiungibile tiene ferma la modale per
                // default_socket_timeout ( 60 secondi ) prima di rispondere ( segnalato da gimbe il 09/11/2026 )
                mysqli_options( $cTarget, MYSQLI_OPT_CONNECT_TIMEOUT, 5 );

                // connessione al database target
                // NOTA su PHP 8 mysqli_real_connect() lancia un'eccezione invece di restituire false
                try {
                    if( ! @mysqli_real_connect(
                        $cTarget,
                        $server['address'],
                        $server['username'],
                        $server['password'],
                        $server['db'],
                        ( ( ! empty( $server['port'] ) ) ? (int) $server['port'] : NULL )
                    ) ) {
                        $cTarget = false;
                    }
                } catch( Exception $e ) {
                    $cTarget = false;
                }

                // verifico la connessione target
                if( ! empty( $cTarget ) ) {

                    // recupero la pagina
                    $source = mysqlSelectRow(
                        $cf['mysql']['connection'],
                        'SELECT * FROM pagine WHERE id = ?',
                        array( array( 's' => $_REQUEST['id'] ) ) 
                    );

                    // controllo se la riga esiste
                    if( ! empty( $source ) ) {

                        // inserisco la pagina
                        $idPagina = mysqlInsertRow(
                            $cTarget,
                            $source,
                            'pagine'
                        );

                        // verifica inserimento pagina
                        if( ! empty( $idPagina ) ) {

                            // status
                            $status['info'][] = 'inserita la pagina ' . $idPagina;

                            // oggetti collegati
                            foreach( array( 'contenuti', 'menu', 'immagini', 'file', 'metadati', 'macro', 'pubblicazioni', 'video' ) as $entita ) {

                                // status
                                $status['info'][] = 'procedo con l\'inserimento di ' . $entita;

                                // recupero le entità da inserire
                                $ents = mysqlQuery(
                                    $cf['mysql']['connection'],
                                    'SELECT * FROM ' . $entita . ' WHERE id_pagina = ?',
                                    array( array( 's' => $_REQUEST['id'] ) ) 
                                );

                                // inserisco le entità
                                foreach( $ents as $ent ) {

                                    // inserimento
                                    $xId = mysqlInsertRow(
                                        $cTarget,
                                        $ent,
                                        $entita
                                    );

                                    // status
                                    if( ! empty( $xId ) ) {
                                        $status['info'][] = 'inserito ' . $entita . ' ' . $xId;
                                    } else {
                                        $status['err'][] = 'impossibile inserire ' . $entita . ' per la pagina ' . $_REQUEST['id'];
                                    }

                                    // copia file
                                    if( in_array( $entita, array( 'immagini', 'file', 'video' ) ) ) {

                                        // TODO implementare caricamento file

                                        // ...
                                        $cont = NULL;
                                        $meta = NULL;
                                        $xField = NULL;

                                        // ...
                                        if( $entita == 'immagini' ) {
                                            $xField = 'id_immagine';
                                        } elseif( $entita == 'file' ) {
                                            $xField = 'id_file';
                                        } elseif( $entita == 'video' ) {
                                            $xField = 'id_video';
                                        }

                                        // ...
                                        if( ! empty( $xField ) && ! empty( $xId ) ) {

                                            // ...
                                            foreach( array( 'contenuti', 'metadati' ) as $xTable ) {

                                                // ...
                                                $cont = mysqlSelectRow(
                                                    $cf['mysql']['connection'],
                                                    'SELECT * FROM ' . $xTable . ' WHERE ' . $xField . ' = ?',
                                                    array( array( 's' => $xId ) ) 
                                                );

                                                // inserimento
                                                if( ! empty( $cont ) ) {
                                                    mysqlInsertRow(
                                                        $cTarget,
                                                        $cont,
                                                        $xTable
                                                    );
                                                }

                                            }

                                        }

                                    }

                                }

                            }

                            // se è andato a buon fine il caricamento del database, procedo con i file
                            if( isset( $cf['ftp']['servers'][ $cf['ftp']['profiles'][ $_REQUEST['target'] ]['servers'][0] ] ) ) {

                                // file collegati alla pagina: immagini, file e video
                                // NOTA fino al 10/11/2026 si mandava anche tutta var/contenuti/, e alla prima pubblicazione si
                                // sovrascrivevano i file che il cliente aggiorna direttamente sulla destinazione ( decisione di Fabio del 09/11/2026 )
                                $toFtp = array();
                                foreach( array( 'immagini', 'file', 'video' ) as $entita ) {
                                    $toFtp = array_merge(
                                        $toFtp,
                                        mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM ' . $entita . ' WHERE id_pagina = ? AND path IS NOT NULL', array( array( 's' => $_REQUEST['id'] ) ) )
                                    );
                                }

                                // template della pagina
                                $template = mysqlSelectValue(
                                    $cf['mysql']['connection'],
                                    'SELECT template FROM pagine WHERE id = ?',
                                    array( array( 's' => $_REQUEST['id'] ) )
                                );

                                // file del template
                                $toFtp = array_merge(
                                    $toFtp,
                                    getRecursiveFileList( path2custom( DIR_BASE . '/' . $template ) )
                                );

                                // dati della vista per i moduli
                                foreach( $cf['mods']['active']['array'] as $mod ) {
                                    $toFtp = array_merge(
                                        $toFtp,
                                        getRecursiveFileList( path2custom( DIR_MOD . '_' . $mod . '/' . $template ) )
                                    );
                                }

                                // server di destinazione, FTP o SFTP secondo la sua chiave protocol ( _src/_lib/_ftp.tools.php )
                                $ftpSrv = $cf['ftp']['servers'][ $cf['ftp']['profiles'][ $_REQUEST['target'] ]['servers'][0] ];

                                // connessione al server; il motivo di un fallimento lo scrive ftpConnect() nel log ftp
                                $ftpConn = ftpConnect( $ftpSrv );

                                // se ho connessione
                                if( ! empty( $ftpConn ) ) {

                                    // contatori
                                    $done = 0;
                                    $fail = 0;

                                    $base = time();

                                    // riferimento dell'ultimo deploy, per i server che non danno la data dei file
                                    $refFile = DIR_VAR .'latest.deploy.'.strtolower( $_REQUEST['target'] ).'.time.conf';

                                    // ...
                                    $refTime = ( file_exists( $refFile ) ) ? filemtime( $refFile ) : 0;

                                    // log
                                    logger( 'tref di ' . $refFile . ' -> ' . $refTime, 'details/ftp.log' );

                                    // ...
                                    foreach( $toFtp as $to ) {

                                        // normalizzazione percorsi: relativi a DIR_BASE, e sulla destinazione alla cartella di login
                                        $to = shortPath( $to );

                                        // un file registrato nel database ma assente in locale non si puo' mandare
                                        if( ! file_exists( getFullPath( $to ) ) ) {

                                            $fail++;
                                            $status['err'][] = 'impossibile trasferire ' . $to . ' errore: file locale assente';
                                            $esito = 'KO';

                                            // ...
                                            appendToFile( date( 'Y-m-d H:i:s' ) . ' ' . $esito . ' -> ' . $to . PHP_EOL, 'details/ftp.'.$base.'.log' );

                                            continue;

                                        }

                                        // ...
                                        $refToTime = filemtime( getFullPath( $to ) );

                                        // si manda solo se il file locale e' piu' recente di quello della destinazione; se la
                                        // destinazione non da' la data ( o il file non c'e' ) vale il riferimento dell'ultimo deploy
                                        $remoteTime = ftpGetFileTime( $ftpConn, $to );
                                        $refToDest = ( $remoteTime === false ) ? $refTime : $remoteTime;

                                        // ...
                                        if( $refToDest < $refToTime ) {

                                            // log
                                            logger( 'procedo al caricamento in quanto tref ' . $refToDest . ' < ' . $refToTime . ' per ' . getFullPath( $to ), 'details/ftp.log' );

                                            // ...
                                            set_time_limit( 240 );

                                            // upload del file
                                            $ftpPut = ftpPutFile( $ftpConn, $to, $to );

                                            // status
                                            if( $ftpPut == false ) {
                                                $fail++;
                                                $error = error_get_last();
                                                $status['err'][] = 'impossibile trasferire ' . $to . ' (' . boolean2string( $ftpPut ) . ') errore: ' . $error['message'];
                                                logger( $ftpSrv['address'] . ' -> ' . $to . PHP_EOL . ' errore: ' . $error['message'], 'details/ftp.'.$base.'.fail', LOG_ERR );
                                                $esito = 'KO';
                                            } else {
                                                $done++;
                                                $status['info'][] = 'trasferito ' . $to . ' (' . boolean2string( $ftpPut ) . ')';
                                                logger( $ftpSrv['address'] . ' -> ' . $to . PHP_EOL, 'details/ftp.'.$base.'.success' );
                                                $esito = 'OK';
                                            }

                                            // ...
                                            appendToFile( date( 'Y-m-d H:i:s' ) . ' ' . $esito . ' -> ' . $to . PHP_EOL, 'details/ftp.'.$base.'.log' );

                                        } else {

                                            // log
                                            logger( 'non procedo al caricamento in quanto tref ' . $refToDest . ' >= ' . $refToTime, 'details/ftp.log' );

                                            // conta come done visto che non va trasferito
                                            $done++;
                                            $status['info'][] = 'saltato ' . $to . ' (già aggiornato)';
                                            logger( $ftpSrv['address'] . ' -> saltato -> ' . $to . PHP_EOL, 'details/ftp.'.$base.'.success' );
                                            $esito = 'SKIPPED';

                                            // ...
                                            appendToFile( date( 'Y-m-d H:i:s' ) . ' ' . $esito . ' -> ' . $to . PHP_EOL, 'details/ftp.'.$base.'.log' );

                                        }

                                        // ...
                                        writeToFile(
                                            json_encode(
                                                array(
                                                    'total' => count( $toFtp ),
                                                    'done' => $done,
                                                    'fail' => $fail,
                                                    'current' => ( $done + $fail ),
                                                    'connection' => 'OK',
                                                    'login' => true,
                                                    'server' => $ftpSrv['address'],
                                                )
                                            ),
                                            'var/progress/ftp.'.$_REQUEST['id'].'.progress'
                                        );

                                        // ...
                                        writeToFile( date( 'Y-m-d H:i:s' ) . ' completato caricamento FTP' . PHP_EOL, $refFile );

                                    }

                                    // ...
                                    ftpClose( $ftpConn );

                                } else {

                                    // status
                                    $status['err'][] = 'connessione FTP assente per lo stage ' . $_REQUEST['target'];

                                }

                            } else {

                                // status
                                $status['err'][] = 'server FTP non settato per lo stage ' . $_REQUEST['target'];

                            }

                        } else {

                            // status
                            $status['err'][] = 'impossibile inserire la pagina ' . $_REQUEST['id'];

                        }

                    } else {

                        // status
                        $status['err'][] = 'dati non trovati per la pagina ' . $_REQUEST['id'];
                        
                    }

                } else {

                    // status
                    $status['err'][] = 'connessione remota non disponibile (' . mysqli_connect_errno() . ' ' . mysqli_connect_error() . ')';

                }

            } else {

                // status
                $status['err'][] = 'server non disponibile';

            }

        } else {

            // status
            $status['err'][] = 'target della pagina non passato';
    
        }

    } else {

        // status
        $status['err'][] = 'ID della pagina non passato';

    }

    // esito complessivo: la modale di pubblicazione ricarica la pagina solo se e' OK, altrimenti mostra gli errori
    $status['esito'] = ( empty( $status['err'] ) ) ? 'OK' : 'KO';

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
