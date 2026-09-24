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
    function tendinaTipologieListini() {

        global $cf;

        return mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_listini_view ORDER BY __label__'
        );

    }

