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
	if( isset( $ct['page']['metadati']['id_categoria_notizie'] ) && ! empty( $ct['page']['metadati']['id_categoria_notizie'] ) ) {

	    // selezione delle sotto categorie
		$ct['page']['contents']['categorie_notizie'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT contenuti.id_categoria_notizie AS id, contenuti.h1, contenuti.h2, contenuti.abstract, contenuti.cappello, immagini.path AS immagine, contenuti_immagine.cappello AS didascalia FROM categorie_notizie '
		    .'INNER JOIN contenuti ON ( contenuti.id_categoria_notizie = categorie_notizie.id AND contenuti.id_lingua = ? ) '
		    .'LEFT JOIN immagini ON ( immagini.id_categoria_notizie = categorie_notizie.id AND immagini.id_ruolo = 4 ) '
		    .'LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) '
		    .'WHERE categorie_notizie.id_genitore = ? '
		    .'GROUP BY categorie_notizie.id ',
		    array(
			array( 's' => $cf['localization']['language']['id'] ),
			array( 's' => $ct['page']['metadati']['id_categoria_notizie'] )
		    )
		);

	    // selezione delle notizie
	    // TODO filtrare per date con status pubblicazioni -> pubblicato e data corrente nell'intervallo
		$ct['page']['contents']['notizie'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT contenuti.id_notizia AS id, contenuti.h1, contenuti.h2, contenuti.abstract, contenuti.cappello, '
			.'pubblicazioni.id_tipologia, pubblicazioni.timestamp_inizio, '
		    .'immagini.path AS immagine, contenuti_immagine.cappello AS didascalia '
		    .'FROM notizie '
		    .'INNER JOIN contenuti ON ( contenuti.id_notizia = notizie.id AND contenuti.id_lingua = ? ) '
		    .'INNER JOIN notizie_categorie ON notizie_categorie.id_notizia = notizie.id '
		    .'INNER JOIN pubblicazioni ON pubblicazioni.id_notizia = contenuti.id_notizia '
		    .'LEFT JOIN immagini ON ( immagini.id_notizia = notizie.id AND immagini.id_ruolo = 4 ) '
		    .'LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) '
		    .'WHERE notizie_categorie.id_categoria = ? '
		    .'GROUP BY notizie.id ORDER BY pubblicazioni.timestamp_inizio DESC',
		    array(
			array( 's' => $cf['localization']['language']['id'] ),
			array( 's' => $ct['page']['metadati']['id_categoria_notizie'] )
		    )
		);

	    // debug
		// print_r( $ct['page']['contents']['categorie_notizie'] );
		// print_r( $ct['page']['contents']['notizie'] );
		// print_r( $ct['notizie']['categorie'][ $ct['page']['metadati']['id_categoria_notizie'] ] );
		// print_r( $ct['notizie']['dati'] );

	}
