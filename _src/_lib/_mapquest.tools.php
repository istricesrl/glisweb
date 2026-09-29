<?php

    /**
     * libreria per la geolocalizzazione tramite Mapquest
     * 
     * Questa libreria contiene le funzioni per ottenere le coordinate di un indirizzo tramite il servizio di geocoding
     * di Mapquest, con o senza cache.
     * 
     * introduzione
     * ============
     * Il framework usa Mapquest per geolocalizzare gli indirizzi: il task _src/_api/_task/_indirizzi.geocode.php prende
     * un indirizzo della tabella indirizzi, lo passa a mapquestGetCachedCoords() con la chiave del profilo corrente
     * ($cf['mapquest']['server']['key'], dichiarata in _src/_config/_520.mapquest.php) e scrive nella tabella latitudine,
     * longitudine e CAP restituiti. Ogni risposta del servizio viene aggiunta a un file di log in var/log/geocode/ il cui
     * nome è ricavato dall'indirizzo.
     * 
     * Fra i risultati restituiti da Mapquest vengono considerati solo quelli di qualità POINT, ADDRESS o STREET, e fra
     * questi viene scelto quello con il codice di confidenza migliore (si veda mapquestGetCoords()).
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni di geocoding
     * ---------------------
     * Le funzioni in questo gruppo servono per ottenere le coordinate di un indirizzo.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * mapquestGetCoords()              | restituisce le coordinate di un indirizzo interrogando Mapquest
     * mapquestGetCachedCoords()        | restituisce le coordinate di un indirizzo passando per la cache
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * restCall()                       | _src/_lib/_rest.tools.php
     * appendToFile()                   | _src/_lib/_filesystem.tools.php
     * string2rewrite()                 | _src/_lib/_rewrite.tools.php
     * logWrite()                       | _src/_lib/_log.utils.php
     * memcacheRead()                   | _src/_lib/_memcache.tools.php
     * memcacheWrite()                  | _src/_lib/_memcache.tools.php
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    /**
     * FUNZIONI DI GEOCODING
     */

    /**
     * restituisce le coordinate di un indirizzo interrogando Mapquest
     * 
     * Questa funzione compone l'indirizzo nella forma "indirizzo civico, cap città, stato", lo invia in POST all'API di
     * geocoding di Mapquest e aggiunge la risposta al log in var/log/geocode/. Fra le località restituite scarta quelle
     * con qualità diversa da POINT, ADDRESS e STREET; per le altre prende i tre caratteri di confidenza del
     * geocodeQualityCode (via, area amministrativa, CAP, ciascuno da A a X) e li riordina mettendo prima l'area
     * amministrativa, poi la via e poi il CAP, in modo che ordinando per chiave il primo risultato sia quello con la
     * città più affidabile. A parità di codice vince l'ultima località incontrata.
     * 
     * Se la chiave è vuota la funzione scrive un errore critico nel log geocode e restituisce false; se nessuna località
     * supera il filtro restituisce NULL. La risposta del servizio non viene controllata: se la chiamata fallisce e
     * $result non contiene results PHP emette dei warning e la funzione restituisce NULL.
     * 
     * @param       string      $key            la chiave API di Mapquest
     * @param       string      $civico         il numero civico
     * @param       string      $indirizzo      l'indirizzo senza civico
     * @param       string      $citta          la città
     * @param       string      $cap            il CAP (default NULL, cioè assente)
     * @param       string      $stato          lo stato (default Italia)
     * @param       string      $url            l'URL dell'API di geocoding (default quello di Mapquest v1)
     * 
     * @return      mixed                       un array con le chiavi lat, lng e cap, NULL se non ci sono risultati
     *                                          utili, false se la chiave è vuota
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
     * restituisce le coordinate di un indirizzo passando per la cache
     * 
     * Questa funzione cerca in memcache il risultato di una precedente geolocalizzazione dello stesso indirizzo, con
     * chiave MAPQUEST_ seguito dall'md5 di civico, indirizzo, città, CAP e stato; se non lo trova, o se $t è false,
     * chiama mapquestGetCoords() e scrive in cache il risultato con durata $t. Anche i risultati NULL e false vengono
     * scritti in cache, ma essendo vuoti non vengono mai considerati validi e la chiamata successiva interroga di nuovo
     * Mapquest.
     * 
     * @param       object      $m              la connessione a memcache
     * @param       string      $key            la chiave API di Mapquest
     * @param       string      $civico         il numero civico
     * @param       string      $indirizzo      l'indirizzo senza civico
     * @param       string      $citta          la città
     * @param       string      $cap            il CAP (default NULL, cioè assente)
     * @param       string      $stato          lo stato (default Italia)
     * @param       int         $t              la durata della cache in secondi (default MEMCACHE_DEFAULT_TTL, false
     *                                          per scavalcare la cache)
     * @param       string      $url            l'URL dell'API di geocoding (default quello di Mapquest v1)
     * 
     * @return      mixed                       lo stesso valore restituito da mapquestGetCoords()
     * 
     * @todo implementare
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
