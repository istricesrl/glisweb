<?php

    /**
     * test delle cache
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // esempio di contenuto del JWT
    $a = array(
        'id' => '1',
        'user' => 'test'
    );

    $t = getJwt( $a, 'testSecret' );

    var_dump( $t );

    var_dump( checkJwt( $t, 'testSecret' ) );
