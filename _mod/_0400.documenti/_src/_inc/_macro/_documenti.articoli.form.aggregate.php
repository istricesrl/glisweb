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
    $ct['form']['table'] = 'documenti_articoli';
    
    // tabella della vista
	$ct['view']['table'] = 'documenti_articoli';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.articoli.form';

     // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data' => 'data',
       // 'documento' => 'documento',
       // 'tipologia' => 'tipologia',
        'nome' => 'nome',
        'id_articolo' => 'articolo',
        'quantita' => 'quantità',
		'mastro_provenienza' => 'provenienza',
		'mastro_destinazione' => 'destinazione',
        'importo_netto_totale' => 'importo'
    );


    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.articoli.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'documenti.articoli.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_genitore';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_genitore']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

 /*   if( !empty( $ct['view']['data'] ) ){
		// le date AAAA-MM-GG le ha gia' convertite in GG/MM/AAAA _default.view.php ( dal 2026-09-22 ), e
		// ripassarle da strtotime() leggeva GG/MM come MM/GG ( 01/01/1970 o giorno e mese scambiati ): si
		// riconverte solo quello che e' ancora AAAA-MM-GG, come un datetime che il default lascia com'e'
		foreach ( $ct['view']['data'] as &$row ){
            if(!empty($row['data_programmazione'])){$row['data_programmazione'] = ( preg_match( '/^[0-9]{4}-[0-9]{2}-[0-9]{2}/', $row['data_programmazione'] ) ? date('d/m/Y', strtotime($row['data_programmazione'])) : $row['data_programmazione'] );}

            if(!empty($row['data_attivita'])){$row['data_attivita'] = ( preg_match( '/^[0-9]{4}-[0-9]{2}-[0-9]{2}/', $row['data_attivita'] ) ? date('d/m/Y', strtotime($row['data_attivita'])) : $row['data_attivita'] );}
            $row['ora_inizio_programmazione'] = substr( $row['ora_inizio_programmazione'], 0, -3);
            $row['__label__'] = $row['note_interne'].( empty($row['note_interne']) ? '' : '; <br>').$row['testo'];
		}
	}*/
