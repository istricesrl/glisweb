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
    $ct['form']['table'] = 'articoli';
    $ct['view']['data']['__report_mode__'] = 1;
    
    // tabella della vista
	$ct['view']['table'] = '__report_movimenti_magazzini__';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.articoli.form';
    $ct['view']['open']['table'] = 'documenti_articoli';
    $ct['view']['open']['field'] = 'id';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
#        'data_lavorazione' => 'data',
#	    'descrizione' => 'riga',
#        'id_articolo' => 'articolo',
#        'quantita' => 'quantità',
#        'importo' => 'importo',
#        'id_listino' => 'id_listino',
        'id' => 'id',
#        'cliente' => 'cliente',
#        'id_emittente' => 'emittente',
#        'id_tipologia' => 'id_tipologia',
#        'id_todo' => 'todo',
#        'progetto' => 'progetto',
#        'matricola' => 'matricola'
'data' => 'data',
'tipologia' => 'tipologia',
'documento' => 'documento',
'numero' => 'numero',
'sezionale' => 'sezionale',
'emittente' => 'emittente',
'destinatario' => 'destinatario',
'categorie' => 'categorie',
'id_prodotto' => 'codice prodotto',
'prodotto' => 'prodotto',
'codice_produttore' => 'cod. produttore',
'id_articolo' => 'codice articolo',
'articolo' => 'descrizione',
'mastro_provenienza' => 'da',
'mastro_destinazione' => 'a',
'quantita' => 'quantita',
'quantita_movimento' => 'q.tà movimento',
'udm_movimento' => 'udm'

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
#        'id_riga' => 'd-none',
        'numero' => 'd-none',
        'data' => 'no-wrap', 
        'documento' => 'text-left no-wrap',
        'numero' => 'd-none',
        'sezionale' => 'd-none',
#        'id_listino' => 'd-none',
#        'id_tipologia' => 'd-none',
#        'id_emittente' => 'd-none',
'emittente' => 'd-none',
'destinatario' => 'd-none',
        'tipologia' => 'd-none',
        'quantita' => 'text-right',
        'quantita_movimento' => 'text-right',
#        'qta_carico' => 'd-none',
#        'qta_scarico' => 'd-none',
#	    'descrizione' => 'text-left',
'categorie' => 'd-none',
'id_prodotto' => 'd-none',
'prodotto' => 'd-none',
'codice_produttore' => 'd-none',
        'id_articolo' => 'd-none',
#        'importo' => 'text-right',
#        'cliente' => 'text-left',
#        'emittente' => 'text-left'
'mastro_provenienza' => 'text-left',
'mastro_destinazione' => 'text-left',
'articolo' => 'd-none',
'udm_movimento' => 'd-none'
);

#    $ct['etc']['include']['filters'] = 'inc/documenti.articoli.view.filters.html';

    // preset filtro mastro corrente
	// $ct['view']['__restrict__']['id']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
//    $ct['view']['__restrict__']['mastri_path_check( id_mastro_provenienza, '.$_REQUEST[ $ct['form']['table'] ]['id'].' )']['EQ'] = 1;
//    $ct['view']['__restrict__']['mastri_path_check( id_mastro_destinazione, '.$_REQUEST[ $ct['form']['table'] ]['id'].' )']['EQ'] = 1;
//    $ct['view']['__restrict__']['( mastri_path_check( id_mastro_provenienza, '.$_REQUEST[ $ct['form']['table'] ]['id'].' )  mastri_path_check( id_mastro_destinazione, '.$_REQUEST[ $ct['form']['table'] ]['id'].' ) )']['EQ'] = 1;

$ct['view']['__restrict__']['id_articolo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
#            $row['tipologia'] .= ' ' . $row['documento'] . ' ' . ' n. '.$row['numero'].'/'.$row['sezionale'];
            $row['quantita_movimento'] .= ' ' . $row['udm_movimento'];
        }
	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';