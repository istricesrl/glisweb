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
	$ct['view']['table'] = 'carrelli';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'carrelli.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
		'data_ora_apertura' => 'data apertura',
	    'intestazione_nome' => 'nome',
	    'intestazione_cognome' => 'cognome',
		'prezzo_lordo_finale' => 'importo',
	    'provider_pagamento' => 'metodo pagamento',
		'status_pagamento' => 'esito',
		'data_ora_pagamento' => 'data pagamento',
		'data_ora_checkout' => 'data chiusura'
	);

    // stili della vista
	$ct['view']['class'] = array(
	   'data_ora_apertura' => 'text-center',
	   'intestazione_nome' => 'text-left',
	   'intestazione_cognome' => 'text-left',
	   'prezzo_lordo_finale' => 'text-right',
	   'provider_pagamento' => 'text-center',
	   'status_pagamento' => 'text-center',
	   'data_ora_pagamento' => 'text-center',
	   'data_ora_checkout' => 'text-center'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
