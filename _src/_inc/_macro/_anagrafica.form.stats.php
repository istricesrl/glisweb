<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */
    
    // tabella gestita
    $ct['form']['table'] = 'anagrafica';

    // tendina sesso
	$ct['etc']['select']['sorgenti'] = array( 
	    array( 'id' => 'IMPORTO_ORDINI', '__label__' => 'importo degli ordini' ),
	    array( 'id' => 'MARGINE_ORDINI', '__label__' => 'utile degli ordini' ),
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.stats.php';
    
    // ...
    switch( $_REQUEST['__stats__']['__sorgente__'] ) {

        case 'IMPORTO_ORDINI':

            $dati = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT sum( documenti_articoli.importo_netto_totale ) AS importo, '.
                'date_format( documenti.data, "' . $m . '" ) AS label '.
                'FROM documenti_articoli '.
                'INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento '.
                'WHERE documenti.id_tipologia = 7 '.
                'AND documenti.id_emittente = ? '.
                'AND documenti.data BETWEEN ? AND ? '.
                'GROUP BY date_format( documenti.data, "' . $m . '" )',
                array(
                    array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                    array( 's' => $_REQUEST['__stats__']['__inizio__'] ),
                    array( 's' => $_REQUEST['__stats__']['__fine__'] )
                )
            );

            foreach( $dati as $row ) {
                $ct['data']['grafico']['base'][ $row['label'] ] = $ds['base'][ $row['label'] ] = array( 'value' => $row['importo'] );
            }

            $ct['page']['contents']['chartjs'] = array(
                'grafico' => array(
                    'type' => 'line',
                    'data' => array(
                        'labels' => $ct['data']['labels'],
                        'datasets' => array(
                            'base' => array(
                                'data' => $ds['base']
                            )
                        )
                    )
                )
            );

            if( $_REQUEST['__stats__']['__confronto__'] == 'ANNO' ) {

                $dati = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT sum( documenti_articoli.importo_netto_totale ) AS importo, '.
                    'date_format( documenti.data, "' . $m . '" ) AS label '.
                    'FROM documenti_articoli '.
                    'INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento '.
                    'WHERE documenti.id_tipologia = 7 '.
                    'AND documenti.data BETWEEN ? AND ? '.
                    'GROUP BY date_format( documenti.data, "' . $m . '" )',
                    array(
                        array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__inizio__'] . ' -1 year' ) ) ),
                        array( 's' => date( 'Y-m-d', strtotime( $_REQUEST['__stats__']['__fine__'] . ' -1 year' ) ) )
                    )
                );
    
                foreach( $dati as $row ) {
                    $row['label'] = str_replace( date( 'Y' ) - 1, date( 'Y' ), $row['label'] );
                    $ct['data']['grafico']['precedente'][ $row['label'] ] = $ds['precedente'][ $row['label'] ] = array( 'value' => $row['importo'] );
                }
    
                $ct['page']['contents']['chartjs']['grafico']['data']['datasets']['precedente']['data'] = $ds['precedente'];

            }

        break;

        case 'MARGINE_ORDINI':
        break;
    
    }

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';
	
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // debug
    // print_r( $ct['data'] );
    // print_r( $dati );
