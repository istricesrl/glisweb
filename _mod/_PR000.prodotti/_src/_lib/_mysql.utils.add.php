<?php

    // TODO implementare
    function updateArticoliViewStatic( $id ) {

        global $cf;

        logger( 'aggiorno la view statica per l\'articolo id: ' . $id, 'articoli' );

        $articolo = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM articoli WHERE id = ?',
            array(
                array( 's' => $id )
            )
        );

        if( ! empty( $articolo['id'] ) ) {

            mysqlQuery( $cf['mysql']['connection'],
                'REPLACE INTO articoli_view_static 
                SELECT * FROM articoli_view WHERE id = ?',
                array( array( 's' => $id ) )
            );

            logger( 'view statica aggiornata per l\'articolo id: ' . $id, 'articoli' );

        } else {

            logger( 'articolo id: ' . $id . ' non trovato', 'articoli' );

        }

    }

    // TODO implementare
    function cleanArticoliViewStatic( $id = NULL ) {

        global $cf;

        if( ! empty( $id ) ) {

            mysqlQuery( $cf['mysql']['connection'],
                'DELETE FROM articoli_view_static WHERE id = ?',
                array( array( 's' => $id ) )
            );

        } else {

            return mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE articoli_view_static FROM articoli_view_static
                LEFT JOIN articoli ON articoli.id = articoli_view_static.id
                WHERE articoli.id IS NULL;'
            );
  

        }

    }

    // TODO implementare
    function emptyArticoliViewStatic() {

        global $cf;

        return mysqlQuery(
            $cf['mysql']['connection'],
            'TRUNCATE articoli_view_static'
        );

    }
