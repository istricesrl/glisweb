<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // do un riferimento temporale ai job che non ne hanno ancora uno
    //
    // i due recuperi qui sotto filtrano su "timestamp_esecuzione < ?" e in SQL il
    // confronto con NULL non e' mai vero, quindi un job appena inserito - che ha
    // timestamp_esecuzione NULL, perche' la colonna e' DEFAULT NULL e le INSERT
    // non la valorizzano - e' invisibile a entrambi. Le conseguenze:
    //
    // - un job creato con se_foreground non verrebbe MAI riportato in background,
    //   quindi se nessuno apre l'interfaccia per farlo avanzare resta fermo per
    //   sempre invece di essere completato dal cron;
    // - un job a cui _job.php ha messo il token (senza scrivere
    //   timestamp_esecuzione) e che si interrompe prima della prima iterazione
    //   resta lockato per sempre, perche' lo sblocco non lo vede.
    //
    // stampando qui il riferimento, il conto dei 10 minuti parte dal primo giro di
    // cron successivo alla creazione e i due recuperi tornano a funzionare.
    mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE job SET timestamp_esecuzione = ? WHERE timestamp_esecuzione IS NULL AND timestamp_completamento IS NULL',
        array(
            array( 's' => time() )
        )
    );

    // sblocco i cron
    $status['cron'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'UPDATE cron SET token = NULL WHERE token IS NOT NULL AND timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // sblocco i job
    $status['job']['background'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'UPDATE job SET token = NULL WHERE token IS NOT NULL AND timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // porto in background i job fermi in foreground
    $status['job']['foreground'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'UPDATE job SET se_foreground = NULL WHERE timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
