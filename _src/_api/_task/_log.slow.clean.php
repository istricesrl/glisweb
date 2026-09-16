<?php

    /**
     * Pota i log delle richieste lente.
     *
     * `_src/_api/_pages.php` e `_src/_api/_rest.php` scrivono **un file per ogni richiesta** che
     * supera la soglia di 0,75 s o i 15 MB di memoria, in `var/log/slow/`. Non li pota nessuno.
     * Tutte le altre cartelle di log del framework ruotano ( `$cf['debug']['log']['rotation']` ),
     * questa no: cresce e basta.
     *
     * Osservato il 2026-09-16 su un deploy in esercizio: **51.389 file per 2,2 GB**, il piu' vecchio
     * di mesi. Su una macchina che ospita dieci deploy, e che di RAM ne ha quattro.
     *
     * NON E' SOLO ORDINE, ed e' il motivo per cui questo task esiste invece di una riga nel manuale.
     * Una cartella con cinquantamila file e' una **trappola per chi prova a misurare**: qualunque
     * strumento che la scandisca per intero — un `find`, un `glob()` seguito da `file_get_contents`,
     * anche solo un `ls` in un ciclo — diventa un generatore di carico piu' pesante della lentezza
     * che sta cercando. Nello stesso giorno in cui la cartella e' stata scoperta, un sorvegliante
     * scritto per intercettare le richieste lente le ha fatte passare da 3,65 a 15,42 secondi al
     * minuto, da solo, perche' rileggeva quei 2,2 GB a ogni giro.
     *
     * Quei file servono per le ore successive a un problema, non per i mesi: una finestra corta
     * basta e avanza. Il default e' **sette giorni**, che copre il fine settimana lungo.
     *
     * ⚠ COME SI SCEGLIE COSA CANCELLARE, e qui sta la sola cosa non ovvia di questo task: **dal
     * nome del file, non da `filemtime()`**. Il nome e' `<microtime>.<ip>.log`, quindi l'istante
     * della richiesta e' gia' li' davanti, e leggerlo costa zero. Chiamare `stat()` su
     * cinquantamila file per sapere una cosa che e' scritta nel nome vorrebbe dire ripetere
     * esattamente l'errore che questo task serve a non far fare piu' a nessuno.
     *
     * Si regolano da `$cf`:
     *
     *     $cf['debug']['log']['slow']['giorni']  default 7    quanti giorni si tengono
     *     $cf['debug']['log']['slow']['limite']  default 5000 quanti file al massimo per giro
     *
     * Il limite per giro non e' prudenza eccessiva: la prima esecuzione su una cartella lasciata
     * crescere per mesi ne trova decine di migliaia, e cancellarli tutti in un colpo tiene occupato
     * il filesystem proprio mentre il sito lavora. Con il cron al minuto la cartella rientra in
     * qualche giro, senza che nessuno se ne accorga.
     *
     * ⚠ NON basta scriverle in `src/config.json`. I file JSON di progetto vengono letti dentro
     * l'array `$cx` ed e' poi OGNI RUNLEVEL a travasare la propria chiave in `$cf`: una sezione
     * nuova di `config.json` resta quindi invisibile, senza errori. Per cambiare i valori servono
     * due righe in un runlevel di progetto.
     *
     * Uso ( sempre via web: da CLI il bootstrap esce in silenzio ):
     *   /task/log.slow.clean                 il giro normale
     *   /task/log.slow.clean?dryrun=1        anteprima, non cancella
     *   /task/log.slow.clean?giorni=30       finestra piu' larga
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
        : ( ( ! empty( $cf['debug']['log']['slow']['giorni'] ) ) ? intval( $cf['debug']['log']['slow']['giorni'] ) : 7 );

    $limite = ( ! empty( $_REQUEST['limite'] ) )
        ? intval( $_REQUEST['limite'] )
        : ( ( ! empty( $cf['debug']['log']['slow']['limite'] ) ) ? intval( $cf['debug']['log']['slow']['limite'] ) : 5000 );

    $dryrun = ( ! empty( $_REQUEST['dryrun'] ) );

    // una finestra a zero cancellerebbe anche i log della richiesta in corso
    if( $giorni < 1 )    { $giorni = 1; }
    if( $limite < 1 )    { $limite = 1; }
    if( $limite > 50000 ) { $limite = 50000; }

    $soglia = time() - ( $giorni * 86400 );

    if( ! is_dir( DIR_VAR_LOG_SLOW ) ) {

        $status['info'][] = 'nessuna cartella ' . DIR_VAR_LOG_SLOW . ', niente da potare';

    } else {

        $visti      = 0;
        $cancellati = 0;
        $byte       = 0;
        $piuVecchio = NULL;

        /**
         * Si legge la cartella una voce per volta con `readdir()` invece di `glob()`: `glob()`
         * costruisce in memoria l'elenco completo, e su una cartella da cinquantamila file e'
         * proprio il tipo di picco che si vuole evitare in un task che gira dal cron.
         */
        $dh = opendir( DIR_VAR_LOG_SLOW );

        if( $dh === false ) {

            $status['err'][] = 'impossibile aprire ' . DIR_VAR_LOG_SLOW;

        } else {

            while( ( $nome = readdir( $dh ) ) !== false ) {

                if( substr( $nome, -4 ) !== '.log' ) {
                    continue;
                }

                // il nome e' <microtime>.<ip>.log: l'istante della richiesta e' gia' qui
                $ts = intval( strtok( $nome, '.' ) );

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

                $percorso = DIR_VAR_LOG_SLOW . $nome;

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

            $status['info'][] = 'richieste lente in archivio: ' . $visti
                . ( ( $piuVecchio !== NULL ) ? ', la piu' . "'" . ' vecchia del ' . date( 'd/m/Y', $piuVecchio ) : '' );

            $status['info'][] = ( ( $dryrun ) ? 'da cancellare' : 'cancellati' ) . ': ' . $cancellati
                . ' file oltre i ' . $giorni . ' giorni, ' . writeByte( $byte );

            if( $cancellati >= $limite ) {
                $status['info'][] = 'raggiunto il limite di ' . $limite . ' file per giro: il prossimo passaggio continua';
            }

            /**
             * Si scrive nel log solo quando c'e' stato qualcosa da fare. Una riga che compare a
             * ogni giro di cron smette di essere letta, ed e' lo stesso criterio degli altri
             * controlli periodici del framework.
             */
            if( $cancellati > 0 && ! $dryrun ) {
                logWrite(
                    'potati ' . $cancellati . ' log di richieste lente oltre i ' . $giorni . ' giorni ( '
                    . writeByte( $byte ) . ' liberati, ' . ( $visti - $cancellati ) . ' rimasti )',
                    'filesystem'
                );
            }

        }

    }
