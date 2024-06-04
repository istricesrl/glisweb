<?php

    /**
     *
     *
     *
     * il file FILE_REDIRECT
     * ---------------------
     * Questo file contiene i redirect da effettuare. Il formato è CSV con le seguenti colonne:
     * 
     * colonna              | significat                                                | esempio
     * ---------------------|-----------------------------------------------------------|------------------------
     * id_sito              | l'ID del sito a cui appartiene il redirect                | 1
     * codice_stato_http    | il codice HTTP da lanciare assieme al reindirizzamento    | 301
     * sorgente             | la pagina da cui parte il reindirizzamento                | /vecchia/pagina.html
     * destinazione         | la pagina verso cui si effettua il reindirizzamento       | http://host.domain.bogus/nuova/pagina.html
     *
     * NOTA il file dei redirect deve contenere anche le intestazioni, ad esempio:
     * 
     *  id_sito,codice_stato_http,sorgente,destinazione
     *  1,301,/vecchia/pagina.html,http://host.domain.bogus/nuova/pagina.html
     * 
     *
     * TODO $cf['redirect'] dovrebbe stare in cache, visto che elaborarlo può essere oneroso se i redirect sono tanti
     * TODO documentare
     *
     *
     */

    // debug
    // var_dump( FILE_REDIRECT );
    // die( __FILE__ );

    // inizializzazione array redirect
    $cf['redirect'] = array();

    // redirect da CSV
    if( file_exists( FILE_REDIRECT ) ) {
        $cf['redirect']['src']['csv'] = csvFile2array( FILE_REDIRECT );
    }

    // debug
    // var_dump( $cf['redirect'] );

    // redirect da CMS
    if( ! empty( $cf['mysql']['connection'] ) ) {
        $cf['redirect']['src']['db'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT id,id_sito,codice_stato_http,sorgente,destinazione FROM redirect_view'
        );
    }

    // debug
    // var_dump( $cf['redirect'] );
    // var_dump( strtok( $_SERVER['REQUEST_URI'], '?' ) );
    // var_dump( mysqlQuery( $cf['mysql']['connection'], 'SELECT codice_stato_http,sorgente,destinazione FROM redirect_view' ) );
