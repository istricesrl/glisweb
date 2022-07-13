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
	 $ct['view']['table'] = 'righe_cartellini';

	 // id della vista
	 $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
    );

	if( isset( $_REQUEST['__filters__'] )  ) {
		if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] ) ) {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] = array_replace_recursive(
				$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'],
				$_REQUEST['__filters__']
			);
		} else {
			$_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'] = $_REQUEST['__filters__'];
		}
	}

	// tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][ $mese ] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 2,  date( 'Y' ) + 1 ) as $y ) {
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

	if( !empty( $ct['etc']['select']['operatori'] ) ){
		foreach( $ct['etc']['select']['operatori'] as $op ){
			$ct['etc']['anagrafica'][$op['id']] = $op['__label__'];
		}
	}
	
	// tipologia inps per le ore ordinarie
	$idT_inps_ordinario = mysqlSelectValue( 
		$cf['mysql']['connection'], 
		'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
		array( array( 's' => '01') )
	);

	// tipologia inps per le ore straordinarie
	$idT_inps_straordinario = mysqlSelectValue( 
		$cf['mysql']['connection'], 
		'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
		array( array( 's' => 'LS') )
	);

	// tipologia inps per le ore lavorate nei giorni festivi
	$idT_inps_festivo = mysqlSelectValue( 
		$cf['mysql']['connection'], 
		'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
		array( array( 's' => 'LF1') )
	);  

	// costruzione della griglia
	if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) && !empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) ) 
	{

		$mese = intval( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] );
		$anno = intval( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] );
		$anagrafica = $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'];

		if( isset( $_REQUEST['__approve__'] ) ){
			$approvazione = mysqlQuery(
				$cf['mysql']['connection'], 
				'UPDATE cartellini SET timestamp_approvazione = ?, id_account_approvazione = ? '.
				'WHERE id_anagrafica = ? AND mese = ? AND anno = ? ',
				array(
					array( 's' => time() ),
					array( 's' => ( isset( $_SESSION['account']['id'] ) ? $_SESSION['account']['id'] : NULL ) ),
					array( 's' => $anagrafica ),
					array( 's' => $mese ),
					array( 's' => $anno )
				)

			);
		}

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
		$festivi = getHolidays( $anno, 'd/m' );

		// tipologie inps del cartellino
		$tipologie = mysqlQuery(
			$cf['mysql']['connection'], 
			'SELECT DISTINCT t.id, t.__label__ FROM tipologie_attivita_inps_view AS t INNER JOIN righe_cartellini AS c ON t.id = c.id_tipologia_inps '
			.'WHERE month( c.data_attivita ) = ? AND year( c.data_attivita ) = ? AND c.id_anagrafica = ?',
			array(
				array( 's' => $mese ),
				array( 's' => $anno ),
				array( 's' => $anagrafica )
			)
		);

		// inizializzo le ore totali mensili per tipologia inps
		if( !empty( $tipologie ) ){
			foreach( $tipologie as $t ){
				$ct['etc']['tipologie_attivita_inps'][$t['id']]['id'] = $t['id'];
				$ct['etc']['tipologie_attivita_inps'][$t['id']]['nome'] = $t['__label__'];
				$ct['etc']['tipologie_attivita_inps'][$t['id']]['ore_totali'] = 0;
			}
		}

		// inizializzo le ore totali mensili complessive
		$ct['etc']['ore_totali'] = array(
			'ore_contratto' => 0,
			'ore_lavorate' => 0,
			'ore_variazioni' => 0
		 );

		 // leggo i dati del cartellino
		 $cartellino = mysqlSelectRow(
			$cf['mysql']['connection'], 
			'SELECT cartellini.* FROM cartellini WHERE mese = ? AND anno = ? AND id_anagrafica = ? ',
			array(
				array( 's' =>  $mese ),
				array( 's' =>  $anno ),
				array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] )
			)
		);
		
		if( !empty( $cartellino ) &&  $cartellino['timestamp_approvazione'] > 0 ){
				
			if( !empty( $cartellino['id_account_approvazione'] ) ){
				$account = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT anagrafica_view_static.__label__ FROM anagrafica_view_static LEFT JOIN account ON account.id_anagrafica = anagrafica_view_static.id WHERE account.id = ? ',
				array( array( 's' => $cartellino['id_account_approvazione'] ) ) );
			}
				
			$ct['etc']['approvazione'] = 'approvato il '. date( 'd/m/Y', $cartellino['timestamp_approvazione'] ).' alle '. date( 'H:i', $cartellino['timestamp_approvazione'] ).( isset( $account ) ? ' da '.$account : '');
		}

		// elenco dei giorni per il mese e l'anno specificati
		foreach( $giorni as $giorno ){
			
			$ct['etc']['ore'][ $giorno ]['data'] = date( 'd/m/Y', strtotime("$anno-$mese-$giorno") );
			
			// numero da 1 a 7, se la funzione date restituisce 0 (domenica) setto 7 per uniformità con i giorni degli orari_contratti
			$ct['etc']['ore'][ $giorno ]['numero'] = ( date( 'w', strtotime("$anno-$mese-$giorno") ) == 0 ) ? '7' : date( 'w', strtotime("$anno-$mese-$giorno") );

			// nome del giorno (lun, mar, mer, ...)
			$ct['etc']['ore'][ $giorno ]['nome'] = $nomigiorni[ $ct['etc']['ore'][ $giorno ]['numero'] ];

			// verifico se il giorno è una domenica o una festività
			if( $ct['etc']['ore'][ $giorno ]['numero'] == 7 || 
				in_array( date( 'd/m', strtotime("$anno-$mese-$giorno") ), $festivi ) ){
				$ct['etc']['ore'][ $giorno ]['festivo'] = 1;
			}
			
			// lettura righe cartellino
			$righecart = mysqlQuery(
				$cf['mysql']['connection'],
				'SELECT * FROM righe_cartellini_view WHERE id_anagrafica = ? AND data_attivita = ?',
				array(
					array( 's' => $anagrafica ),
					array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-$giorno") ) )
				)
			);

			if( !empty( $righecart ) ){
				foreach( $righecart as $ca ){
					$ct['etc']['ore'][ $giorno ]['ore_fatte'][$ca['id_tipologia_inps']] = $ca['ore_fatte'];
					$ct['etc']['ore'][ $giorno ]['id_riga'][$ca['id_tipologia_inps']] = $ca['id'];
					
					// totali per riga e complessivi in base a: contratto, lavorate, variazioni
					if( !isset( $ct['etc']['ore'][ $giorno ]['totali']['ore_contratto'] ) ){
						$ct['etc']['ore'][ $giorno ]['totali']['ore_contratto'] = $ca['ore_previste'];
					}
					else{
						$ct['etc']['ore'][ $giorno ]['totali']['ore_contratto'] += $ca['ore_previste'];
					}

					$ct['etc']['ore_totali']['ore_contratto'] += $ca['ore_previste'];

					if( $ca['id_tipologia_inps'] == $idT_inps_ordinario || $ca['id_tipologia_inps'] == $idT_inps_straordinario || $ca['id_tipologia_inps'] == $idT_inps_festivo ){
						if( !isset( $ct['etc']['ore'][ $giorno ]['totali']['ore_lavorate'] ) ){
							$ct['etc']['ore'][ $giorno ]['totali']['ore_lavorate'] = $ca['ore_fatte'];
						}
						else{
							$ct['etc']['ore'][ $giorno ]['totali']['ore_lavorate'] += $ca['ore_fatte'];
						}

						$ct['etc']['ore_totali']['ore_lavorate'] += $ca['ore_fatte'];
					}
					else{
						if( !isset( $ct['etc']['ore'][ $giorno ]['totali']['ore_variazioni'] ) ){
							$ct['etc']['ore'][ $giorno ]['totali']['ore_variazioni'] = $ca['ore_fatte'];
						}
						else{
							$ct['etc']['ore'][ $giorno ]['totali']['ore_variazioni'] += $ca['ore_fatte'];
						}

						$ct['etc']['ore_totali']['ore_variazioni'] += $ca['ore_fatte'];
					}

					// totali per colonna per tipologia inps
					$ct['etc']['tipologie_attivita_inps'][$ca['id_tipologia_inps']]['ore_totali'] += $ca['ore_fatte'];
									
				}
			}		
		}
	}
	
	// modal per la conferma di ricalcolo cartellino
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'ricalcola', 'include' => 'inc/cartellini.modal.ricalcola.html' )
    );
    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

   