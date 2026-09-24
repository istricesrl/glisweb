<?php

	require '../../../../_src/_config.php';

    $status = array( 'status' => 'KO' );

    if( isset( $_REQUEST['id_corso'] ) ) {
        if( isset( $_REQUEST['data'] ) ) {

            $status['status'] = 'OK';

            $status['lezioni'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM __report_lezioni_corsi__ WHERE id_progetto = ?',
                array(
                    array(
                        's' => $_REQUEST['id_corso']
                    )
                )
            );

            $status['totale_lezioni'] = count( $status['lezioni'] );

            $status['lezioni_rimanenti'] = array_filter(
                $status['lezioni'],
                function( $lezione ) {
                    return strtotime( $lezione['data_programmazione'] ) >= strtotime( $_REQUEST['data'] );
                }
            );

            $status['totale_lezioni_rimanenti'] = count( $status['lezioni_rimanenti'] );

        }
    }

    buildJson($status);
