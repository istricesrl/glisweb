<?php

    $ct['etc']['id_provincia'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT provincie.nome AS __label__, provincie.sigla, provincie.id '
        .'FROM provincie '
        .'ORDER BY __label__ '
    );

    $ct['etc']['id_tipologia_documenti'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT tipologie_documenti.nome AS __label__, tipologie_documenti.id '
        .'FROM tipologie_documenti '
        // TODO .'WHERE tipologie_documenti.se_ecommerce = 1 '
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
        // TODO .'WHERE tipologie_anagrafica_view.se_ecommerce = 1 '
        .'ORDER BY __label__ '
    );

    $ct['etc']['id_zona'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT zone_view.__label__, zone_view.id '
        .'FROM zone_view '
        // TODO .'WHERE tipologie_anagrafica_view.se_ecommerce = 1 '
        .'ORDER BY __label__ '
    );

    $ct['etc']['id_listino'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT listini_view.__label__, listini_view.id '
        .'FROM listini_view '
        // TODO .'WHERE tipologie_anagrafica_view.se_ecommerce = 1 '
        .'ORDER BY __label__ '
    );

    $ct['etc']['coupon'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT coupon.id, coupon.sconto_fisso, coupon.id_anagrafica, sum( pagamenti.coupon_valore ) AS utilizzato
        FROM coupon 
        LEFT JOIN pagamenti ON coupon.id = pagamenti.id_coupon
        WHERE ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= NOW() ) AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= NOW() )
        GROUP BY coupon.id
        HAVING utilizzato < coupon.sconto_fisso
        ORDER BY coupon.id 
        '
    );

    // print_r( $_SESSION['carrello'] );
    // die( print_r( $ct['etc'], true ) );
