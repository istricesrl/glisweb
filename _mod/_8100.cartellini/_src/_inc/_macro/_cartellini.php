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
	$ct['etc']['select']['operatori'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1');
	

	// costruzione della griglia
	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) && !empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) ) 
	{

		$mese = intval( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] );
		$anno = intval( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] );

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
			$ct['etc']['ore'][ $giorno ]['ordinarie_previste'] = 0;
			$ct['etc']['ore'][ $giorno ]['ordinarie_fatte'] = 0;

			// ricavo il contratto attivo alla data corrente
			$contratto = mysqlSelectValue(
				$cf['mysql']['connection'], 
				'SELECT id FROM contratti WHERE id_anagrafica = ? AND data_inizio <= ? AND  ( '.
				'data_fine_rapporto >= ? OR ( data_fine_rapporto IS NULL AND ( data_fine IS NULL or data_fine >= ? )  ) ' .
				') ORDER BY id DESC LIMIT 1',
				array(
					array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ),
					array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-$giorno") ) ),
					array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-$giorno") ) ),
					array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-$giorno") ) )
				)
			);

			if( !empty( $contratto ) ){

				// verifico se la data corrente è nella tabella turni e ricavo il turno corrispondente
				$turno = mysqlSelectValue(
					$cf['mysql']['connection'], 
					'SELECT turno FROM turni WHERE id_contratto = ? AND (data_inizio <= ? AND data_fine >= ?) ORDER BY id DESC LIMIT 1',
					array( 
						array( 's' => $contratto ),
						array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-$giorno") ) ),
						array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-$giorno") ) )
					)
				);
			

				// se ci sono turni devo considerare la tabella turni e vedere se la data corrente è in essi
				if( empty( $turno ) ){
					$turno = 1;
				}

				// ore ordinarie e di quadratura previste da contratto per quel giorno
				$ct['etc']['ore'][ $giorno ]['ordinarie_previste'] = mysqlSelectValue(
					$cf['mysql']['connection'], 
					'SELECT sum( time_to_sec( timediff( ora_fine, ora_inizio ) ) / 3600 ) as tot_ore FROM orari_contratti ' .
					'INNER JOIN costi_contratti ON orari_contratti.id_costo = costi_contratti.id ' .
					'INNER JOIN tipologie_attivita_inps ON costi_contratti.id_tipologia = tipologie_attivita_inps.id ' .
					'WHERE tipologie_attivita_inps.se_quadratura = 1 AND orari_contratti.se_lavoro = 1 ' .
					'AND orari_contratti.id_giorno = ? ' . 
					'AND orari_contratti.id_contratto = ? AND orari_contratti.turno = ? ' .
					'GROUP BY orari_contratti.id_giorno',
					array(
						array( 's' => $ct['etc']['ore'][ $giorno ]['numero'] ),
						array( 's' => $contratto ),
						array( 's' => $turno )
					)
				);

			}

			if( !empty( $ct['etc']['ore'][ $giorno ]['ordinarie_previste'] ) ){
				$ct['etc']['totali_quadratura']['ordinarie_previste'] += $ct['etc']['ore'][ $giorno ]['ordinarie_previste'];
			}

			// nome del giorno (lun, mar, mer, ...)
			$ct['etc']['ore'][ $giorno ]['nome'] = $nomigiorni[ $ct['etc']['ore'][ $giorno ]['numero'] ];

			// verifico se il giorno è una domenica o una festività
			if( $ct['etc']['ore'][ $giorno ]['numero'] == 7 || 
				in_array( date( 'd/m', strtotime("$anno-$mese-$giorno") ), $festivi ) ){
				$ct['etc']['ore'][ $giorno ]['festivo'] = 1;
			}
		
		}

		// costruisco l'array delle tipologie attivita inps da mostrare
		// inizializzazioni
		$to = $tf = array();

		// tipologie standard da mostrare sempre (ordinario e straordinario)
		$tf = mysqlCachedQuery(
			$cf['memcache']['connection'], 
			$cf['mysql']['connection'], 
			'SELECT id, __label__ FROM tipologie_attivita_inps_view WHERE id IN (1,2) ORDER BY id'
		);

		// tipologia aggiuntiva eventualmente indicata dalla tendina
		if( isset( $_REQUEST['__cartellini__']['tipologia_aggiuntiva'] ) && !empty( isset( $_REQUEST['__cartellini__']['tipologia_aggiuntiva'] ) ) ){
			$ta = mysqlQuery(
				$cf['mysql']['connection'], 
				'SELECT id, __label__ FROM tipologie_attivita_inps_view WHERE id = ? ORDER BY id',
				array( array( 's' => $_REQUEST['__cartellini__']['tipologia_aggiuntiva'] ) )
			);
		}

		// tipologie relative alle attivita già fatte dall'operatore escluse quelle standard
		$to = mysqlQuery(
			$cf['mysql']['connection'], 
			'SELECT DISTINCT tipologie_attivita_inps_view.id, tipologie_attivita_inps_view.__label__ FROM tipologie_attivita_inps_view ' .
			'INNER JOIN attivita_view_static ON tipologie_attivita_inps_view.id = attivita_view_static.id_tipologia_inps '.
			'WHERE attivita_view_static.anno_attivita = ? AND attivita_view_static.mese_attivita = ? AND attivita_view_static.id_anagrafica = ? '.
			'AND tipologie_attivita_inps_view.id NOT IN (1,2)',
			array(
				array( 's' => $anno ),
				array( 's' => $mese ),
				array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
			)
		);

		
		// elenco finale delle tipologie da mostrare
		// merge tra quelle fisse e quelle dell'operatore
		$ct['etc']['tipologie_attivita_inps'] = array_merge( $to, $tf );

		// merge delle precedenti con quella eventualmente selezionata dalla tendina
		if( isset( $ta ) && !empty( $ta ) ){
			$ct['etc']['tipologie_attivita_inps'] = array_merge( $ct['etc']['tipologie_attivita_inps'], $ta );
		}

		// tendina delle tipologie rimanenti
		$ct['etc']['select']['tipologie_attivita_inps'] = mysqlQuery(
			$cf['mysql']['connection'], 
			'SELECT DISTINCT id, __label__ FROM tipologie_attivita_inps_view ' .
			'WHERE id NOT IN (1,2) '. 			// escludo le tipologie fisse
			( ( isset( $ta ) && !empty( $ta ) ) ? 'AND id <> ' . $ta[0]['id'] : '' ) . ' ' . 	// escludo l'eventuale valore già selezionato con la tendina
			'AND id NOT IN (SELECT DISTINCT id_tipologia_inps FROM attivita_view_static '.		// escludo le tipologie di attività fatte dall'operatore
			'WHERE attivita_view_static.anno_attivita = ? AND attivita_view_static.mese_attivita = ? AND attivita_view_static.id_anagrafica = ? )',
			array(
				array( 's' => $anno ),
				array( 's' => $mese ),
				array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
			)
		);

		// ricavo il riepilogo attività presenti
		$attivita = mysqlQuery( 
			$cf['mysql']['connection'], 
			'SELECT giorno, id_tipologia_inps, tipologie_attivita_inps.se_quadratura, sum(ore) as tot_ore FROM attivita_view_static ' .
			'INNER JOIN tipologie_attivita_inps ON attivita_view_static.id_tipologia_inps = tipologie_attivita_inps.id ' .
			'WHERE anno_attivita = ? AND mese_attivita = ? and id_anagrafica = ? GROUP by data_attivita, id_tipologia_inps',
			array(
				array( 's' => $anno ),
				array( 's' => $mese ),
				array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
			)			
		);
		
		if( !empty( $attivita ) ){
			foreach( $attivita as $a ){
				$ct['etc']['ore'][ $a['giorno'] ]['tipologie_inps'][ $a['id_tipologia_inps'] ] = $a['tot_ore'];

				// setto le ore ordinarie e altre di quadratura totali fatte
				if( $a['se_quadratura'] == 1 ){
					$ct['etc']['ore'][ $a['giorno'] ]['ordinarie_fatte'] += $a['tot_ore'];
					$ct['etc']['totali_quadratura']['ordinarie_fatte'] += $a['tot_ore'];
				}
			}
		}

		// confronto le ore ordinarie previste e fatte
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
			'SELECT id_tipologia_inps, sum(ore) as tot_ore FROM attivita_view_static WHERE anno_attivita = ? AND mese_attivita = ? and id_anagrafica = ? GROUP by id_tipologia_inps',
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
		
	}
   