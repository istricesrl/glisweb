<?php

    /**
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    /**
     * azioni specifiche della macro
     * =============================
     * 
     * 
     * 
     * 
     */

    // ...
    if( isset( $_REQUEST['__associazione_riga__'] ) ) {

        // debug
        // die( print_r( $_REQUEST, true ) );

        // ...
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE documenti_articoli SET id_missione = ? WHERE id = ?',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => $_REQUEST['__associazione_riga__']['id_documenti_articoli'] )
            )
        );

    }

    /**
     * configurazione del form
     * =======================
     * 
     * 
     * 
     * 
     */

    // tabella gestita
	$ct['form'] = array(
        'table' => 'documenti'
    );

    /**
     * configurazione della view
     * =========================
     * 
     * 
     * 
     * 
     */

    // tabella della vista
	$ct['view'] = array(
        'table' => 'documenti_articoli',
        'open' => array(
            'page' => 'documenti.articoli.form',
            'table' => 'documenti_articoli',
            'field' => 'id',
        ),
        'cols' => array(
            'id' => '#',
            'data' => 'data',
            'nome' => 'nome',
            'quantita' => 'quantità',
            'importo_netto_totale' => 'importo netto',
            'id_genitore' => 'aggregata a',
            'id_documento' => 'id_documento'
        ),
        'class' => array(
            'nome' => 'text-left',
            'importo_netto_totale' => 'text-right',
            'quantita' => 'text-right',
            'totale_riga' => 'text-right',
            'nome' => 'text-left',
            'articolo' => 'text-left',
            'id_documento' => 'd-none',
            'cliente' => 'text-left',
            'emittente' => 'text-left', 
            'data' => 'no-wrap', 
            'id_articolo' => 'text-left'
        ),
        '__restrict__' => array(
            'id_missione' => array( 'EQ' => $_REQUEST[ $ct['form']['table'] ]['id'] ?? null ),
            'id_genitore' => array( 'NL' => true )
        ),
    );

    /**
     * relazioni con altri moduli
     * ==========================
     * 
     * 
     * 
     * 
     */

	// RELAZIONI CON IL MODULO MASTRI
	if( checkMod( "0500.mastri" ) ) {
		arrayInsertAssoc( 'nome', $ct['view']['cols'], array( 'mastro_provenienza' => 'scarico', 'mastro_destinazione' => 'carico' ) );
	}

	// RELAZIONI CON IL MODULO PRODOTTI
	if( checkMod( "4100.prodotti" ) ) {
		arrayInsertAssoc( 'id', $ct['view']['cols'], array( 'id_articolo' => 'codice' ) );
		arrayInsertAssoc( 'nome', $ct['view']['cols'], array( 'articolo' => 'articolo' ) );
	}

	// RELAZIONI CON IL MODULO MATRICOLE
	if( checkMod( "4110.matricole" ) ) {
		arrayInsertAssoc( 'id_articolo', $ct['view']['cols'], array( 'matricola' => 'matricola' ) );
		if( ! empty( $cf['matricole']['scadenze'] ) ) {
			arrayInsertAssoc( 'matricola', $ct['view']['cols'], array( 'data_scadenza' => 'scadenza' ) );
		}
	}

    /**
     * dati delle tendine
     * ==================
     * 
     * 
     * 
     * 
     */

    $ct['etc']['select']['righe'] = tendinaRigheMissione();

    /**
     * macro di default
     * ================
     * 
     * 
     * 
     * 
     */

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

