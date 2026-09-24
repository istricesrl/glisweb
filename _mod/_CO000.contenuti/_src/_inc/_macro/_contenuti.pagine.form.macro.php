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

    // tabella gestita
    $ct['form']['table'] = 'pagine';

    // recupero macro
    $mcr = array_unique(
        array_merge(
            glob( glob2custom( DIR_SRC_INC_MACRO . '*.php' ), GLOB_BRACE ),
            glob( glob2custom( DIR_MOD_ATTIVI_SRC_INC_MACRO . '*.php' ), GLOB_BRACE )
        )
    );

    // tendina macro
	foreach( $mcr as $t ) {
        $t = str_replace( DIR_BASE, '', $t );
	    $ct['etc']['select']['macro'][] = array( 'id' => $t, '__label__' => $t );
	}

    // ordinamento
    asort( $ct['etc']['select']['macro'] );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // debug
    // die( print_r( $_REQUEST, true ) );
