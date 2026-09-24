<?php

    /**
     * Segnala le tabelle che tengono occupato spazio che non usano piu'.
     *
     * InnoDB non restituisce al filesystem lo spazio delle righe cancellate: resta dentro il file
     * della tabella e viene riusato solo da quella tabella. Dopo una cancellazione massiva un file
     * puo' quindi restare grande il doppio di quello che contiene, per sempre, senza che nessuno se
     * ne accorga — non e' un errore e non compare in nessun log.
     *
     * Osservato il 2026-09-10 su un deploy in esercizio: `__report_lezioni_corsi__` aveva 377 MB di
     * dati e 373 MB di spazio libero dentro il file, cioe' meta' del file era vuota, e `todo` 104
     * contro 79. In tutto 452 MB su una macchina che di RAM ne ha 3,9 e che ospita dieci deploy.
     *
     * QUESTO TASK NON RECUPERA NIENTE, E NON DEVE. Il recupero si fa con `OPTIMIZE TABLE`, che su
     * InnoDB e' una ricostruzione della tabella: costa I/O pieno ogni volta, e quando non c'e'
     * niente da recuperare quel costo e' tutto sprecato. Farlo periodicamente sarebbe un peso fisso
     * in cambio di niente. Qui si guarda soltanto — una query su `information_schema`, che non
     * tocca le tabelle — e si scrive nel log quando vale la pena intervenire; a quel punto decide
     * una persona e usa `_src/_sh/_database.optimize.sh`, che l'operazione la fa con le cautele del
     * caso.
     *
     * E' la stessa divisione dei compiti che il framework usa gia' altrove: `_folders.check.sh`,
     * `_database.rebuild.check.sh` e `_cron.queue.check.php` guardano e riportano, e chi ripara e'
     * un altro.
     *
     * ATTENZIONE a non confondere questo caso con quello dei task `*.queue.clean.*`, che dopo
     * `DELETE FROM <tabella>` fanno subito `OPTIMIZE TABLE <tabella>`: quelli sono svuotamenti
     * TOTALI, e l'optimize su una tabella diventata vuota non costa niente. Sulle cancellazioni
     * parziali la stessa mossa e' una ricostruzione piena, ed e' il motivo per cui il framework
     * non la fa in `_job.clean.php`.
     *
     * DUE SOGLIE, E SERVONO ENTRAMBE. Da sole non dicono niente: il 60% di spazio libero su una
     * tabella da 2 MB non vale un intervento, e 200 MB liberi su un file da 20 GB sono fisiologici.
     * Si segnala solo quando lo spreco e' insieme grande in assoluto e grande in proporzione.
     * I default sono tarati su un caso reale: con 50 MB e 25% la produzione osservata riporta le
     * due tabelle che contano ( 452 MB in tutto ) e il database di sviluppo, che di sprechi non ne
     * ha, non riporta niente. Alzando a 100 MB si perderebbe `todo`, che di spazio vuoto ne ha 79
     * su 183, cioe' il 43% del file: assoluta e percentuale servono proprio perche' nessuna delle
     * due da sola inquadra quel caso.
     *
     * Si regolano da `$cf`:
     *
     *     $cf['database']['frammentazione']['soglia_mb']          default 50
     *     $cf['database']['frammentazione']['soglia_percentuale'] default 25
     *
     * ⚠ NON basta scriverle in `src/config.json`. I file JSON di progetto vengono letti dentro
     * l'array `$cx` ( `_src/_config.php`, `array_replace_recursive( $cx, $cj )` ) ed e' poi OGNI
     * RUNLEVEL a travasare la propria chiave in `$cf`: una sezione nuova di `config.json` resta
     * quindi invisibile, senza errori e senza che svuotare la cache cambi niente. Per cambiare le
     * soglie servono due righe in un runlevel di progetto — per esempio `src/config/035.common.php`,
     * che gira perche' esiste il fratello standard `_src/_config/_035.common.php`:
     *
     *     if( isset( $cx['database'] ) ) { $cf['database'] = $cx['database']; }
     *
     * Finche' quel travaso non c'e', valgono i default qui sotto, che e' esattamente cio' che
     * serve alla maggior parte dei deploy.
     *
     * @file
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_SISTEMA' );

    // inizializzo l'array del risultato
	$status = array();

    // soglie: sotto queste non si segnala niente
    $sogliaMb          = ! empty( $cf['database']['frammentazione']['soglia_mb'] )
        ? intval( $cf['database']['frammentazione']['soglia_mb'] ) : 50;
    $sogliaPercentuale = ! empty( $cf['database']['frammentazione']['soglia_percentuale'] )
        ? intval( $cf['database']['frammentazione']['soglia_percentuale'] ) : 25;

    /**
     * Le tabelle che sprecano spazio.
     *
     * `data_free` e' lo spazio libero dentro il file; il denominatore della percentuale e' il file
     * intero ( dati + indici + libero ), non i soli dati, altrimenti una tabella quasi vuota
     * darebbe percentuali sopra il cento.
     *
     * Il filtro su `engine = 'InnoDB'` non e' pignoleria: su MyISAM `data_free` ha un significato
     * diverso e le viste materializzate del framework sono MyISAM, quindi finirebbero qui dentro
     * senza motivo.
     */
    $frammentate = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT
            table_name,
            table_rows,
            round( ( data_length + index_length ) / 1048576 ) AS usato_mb,
            round( data_free / 1048576 )                      AS libero_mb,
            round( 100 * data_free / ( data_length + index_length + data_free ) ) AS libero_percentuale
         FROM information_schema.tables
         WHERE table_schema = database()
           AND engine = ?
           AND data_free > ?
           AND ( data_length + index_length + data_free ) > 0
           AND ( 100 * data_free / ( data_length + index_length + data_free ) ) >= ?
         ORDER BY data_free DESC',
        array(
            array( 's' => 'InnoDB' ),
            array( 's' => $sogliaMb * 1048576 ),
            array( 's' => $sogliaPercentuale )
        )
    );

    $status['soglie'] = array( 'mb' => $sogliaMb, 'percentuale' => $sogliaPercentuale );
    $status['tabelle'] = array();

    $totaleRecuperabile = 0;

    if( ! empty( $frammentate ) && is_array( $frammentate ) ) {

        foreach( $frammentate as $t ) {

            $totaleRecuperabile += intval( $t['libero_mb'] );

            $status['tabelle'][] = array(
                'tabella'    => $t['table_name'],
                'usato_mb'   => intval( $t['usato_mb'] ),
                'libero_mb'  => intval( $t['libero_mb'] ),
                'libero_pct' => intval( $t['libero_percentuale'] )
            );

            logger(
                'la tabella ' . $t['table_name'] . ' tiene ' . $t['libero_mb'] . ' MB di spazio non usato ( '
                . $t['libero_percentuale'] . '% del file, ' . $t['usato_mb'] . ' MB di dati ): recuperabile con '
                . '_src/_sh/_database.optimize.sh, in una finestra tranquilla',
                'mysql',
                LOG_WARNING
            );

        }

        $status['recuperabile_mb'] = $totaleRecuperabile;

        logger(
            'in tutto ' . $totaleRecuperabile . ' MB recuperabili su ' . count( $status['tabelle'] ) . ' tabelle',
            'mysql',
            LOG_WARNING
        );

    } else {

        $status['recuperabile_mb'] = 0;
        $status['info'][] = 'nessuna tabella oltre le soglie';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
