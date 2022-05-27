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

        // inserimento nuova fattura
        $ct['page']['contents']['metro']['10.scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['fatture.amministrazione.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'inserimento fattura',
            'text' => 'inserisce una nuova fattura'
        );

        // inserimento nuova fattura
        $ct['page']['contents']['metro']['20.andamento'][] = array(
            'include' => 'inc/amministrazione.dashboard.html'
        );

        // etichette
        for( $m = 0; $m < 12; $m++ ) {
            $ts = strtotime( '+'.$m.' months', strtotime( date('Y').'-01-01' ) );
            $ct['data']['labels'][ date( 'm', $ts ) ] = strftime( '%B', $ts );
        }

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