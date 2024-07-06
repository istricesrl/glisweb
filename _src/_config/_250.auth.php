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
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // array dei permessi
    $cf['auth']['permissions'] = array(
        'account' => array(
            CONTROL_FULL            => array( 'roots' )
        ),
        'account_gruppi' => array(
            CONTROL_FULL            => array( 'roots' )
        ),
        'account_gruppi_attribuzione' => array(
            CONTROL_FULL            => array( 'roots' )
        ),

        // TODO commenti MySQL OK fin qui

        'anagrafica' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'anagrafica_categorie' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'anagrafica_cittadinanze' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'anagrafica_indirizzi' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'anagrafica_settori' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'badge' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'relazioni_anagrafica' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'audio' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'categorie_anagrafica' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'comuni' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff', 'users', 'guests' )
        ),
        'stati' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff', 'users', 'guests' )
        ),
        'contenuti' => array(
            CONTROL_FULL => array( 'roots' ,'staff'),
        ),
        'file' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'gruppi' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'iban' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'immagini' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'indirizzi' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'indirizzi_caratteristiche' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'job' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )    
        ),
        'luoghi' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'mail' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'mail_out' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'mail_sent' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'metadati' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'periodi' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'orari' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'redirect' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'sms_out' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'sms_sent' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'task' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'telefoni' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'template' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'zone_indirizzi' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'tipologie_luoghi' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'tipologie_periodi' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'tipologie_zone' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'ranking' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'reparti' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'url' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'video' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'zone' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'zone_stati' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_documenti_carrelli__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED        => array( 'staff' )
        ),
        '__report_variazioni_anagrafica__' => array(
            CONTROL_FULL => array( 'roots','staff' )
        )
    );
 