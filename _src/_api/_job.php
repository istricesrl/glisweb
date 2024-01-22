<?php

    /**
     * 
     *  NOTA i commenti che iniziano con CUSTOM si riferiscono al codice da personalizzare
     * 
     */

    // costanti che descrivono lo stato di funzionamento del framework
	define( 'JOB_RUNNING'			, 'JOBRUN' );

    // inclusione del framework
    require '../_config.php';

    // debug
    // ini_set('display_errors', 1);
    // ini_set('display_startup_errors', 1);
    // error_reporting(E_ALL);

    // inizializzo l'array del risultato
    $status = array();

    // status
    $status['info'][] = 'inizio operazioni API job';

    // chiave di lock
    $status['token'] = getToken( __FILE__ );

    // verifico la presenza di un ID
    if( isset( $_REQUEST['__id__'] ) ) {

        // debug
        // echo "id del job " . $_REQUEST['__id__'];

        // status
        $status['info'][] = 'richiesta lavorazione del job #' . $_REQUEST['__id__'];

        // timer
        timerCheck( $cf['speed'], 'inizio lavorazione job' );

        // metto il lock sui job richiesto
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE job SET token = ? WHERE id = ? '.
            'AND ( timestamp_apertura <= ? OR timestamp_apertura IS NULL ) '.
            'AND timestamp_completamento IS NULL '.
            'AND token IS NULL ',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['__id__'] ),
                array( 's' => time() )
            )
        );

        // timer
        timerCheck( $cf['speed'], 'fine piazzamento lock job' );

        // seleziono il job a cui ho applicato il lock
        $job = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM job WHERE token = ? ',
            array(
                array( 's' => $status['token'] )
            )
        );

        // timer
        timerCheck( $cf['speed'], 'fine selezione job pinnato' );

        // ...
        if( is_array( $job ) ) {

            // se il job è stato correttamente recuperato dal database
            if( isset( $job['workspace'] ) && ! empty( $job['workspace'] ) ) {

                // status
                $status['info'][] = 'lavoro il job #' . $job['id'];

                // log
                logWrite( 'workspace per il job #' . $job['id'] . print_r( $job['workspace'], true ), 'job' );

                // decodifica del workspace
                $job['workspace'] = json_decode( $job['workspace'], true );

                /* ITERAZIONI */
                if( ! empty( $job['iterazioni'] ) ) {

                    /* CODICE PRINCIPALE DEL JOB */
                    if( file_exists( DIR_BASE . $job['job'] ) ) {
                        require DIR_BASE . $job['job'];
                    } else {
                        die( 'file non trovato ' . DIR_BASE . $job['job'] );
                    }

                    // delay
                    if( $job['iterazioni'] > 1 ) {
                        sleep( ( isset( $job['delay'] ) && ! empty( $job['delay'] ) ) ? $job['delay'] : mt_rand( 1, 2 ) );
                        timerCheck( $cf['speed'], 'fine delay job' );
                    }

                } else {

                    $status['err'][] = 'numero di iterazioni vuoto';

                }

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

                // timer
                timerCheck( $cf['speed'], 'fine aggiornamento avanzamento job' );

                // ...
                writeToFile( print_r( array_replace_recursive( $job, $status ), true ), DIR_VAR_LOG_JOB . $job['id'] . '.log' );
                writeToFile( print_r( array_replace_recursive( $job, $status ), true ), DIR_VAR_LOG_JOB . $job['id'] . '/' . microtime( true ) . '.log' );

                // timer
                timerCheck( $cf['speed'], 'fine scrittura log job' );

            } else {

                // status
                $status['info'][] = 'workspace vuoto per il job #' . $job['id'];

                // log
                logWrite( 'workspace vuoto per il job #' . $job['id'], 'job' );

            }

            // log
            appendToFile( print_r( array_replace_recursive( $job, $status ), true ), DIR_VAR_LOG_JOB . $_REQUEST['__id__'] . '.log' );

            // output
            buildJson( array_replace_recursive( $job, $status ) );

        } else {

            // status
            $status['info'][] = 'impossibile ottenere il lock per il job #' . $_REQUEST['__id__'] . ', vado in modalità informazioni sullo stato';

            // status
            $status = array_replace_recursive(
                $status,
                mysqlSelectRow(
                    $cf['mysql']['connection'],
                    'SELECT id, totale, corrente, nome, timestamp_apertura, timestamp_esecuzione, timestamp_completamento FROM job WHERE id = ? ',
                    array(
                        array( 's' => $_REQUEST['__id__'] )
                    )
                )
            );

            // status
            $status['info'][] = 'informazioni avanzamento lavori per il token ' . $status['token'];

            // output
            buildJson( $status );

        }

    } else {

        // status
        $status['err'][] = 'ID job non specificato';

        // output
        buildJson( $status );

    }

    // debug
    // echo '<pre>' . print_r( $cf['speed'], true ) . '</pre>';
