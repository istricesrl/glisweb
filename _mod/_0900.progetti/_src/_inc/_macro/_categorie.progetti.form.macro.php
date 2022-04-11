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
	$ct['form']['table'] = 'categorie_progetti';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'macro';

    // recupero macro
    $mcr = array_unique(
        array_merge(
            glob( glob2custom( DIR_SRC_INC_MACRO . '*.php' ), GLOB_BRACE ),
            glob( glob2custom( DIR_MOD_ATTIVI_SRC_INC_MACRO . '*.php' ), GLOB_BRACE )
        )
    );

    // tendina macro
	foreach( $mcr as $t ) {
	    $ct['etc']['select']['macro'][] = array( 'id' => $t, '__label__' => $t );
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    //debug
        // var_dump( glob2custom( DIR_SRC_INC_MACRO . '*.php' ) );
        // var_dump( glob2custom( DIR_MOD_ATTIVI_SRC_INC_MACRO . '*.php' ) );
        // print_r( glob( glob2custom( DIR_SRC_INC_MACRO . '*.php' ), GLOB_BRACE ) );
        // print_r( glob( glob2custom( DIR_MOD_ATTIVI_SRC_INC_MACRO . '*.php' ), GLOB_BRACE ) );
