<?php

    /**
     * file di esempio per la funzione mysqlPing()
     *
     * Mostra l'esito su una connessione viva, su nessuna connessione, su una connessione chiusa e su una connessione
     * fatta cadere dal server ( KILL da un'altra connessione, come la chiude il wait_timeout ); poi fa cadere quella del
     * framework e la ricrea come fa il cron, rileggendo _src/_config/_125.mysql.php.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // apre una seconda connessione allo stesso server del framework
    function connessioneDiProva( $s ) {
        $k = mysqli_init();
        mysqli_real_connect( $k, $s['address'], $s['username'], $s['password'], $s['db'], ( ( ! empty( $s['port'] ) ) ? (int) $s['port'] : NULL ) );
        return $k;
    }

    // connessione viva
    echo 'viva: ' . var_export( mysqlPing( $cf['mysql']['connection'] ), true ) . PHP_EOL;

    // nessuna connessione
    echo 'assente: ' . var_export( mysqlPing( NULL ), true ) . PHP_EOL;

    // connessione chiusa
    $k = connessioneDiProva( $cf['mysql']['server'] );
    mysqli_close( $k );
    echo 'chiusa: ' . var_export( mysqlPing( $k ), true ) . PHP_EOL;

    // connessione fatta cadere dal server
    $k = connessioneDiProva( $cf['mysql']['server'] );
    mysqli_query( $cf['mysql']['connection'], 'KILL CONNECTION ' . (int) mysqli_thread_id( $k ) );
    echo 'caduta: ' . var_export( mysqlPing( $k ), true ) . PHP_EOL;

    // cade la connessione del framework e il cron la ricrea
    $k = connessioneDiProva( $cf['mysql']['server'] );
    mysqli_query( $k, 'KILL CONNECTION ' . (int) mysqli_thread_id( $cf['mysql']['connection'] ) );
    mysqli_close( $k );
    echo 'framework caduta: ' . var_export( mysqlPing( $cf['mysql']['connection'] ), true ) . PHP_EOL;
    require DIR_SRC_CONFIG . '_125.mysql.php';
    echo 'framework ricreata: ' . var_export( mysqlPing( $cf['mysql']['connection'] ), true ) . PHP_EOL;
