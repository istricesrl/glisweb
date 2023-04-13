<?php

    /**
     * macro form articoli
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
    $ct['form']['table'] = 'articoli';

    // tendina prodotti
	$ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM prodotti_view' );

    // tendina colori
	$ct['etc']['select']['colori'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM colori_view' );

    // tendina id_tipologia_pubblicazioni
	$ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
	);

    // tendina taglie
	/*$ct['etc']['select']['taglie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM taglie_view' );*/

    // tendina unità di misura
	$ct['etc']['select']['udm'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM udm_view' );

        $ct['etc']['select']['udm_massa'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'], 
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM udm_view WHERE se_massa' );

            $ct['etc']['select']['udm_volume'] = mysqlCachedIndexedQuery(
                $cf['memcache']['index'],
                $cf['memcache']['connection'], 
                $cf['mysql']['connection'], 
                'SELECT id, __label__ FROM udm_view WHERE se_volume' );
    
    // tendina reparti
	$ct['etc']['select']['reparti'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM reparti_view' );    

/*
    if( isset( $_REQUEST['__preset__']['articoli']['id_prodotto']  ) ){
        // unità di misura di default
        $ct['etc']['value']['udm'] = mysqlSelectValue(
            $cf['mysql']['connection'], 
            'SELECT id_udm FROM prodotti WHERE id = ?',
            array( array( 's' => $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_prodotto'] ) ) );
    
        // dettagli tipologia
        $ct['etc']['value']['tipologia'] = mysqlSelectRow(
            $cf['mysql']['connection'], 
            'SELECT tipologie_prodotti.* FROM tipologie_prodotti LEFT JOIN prodotti ON prodotti.id_tipologia = tipologie_prodotti.id WHERE prodotti.id = ?',
            array( array( 's' => $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_prodotto'] ) ));
    }

    
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_prodotto']  ) ){
        // dettagli tipologia
        $ct['etc']['value']['tipologia'] = mysqlSelectRow(
            $cf['mysql']['connection'], 
            'SELECT tipologie_prodotti.* FROM tipologie_prodotti LEFT JOIN prodotti ON prodotti.id_tipologia = tipologie_prodotti.id WHERE prodotti.id = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_prodotto'] ) ));
    }
*/
    // tendina per mascherare il periodo di riferimento degli articoli rispetto ai corsi
    $ct['etc']['select']['periodi'] = array(
        array( 'id' => 'totale', '__label__' => 'totale' ),
        array( 'id' => 'quadrimestrale', '__label__' => 'quadrimestrale' ),
        array( 'id' => 'trimestrale', '__label__' => 'trimestrale' ),
        array( 'id' => 'bimestrale', '__label__' => 'bimestrale' ),
        array( 'id' => 'mensile', '__label__' => 'mensile' ),
        array( 'id' => 'settimanale', '__label__' => 'settimanale' ),
        array( 'id' => 'giornata', '__label__' => 'giornata' )
    );
    // macro di default per l'entità articoli
    require DIR_MOD . '_4100.prodotti/_src/_inc/_macro/_articoli.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
