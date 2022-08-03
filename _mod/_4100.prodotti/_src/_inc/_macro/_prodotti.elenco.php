<?php

/**
 *
 *
 *
 *
 * @file
 *
 */

// seleziono le sottocategorie
if( isset( $cf['contents']['page']['metadata']['id_categoria_prodotti'] ) && ! empty($cf['contents']['page']['metadata']['id_categoria_prodotti'] ) ) {

/*
	// cerco le categorie fra i figli della pagina
	foreach( $cf['contents']['page']['children']['id'] as $child ) {
		if( isset( $cf['contents']['pages'][ $child ]['metadata']['id_prodotto'] ) ) {
			$cf['contents']['page']['contents']['prodotti'][] = $child;

		} else {
			print_r( $cf['contents']['pages'][ $child ]['metadata'] );
		}


	}
*/

	/*
	// parametri di base
	$params = array(
		#1			array( 's' => $ct['page']['metadati']['id_categoria_prodotti'] ),
		#1			array( 's' => $cf['localization']['language']['id'] )
		array('s' => $cf['localization']['language']['id']),
		array('s' => $cf['contents']['page']['metadata']['id_categoria_prodotti'])
	);

	// impostazioni di base
	$perpg = 50;
	$filters = array();
	$order = $orders = array();

	// ordinamento di default
	if (empty($orders)) {
		$orders = array('prodotti_categorie.ordine' => 'ASC');
	}

	// paginazione (SDF modificato $_REQUEST['pg'] in $_REQUEST['__curpg__'] per uniformità con documentazione
	if (isset($_REQUEST['__curpg__'])) {
		$pg = $_REQUEST['__curpg__'] * $perpg;
	} else {
		$pg = $_REQUEST['__curpg__'] = 0;
	}


	// congiunzione
	if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['__inclusivo__'])) {
		$conj = ' OR ';
	} else {
		$conj = ' AND ';
	}

	// filtro larghezza/lunghezza inclusivo
	if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['__inclusivo__'])) {

		if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max']) && !empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max'])) {
			if (!isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max']) || empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max'])) {
				$_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max'] = $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max'];
			}
		}

		if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max']) && !empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max'])) {
			if (!isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max']) || empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max'])) {
				$_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max'] = $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max'];
			}
		}

		if (!empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max']) && !empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max'])) {
			$filters = array('( ( larghezza_prodotto <= ? AND lunghezza_prodotto <= ? ) OR ( larghezza_prodotto <= ? AND lunghezza_prodotto <= ? ) )');
			$params[] = array('s' => $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max']);
			$params[] = array('s' => $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max']);
			$params[] = array('s' => $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max']);
			$params[] = array('s' => $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max']);
			$orders = array('somma_dimensioni' => 'DESC');
		}
	} else {

		// filtro larghezza
		if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max'])) {
			if (!empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max'])) {
				$filters[] = ' larghezza_prodotto <= ? ';
				$params[] = array('s' => $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['larghezza_max']);
			}
		}

		// filtro lunghezza
		if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max'])) {
			if (!empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max'])) {
				$filters[] = ' lunghezza_prodotto <= ? ';
				$params[] = array('s' => $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['lunghezza_max']);
			}
		}
	}



	// SDF filtro per marchio
	if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['marchio'])) {

		$marchi_richiesti = array();
		foreach ($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['marchio'] as $idmarchio => $marchio) {
			if ($marchio == 1) {
				$marchi_richiesti[] = $idmarchio;
			}
		}

		if (count($marchi_richiesti)) {
			$cond = array();
			foreach ($marchi_richiesti as $marchio_richiesto) {
				$cond[] = ' prodotti.id_marchio = ? ';
				$params[] = array('s' => $marchio_richiesto);
			}
			$filters[] = ' (' . implode(' OR ', $cond) . ') ';
		}
	}

	// SDF filtro per taglia
	if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['taglia'])) {
		$taglie_richieste = array();
		foreach ($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['taglia'] as $idtaglia => $taglia) {
			if ($taglia == 1) {
				$taglie_richieste[] = $idtaglia;
			}
		}

		if (count($taglie_richieste)) {
			$cond = array();
			foreach ($taglie_richieste as $taglia_richiesta) {
				$cond[] = ' articoli.id_taglia = ? ';
				$params[] = array('s' => $taglia_richiesta);
			}
			$filters[] = ' (SELECT count(*) as numArt FROM articoli where id_prodotto = prodotti.id AND (' . implode(' OR ', $cond) . '))';
		}
	}


	// SDF filtro per categoria
	if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['categoria'])) {
		$categorie_richieste = array();
		foreach ($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__filters__']['categoria'] as $idcategoria => $categoria) {
			if ($categoria == 1) {
				$categorie_richieste[] = $idcategoria;
			}
		}

		if (count($categorie_richieste)) {
			$cond = array();
			foreach ($categorie_richieste as $categoria_richiesta) {
				$cond[] = ' prodotti_categorie.id_categoria = ? ';
				$params[] = array('s' => $categoria_richiesta);
			}
			$filters[] = ' (' . implode(' OR ', $cond) . ') ';
		}
	}

	// filtro generico
	if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__search__'])) {
		if (!empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__search__'])) {
			foreach (explode(' ', $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__search__']) as $tks) {
				$like = "%${tks}%";
				$cond = array();
				foreach (array('prodotti.id', 'contenuti.title', 'contenuti.h1', 'contenuti.h2', 'contenuti.abstract', 'contenuti.testo') as $field) {
					$cond[] = $field . ' LIKE ?';
					$params[] = array('s' => $like);
				}
				$filters[] = ' (' . implode(' OR ', $cond) . ') ';
			}
		}
	}

	// ordinamento per prezzo
	if (isset($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__sort__']['prezzo'])) {
		if (!empty($_SESSION['__view__']['__pages__'][$ct['page']['id']]['__sort__']['prezzo'])) {
			$orders['prezzi.prezzo'] = $_SESSION['__view__']['__pages__'][$ct['page']['id']]['__sort__']['prezzo'];
		}
	}

	// ordinamento per dimensioni
	// TODO

	// ordinamento
	foreach ($orders as $fld => $ord) {
		$order[] = $fld . '  ' . $ord;
	}

	// query di recupero prodotti della pagina
	$q = 'SELECT SQL_CALC_FOUND_ROWS prodotti.id, contenuti.title, contenuti.h1, contenuti.h2, contenuti.cappello, contenuti.abstract, '
		. 'immagini.path AS immagine, contenuti_immagine.cappello AS didascalia, '
		. '( prodotti.larghezza_prodotto + prodotti.lunghezza_prodotto ) AS somma_dimensioni, '
		. 'concat( "CATEGORIE.PRODOTTI.' . $cf['contents']['page']['metadata']['id_categoria_prodotti'] . '.PRODOTTI.", prodotti.id ) AS id_pagina, '
		. 'prodotti.id_marchio, marchi.nome as marchio, '		// SDF
		. 'mPiuVenduti.testo AS piu_venduti '
		. 'FROM prodotti '
		#1		    .'INNER JOIN prodotti_categorie ON ( prodotti_categorie.id_prodotto = prodotti.id AND prodotti_categorie.id_categoria = ? ) '
		. 'INNER JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id '
		. 'INNER JOIN contenuti ON ( contenuti.id_prodotto = prodotti.id AND contenuti.id_lingua = ? ) '
		. 'INNER JOIN pubblicazioni ON pubblicazioni.id_prodotto = prodotti.id '
		. 'INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia '
		#2		    TODO il fatto che siano o meno ammissibili prodotti senza prezzo dovrebbe essere un'opzione
		#2		    .'INNER JOIN prezzi ON prezzi.id_prodotto = prodotti.id '
		#2		    .'INNER JOIN iva ON iva.id = prezzi.id_iva '
		. 'LEFT JOIN prezzi ON prezzi.id_prodotto = prodotti.id '
		. 'LEFT JOIN iva ON iva.id = prezzi.id_iva '
		. 'LEFT JOIN immagini ON ( immagini.id_prodotto = prodotti.id AND immagini.id_ruolo = 4 ) '
		. 'LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) '
		. 'LEFT JOIN metadati AS mPiuVenduti ON ( mPiuVenduti.id_prodotto = prodotti.id AND mPiuVenduti.nome = "piu_venduti" ) '
		. 'LEFT JOIN marchi ON (prodotti.id_marchio = marchi.id ) '		// SDF
		. 'LEFT JOIN articoli ON prodotti.id = articoli.id_prodotto '		// SDF
		. 'WHERE categorie_prodotti_path_check( prodotti_categorie.id_categoria, ? ) = 1 AND tipologie_pubblicazioni.se_pubblicato = 1 '
		#	.'AND (SELECT count(*) FROM immagini where id_articolo IN (SELECT articoli.id FROM articoli WHERE id_prodotto = prodotti.id)) '		// SDF
		//	.'AND ( (SELECT count(*) FROM immagini where id_articolo IN (SELECT articoli.id FROM articoli WHERE id_prodotto = prodotti.id)) '		// SDF
		//	.'OR ( SELECT count(*) FROM immagini where id_prodotto = prodotti.id ) ) '		// SDF
		. ((count($filters)) ? 'AND (' : NULL) . implode($conj, $filters) . ((count($filters)) ? ') ' : NULL)
		. 'GROUP BY prodotti.id '
		. 'ORDER BY ' . implode(', ', $order) . ' '
		. 'LIMIT ?,?';


	// SDF query per il conteggio del numero totale di prodotti (stessi parametri della q sopra ma senza paginazione)
	$qTot = 'SELECT count(prodotti.id) '
		. 'FROM prodotti '
		. 'INNER JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id '
		. 'INNER JOIN contenuti ON ( contenuti.id_prodotto = prodotti.id AND contenuti.id_lingua = ? ) '
#		. 'INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = prodotti.id_tipologia_pubblicazioni '
		. 'LEFT JOIN prezzi ON prezzi.id_prodotto = prodotti.id '
		. 'LEFT JOIN iva ON iva.id = prezzi.id_iva '
		. 'LEFT JOIN immagini ON ( immagini.id_prodotto = prodotti.id AND immagini.id_ruolo = 4 ) '
		. 'LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) '
		. 'LEFT JOIN metadati AS mPiuVenduti ON ( mPiuVenduti.id_prodotto = prodotti.id AND mPiuVenduti.nome = "piu_venduti" ) '
		. 'LEFT JOIN marchi ON (prodotti.id_marchio = marchi.id ) '		// SDF
		. 'LEFT JOIN articoli ON prodotti.id = articoli.id_prodotto '		// SDF
		. 'WHERE categorie_prodotti_path_check( prodotti_categorie.id_categoria, ? ) = 1 '
		#	.'AND tipologie_pubblicazioni.se_pubblicato = 1 '
		#	.'AND (SELECT count(*) FROM immagini where id_articolo IN (SELECT articoli.id FROM articoli WHERE id_prodotto = prodotti.id)) '		// SDF
		//	.'AND ( (SELECT count(*) FROM immagini where id_articolo IN (SELECT articoli.id FROM articoli WHERE id_prodotto = prodotti.id)) '		// SDF
		//	.'OR ( SELECT count(*) FROM immagini where id_prodotto = prodotti.id ) ) '		// SDF
		. ((count($filters)) ? 'AND (' : NULL) . implode($conj, $filters) . ((count($filters)) ? ') ' : NULL)
		. 'GROUP BY prodotti.id ';


	// SDF leggo il numero totale di prodotti
	$totpg = count(mysqlQuery($cf['mysql']['connection'], $qTot, $params));


	// aggiunta della paginazione
	$params[] = array('s' => $pg);
	$params[] = array('s' => $perpg);


	// SDF aggiunto numero massimo pagine
	$_REQUEST['__maxpg__'] = floor($totpg / $perpg);


	// selezione dei prodotti
	#		$ct['page']['contents']['prodotti'] = mysqlCachedQuery(
	#		    $cf['memcache']['connection'],
	$ct['page']['contents']['prodotti'] = mysqlQuery(
		$cf['mysql']['connection'],
		$q,
		$params
	);

	//		echo "q: " . $q . "<br>";
	#		print_r($params);
	//		echo "record con limit: " . count($ct['page']['contents']['prodotti']) . PHP_EOL;
	//		echo "record totali" . $totpg;
*/

	// TODO
	// ciclo su $ct['page']['contents']['prodotti'] per creare il sotto array di articoli
	//	$ct['page']['contents']['prodotti'][id_prodotto]['contents']['articoli']

	// SDF leggo il primo articolo (per l'immagine prodotto) e le info sul prezzo
	/*	foreach( $ct['page']['contents']['prodotti'] as $key => $prod ) {
		
		#	$ct['page']['contents']['prodotti'][ $key ]['immagine_principale'] = array();
			
			$immagine = mysqlQuery( 
				$cf['mysql']['connection'],
			    'SELECT nome, path, orientamento FROM immagini WHERE id_articolo = ( SELECT id FROM articoli WHERE id_prodotto = ? ORDER BY id LIMIT 1 ) ORDER BY ordine LIMIT 1'
				,
			    array(
				array( 's' => $prod['id'] )
			    )
			);

			if( isset($immagine[0] ) ){
				$ct['page']['contents']['prodotti'][ $key ]['immagine_principale'] = $immagine[0];
			}

			// leggo il prezzo
			$prezzi = mysqlQuery( 
				$cf['mysql']['connection'],
			    'SELECT * from prezzi_view WHERE id_prodotto = ?'
				,
			    array(
				array( 's' => $prod['id'] )
			    )
			);

			foreach( $prezzi as $prezzo ) {
				$ct['page']['contents']['prodotti'][ $key ]['prezzi'][ $prezzo['listino'] ] = $prezzo;
				
				// SDF 01-07-2020 aggiunta di eventuali sconti		
				$variazione_prezzo = variazionePrezzo( $cf['mysql']['connection'], $prezzo['id_listino'], $prezzo['id_prodotto'], $prezzo['prezzo_lordo'] );
				$ct['page']['contents']['prodotti'][ $key ]['prezzi'][ $prezzo['listino'] ]['tipo_sconto'] = $variazione_prezzo['tipoSconto'];
				$ct['page']['contents']['prodotti'][ $key ]['prezzi'][ $prezzo['listino'] ]['sconto'] = $variazione_prezzo['sconto'];
				$ct['page']['contents']['prodotti'][ $key ]['prezzi'][ $prezzo['listino'] ]['sconto_su'] = $variazione_prezzo['sconto_su'];
				$ct['page']['contents']['prodotti'][ $key ]['prezzi'][ $prezzo['listino'] ]['importo_sconto'] = $variazione_prezzo['importoSconto'];
				$ct['page']['contents']['prodotti'][ $key ]['prezzi'][ $prezzo['listino'] ]['prezzo_scontato'] = $variazione_prezzo['prezzoScontato'];	
			}
		}

*/
/*
	// SDF costruisco l'array delle categorie (corrente e figlie) per la pagina
	$ct['etc']['categorie'] = mysqlQuery(
		$cf['mysql']['connection'],
		'SELECT id, nome FROM categorie_prodotti '
#			. 'WHERE (id = ? OR id_genitore = ?) AND id_tipologia_pubblicazioni = 2 ORDER BY categorie_prodotti.nome',
			. 'WHERE (id = ? OR id_genitore = ?) ORDER BY categorie_prodotti.nome',
		array(
			array('s' => $cf['contents']['page']['metadata']['id_categoria_prodotti']),
			array('s' => $cf['contents']['page']['metadata']['id_categoria_prodotti'])
		)
	);


	// SDF costruisco l'array dei marchi per la pagina
	$ct['etc']['marchi'] = mysqlQuery(
		$cf['mysql']['connection'],
		'SELECT DISTINCT marchi.id, marchi.nome FROM marchi INNER JOIN prodotti ON marchi.id = prodotti.id_marchio INNER JOIN prodotti_categorie '
			. 'ON prodotti.id = prodotti_categorie.id_prodotto INNER JOIN categorie_prodotti ON prodotti_categorie.id_categoria = categorie_prodotti.id '
			. 'WHERE categorie_prodotti.id = ? OR categorie_prodotti.id_genitore = ? ORDER BY marchi.nome',
		array(
			array('s' => $cf['contents']['page']['metadata']['id_categoria_prodotti']),
			array('s' => $cf['contents']['page']['metadata']['id_categoria_prodotti'])
		)
	);

	// SDF costruisco l'array delle taglie per la pagina
	$ct['etc']['taglie'] = mysqlQuery(
		$cf['mysql']['connection'],
		'SELECT DISTINCT taglie.id, taglie.it as nome FROM taglie INNER JOIN articoli ON taglie.id = articoli.id_taglia '
			. 'INNER JOIN prodotti ON articoli.id_prodotto = prodotti.id INNER JOIN prodotti_categorie '
			. 'ON prodotti.id = prodotti_categorie.id_prodotto INNER JOIN categorie_prodotti ON prodotti_categorie.id_categoria = categorie_prodotti.id '
			. 'WHERE categorie_prodotti.id = ? OR categorie_prodotti.id_genitore = ? ORDER BY taglie.id',
		array(
			array('s' => $cf['contents']['page']['metadata']['id_categoria_prodotti']),
			array('s' => $cf['contents']['page']['metadata']['id_categoria_prodotti'])
		)
	);
*/
	// print_r($ct['etc']['taglie']);
}
	
	


    // debug
	// print_r( $ct['page']['metadati'] );
	// print_r( $_REQUEST );
	//print_r($ct['page']['contents']['prodotti']);
	