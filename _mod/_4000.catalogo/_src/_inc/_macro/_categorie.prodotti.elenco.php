<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */
/*
    // seleziono le sottocategorie
	if( isset( $cf['contents']['page']['metadata']['id_categoria_prodotti'] ) && ! empty( $cf['contents']['page']['metadata']['id_categoria_prodotti']  ) ) {

	    // selezione delle sotto categorie
		$ct['page']['contents']['categorie_prodotti'] = mysqlQuery(
		    $cf['mysql']['connection'],
		    'SELECT contenuti.*, immagini.path AS immagine, contenuti_immagine.cappello AS didascalia FROM categorie_prodotti '
		    .'INNER JOIN contenuti ON ( contenuti.id_categoria_prodotti = categorie_prodotti.id AND contenuti.id_lingua = ? ) '
		    .'LEFT JOIN immagini ON ( immagini.id_categoria_prodotti = categorie_prodotti.id AND immagini.id_ruolo = 4 ) '
		    .'LEFT JOIN contenuti AS contenuti_immagine ON ( contenuti_immagine.id_immagine = immagini.id AND contenuti.id_lingua = contenuti.id_lingua ) '
		    .'WHERE categorie_prodotti.id_genitore = ? '
		    .'GROUP BY categorie_prodotti.id ',
		    array(
				array( 's' => $cf['localization']['language']['id'] ),
				array( 's' => $cf['contents']['page']['metadata']['id_categoria_prodotti'] )
		    )
		);

	    // debug
		 //print_r( $ct['page']['contents']['categorie_prodotti'] );
		// print_r( $ct['catalogo']['categorie'][ $ct['page']['metadati']['id_categoria_prodotti'] ] );

	}
*/
