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
	// $base = $ct['site']['url'].'_mod/_0400.documenti/_src/_api/_print/';
	$base = $ct['site']['url'].'print/0400.documenti/';

    $ct['page']['contents']['metros'] = array(
        'pdf' => array(
        'label' => 'stampe PDF'
        ),
        'xml' => array(
            'label' => 'stampe XML'
        )
    );

    if( isset( $_REQUEST[ $ct['form']['table'] ] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) ){

        // TODO fare lo switch sui flag della tabella tipologie_documenti e non sull'ID?
        switch ( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) {

            case 1:
            case 2:

                $ct['page']['contents']['metro']['pdf'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . 'fattura.pdf?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa una copia di cortesia della fattura in formato PDF'
                );

                if( ! empty( $_REQUEST[ $ct['form']['table'] ]['progressivo_invio'] ) ) {
                    $ct['page']['contents']['metro']['xml'][] = array(
                        'target' => '_blank' ,
                        'url' => $base . 'fattura.xml?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                        'icon' => NULL,
                        'fa' => 'fa-file-code-o',
                        'title' => 'stampa XML',
                        'text' => 'stampa la fattura in formato XML'
                    );
                }

            break;

            case 4:

                $ct['page']['contents']['metro']['pdf'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . 'ddt.pdf?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa una copia di cortesia del DDT in formato PDF'
                );


            break;

            case 5:

                $ct['page']['contents']['metro']['pdf'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . 'proforma.pdf?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa una copia di cortesia della proforma in formato PDF'
                );

            break;

            case 8:

                $ct['page']['contents']['metro']['pdf'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . 'ricevuta.pdf?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa la ricevuta in formato PDF'
                );


            break;

        }

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

   