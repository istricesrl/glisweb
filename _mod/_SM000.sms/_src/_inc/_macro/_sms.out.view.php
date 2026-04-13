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
        'table' => 'sms_out',
        'open'  => array( 'page' => 'sms.out.form' ),
        'data'  => array(),
        'cols'  => array(
            'id' => '#',
            'timestamp_invio' => 'invio previsto',
            'destinatari' => 'destinatari',
            'corpo' => 'corpo'
        ),
        'class' => array(
            'id' => 'd-none d-md-table-cell',
            'timestamp_invio' => 'text-left nowrap',
            'destinatari' => 'text-left nowrap',
            'corpo' => 'text-start'
        )
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // trasformazione indirizzi
	foreach( $ct['view']['data'] as $key => &$row ) {

        if( ! empty( $row['timestamp_invio'] ) ) {
            $row['timestamp_invio'] = date( 'Y-m-d H:i', $row['timestamp_invio'] );
        } else {
            $row['timestamp_invio'] = 'in uscita';
        }

        foreach( $row as $k => $v ) {
            if( in_array( $k, array( 'mittente', 'destinatari', 'destinatari_cc', 'destinatari_bcc' ) ) ) {
                $row[ $k ] = htmlentities( array2smsString( unserialize( $v ) ) );
            }
        }

    }
