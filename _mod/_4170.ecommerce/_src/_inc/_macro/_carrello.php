<?php

    $ct['etc']['id_provincia'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT provincie.nome AS __label__, provincie.sigla, provincie.id 
        FROM provincie 
        INNER JOIN regioni ON provincie.id_regione = regioni.id 
        WHERE regioni.id_stato = ?
        ORDER BY __label__ ',
        array( array( 's' => ( ( $_SESSION['carrello']['intestazione_id_stato'] ) ? $_SESSION['carrello']['intestazione_id_stato'] : 1 ) ) )
    );

    $ct['etc']['id_stato'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT stati.nome AS __label__, stati.id '
        .'FROM stati '
        .'ORDER BY __label__ '
    );

    $ct['etc']['id_tipologia_documenti'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT tipologie_documenti.nome AS __label__, tipologie_documenti.id '
        .'FROM tipologie_documenti '
        .'WHERE tipologie_documenti.se_ecommerce = 1 '
        .'ORDER BY __label__ '
    );

	$ct['etc']['strategie_fatturazione'] = array( 
	    array( 'id' => 'SINGOLA', '__label__' => 'documento unico' ),
	    array( 'id' => 'MULTIPLA', '__label__' => 'documenti separati' ),
	);

	$ct['etc']['id_tipologia_anagrafica'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT tipologie_anagrafica_view.__label__, tipologie_anagrafica_view.id '
        .'FROM tipologie_anagrafica_view '
        .'WHERE tipologie_anagrafica_view.id_genitore IS NULL '
        .'ORDER BY __label__ '
    );
