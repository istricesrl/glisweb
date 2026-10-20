<?php

    /**
     * pagina di errore 403, che porta al firewall applicativo le richieste respinte da Apache
     *
     * È l'ErrorDocument 403 del .htaccess: ModSecurity e i blocchi del .htaccess ( .git/, FilesMatch, le cartelle
     * vietate ) respingono la richiesta prima di PHP, e senza questa pagina il firewall applicativo non la vedrebbe mai.
     * Il framework si ferma al firewall ( _src/_inc/_macro/_security.php ), che risponde 403 e lascia i punti a
     * securityOutcome(): la richiesta originale è in REQUEST_URI, e REDIRECT_STATUS dice che è un 403.
     *
     * Se questa pagina rispondesse a sua volta 403 non c'è ciclo: Apache non rientra nell'ErrorDocument e manda la sua
     * pagina predefinita.
     *
     */

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // chiamata diretta, senza un 403 di Apache dietro
    http_response_code( 404 );
