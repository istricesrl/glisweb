<?php

    /**
     * task di aggiornamento della anagrafica_view_static
     * 
     * Questo task aggiorna la tabella anagrafica_view_static in base al contenuto della tabella anagrafica
     * e delle tabelle collegate
     * 
     * introduzione
     * ============
     * La tabella anagrafica è fra le tabelle che in molti scenari tendono a riempirsi con un volume considerevole
     * di dati; per questo beneficia di una vista statica. Questo rende le operazioni di lettura molto più veloci,
     * ma richiede un sistema di aggiornamento della vista statica. Questo task si occupa proprio di questo, e può essere
     * chiamato in modalità standard, in cui decide lui quale anagrafica aggiornare, oppure in modalità forzata,
     * in cui viene passato l'ID dell'anagrafica da aggiornare.
     * 
     * la funzione updateAnagraficaViewStatic()
     * ----------------------------------------
     * La chiave del sistema di aggiornamento è la funzione updateAnagraficaViewStatic(); questo task serve soprattutto
     * a determinare quale anagrafica aggiornare, ma è la funzione updateAnagraficaViewStatic() che si occupa di
     * effettuare l'aggiornamento vero e proprio. Per maggiori dettagli su questa funzione, si rimanda alla sua documentazione.
     * 
     * modalità di utilizzo del task
     * -----------------------------
     * Questo task può essere chiamato in vari modi; se viene chiamato senza parametri, decide lui quale anagrafica aggiornare,
     * verificando la tabella anagrafica e le tabelle collegate; se viene chiamato con il parametro idAnagrafica, aggiorna l'anagrafica
     * specificata.
     * 
     * La chiamata standard è /task/AN000.anagrafica/anagrafica.view.static.popolazione mentre la chiamata forzata è
     * /task/AN000.anagrafica/anagrafica.view.static.popolazione?idAnagrafica=<idAnagrafica>
     * 
     * TODO implementare un sistema di controllo dei permessi
     * 
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // inizializzo l'array del risultato
    $status = array();

    // ...
    if( ! isset( $_REQUEST['id'] ) ) {

        // trovo una riga da aggiornare
        $status['aggiornare'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT anagrafica.id FROM anagrafica 
            LEFT JOIN anagrafica_view_static ON anagrafica_view_static.id = anagrafica.id
            WHERE
                ( anagrafica_view_static.timestamp_inserimento IS NULL 
                    OR 
                    anagrafica.timestamp_inserimento > anagrafica_view_static.timestamp_inserimento )
                OR
                ( anagrafica_view_static.timestamp_aggiornamento IS NULL 
                    OR 
                    anagrafica.timestamp_aggiornamento > anagrafica_view_static.timestamp_aggiornamento )
            ORDER BY anagrafica.id DESC
            LIMIT 1'
        );

        // verifico le tabelle collegate
        if( empty( $status['aggiornare'] ) ) {

            // ...
            $aggiornare = array();

            // tabelle collegate
            foreach( array( 'anagrafica_categorie' ) as $table ) {

                // trovo una riga da aggiornare
                $aggiornare[] = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT ' . $table . '.id_anagrafica 
                    FROM ' . $table . ' 
                    INNER JOIN anagrafica ON anagrafica.id = ' . $table . '.id_anagrafica
                    LEFT JOIN anagrafica_view_static ON anagrafica_view_static.id = ' . $table . '.id_anagrafica
                    WHERE ( coalesce( ' . $table . '.timestamp_aggiornamento, ' . $table . '.timestamp_inserimento, 0 ) > anagrafica_view_static.timestamp_aggiornamento 
                    OR anagrafica_view_static.timestamp_aggiornamento IS NULL )
                    LIMIT 1'
                );

            }

            // status
            $status['aggiornare']['id'] = max( $aggiornare );
            $status['modalita'] = 'categorie';

        } else {

            // status
            $status['modalita'] = 'standard';

        }

    } elseif( isset( $_REQUEST['id'] ) ) {

        // scrivo la riga
        $status['aggiornare']['id'] = $_REQUEST['id'];
        $status['modalita'] = 'forzata';
        $status['done'] = true;

    }

    // ...
    if( ! empty( $status['aggiornare']['id'] ) ) {
        updateAnagraficaViewStatic(
            $status['aggiornare']['id']
        );
    }

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
