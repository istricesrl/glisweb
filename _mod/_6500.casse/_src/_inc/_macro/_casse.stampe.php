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
	    $base = DIR_MOD ;
#	}

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    )
	);

    if(file_exists(DIR_MOD.'6500.casse/src/api/print/manuale.barcode.pdf.php')  ){$file = $cf['site']['url'].'6500.casse/src/api/print/comandi.cassa.pdf.php';}
    else {$file = $cf['site']['url'].'_6500.casse/_src/_api/_print/_comandi.cassa.pdf.php';  }

	$ct['page']['contents']['metro']['general'][] = array(
        'target' => '_blank' ,
		'url' => $file ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'stampa comandi',
		'text' => 'stampa barcode comandi rapidi'
	    );

    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';

	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';