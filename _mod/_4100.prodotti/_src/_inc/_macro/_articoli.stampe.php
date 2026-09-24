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
	$ct['form']['table'] = 'articoli';

    $ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    )
	);
/*
    if(file_exists(DIR_MOD.'4100.prodotti/src/api/print/manuale.barcode.pdf.php')  ){$file =  $cf['site']['url'].'4100.prodotti/src/api/print/cartellini.prezzo.articoli.pdf.php';}
    else {$file = $cf['site']['url'].'_mod/_4100.prodotti/_src/_api/_print/_cartellini.prezzo.articoli.pdf.php';  }

	$ct['page']['contents']['metro']['general'][] = array(
        'target' => '_blank' ,
		'url' => $file ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'etichette prezzo',
		'text' => 'stampa l\'etichetta prezzo di tutti gli articol in pdf'
	    );
*/