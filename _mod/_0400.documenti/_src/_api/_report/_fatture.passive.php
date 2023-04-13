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
	$t = 'report fatture passive';

    // timer
	$start = timerNow();

	// inizializzazione
	$dati = array();
	$aziende = mysqlSelectColumn( 'codice_archivium', $cf['mysql']['connection'], 'SELECT DISTINCT codice_archivium FROM anagrafica WHERE codice_archivium IS NOT NULL' );

	// debug
	// print_r( $aziende );

    // dati
	foreach( $aziende as $azienda ) {
		$dati = array_merge(
			$dati,
			archiviumGetListaFePassive( $azienda, 0, 'ID=ASC', 'RIGHT', 'DataFattura=' . date( 'Y' ) )
		);
	}

	// debug
	// print_r( $dati );

    // header
	buildContentHeader();

    // intestazione report
	echo txtHeader( 'report fatture elettroniche passive' );

    // corpo del report
	if( count( $dati ) ) {
	    echo txtTable(
		array( 'DataFattura' => 12, 'NumeroFattura' => 16, 'RagSocMit' => 40, 'Importo' => 12 ),
		$dati,
		array( 'DataFattura' => 'data', 'NumeroFattura' => 'numero', 'RagSocMit' => 'fornitore', 'Importo' => 'totale' ),
		NULL,
		array( 'Importo' => STR_PAD_LEFT )
	    );
	}

    // chiusura report
	echo txtDateTimeLine( '=' );

    // chiusura report
	echo 'righe trovate: ' . count( $dati ) . PHP_EOL;
	echo 'report generato in ' . timerDiff( $start ) . ' secondi' . PHP_EOL . PHP_EOL;

    // debug
	// timer_debug( $t );
	// print_r( $dati );
