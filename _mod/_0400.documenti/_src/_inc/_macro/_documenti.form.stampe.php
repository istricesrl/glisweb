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
	$base = $ct['site']['url'].'_mod/_0400.documenti/_src/_api/_print/';

    $ct['page']['contents']['metros'] = array(
        'pdf' => array(
        'label' => 'stampe PDF'
        ),
        'xml' => array(
            'label' => 'stampe XML'
        )
    );

    if( isset( $_REQUEST[ $ct['form']['table'] ] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) ){

        switch ( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) {

            case 1:
            case 2:

                $ct['page']['contents']['metro']['pdf'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_fattura.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa una copia di cortesia della fattura in formato PDF'
                );

                if( ! empty( $_REQUEST[ $ct['form']['table'] ]['progressivo_invio'] ) ) {
                    $ct['page']['contents']['metro']['xml'][] = array(
                        'target' => '_blank' ,
                        'url' => $base . '_fattura.xml.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
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
                    'url' => $base . '_ddt.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa una copia di cortesia del DDT in formato PDF'
                );


            break;

            case 5:

                $ct['page']['contents']['metro']['pdf'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_proforma.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa una copia di cortesia della proforma in formato PDF'
                );

            break;
        }

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

   