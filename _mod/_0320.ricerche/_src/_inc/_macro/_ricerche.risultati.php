<?php

    /**
     * 
     * 
     * 
     * @file
     * 
     */

    // debug
	// die( print_r( $_REQUEST, true ) );

    // ciclo sui moduli __ricerche__
	if( isset( $_REQUEST['__ricerche__'] ) && is_array( $_REQUEST['__ricerche__'] ) ) {

	    // ricerca base
		if( isset( $_REQUEST['__ricerche__']['base'] ) ) {

		    // salvo la ricerca
			// TODO

            // ...
            $ct['ricerche']['query'] = $_REQUEST['__ricerche__']['base'];

            // tokenizzo la ricerca
			$tks = explode( ' ', $_REQUEST['__ricerche__']['base'] );
			$t = 'contenuti';
			$fields = array( 'h1', 'h2', 'cappello', 'testo', 'abstract' );

            // ...
            // die( print_r( $fields, true ) );

            // preparo la clausola WHERE
			foreach( $tks as $tk ) {
			    $like = "%${tk}%";
			    $cond = array();
			    foreach( preg_filter( '/^/', "${t}.", $fields ) as $field ) {
                    $cond[] = $field . ' LIKE ?';
                    $vs[] = array( 's' => $like );
			    }
			    $whr[] = '(' . implode( ' OR ', $cond ) . ')';
			}

            // ...
            // die( print_r( $cond, true ) );

            $join[] = 'LEFT JOIN pagine ON pagine.id = contenuti.id_pagina';
            $join[] = 'LEFT JOIN pubblicazioni AS p1 ON p1.id_pagina = pagine.id';
            $join[] = 'LEFT JOIN tipologie_pubblicazioni AS tp1 ON tp1.id = p1.id_tipologia';

			$join[] = 'LEFT JOIN categorie_prodotti ON categorie_prodotti.id = contenuti.id_categoria_prodotti';
            $join[] = 'LEFT JOIN pubblicazioni AS p2 ON p2.id_categoria_prodotti = categorie_prodotti.id';
            $join[] = 'LEFT JOIN tipologie_pubblicazioni AS tp2 ON tp2.id = p2.id_tipologia';

			$join[] = 'LEFT JOIN prodotti ON prodotti.id = contenuti.id_prodotto';
            $join[] = 'LEFT JOIN pubblicazioni AS p3 ON p3.id_prodotto = prodotti.id';
            $join[] = 'LEFT JOIN tipologie_pubblicazioni AS tp3 ON tp3.id = p3.id_tipologia';

            $whr[] = '( p1.timestamp_inizio IS NULL OR p1.timestamp_inizio <= ' . time() . ' )';
            $whr[] = '( p1.timestamp_fine IS NULL OR p1.timestamp_fine >= ' . time() . ' )';

            $whr[] = '( p2.timestamp_inizio IS NULL OR p2.timestamp_inizio <= ' . time() . ' )';
            $whr[] = '( p2.timestamp_fine IS NULL OR p2.timestamp_fine >= ' . time() . ' )';

            $whr[] = '( p3.timestamp_inizio IS NULL OR p3.timestamp_inizio <= ' . time() . ' )';
            $whr[] = '( p3.timestamp_fine IS NULL OR p3.timestamp_fine >= ' . time() . ' )';

            $whr[] = '( tp1.se_pubblicato = 1 OR tp2.se_pubblicato = 1 OR tp3.se_pubblicato = 1 )';
            $whr[] = '( pagine.id_sito = ? OR categorie_prodotti.id_sito = ? OR prodotti.id_sito = ? )';
            $whr[] = 'contenuti.id_lingua = ?';

            $vs[] = array( 's' => $cf['site']['id'] );
			$vs[] = array( 's' => $cf['site']['id'] );
			$vs[] = array( 's' => $cf['site']['id'] );
			$vs[] = array( 's' => ID_LINGUA_CORRENTE );

		    // aggiungo le clausole WHERE alla query
			$q = "SELECT ${t}.id, ${t}.h1, ${t}.cappello, ${t}.id_pagina, ${t}.id_categoria_prodotti, ${t}.id_prodotto FROM ${t} " . implode( ' ', $join ) . ' WHERE ' . implode( ' AND ', $whr );

            // ...
            // echo $q;

            // cerco fra i contenuti
		    $dati = mysqlQuery( $cf['mysql']['connection'], $q, $vs );

            // ...
            // var_dump( $cf['site']['id'] );
            // var_dump( ID_LINGUA_CORRENTE );
            // die( print_r( $dati, true ) );

            // ...
            foreach( $dati as $dato ) {

                // ...
                if( ! empty( $dato['id_pagina'] ) ) {
                    $dato['url'] = $cf['contents']['pages'][ $dato['id_pagina'] ]['url'][ LINGUA_CORRENTE ];
                    $ct['ricerche']['risultati']['pagine'][] = $dato;
                } elseif( ! empty( $dato['id_categoria_prodotti'] ) ) {
                    $dato['url'] = $cf['contents']['pages'][ $cf['contents']['reverse']['categorie_prodotti'][ $dato['id_categoria_prodotti'] ] ]['url'][ LINGUA_CORRENTE ];
                    $ct['ricerche']['risultati']['categorie prodotti'][] = $dato;
                } elseif( ! empty( $dato['id_prodotto'] ) ) {
                    $dato['url'] = $cf['contents']['pages'][ $cf['contents']['reverse']['prodotti'][ $dato['id_prodotto'] ] ]['url'][ LINGUA_CORRENTE ];
                    $ct['ricerche']['risultati']['prodotti'][] = $dato;
                }

                // TODO aggiungere notizie, categorie_notizie, risorse, categorie_risorse, progetti, categorie_progetti

            }

            // ...
            // die( print_r( $ct['ricerche'], true ) );

        }

    }
