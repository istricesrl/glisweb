<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */


    // tabella della vista
	$ct['view']['table'] = 'tesseramenti';

    // tabella per la gestione degli oggetti esistenti
    $ct['view']['open']['table'] = 'contratti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'tesseramenti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
#        'codice' => 'numero tessera',
        'iscritti' => 'anagrafica',
#        'tipologia_rinnovo' => 'tipologia',
        'data_inizio' => 'inizio',
        'data_fine' => 'fine',
        NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'codice' => 'text-left d-none d-md-table-cell',
        'iscritti' => 'text-left',
        'tipologia_rinnovo' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // azioni
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            $pagato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM documenti_articoli INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento INNER JOIN pagamenti ON pagamenti.id_documento = documenti.id INNER JOIN rinnovi ON rinnovi.id = documenti_articoli.id_rinnovo WHERE rinnovi.id_contratto = ? AND pagamenti.data_pagamento IS NOT NULL', array( array( 's' => $row['id'] ) ) );
            if( empty( $pagato ) ) {
                $row[ NULL ] =  '<a href="'.$cf['contents']['pages'][ $ct['view']['open']['page'] ]['url'][ LINGUA_CORRENTE ].'?'.$ct['view']['open']['table'].'[id]='.$row['id'].'"><span class="media-left"><i class="fa fa-exclamation-triangle"></i></span></a>';
            }
        }
    }
