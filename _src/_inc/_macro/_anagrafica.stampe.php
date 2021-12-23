<?php

    /**
     * macro form anagrafica
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

 	    $base = DIR_MOD ;

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    )
	);

    if(file_exists('src/api/print/etichette.cartelle.sospese.php')  ){$file = $cf['site']['url'].'src/api/print/etichette.cartelle.sospese.php';}
    else {$file = $cf['site']['url'].'_src/_api/_print/_etichette.cartelle.sospese.pdf.php';  }

	$ct['page']['contents']['metro']['general'][] = array(
        'target' => '_blank' ,
		'url' => $file ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'etichette cartelle sospese',
		'text' => 'stampa le costine per le cartelle sospese'
	    );


    
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
