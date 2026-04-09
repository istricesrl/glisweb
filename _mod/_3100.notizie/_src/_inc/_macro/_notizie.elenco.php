<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

	// filtro per anno
	if( isset( $_REQUEST['y'] ) && ! empty( $_REQUEST['y'] ) ) {

	    $ct['page']['metadati']['filtro_anno'] = $_REQUEST['y'];

	}

    // seleziono le sottocategorie
	if( isset( $ct['page']['metadati']['id_categoria_notizie'] ) && ! empty( $ct['page']['metadati']['id_categoria_notizie'] ) ) {

	    // selezione delle sotto categorie
		$ct['page']['contents']['categorie_notizie'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT contenuti.id_categoria_notizie AS id, contenuti.h1, contenuti.h2, contenuti.abstract, contenuti.cappello, 
			immagini.path AS immagine, contenuti_immagine.cappello AS didascalia 
			FROM categorie_notizie 
			INNER JOIN contenuti ON ( contenuti.id_categoria_notizie = categorie_notizie.id AND contenuti.id_lingua = ? ) 
			LEFT JOIN immagini ON ( immagini.id_categoria_notizie = categorie_notizie.id AND immagini.id_ruolo = 4 ) 
			LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) 
			WHERE categorie_notizie.id_genitore = ? 
			GROUP BY categorie_notizie.id ',
		    array(
			array( 's' => $cf['localization']['language']['id'] ),
			array( 's' => $ct['page']['metadati']['id_categoria_notizie'] )
		    )
		);

        if( isset( $ct['page']['metadati']['filtro_anno'] ) && ! empty( $ct['page']['metadati']['filtro_anno'] ) ) {


            // selezione delle notizie
            // TODO filtrare per date con status pubblicazioni -> pubblicato e data corrente nell'intervallo
            $ct['page']['contents']['notizie'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT contenuti.id_notizia AS id, contenuti.h1, contenuti.h2, contenuti.abstract, contenuti.cappello, 
                pubblicazioni.id_tipologia, pubblicazioni.timestamp_inizio, 
                immagini.path AS immagine, contenuti_immagine.cappello AS didascalia 
                FROM notizie 
                INNER JOIN contenuti ON ( contenuti.id_notizia = notizie.id AND contenuti.id_lingua = ? ) 
                INNER JOIN notizie_categorie ON notizie_categorie.id_notizia = notizie.id 
                INNER JOIN pubblicazioni ON pubblicazioni.id_notizia = contenuti.id_notizia 
                LEFT JOIN immagini ON ( immagini.id_notizia = notizie.id AND immagini.id_ruolo = 4 ) 
                LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) 
                WHERE notizie_categorie.id_categoria = ? GROUP BY notizie.id 
                AND YEAR( FROM_UNIXTIME( pubblicazioni.timestamp_inizio ) ) = ?
                ORDER BY pubblicazioni.timestamp_inizio DESC',
                array(
                    array( 's' => $cf['localization']['language']['id'] ),
                    array( 's' => $ct['page']['metadati']['id_categoria_notizie'] ),
                    array( 's' => $ct['page']['metadati']['filtro_anno'] )
                )
            );

        } else {

            // selezione delle notizie
            // TODO filtrare per date con status pubblicazioni -> pubblicato e data corrente nell'intervallo
            $ct['page']['contents']['notizie'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT contenuti.id_notizia AS id, contenuti.h1, contenuti.h2, contenuti.abstract, contenuti.cappello, 
                pubblicazioni.id_tipologia, pubblicazioni.timestamp_inizio, 
                immagini.path AS immagine, contenuti_immagine.cappello AS didascalia 
                FROM notizie 
                INNER JOIN contenuti ON ( contenuti.id_notizia = notizie.id AND contenuti.id_lingua = ? ) 
                INNER JOIN notizie_categorie ON notizie_categorie.id_notizia = notizie.id 
                INNER JOIN pubblicazioni ON pubblicazioni.id_notizia = contenuti.id_notizia 
                LEFT JOIN immagini ON ( immagini.id_notizia = notizie.id AND immagini.id_ruolo = 4 ) 
                LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) 
                WHERE notizie_categorie.id_categoria = ? GROUP BY notizie.id ORDER BY pubblicazioni.timestamp_inizio DESC',
                array(
                    array( 's' => $cf['localization']['language']['id'] ),
                    array( 's' => $ct['page']['metadati']['id_categoria_notizie'] )
                )
            );

        }

		// ...
		foreach( $ct['page']['contents']['notizie'] as $k => $v ) {

		    // ...
		    $ct['page']['contents']['notizie'][ $k ]['categorie'] = mysqlQuery(
				$cf['mysql']['connection'],
				'SELECT categorie_notizie.id, contenuti.h1
				FROM notizie_categorie
				INNER JOIN categorie_notizie ON categorie_notizie.id = notizie_categorie.id_categoria
				INNER JOIN contenuti ON contenuti.id_categoria_notizie = categorie_notizie.id AND contenuti.id_lingua = ?
				WHERE notizie_categorie.id_notizia = ?',
				array(
					array( 's' => $cf['localization']['language']['id'] ),							
					array( 's' => $v['id'] ) )
		    );

			// ...
			$ct['page']['contents']['notizie'][ $k ]['persone'] = mysqlQuery(
				$cf['mysql']['connection'],
				'SELECT anagrafica.id, anagrafica.nome, anagrafica.cognome, ruoli_anagrafica.id AS id_ruolo, ruoli_anagrafica.nome AS ruolo
				FROM notizie_anagrafica
				INNER JOIN anagrafica ON anagrafica.id = notizie_anagrafica.id_anagrafica
				INNER JOIN ruoli_anagrafica ON ruoli_anagrafica.id = notizie_anagrafica.id_ruolo
				WHERE notizie_anagrafica.id_notizia = ?',
				array( array( 's' => $v['id'] ) )
			);

            foreach( $ct['page']['contents']['notizie'][ $k ]['persone'] as &$persona ) {

                // foto profilo
                $persona['avatar'] = basename( mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT immagini.path AS immagine
                    FROM immagini
                    WHERE immagini.id_ruolo = 10 AND immagini.id_anagrafica = ? LIMIT 1',
                    array( array( 's' => $persona['id'] ) )
                ) ?? '' );

                $persona['urls'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT url.* FROM url WHERE url.id_anagrafica = ?',
                    array( array( 's' => $persona['id'] ) )
                );

            }

        }

		// debug
		// print_r( $ct['page']['contents']['categorie_notizie'] );
		// print_r( $ct['page']['contents']['notizie'] );
		// print_r( $ct['notizie']['categorie'][ $ct['page']['metadati']['id_categoria_notizie'] ] );
		// print_r( $ct['notizie']['dati'] );

	}
