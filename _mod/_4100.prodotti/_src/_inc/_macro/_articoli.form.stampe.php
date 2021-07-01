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

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
