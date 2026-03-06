<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     */

    /**
     * 
     * TODO documentare 
     * 
     */
    function tendinaTipologieVeicoli() {

        global $cf;

        return mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_veicoli_view ORDER BY __label__'
        );

    }

