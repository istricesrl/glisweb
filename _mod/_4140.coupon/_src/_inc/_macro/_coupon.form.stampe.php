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
    $ct['form']['table'] = 'coupon';

    // percorsi
	$base = $ct['site']['url'].'print/4140.coupon/';

    $ct['page']['contents']['metros'] = array(
        'pdf' => array(
            'label' => 'stampe PDF'
        ),
        'xml' => array(
            'label' => 'stampe XML'
        )
    );

    $ct['page']['contents']['metro']['pdf'][] = array(
        'target' => '_blank' ,
        'url' => $base . 'coupon.pdf?__id__='.$_REQUEST[ $ct['form']['table'] ]['id'],
        'icon' => NULL,
        'fa' => 'fa-file-pdf-o',
        'title' => 'stampa PDF',
        'text' => 'stampa una copia del coupon in formato PDF'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

   