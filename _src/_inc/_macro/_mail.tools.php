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

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'mail' => array(
		'label' => 'gestione delle mail'
	    )
	);

	if( mysqlSelectValue( $cf['mysql']['connection'], 'SELECT count( id ) FROM mail_sent LIMIT 1' ) > 0 ) {

        $ct['page']['contents']['metro']['mail'][] = array(
		'ws' => $base . 'mail.queue.clean.sent',
        'confirm' => true,
		'icon' => NULL,
		'fa' => 'fa-trash-o',
		'title' => 'svuotamento coda mail inviate',
		'text' => 'cancella la coda delle mail inviate'
	    );

        timerCheck( $cf['speed'], '-> mail in uscita' );

    }

	if( mysqlSelectValue( $cf['mysql']['connection'], 'SELECT count( id ) FROM mail_out LIMIT 1' ) > 0 ) {

        $ct['page']['contents']['metro']['mail'][] = array(
		'ws' => $base . 'mail.queue.clean.out',
        'confirm' => true,
		'icon' => NULL,
		'fa' => 'fa-trash',
		'title' => 'svuotamento coda mail in uscita',
		'text' => 'cancella la coda delle mail in uscita senza inviare'
		);

        timerCheck( $cf['speed'], '-> mail inviate' );

        if( ! empty( $cf['smtp']['server'] ) ) {

            $ct['page']['contents']['metro']['mail'][] = array(
            'ws' => $base . 'mail.queue.send?hard=1',
            'icon' => NULL,
            'fa' => 'fa-share-square-o',
            'title' => 'invia la prossima mail in uscita',
            'text' => 'forza elaborazione della prima mail della coda in uscita'
            );

            $ct['page']['contents']['metro']['mail'][] = array(
            'confirm' => true,
            'ws' => $base . 'mail.queue.send?full=1',
            'icon' => NULL,
            'fa' => 'fa-share-square',
            'title' => 'elabora coda mail in uscita',
            'text' => 'forza elaborazione di tutta la coda delle mail in uscita'
            );

        }

    }

    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';
