<?php

    // lingua di questo file
    $l = 'en-GB';

    // sblocco dell'accesso sospeso dal firewall applicativo ( _src/_inc/_macro/_security.php )
    $p['security.sblocco'] = array(
        'sitemap'        => false,
        'title'        => array( $l        => 'unlock access' ),
        'h1'        => array( $l        => 'unlock access' ),
        'parent'        => array( 'id'        => NULL ),
        'template'        => array( 'path'    => '_src/_tpl/_athena/', 'schema' => 'security.sblocco.twig' ),
        'macro'        => array( '_src/_inc/_macro/_security.sblocco.php' )
    );

    // debug
    // die();
