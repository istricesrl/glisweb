<?php


    // tabella gestita
	$ct['form']['table'] = 'job';

    // recupero job
	$jb = array_unique(
        array_merge(
            glob( glob2custom( DIR_SRC_API_JOB . '*.php' ), GLOB_BRACE ),
            glob( glob2custom( DIR_MOD_ATTIVI_SRC_API_JOB . '*.php' ), GLOB_BRACE )
        )
    );

    // tendina job
	foreach( $jb as $t ) {
        shortPath( $t );
	    $ct['etc']['select']['job'][] = array( 'id' => $t, '__label__' => $t );
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
