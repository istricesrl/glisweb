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
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = 'mail_out';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'mail.out.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'data_ora_invio' => 'invio previsto',
	    'destinatari' => 'destinatari',
	    'destinatari_cc' => 'destinatari CC',
	    'destinatari_bcc' => 'destinatari BCC',
	    '__label__' => 'oggetto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'data_ora_invio' => 'text-left',
	    'destinatari' => 'text-left',
	    'destinatari_cc' => 'text-left',
	    'destinatari_bcc' => 'text-left',
	    '__label__' => 'text-left'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione indirizzi
	foreach( $ct['view']['data'] as $key => &$row ) {
        foreach( $row as $k => $v ) {
            if( in_array( $k, array( 'mittente', 'destinatari', 'destinatari_cc', 'destinatari_bcc' ) ) ) {
                $row[ $k ] = htmlentities( array2mailString( unserialize( $v ) ) );
            }
        }
	}
