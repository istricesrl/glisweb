<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'indirizzi';

    // tabella della vista
    $ct['view']['table'] = 'anagrafica_indirizzi';
    
     // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'indirizzi.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'anagrafica' => 'anagrafica',
	    'interno' => 'interno',
	    'descrizione' => 'descrizione'
    );
    
    // stili della vista
	$ct['view']['class'] = array(
	    'anagrafica' => 'd-none d-md-table-cell',
	    'interno' => 'text-left',
	    'descrizione' => 'text-left'
	);
    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
