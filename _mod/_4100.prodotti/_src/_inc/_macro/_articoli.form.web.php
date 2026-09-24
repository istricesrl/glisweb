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
    $ct['form']['table'] = 'articoli';

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

    // tendina templates
    $tpl = glob( DIR_BASE . '{_,}src/{_,}templates/*', GLOB_BRACE );
    foreach( $tpl as $t ) {
        if( file_exists( $t . '/etc/template.conf' ) ) {
            $ct['etc']['select']['templates'][] = array( 'id' => str_replace( DIR_BASE, '', $t ).'/', '__label__' => basename( $t ) );
        }
    }
 
    // dati che dipendono dal sito
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_sito'] ) ) {

        // tendina genitori
        $ct['etc']['select'][ $ct['form']['table'] ] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
                $cf['mysql']['connection'],
            'SELECT id, __label__ FROM pagine_view WHERE id_sito = ? AND pagine_path_check( pagine_view.id, ? ) = 0',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_sito'] ),
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
            )
        );

    }

    // dati che dipendono dal template
    if( isset( $_REQUEST[ $ct['form']['table'] ]['template'] ) ) {

        // controllo file
        if( file_exists( DIR_BASE . $_REQUEST[ $ct['form']['table'] ]['template'] . '/etc/template.conf' ) ) {

            // ricerca schemi
            $schemi = array_merge(
                glob( DIR_BASE . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.html', GLOB_BRACE ),
                glob( DIR_MOD_ATTIVI . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.html', GLOB_BRACE )
            );

            // tendina schemi
            foreach( $schemi as $t ) {
                $ct['etc']['select']['schemi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
            }

            // tendina temi
            $temi = glob( DIR_BASE . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/css/{,themes/}*.css', GLOB_BRACE );
            foreach( $temi as $t ) {
                $ct['etc']['select']['temi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
            }

        }

    }

    // tendina id_tipologia_pubblicazione
	$ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
