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
    $ct['form']['table'] = 'pagine';
    
    // tabella della vista
	$ct['view']['table'] = 'pagine_gruppi';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pagine.form';
    
     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'id_pagina' => 'pagina',
	    'id_gruppo' => 'gruppi'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'id_pagina' => 'text-left',
	    'id_gruppo' => 'text-left'
	);

    // preset filtro custom progetti aperti
	//$ct['view']['__restrict__']['id_pagina']['LK'] = $_REQUEST[ $ct['form']['table'] ]['id'];

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
