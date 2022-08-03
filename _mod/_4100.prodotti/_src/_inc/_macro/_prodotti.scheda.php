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

		// articoli
		$ct['page']['contents']['articoli'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT articoli.* FROM articoli '
			.'LEFT JOIN contenuti ON ( contenuti.id_articolo = articoli.id AND contenuti.id_lingua = ? ) '
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

	}

    // debug
    // print_r( $ct['page']['contents']['recensioni'] );
