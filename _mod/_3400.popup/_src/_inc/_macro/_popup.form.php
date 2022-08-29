<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'popup';

	// tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];

    // tendina tipologie pubblicazione
	$ct['etc']['select']['tipologie_pubblicazione'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazione_view'
	);

    // tendina tipologie popup
	$ct['etc']['select']['tipologie_popup'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_popup_view'
    );
    

	// tendina templates
	$tpl = glob( DIR_BASE . '{_,}src/{_,}templates/*', GLOB_BRACE );
	foreach( $tpl as $t ) {
        if( file_exists( $t . '/etc/template.conf' ) ) {
            $ct['etc']['select']['templates'][] = array( 'id' => str_replace( DIR_BASE, '', $t ).'/', '__label__' => basename( $t ) );
        }
	}
	
    if( isset( $_REQUEST[ $ct['form']['table'] ]['template'] ) ) {

	    // controllo file
		if( file_exists( DIR_BASE . $_REQUEST[ $ct['form']['table'] ]['template'] . '/etc/template.conf' ) ) {

		    // tendina schemi
			$schemi = glob( DIR_BASE . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.html', GLOB_BRACE );
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

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
