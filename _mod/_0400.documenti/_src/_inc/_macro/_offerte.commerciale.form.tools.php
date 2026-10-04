<?php

    /**
     * macro degli strumenti delle offerte
     *
     * La scheda strumenti e' fra i tab di offerte.commerciale.form fin da quando le pagine delle
     * offerte sono state scritte, ma questa macro non esisteva: aprendola si otteneva
     * "impossibile trovare la macro di pagina". Gli strumenti si aggiungono qui, con la stessa
     * forma usata in _documenti.form.tools.php ( voci in $ct['page']['contents']['metro'][ \<gruppo\> ]
     * e gruppi dichiarati in $ct['page']['contents']['metros'] ).
     *
     * @file
     *
     */

    // tabella della vista
    $ct['form']['table'] = 'documenti';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        'static' => array(
            'label' => 'vista statica'
        )
    );

    /**
     * RIPOPOLAMENTO DELLA VISTA STATICA DELLE OFFERTE
     *
     * Stessa forma dei tre pulsanti delle attivita' ( _mod/_0200.attivita/_src/_inc/_macro/_attivita.tools.php ):
     * lws e non ws per la popolazione, perche' il task scrive un lotto per volta e va richiamato in ciclo.
     *
     * Di norma non serve: la statica la tiene allineata il controller finally dei documenti. Serve
     * per la prima popolazione e per le righe entrate in archivio senza passare dal controller,
     * per esempio un'importazione.
     */
    $ct['page']['contents']['metro']['static'][] = array(
        'lws' => '/task/0400.documenti/offerte.view.static.popolazione',
        'icon' => NULL,
        'fa' => 'fa-refresh',
        'title' => 'ripopola la vista statica delle offerte',
        'text' => 'riscrive le righe dell\'elenco offerte rimaste indietro rispetto ai documenti'
    );

    $ct['page']['contents']['metro']['static'][] = array(
        'ws' => '/task/0400.documenti/offerte.view.static.pulizia',
        'icon' => NULL,
        'fa' => 'fa-refresh',
        'title' => 'pulizia della vista statica delle offerte',
        'text' => 'toglie dall\'elenco offerte le righe dei documenti cancellati o che non sono piu\' offerte'
    );

    $ct['page']['contents']['metro']['static'][] = array(
        'ws' => '/task/0400.documenti/offerte.view.static.svuotamento',
        'icon' => NULL,
        'fa' => 'fa-trash',
        'title' => 'svuotamento della vista statica delle offerte',
        'text' => 'svuota la vista statica delle offerte ( solo per le emergenze, poi va ripopolata )'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';
