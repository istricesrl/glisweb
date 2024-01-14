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
	if( isset( $ct['page']['metadati']['id_categoria_annunci'] ) && ! empty( $ct['page']['metadati']['id_categoria_annunci'] ) ) {

	    // selezione delle sotto categorie
		$ct['page']['contents']['categorie_annunci'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT contenuti.id_categoria_annunci AS id, contenuti.h1, contenuti.h2, contenuti.abstract, contenuti.cappello, immagini.path AS immagine, contenuti_immagine.cappello AS didascalia FROM categorie_annunci '
		    .'INNER JOIN contenuti ON ( contenuti.id_categoria_annunci = categorie_annunci.id AND contenuti.id_lingua = ? ) '
		    .'LEFT JOIN immagini ON ( immagini.id_categoria_annunci = categorie_annunci.id AND immagini.id_ruolo = 4 ) '
		    .'LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) '
		    .'WHERE categorie_annunci.id_genitore = ? '
		    .'GROUP BY categorie_annunci.id ',
		    array(
			array( 's' => $cf['localization']['language']['id'] ),
			array( 's' => $ct['page']['metadati']['id_categoria_annunci'] )
		    )
		);

	    // selezione delle annunci
	    // TODO filtrare per date con status pubblicazioni -> pubblicato e data corrente nell'intervallo
		$ct['page']['contents']['annunci'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT contenuti.id_annuncio AS id, contenuti.h1, contenuti.h2, contenuti.abstract, contenuti.cappello, '
			.'pubblicazioni.id_tipologia, pubblicazioni.timestamp_inizio, '
		    .'immagini.path AS immagine, contenuti_immagine.cappello AS didascalia '
		    .'FROM annunci '
		    .'INNER JOIN contenuti ON ( contenuti.id_annuncio = annunci.id AND contenuti.id_lingua = ? ) '
		    .'INNER JOIN annunci_categorie ON annunci_categorie.id_annuncio = annunci.id '
		    .'INNER JOIN pubblicazioni ON pubblicazioni.id_annuncio = contenuti.id_annuncio '
		    .'LEFT JOIN immagini ON ( immagini.id_annuncio = annunci.id AND immagini.id_ruolo = 4 ) '
		    .'LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) '
		    .'WHERE annunci_categorie.id_categoria = ? '
		    .'GROUP BY annunci.id ORDER BY pubblicazioni.timestamp_inizio DESC',
		    array(
			array( 's' => $cf['localization']['language']['id'] ),
			array( 's' => $ct['page']['metadati']['id_categoria_annunci'] )
		    )
		);

	    // debug
		// print_r( $ct['page']['contents']['categorie_annunci'] );
		// print_r( $ct['page']['contents']['annunci'] );
		// print_r( $ct['annunci']['categorie'][ $ct['page']['metadati']['id_categoria_annunci'] ] );
		// print_r( $ct['annunci']['dati'] );

	}
