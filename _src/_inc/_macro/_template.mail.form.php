<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'template_mail';

    // tendina types
	$ct['etc']['select']['types'] = array(
	    array( 'id' => 'twig', '__label__' => 'template manager Twig' )
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
