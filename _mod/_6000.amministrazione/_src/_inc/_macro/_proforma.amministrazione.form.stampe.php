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
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['form']['table'] = 'documenti';

    // percorsi
	$base = $ct['site']['url'].'_mod/_6200.documenti/_src/_api/_print/';

    $ct['page']['contents']['metros'] = array(
        'pdf' => array(
        'label' => 'stampe PDF'
        ),
        'xml' => array(
            'label' => 'stampe XML'
        )
    );

    if(file_exists(DIR_BASE.'mod/6200.documenti/src/api/print/proforma.pdf.php')  ){$file = $ct['site']['url'].'mod/6200.documenti/src/api/print/';}
    else {$file =$ct['site']['url'].'_mod/_6200.documenti/_src/_api/_print/_';  }

    if( isset( $_REQUEST[ $ct['form']['table'] ] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) ){

        switch ( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ){
            case 5:

                $ct['page']['contents']['metro']['pdf'][] = array(
                    'target' => '_blank' ,
                    'url' => $file . 'proforma.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa una copia di cortesia della proforma in formato PDF'
                );

            break;
/*
            case 10:
                $ct['page']['contents']['metro']['general'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_ritiro.hardware.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa modulo ritiro',
                    'text' => 'stampa il modulo di ritiro hardware da far firmare al cliente'
                ); 

                $ct['page']['contents']['metro']['general'][] = array(
                    'modal' => array( 'id' => 'stampa_etichette', 'include' => 'inc/ritiro.hardware.modal.html',  'onclick' => '$( "#id_doc" ).val('.$_REQUEST[ $ct['form']['table'] ]['id'].');' ),
                    'icon' => NULL,  'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa etichette di ritiro',
                    'text' => 'stampa le etichette di ritiro '
                ); 
            break;

            case 11:
                $ct['page']['contents']['metro']['general'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_ritiro.hardware.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa modulo consegna',
                    'text' => 'stampa il modulo di consegna hardware da far firmare al cliente'
                ); 
            break;
*/

        }


    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

   