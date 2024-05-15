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
	$base = $ct['site']['url'].'_mod/_4140.coupon/_src/_api/_print/';

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
        'url' => $base . '_coupon.pdf.php?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
        'icon' => NULL,
        'fa' => 'fa-file-pdf-o',
        'title' => 'stampa PDF',
        'text' => 'stampa una copia del coupon in formato PDF'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

   