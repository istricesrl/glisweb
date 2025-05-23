<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * https://tcpdf.org/examples/example_009/
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../../_src/_config.php';

    // se è specificata la tipologia di collo
    if( isset( $_REQUEST['tipo'] ) ) {

        // tipo
        $status = array( 'tipo' => $_REQUEST['tipo'] );

        // nome del tipo
        $status['tipo'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT nome FROM tipologie_colli WHERE id = ?',
            array( array( 's' => $_REQUEST['tipo'] ) )
        );

        // debug
        // var_dump( $status );
        // die( print_r( $status, true ) );

        // inizio del codice
        $status['codice'] = date('YmdHis') . '-' . $_REQUEST['tipo'];

        // se è specificata la quantità
        if( isset( $_REQUEST['qta'] ) ) {
            $status['qta'] = $_REQUEST['qta'];
        } else {
            $status['qta'] = 1;
        }

        // per la quantità richiesta, creo i colli
        for( $i = 0; $i < $status['qta']; $i++ ) {

            // parte incrementale del codice
            $incremento = str_pad( $i + 1, 4, '0', STR_PAD_LEFT );

            // codice del collo
            $status['codice_collo'] = $status['codice'] . '-' . $incremento;

            // inserisco il collo
            $status['colli'][] = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'codice' => $status['codice_collo'],
                    'id_tipologia' => $_REQUEST['tipo'],
                    'nome' => strtoupper( $status['tipo'] . ' generato automaticamente il ' . date('d/m/Y H:i:s') ),
                ),
                'colli'
            );

        }

        // status
        $status['print'] = '/print/5600.colli/etichette.colli?codice=' . $status['codice'];

    } else {

        // status
        $status = array( 'test' => 'KO', 'err' => 'tipo di collo non specificato' );

    }

    // output
    buildJson( $status );
