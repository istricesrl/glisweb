<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */


    // tabella della vista
	$ct['view']['table'] = 'progetti_scoperti';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'progetti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'progetti.scoperti.form';

    $ct['view']['insert']['page'] = '';     // non deve essere possibile inserire nuovi oggetti ma solo gestire quelli esistenti

    $ct['view']['cols'] = array(
        'id' => '#',
        'cliente' => 'cliente',
        '__label__' => 'nome',
        'data_scopertura' => 'scoperto dal'
    );

// stili della vista
$ct['view']['class'] = array(
    'id' => 'd-none d-md-table-cell',
    'cliente' => 'text-left d-none d-md-table-cell',
    '__label__' => 'text-left'
);
 

// macro di default
require DIR_SRC_INC_MACRO . '_default.view.php';

   