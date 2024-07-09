<?php

    /**
     * firewall applicativo del framework
     * 
     * introduzione
     * ============
     * 
     * TODO documentare
     * 
     * 
     * il file _etc/_security/_banned.words.conf
     * -----------------------------------------
     * 
     * TODO documentare
     * 
     * 
     * il file var/spool/security/banned.hosts.conf
     * --------------------------------------------
     * 
     * TODO documentare
     * 
     * 
     * 
     * i file var/spool/security/<ip>.log
     * ----------------------------------
     * 
     * TODO documentare
     * 
     * 
     * 
     * avvertenze importanti
     * =====================
     * 
     * - questo file è standalone
     * - questo file è richiamato da _src/_config/_config.php quindi se un file del framework non usa _src/_config/_config.php deve includerlo manualmente
     * 
     * test e debug
     * ============
     * 
     * TODO controllare che $valore:
     *
     *  - non contenga tentativi di SQL injection
     *  - non contenga codice di alcun tipo
     * 
     * 
     * NOTA
     * testare chiamando il framework con un URL contenente una qualsiasi delle parole bloccate in _etc/_security/_banned.words.conf
     * 
     * 
     * 
     * 
     * TODO documentare
     *
     *
     * 
     */

    // controllo che esista la cartella per i log di sicurezza
    if( ! is_dir( DIR_VAR_SPOOL_SECURITY ) ) {
        mkdir( DIR_VAR_SPOOL_SECURITY, 0775, true );
    }

    // leggo l'elenco degli attacker
    $attackers = array_map( 'trim', file( FILE_BANNED_HOSTS ) );

    // blocco la richiesta se proviene da un attacker noto
    if( in_array( $_SERVER['REMOTE_ADDR'], $attackers ) ) {

        // HTTP status di risposta (forbidden)
        http_response_code( 400 );

        // output
        header( 'Content-type: text/plain' );
        die( 'sorgente bloccata' );

    }

    // lettura delle parole proibite
    $words = array_map( 'trim', file( FILE_BANNED_WORDS ) );

    // controllo che l'URL e la $_REQUEST non contengano parole proibite
    foreach( $words as $word ) {

        // controllo 
        if( stripos( urldecode( $_SERVER['REQUEST_URI'] ), urldecode( $word ) ) !== false || array_search( $word, $_REQUEST ) ) {

            // riepilogo
            $attackers[] = $_SERVER['REMOTE_ADDR'];

            // apertura file di log
            $h = fopen( DIR_VAR_SPOOL_SECURITY . $_SERVER['REMOTE_ADDR'] . '.log', 'a+' );

            // debug
            // var_dump( $h );

            // scrittura attacco
            fwrite( $h, date( 'Y-m-d H:i:s' ) . ' match per la regola URL ' . $word . PHP_EOL . 
                    'sorgente: '    . $_SERVER['REMOTE_ADDR'] . PHP_EOL .
                    'url: '         . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'] . PHP_EOL . PHP_EOL .
                    'contenuto: '   . $_SERVER['QUERY_STRING'] . PHP_EOL . PHP_EOL )
                or die( 'impossibile scrivere il file di log degli attacchi' );

            // chiusura file di log
            fclose( $h );

            // salvataggio elenco degli attacker
            $h = fopen( FILE_BANNED_HOSTS, 'a+' );
            fwrite( $h, $_SERVER['REMOTE_ADDR'] . PHP_EOL )
                or die( 'impossibile scrivere il registro degli host banditi' );
            fclose( $h );

            // HTTP status di risposta (forbidden)
            http_response_code( 400 );

            // output
            header( 'Content-type: text/plain' );
            die( 'richiesta bloccata' );

        }

    }
