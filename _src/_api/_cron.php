<?php

    /**
     * gestione delle operazioni pianificate
     * 
     * questa API si occupa di gestire le operazioni pianificate del framework
     * 
     * introduzione
     * ============
     * Il framework dispone di un potente e flessibile sistema di esecuzione delle operazioni pianificate,
     * che appoggiandosi al cron di sistema garantisce un'elevatissima affidabilità e buone prestazioni.
     * Dal lato del sistema, uno script in /etc/cron.d/ che può essere installato anche tramite il comando
     * _src/_sh/_crontab.install.sh deve richiamare l'API /api/cron del framework ogni minuto. L'API si 
     * occuperà di controllare sulle tabelle *task* e *job* quali compiti vanno eseguiti e provvederà a 
     * sbrigarli di conseguenza.
     * 
     * task e job
     * ----------
     * Come accennato, il meccanismo di esecuzione pianificata si articola su due diverse strategie, 
     * rappresentate rispettivamente dai task e dai job. Da un lato i primi rappresentano un lavoro
     * puntuale, eseguito ad ogni chiamata senza cognizione del contesto complessivo delle cose da fare;
     * e di conseguenza la natura stessa del task è quella di coincidere con la singola chiamata.
     * Dall'altra parte, i job rappresentano lavori pianificati con un inizio e una fine e un'estensione
     * predeterminata, in quanto hanno cognizione del contesto globale del compito da svolgere.
     * 
     * Un esempio di task è la gestione delle code della posta; ad ogni chiamata, il task controlla se c'è
     * almeno una mail da inviare, se sì la invia, dopodiché termina, senza preoccuparsi di quante mail da
     * inviare ci siano nel complesso (perché è irrilevante dal suo punto di vista). Viceversa, un esempio
     * di job è l'importazione dell'elenco aggiornato dei comuni italiani; in questo caso, il job prima
     * scarica l'intero elenco dei comuni, poi pianifica il numero di esecuzioni necessarie per importarlo,
     * dopodiché ad ogni chiamata successiva esegue una parte del lavoro sapendo quanto ha già fatto e
     * quanto manca al completamento del compito, infine quando ha terminato l'importazione finisce e
     * registra la chiusura del procedimento.
     * 
     * lo script di appoggio in /etc/cron.d/
     * -------------------------------------
     * Ad ogni chiamata, l'API _src/_api/_cron.php ricava dalle tabelle *task* e *job* l'elenco delle cose
     * da fare, utilizzando un meccanismo di lock software basato su token per evitare la concorrenza. Prima
     * vengono eseguiti i task, e successivamente vengono fatti avanzare i job.
     * 
     * Le informazioni rilevanti sul lavoro dell'API vengono salvate rispettivamente sotto le chiavi
     * $cf['cron']['task'] e $cf['cron']['job'], inoltre un log specifico per la tracciatura degli esiti di
     * tali lavorazioni è tenuto in var/log/cron/ e specificamente il dettaglio dell'ultima esecuzione è contenuto
     * in var/log/latest/cron.latest.log.
     * 
     * logging dell'attività di cron
     * -----------------------------
     * Tutte le attività principali dell'API cron vengono registrate su /var/log/cron/YYYYMMDDHH.log; in pratica,
     * qui viene registrata tutta l'attività di cron (ovvero il contenuto di $cf['cron']). Il dettaglio dell'ultima
     * esecuzione di cron si trova invece in var/log/latest/cron.latest.log.
     * 
     * esecuzione dei task
     * ===================
     * Un task può essere chiamato manualmente in maniera diretta, oppure tramite cron. Nel primo caso è necessario
     * far puntare il browser (o fare una chiamata Ajax) all'URL del task; ad esempio per chiamare il task
     * /_src/_api/_task/_memcache.clean.php si accederà all'endpoint /task/memcache.clean (si veda la documentazione
     * del file .htaccess per ulteriori dettagli sui percorsi e sulla riscrittura degli URL).
     * 
     * Per eseguire un task in maniera ricorrente e pianificata, è necessario invece che esso sia presente nella
     * tabella task, la cui struttura è simile a quella del file /etc/crontab di Linux. Ogni volta che viene chiamata
     * l'API cron (/api/cron) il framework controlla se ci sono task da eseguire in quel momento, e nel caso
     * provvede ad eseguirli.
     * 
     * test dei task
     * -------------
     * Il test dei task è facilitato dal fatto che possono essere chiamati manualmente quante volge si vuole per
     * testarli a fondo prima di iniziare a utilizzarli. Una volta che si è sicuri del buon funzionamento del task
     * chiamato manualmente, è possibile aggiungerlo alla tabella task con la sua pianificazione. Un esempio di
     * codice SQL per questo inserimento sarebbe:
     * 
     * ```
     * INSERT INTO `task` (`id`, `minuto`, `ora`, `giorno_del_mese`, `mese`, `giorno_della_settimana`, `settimana`, `task`, `iterazioni`, `delay`, `token`, 
     *     `timestamp_esecuzione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`)
     * VALUES
     *     (1, NULL, NULL, NULL, NULL, NULL, NULL, '_src/_api/_task/_test.cron.php', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
     * ```
     * 
     * Questo task (nell'esempio _src/_api/_task/_test.cron.php) verrà eseguito ogni minuto. Si può verificarlo facilmente
     * chiamando a mano l'API cron oppure, se è attiva l'esecuzione automatica, basterà tenere sott'occhio i log (vedi sotto).
     * 
     * log delle operazioni dei task
     * -----------------------------
     * I log dei task sono raggruppati per ID del task (con riferimento all'ID che il task ha sulla tabella dei task).
     * Quando un task viene chiamato manualmente è prassi fare riferimento soprattutto all'output JSON che genera, mentre
     * quando viene eseguito da cron è possibile consultare i log per avere informazioni più dettagliate. I file di
     * log dei task pianificati sono /var/log/task/TASKID.log (che contiene informazioni generali sull'esecuzione del task)
     * e /var/log/task/TASKID/MICROTIME.log (che contiene informazioni più dettagliate relative a una specifica esecuzione
     * del task). In pratica il primo file è un log sintetico e cumulativo, mentre il secondo dettagliato e suddiviso
     * in piccole parti ognuna relativa a una data esecuzione.
     * 
     * esecuzione dei job
     * ==================
     * Mentre la chiamata di un task è un evento puntuale, che si esaurisce in sé stesso e non ha memoria delle esecuzioni
     * precedenti o successive, la chiamata di un job è qualcosa che fa avanzare il job stesso lungo un percorso di
     * lavoro predeterminato, la cui lunghezza è nota al tempo dell'avvio, e all'interno del quale tutte le esecuzioni
     * hanno una memoria comune (il workspace del job).
     * 
     * L'esecuzione manuale di un job richiede l'utilizzo dell'API job (esiste anche la possibilità di creare dei job
     * standalone, ma è deprecata); di conseguenza, anche il debug di un nuovo job andrà fatto in questo modo. Per eseguire
     * manualmente un job è necessario prima di tutto inserire una riga nella tabella job specificando il flag se_foreground;
     * questo farà sì che il cron ignori il job, consentendone l'esecuzione manuale.
     * 
     * Per eseguire un job in maniera automatica è necessario che il flag se_foreground sia settato a NULL, in modo che
     * sia il cron ad occuparsi dell'esecuzione.
     * 
     * test dei job
     * ------------
     * Anche se apparentemente è più complicato, il test dei job funziona in maniera molto simile a quello dei task. Dopo
     * aver inserito la riga relativa nella tabella dei job, si disporrà dell'ID necessario a chiamare l'API job per
     * l'esecuzione manuale:
     * 
     * ```
     * /api/job/<jobId>
     * ```
     * 
     * Per il debug si può fare riferimento sia al JSON di risposta sia alle informazioni che il job scriverà sui file
     * di log.
     * 
     * log delle operazioni dei job
     * ----------------------------
     * Come per i task, anche i log dei job sono raggruppati per ID del job, e in particolare il file /var/log/job/JOBID.log
     * rappresenta il log per le informazioni generali, meno dettagliato ma cumulativo di tutte le esecuzioni del job, mentre
     * il file /var/log/job/JOBID/AVANZAMENTO.MICROTIME.log contiene le informazioni specifiche relative a uno step dato.
     * Si noti che oltre al tempo in questo caso rileva anche il punto di avanzamento del job (cosa che non aveva invece senso
     * nell'ambito dei task).
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
