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
	if( isset( $ct['page']['metadata']['id_prodotto'] ) && ! empty( $ct['page']['metadata']['id_prodotto'] ) ) {
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
				array( 's' => $ct['page']['metadata']['id_prodotto'] )
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
			array( 's' => $ct['page']['metadata']['id_prodotto'] )
		    )
		);
*/
	}

    // debug
    // print_r( $ct['page']['contents']['recensioni'] );
