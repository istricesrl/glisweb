<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     * @file
     *
     */

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumGetListaAziende( $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'Admin/' . $a . '/Enterprises/list';

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // eseguo la chiamata
        $l      = restCall( $u, METHOD_GET, NULL, MIME_APPLICATION_JSON, $s );

        // debug
         var_dump( $u );
         var_dump( $s );
         print_r( $l );

        // restituisco il risultato
        return $l;

    }

    /**
     * NOTA i parametri opzionali per la chiamata a /Enterprises/list sono:
     * 
     * {limit}: definisce il numero massimo di record da far visualizzare, può andare da 1 a 10000 oltre questo valore la chiamata è considerata incorretta (404);
     * 
     * {orderby}: definisce il criterio di ordinamento deve essere inserito il nome di un metadato (si veda servizio Metadata) seguito da = ed uno dei valori
     * tra ASC (per ordine ascendente) o DESC (per ordine discendente) ES. Data=DESC errori di formattazione portano a 404;
     * 
     * {wildcard}: parametro complementare del successivo {params} definisce il tipo di ricerca che si effettuerà sui valori di param e può assumere i seguenti valori:
     *   LEFT: significa ricerca per colonna che termina con valore immesso
     *   RIGHT: significa ricerca per colonna che incomincia con valore immesso
     *   BOTH: significa ricerca per colonna che contiene il valore immesso
     *   NONE: significa ricerca per colonna che contiene esattamente valore immesso
     * La wildcard scelta si applica a tutti i params
     * 
     * {params}: è un campo che può essere ripetuto n volte ogni volta si ripete '/colonna=valore/'* ogni istanza
     * definisce un criterio addizionale alla ricerca rendendola sempre più particolareggiata.
     * 
     */

    /**
     *
     * NOTA qui il parametro $idAzienda fa riferimento all'ID Archivium dell'azienda
     * 
     * @todo documentare
     * 
     */
    function archiviumGetDettagliAzienda( $idAzienda ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'Admin/' . $a . '/Enterprises/view/' . $idAzienda;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     *
     * NOTA il parametro $id qui fa riferimento all'ID dell'azienda nel database
     * 
     * @todo documentare
     * 
     */
    function archiviumPostInsertAzienda( $id ) {
    }

    /**
     *
     * NOTA il parametro $id qui fa riferimento all'ID dell'azienda nel database
     * mentre $idAzienda fa riferimento all'ID Archivium dell'azienda
     * 
     * @todo documentare
     * 
     */
    function archiviumPostAggiornamentoAzienda( $id, $idAzienda ) {
    }

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumGetListaFeAttive( $idAzienda, $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEAttive/' . $idAzienda . '/list';

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumGetInfoFeAttiva( $idAzienda, $idFattura, $index = 'IDArchivium'  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEAttive/' . $idAzienda . '/info/' . $idFattura . '/' . $index;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumPostInvioFeAttiva( $idAzienda, $xmlFattura, $tipo = 'XML', $mail = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEAttive/' . $idAzienda . '/Send/' . $tipo;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumGetListaFePassive( $idAzienda, $limit = NULL, $order = NULL, $wildcard = NULL, $params = NULL  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEPassive/' . $idAzienda . '/list';

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumGetInfoFePassiva( $idAzienda, $idFattura, $index = 'IDArchivium'  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEPassive/' . $idAzienda . '/info/' . $idFattura . '/' . $index;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }

    /**
     *
     * @todo documentare
     * 
     */
    function archiviumGetDownloadFePassiva( $idAzienda, $idFattura, $index = 'IDArchivium', $type = 'XML'  ) {

        // inizializzazione variabili
        $s      = NULL;

        // globalizzazione di $cf
        global $cf;

        // autenticazione per la chiamata
        $a      = $cf['archivium']['profile']['id'] . '/' . $cf['archivium']['profile']['apikey'];

        // endpoint per la chiamata
        $e      = 'ISC/' . $a . '/FEPassive/' . $idAzienda . '/Download/' . $idFattura . '/' . $index . '/' . $type;

        // URL per la chiamata
        $u      = $cf['archivium']['profile']['url'] . $e;

        // TODO fare la chiamata

        // TODO restituire il risultato

    }
