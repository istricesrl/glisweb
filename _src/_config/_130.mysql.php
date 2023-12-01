<?php

    /**
     * 
     * 
     * 
     */


    // verifico la connessione
    if( ! empty( $cf['mysql']['connection'] ) ) {

        // non eseguo le patch se il framework è chiamato da cron
        if( ! defined( 'CRON_RUNNING' ) && ! defined( 'JOB_RUNNING' ) ) {

            // eseguo le patch solo se esplicitamente richiesto
            if( isset( $_REQUEST['m'] ) ) {

                // TODO la creazione del database e l'esecuzione delle patch non dovrebbero essere un
                // task a parte? con anche tutti i runlevel successivi al 125 esclusi?

                // ...
                header( 'Content-type: text/plain' );

                // creo la tabella di patch se non esiste
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'CREATE TABLE IF NOT EXISTS `__patch__` ('.
                    '	`id` char(12) NOT NULL PRIMARY KEY,'.
                    '	`patch` text COLLATE utf8_unicode_ci,'.
                    '	`timestamp_esecuzione` int(11) DEFAULT NULL,'.
                    '	`token` char(128) DEFAULT NULL,'.
                    '	`note_esecuzione` text'.
                    '  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;'
                );
        
                // debug
                // die( 'creazione della tabella di patch' );

                // cerco l'ultima patch eseguita
                $patchLevel = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT id AS patch_level FROM __patch__ ORDER BY id DESC LIMIT 1'
                );
        
                /*

                    if( empty( $patchLevel ) ) {
        
                        mysqlQuery(
                            $cf['mysql']['connection'],
                            'CREATE TABLE IF NOT EXISTS `__patch__` ('.
                            '	`id` char(12) NOT NULL PRIMARY KEY,'.
                            '	`patch` text COLLATE utf8_unicode_ci,'.
                            '	`timestamp_esecuzione` int(11) DEFAULT NULL,'.
                            '	`note_esecuzione` text'.
                            '  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;'
                        );
                    
        
                    $patchLevel = '000000000000';
        
                    }

                */

                // patch level di default
                if( empty( $patchLevel ) ) {
                    $patchLevel = '000000000000';
                }

                // debug
                // die( print_r( $pFiles, true ) );
                
                // cerco i patch file
                $pFiles = glob( glob2custom( DIR_USR_DATABASE_PATCH . '_*.*.sql' ), GLOB_BRACE );

                // elimino i duplicati
                // TODO cercare di capire perché glob qui genera duplicati!
                $pFiles = array_unique( $pFiles );

                // ordino i patch file per patch level
                sort( $pFiles );
        
                // debug
                // echo 'percorso di ricerca: ' . glob2custom( DIR_USR_DATABASE_PATCH . '_*.*.sql' ) . PHP_EOL;
                // echo 'patch level: ' . $patchLevel . PHP_EOL;
                // die( print_r( $pFiles, true ) );

                // processo un patch file alla volta
                foreach( $pFiles as $pFile ) {

                    // ricavo il livello di patch del file dal nome
                    $pFilePatchLevel = substr( basename( $pFile ), 1, 12 );
        
                    // debug
                    // echo 'patch level del file ' . $pFilePatchLevel . PHP_EOL;
                    // echo 'patch level del database ' . $patchLevel . PHP_EOL;
                    // die( 'elaborazione file' );
        
                    // se il livello di patch del file è maggiore di quello del database...
                    if( $pFilePatchLevel > $patchLevel ) {
        
                        // log
                        appendToFile( 'elaborazione file patch -> ' . $pFile . PHP_EOL, FILE_LATEST_RUN );
        
                        // debug
                        // echo 'prelevo le patch dal file ' . $pFilePatchLevel . PHP_EOL;
        
                        // leggo il file in un array (una riga per elemento)
                        $rows = readFromFile( $pFile );

                        // debug
                        // echo 'righe trovate nel file ' . $pFile . ' -> ' . count( $rows ) . PHP_EOL;

                        // id della patch
                        $pId = NULL;

                        // patch corrente
                        $pQuery = NULL;
                        $pComments = NULL;

                        // processo le righe una alla volta
                        foreach( $rows as $row ) {

                            // se la riga inizia con il marcatore, allora ho trovato una patch
                            if( substr( trim( $row ), 0, 4 ) == '-- |' ) {
        
                                // se la query che sto ricavando non è vuota...
                                if( ! empty( trim( $pQuery ) ) ) {
        
                                    // debug
                                    // echo 'eseguo la patch ' . $pId . PHP_EOL;
        
                                    // se l'ID della patch che sto lavorando è maggiore del patch level del database
                                    if( $pId > $patchLevel ) {

                                        // log
                                        appendToFile( 'elaborazione patch -> ' . $patchLevel . PHP_EOL, FILE_LATEST_RUN );

                                        // eseguo la patch corrente
                                        $pEx = mysqlQuery(
                                            $cf['mysql']['connection'],
                                            $pQuery
                                        );

                                        // debug
                                        // echo 'scrivo la patch ' . $pId . PHP_EOL;

                                        // risultato dell'esecuzione della patch
                                        $pStatus = mysqli_errno( $cf['mysql']['connection'] ) . ' ' . mysqli_error( $cf['mysql']['connection'] );

                                        // debug
                                        if( ! empty( mysqli_errno( $cf['mysql']['connection'] ) ) ) {
                                            echo $pQuery . PHP_EOL;
                                            echo $pStatus . PHP_EOL;
                                            die( 'errore nella patch ' . $pQuery );
                                        } else {
                                            echo 'patch ' . $patchLevel . ' applicata correttamente' . PHP_EOL;
                                        }

                                        // registro l'esecuzione della patch nella tabella __patch__
                                        $rEx = mysqlInsertRow(
                                            $cf['mysql']['connection'],
                                            array(
                                                'id' => $pId,
                                                'patch' => trim( $pQuery ),
                                                'timestamp_esecuzione' => ( ( empty( $pEx ) ) ? NULL : time() ),
                                                'note_esecuzione' => ( ( empty( mysqli_errno( $cf['mysql']['connection'] ) ) ) ? 'OK' : $pStatus )
                                            ),
                                            '__patch__',
                                            false
                                        );

                                        // risultato dell'esecuzione della patch
                                        $pStatus = mysqli_errno( $cf['mysql']['connection'] ) . ' ' . mysqli_error( $cf['mysql']['connection'] );

                                        // debug
                                        if( ! empty( mysqli_errno( $cf['mysql']['connection'] ) ) ) {
                                            die( 'errore nella scrittura sulla tabella delle patch' );
                                        } else {
                                            echo 'esecuzione della patch ' . $patchLevel . ' registrata correttamente' . PHP_EOL;
                                        }

                                        // aggiorno il patch level al livello (ID) della patch che ho appena inserito
                                        $patchLevel = $pId;
    
                                    } else {
    
                                        // debug
                                        echo 'patch ' . $pId . ' obsoleta rispetto a ' . $patchLevel. PHP_EOL;
                                        
                                    }
        
                                } else {
        
                                    // debug
                                    if( empty( $pComments ) ) {
                                        echo 'NON eseguo la patch ' . $pId . ' in quanto è vuota' . PHP_EOL;
                                    } else {
                                        // echo $pComments . PHP_EOL;
                                    }
                                    
                                }
        
                                // leggo l'ID della patch
                                $pId = substr( $row, 5, 12 );

                                // se l'ID della patch è '------------' allora lo imposto alla data corrente
                                if( $pId == '------------' ) { $pId = date( 'YmdHis' ); }
        
                                // svuoto la query per ricominciare ad aggiungere righe
                                $pQuery = NULL;
                                $pComments = NULL;
                        
                                // echo 'inizio la lettura della patch ' . $pId . PHP_EOL;
                                
                            } elseif( substr( trim( $row ), 0, 2 ) == '--' ) {

                                // aggiungo la riga corrente alla patch che sto leggendo
                                $pComments .= $row;

                            } elseif( substr( trim( $row ), 0, 2 ) !== '--' ) {

                                // aggiungo la riga corrente alla patch che sto leggendo
                                $pQuery .= $row;

                            }
        
                        }

                        /*
                        $patchLevel = mysqlSelectValue(
                                        $cf['mysql']['connection'],
                                        'SELECT id FROM __patch__ ORDER BY id DESC LIMIT 1'
                                    );
                        */

                    }

                }
    
                // ...
                die( 'fine applicazione patch database' );

            }
    
        }

    } else {

        // log
        // connessione assente

    }
