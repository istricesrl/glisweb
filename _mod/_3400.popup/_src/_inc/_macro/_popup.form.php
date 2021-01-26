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
	    $ct['etc']['select']['templates'][] = array( 'id' => str_replace( DIR_BASE, '', $t ).'/', '__label__' => basename( $t ) );
    }
    
    // dati che dipendono dal template
	if( isset( $_REQUEST['popup']['template'] ) ) {

	    // controllo file
		if( file_exists( DIR_BASE . $_REQUEST['popup']['template'] . '/etc/template.conf' ) ) {

		    // tendina schemi
			$schemi = glob( DIR_BASE . $_REQUEST['popup']['template'] . '/*.html', GLOB_BRACE );
			foreach( $schemi as $t ) {
			    $ct['etc']['select']['schemi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
			}

		}

	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
