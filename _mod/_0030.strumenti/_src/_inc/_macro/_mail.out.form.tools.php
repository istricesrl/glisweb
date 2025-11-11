<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // TODO il framework dovrebbe poter funzionare anche su porte diverse dalla :80

    // TODO prelevare l'URL del sito correntemente gestito ($_SESSION['__view__']['__site__'])
    // TODO provvisorio; a tendere bisognerebbe che ogni elemento di $cf['sites'] venisse processato
    // e avesse quindi il suo URL calcolato, quindi poi $cf['site'] dovrebbe far riferimento all'elemento
    // appropriato di $cf['sites']
#	if( isset( $cf['sites'] ) && count( $cf['sites'] ) ) {
#	    $base = $cf['sites'][ $_SESSION['__view__']['__site__'] ]['protocols'][ $cf['site']['status'] ] . '://' .
#		( ( ! empty( $cf['sites'][ $_SESSION['__view__']['__site__'] ]['hosts'][ $cf['site']['status'] ] ) ) ? $cf['sites'][ $_SESSION['__view__']['__site__'] ]['hosts'][ $cf['site']['status'] ] . ((!empty($cf['sites'][ $_SESSION['__view__']['__site__'] ]['domains'][ $cf['site']['status'] ]))?'.':NULL) : NULL ).
#		$cf['sites'][ $_SESSION['__view__']['__site__'] ]['domains'][ $cf['site']['status'] ] . '/' .
#		( ( isset( $cf['sites'][ $_SESSION['__view__']['__site__'] ]['folders'][ $cf['site']['status'] ] ) ) ? $cf['sites'][ $_SESSION['__view__']['__site__'] ]['folders'][ $cf['site']['status'] ] : NULL );
#	} else {
	    $base = '/task/';
#	}

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // tabella gestita
	$ct['form']['table'] = 'mail_out';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'mail' => array(
		'label' => 'gestione delle mail'
	    )
	);

    if( ! empty( $cf['smtp']['server'] ) ) {
        $ct['page']['contents']['metro']['mail'][] = array(
        'ws' => $base . 'mail.queue.send?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
        'callback' => 'function() { window.open("' . $cf['contents']['pages']['mail.sent.view']['url'][ LINGUA_CORRENTE ] . '", "_self"); }',
        'icon' => NULL,
        'fa' => 'fa-share-square-o',
        'title' => 'invia immediatamente la mail',
        'text' => 'forza un tentativo di invio per questa mail'
        );
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';
