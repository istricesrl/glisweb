<?php

    /**
     * Pota i log dei task pianificati.
     *
     * `_src/_api/_cron.php` scrive, per ogni task eseguito, **un file per ogni iterazione** in
     * `var/log/task/<id>/<microtime>.log`. Non li pota nessuno: un task pianificato al minuto ne
     * lascia 1.440 al giorno, e la cartella cresce e basta, come `var/log/slow/` prima di
     * `_log.slow.clean.php`, di cui questo task e' il gemello.
     *
     * Osservato il 2026-09-29 su un deploy in DEV con sette task al minuto: `var/log/task/` a
     * **692 MB**, oltre dodicimila file per cartella, mezzo `var/log/`. Il cron di sistema che pota
     * i log mensili non li vede, perche' seleziona per nome i soli `*.<AAAAMM>.log`.
     *
     * Pota anche i vecchi `var/log/task/<id>.log`, il log sintetico cumulativo che fino al
     * 2026-09-29 non aveva il mese nel nome e cresceva in append per sempre ( 50 MB a task ).
     * Adesso si chiama `<id>.<AAAAMM>.log`, come gli altri log del framework, e lo pota il cron di
     * sistema: quelli senza mese smettono di crescere e qui se ne vanno quando sono piu' vecchi
     * della finestra. Sono pochi, uno per task, quindi per loro `filemtime()` non costa niente.
     *
     * ⚠ PER I FILE DI ITERAZIONE SI DECIDE DAL NOME, NON DA `filemtime()`, per lo stesso motivo
     * spiegato in `_log.slow.clean.php`: il nome e' `<microtime>.log`, l'istante e' gia' li' davanti,
     * e `stat()` su decine di migliaia di file e' esattamente il carico che si vuole evitare. Il
     * separatore decimale del microtime dipende dalla locale ( `1789965362,4655.log` con it-IT ):
     * `intval()` si ferma alla virgola come al punto, quindi va bene in tutti e due i casi.
     *
     * Si regolano da `$cf`:
     *
     *     $cf['debug']['log']['task']['giorni']  default 7    quanti giorni si tengono
     *     $cf['debug']['log']['task']['limite']  default 5000 quanti file al massimo per giro
     *
     * Il limite vale per il giro intero, non per cartella: la prima esecuzione su un deploy lasciato
     * crescere per mesi trova centinaia di migliaia di file, e con il cron frequente la cartella
     * rientra in qualche giro senza tenere occupato il filesystem.
     *
     * ⚠ NON basta scriverle in `src/config.json`: vale la stessa avvertenza di `_log.slow.clean.php`,
     * servono due righe in un runlevel di progetto.
     *
     * Uso ( sempre via web: da CLI il bootstrap esce in silenzio ):
     *   /task/log.task.clean                 il giro normale
     *   /task/log.task.clean?dryrun=1        anteprima, non cancella
     *   /task/log.task.clean?giorni=30       finestra piu' larga
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

    // quanto si tiene, e quanto si cancella per giro
    $giorni = ( ! empty( $_REQUEST['giorni'] ) )
        ? intval( $_REQUEST['giorni'] )
        : ( ( ! empty( $cf['debug']['log']['task']['giorni'] ) ) ? intval( $cf['debug']['log']['task']['giorni'] ) : 7 );

    $limite = ( ! empty( $_REQUEST['limite'] ) )
        ? intval( $_REQUEST['limite'] )
        : ( ( ! empty( $cf['debug']['log']['task']['limite'] ) ) ? intval( $cf['debug']['log']['task']['limite'] ) : 5000 );

    $dryrun = ( ! empty( $_REQUEST['dryrun'] ) );

    // una finestra a zero cancellerebbe anche i log dell'esecuzione in corso
    if( $giorni < 1 )    { $giorni = 1; }
    if( $limite < 1 )    { $limite = 1; }
    if( $limite > 50000 ) { $limite = 50000; }

    $soglia = time() - ( $giorni * 86400 );

    if( ! is_dir( DIR_VAR_LOG_TASK ) ) {

        $status['info'][] = 'nessuna cartella ' . DIR_VAR_LOG_TASK . ', niente da potare';

    } else {

        $visti      = 0;
        $cancellati = 0;
        $byte       = 0;
        $piuVecchio = NULL;

        // le cartelle dei task, e i vecchi log cumulativi senza mese nel nome
        $cartelle = array();

        $dh = opendir( DIR_VAR_LOG_TASK );

        if( $dh === false ) {

            $status['err'][] = 'impossibile aprire ' . DIR_VAR_LOG_TASK;

        } else {

            while( ( $nome = readdir( $dh ) ) !== false ) {

                $percorso = DIR_VAR_LOG_TASK . $nome;

                if( ctype_digit( $nome ) && is_dir( $percorso ) ) {
                    $cartelle[] = $percorso . '/';
                } elseif( preg_match( '/^[0-9]+\.log$/', $nome ) && $cancellati < $limite ) {
                    $ts = intval( @filemtime( $percorso ) );
                    if( $ts > 0 && $ts < $soglia ) {
                        $peso = intval( @filesize( $percorso ) );
                        if( $dryrun || @unlink( $percorso ) ) {
                            $cancellati++;
                            $byte += $peso;
                        }
                    }
                }

            }

            closedir( $dh );

        }

        /**
         * Dentro le cartelle si legge una voce per volta con `readdir()` invece di `glob()`, come
         * in `_log.slow.clean.php`: `glob()` costruisce in memoria l'elenco completo.
         */
        foreach( $cartelle as $cartella ) {

            $dh = opendir( $cartella );

            if( $dh === false ) {
                $status['err'][] = 'impossibile aprire ' . $cartella;
                continue;
            }

            while( ( $nome = readdir( $dh ) ) !== false ) {

                if( substr( $nome, -4 ) !== '.log' ) {
                    continue;
                }

                // il nome e' <microtime>.log: l'istante dell'iterazione e' gia' qui
                $ts = intval( $nome );

                if( $ts <= 0 ) {
                    continue;
                }

                $visti++;

                if( $piuVecchio === NULL || $ts < $piuVecchio ) {
                    $piuVecchio = $ts;
                }

                if( $ts >= $soglia ) {
                    continue;
                }

                if( $cancellati >= $limite ) {
                    continue;
                }

                $percorso = $cartella . $nome;

                if( $dryrun ) {
                    $cancellati++;
                    $byte += intval( @filesize( $percorso ) );
                } else {
                    $peso = intval( @filesize( $percorso ) );
                    if( @unlink( $percorso ) ) {
                        $cancellati++;
                        $byte += $peso;
                    }
                }

            }

            closedir( $dh );

        }

        $status['info'][] = 'log di iterazione in archivio: ' . $visti . ' in ' . count( $cartelle ) . ' cartelle'
            . ( ( $piuVecchio !== NULL ) ? ', il piu' . "'" . ' vecchio del ' . date( 'd/m/Y', $piuVecchio ) : '' );

        $status['info'][] = ( ( $dryrun ) ? 'da cancellare' : 'cancellati' ) . ': ' . $cancellati
            . ' file oltre i ' . $giorni . ' giorni, ' . writeByte( $byte );

        if( $cancellati >= $limite ) {
            $status['info'][] = 'raggiunto il limite di ' . $limite . ' file per giro: il prossimo passaggio continua';
        }

        // si scrive nel log solo quando c'e' stato qualcosa da fare, come in _log.slow.clean.php
        if( $cancellati > 0 && ! $dryrun ) {
            logWrite(
                'potati ' . $cancellati . ' log di task oltre i ' . $giorni . ' giorni ( '
                . writeByte( $byte ) . ' liberati, ' . ( $visti - $cancellati ) . ' rimasti )',
                'filesystem'
            );
        }

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
