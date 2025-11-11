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
    function tendinaTipologieNotizie() {

        global $cf;

        return mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_notizie_view ORDER BY __label__'
        );

    }

    /**
     * 
     *  TODO documentare
     * 
     * 
     */
    function tendinaCategorieNotizie() {

        global $cf;

        return mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM categorie_notizie_view ORDER BY __label__'
        );

    }
