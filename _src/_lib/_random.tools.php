<?php

    /**
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function getToken() {

	    return md5( microtime( true ) * random_int( 0, 10000 ) );

    }
