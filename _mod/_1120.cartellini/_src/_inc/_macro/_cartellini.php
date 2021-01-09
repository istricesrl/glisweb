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
	 $ct['view']['table'] = 'attivita';

	 // id della vista
	 if( ! isset( $ct['view']['id'] ) ) {
		 /*
		 $ct['view']['id'] = md5(
		 $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
		 );
		 */
		 $ct['view']['id'] = md5( $ct['view']['table'] );
	 }

		// tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][ $mese ] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 5,  date( 'Y' ) ) as $y ) {
	    $ct['etc']['select']['anni'][ $y ] = $y ;
	}

	// preset filtri custom
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] = date('m');
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] = date('yy');
	}

    // tendina operatori
	$ct['etc']['select']['operatori'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1');
	
	// elenco tipologie attività inps
/*	$ct['etc']['tipologie_attivita_inps'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
		'SELECT id, __label__ FROM tipologie_attivita_inps_view ORDER BY id'
	);

	print_r( $ct['etc']['tipologie_attivita_inps'] );
*/

	// costruzione della griglia
	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) && !empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) ) 
	{

		// costruisco l'elenco giorni partendo da mese e anno
		$giorni = array();
		$mese = intval( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] );
		$anno = intval( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] );
		
		for( $d=1; $d<=31; $d++ )
		{
			$time=mktime(12, 0, 0, $mese, $d, $anno);          
			if (date('m', $time) == $mese){   
				$giorni[] = intval( date('d', $time) );
			}
		}

		// elenco delle date per il mese e l'anno specificati
		foreach( $giorni as $giorno ){
			$ct['etc']['ore'][ $giorno ]['data'] = date( 'd/m/Y', strtotime("$anno-$mese-$giorno") );
			$ct['etc']['ore'][ $giorno ]['numero'] = date( 'w', strtotime("$anno-$mese-$giorno") );
		}

		// costruisco l'array delle tipologie attivita inps da mostrare
		// inizializzazioni
		$to = $tf = array();

		// tipologie standard da mostrare sempre
		$tf = mysqlCachedQuery(
			$cf['memcache']['connection'], 
			$cf['mysql']['connection'], 
			'SELECT id, nome FROM tipologie_attivita_inps WHERE id IN (1,2) ORDER BY id'
		);

		// tipologia aggiuntiva eventualmente indicata dalla tendina
		if( isset( $_REQUEST['__cartellini__']['tipologia_aggiuntiva'] ) && !empty( isset( $_REQUEST['__cartellini__']['tipologia_aggiuntiva'] ) ) ){
			$ta = mysqlCachedQuery(
				$cf['memcache']['connection'], 
				$cf['mysql']['connection'], 
				'SELECT id, nome FROM tipologie_attivita_inps WHERE id = ? ORDER BY id',
				array( array( 's' => $_REQUEST['__cartellini__']['tipologia_aggiuntiva'] ) )
			);
		}

		// tipologie relative alle attivita già fatte dall'operatore escluse le fisse
		$to = mysqlCachedQuery(
			$cf['memcache']['connection'], 
			$cf['mysql']['connection'], 
			'SELECT DISTINCT tipologie_attivita_inps.id, tipologie_attivita_inps.nome FROM tipologie_attivita_inps ' .
			'INNER JOIN attivita_view ON tipologie_attivita_inps.id = attivita_view.id_tipologia_inps '.
			'WHERE attivita_view.anno = ? AND attivita_view.mese = ? AND attivita_view.id_anagrafica = ? '.
			'AND tipologie_attivita_inps.id NOT IN (1,2)',
			array(
				array( 's' => $anno ),
				array( 's' => $mese ),
				array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
			)
		);

		// elenco finale delle tipologie da mostrare
		$ct['etc']['tipologie_attivita_inps'] = array_merge( $to, $tf );

		if( isset( $ta ) && !empty( $ta ) ){
			$ct['etc']['tipologie_attivita_inps'] = array_merge( $ct['etc']['tipologie_attivita_inps'], $ta );
		}

		// tendina delle tipologie rimanenti
		$ct['etc']['select']['tipologie_attivita_inps'] = mysqlCachedQuery(
			$cf['memcache']['connection'], 
			$cf['mysql']['connection'], 
			'SELECT DISTINCT id, nome FROM tipologie_attivita_inps ' .
			'WHERE id NOT IN (1,2) AND id NOT IN (SELECT DISTINCT id_tipologia_inps FROM attivita_view '.
			'WHERE attivita_view.anno = ? AND attivita_view.mese = ? AND attivita_view.id_anagrafica = ? )',
			array(
				array( 's' => $anno ),
				array( 's' => $mese ),
				array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
			)
		);

		// ricavo il riepilogo attività presenti
		$attivita = mysqlQuery( $cf['mysql']['connection'], 
		'SELECT giorno, id_tipologia_inps, sum(ore) as tot_ore FROM attivita_view WHERE anno = ? AND mese = ? and id_anagrafica = ? GROUP by data, id_tipologia_inps',
		array(
			array( 's' => $anno ),
			array( 's' => $mese ),
			array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
		)			
		);
		
		if( !empty( $attivita ) ){
			foreach( $attivita as $a ){
				$ct['etc']['ore'][ $a['giorno'] ]['tipologie_inps'][ $a['id_tipologia_inps'] ] = $a['tot_ore'];
			}
		}

/*		$ore_giorno = mysqlQuery( $cf['mysql']['connection'], 
		'SELECT giorno, sum(ore) as tot_ore FROM attivita_view WHERE anno = ? AND mese = ? and id_anagrafica = ? GROUP by data',
		array(
			array( 's' => $anno ),
			array( 's' => $mese ),
			array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
		)			
		);
		
		if( !empty( $ore_giorno ) ){
			foreach( $ore_giorno as $og ){
				$ct['etc']['ore'][ $og['giorno'] ]['ore_totali'] = $og['tot_ore'];
			}
		}
*/

		$ore_tipologia = mysqlQuery( $cf['mysql']['connection'], 
		'SELECT id_tipologia_inps, sum(ore) as tot_ore FROM attivita_view WHERE anno = ? AND mese = ? and id_anagrafica = ? GROUP by id_tipologia_inps',
		array(
			array( 's' => $anno ),
			array( 's' => $mese ),
			array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
		)			
		);
		
		if( !empty( $ore_tipologia ) ){
			foreach( $ore_tipologia as $ot ){
				$ct['etc']['tipologie'][ $ot['id_tipologia_inps'] ]['ore_totali'] = $ot['tot_ore'];
			}
		}
		
	}
   