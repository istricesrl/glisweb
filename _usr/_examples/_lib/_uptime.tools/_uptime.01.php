<?php

    /**
     * file di esempio per le funzioni pure del controllo di uptime
     *
     * Non tocca il database e non scrive niente; l'unica rete è la domanda al DNS di uptimePubblico():
     * - uptimePubblico() su un IP pubblico e uno privato, che non interrogano il DNS, e su localhost e un dominio
     *   .invalid, che il DNS non risolve;
     * - uptimeProfilo() con un sito che ha DEV e PROD e uno con un profilo PRODWMS, come su bernispa, e sui siti
     *   veri del deploy, dove deve dare all'host della richiesta lo stesso SITE_STATUS del bootstrap;
     * - uptimeEsterni() con un sito esterno completo e uno senza url;
     * - uptimeImpronta() sulla stessa sezione esterni: con le chiavi in un altro ordine, e su una diversa;
     * - uptimeVhost() sui due file di _vhost/: un Apache con un vhost sulla 80 e uno sulla 443, un nginx con un
     *   server sulla 443 e uno sulla 80; contano solo quelli sulla 443, col primo nome;
     * - uptimeAggiorna() su tre fallimenti e un controllo riuscito: il sito passa giù al terzo e torna su al primo ok;
     *   e su risposte lente: una prova lenta a freddo non conta, tre di fila sì, e la soglia vale per sito;
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

    // host pubblici
    foreach( array( '35.195.114.10', '10.0.0.1', 'localhost', 'nessuno.invalid' ) as $h ) {
        echo 'pubblico ' . $h . ': ' . var_export( uptimePubblico( $h ), true ) . PHP_EOL;
    }

    // profili: la stessa regola di _src/_config/_015.site.php
    $sites = array(
        1 => array( 'domains' => array( 'DEV' => 'istricesrl.it', 'PROD' => 'esempio.it' ), 'hosts' => array( 'DEV' => 'esempio', 'PROD' => 'www' ) ),
        2 => array( 'domains' => array( 'PRODWMS' => 'interno.esempio.it' ), 'hosts' => array( 'PRODWMS' => 'magazzino' ) )
    );
    foreach( array( 'esempio.istricesrl.it', 'www.esempio.it', 'esempio.it', 'magazzino.interno.esempio.it', 'altro.it' ) as $h ) {
        echo 'profilo ' . $h . ': ' . var_export( uptimeProfilo( $h, $sites ), true ) . PHP_EOL;
    }

    // la regola di uptimeProfilo() e quella di _015.site.php sono una: sull'host della richiesta danno lo stesso stato
    echo 'profilo come il bootstrap: ' . var_export( uptimeProfilo( $_SERVER['HTTP_HOST'], $cf['sites'] ) === SITE_STATUS, true ) . PHP_EOL;

    // siti esterni: codice 200, nessun testo se non lo si chiede, nessun deploy; senza url si scartano
    $esterni = uptimeEsterni( array( 'www.esterno.it' => array( 'url' => 'https://www.esterno.it/', 'lento' => 5, 'avvisa' => array( 'abilitato' => true ) ), 'senzaurl.it' => array() ) );
    echo 'esterni: ' . implode( ', ', array_keys( $esterni ) ) . PHP_EOL;
    echo 'esterno: codice ' . $esterni['www.esterno.it']['codice'] . ', testo ' . var_export( $esterni['www.esterno.it']['testo'], true ) . ', lento ' . $esterni['www.esterno.it']['lento'] . ', soglia ' . $esterni['www.esterno.it']['soglia'] . ', deploy ' . var_export( $esterni['www.esterno.it']['deploy'], true ) . PHP_EOL;

    // impronta degli esterni: l'ordine delle chiavi non conta, un valore diverso sì
    $a = uptimeImpronta( array( 'a.it' => array( 'url' => 'https://a.it/', 'lento' => 5 ), 'b.it' => array( 'url' => 'https://b.it/' ) ) );
    $b = uptimeImpronta( array( 'b.it' => array( 'url' => 'https://b.it/' ), 'a.it' => array( 'lento' => 5, 'url' => 'https://a.it/' ) ) );
    $c = uptimeImpronta( array( 'a.it' => array( 'url' => 'https://a.it/', 'lento' => 6 ), 'b.it' => array( 'url' => 'https://b.it/' ) ) );
    echo 'impronta riordinata: ' . var_export( $a === $b, true ) . ', impronta diversa: ' . var_export( $a !== $c, true ) . PHP_EOL;

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

    // lentezza: conta solo dopo tre giri di fila oltre la soglia del sito
    $adagio = array( 'sito.it' => array( 'ok' => true, 'codice' => 200, 'tempo' => 6.5, 'certificato' => 60, 'errore' => '' ) );
    $stato = uptimeAggiorna( array(), $adagio, 3, array( 'sito.it' => 3 ) );
    $stato = uptimeAggiorna( $stato, $ok, 3, array( 'sito.it' => 3 ) );
    echo 'lento a freddo e poi veloce: ' . var_export( $stato['sito.it']['lento'], true ) . PHP_EOL;
    for( $i = 1; $i <= 3; $i++ ) {
        $stato = uptimeAggiorna( $stato, $adagio, 3, array( 'sito.it' => 3 ) );
        echo 'giro lento ' . $i . ': ' . var_export( $stato['sito.it']['lento'], true ) . PHP_EOL;
    }
    echo 'soglia del sito a 10 secondi: ' . var_export( uptimeAggiorna( $stato, $adagio, 3, array( 'sito.it' => 10 ) )['sito.it']['lento'], true ) . PHP_EOL;

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
