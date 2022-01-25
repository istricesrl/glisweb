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
        'anteprima' => array(
        'label' => 'anteprima'
        ),
        'download' => array(
            'label' => 'download'
        )
    );

    if( isset( $_REQUEST[ $ct['form']['table'] ] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) ){

        switch ( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) {

            case 1:
            case 2:

                $ct['page']['contents']['metro']['anteprima'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_fattura.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa una copia di cortesia della fattura in formato PDF'
                );

                $ct['page']['contents']['metro']['anteprima'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_fattura.xml.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-code-o',
                    'title' => 'stampa XML',
                    'text' => 'stampa la fattura in formato XML'
                );

                $ct['page']['contents']['metro']['download'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_fattura.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'].'&d=1',
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF',
                    'text' => 'stampa una copia di cortesia della fattura in formato PDF'
                );

                $ct['page']['contents']['metro']['download'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_fattura.xml.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'].'&d=1',
                    'icon' => NULL,
                    'fa' => 'fa-file-code-o',
                    'title' => 'stampa XML',
                    'text' => 'stampa la fattura in formato XML'
                );

            break;

            case 5:

                $ct['page']['contents']['metro']['anteprima'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . '_fattura.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
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

   