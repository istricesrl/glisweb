<?php

    /* CODICE PRINCIPALE DEL JOB 

    // verifiche formali
    if( ! defined( 'CRON_RUNNING' ) && ! defined( 'JOB_RUNNING' ) ) {

        // status
        $job['workspace']['status']['error'][] = 'questo job non supporta la modalità standalone';

        // output
        buildJson( $job['workspace']['status'] );

    } elseif( empty( $job['id'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'ID job non trovato';

    } elseif( isset( $job['corrente'] ) && $job['corrente'] > $job['totale'] ) {

        // status
        $job['workspace']['status']['info'][] = 'iterazione a vuoto su job completato';

    } elseif( ! isset( $job['workspace']['files'] ) || empty( $job['workspace']['files'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'questo job richiede un file su cui lavorare';

    } else {

        // attività di avvio
        if( empty( $job['corrente'] ) ) {

            // inizializzo l'array
            $arr = $job['workspace']['files'];

            // segno il totale delle cose da fare
            $job['totale'] = count( $arr );

            // avvio il contatore
            $job['corrente'] = 1;

            // timestamp di avvio
            if( empty( $job['timestamp_apertura'] ) ) {
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET totale = ?, timestamp_apertura = ? WHERE id = ?',
                    array(
                        array( 's' => $job['totale'] ),
                        array( 's' => time() ),
                        array( 's' => $job['id'] )
                    )
                );
            }

            // status
            $job['workspace']['status']['info'][] = 'file: ' . $job['workspace']['file'];
            $job['workspace']['status']['info'][] = 'requisiti formali soddisfatti, inizializzo il job';
            $job['workspace']['status']['info'][] = 'righe trovate: ' . $job['totale'];
            $job['workspace']['status']['info'][] = 'colonne trovate: ' . implode( ', ', array_keys( $arr[0] ) );

        } else {

            // inizializzo l'array
            $arr = $job['workspace']['files'];

            // incremento l'indice di lavoro
            $job['corrente']++;

        }

        // operazioni di chiusura
        if( empty( $job['totale'] ) || $job['corrente'] > $job['totale'] ) {

            // scrivo la timestamp di completamento
            $jobs = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
                array(
                    array( 's' => time() ),
                    array( 's' => $job['id'] )
                )
            );

        } else {

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // prelevo la riga da lavorare
            $job['riga'] = $arr[ $widx ];

            // controlli formali e lavorazione riga
            if( ! file_exists( DIR_BASE . $job['riga'] ) ) {

                // status
                $job['workspace']['status']['error'][] = $job['riga'] . ' non esiste';

            } else {

                // normalizzazione percorsi
                // $to = shortPath( $job['riga'] );
                $to = $job['riga'];

                // dati del server
                $ftpSrv = $job['workspace']['server'];

                // debug
                // print_r( $ftpSrv );

                // timer
                timerCheck( $cf['speed'], 'inizio connessione' );

                // connessione al server FTP
                $ftpConn = @ftp_connect( $ftpSrv['address'], $ftpSrv['port'], 5 );

                // timer
                timerCheck( $cf['speed'], 'fine connessione' );

                // se c'è connessione
                if( ! empty( $ftpConn ) ) {

                    // debug
                    // var_dump( $ftpConn );

                    // login al server FTP
                    $ftpLogin = @ftp_login( $ftpConn, $ftpSrv['username'], $ftpSrv['password'] );

                    // timer
                    timerCheck( $cf['speed'], 'fine login' );

                    // se è stato effettuato il login
                    if( ! empty( $ftpLogin ) ) {

                        // debug
                        // var_dump( $ftpLogin );

                        // ...
                        // set_time_limit( 360 );

                        // ...
                        ftp_pasv( $ftpConn, true );

                        // ...
                        $mode = ftpGetUploadTypeByFile( $to );

                        // ...
                        $ftpDir = ftp_chdir( $ftpConn, dirname( $to ) );

                        // timer
                        timerCheck( $cf['speed'], 'fine cambio cartella' );

                        // ...
                        if( ! empty( $ftpDir ) ) {

                            // debug
                            // var_dump( $ftpDir );

                            // ...
                            $ftp = 0;

                            // timer
                            timerCheck( $cf['speed'], 'inizio caricamento file' );

                            // upload del file
                            // $ftpPut = @ftp_nb_put( $ftpConn, basename( $to ), DIR_BASE . $to, $mode );
                            $ftpPut = @ftp_nb_put( $ftpConn, basename( $to ), DIR_BASE . $to, FTP_BINARY );

                            // timer
                            timerCheck( $cf['speed'], 'prosieguo caricamento file' );

                            // ...
                            while( $ftpPut == FTP_MOREDATA ) {

                                timerCheck( $cf['speed'], 'caricamento file ' . $ftp++ );

                                $ftpPut = ftp_nb_continue( $ftpConn );

                            }

                            // status
                            if( $ftpPut == FTP_FINISHED ) {
                                timerCheck( $cf['speed'], 'fine caricamento file' );
                                $status['info'][] = 'completato trasferimento di ' . $to;
                            } else {
                                timerCheck( $cf['speed'], 'timeout caricamento file' );
                                $status['err'][] = 'impossibile trasferire ' . $to . ' in modalità ' . $mode;
                            }

                            // ...
                            ftp_close( $ftpConn );

                            // timer
                            timerCheck( $cf['speed'], 'chiusura connessione FTP' );

                        } else {

                            $status['err'][] = 'impossibile entrare in ' . dirname( $to );

                        }

                    } else {

                        $status['err'][] = 'impossibile fare il login per trasferire ' . $to;

                    }

                } else {

                    $status['err'][] = 'impossibile connettersi al server per trasferire ' . $to;

                }

            }

            // aggiorno i valori di visualizzazione avanzamento
            $jobs = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE job SET corrente = ? WHERE id = ?',
                array(
                    array( 's' => $job['corrente'] ),
                    array( 's' => $job['id'] )
                )
            );

        }

    }

    /* FINE CODICE PRINCIPALE DEL JOB */

    // ,,,
    // echo '<pre>' . print_r( $cf['speed'], true ) . '</pre>';
