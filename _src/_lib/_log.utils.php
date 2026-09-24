<?php

    /**
     * libreria per la retrocompatibilità con il vecchio sistema di log
     *
     * Questa libreria è inserita solo per garantire la retrocompatibilità con il vecchio sistema di log del framework.
     *
     * TODO documentare
     *
     */

    // logWrite() -> logger()
    function logWrite( $m, $f = 'site', $l = LOG_DEBUG, $d = DIR_VAR_LOG, $t = LOG_CURRENT_LEVEL, $s = SITE_STATUS ) {
        logger( $m, $f, $l );
    }
        
    // logMsg() -> logger()
    function logMsg( $m, &$o = NULL, &$a = array(), &$t = NULL ) {
        logger( $m, 'deprecated' );
    }
