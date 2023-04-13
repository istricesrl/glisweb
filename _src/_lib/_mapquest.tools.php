<?php

    /**
     * libreria per la geolocalizzazione tramite Mapquest
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     *
     *
     * @todo documentare
     *
     */
    function mapquestGetCoords( $key, $civico, $indirizzo, $citta, $cap = NULL, $stato = 'Italia', $url = 'http://www.mapquestapi.com/geocoding/v1/address' ) {

		// die( print_r( array( $key, $civico, $indirizzo, $citta, $cap, $stato, $url ), true ) );

	    if( ! empty( $key ) ) {

		    $result = restCall(
				$url . '?key=' . $key,
				METHOD_POST,
				array(
				    'location' => $indirizzo . ' ' . $civico . ', ' . $cap . ' ' . $citta . ', ' . $stato
				)
		    );

		    // die( print_r( $result, true ) );

		    // writeToFile( $key . PHP_EOL . print_r( $result, true ), 'var/log/mapquest/' . string2urlRewrite( $civico . ', ' . $indirizzo . ', ' . $citta . ', ' . $stato ) . '.log' );

            // log
            appendToFile(
                '-- ' . date( 'Y-m-d H:i' ) . PHP_EOL . print_r( $result, true ) . PHP_EOL,
                'var/log/geocode/' . string2rewrite( implode( ' ', array(
                    $stato,
                    $citta,
                    $indirizzo,
                    $civico
                ) ) ) . '.log'
            );

		    // TODO qui loggare in caso di problemi

		    foreach( $result['results'][0]['locations'] as $location ) {
			if( $location['geocodeQuality'] == 'POINT' || $location['geocodeQuality'] == 'ADDRESS' || $location['geocodeQuality'] == 'STREET' ) {
#			if( $location['geocodeQuality'] == 'POINT' || $location['geocodeQuality'] == 'ADDRESS' ) {
				$qString = substr( $location['geocodeQualityCode'], 2, 3 );
				$qArray = str_split( $qString );
			    $qResults[ $qArray[1] . $qArray[0] . $qArray[2] ] = $location;
			}
		    }

		    if( ! empty( $qResults ) ) {

			ksort( $qResults );

			// die( print_r( $qResults, true ) );

			$bResult = array_shift( $qResults );

			// die( print_r( $bResult, true ) );

			// return $result['results'][0]['locations'][0]['latLng'];
			return array_merge( $bResult['latLng'], array( 'cap' => $bResult['postalCode'] ) );

		    } else {

			return NULL;

		    }

	    } else {

		logWrite( 'nessuna chiave Mapquest impostata per lo stage corrente', 'geocode', LOG_CRIT );

		return false;

	    }

    }

    /**
     *
     *
     *
     * @todo implementare
     * @todo documentare
     *
     */
    function mapquestGetCachedCoords( $m, $key, $civico, $indirizzo, $citta, $cap = NULL, $stato = 'Italia', $t = MEMCACHE_DEFAULT_TTL, $url = 'http://www.mapquestapi.com/geocoding/v1/address' ) {

	// calcolo la chiave della query
	    $k = 'MAPQUEST_' . md5( $civico . $indirizzo . $citta . $cap . $stato );

	// cerco il valore in cache
	    $r = memcacheRead( $m, $k );

	// se il valore non è stato trovato
	    if( empty( $r ) || $t === false ) {
		$r = mapquestGetCoords( $key, $civico, $indirizzo, $citta, $cap, $stato, $url );
			memcacheWrite( $m, $k, $r, $t );
	    }

	// restituisco il risultato
	    return $r;

    }
