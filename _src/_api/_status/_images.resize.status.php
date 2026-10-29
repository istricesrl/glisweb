<?php

    /**
     * report della coda di scalamento delle immagini
     *
     * Stampa in testo, con gli strumenti di _src/_lib/_txt.tools.php, quattro elenchi della tabella `immagini`:
     *
     * sezione                  | righe
     * -------------------------|------------------------------------------------------------------------------------
     * immagini da scalare      | la coda del task di scalamento, con la stessa condizione che usa il task ( imageCondizioneCoda() )
     * immagini in lavorazione  | le righe marcate col token di un giro, con i minuti dalla marcatura e i giri già abbandonati
     * immagini non scalabili   | le righe col token `NON_SCALABILE` ( SVG, PDF, file che non sono immagini )
     * immagini ferme           | le righe col token `TROPPI_TENTATIVI`, che riparte solo lo scalamento forzato
     *
     * Una riga in lavorazione da più di `$cf['image']['minuti_sblocco']` minuti è di un giro morto a metà, e il task la
     * sblocca al giro successivo. Fino al 2026-10-30 il report leggeva la vista `__report_immagini_da_scalare__`, che non
     * esisteva più, e non mostrava le righe bloccate, cioè proprio quelle che fermano la coda.
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

    // coda
	$dati['coda'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT id, path, from_unixtime( timestamp_scalamento ) AS scalata, from_unixtime( timestamp_aggiornamento ) AS aggiornata '.
	    'FROM immagini WHERE ' . imageCondizioneCoda() . ' ORDER BY timestamp_scalamento ASC, ordine ASC'
	);

    // righe in lavorazione
	$dati['lavorazione'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT id, path, coalesce( round( ( unix_timestamp() - timestamp_elaborazione ) / 60 ), \'n.d.\' ) AS minuti, tentativi '.
	    'FROM immagini WHERE token IS NOT NULL AND token NOT IN ( ?, ? ) ORDER BY timestamp_elaborazione ASC',
	    array( array( 's' => 'NON_SCALABILE' ), array( 's' => 'TROPPI_TENTATIVI' ) )
	);

    // righe non scalabili
	$dati['non_scalabili'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT id, path FROM immagini WHERE token = ? ORDER BY id ASC',
	    array( array( 's' => 'NON_SCALABILE' ) )
	);

    // righe ferme per troppi tentativi
	$dati['ferme'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT id, path, tentativi FROM immagini WHERE token = ? ORDER BY id ASC',
	    array( array( 's' => 'TROPPI_TENTATIVI' ) )
	);

    // header
	buildContentHeader();

    // sezioni del report
	foreach( array(
	    'coda' => array( 'immagini da scalare', array( 'id' => 8, 'path' => 33, 'scalata' => 20, 'aggiornata' => 20 ) ),
	    'lavorazione' => array( 'immagini in lavorazione', array( 'id' => 8, 'path' => 53, 'minuti' => 10, 'tentativi' => 10 ) ),
	    'non_scalabili' => array( 'immagini non scalabili', array( 'id' => 8, 'path' => 73 ) ),
	    'ferme' => array( 'immagini ferme per troppi tentativi', array( 'id' => 8, 'path' => 63, 'tentativi' => 10 ) )
	) as $sezione => $intestazione ) {

	    // intestazione della sezione
	    echo txtHeader( $intestazione[0] . ' (' . count( (array) $dati[ $sezione ] ) . ')' );

	    // corpo della sezione
	    if( ! empty( $dati[ $sezione ] ) ) {
		echo txtTable( $intestazione[1], $dati[ $sezione ] );
	    }

	}

    // chiusura report
	echo txtDateTimeLine( '=' );

    // chiusura report
	echo 'righe in coda: ' . count( (array) $dati['coda'] ) . PHP_EOL;
	echo 'report generato in ' . timerDiff( $start ) . ' secondi' . PHP_EOL . PHP_EOL;

    // note
	echo txtText(
	    'NOTA la coda è quella del task di scalamento ( /task/IM000.immagini/images.resize ): le immagini mai scalate e '.
	    'quelle aggiornate dopo l\'ultimo scalamento, che nessun giro sta lavorando. Una riga in lavorazione da più di '.
	    $cf['image']['minuti_sblocco'] . ' minuti è di un giro morto a metà: il task la sblocca al giro successivo e conta '.
	    'il tentativo; dopo ' . $cf['image']['tentativi_massimi'] . ' tentativi la ferma, e la fa ripartire lo scalamento '.
	    'forzato dalla scheda dell\'immagine.' . PHP_EOL . PHP_EOL .
	    'NOTA se questa coda è bloccata, probabilmente il cron è fermo oppure lo script di shell chiamato da cron non riesce '.
	    'a raggiungere il web service di schedulazione del framework; è anche possibile che sia bloccato il token '.
	    'sulla tabella cron.'
	);
