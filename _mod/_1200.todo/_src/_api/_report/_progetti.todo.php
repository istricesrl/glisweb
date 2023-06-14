<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../../../_src/_config.php';

    // impostazioni del timer
	$t = 'report todo per progetto';

    // timer
	$start = timerNow();

    // header
    buildContentHeader();

    // ...
    if( isset( $_REQUEST['idProgetto'] ) ) {

        // progetto
        $proj = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM progetti WHERE id = ?', array( array( 's' => $_REQUEST['idProgetto'] ) ) );

        // dati
        $dati = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM todo WHERE id_progetto = ? AND data_chiusura IS NULL', array( array( 's' => $_REQUEST['idProgetto'] ) ) );

        // intestazione report
        echo txtHeader( $proj['nome'] );

    } else {

        // dati
        $dati = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM todo WHERE data_chiusura IS NULL ORDER BY id_progetto' );
        
        // intestazione report
        echo txtHeader( 'stato generale delle cose da fare' );

    }

#        // chiusura report
#        echo txtLine( '=' );

        // elenco delle todo
        foreach( $dati AS $key => $dato ) {

            echo PHP_EOL;
            echo PHP_EOL;

            if( ! isset( $_REQUEST['idProgetto'] ) ) {
                // if( ! isset( $proj ) || ( isset( $proj['id'] ) && $proj['id'] != $dato['id_progetto'] ) ) {
                    $proj = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM progetti WHERE id = ?', array( array( 's' => $dato['id_progetto'] ) ) );
                // }
                # echo txtSubtitle( $proj['nome'] );
                if( isset( $proj['nome'] ) ) {
                    echo txtFullText( '###' . ' ' . $proj['nome'] );
                } else {
                    echo txtFullText( '### nessun progetto' );
                }
            }

#            echo txtSubtitle( '#' . $dato['id'] . ' ' . $dato['nome'] );
            echo txtFullText( '#' . $dato['id'] . ' ' . $dato['nome'] );
#            echo txtFullText( $dato['testo'] );
            foreach( explode( "\n", trim( $dato['testo'] ) ) as $todo ) {
                echo txtFullText( $todo );
            }

            echo PHP_EOL;
            echo PHP_EOL;

            if( $key === array_key_last( $dati ) ) {
                echo txtDateTimeLine( '=' );
            } else {
                echo txtFullLine();
            }

        }

/*
        // corpo del report
        if( count( $dati ) ) {
            echo txtTable(
            array( 'path' => 41, 'timestamp_scalamento' => 20, 'timestamp_aggiornamento' => 20 ),
            $dati,
            array( 'path' => 'immagine', 'timestamp_scalamento' => 'scalata', 'timestamp_aggiornamento' => 'aggiornata' )
            );
        }

        // chiusura report
        echo txtDateTimeLine( '=' );

        // chiusura report
        echo 'righe trovate: ' . count( $dati ) . PHP_EOL;
        echo 'report generato in ' . timerDiff( $start ) . ' secondi' . PHP_EOL . PHP_EOL;

        // note
        echo txtText(
            'NOTA questo report rappresenta gli stessi dati su cui ragiona lo schedulatore di ridimensionamento delle immagini. '.
            'Vengono scalate le immagini che non hanno data/ora di scalamento e le immagini che hanno data/ora di aggiornamento '.
            'successiva a quella di scalamento.' . PHP_EOL . PHP_EOL .
            'NOTA se questa coda è bloccata, probabilmente il cron è fermo oppure lo script di shell chiamato da cron non riesce '.
            'a raggiungere il web service di schedulazione del framework; è anche possibile che sia bloccato il token '.
            'sulla tabella cron.'
        );
*/
        // debug
        // timer_debug( $t );
        // print_r( $dati );
