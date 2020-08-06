<?php

    /**
     * individuazione del sito corrente
     *
     * questo file si occupa di determinare il sito corrente fra quelli gestiti dall'installazione corrente
     * a partire dall'URL
     *
     * strategie di individuazione del sito
     * ====================================
     * Il sito corrente viene determinato a partire dall'URL corrente, che viene confrontato con i domini, gli host,
     * i protocolli e gli alias dichiarati nell'array $cf['sites']. Se non viene trovata alcuna corrispondenza, il
     * sito corrente rimane quello di default (vedi sotto) impostato in _src/_config/_010.site.php, eventualmente
     * customizzato.
     *
     * la costante SITE_DEFAULT
     * ------------------------
     * Questa costante contiene l'ID del sito di default, che viene utilizzato nel caso non venga riscontrata alcuna
     * corrispondenza fra l'URL corrente e i dati dichiarati in $cf['sites'].
     *
     * la costante SITE_CURRENT
     * ------------------------
     * Questa costante contiene l'ID del sito corrente, così come identificato tramite l'analisi dell'URL, oppure
     * viene valorizzata a SITE_DEFAULT se l'analisi dell'URL non ha dato corrispondenze con i dati contenuti in $cf['sites'].
     *
     * l'array $cf['site']
     * ===================
     * Le variabili del ramo 'site' definiscono in generale il sito corrente. Si veda la
     * \ref variabili "sezione della documentazione dedicata alle variabili" per il dettaglio delle chiavi di $cf['site'],
     * in questa sede è solo necessario sottolineare che questo array contiene tutti i dati di configurazione del
     * sito corrente.
     *
     * licenza commerciale
     * -------------------
     * Il framework GlisWeb è totalmente Open Source e gratuito, e lo rimarrà sempre. La presenza di una licenza commerciale
     * non comporta differenze nel codice, nelle funzionalità o in qualsiasi altro aspetto del framework, ma dà semplicemente
     * accesso all'assistenza di Fabio Mosti <fabio.mosti@istricesrl.it> e degli sviluppatori di Istrice srl che si occupano
     * di manutenere e aggiornare il software. Se siete titolari di una licenza commerciale, potete inviare le vostre richieste
     * di assistenza all'ufficio Produzione di Istricesrl <produzione@istricesrl.it>; mentre se non disponete di una licenza
     * commerciale e siete interessati a procurarvene una potete diventare nostri sostenitori su GitHub (all'indirizzo
     * https://github.com/istricesrl/glisweb) oppure contattare l'ufficio Commerciale di Istrice srl <commerciale@istricesrl.it>.
     *
     *
     *
     * @todo visto che la licenza è per deploy (non per sito) dovrebbe essere $cf['license'] e non $cf['site']['license']
     * @todo verificare se dietro proxy serve di considerare X-FORWARDED-FOR anziché HTTP_HOST https://stackoverflow.com/questions/11452938/how-to-use-http-x-forwarded-for-properly
     * @todo documentare FILE_STATUS
     * @todo finire di documentare
     *
     * @file
     *
     */

    // multisito di default
	if( ! defined( 'SITE_DEFAULT' ) ) {
	    define( 'SITE_DEFAULT'		, 1 );
	}

    // cerco di ricavare il sito corrente dal dominio
	foreach( $cf['sites'] as $id => &$site ) {

	    // assegno l'id del sito corrente alla chiave 'id'
		$site['id'] = $id;

	    // ciclo sugli stati del sito
		foreach( $site['domains'] as $status => $domain ) {

		    // se c'è un dominio per questo status
			if( ! empty( $domain ) ) {

			    // debug
				// echo $id . '->';
				// echo $status . '->' . $domain . PHP_EOL;
				// echo $domain .' -> ' . $_SERVER['HTTP_HOST'] . PHP_EOL;

			    // inizializzazioni
				$hosts = $domains = array();

			    // per lo stato corrente, verifico se c'è un host specificato
				if( isset( $site['hosts'][ $status ] ) ) {
				    $hosts[] = $site['hosts'][ $status ];
				}

			    // per lo stato corrente, verifico se ci sono degli alias di host
				if( isset( $site['alias']['hosts'][ $status ] ) ) {
				    $hosts = array_merge( $hosts, $site['alias']['hosts'][ $status ] );
				}

			    // per lo stato corrente, aggiungo il domain
				$domains[] = $site['domains'][ $status ];

			    // per lo stato corrente, verifico se ci sono degli alias di domain
				if( isset( $site['alias']['domains'][ $status ] ) ) {
				    $domains = array_merge( $domains, $site['alias']['domains'][ $status ] );
				}

			    // numeratore host in base a www
				if( in_array( 'www', $hosts ) ) {
				    $numerator = '{0,1}';
				} else {
				    $numerator = '{1}';
				}

			    // regola di match per i domini
				$drule = str_replace( '.', '\.', implode( '|', $domains ) );

			    // regola di match per gli host
				$hrule = implode( '|', $hosts );

			    // composizione dell'espressione regolare
				$regex = '/^(?:' . $hrule . ')' . $numerator . '(?:\.)*(' . $drule . '){1}/';

			    // debug
				// echo $regex .' -> ' . $_SERVER['HTTP_HOST'] . PHP_EOL;

			    // espressione regolare
				if( preg_match( $regex, $_SERVER['HTTP_HOST'] ) === 1 ) {
				    if( ! defined( 'SITE_CURRENT' ) ) {
					// echo 'MATCH (' . $status . ') -> ' . $_SERVER['HTTP_HOST'] . PHP_EOL;
					define( 'SITE_CURRENT', $id ); 
					$cStatus = $status;
				    }
				}

			}

		}

	}

    // multisito corrente
	if( ! defined( 'SITE_CURRENT' ) ) {
	    define( 'SITE_CURRENT'		, SITE_DEFAULT );
	}

    // link al sito corrente
	$cf['site']				= &$cf['sites'][ SITE_CURRENT ];

    // status del sito
	if( isset( $cStatus ) ) {
	    $cf['site']['status']		= $cStatus;
	} elseif( file_exists( FILE_STATUS ) ) {
	    $cf['site']['status']		=  readStringFromFile( FILE_STATUS );
	} else {
	    $cf['site']['status']		= TESTING;
	}

    // licenza commerciale
	if( file_exists( FILE_LICENSE ) ) {
	    $cf['license']['key']		= trim( readStringFromFile( FILE_LICENSE ) );
	} else {
	    $cf['license']['key']		= NULL;
	}

    // status del sito
	define( 'SITE_STATUS'			, $cf['site']['status'] );

    // debug
	// die( 'host: ' . $_SERVER['HTTP_HOST'] );
	// print_r( $cf['site'] );

?>
