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

    // tabella della vista
    $ct['view']['table'] = 'contratti_completa';

    // tabella per la gestione
    $ct['view']['open']['table'] = 'contratti';

     // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_inizio' => 'data inizio',
        'data_fine' => 'data fine',
        'data_inizio_rapporto' => 'data inizio rapporto',
        'data_fine_rapporto' => 'data fine rapporto',
	    '__label__' => 'contratto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap'
    );
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contratti.form';
    $ct['view']['insert']['page'] = 'contratti.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_anagrafica';
//    $ct['view']['open']['preset']['subform'] = 'contratti';
    

    // preset filtro custom
    $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    
    // macro di default per la vista
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default per l'entità anagrafica
    require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
