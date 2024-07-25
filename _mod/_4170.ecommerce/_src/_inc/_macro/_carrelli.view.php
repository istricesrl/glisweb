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
	    'intestazione' => 'intestazione',
	    'data_ora_inserimento' => 'inserito',
	    'data_ora_checkout' => 'confermato',
	    'data_ora_pagamento' => 'pagato',
	    'provider_pagamento' => 'tramite',
	    'prezzo_lordo_finale' 	=> 'totale ordine',
	    'data_ora_evasione' => 'evaso',
#		'gruppi_attribuzione' => 'attribuzione automatica'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'intestazione' => 'text-left',
	    'provider_pagamento' => 'd-none',
	    'prezzo_lordo_finale' 	=> 'text-right',
#	    'gruppi' 	=> 'text-left'
	);

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/carrelli.view.filters.html';

	// filtri di default
    $ct['view']['__filters__']['timestamp_checkout']['NL'] = -1;
    // $ct['view']['__filters__']['timestamp_pagamento']['NL'] = -1;
    $ct['view']['__filters__']['timestamp_evasione']['NL'] = 1;

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {
            if( ! empty( $row['provider_pagamento'] ) ) {
                $row['data_ora_pagamento'] .= ' (' . $row['provider_pagamento'] . ')';
            }
            $row['prezzo_lordo_finale'] = writeCurrency( $row['prezzo_lordo_finale'] );
        }
	}
