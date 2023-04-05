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

        // metto il lock sui job richiesto
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE job SET token = ? WHERE id = ? AND '.
            '( timestamp_apertura <= ? OR timestamp_apertura IS NULL ) AND timestamp_completamento IS NULL AND token IS NULL ',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['__id__'] ),
                array( 's' => time() )
            )
        );

        // seleziono il job a cui ho applicato il lock
        $job = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM job WHERE token = ? ',
            array(
                array( 's' => $status['token'] )
            )
        );

        // se il job è stato correttamente recuperato dal database
        if( isset( $job['workspace'] ) ) {

            // status
            $status['info'][] = 'lavoro il job #' . $job['id'];

            // log
            logWrite( 'workspace per il job #' . $job['id'] . print_r( $job['workspace'], true ), 'job' );

            // decodifica del workspace
            $job['workspace'] = json_decode( $job['workspace'], true );

            /* ITERAZIONI */
            if( ! empty( $job['iterazioni'] ) ) {

                /* CODICE PRINCIPALE DEL JOB */
                require DIR_BASE . $job['job'];

                // delay
                sleep( ( isset( $job['delay'] ) && ! empty( $job['delay'] ) ) ? $job['delay'] : mt_rand( 1, 2 ) );

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

        } elseif( isset( $job['id'] ) ) {

            // status
            $status['info'][] = 'workspace vuoto per il job #' . $job['id'];

            // log
            logWrite( 'workspace vuoto per il job #' . $job['id'], 'job' );

            // recupero dati informativi sul job
            $job = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT id, totale, corrente, nome FROM job WHERE id = ? ',
                array(
                    array( 's' => $_REQUEST['__id__'] )
                )
            );

        } else {

            // status
            $status['info'][] = 'nessun job trovato per il token' . $status['token'];

            // log
            logWrite( 'nessun job trovato per il token' . $status['token'], 'job' );

        }

        // log
        if( isset( $job['id'] ) ) {
            appendToFile( print_r( array_replace_recursive( $job, $status ), true ), DIR_VAR_LOG_JOB . $job['id'] . '.log' );
        }

        // output
        buildJson( array_replace_recursive( $job, $status ) );

    } elseif( isset( $_REQUEST['__job__'] ) ) {

        // TODO creare il job e restituire l'ID
        // __job__ campo job
        // __wksp__ campo workspace
        // __nome__ campo nome

    }
