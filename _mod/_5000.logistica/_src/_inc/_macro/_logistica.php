<?php

    /**
     * macro dashboard logistica
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
	    'notifiche' => array(
			'label' => 'notifiche'
		),
	    'scorciatoie' => array(
			'label' => 'azioni rapide'
		)
	);
/*
	if( in_array( "0400.documenti", $cf['mods']['active']['array'] ) ) {

        // ricerca ordini da evadere
        $ordini = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT documenti.id, documenti.data, documenti.numero FROM documenti INNER JOIN __report_dettaglio_evasione_ordini__ AS r ON r.id_ordine = documenti.id WHERE r.quantita_da_evadere > 0 AND documenti.timestamp_invio IS NOT NULL AND documenti.timestamp_chiusura IS NULL GROUP BY documenti.id'
        );

        foreach( $ordini as $ordine ) {
            $ct['page']['contents']['metro']['notifiche'][] = array(
                'url' => $cf['contents']['pages']['ddt.magazzini.form']['url'][ LINGUA_CORRENTE ] . '?__ordine_da_evadere__=' . $ordine['id'],
                'icon' => NULL,
                'fa' => 'fa-plus-square',
                'title' => 'evadi ordine n. ' . $ordine['numero'] . ' del ' . date('d/m/Y', strtotime($ordine['data'])),
                'text' => 'inserisce un nuovo DDT attivo per evadere l\'ordine',
                'colspan' => 3
            );
        }

        // inserimento nuovo DDT attivo
        $ct['page']['contents']['metro']['scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['ddt.magazzini.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'inserimento DDT attivo',
            'text' => 'inserisce un nuovo DDT attivo',
            'colspan' => 3
        );

        // inserimento nuovo DDT passivo
        $ct['page']['contents']['metro']['scorciatoie'][] = array(
            'url' => $cf['contents']['pages']['ddt.passivi.magazzini.form']['url'][ LINGUA_CORRENTE ],
            'icon' => NULL,
            'fa' => 'fa-plus-square',
            'title' => 'inserimento DDT passivo',
            'text' => 'inserisce un nuovo DDT passivo',
            'colspan' => 3
        );

    }
*/
