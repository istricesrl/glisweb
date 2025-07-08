<?php

    /**
     * macro form abbonamenti stampe
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

    // ...
    $ct['page']['contents']['metros'] = array(
        'pdf' => array(
            'label' => 'stampe PDF'
        ),
        'xml' => array(
            'label' => 'stampe XML'
        )
    );

    // TODO se è attivo il modulo coupon
    if( true ) {

        // cerco i coupon associati a questo abbonamento
        $coupon = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM coupon WHERE causale_id_contratto = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );

        // ...
        if( ! empty( $coupon ) ) {

            // percorsi
            $base = $ct['site']['url'].'print/4140.coupon/';

            // ...
            foreach( $coupon as $cpn ) {

                // ...
                $ct['page']['contents']['metro']['pdf'][] = array(
                    'target' => '_blank' ,
                    'url' => $base . 'coupon.pdf?__id__='.$cpn['id'],
                    'icon' => NULL,
                    'fa' => 'fa-file-pdf-o',
                    'title' => 'stampa PDF #' . $cpn['id'],
                    'text' => 'stampa una copia del coupon in formato PDF'
                );

            }

        }

    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

