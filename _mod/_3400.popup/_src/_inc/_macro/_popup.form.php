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

    // tendina tipologie pubblicazioni
	$ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
	);

    // tendina tipologie popup
	$ct['etc']['select']['tipologie_popup'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_popup_view'
    );

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];
    
     // tendina templates
	$tpl = glob( DIR_BASE . '{_,}src/{_,}templates/*', GLOB_BRACE );
	foreach( $tpl as $t ) {
	    $ct['etc']['select']['templates'][] = array( 'id' => str_replace( DIR_BASE, '', $t ).'/', '__label__' => basename( $t ) );
    }
    
    // dati che dipendono dal template
	if( isset( $_REQUEST['popup']['template'] ) ) {

	    // controllo file
		if( file_exists( DIR_BASE . $_REQUEST['popup']['template'] . '/etc/template.conf' ) ) {

            // ricerca schemi
            $schemi = array_merge(
                glob( DIR_BASE . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.html', GLOB_BRACE ),
                glob( DIR_MOD_ATTIVI . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.html', GLOB_BRACE )
            );

            // tendina schemi
            foreach( $schemi as $t ) {
                $ct['etc']['select']['schemi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
            }

		}

	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
