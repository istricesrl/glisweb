<?php

    // TODO implementare
    function updateAttivitaViewStatic( $id ) {

        global $cf;

        $attivita = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM attivita WHERE id = ?',
            array(
                array( 's' => $id )
            )
        );

        $todo = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM todo WHERE id = ?',
            array(
                array( 's' => $attivita['id_todo'] )
            )
        );

        if( empty( $attivita['data_programmazione'] ) ) {
            $attivita['data_programmazione'] = $todo['data_programmazione'];
        }

        if( empty( $attivita['ora_inizio_programmazione'] ) ) {
            $attivita['ora_inizio_programmazione'] = $todo['ora_inizio_programmazione'];
        }

        if( empty( $attivita['ora_fine_programmazione'] ) ) {
            $attivita['ora_fine_programmazione'] = $todo['ora_fine_programmazione'];
        }

        $attivita['data_riferimento'] = ( ( ! empty( $attivita['data_attivita'] ) ) ? $attivita['data_attivita'] : $attivita['data_programmazione'] );
/*
        mysqlInsertRow(
            $cf['mysql']['connection'],
            $attivita,
            'attivita'
        );
*/
        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO attivita ( id, data_programmazione, ora_inizio_programmazione, ora_fine_programmazione ) VALUES ( ?, ?, ?, ? ) ON DUPLICATE KEY UPDATE data_programmazione = ?, ora_inizio_programmazione = ?, ora_fine_programmazione = ?',
            array(
                array( 's' => $id ),
                array( 's' => $attivita['data_programmazione'] ),
                array( 's' => $attivita['ora_inizio_programmazione'] ),
                array( 's' => $attivita['ora_fine_programmazione'] ),
                array( 's' => $attivita['data_programmazione'] ),
                array( 's' => $attivita['ora_inizio_programmazione'] ),
                array( 's' => $attivita['ora_fine_programmazione'] )
            )
        );

        mysqlQuery( $cf['mysql']['connection'],
            'REPLACE INTO attivita_view_static SELECT * FROM attivita_view WHERE id = ?',
            array( array( 's' => $id ) )
        );

    }

    // TODO implementare
    function cleanAttivitaViewStatic( $id = NULL ) {

        global $cf;

        if( ! empty( $id ) ) {

            mysqlQuery( $cf['mysql']['connection'],
                'DELETE FROM attivita_view_static WHERE id = ?',
                array( array( 's' => $id ) )
            );

        } else {

            return mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE attivita_view_static FROM attivita_view_static
                LEFT JOIN attivita ON attivita.id = attivita_view_static.id
                WHERE attivita.id IS NULL;'
            );
  

        }

    }
