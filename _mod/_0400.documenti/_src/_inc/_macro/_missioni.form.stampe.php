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

    if( file_exists(DIR_MOD.'4100.prodotti/src/api/print/barcode.pdf.php')  ) {
        $file_barcode =  $cf['site']['url'].'4100.prodotti/src/api/print/barcode.pdf.php';
    } else {
        $file_barcode = $cf['site']['url'].'_mod/_4100.prodotti/_src/_api/_print/_barcode.pdf.php';
    }

    $ct['page']['contents']['metro']['pdf'][] = array(
        'target' => '_blank' ,
        'url' => '/print/0400.documenti/barcode.missione.pdf?missione='.$_REQUEST[ $ct['form']['table'] ]['id'] ,
        'icon' => NULL,
        'fa' => 'fa-file-pdf-o',
        'title' => 'barcode semplice',
        'text' => 'stampa il barcode della missione in PDF'
    );

    $ct['page']['contents']['metro']['pdf'][] = array(
        'target' => '_blank' ,
        'url' => '/print/0400.documenti/copertina.missione.pdf?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'] ,
        'icon' => NULL,
        'fa' => 'fa-file-pdf-o',
        'title' => 'copertina missione',
        'text' => 'stampa la copertina della missione in PDF'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
