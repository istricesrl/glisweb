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
        'general' => array(
        'label' => ''
        )
    );

    if( isset( $_REQUEST[ $ct['form']['table'] ] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) ){

        switch ( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) {

            case 1:
            case 2:

                $ct['page']['contents']['metro']['general'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_fattura.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF di cortesia',
                    'text' => 'stampa una copia di cortesia della fattura in formato PDF'
                );

                $ct['page']['contents']['metro']['general'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_fattura.xml.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-code-o',
                    'title' => 'stampa XML',
                    'text' => 'stampa la fattura in formato XML'
                );

            break;

        }

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

   