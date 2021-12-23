<?php

    /**
     * macro form cartellini
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
	$ct['form']['table'] = 'cartellini';
    
     // tabella della vista
	$ct['view']['table'] = 'righe_cartellini';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'righe.cartellini.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'data_attivita' => 'data',
        'ore_fatte' => 'ore fatte',
        'ore_previste' => 'ore previste',
        'id_cartellino' => 'id_cartellino',
        'tipologia_inps' => 'tipologia_inps',
        '__label__' => 'stato'
    );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
        'id_cartellino' => 'd-none'
    );
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'attivita.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_cartellino';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_cartellino']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
            if(!empty($row['data_programmazione'])){$row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione']));}

            if(!empty($row['data_attivita'])){$row['data_attivita'] = date('d/m/Y', strtotime($row['data_attivita']));}
            if( !empty( $row['ore_previste'] ) && !empty(  $row['ore_fatte'] )  ){

                if(  $row['ore_previste'] != $row['ore_fatte']   ){
                    $row['__label__'] = '<i class="fa fa-check" style="padding-left: 8px;" aria-hidden="true"></i>';
                } else {
                    $row['__label__'] = '<i class="fa fa-exclamation-triangle" style="padding-left: 8px;" aria-hidden="true"></i>';
                }

            } else {
                $row['__label__'] = '';
            }
		}
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
