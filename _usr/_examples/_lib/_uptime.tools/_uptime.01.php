<?php

    /**
     * file di esempio per le funzioni pure del controllo di uptime
     *
     * Non tocca la rete né il database, e non scrive niente:
     * - uptimeVhost() sui due file di _vhost/: un Apache con un vhost sulla 80 e uno sulla 443, un nginx con un
     *   server sulla 443 e uno sulla 80; contano solo quelli sulla 443, col primo nome;
     * - uptimeAggiorna() su tre fallimenti e un controllo riuscito: il sito passa giù al terzo e torna su al primo ok;
     * - uptimeConsenso() nei quattro casi: confermato, smentito, nessun altro server, mittente;
     * - uptimeTransizione() e uptimeDowntime() su un periodo di down di dieci minuti.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // virtual host
    $vhost = uptimeVhost( array( __DIR__ . '/_vhost/' ) );
    foreach( $vhost as $radice => $host ) {
        echo 'vhost ' . $radice . ': ' . implode( ', ', $host ) . PHP_EOL;
    }
    echo 'vhost sulla 80: ' . ( isset( $vhost['/var/www/tre/dev'] ) ? 'presente' : 'assente' ) . PHP_EOL;

    // isteresi
    $ko = array( 'sito.it' => array( 'ok' => false, 'codice' => 0, 'tempo' => 10, 'certificato' => NULL, 'errore' => 'timeout' ) );
    $ok = array( 'sito.it' => array( 'ok' => true, 'codice' => 200, 'tempo' => 0.5, 'certificato' => 60, 'errore' => '' ) );
    $stato = array();
    for( $i = 1; $i <= 3; $i++ ) {
        $stato = uptimeAggiorna( $stato, $ko, 3 );
        echo 'fallimento ' . $i . ': ' . $stato['sito.it']['locale'] . PHP_EOL;
    }
    $stato = uptimeAggiorna( $stato, $ok, 3 );
    echo 'dopo un controllo riuscito: ' . $stato['sito.it']['locale'] . ', fallimenti ' . $stato['sito.it']['fallimenti'] . PHP_EOL;

    // consenso
    $c = uptimeConsenso( 'web03', 'giu', array( 'web04' => 'giu' ) );
    echo 'giu anche per un altro: ' . $c['stato'] . ', mittente ' . var_export( $c['mittente'], true ) . PHP_EOL;
    $c = uptimeConsenso( 'web03', 'giu', array( 'web02' => 'giu' ) );
    echo 'giu anche per un altro che viene prima: ' . $c['stato'] . ', mittente ' . var_export( $c['mittente'], true ) . PHP_EOL;
    $c = uptimeConsenso( 'web03', 'giu', array( 'web02' => 'su' ) );
    echo 'su per un altro: ' . $c['stato'] . PHP_EOL;
    $c = uptimeConsenso( 'web03', 'giu', array( 'web02' => NULL ) );
    echo 'nessun altro risponde: ' . $c['stato'] . ', mittente ' . var_export( $c['mittente'], true ) . PHP_EOL;

    // un periodo di dieci minuti
    $t = mktime( 10, 0, 0, 11, 4, 2026 );
    $sito = array( 'globale' => 'su', 'errore' => 'timeout' );
    list( $sito, $inizio ) = uptimeTransizione( 'sito.it', $sito, 'giu', $t, array( 'web02', 'web03' ) );
    list( $sito, $niente ) = uptimeTransizione( 'sito.it', $sito, 'giu', $t + 60 );
    list( $sito, $fine ) = uptimeTransizione( 'sito.it', $sito, 'su', $t + 600 );
    echo 'eventi: ' . $inizio['evento'] . ', ' . var_export( $niente, true ) . ', ' . $fine['evento'] . ' dopo ' . $fine['durata'] . ' secondi' . PHP_EOL;
    $md = uptimeDowntime( array( $inizio, $fine ), array( 'sito.it' ) );
    echo 'riga del DOWNTIME.md: ' . trim( substr( $md, strpos( $md, '| 2026' ) ) ) . PHP_EOL;
    echo 'siti di altri deploy esclusi: ' . ( strpos( uptimeDowntime( array( $inizio, $fine ), array( 'altro.it' ) ), 'sito.it |' ) === false ? 'si' : 'no' ) . PHP_EOL;
