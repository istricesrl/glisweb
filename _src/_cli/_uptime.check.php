<?php

    /**
     * giro di un minuto del controllo di uptime
     *
     * Questo file e' l'entry point PHP di _src/_sh/_uptime.check.sh e non va lanciato direttamente.
     *
     * introduzione
     * ============
     * Legge la configurazione del cluster da /etc/glisweb/uptime.yaml, prende le viste degli altri server, controlla i
     * siti glisweb di questo server e quelli che gli altri pubblicano, decide chi e' giu', scrive il registro e il
     * DOWNTIME.md dei deploy coinvolti e manda gli avvisi. La vista di questo server resta in var/uptime/stato.json,
     * che /status/uptime serve agli altri server del cluster.
     *
     * opzioni
     * =======
     * opzione              | effetto
     * ---------------------|---------------------------------------------------------------
     * --secco              | controlla e stampa, senza scrivere niente e senza avvisare
     * --prova-avviso       | manda una mail di prova agli indirizzi avvisa.noi e si ferma
     * --config FILE        | legge la configurazione da FILE invece che da /etc/glisweb/uptime.yaml
     *
     * dipendenze
     * ==========
     * NON esegue il bootstrap del framework, per le stesse ragioni di _src/_cli/_docs.build.php: il monitoraggio
     * deve girare anche quando il deploy da cui parte ha il database giu'. Servono l'autoload di composer, per
     * PHPMailer, e le librerie _src/_lib/_uptime.tools.php, _mail.tools.php e _filesystem.tools.php.
     *
     * licenza
     * =======
     * Questo file fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed e'
     * distribuita sotto licenza Open Source.
     *
     */

    // la document root e' la cartella da cui lo script wrapper ha gia' fatto cd
    define( 'DIR_BASE', rtrim( getcwd(), '/' ) . '/' );

    // opzioni
    $opt = getopt( '', array( 'secco', 'prova-avviso', 'config:' ) );
    $secco = isset( $opt['secco'] );
    $file = isset( $opt['config'] ) ? $opt['config'] : '/etc/glisweb/uptime.yaml';

    // configurazione del cluster
    if( ! function_exists( 'yaml_parse_file' ) ) {
        fwrite( STDERR, "manca l'estensione yaml di PHP\n" );
        exit( 1 );
    }
    $conf = is_readable( $file ) ? @yaml_parse_file( $file ) : false;
    if( empty( $conf['server'] ) ) {
        fwrite( STDERR, "configurazione assente o senza server: $file\n" );
        exit( 1 );
    }
    $conf = array_replace( array( 'cluster' => array(), 'token' => NULL, 'radice' => '/var/www/', 'smtp' => array(), 'avvisa' => array() ), $conf );
    $io = $conf['server'];

    // le librerie scrivono i log con logger() e logWrite(), che senza bootstrap non ci sono: gli errori vanno nel journal
    if( ! function_exists( 'logger' ) ) {
        function logger( $m, $f = 'uptime', $l = LOG_DEBUG ) {
            if( $l <= LOG_ERR ) {
                fwrite( STDERR, $m . PHP_EOL );
            }
        }
    }
    if( ! function_exists( 'logWrite' ) ) {
        function logWrite( $m, $f = 'uptime', $l = LOG_DEBUG ) {
            if( $l <= LOG_ERR ) {
                fwrite( STDERR, $m . PHP_EOL );
            }
        }
    }

    // librerie
    if( file_exists( DIR_BASE . '_src/_lib/_ext/autoload.php' ) ) {
        require_once DIR_BASE . '_src/_lib/_ext/autoload.php';
    }
    require_once DIR_BASE . '_src/_lib/_filesystem.tools.php';
    require_once DIR_BASE . '_src/_lib/_mail.tools.php';
    require_once DIR_BASE . '_src/_lib/_uptime.tools.php';

    // prova degli avvisi
    if( isset( $opt['prova-avviso'] ) ) {
        $noi = isset( $conf['avvisa']['noi'] ) ? $conf['avvisa']['noi'] : array();
        $esito = uptimeAvvisa( $conf['smtp'], $noi, '[uptime] prova da ' . $io, 'Mail di prova del controllo di uptime, mandata da ' . $io . ' il ' . date( 'd/m/Y H:i' ) . '.' );
        echo 'prova a ' . implode( ', ', (array) $noi ) . ': ' . ( $esito ? 'inviata' : 'NON inviata' ) . PHP_EOL;
        exit( $esito ? 0 : 1 );
    }

    // stato del giro precedente
    $cartella = DIR_BASE . 'var/uptime/';
    $ora = time();
    $prima = is_readable( $cartella . 'stato.json' ) ? json_decode( file_get_contents( $cartella . 'stato.json' ), true ) : array();
    $vista = isset( $prima['vista'] ) ? $prima['vista'] : array();

    // viste degli altri server
    $altri = array();
    foreach( $conf['cluster'] as $nome => $url ) {
        if( $nome != $io ) {
            $altri[ $nome ] = uptimeVista( $url, $conf['token'] );
        }
    }

    // i siti di questo server e quelli che pubblicano gli altri
    $scartati = array();
    $locali = uptimeSiti( $conf['radice'], uptimeVhost(), isset( $conf['escludi'] ) ? (array) $conf['escludi'] : array(), $scartati );
    $siti = array_replace( uptimeEsterni( isset( $conf['esterni'] ) ? $conf['esterni'] : array() ), $locali );
    foreach( $altri as $nome => $a ) {
        if( $a !== NULL ) {
            foreach( $a['siti'] as $h => $s ) {
                if( ! isset( $siti[ $h ] ) ) {
                    $siti[ $h ] = array_replace( UPTIME_DEFAULT, $s, array( 'deploy' => NULL ) );
                }
            }
        }
    }

    // controlli e isteresi
    $esiti = uptimeControlla( $siti, isset( $conf['paralleli'] ) ? $conf['paralleli'] : 4 );
    $prima_vista = $vista;
    $vista = uptimeAggiorna( $vista, $esiti, array_combine( array_keys( $siti ), array_column( $siti, 'soglia' ) ), array_combine( array_keys( $siti ), array_column( $siti, 'lento' ) ) );

    // gli avvisi di servizio ( certificato, DNS ) li manda il primo dei server che rispondono
    $presenti = array( $io );
    foreach( $altri as $nome => $a ) {
        if( $a !== NULL ) {
            $presenti[] = $nome;
        }
    }
    sort( $presenti );
    $primo = ( reset( $presenti ) === $io );

    // consenso, registro, avvisi
    $eventi = array();

    // un sito uscito dal controllo mentre era giù chiude il suo periodo, altrimenti resterebbe in corso per sempre
    foreach( array_diff_key( $prima_vista, $vista ) as $h => $v ) {
        if( isset( $v['globale'] ) && $v['globale'] !== 'su' && isset( $v['dal'] ) ) {
            $eventi[] = array( 'evento' => 'fine', 'sito' => $h, 'ora' => date( 'c', $ora ), 'inizio' => date( 'c', $v['dal'] ),
                'durata' => $ora - $v['dal'], 'confermato' => ! empty( $v['confermato'] ), 'rimosso' => true );
        }
    }
    $posta = array();

    foreach( $vista as $h => $v ) {

        $viste = array();
        foreach( $altri as $nome => $a ) {
            $viste[ $nome ] = ( $a !== NULL && isset( $a['vista'][ $h ]['locale'] ) ) ? $a['vista'][ $h ]['locale'] : NULL;
        }

        $c = uptimeConsenso( $io, $v['locale'], $viste );
        list( $vista[ $h ], $e ) = uptimeTransizione( $h, $v, $c['stato'], $ora, $c['giu'] );
        if( $e !== NULL ) {
            $eventi[] = $e;
        }

        $avvisa = array_replace( $conf['avvisa'], isset( $siti[ $h ]['avvisa'] ) ? (array) $siti[ $h ]['avvisa'] : array() );
        $noi = isset( $avvisa['noi'] ) ? $avvisa['noi'] : array();
        $referente = ( ! empty( $avvisa['abilitato'] ) && ! empty( $avvisa['referente'] ) ) ? $avvisa['referente'] : array();
        $ritardo = isset( $avvisa['ritardo'] ) ? $avvisa['ritardo'] : UPTIME_DEFAULT['ritardo'];
        $s = $vista[ $h ];

        // giu', o confermato dopo un avviso non confermato
        if( $c['mittente'] && ( empty( $s['avvisato'] ) || ( $s['avvisato'] === 'nonconfermato' && $c['stato'] === 'giu' ) ) ) {
            $posta[] = array( $noi, '[uptime] ' . $h . ' GIU\'' . ( $c['stato'] === 'giu' ? '' : ' ( non confermato )' ),
                $h . ' non risponde dal ' . date( 'd/m/Y H:i', $s['dal'] ) . ': ' . $s['errore'] . PHP_EOL
                . 'visto giu\' da: ' . implode( ', ', $c['giu'] ) . PHP_EOL
                . ( $c['stato'] === 'giu' ? '' : 'nessun altro server del cluster ha risposto: puo\' essere un problema di ' . $io . PHP_EOL ) );
            $vista[ $h ]['avvisato'] = $c['stato'];
        }

        // il referente, solo se abilitato e dopo il ritardo di down confermato
        if( $c['mittente'] && $c['stato'] === 'giu' && ! empty( $referente ) && empty( $s['referente'] ) && $ora - $s['dal'] >= $ritardo * 60 ) {
            $posta[] = array( $referente, '[uptime] ' . $h . ' non raggiungibile',
                'Il sito ' . $h . ' non risponde dal ' . date( 'd/m/Y H:i', $s['dal'] ) . '. Ce ne stiamo gia\' occupando.' . PHP_EOL );
            $vista[ $h ]['referente'] = true;
        }

        // di nuovo su: lo dice chi aveva avvisato, a chi era stato avvisato
        if( $e !== NULL && $e['evento'] === 'fine' && ! empty( $v['avvisato'] ) ) {
            $corpo = $h . ' risponde di nuovo dal ' . date( 'd/m/Y H:i', $ora ) . ', dopo ' . ceil( $e['durata'] / 60 ) . ' minuti.' . PHP_EOL;
            $posta[] = array( $noi, '[uptime] ' . $h . ' di nuovo su', $corpo );
            if( ! empty( $v['referente'] ) ) {
                $posta[] = array( $referente, '[uptime] ' . $h . ' di nuovo raggiungibile', $corpo );
            }
        }

        // lento: inizio e fine vanno solo nel registro, senza mail
        $era = ! empty( $prima_vista[ $h ]['lento'] );
        if( $s['lento'] !== $era ) {
            $eventi[] = array( 'evento' => ( $s['lento'] ) ? 'lento' : 'normale', 'sito' => $h, 'ora' => date( 'c', $ora ), 'tempo' => $s['tempo'] );
        }

        // certificato in scadenza: una volta al giorno, solo a noi
        if( $primo && $s['certificato'] !== NULL && $s['certificato'] < $siti[ $h ]['certificato'] && ( ! isset( $s['avvertito'] ) || $s['avvertito'] !== date( 'Y-m-d', $ora ) ) ) {
            $posta[] = array( $noi, '[uptime] ' . $h . ': il certificato scade fra ' . $s['certificato'] . ' giorni', 'Il certificato di ' . $h . ' scade fra ' . $s['certificato'] . ' giorni.' . PHP_EOL );
            $vista[ $h ]['avvertito'] = date( 'Y-m-d', $ora );
        }

    }

    // se il server ha dei siti ma nessuno risulta pubblico, il problema è più probabilmente il DNS del server che i
    // siti: senza questo avviso il controllo si spegnerebbe in silenzio
    $irrisolti = array_keys( $scartati, 'dns' );
    if( empty( $locali ) && ! empty( $irrisolti ) && $primo && ( ! isset( $prima['dns'] ) || $prima['dns'] !== date( 'Y-m-d', $ora ) ) ) {
        $posta[] = array( isset( $conf['avvisa']['noi'] ) ? $conf['avvisa']['noi'] : array(), '[uptime] ' . $io . ': nessun sito risolto nel DNS',
            'Nessuno dei ' . count( $irrisolti ) . ' siti di produzione di ' . $io . ' si risolve nel DNS pubblico: controllare il resolver del server.' . PHP_EOL );
        $dns = date( 'Y-m-d', $ora );
    } else {
        $dns = isset( $prima['dns'] ) ? $prima['dns'] : NULL;
    }

    // a secco si stampa e ci si ferma
    if( $secco ) {
        foreach( $vista as $h => $v ) {
            echo str_pad( $h, 40 ) . ' ' . str_pad( $v['globale'], 14 ) . ' ' . $v['fallimenti'] . ' ' . $v['tempo'] . 's ' . ( $v['certificato'] === NULL ? '' : $v['certificato'] . 'gg ' ) . $v['errore'] . PHP_EOL;
        }
        foreach( $scartati as $h => $motivo ) {
            echo 'scartato ( ' . $motivo . ' ): ' . $h . PHP_EOL;
        }
        foreach( $eventi as $e ) {
            echo 'evento: ' . json_encode( $e ) . PHP_EOL;
        }
        foreach( $posta as $p ) {
            echo 'avviso a ' . implode( ', ', (array) $p[0] ) . ': ' . $p[1] . PHP_EOL;
        }
        exit( 0 );
    }

    // la vista di questo server, per gli altri: pubblica solo i siti propri, cosi' un sito tolto non resta in giro
    if( ! is_dir( $cartella ) ) {
        mkdir( $cartella, 0750, true );
        @chgrp( $cartella, 'www-data' );
    }
    $pubblici = array();
    foreach( $locali as $h => $s ) {
        unset( $s['deploy'], $s['dichiarato'], $s['avvisa'] );
        $pubblici[ $h ] = $s;
    }
    file_put_contents( $cartella . 'stato.json', json_encode( array( 'server' => $io, 'ora' => date( 'c', $ora ), 'dns' => $dns, 'siti' => $pubblici, 'vista' => $vista ), JSON_PRETTY_PRINT ), LOCK_EX );
    @chgrp( $cartella . 'stato.json', 'www-data' );
    @chmod( $cartella . 'stato.json', 0640 );

    // registro e DOWNTIME.md dei deploy di questo server toccati da un evento
    if( ! empty( $eventi ) ) {
        $righe = '';
        foreach( $eventi as $e ) {
            $righe .= json_encode( $e ) . PHP_EOL;
            echo $e['evento'] . ' ' . $e['sito'] . PHP_EOL;
        }
        file_put_contents( $cartella . 'registro.jsonl', $righe, FILE_APPEND | LOCK_EX );
        $registro = array_map( function( $r ) { return json_decode( $r, true ); }, file( $cartella . 'registro.jsonl', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES ) );
        $deploy = array();
        foreach( $eventi as $e ) {
            if( ! empty( $locali[ $e['sito'] ]['deploy'] ) ) {
                $deploy[ $locali[ $e['sito'] ]['deploy'] ] = true;
            }
        }
        foreach( array_keys( $deploy ) as $dev ) {
            $host = array_keys( array_filter( $locali, function( $s ) use( $dev ) { return $s['deploy'] === $dev; } ) );
            file_put_contents( dirname( $dev ) . '/DOWNTIME.md', uptimeDowntime( $registro, $host ) );
        }
    }

    // avvisi
    foreach( $posta as $p ) {
        if( ! uptimeAvvisa( $conf['smtp'], $p[0], $p[1], $p[2] ) ) {
            fwrite( STDERR, 'avviso non inviato: ' . $p[1] . PHP_EOL );
        }
    }
