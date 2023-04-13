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
/*
    if(file_exists(DIR_MOD.'4000.catalogo/src/api/print/manuale.barcode.pdf.php')  ){$file = $cf['site']['url'].'4000.catalogo/src/api/print/manuale.barcode.pdf.php';}
    else {$file = $cf['site']['url'].'/_mod/_4000.catalogo/_src/_api/_print/_manuale.barcode.pdf.php';  }

	$ct['page']['contents']['metro']['general'][] = array(
        'target' => '_blank' ,
		'url' => $file ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'manuale barcode',
		'text' => 'stampa gli articoli con i relativi barcode'
	    );

    if( file_exists(DIR_MOD.'4100.prodotti/src/api/print/cartellini.grandi.articoli.pdf.php')  ){$file_cartellini =  $cf['site']['url'].'mod/4100.prodotti/src/api/print/cartellini.grandi.articoli.pdf.php';}
    else {$file_cartellini = $cf['site']['url'].'_mod/_4100.prodotti/_src/_api/_print/_cartellini.grandi.articoli.pdf.php';  }

	$ct['page']['contents']['metro']['general'][] = array(
        'target' => '_blank' ,
		'url' => $file_cartellini ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'cartellini vetrina',
		'text' => 'stampa l\'etichetta prezzo di tutti gli articoli in pdf'
	    );

    if(file_exists(DIR_MOD.'4100.prodotti/src/api/print/cartellini.prezzo.articoli.pdf.php')  ){$file_prezzi =  $cf['site']['url'].'mod/4100.prodotti/src/api/print/cartellini.prezzo.articoli.pdf.php';}
    else {$file_prezzi = $cf['site']['url'].'_mod/_4100.prodotti/_src/_api/_print/_cartellini.prezzo.articoli.pdf.php';  }
*/
/*
	$ct['page']['contents']['metro']['general'][] = array(
#      'target' => '_blank' ,
#		'url' => $file_prezzi ,
		'modal' => array('id' => 'stampa', 'include' => 'inc/prodotti.stampe.modal.html' ),
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'etichette prezzo',
		'text' => 'stampa l\'etichetta prezzo di tutti gli articoli in pdf'
	    );
    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';
*/

	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';
