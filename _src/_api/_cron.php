<?php

    /**
     * gestione delle operazioni pianificate
     * 
     * 
     * 
     * introduzione
     * ============
     * 
     * 
     * 
     * 
     * logging dell'attività di cron
     * -----------------------------
     * 
     * [...] /var/log/cron/YYYYMMDDHH.log -> tutta l'attività di cron (il contenuto di $cf['cron'])
     * 
     * [...] /var/log/latest/cron.latest.log -> l'ultima attività di cron (il contenuto di $cf['cron'] relativo all'ultima esecuzione)
     * 
     * 
     * esecuzione dei task
     * ===================
     * 
     * 
     * 
     * 
     * test dei task
     * -------------
     * 
     * 
     * ```
     * INSERT INTO `task` (`id`, `minuto`, `ora`, `giorno_del_mese`, `mese`, `giorno_della_settimana`, `settimana`, `task`, `iterazioni`, `delay`, `token`, 
     *     `timestamp_esecuzione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`)
     * VALUES
     *     (1, NULL, NULL, NULL, NULL, NULL, NULL, '_src/_api/_task/_test.cron.php', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
     * ```
     * 
     * 
     * 
     * 
     * 
     * 
     * log delle operazioni dei task
     * -----------------------------
     * 
     * 
     * [...] /var/log/task/TASKID.log -> informazioni generali sull'esecuzione del task (il contenuto di $task)
     * 
     * [...] /var/log/task/TASKID/MICROTIME.log -> l'attività di un task specifico (il contenuto di $cf['cron']['task'][TASKID][status])
     * 
     * 
     * 
     * 
     * esecuzione dei job
     * ==================
     * 
     * 
     * 
     * 
     * 
     * 
     * test dei job
     * ------------
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
     * [...] /var/log/job/JOBID.log -> informazioni generali sull'esecuzione del job (il contenuto di $job)
     * 
     * [...] /var/log/job/JOBID/AVANZAMENTO.MICROTIME.log -> l'attività di un job specifico (il contenuto di $cf['cron']['job'][JOBID][status])
     * 
     * 
     * 
     * 
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
    define( 'CRON_RUNNING', true );

    // inclusione del framework
    require '../_config.php';

    // log
    logger( 'chiamata cron API', 'cron' );
    loggerLatest( 'avvio API cron', FILE_LATEST_CRON );

    // output
    $cf['cron']['status'] = array( 'avviato' => date( 'Y-m-d H:i:s' ) );

    // tempo
    $cf['cron']['time'] = time();

    // chiave di lock
    $cf['cron']['token'] = getToken( __FILE__ );

    /**
     * esecuzione task
     * ===============
     * 
     * 
     */

    // provo a recuperare i task fermi
    mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE task SET token = NULL WHERE token IS NOT NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // metto il lock sui task con profili di schedulazione compatibili con l'orario corrente
    $tasks = mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE task SET token = ? WHERE
            ( minuto = ?                                                OR minuto IS NULL ) AND 
            ( ora = ?                                                   OR ora IS NULL ) AND 
            ( giorno_del_mese = ?                                       OR giorno_del_mese IS NULL ) AND 
            ( mese = ?                                                  OR mese IS NULL ) AND 
            ( giorno_della_settimana = ?                                OR giorno_della_settimana IS NULL ) AND 
            ( settimana = ?                                             OR settimana IS NULL ) AND 
            ( from_unixtime( timestamp_esecuzione, "%Y%m%d%H%i") < ?    OR timestamp_esecuzione IS NULL ) AND 
            ( token IS NULL OR ( timestamp_esecuzione < ? ) )',
        array(
            array( 's' => $cf['cron']['token'] ),                               //
            array( 's' => intval( date( 'i', $cf['cron']['time'] ) ) ),         // 
            array( 's' => date( 'G', $cf['cron']['time'] ) ),                   // 
            array( 's' => date( 'j', $cf['cron']['time'] ) ),                   // 
            array( 's' => date( 'n', $cf['cron']['time'] ) ),                   // 
            array( 's' => date( 'N', $cf['cron']['time'] ) ),                   // 1 - 7, 1 -> lunedì
            array( 's' => date( 'W', $cf['cron']['time'] ) ),                   // 1 - 52/53
            array( 's' => date( 'YmdHi', $cf['cron']['time'] ) ),               //
            array( 's' => strtotime( '-10 minutes' ) )                          //
        )
    );

    // seleziono i task a cui ho applicato il lock
    $cf['cron']['task'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT * FROM task WHERE token = ? ',
        array(
            array( 's' => $cf['cron']['token'] )
        )
    );

    // log
    logger( 'criteri di ricerca -> '
        . date( 'i', $cf['cron']['time'] ) . ' '
        . date( 'G', $cf['cron']['time'] ) . ' '
        . date( 'j', $cf['cron']['time'] ) . ' '
        . date( 'n', $cf['cron']['time'] ) . ' '
        . date( 'N', $cf['cron']['time'] ) . ' '
        . date( 'W', $cf['cron']['time'] ),
        'task'
    );

    // verifico se ci sono dei job aperti
    if( is_array( $cf['cron']['task'] ) ) {

        // log
        logger( 'task trovati: ' . print_r( $cf['cron']['task'], true), 'cron' );

        // ciclo sui task
        foreach( $cf['cron']['task'] as $task ) {

            // controllo che il file del task esista
            if( file_exists( DIR_BASE . $task['task'] ) ) {

                // log
                logger( 'eseguo il task ' . $task['id'] . ' -> ' . $task['task'], 'cron' );

                // log
                loggerLatest( 'eseguo il task ' . $task['id'] . ' -> ' . $task['task'], FILE_LATEST_RUN );

                // eseguo il task
                if( ! empty( $task['iterazioni'] ) ) {

                    // iterazioni del task
                    for( $iter = 0; $iter < $task['iterazioni']; $iter++ ) {

                        // ...
                        logger( 'iterazione #' . $iter . ' di ' . $task['iterazioni'] . ' per il task ' . $task['id'] . ' -> ' . $task['task'], 'cron' );

                        // ...
                        $status = array();

                        // ...
                        require DIR_BASE . $task['task'];

                        // ...
                        $cf['cron']['task'][ $task['id'] ]['status'] = $status;

                        // ...
                        logger( 'fine iterazione #' . $iter . ' di ' . $task['iterazioni'] . ' per il task ' . $task['id'] . ' -> ' . $task['task'], 'cron' );

                        // ...
                        loggerLatest( print_r( $status, true ), DIR_VAR_LOG_TASK . $task['id'] . '/' . microtime( true ) . '.log' );

                    }

                    // aggiorno la tabella di pianificazione
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE task SET timestamp_esecuzione = ?, token = NULL WHERE id = ?',
                        array(
                            array( 's' => $cf['cron']['time'] ),
                            array( 's' => $task['id'] )
                        )
                    );

                } else {

                    // status
                    $cf['cron']['task'][ $task['id'] ]['errors'][] = 'il task ' . $task['id'] . ' ha specificato un numero di iterazioni nullo, è voluto?';

                    // log
                    logger( 'il task ' . $task['id'] . ' ha iterazioni nulle', 'cron', LOG_ERR );

                }
        
                // log
                loggerLatest( 'eseguito il task ' . $task['id'] . ' -> ' . $task['task'], FILE_LATEST_RUN );

            } else {

                // status
                $cf['cron']['task'][ $task['id'] ]['errors'][] = 'il file di task ' . $task['task'] . ' non esiste';

                // log
                logger( 'il file di task ' . $task['task'] . ' non esiste', 'cron', LOG_ERR );

            }

            // log
            loggerLatest( print_r( $task, true ), DIR_VAR_LOG_TASK . $task['id'] . '.log' );

        }

    } else {

        // status
        $cf['cron']['info'][] = 'nessun task trovato';

        // log
        logger( 'nessun task trovato', 'cron' );

    }

    /**
     * esecuzione job
     * ==============
     * 
     * 
     */

    // provo a recuperare i job fermi
    mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE job SET token = NULL WHERE token IS NOT NULL AND timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // porto in background i job fermi in foreground
    mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE job SET se_foreground = NULL WHERE timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // metto il lock sui job aperti
    $jobs = mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE job SET token = ?, timestamp_esecuzione = ? WHERE 
        ( timestamp_apertura <= ? OR timestamp_apertura IS NULL )
        AND timestamp_completamento IS NULL 
        AND ( token IS NULL ) 
        AND ( se_foreground IS NULL OR se_foreground = 0 )',
        array(
            array( 's' => $cf['cron']['token'] ),
            array( 's' => $cf['cron']['time'] ),
            array( 's' => $cf['cron']['time'] )
        )
    );
    
    // seleziono i job a cui ho applicato il lock
    $cf['cron']['job'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT * FROM job WHERE token = ? ',
        array(
            array( 's' => $cf['cron']['token'] )
        )
    );

    // verifico se ci sono dei job aperti
    if( is_array( $cf['cron']['job'] ) ) {

        // log
        logger( 'job trovati: ' . print_r( $cf['cron']['job'], true), 'cron' );

        // ciclo sui job
        foreach( $cf['cron']['job'] as $job ) {

            // controllo che il file del job esista
            if( file_exists( DIR_BASE . $job['job'] ) ) {

                // log
                logger( 'eseguo il job ' . $job['id'] . ' -> ' . $job['job'], 'cron', LOG_DEBUG );

                // decodifica del workspace
                $job['workspace'] = json_decode( $job['workspace'], true );

                // eseguo il job
                if( ! empty( $job['iterazioni'] ) ) {

                    for( $iter = 0; $iter < $job['iterazioni']; $iter++ ) {

                        // ...
                        logger( 'iterazione #' . $iter . ' di ' . $job['iterazioni'] . ' per il job ' . $job['id'] . ' -> ' . $job['job'], 'cron' );

                        // ...
                        $status = array();

                        // ...
                        require DIR_BASE . $job['job'];

                        // ...
                        $cf['cron']['job'][ $job['id'] ]['status'] = $status;

                        // ...
                        logger( 'fine iterazione #' . $iter . ' di ' . $job['iterazioni'] . ' per il job ' . $job['id'] . ' -> ' . $job['job'], 'cron' );

                        // ...
                        loggerLatest( print_r( $status, true ), DIR_VAR_LOG_JOB . $job['id'] . '/' . $job['corrente'] . '.' . microtime( true ) . '.log' );

                    }

                    // aggiorno la tabella di avanzamento lavori
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE job SET timestamp_esecuzione = ?, workspace = ?, token = NULL WHERE id = ?',
                        array(
                            array( 's' => $cf['cron']['time'] ),
                            array( 's' => json_encode( $job['workspace'] ) ),
                            array( 's' => $job['id'] )
                        )
                    );

                } else {

                    // status
                    $cf['cron']['job'][ $job['id'] ]['errors'][] = 'il job ' . $job['job'] . ' ha specificato un numero di iterazioni nullo, è voluto?';

                    // log
                    logger( 'il job ' . $job['job'] . ' ha iterazioni nulle', 'cron', LOG_ERR );

                }

            } else {

                // status
                $cf['cron']['job'][ $job['id'] ]['errors'][] = 'il file di job ' . $job['job'] . ' non esiste';

                // log
                logger( 'il file di job ' . $job['job'] . ' non esiste', 'cron', LOG_ERR );

            }

            // log
            loggerLatest( print_r( $job, true ), DIR_VAR_LOG_JOB . $job['id'] . '.log' );

        }

    } else {

        // status
        $cf['cron']['info'][] = 'nessun job trovato';

        // log
        logger( 'nessun job trovato', 'cron' );

    }

    // status
    $cf['cron']['status']['concluso'] = date( 'Y-m-d H:i:s' );

    // log
    loggerLatest( print_r( $cf['cron'], true ), DIR_VAR_LOG_CRON . date( 'YmdH' ) . '.log' );

    // log
    loggerLatest( print_r( $cf['cron'], true ), FILE_LATEST_CRON );

    // output
    buildJson( $cf['cron'] );
