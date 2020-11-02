<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = 'indirizzi';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'indirizzi.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'account',
	  
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
	   
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
	    if( $row['se_attivo'] == 1 ) { $row['se_attivo'] = '<i class="fa fa-check"></i>'; }
	}

?>
