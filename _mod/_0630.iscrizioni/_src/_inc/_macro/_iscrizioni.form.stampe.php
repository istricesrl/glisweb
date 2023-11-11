<?php

    /**
     * macro form progetti produzione tools
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'contratti';

    // base di chiamata dei WS
    $base = '/task/0630.iscrizioni/';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        'general' => array(
        'label' => NULL
        )
    );

    // ...
    if( true ) {
        $ct['page']['contents']['metro']['general'][] = array(
            'target' => '_blank' ,
            'url' => 'print/4140.coupon/coupon.rimborso.iscrizione?id='.$_REQUEST[ $ct['form']['table'] ]['id'] ,
            'icon' => NULL,
            'fa' => 'fa-file-pdf-o',
            'title' => 'coupon rimborso',
            'text' => 'stampa il coupon relativo al rimborso per il ritiro'
        );
    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

