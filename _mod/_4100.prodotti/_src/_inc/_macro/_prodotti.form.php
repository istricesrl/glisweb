<?php

    /**
     * macro form prodotti
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
    $ct['form']['table'] = 'prodotti';

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];
 
    /*
    if( !isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST[ '__preset__' ] ) ) {

	    $ct['etc']['caratteristiche_categoria'] = mySqlQuery( $cf['mysql']['connection'], 'SELECT * FROM categorie_prodotti_caratteristiche_view WHERE id_categoria = ?', array( array('s' => $_REQUEST[ '__preset__' ]['prodotti']['prodotti_categorie'][0]['id_categoria'] )) );

	    foreach ( $ct['etc']['caratteristiche_categoria'] as $caratteristiche){
	        $_REQUEST[ $ct['form']['table'] ]['prodotti_caratteristiche'][] = array(
											'id_caratteristica' => $caratteristiche['id_caratteristica'],
											'id_prodotto' => '__parent_id__',
											'ordine' => $caratteristiche['ordine'],
                                            'testo' => $caratteristiche['testo'],
                                            'se_non_presente' => $caratteristiche['se_non_presente'],
		);
	    }

	}
*/
    // tendina produttori
	$ct['etc']['select']['produttori'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_produttore = 1' 
    );

    // tendina marchi
	$ct['etc']['select']['marchi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM marchi_view' 
    );

     // tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_prodotti_view' 
    );
    
     // tendina id_tipologia_pubblicazioni
	$ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
	);

    // tendina unità di misura
	$ct['etc']['select']['udm'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM udm_view' );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
