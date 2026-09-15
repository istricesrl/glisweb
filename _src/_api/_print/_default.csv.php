<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */


    // inclusione del framework
    require '../../_config.php';

    // inclusione di PHPExcel
    // use PhpOffice\PhpSpreadsheet\Spreadsheet;
    // use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

    // debug
    // die( 'contenuto: '.print_r( $_REQUEST, true ) );

    /**
     * Controllo autorizzazioni
     * ========================
     *
     * Fix 2026-09-15, insieme a `_anagrafica.csv.php` e `_indirizzario.csv.php`: stesso segnaposto
     * `if( true )`, ma qui la situazione e' diversa e la cura e' piu' leggera.
     *
     * Questo e' l'export **generico**: prende una tabella in `?t=` e uno stato di vista in `?v=`,
     * e il lavoro lo fa `controller()` in METHOD_GET — che applica l'ACL per tabella. Provato da
     * anonimo su un deploy reale, `?t=anagrafica` rispondeva gia' "nessun risultato per la ricerca
     * effettuata": l'ACL c'era e teneva. Quello che mancava era il gradino prima, cioe' pretendere
     * che ci sia **qualcuno** collegato.
     *
     * `checkTaskPrivilege()` **senza argomento** e' esattamente questo: `getPrivilege( NULL )`
     * ritorna vero appena esistono dei gruppi in sessione ( "senza privilegio richiesto e'
     * sufficiente essere autenticati" ). Chiedere qui un privilegio per area sarebbe sbagliato:
     * questo endpoint serve QUALSIASI griglia, e il diritto giusto e' gia' quello che l'ACL
     * associa alla tabella richiesta — sovrapporne un secondo taglierebbe fuori esportazioni
     * legittime senza aggiungere nulla.
     */
    checkTaskPrivilege();

    if( true ) {

        $error = array();

        $view = ( isset( $_REQUEST['v'] ) ) ? json_decode( $_REQUEST['v'], true ) : array();

        $view['__pager__'] = NULL;

        if( isset( $ct['view']['__restrict__'] ) ) {
            $_REQUEST['__view__'][ $ct['view']['id'] ]['__restrict__'] = $ct['view']['__restrict__'];
        }

        $data = array();

        if( isset( $view['__report_mode__'] ) ) {
            $data['__report_mode__'] = $view['__report_mode__'];
        }

        controller(
            $cf['mysql']['connection'],
            $cf['memcache']['connection'],
            $data,
            $_REQUEST['t'],
            METHOD_GET,
            NULL,
            $error,
            $view
        );

        // debug
        // die( print_r( $view, true ) );

        if( ! empty( $data ) ) {

            $csv[0] = array_keys( $data[0] );

            // die(print_r($data ) );

            header('Content-Type: text/csv');
            header('Content-Disposition: attachment; filename="'.$_REQUEST['t'].'.csv"');

                $csv = array_merge( $csv, $data );

            $fp = fopen('php://output', 'wb');
            foreach ($csv as $line) {fputcsv($fp, $line, ';');}
            fclose($fp);

        } else {
            
            buildText( 'nessun risultato per la ricerca effettuata' );
        
        }

    } else {

        // errore
        buildText( 'non autorizzato' );

    }
