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
	    'job' => array(
		'label' => 'gestione dei job'
	    )
	);

	if( mysqlSelectValue( $cf['mysql']['connection'], 'SELECT count( id ) FROM job WHERE timestamp_completamento IS NOT NULL LIMIT 1' ) > 0 ) {

        $ct['page']['contents']['metro']['job'][] = array(
            'ws' => $base . 'job.clean.completed',
            'callback' => 'function(){window.open(\''.$ct['page']['parent']['path'][ LINGUA_CORRENTE ].'\',\'_self\');}',
            'icon' => NULL,
            'fa' => 'fa-trash-o',
            'title' => 'svuotamento coda job completati',
            'text' => 'cancella la coda dei job completati'
	    );

    }

	if( mysqlSelectValue( $cf['mysql']['connection'], 'SELECT count( id ) FROM job LIMIT 1' ) > 0 ) {

        $ct['page']['contents']['metro']['job'][] = array(
            'ws' => $base . 'job.clean',
            'callback' => 'function(){window.open(\''.$ct['page']['parent']['path'][ LINGUA_CORRENTE ].'\',\'_self\');}',
            'confirm' => true,
            'icon' => NULL,
            'fa' => 'fa-trash',
            'title' => 'svuotamento totale coda job',
            'text' => 'cancella la coda dei job, compresi i job in corso'
        );
    
    }

    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';
