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

                // connessione al database target
                $cTarget = mysqli_connect(
                    $server['address'],
                    $server['username'],
                    $server['password'],
                    $server['db'],
                );

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

                                    // copia file
                                    if( in_array( $entita, array( 'immagini', 'file' ) ) ) {

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

                                // ...
                                $toFtp = array_merge(
                                    mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM immagini WHERE id_pagina = ?', array( array( 's' => $_REQUEST['id'] ) ) )
                                    ,
                                    mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM file WHERE id_pagina = ?', array( array( 's' => $_REQUEST['id'] ) ) )
                                );

                                // ...
                                $template = mysqlSelectValue(
                                    $cf['mysql']['connection'],
                                    'SELECT template FROM pagine WHERE id = ?',
                                    array( array( 's' => $_REQUEST['id'] ) )
                                );

                                // ...
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
/*
                                // creo il job
                                $status['inserimento'] = mysqlQuery(
                                    $cf['mysql']['connection'],
                                    'INSERT INTO job ( nome, job, iterazioni, delay, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ?, ? )',
                                    array(
                                        array( 's' => 'caricamento FTP file aggiornati' ),
                                        array( 's' => '_mod/_3000.contenuti/_src/_api/_job/_pagine.upload.php' ),
                                        array( 's' => 3 ),
                                        array( 's' => 20 ),
                                        array( 's' => 1 ),
                                        array( 's' => json_encode(
                                            array(
                                                'files' => array_map( 'shortPath', $toFtp ),
                                                'server' => $cf['ftp']['servers'][ $cf['ftp']['profiles'][ $_REQUEST['target'] ]['servers'][0] ]
                                            )
                                        ) )
                                    )
                                );

                                // die( $status['inserimento'] );
*/
/*
*/

                                // ...
                                $ftpSrv = $cf['ftp']['servers'][ $cf['ftp']['profiles'][ $_REQUEST['target'] ]['servers'][0] ];

                                // ...
                                $toFtp = array_merge(
                                    mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM immagini WHERE id_pagina = ?', array( array( 's' => $_REQUEST['id'] ) ) )
                                    ,
                                    mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM file WHERE id_pagina = ?', array( array( 's' => $_REQUEST['id'] ) ) )
                                );

                                // ...
                                $template = mysqlSelectValue(
                                    $cf['mysql']['connection'],
                                    'SELECT template FROM pagine WHERE id = ?',
                                    array( array( 's' => $_REQUEST['id'] ) )
                                );

                                // ...
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

                                // debug
                                // die( $template );
                                // die( print_r( $toFtp, true ) );

                                // connessione al server FTP
                                $ftpConn = ftp_connect( $ftpSrv['address'], $ftpSrv['port'], 5 );
                                $ftpLogin = ftp_login( $ftpConn, $ftpSrv['username'], $ftpSrv['password'] );
                                $ftpPasw = ftp_pasv( $ftpConn, true );

                                // contatori
                                $done = 0;
                                $fail = 0;

                                $base = time();

// $toFtp = array_slice( $toFtp, 2, 3, true);

                                // ...
                                // deleteFile( 'tmp/ftp.done' );
                                // deleteFile( 'tmp/ftp.fail' );
                                // deleteFile( 'tmp/ftp.progress' );

                                // ...
                                foreach( $toFtp as $to ) {

                                    // ...
                                    $refFile = DIR_VAR .'latest.deploy.'.strtolower( $_REQUEST['target'] ).'.conf';

                                    // ...
                                    $refTime = ( file_exists( $refFile ) ) ? filemtime( $refFile ) : 0;

                                    // ...
                                    if( filemtime( fullPath( $to ) ) < $refTime ) {

                                        // ...
                                        set_time_limit( 240 );

                                        // normalizzazione percorsi
                                        $to = shortPath( $to );

                                        // tipo di upload per tipo di file
                                        $mode = ftpGetTransferTypeByFile( $to );

                                        // ...
                                        $path = explode( '/', dirname( $to ) );
                                        foreach( $path as $chdir ) {
                                            $ftpDir = ftp_chdir( $ftpConn, $chdir );
                                            // var_dump( $chdir );
                                            // var_dump( $ftpDir );
                                            if( empty( $ftpDir ) ) {
                                                $ftpDir = ftp_mkdir( $ftpConn, $chdir );
                                                // var_dump( $ftpDir );
                                                $ftpDir = ftp_chdir( $ftpConn, $chdir );
                                                // var_dump( $ftpDir );
                                            }
                                        }

                                        // echo 'cartella corrente: ' . PHP_EOL;
                                        // var_dump( ftp_pwd( $ftpConn ) );

                                        // upload del file
                                        // $ftpPut = @ftp_put( $ftpConn, basename( $to ), DIR_BASE . $to, $mode );
                                        // $ftpPut = ftp_put( $ftpConn, basename( $to ), DIR_BASE . $to, $mode );
                                        // $ftpPut = ftp_put( $ftpConn, $to, DIR_BASE . $to, $mode );
                                        $ftpPut = ftp_put( $ftpConn, basename( $to ), DIR_BASE . $to );

                                        // var_dump( basename( $to ) );
                                        // var_dump( DIR_BASE . $to );
                                        // var_dump( file_exists( DIR_BASE . $to ) );
                                        // var_dump( $ftpPut );

                                        // die();

                                        // status
                                        if( $ftpPut == true ) {
                                            $done++;
                                            // $status['info'][] = 'completato trasferimento di ' . $to . ' (' . boolean2string( $ftpPut ) . ')';
                                            appendToFile( ftp_pwd( $ftpConn ) . ' -> ' . $mode . ' -> ' . $to . PHP_EOL, 'tmp/ftp.'.$base.'.done' );
                                            $esito = 'OK';
                                        } else {
                                            $fail++;
                                            $status['err'][] = 'impossibile trasferire ' . $to . ' (' . boolean2string( $ftpPut ) . ')';
                                            appendToFile( ftp_pwd( $ftpConn ) . ' -> ' . $mode . ' -> ' . $to . PHP_EOL, 'tmp/ftp.'.$base.'.fail' );
                                            $esito = 'KO';
                                        }

                                        // ...
                                        appendToFile( date( 'Y-m-d H:i:s' ) . ' ' . $esito . ' -> ' . $to . PHP_EOL, $refFile );

                                        // ...
                                        for( $i = 0; $i < count( $path ); $i++ ) {
                                            $ftpDir = ftp_cdup( $ftpConn );
                                        }

                                        // ...
                                        writeToFile(
                                            json_encode(
                                                array(
                                                    'total' => count( $toFtp ),
                                                    'done' => $done,
                                                    'fail' => $fail,
                                                    'current' => ( $done + $fail ),
                                                    'connection' => ( ( empty( $ftpConn ) ) ? 'NO' : 'OK' ),
                                                    'login' => $ftpLogin,
                                                    'server' => $ftpSrv['address']
                                                )
                                            ),
                                            'var/progress/ftp.'.$_REQUEST['id'].'.progress'
                                        );

                                    }

                                }

                                // ...
                                ftp_close( $ftpConn );

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

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
