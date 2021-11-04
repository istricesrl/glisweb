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
	$ct['form']['table'] = 'prodotti';

    $ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    )
	);

    if(file_exists(DIR_MOD.'4100.prodotti/src/api/print/cartellini.prezzo.articoli.pdf.php')  ){$file =  $cf['site']['url'].'4100.prodotti/src/api/print/cartellini.prezzo.articoli.pdf.php';}
    else {$file = $cf['site']['url'].'_mod/_4100.prodotti/_src/_api/_print/_cartellini.prezzo.articoli.pdf.php';  }

	$ct['page']['contents']['metro']['general'][] = array(
        'target' => '_blank' ,
		'url' => $file.'?prodotto='.$_REQUEST[ $ct['form']['table'] ]['id'] ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'etichette prezzo',
		'text' => 'stampa l\'etichetta prezzo di tutti gli articoli in pdf'
	    );

    if( file_exists(DIR_MOD.'4100.prodotti/src/api/print/cartellini.grandi.articoli.pdf.php')  ){$file_cartellini =  $cf['site']['url'].'4100.prodotti/src/api/print/cartellini.grandi.articoli.pdf.php';}
    else {$file_cartellini = $cf['site']['url'].'_mod/_4100.prodotti/_src/_api/_print/_cartellini.grandi.articoli.pdf.php';  }

	$ct['page']['contents']['metro']['general'][] = array(
        'target' => '_blank' ,
		'url' => $file_cartellini.'?prodotto='.$_REQUEST[ $ct['form']['table'] ]['id'] ,
		'icon' => NULL,
		'fa' => 'fa-file-pdf-o',
		'title' => 'cartellini vetrina',
		'text' => 'stampa l\'etichetta prezzo di tutti gli articoli in pdf'
	    );
    
    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
