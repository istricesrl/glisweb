<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tendina sesso
	$ct['etc']['select']['sorgenti'] = array( 
	    array( 'id' => 'IMPORTO_ORDINI', '__label__' => 'importo degli ordini' ),
	    array( 'id' => 'MARGINE_ORDINI', '__label__' => 'utile degli ordini' ),
	    array( 'id' => 'VOLUME_ORDINI', '__label__' => 'quantità ordinate' ),
	);

    // tendina categorie
	$ct['etc']['select']['categorie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM categorie_prodotti_view ORDER BY __label__ '
    );

    // tendina stati
    $ct['etc']['select']['stati'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM stati_view ORDER BY __label__'
    );

    // tendina provincie
	if( isset( $_REQUEST['__stats__']['__id_stato__'] ) ){
        $ct['etc']['select']['provincie'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM provincie_view WHERE id_stato = ? ORDER BY __label__',
            array(
                array( 's' => $_REQUEST['__stats__']['__id_stato__'] )
            )
        );
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.stats.php';

    // ...
    if( isset( $_REQUEST['__stats__'] ) ) {

        // ...
        switch( $_REQUEST['__stats__']['__sorgente__'] ) {

            case 'IMPORTO_ORDINI':

                $whr = NULL;
                $ijn = NULL;
                $cnd = array();
                $cnw = array(
                    array( 's' => $_REQUEST['__stats__']['__inizio__'] ),
                    array( 's' => $_REQUEST['__stats__']['__fine__'] )
                );

                // print_r( $cnd );

                if( isset( $_REQUEST['__stats__']['__categoria__'] ) && ! empty( $_REQUEST['__stats__']['__categoria__'] ) ) {
                    $ijn .= 'INNER JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id AND categorie_prodotti_path_check( prodotti_categorie.id_categoria, ? ) ';
                    $cnd = array_merge( $cnd, array(
                        array( 's' => $_REQUEST['__stats__']['__categoria__'] )
                        )
                    );
                }

                if( isset( $_REQUEST['__stats__']['__id_stato__'] ) && ! empty( $_REQUEST['__stats__']['__id_stato__'] ) ) {
                    $ijn .= 'INNER JOIN anagrafica_view_static ON anagrafica_view_static.id = documenti.id_emittente AND anagrafica_view_static.id_stato = ? ';
                    $cnd = array_merge( $cnd, array(
                        array( 's' => $_REQUEST['__stats__']['__id_stato__'] )
                        )
                    );
                    if( isset( $_REQUEST['__stats__']['__id_provincia__'] ) && ! empty( $_REQUEST['__stats__']['__id_provincia__'] ) ) {
                        $ijn .= 'AND anagrafica_view_static.id_provincia = ? ';
                        $cnd = array_merge( $cnd, array(
                            array( 's' => $_REQUEST['__stats__']['__id_provincia__'] )
                            )
                        );
                    }
                }

                $dati = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT sum( documenti_articoli.importo_netto_totale ) AS importo, '.
                    'date_format( documenti.data, "' . $m . '" ) AS label '.
                    'FROM documenti_articoli '.
                    'INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento '.
                    'INNER JOIN articoli ON articoli.id = documenti_articoli.id_articolo '.
                    'INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto '.
                    $ijn.
                    'WHERE documenti.id_tipologia = 7 '.
                    'AND documenti.data >= ? AND documenti.data <= ? '.
                    $whr.
                    'GROUP BY date_format( documenti.data, "' . $m . '" )',
                    array_merge( $cnd, $cnw )
                );

                // var_dump( $m );
                // print_r( $dati );
                // print_r( $_REQUEST );

                foreach( $dati as $row ) {
                    $ct['data']['grafico']['corrente'][ $row['label'] ] = $ds['corrente'][ $row['label'] ] = array( 'value' => $row['importo'] );
                }

                // print_r( $ct['data'] );

                $ct['page']['contents']['chartjs'] = array(
                    'grafico' => array(
                        'type' => 'line',
                        'data' => array(
                            'labels' => $ct['data']['labels'],
                            'datasets' => array(
                                'corrente' => array(
                                    'data' => $ds['corrente']
                                )
                            )
                        )
                    )
                );

                if( $_REQUEST['__stats__']['__confronto__'] == 'ANNO' ) {

                    $whr = NULL;
                    $ijn = NULL;
                    $cnd = array(
                        array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__inizio__'] . ' -1 year' ) ) ),
                        array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__fine__'] . ' -1 year' ) ) )
                    );

                    if( isset( $_REQUEST['__stats__']['__categoria__'] ) && ! empty( $_REQUEST['__stats__']['__categoria__'] ) ) {
                        $ijn = 'INNER JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id AND categorie_prodotti_path_check( prodotti_categorie.id_categoria, ? ) ';
                        $cnd = array(
                            array( 's' => $_REQUEST['__stats__']['__categoria__'] ),
                            array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__inizio__'] . ' -1 year' ) ) ),
                            array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__fine__'] . ' -1 year' ) ) )
                            );
                    }
        
                    $dati = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT sum( documenti_articoli.importo_netto_totale ) AS importo, '.
                        'date_format( documenti.data, "' . $m . '" ) AS label '.
                        'FROM documenti_articoli '.
                        'INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento '.
                        'INNER JOIN articoli ON articoli.id = documenti_articoli.id_articolo '.
                        'INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto '.
                        $ijn.
                        'WHERE documenti.id_tipologia = 7 '.
                        'AND documenti.data >= ? AND documenti.data <= ? '.
                        $whr.
                        'GROUP BY date_format( documenti.data, "' . $m . '" )',
                        $cnd
                    );

                    // var_dump( date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__inizio__'] . ' -1 year' ) ) );
                    // var_dump( date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__fine__'] . ' -1 year' ) ) );
                    // var_dump( $m );
                    // print_r( $dati );

                    foreach( $dati as $row ) {
                        // $row['label'] = str_replace( date( 'Y', strtotime( $_REQUEST['__stats__']['__inizio__'] ) ) - 1, date( 'Y', strtotime( $_REQUEST['__stats__']['__inizio__'] ) ), $row['label'] );
                        // var_dump( $row['label'] );
                        $row['label'] = date( $d, strtotime( $row['label'] . ' +1 year' ) );
                        // if( array_key_exists( $row['label'] ) ) { $row['label'] = 'N' . $row['label']; }
                        // var_dump( $row['label'] );
                        $ct['data']['grafico']['precedente'][ $row['label'] ] = $ds['precedente'][ $row['label'] ] = array( 'value' => $row['importo'] );
                    }
                        
                    // print_r( $ct['data']['grafico']['precedente'] );
                        
                    if( isset( $ds['precedente'] ) ) {

                        $ct['page']['contents']['chartjs']['grafico']['data']['datasets']['precedente']['data'] = $ds['precedente'];

                        $ct['page']['contents']['chartjs']['grafico']['data']['datasets']['precedente']['options'] = array(
                            'bgColor' => 'rgb( 187, 187, 187 )', 'bdColor' => 'rgb( 187, 187, 187 )'
                        );
    
                    }

                }

            break;

            case 'VOLUME_ORDINI':

                $whr = NULL;
                $ijn = NULL;
                $cnd = array(
                    array( 's' => $_REQUEST['__stats__']['__inizio__'] ),
                    array( 's' => $_REQUEST['__stats__']['__fine__'] )
                );

                if( isset( $_REQUEST['__stats__']['__categoria__'] ) && ! empty( $_REQUEST['__stats__']['__categoria__'] ) ) {
                    $ijn = 'INNER JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id AND categorie_prodotti_path_check( prodotti_categorie.id_categoria, ? ) ';
                    $cnd = array(
                        array( 's' => $_REQUEST['__stats__']['__categoria__'] ),
                        array( 's' => $_REQUEST['__stats__']['__inizio__'] ),
                        array( 's' => $_REQUEST['__stats__']['__fine__'] )
                    );
                }

                $dati = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT sum( documenti_articoli.quantita ) AS quantita, '.
                    'date_format( documenti.data, "' . $m . '" ) AS label '.
                    'FROM documenti_articoli '.
                    'INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento '.
                    'INNER JOIN articoli ON articoli.id = documenti_articoli.id_articolo '.
                    'INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto '.
                    $ijn.
                    'WHERE documenti.id_tipologia = 7 '.
                    'AND documenti.data >= ? AND documenti.data <= ? '.
                    $whr.
                    'GROUP BY date_format( documenti.data, "' . $m . '" )',
                    $cnd
                );

                // var_dump( $m );
                // print_r( $dati );
                // print_r( $_REQUEST );

                foreach( $dati as $row ) {
                    $ct['data']['grafico']['corrente'][ $row['label'] ] = $ds['corrente'][ $row['label'] ] = array( 'value' => $row['quantita'] );
                }

                // print_r( $ct['data'] );

                $ct['page']['contents']['chartjs'] = array(
                    'grafico' => array(
                        'type' => 'line',
                        'data' => array(
                            'labels' => $ct['data']['labels'],
                            'datasets' => array(
                                'corrente' => array(
                                    'data' => $ds['corrente']
                                )
                            )
                        )
                    )
                );

                if( $_REQUEST['__stats__']['__confronto__'] == 'ANNO' ) {

                    $whr = NULL;
                    $ijn = NULL;
                    $cnd = array(
                        array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__inizio__'] . ' -1 year' ) ) ),
                        array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__fine__'] . ' -1 year' ) ) )
                    );

                    if( isset( $_REQUEST['__stats__']['__categoria__'] ) && ! empty( $_REQUEST['__stats__']['__categoria__'] ) ) {
                        $ijn = 'INNER JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id AND categorie_prodotti_path_check( prodotti_categorie.id_categoria, ? ) ';
                        $cnd = array(
                            array( 's' => $_REQUEST['__stats__']['__categoria__'] ),
                            array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__inizio__'] . ' -1 year' ) ) ),
                            array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__fine__'] . ' -1 year' ) ) )
                            );
                    }
        
                    $dati = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT sum( documenti_articoli.quantita ) AS quantita, '.
                        'date_format( documenti.data, "' . $m . '" ) AS label '.
                        'FROM documenti_articoli '.
                        'INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento '.
                        'INNER JOIN articoli ON articoli.id = documenti_articoli.id_articolo '.
                        'INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto '.
                        $ijn.
                        'WHERE documenti.id_tipologia = 7 '.
                        'AND documenti.data >= ? AND documenti.data <= ? '.
                        $whr.
                        'GROUP BY date_format( documenti.data, "' . $m . '" )',
                        $cnd
                    );

                    // var_dump( date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__inizio__'] . ' -1 year' ) ) );
                    // var_dump( date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__fine__'] . ' -1 year' ) ) );
                    // var_dump( $m );
                    // print_r( $dati );

                    foreach( $dati as $row ) {
                        // $row['label'] = str_replace( date( 'Y', strtotime( $_REQUEST['__stats__']['__inizio__'] ) ) - 1, date( 'Y', strtotime( $_REQUEST['__stats__']['__inizio__'] ) ), $row['label'] );
                        // $ct['data']['grafico']['precedente'][ $row['label'] ] = $ds['precedente'][ $row['label'] ] = array( 'value' => $row['quantita'] );
                        $row['label'] = date( $d, strtotime( $row['label'] . ' +1 year' ) );
                        $ct['data']['grafico']['precedente'][ $row['label'] ] = $ds['precedente'][ $row['label'] ] = array( 'value' => $row['quantita'] );
                    }
        
                    if( isset( $ds['precedente'] ) ) {

                        $ct['page']['contents']['chartjs']['grafico']['data']['datasets']['precedente']['data'] = $ds['precedente'];

                        $ct['page']['contents']['chartjs']['grafico']['data']['datasets']['precedente']['options'] = array(
                            'bgColor' => 'rgb( 187, 187, 187 )', 'bdColor' => 'rgb( 187, 187, 187 )'
                        );

                    }

                }

            break;

            case 'MARGINE_ORDINI':
            break;

        }

    }

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';
	
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // debug
    // print_r( $ct['data'] );
    // print_r( $dati );
