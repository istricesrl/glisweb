<?php

    /**
     * macro form anagrafica
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
    $ct['form']['table'] = 'categorie_prodotti';

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];
    
    // tendina id_genitore
	$ct['etc']['select']['id_genitore'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_prodotti_view'
    );
    
   // tendina templates
	$tpl = glob( DIR_BASE . '{_,}src/{_,}templates/*', GLOB_BRACE );
	foreach( $tpl as $t ) {
	    $ct['etc']['select']['templates'][] = array( 'id' => str_replace( DIR_BASE, '', $t ).'/', '__label__' => basename( $t ) );
	}
    
   // dati che dipendono dal sito
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_sito'] ) ) {

        // tendina genitori
		$ct['etc']['select'][ $ct['form']['table'] ] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
                $cf['mysql']['connection'],
            'SELECT id, __label__ FROM pagine_view WHERE id_sito = ? AND pagine_path_check( pagine_view.id, ? ) = 0',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_sito'] ),
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
            );

    }

    // dati che dipendono dal template
	if( isset( $_REQUEST[ $ct['form']['table'] ]['template'] ) ) {

	    // controllo file
		if( file_exists( DIR_BASE . $_REQUEST[ $ct['form']['table'] ]['template'] . '/etc/template.conf' ) ) {

		    // tendina schemi
			$schemi = glob( DIR_BASE . $_REQUEST[ $ct['form']['table'] ]['template'] . '/*.html', GLOB_BRACE );
			foreach( $schemi as $t ) {
			    $ct['etc']['select']['schemi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
			}

		    // tendina temi
			$temi = glob( DIR_BASE . $_REQUEST[ $ct['form']['table'] ]['template'] . '/css/*.css', GLOB_BRACE );
			foreach( $temi as $t ) {
			    $ct['etc']['select']['temi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
			}

		}

	}
    
     // tendina id_tipologia_pubblicazione
	$ct['etc']['select']['tipologie_pubblicazione'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazione_view'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
