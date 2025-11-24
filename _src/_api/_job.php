<?php

    /**
     * esecuzione dei job in foreground
     * 
     * 
     * 
     * 
     * introduzione
     * ============
     * 
     * 
     * 
     * 
     * 
     * relazione con l'API cron
     * ------------------------
     * 
     * 
     * 
     * 
     * 
     * 
     * logging dell'attività in foreground
     * -----------------------------------
     * 
     * [...] /var/log/foreground/YYYYMMDDHH.log -> tutta l'attività di foreground (il contenuto di $job)
     * 
     * 
     * 
     * 
     * 
     * esecuzione dei job in foreground
     * ================================
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * test dei job in foreground
     * --------------------------
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * log delle operazioni dei job
     * ----------------------------
     * 
     * 
     * 
     * [...] /var/log/job/JOBID.log -> informazioni generali sull'esecuzione del job (il contenuto di $job)
     * 
     * [...] /var/log/job/JOBID/AVANZAMENTO.MICROTIME.log -> l'attività di un job specifico (il contenuto di $cf['cron']['job'][JOBID][status])
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * NOTA i commenti che iniziano con CUSTOM si riferiscono al codice da personalizzare
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    /**
     * configurazioni generali
     * =======================
     * 
     * 
     */


    // costanti che descrivono lo stato di funzionamento del framework
    define( 'JOB_RUNNING', 'JOBRUN' );

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // log
    logger( 'chiamata job API', 'foreground' );

    // inizializzo l'array del risultato
    $job['status'] = array();

    // status
    $job['info'][] = 'inizio operazioni in foreground API job';

    // chiave di lock
    $job['token'] = getToken( __FILE__ );

    /**
     * esecuzione job
     * ==============
     * 
     * 
     */

    // verifico la presenza di un ID
    if( isset( $_REQUEST['__id__'] ) ) {

        // debug
        // echo "id del job " . $_REQUEST['__id__'];

        // status
        $job['info'][] = 'richiesta lavorazione in foreground del job #' . $_REQUEST['__id__'];

        // timer
        timerCheck( $cf['speed'], 'inizio lavorazione in foreground del job #' . $_REQUEST['__id__'] );

        // metto il lock sui job richiesto
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE job SET token = ? WHERE id = ? '.
            'AND ( timestamp_apertura <= ? OR timestamp_apertura IS NULL ) '.
            'AND timestamp_completamento IS NULL '.
            'AND token IS NULL ',
            array(
                array( 's' => $job['token'] ),
                array( 's' => $_REQUEST['__id__'] ),
                array( 's' => time() )
            )
        );

        // timer
        timerCheck( $cf['speed'], 'fine piazzamento lock job' );

        // seleziono il job a cui ho applicato il lock
        $job = array_replace_recursive(
            $job,
            mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM job WHERE token = ? ',
                array(
                    array( 's' => $job['token'] )
                )
            )
        );

        // timer
        timerCheck( $cf['speed'], 'fine selezione job pinnato' );

        // se ho trovato il job da eseguire
        if( is_array( $job ) && ! empty( $job ) ) {

            // se il job è stato correttamente recuperato dal database
            if( isset( $job['workspace'] ) && ! empty( $job['workspace'] ) ) {

                // status
                $job['info'][] = 'lavoro in foreground il job #' . $job['id'];

                // log
                // logger( 'workspace per il job #' . $job['id'] . print_r( $job['workspace'], true ), 'job' );

                // decodifica del workspace
                $job['workspace'] = json_decode( $job['workspace'], true );

                // se il file del job esiste
                if( file_exists( DIR_BASE . $job['job'] ) ) {

                    // se il job ha un numero di iterazioni settato
                    if( ! empty( $job['iterazioni'] ) ) {

                        // ...
                        $job['timer']['foreground']['start'] = microtime( true );

                        // ...
                        $status = array();

                        // ...
                        require DIR_BASE . $job['job'];

                        // ...
                        $job['status'] = $status;

                        // ...
                        $job['timer']['foreground']['end'] = microtime( true );

                        // ...
                        $job['timer']['foreground']['elapsed'] = $job['timer']['foreground']['end'] - $job['timer']['foreground']['start'];

                        // ...
                        loggerLatest( print_r( $status, true ), DIR_VAR_LOG_JOB . $job['id'] . '/' . $job['corrente'] . '.' . microtime( true ) . '.log' );

                        // aggiorno la tabella di avanzamento lavori
                        mysqlQuery(
                            $cf['mysql']['connection'],
                            'UPDATE job SET timestamp_esecuzione = ?, workspace = ?, token = NULL WHERE id = ?',
                            array(
                                array( 's' => time() ),
                                array( 's' => json_encode( $job['workspace'] ) ),
                                array( 's' => $job['id'] )
                            )
                        );

                    } else {

                        // status
                        $job['err'][] = 'numero di iterazioni vuoto';

                    }

                } else {

                    // status
                    $job['err'][] = 'file non trovato ' . DIR_BASE . $job['job'];

                }

            } else {
                die( print_r( $job, true ) );
                // status
                $job['err'][] = 'workspace vuoto per il job #' . $_REQUEST['__id__'];

                // log
                logger( 'workspace vuoto per il job #' . $_REQUEST['__id__'], 'job' );

            }

            // log
            loggerLatest( print_r( $job, true ), DIR_VAR_LOG_JOB . $_REQUEST['__id__'] . '.log' );

        } else {

            // status
            $job['err'][] = 'impossibile ottenere il lock per il job #' . $_REQUEST['__id__'] . ', vado in modalità informazioni sullo stato';

            // status
            $job = array_replace_recursive(
                $job,
                mysqlSelectRow(
                    $cf['mysql']['connection'],
                    'SELECT id, totale, corrente, nome, timestamp_apertura, timestamp_esecuzione, timestamp_completamento FROM job WHERE id = ? ',
                    array(
                        array( 's' => $_REQUEST['__id__'] )
                    )
                )
            );

            // status
            $job['info'][] = 'informazioni avanzamento lavori per il token ' . $job['token'];

        }

    } else {

        // status
        $job['err'][] = 'ID job non specificato';

    }

    // debug
    // echo '<pre>' . print_r( $cf['speed'], true ) . '</pre>';

    // output
    buildJson( array_diff_key( $job, array_flip( array( 'workspace' ) ) ) );
