<?php

    /**
     * macro dashboard amministrazione
     *
     *
     *
     *
     * @todo implementare
     * @todo documentare
     *
     * @file
     *
     */

    // ID della vista
    $ct['view']['id'] = md5(
		$ct['page']['id'] . 'amministrazione' . $_SESSION['__view__']['__site__']
	);

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    '00.notifiche' => array(
			'label' => 'notifiche'
		),
        '10.scorciatoie' => array(
            'label' => 'azioni rapide'
        ),
        '20.andamento' => array(
            'label' => 'riepilogo fatturato'
        )
	);

	if( in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {

        // riepilogo fatture attive
        $ct['page']['contents']['metro']['00.notifiche'][] = array(
            'url' => $cf['contents']['pages']['fatture.amministrazione.view']['url'][ LINGUA_CORRENTE ],
            'h4' => '25/500',
            'title' => 'documenti utilizzati',
            'text' => 'una volta esaurito il credito dovrai ricaricarlo per inviare altri documenti'
        );

        // riepilogo fattura da verifacre
        $ct['page']['contents']['metro']['00.notifiche'][] = array(
            'url' => $cf['contents']['pages']['fatture.passive.amministrazione.view']['url'][ LINGUA_CORRENTE ],
            'h4' => '15',
            'title' => 'nuove fatture passive',
            'text' => 'hai delle fatture passive scaricate ma non ancora visualizzate'
        );

        // inserimento nuova fattura attiva
        $ct['page']['contents']['metro']['10.scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['fatture.amministrazione.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'inserimento fattura attiva',
            'text' => 'inserisce una nuova fattura attiva'
        );

        // inserimento nuova proforma
        $ct['page']['contents']['metro']['10.scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['proforma.amministrazione.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'inserimento proforma',
            'text' => 'inserisce una nuova proforma'
        );

        // inserimento nuova nota di credito
        $ct['page']['contents']['metro']['10.scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['note.credito.amministrazione.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'inserimento nota di credito',
            'text' => 'inserisce una nuova nota di credito'
        );

        // inserimento nuova fattura
        $ct['page']['contents']['metro']['20.andamento'][] = array(
            'include' => 'inc/amministrazione.dashboard.html'
        );

        // default anno
        if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) ) {
            $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] = date('Y');
        }
    
        // etichette
        for( $m = 0; $m < 12; $m++ ) {
            $ts = strtotime( '+'.$m.' months', strtotime( date('Y').'-01-01' ) );
            $ct['data']['labels'][ date( 'm', $ts ) ] = strftime( '%B', $ts );
        }

        /*
        SELECT 
            data AS mese,
            sum( entrate ) AS entrate,
            sum( uscite ) AS uscite
        FROM ( 
            SELECT
                DATE_FORMAT(`data`,'%M'),
                importo_netto_totale,
                coalesce( documenti_articoli.importo_netto_totale, 0 ) AS entrate,
                0 AS uscite
            FROM documenti_articoli
            WHERE id_tipologia=1
        UNION
            SELECT
                DATE_FORMAT(`data`,'%M'),
                importo_netto_totale,
                0 AS entrate,
                coalesce( documenti_articoli.importo_netto_totale, 0 ) AS uscite
            FROM documenti_articoli
            WHERE id_tipologia=1
        ) AS 
        WHERE data BETWEEN "2019-01-01" AND "2019-12-31"
        ORDER BY mese ASC
        */

        // dati entrate
        foreach( $ct['data']['labels'] as $m => $l ) {
            $ct['data']['values']['entrate'][ $l ] = array( 'value' => 100.00 );
        }

        // dati uscite
        foreach( $ct['data']['labels'] as $m => $l ) {
            $ct['data']['values']['uscite'][ $l ] = array( 'value' => 100.00 );
        }

        // dati per il grafico
        $ct['page']['contents']['chartjs'] = array(
            'andamento' => array(
                'type' => 'bar',
                'data' => array(
                    'labels' => $ct['data']['labels'],
                    'datasets' => array(
                        'entrate' => array(
                            'data' => $ct['data']['values']['entrate'],
                            'options' => array(
                                'bgColor' => 'rgb( 128, 128, 128 )', 'bdColor' => 'rgb( 64, 64, 64 )'
                            )
                        ),
                        'uscite' => array(
                            'data' => $ct['data']['values']['uscite'],
                            'options' => array(
                                'bgColor' => 'rgb( 72, 72, 72 )', 'bdColor' => 'rgb( 64, 64, 64 )'
                            )
                        )
                    )
                ),
                'options' => array(
                    'responsive' => true,
                    'maintainAspectRatio' => false,
                    'scales' => array(
                        'x' => array(
                            'stacked' => false
                        ),
                        'y' => array(
                            'stacked' => false
                        )
                    )
                )
            )
        );

    }

    // tendina anni
	$ct['etc']['select']['anni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT DISTINCT year( documenti.data ) AS id, year( documenti.data ) AS __label__ FROM documenti ORDER BY __label__ DESC'
	);
