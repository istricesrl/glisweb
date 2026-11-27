<?php

    /**
     * esempio di twigPulisci()
     *
     * L'output è controllato da _usr/_test/_tests/unit/twigToolsCest.php: i segnaposto puri devono restare intatti e
     * venire risolti, mentre filtri, blocchi, commenti e graffe in più devono arrivare a Twig come testo; fino al
     * 14/10/2026 un destinatario di queueMailFromTemplate() scritto così eseguiva codice sul server.
     *
     */

    require '../../../../_src/_config.php';

    // pulizia
    var_dump( twigPulisci( '{{ dt.nome }} {{ dt.cognome }}', true ) );
    var_dump( twigPulisci( "{{['id']|map('system')|join}}", true ) );
    var_dump( twigPulisci( '{{{ dt.nome }}', true ) );
    var_dump( twigPulisci( '{% set x = 1 %}{# nota #}{{ dt.nome }}' ) );

    // |raw su un segnaposto puro resta valido, ogni altro filtro dopo di lui no
    var_dump( twigPulisci( '{{ dt.nome|raw }} {{dt.email | raw}}', true ) );
    var_dump( twigPulisci( "{{ dt.nome|raw|map('system') }}", true ) );
    var_dump( twigPulisci( '{{ dt.nome|rawx }}', true ) );

    // compilazione come in queueMailFromTemplate(): il segnaposto si risolve, il resto resta testo
    $tm = array( 'nome' => twigPulisci( '{{ dt.nome }} {{ 7*7 }}', true ) );
    $tw = new \Twig\Environment( new \Twig\Loader\ArrayLoader( $tm ), array( 'cache' => false ) );
    var_dump( $tw->render( 'nome', array( 'dt' => array( 'nome' => 'Pinco {{ 7*7 }}' ) ) ) );

    // con |raw l'apostrofo resta un apostrofo, senza diventerebbe &#039;
    $tm = array( 'nome' => twigPulisci( '{{ dt.nome|raw }} {{ dt.email|raw }}', true ) );
    $tw = new \Twig\Environment( new \Twig\Loader\ArrayLoader( $tm ), array( 'cache' => false ) );
    var_dump( $tw->render( 'nome', array( 'dt' => array( 'nome' => "D'Amico", 'email' => "o'brien@gimbe.it" ) ) ) );
