<?php

    /**
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // verifico se è presente una pagina
	if( isset( $cf['contents']['page']['id'] ) && isset( $cf['localization']['language']['id'] ) ) {

        // prelevo i popup della pagina dal database
        $popup = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT popup.* FROM popup '
            .'LEFT JOIN popup_pagine ON popup_pagine.id_popup = popup.id '
            .'WHERE (popup_pagine.id_pagina = ? OR popup.se_ovunque = 1 ) AND popup.id_sito = ? AND template IS NOT NULL AND schema_html IS NOT NULL '
            .'AND popup.template = ?',
            array(
                array( 's' => $cf['contents']['page']['id'] ),
                array( 's' => SITE_CURRENT ),
                array( 's' => $cf['contents']['page']['template']['path'] )
            )
        );

        // costruisco l'array delle immagini
        if( !empty( $popup ) ){
            foreach( $popup as $pu ) {
                
                // leggiamo dal db il campo schema_html e lo mettiamo nella chiave schema dell'array popup
                $pu['schema'] = $pu['schema_html'];
    
                // classe per il tipo di apparizione
                switch( $pu['id_tipologia'] ) {
                    case 1:
                    $pu['tipologia'] = 'popup-open';
                    break;
                    case 2:
                    $pu['tipologia'] = 'popup-close';
                    break;
                    case 3:
                    $pu['tipologia'] = 'popup-delay';
                    break;
                    case 4:
                    $pu['tipologia'] = 'popup-scroll';
                    break;
                }
    
    
               // leggo i contenuti del popup
                $cnt = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT contenuti.*, lingue.ietf FROM contenuti '.
                    'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
                    'WHERE id_popup = ?',
                    array(
                        array( 's' => $pu['id'] )
                    )
                );
    
                if( !empty( $cnt ) ){
                    foreach( $cnt as $cn ){
                        $pu = array_replace_recursive( $pu,
                            array(
                                'h1'	            => array( $cn['ietf']	=> $cn['h1'] ),
                                'h2'	            => array( $cn['ietf']	=> $cn['h2'] ),
                                'h3'	            => array( $cn['ietf']	=> $cn['h3'] ),
                                'testo'             => array( $cn['ietf']	=> $cn['testo'] )
                            )
                        );
                    }
                }
    
                if( !isset( $_SESSION['popup'] ) || !in_array( $pu['html_id'], $_SESSION['popup']['chiusi'] ) ){
                    // aggiungo il popup
                    $cf['contents']['page']['contents']['modals']['popup'][] = $pu;
                }
    
            }
        }

	}


