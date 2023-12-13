<?php

    /**
     * 
     * 
     * 
     * 
     * 
     */

/*
    // ...
    if( isset( $_SESSION['static'] ) && is_array( $_SESSION['static'] ) ) {
        foreach( $_SESSION['static'] as $table => $data ) {
            foreach( $rows as $id => $details ) {

                // ...
                $view = $table . '_static';

                // ...
                logWrite( 'aggiorno la view statica ' . $view . ' per id #' . $id . ' (' . print_r( $details ) . ')', 'static' );

                // ...
                if( isset( $details['field'] ) ) {
                    $row = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM ' . $table . ' WHERE ' . $details['field'] . ' = ?', array( array( 's' => $id ) ) );
                } else {
                    // TODO implementare il caso delle view statiche alimentate da una funzione PHP
                }

                // ...
                if( ! empty( $row ) ) {
                    mysqlInsertRow( $cf['mysql']['connection'], $row, $view );
                } else {
                    mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM ' . $view . ' WHERE ' . $details['field'] . ' = ?', array( array( 's' => $id ) ) );
                }

            }
        }
    }
*/
