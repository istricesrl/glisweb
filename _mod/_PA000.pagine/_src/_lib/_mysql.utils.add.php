<?php

    /**
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    /**
     *
     * TODO documentare
     * 
     */
    function tendinaTipologiePubblicazioni() {

        global $cf;

        return mysqlCachedQuery(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
        );

    }

