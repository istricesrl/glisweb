<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'pagine';

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];

    // tendina templates
	$tpl = glob( DIR_BASE . '_src/_tpl/*', GLOB_BRACE );
	foreach( $tpl as $t ) {
        if( file_exists( $t . '/etc/template.conf' ) || file_exists( $t . '/etc/template.yaml' ) ) {
            $ct['etc']['select']['templates'][] = array( 'id' => str_replace( DIR_BASE, '', $t ).'/', '__label__' => str_replace( '_', '', basename( $t ) ) );
        }
	}

    // dati che dipendono dal template
	if( isset( $_REQUEST[ $ct['form']['table'] ]['template'] ) ) {

        // ricerca schemi
        $schemi = array_merge(
            glob( glob2custom( DIR_BASE . $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.twig', GLOB_BRACE ),
            glob( glob2custom( DIR_MOD_ATTIVI . $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.twig', GLOB_BRACE )
        );

        // tendina schemi
        foreach( $schemi as $t ) {
            $ct['etc']['select']['schemi'][ basename( $t ) ] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
        }

        // tendina temi
        $temi = glob( DIR_BASE . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . 'css/{,themes/}*.css', GLOB_BRACE );
        foreach( $temi as $t ) {
            $ct['etc']['select']['temi'][ basename( $t ) ] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
        }

	}

    // tendina tipologie pubblicazioni
    $ct['etc']['select']['tipologie_pubblicazioni'] = tendinaTipologiePubblicazioni();

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

