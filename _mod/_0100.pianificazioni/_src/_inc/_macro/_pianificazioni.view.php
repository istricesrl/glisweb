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
    $ct['view']['table'] = 'pianificazioni';
    
    // id della vista
  #  $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pianificazioni.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'entita' => 'entità',
        'nome' => 'pianficazione',
        'data_avvio' => 'attiva dal',
        'data_inizio' => 'primo oggetto',
        'giorni_elaborazione' => 'crea oggetti per'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left'
    );

    // tendina delle entita che è possibile gestire
    $ct['etc']['select']['entita'] = array(
        array( 'id' => 'turni', '__label__' => 'turni' )
    );
    
    // inclusione filtri speciali
//	$ct['etc']['include']['filters'] = 'inc/pianificazioni.view.filters.html';
 
    // ...
    $ct['view']['__restrict__']['id_genitore']['NL'] = true;

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
    if( ! empty( $ct['view']['data'] ) && is_array( $ct['view']['data'] ) ) {
        foreach( $ct['view']['data'] as &$row ) {
            $row['giorni_elaborazione'] = ( ! empty( $row['giorni_elaborazione'] ) ) ? $row['giorni_elaborazione'] . 'gg' : '-';
        }
    }
