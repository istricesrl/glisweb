<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tendina sesso
	$ct['etc']['select']['confronti'] = array( 
	    array( 'id' => 'NESSUNO', '__label__' => 'nessun confronto' ),
	    array( 'id' => 'PERIODO', '__label__' => 'periodo precedente' ),
	    array( 'id' => 'ANNO', '__label__' => 'anno precedente' ),
	);

    // tendina sesso
	$ct['etc']['select']['precisioni'] = array( 
	    array( 'id' => 'GIORNO', '__label__' => 'giorno' ),
	    array( 'id' => 'SETTIMANA', '__label__' => 'settimana' ),
	    array( 'id' => 'MESE', '__label__' => 'mese' ),
	    array( 'id' => 'ANNO', '__label__' => 'anno' ),
	);

    // array mesi
	switch( $_REQUEST['__stats__']['__precisione__'] ) {

		case 'GIORNO';
			$u = 'day';
			$d = 'd-m-Y';
			$f = '%d';
			$m = '%d-%m-%Y';
			$j = '%d';
		break;

		case 'SETTIMANA':
			$u = 'week';
			$d = 'W-Y';
			$f = '%V';
			$m = '%u-%Y';
			$j = '%u';
		break;

		case 'MESE':
			$u = 'month';
			$d = 'm-Y';
			$f = '%B';
			$m = '%m-%Y';
			$j = '%B';
		break;

		case 'ANNO':
			$u = 'year';
			$d = 'Y';
			$f = '%Y';
			$m = '%Y';
			$j = '%Y';
		break;

	}

	// var_dump( $u );
	// var_dump( $d );
	// var_dump( $f );

	$ts = strtotime( $_REQUEST['__stats__']['__inizio__'] );
	$fine = false;

	do {
		$dataCorrente = date( 'Y-m-d', $ts );
		// $ct['data']['labels'][ date( $d, $ts ) ] = strftime( $f, $ts );
		if( $dataCorrente < $_REQUEST['__stats__']['__fine__'] ) {
			$ct['data']['labels'][ date( $d, $ts ) ] = date( $d, $ts );
			$ct['data']['grafico']['corrente'][ date( $d, $ts ) ] = $ds['corrente'][ strftime( $f, $ts ) ] = array( 'value' => 0 );
			$ts = strtotime( '+1 ' . $u, $ts );
		} else {
			$fine = true;
		}
	} while( $fine === false );
