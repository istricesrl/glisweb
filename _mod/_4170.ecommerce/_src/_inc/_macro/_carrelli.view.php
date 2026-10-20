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

    // campi della vista; il cliente e' l'intestatario o, se manca, il destinatario ( carrelli_view )
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'cliente_nome' => 'nome',
	    'cliente_cognome' => 'cognome',
	    'cliente_mail' => 'e-mail',
	    'data_ora_inserimento' => 'inserito',
	    'data_ora_checkout' => 'confermato',
	    'data_ora_pagamento' => 'pagato',
	    'provider_pagamento' => 'tramite',
	    'status_pagamento' => 'esito',
	    'prezzo_lordo_finale' 	=> 'totale ordine',
	    'id_sito' => 'sito',
	    'data_ora_evasione' => 'evaso',
#		'gruppi_attribuzione' => 'attribuzione automatica'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'cliente_nome' => 'text-left',
	    'cliente_cognome' => 'text-left',
	    'cliente_mail' => 'text-left',
	    'provider_pagamento' => 'd-none',
	    'status_pagamento' => 'text-center',
	    'prezzo_lordo_finale' 	=> 'text-right',
	    'id_sito' => 'text-left',
#	    'gruppi' 	=> 'text-left'
	);

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/carrelli.view.filters.html';

	// filtri di default
    $ct['view']['__filters__']['timestamp_checkout']['NL'] = -1;
    // $ct['view']['__filters__']['timestamp_pagamento']['NL'] = -1;
    $ct['view']['__filters__']['timestamp_evasione']['NL'] = 1;

	// ordinamento di default, i carrelli piu' recenti in cima
	$ct['view']['__sort__']['id'] = 'DESC';

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

        if( is_array( $row ) ) {
            if( ! empty( $row['id_sito'] ) ) {
                if( isset( $cf['sites'][ $row['id_sito'] ] ) )
                    $row['id_sito'] = $cf['sites'][ $row['id_sito'] ]['__label__'];
                else
                    $row['id_sito'] = 'Sito non definito';
            } else {
                $row['id_sito'] = 'Nessun sito';
            }
        }

	}
