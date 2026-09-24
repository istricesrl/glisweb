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
	if( isset( $ct['page']['metadati']['id_prodotto'] ) && ! empty( $ct['page']['metadati']['id_prodotto'] ) ) {
/*

		NOTA vedi _420.pages.php

		// articoli
		$ct['page']['contents']['articoli'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT articoli.*, coalesce( p1.prezzo, p2.prezzo ) AS prezzo, '
			.'( coalesce( p1.prezzo, p2.prezzo ) * ( ( iva.aliquota + 100 ) / 100 ) ) AS prezzo_lordo, iva.aliquota, valute.utf8 AS valuta '
			.'FROM articoli '
			.'LEFT JOIN contenuti ON ( contenuti.id_articolo = articoli.id AND contenuti.id_lingua = ? ) '
			.'LEFT JOIN prezzi AS p1 ON p1.id_prodotto = articoli.id_prodotto '
			.'LEFT JOIN prezzi AS p2 ON p2.id_articolo = articoli.id '
			.'LEFT JOIN iva ON iva.id = coalesce( p1.id_iva, p2.id_iva ) '
			.'LEFT JOIN listini ON listini.id = coalesce( p1.id_listino, p2.id_listino ) '
			.'LEFT JOIN valute ON valute.id = listini.id_valuta '
		    .'WHERE articoli.id_prodotto = ? '
#		    .'GROUP BY id_prodotto '
		    .'ORDER BY timestamp_inserimento DESC '
#		    .'LIMIT 6'
		    ,
		    array(
				array( 's' => $cf['localization']['language']['id'] ),
				array( 's' => $ct['page']['metadati']['id_prodotto'] )
		    )
		);
*/
/*
	    // recensioni
		$ct['page']['contents']['recensioni'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT recensioni.* FROM recensioni '
		    .'WHERE id_lingua = ? AND se_approvata = 1 AND id_prodotto = ? '
#		    .'GROUP BY id_prodotto '
		    .'ORDER BY timestamp_inserimento DESC '
#		    .'LIMIT 6'
		    ,
		    array(
			array( 's' => $cf['localization']['language']['id'] ),
			array( 's' => $ct['page']['metadati']['id_prodotto'] )
		    )
		);
*/

        $ct['page']['contents']['caratteristiche'] = array();

        $caratteristiche = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT caratteristiche_prodotti.*, prodotti_caratteristiche.valore FROM prodotti_caratteristiche
            LEFT JOIN caratteristiche_prodotti ON ( caratteristiche_prodotti.id = prodotti_caratteristiche.id_caratteristica )
            WHERE prodotti_caratteristiche.id_prodotto = ? AND caratteristiche_prodotti.id_genitore IS NULL ',
            array(
                array( 's' => $ct['page']['metadati']['id_prodotto'] )
            )
        );

        // die( print_r( $caratteristiche, true ) );

        foreach( $caratteristiche as $k => $c ) {

            $ct['page']['contents']['caratteristiche'][ $c['id'] ] = $c;

        }

        // die( print_r( $ct['page']['contents']['caratteristiche'], true ) );

        $figli = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT caratteristiche_prodotti.*, prodotti_caratteristiche.valore FROM prodotti_caratteristiche
            INNER JOIN caratteristiche_prodotti ON ( caratteristiche_prodotti.id = prodotti_caratteristiche.id_caratteristica )
            WHERE prodotti_caratteristiche.id_prodotto = ? AND caratteristiche_prodotti.id_genitore IS NOT NULL ',
            array(
                array( 's' => $ct['page']['metadati']['id_prodotto'] )
            )
        );

        // die( print_r( $figli, true ) );

        foreach( $figli as $k => $c ) {

            // il genitore si legge UNA VOLTA SOLA, e solo se non c'e' gia'
            //
            // prima la riga veniva riletta e riassegnata per ogni figlio. Due effetti, tutti e due
            // sbagliati: una query in piu' per ogni caratteristica, e soprattutto la perdita del
            // valore. Un gruppo puo' avere un valore suo ( e' li' che finiscono le voci di elenco
            // senza etichetta, per esempio gli accessori in dotazione ): quel valore arriva dalla
            // prima query, e la rilettura secca lo cancellava perche' SELECT * FROM
            // caratteristiche_prodotti la colonna valore non ce l'ha.
            if( ! empty( $c['id_genitore'] ) && ! isset( $ct['page']['contents']['caratteristiche'][ $c['id_genitore'] ] ) ) {
                $ct['page']['contents']['caratteristiche'][ $c['id_genitore'] ] = mysqlSelectRow(
                    $cf['mysql']['connection'],
                    'SELECT * FROM caratteristiche_prodotti WHERE id = ? ',
                    array(
                        array( 's' => $c['id_genitore'] )
                    )
                );
            }

        }

        foreach( $figli as $k => $c ) {
            if( ! empty( $c['id_genitore'] ) ) {
                $ct['page']['contents']['caratteristiche'][ $c['id_genitore'] ]['caratteristiche'][ $c['id'] ] = $c;
            }
        }

        // die( print_r( $ct['page']['contents']['caratteristiche'], true ) );

    }

    // debug
    // print_r( $ct['page']['contents']['recensioni'] );
