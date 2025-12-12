<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * TODO finire di implementare
     * 
     */

    // die('TEST');
    // print_r( $_REQUEST );
    // print_r( $ct['page']['etc']['tabs'] );

    /**
     * disattivazione delle tab in base alle categorie dell'anagrafica
     * ===============================================================
     * 
     * 
     * 
     */

    $seCliente = ( empty( $_REQUEST['anagrafica']['se_cliente'] ) )                 ? false : true;
    $seLead = ( empty( $_REQUEST['anagrafica']['se_lead'] ) )                       ? false : true;
    $seProspect = ( empty( $_REQUEST['anagrafica']['se_prospect'] ) )               ? false : true;
    $seFornitore = ( empty( $_REQUEST['anagrafica']['se_fornitore'] ) )             ? false : true;
    $seDipendente = ( empty( $_REQUEST['anagrafica']['se_dipendente'] ) )           ? false : true;
    $seInterinale = ( empty( $_REQUEST['anagrafica']['se_interinale'] ) )           ? false : true;
    $seCollaboratore = ( empty( $_REQUEST['anagrafica']['se_collaboratore'] ) )     ? false : true;
    $seProduttore = ( empty( $_REQUEST['anagrafica']['se_produttore'] ) )           ? false : true;
    $seGestita = ( empty( $_REQUEST['anagrafica']['se_gestita'] ) )                 ? false : true;

    if( max( [ $seCliente, $seLead, $seProspect ] ) != true ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['anagrafica.form.cliente','anagrafica.form.offerte','anagrafica.form.licenze']
        );
    }

    if( max( [ $seGestita ] ) != true ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['anagrafica.form.amministrazione']
        );
    }

    if( max( [ $seDipendente, $seCollaboratore, $seInterinale ] ) != true ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['anagrafica.form.collaboratore']
        );
    }

    if( max( [ $seFornitore ] ) != true ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['anagrafica.form.fornitore']
        );
    }

    if( max( [ $seDipendente, $seCollaboratore, $seInterinale, $seCliente, $seFornitore ] ) != true ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['anagrafica.form.contratti']
        );
    }

    if( max( [ $seProduttore ] ) != true ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['anagrafica.form.produttore']
        );
    }

    // print_r( $ct['page']['etc']['tabs'] );

    /**
     * disattivazione delle tab in base ai moduli attivi
     * =================================================
     * 
     * 
     * 
     * 
     */

    if( ! in_array( "AT000.attivita", $cf['mods']['active']['array'] ) ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['anagrafica.form.attivita']
        );
    }
