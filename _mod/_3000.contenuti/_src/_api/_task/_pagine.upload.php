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
                            foreach( array( 'contenuti', 'menu', 'immagini', 'file', 'metadati', 'macro', 'pubblicazioni' ) as $entita ) {

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
                            if( isset( $cf['ftp']['servers'][ $cf['mysql']['profiles'][ $_REQUEST['target'] ]['servers'][0] ] ) ) {

                                // ...
                                $ftpSrv = $cf['ftp']['servers'][ $cf['mysql']['profiles'][ $_REQUEST['target'] ]['servers'][0] ];

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
                                $ftpConn = ftp_connect( $ftpSrv['address'] );
                                $ftpLogin = ftp_login( $ftpConn, $ftpSrv['username'], $ftpSrv['password'] );

                                // ...
                                foreach( $toFtp as $to ) {

                                    // normalizzazione percorsi
                                    $to = shortPath( $to );

                                    // tipo di upload per tipo di file

                                    // upload del file
                                    $ftpPut = ftp_put( $ftpConn, $to, DIR_BASE . $to, ftpGetTransferTypeByFile( $to ) );

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

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
