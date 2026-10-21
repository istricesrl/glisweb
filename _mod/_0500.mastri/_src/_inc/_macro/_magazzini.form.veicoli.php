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
	$ct['form']['table'] = 'mastri';

    // tendina tipologie veicoli
    // NOTA query diretta invece di tendinaTipologieVeicoli(), che sta nel modulo VE000.veicoli e con quel
    // modulo spento non esiste; la vista tipologie_veicoli_view e' nello schema del core
    $ct['etc']['select']['tipologie_veicoli'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_veicoli_view ORDER BY __label__'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
