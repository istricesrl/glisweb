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

    // tabella gestita
	$ct['form']['table'] = 'anagrafica';



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
		'url' => $file.'?id='.$_REQUEST[ $ct['form']['table'] ]['id'] ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'etichetta cartella sospesa',
		'text' => 'stampa la costina per la cartella sospesa'
	    );

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
