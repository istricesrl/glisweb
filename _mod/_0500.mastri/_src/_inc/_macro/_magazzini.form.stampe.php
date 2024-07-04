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
	$ct['form']['table'] = 'mastri';

    $ct['page']['contents']['metros'] = array(
	    'stampe' => array(
		    'label' => 'stampe'
	    )
	);
/*
    if(file_exists(DIR_MOD.'4100.prodotti/src/api/print/manuale.barcode.pdf.php')  ){$file =  $cf['site']['url'].'4100.prodotti/src/api/print/cartellini.prezzo.articoli.pdf.php';}
    else {$file = $cf['site']['url'].'_mod/_4100.prodotti/_src/_api/_print/_cartellini.prezzo.articoli.pdf.php';  }

	$ct['page']['contents']['metro']['general'][] = array(
        'target' => '_blank' ,
		'url' => $file.'?articolo='.$_REQUEST[ $ct['form']['table'] ]['id'] ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'etichetta prezzo',
		'text' => 'stampa l\'etichetta prezzo dell\'articolo in pdf'
	    );

    if( file_exists(DIR_MOD.'4100.prodotti/src/api/print/cartellini.grandi.articoli.pdf.php')  ){$file_cartellini =  $cf['site']['url'].'4100.prodotti/src/api/print/cartellini.grandi.articoli.pdf.php';}
    else {$file_cartellini = $cf['site']['url'].'_mod/_4100.prodotti/_src/_api/_print/_cartellini.grandi.articoli.pdf.php';  }

	$ct['page']['contents']['metro']['general'][] = array(
        'target' => '_blank' ,
		'url' => $file_cartellini.'?articolo='.$_REQUEST[ $ct['form']['table'] ]['id'] ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'cartellini vetrina',
		'text' => 'stampa l\'etichetta prezzo di tutti gli articoli in pdf'
	    );
*/

    $ct['page']['contents']['metro']['stampe'][] = array(
        'target' => '_blank' ,
        'url' => '/print/0500.mastri/etichette.articoli.57x26.pdf?mastro='.$_REQUEST[ $ct['form']['table'] ]['id'] ,
        'icon' => NULL,
        'fa' => 'fa-file-pdf-o',
        'title' => 'stampa etichette 57x26',
        'text' => 'stampa le etichette di tutti gli articoli presenti nel magazzino'
    );

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
