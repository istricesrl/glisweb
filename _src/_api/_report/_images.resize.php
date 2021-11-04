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
	require '../../_config.php';

    // impostazioni del timer
	$t = 'report immagini da scalare';

    // timer
	$start = timerNow();

    // dati
	$dati = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM __report_immagini_da_scalare__' );

    // header
	buildContentHeader();

    // intestazione report
	echo txtHeader( 'report immagini da scalare (' . count( $dati ) . ')' );

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

    // debug
	// timer_debug( $t );
	// print_r( $dati );
