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
     * TODO finire di documentare
     *
     * 
     *
     */

    $ct['view'] = array(
        'table' => 'mail_sent',
        'open'  => array( 'page' => 'mail.sent.form' ),
        'data'  => array(),
        'cols'  => array(
            'id' => '#',
            'timestamp_invio' => 'invio',
            'destinatari' => 'destinatari',
            'destinatari_cc' => 'CC',
            'destinatari_bcc' => 'BCC',
            'oggetto' => 'oggetto'
        ),
        'class' => array(
            'id' => 'd-none d-md-table-cell',
            'timestamp_invio' => 'text-left',
            'destinatari' => 'text-left',
            'destinatari_cc' => 'text-left',
            'destinatari_bcc' => 'text-left',
            'oggetto' => 'text-left'
        )
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // trasformazione indirizzi
	foreach( $ct['view']['data'] as $key => &$row ) {

        // NOTA fra gli inviati la data manca solo se il task di invio non è riuscito a scriverla dopo la copia: la riga
        // è partita, e "in uscita" come nella coda sarebbe sbagliato ( fino al 2026-09-30 )
        if( ! empty( $row['timestamp_invio'] ) ) {
            $row['timestamp_invio'] = date( 'Y-m-d H:i', $row['timestamp_invio'] );
        } else {
            $row['timestamp_invio'] = 'data non registrata';
        }

        foreach( $row as $k => $v ) {
            if( in_array( $k, array( 'mittente', 'destinatari', 'destinatari_cc', 'destinatari_bcc' ) ) ) {
                $row[ $k ] = htmlentities( array2mailString( unserialize( $v ) ) );
            }
        }

    }
