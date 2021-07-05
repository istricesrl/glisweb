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
	 $ct['view']['table'] = 'cartellini';

	 // id della vista
	 if( ! isset( $ct['view']['id'] ) ) {
		 $ct['view']['id'] = md5( 'attivita' );
	 }

	// tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][ $mese ] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 2,  date( 'Y' ) ) as $y ) {
	    $ct['etc']['select']['anni'][ $y ] = $y ;
	}

	// array dei nomi giorni ( compatibile con i numeri della funzione date() )
	$nomigiorni = array(
		'1' => 'lun',
		'2' => 'mar',
		'3' => 'mer',
		'4' => 'gio',
		'5' => 'ven',
		'6' => 'sab',
		'7' => 'dom'
	);

	// preset filtri custom
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] = date('m');
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] = date('Y');
	}

    // tendina operatori
	$ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1');
	

	// costruzione della griglia
	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) && !empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) ) 
	{

		$mese = intval( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] );
		$anno = intval( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] );
		$anagrafica = $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'];

		// costruisco l'elenco giorni partendo da mese e anno
		$giorni = array();
		for( $d=1; $d<=31; $d++ )
		{
			$time=mktime(12, 0, 0, $mese, $d, $anno);          
			if (date('m', $time) == $mese){   
				$giorni[] = intval( date('d', $time) );
			}
		}

		// array delle festività
		$festivi = array(
			'01/01', 	// Capodanno
			'06/01',  	// Epifania
			date("d/m", easter_date( $anno ) ),		// Pasqua calcolata per l'anno corrente
			date("d/m", strtotime( date("Y-m-d", easter_date( $anno ) ) . '+ 1 days') ),	// Pasquetta calcolata per l'anno corrente
			'25/04',  	// Liberazione
			'01/05',  	// Festa Lavoratori
			'02/06',  	// Festa Repubblica
			'15/08',  	// Ferragosto
			'01/11',  	// Tutti i santi
			'08/12',  	// Immacolata
			'25/12',  	// Natale
			'26/12' 	// Santo Stefano
		);
		
		// inizializzo le ore totali di quadratura mensili
		$ct['etc']['totali_quadratura'] = array(
			'ordinarie_previste' => 0,
			'ordinarie_fatte' => 0
		 );

		// elenco dei giorni per il mese e l'anno specificati
		foreach( $giorni as $giorno ){
			$ct['etc']['ore'][ $giorno ]['data'] = date( 'd/m/Y', strtotime("$anno-$mese-$giorno") );
			
			// numero da 1 a 7, se la funzione date restituisce 0 (domenica) setto 7 per uniformità con i giorni degli orari_contratti
			$ct['etc']['ore'][ $giorno ]['numero'] = ( date( 'w', strtotime("$anno-$mese-$giorno") ) == 0 ) ? '7' : date( 'w', strtotime("$anno-$mese-$giorno") );
			
			// inizializzo a 0 le ore ordinarie totali previste ed effettuate
		#	$ct['etc']['ore'][ $giorno ]['ordinarie_previste'] = 0;
		#	$ct['etc']['ore'][ $giorno ]['ordinarie_fatte'] = 0;

			// lettura cartellino
			$cart = mysqlQuery(
				$cf['mysql']['connection'],
				'SELECT * FROM cartellini_view WHERE id_anagrafica = ? AND data_attivita = ?',
				array(
					array( 's' => $anagrafica ),
					array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-$giorno") ) )
				)
			);

			if( !empty( $cart ) ){
				foreach( $cart as $ca ){
					$ct['etc']['ore'][ $giorno ][$ca['id_tipologia_inps']]['ore_previste'] = $ca['ore_previste'];
					$ct['etc']['ore'][ $giorno ][$ca['id_tipologia_inps']]['ore_fatte'] = $ca['ore_fatte'];
				}
				$ct['etc']['totali_quadratura']['ordinarie_previste'] += $ca['ore_previste'];
				$ct['etc']['totali_quadratura']['ordinarie_fatte'] += $ca['ore_fatte'];
			}

			// nome del giorno (lun, mar, mer, ...)
			$ct['etc']['ore'][ $giorno ]['nome'] = $nomigiorni[ $ct['etc']['ore'][ $giorno ]['numero'] ];

			// verifico se il giorno è una domenica o una festività
			if( $ct['etc']['ore'][ $giorno ]['numero'] == 7 || 
				in_array( date( 'd/m', strtotime("$anno-$mese-$giorno") ), $festivi ) ){
				$ct['etc']['ore'][ $giorno ]['festivo'] = 1;
			}
		
		}

		// tipologie inps del cartellino
		$tipologie = mysqlQuery(
			$cf['mysql']['connection'], 
			'SELECT DISTINCT t.id, t.__label__ FROM tipologie_attivita_inps_view AS t INNER JOIN cartellini AS c ON t.id = c.id_tipologia_inps '
			.'WHERE month( c.data_attivita ) = ? AND year( c.data_attivita ) = ? AND c.id_anagrafica = ?',
			array(
				array( 's' => $mese ),
				array( 's' => $anno ),
				array( 's' => $anagrafica )
			)
		);

		if( !empty( $tipologie ) ){
			foreach( $tipologie as $t ){
				$ct['etc']['tipologie_attivita_inps'][$t['id']] = $t['__label__'];
			}
		}
	
	
/*		// confronto le ore ordinarie previste e fatte
		foreach( $ct['etc']['ore'] as &$g ){
			if( $g['ordinarie_fatte'] != $g['ordinarie_previste'] ){
				$g['extra'] = '1';
			}
			elseif( ($g['ordinarie_fatte'] == $g['ordinarie_previste']) && $g['ordinarie_fatte'] > 0 ){
				$g['extra'] = '0';
			}
		}

		// riepilogo ore per tipologia (colonna)
		$ore_tipologia = mysqlQuery( $cf['mysql']['connection'], 
			'SELECT id_tipologia_inps, sum(ore) as tot_ore FROM attivita_view_static WHERE anno = ? AND mese = ? and id_anagrafica = ? GROUP by id_tipologia_inps',
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

		if( $ct['etc']['totali_quadratura']['ordinarie_fatte'] > 0 || $ct['etc']['totali_quadratura']['ordinarie_previste'] > 0 ) {
			if( $ct['etc']['totali_quadratura']['ordinarie_fatte'] != $ct['etc']['totali_quadratura']['ordinarie_previste'] ){
				$ct['etc']['totali_quadratura']['extra'] = '1';
			}
			else{
				$ct['etc']['totali_quadratura']['extra'] = '0';
			}
		}
*/		
	}
   