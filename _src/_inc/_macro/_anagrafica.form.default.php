<?php

    // die('TEST');
    // print_r( $_REQUEST );
    // print_r( $ct['page']['etc']['tabs'] );

    $seCliente = ( empty( $_REQUEST['anagrafica']['se_cliente'] ) )                 ? false : true;
    $seLead = ( empty( $_REQUEST['anagrafica']['se_lead'] ) )                       ? false : true;
    $seProspect = ( empty( $_REQUEST['anagrafica']['se_prospect'] ) )               ? false : true;
    $seFornitore = ( empty( $_REQUEST['anagrafica']['se_fornitore'] ) )             ? false : true;
    $seDipendente = ( empty( $_REQUEST['anagrafica']['se_dipendente'] ) )           ? false : true;
    $seInterinale = ( empty( $_REQUEST['anagrafica']['se_interinale'] ) )           ? false : true;
    $seCollaboratore = ( empty( $_REQUEST['anagrafica']['se_collaboratore'] ) )     ? false : true;
    $seGestita = ( empty( $_REQUEST['anagrafica']['se_gestita'] ) )                 ? false : true;

    if( max( [ $seCliente, $seLead, $seProspect ] ) != true ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['anagrafica.form.cliente','anagrafica.form.offerte']
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

    // print_r( $ct['page']['etc']['tabs'] );
