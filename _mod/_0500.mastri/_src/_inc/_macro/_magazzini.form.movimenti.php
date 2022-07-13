<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'mastri';
    $ct['view']['data']['__report_mode__'] = 1;
    
    // tabella della vista
	$ct['view']['table'] = '__report_movimenti_magazzini__';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.articoli.form';
    $ct['view']['open']['table'] = 'documenti_articoli';
    $ct['view']['open']['field'] = 'id_riga';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
#        'data_lavorazione' => 'data',
#	    'descrizione' => 'riga',
#        'id_articolo' => 'articolo',
#        'quantita' => 'quantità',
#        'importo' => 'importo',
#        'id_listino' => 'id_listino',
        'id_riga' => 'id_riga',
#        'cliente' => 'cliente',
#        'id_emittente' => 'emittente',
#        'id_tipologia' => 'id_tipologia',
#        'id_todo' => 'todo',
#        'progetto' => 'progetto',
#        'matricola' => 'matricola'
'data' => 'data',
'tipologia' => 'documento',
'documento' => 'nome',
'numero' => 'numero',
//'id_articolo' => 'codice',
'articolo' => 'descrizione',
'carico' => 'carico',
'scarico' => 'scarico',

	);

	// RELAZIONI CON IL MODULO MATRICOLE
	if( in_array( "4110.matricole", $cf['mods']['active']['array'] ) ) {

		// colonna matricola
		arrayInsertAssoc( 'articolo', $ct['view']['cols'], array( 'matricola' => 'matricola' ) );

        // OPZIONE scadenze
        if( ! empty( $cf['matricole']['scadenze'] ) ) {
            arrayInsertAssoc( 'matricola', $ct['view']['cols'], array( 'data_scadenza' => 'scadenza' ) );
        }

    }

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none',
        'id_riga' => 'd-none',
        'numero' => 'd-none',
        'data' => 'no-wrap', 
        'documento' => 'd-none',
#        'id_listino' => 'd-none',
#        'id_tipologia' => 'd-none',
#        'id_emittente' => 'd-none',
        'tipologia' => 'text-left',
        'carico' => 'text-right',
        'scarico' => 'text-right',
#	    'descrizione' => 'text-left',
#        'id_articolo' => 'text-left',
#        'importo' => 'text-right',
#        'cliente' => 'text-left',
#        'emittente' => 'text-left'
'articolo' => 'text-left'
);

#    $ct['etc']['include']['filters'] = 'inc/documenti.articoli.view.filters.html';

    // preset filtro mastro corrente
	$ct['view']['__restrict__']['id']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
  
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
        $row['tipologia'] .= ' ' . $row['documento'] . ' ' . ' n° '.$row['numero'];
	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
