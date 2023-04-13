<?php

	// la funzione prende in ingresso il carrello i il documento
	// per ogni articolo va a cercare eventuali coupon di sconto e restituisce l'importo finale di sconto
    function calcolaCoupon( $c, $carrello = array(),  $documento = array() ) {
		
	#	writeToFile( 'chiamata funzione calcolaCoupon. Carrello ricevuto: ' . PHP_EOL . print_r( $carrello, true ), 'var/log/carts/coupon/coupon.'.time().'.log' );
		$sconto = 0;
		$coupon = array();

		// se ho un documento
		if( ! empty($documento) ){
		
			if( isset( $documento['coupon'] ) && !empty( $documento['coupon'] ) ){

				// TODO: bisognerebbe separare il caso in cui il codice coupon non esiste da quello in cui esiste ma non è più valido				
				
				// controllo che il codice coupon sia valido, altrimenti restituisco 0
				$coupon = mysqlSelectRow( $c, "SELECT * from coupon WHERE id = ? AND ("
										. "(timestamp_inizio IS NULL AND timestamp_fine IS NULL) OR (timestamp_inizio <= ? AND timestamp_fine >= ?) OR (timestamp_inizio <= ? AND timestamp_fine IS NULL) )", 
							array(
								array( "s" => $documento['coupon']),
								array( "s" => time() ),
								array( "s" => time() ),
								array( "s" => time() )
							)
						);
				
				// TODO: inserire la parte di verifica per il multiuso

					
			}
			
			// se ho un coupon valido
			if( !empty( $coupon ) ) {
				
				// verifico se lo sconto è in percentuale o in euro
				$sconto_fisso = ( !empty( $coupon['sconto_fisso'] ) ) ? $coupon['sconto_fisso'] : 0;
				$sconto_perc = ( !empty( $coupon['sconto_percentuale'] ) ) ? $coupon['sconto_percentuale'] : 0;


				// per ogni articolo vado a vedere se posso applicare lo sconto
				foreach( $documento['documenti_articoli'] as $articolo ) {
					
				// cerco il prodotto per l'articolo corrente
					$prodotto = mysqlSelectValue( $c, "SELECT id_prodotto from articoli WHERE id = ? ",
											array(
												array( "s" => $articolo['id_articolo'] )
											)
											);
				
				// leggo i dati sul prezzo del prodotto per chiamare la variazionePrezzo							
					$prodRow = mysqlSelectRow( $c, "SELECT * from prezzi_view WHERE id_prodotto = ? AND id_listino = ? ",
											array(
												array( "s" => $prodotto ),
												array( "s" => $articolo['id_listino'] )
											)
											);

					//$variazione_prezzo = variazionePrezzo( $c, $articolo['id_listino'], $prodotto, $prodRow['prezzo_lordo']);

					// se non c'è variazione sull'articolo procedo col calcolo del coupon
					//if( empty( $variazione_prezzo['tipoSconto'] ) ) {
                     if( true ) {

						// verifico se lo sconto è globale (es. nuovi utenti o iscrizione newsletter)
						if( $coupon['se_globale'] == 1 ){
							$verificato = 1;	// l'articolo è automaticamente verificato (lo sconto vale per tutto)
						}
						else {
							$verificato = 0;	// l'articolo deve essere verificato tramite prodotto e/o categoria
						}
						
						
					// 1) se lo sconto non è globale verifico se è associato al prodotto di cui fa parte l'articolo					
						if( $verificato == 0 ){

							$check_prodotto = mysqlSelectValue( $c, "SELECT id from coupon_prodotti WHERE id_coupon = ? AND id_prodotto = ?",
												array(
													array( "s" => $coupon['id']),
													array( "s" => $prodotto )
												)
												);
							
							// se lo sconto era applicato al prodotto, l'articolo è verificato
							if( !empty( $check_prodotto ) ){
								$verificato = 1;
							}
						}
						
						
					// 2) se la verifica sul prodotto non ha dato esito positivo, verifico sulla categoria
						if( $verificato == 0 ){
							
							$categoria = mysqlSelectValue( $c, "SELECT id_categoria from prodotti_categorie WHERE id_prodotto = ? ORDER BY ordine ASC",
											array(
												array( "s" => $prodotto )
											)
											);
											
							// cerco l'elenco delle categorie genitore
							do {
								
								$check_categoria = mysqlSelectValue( $c, "SELECT id from coupon_categorie_prodotti WHERE id_coupon = ? AND id_categoria_prodotti = ?",
											array(
												array( "s" => $coupon['id']),
												array( "s" => $categoria )
											)
											);
								
								$genitore = mysqlSelectValue( $c, "SELECT id_genitore from categorie_prodotti WHERE id = ?", 
									array(
										array( "s" => $categoria)
									)
								);

								$categoria = $genitore;

							} while( $genitore != NULL && empty($check_categoria) );
						
							if( !empty( $check_categoria ) ){
								$verificato = 1;
							}
						}
			
			// TODO testare la verifica per marchio
					// 4) se la verifica sulla categoria non ha dato esito positivo, verifico sul marchio
						if( $verificato == 0 ){
							
							$marchio = mysqlSelectValue( $c, "SELECT id_marchio from prodotti WHERE id_prodotto = ?",
											array(
												array( "s" => $prodotto )
											)
											);

							$check_marchio = mysqlSelectValue( $c, "SELECT id from coupon_marchi WHERE id_coupon = ? AND id_marchio = ?",
											array(
												array( "s" => $coupon['id']),
												array( "s" => $marchio )
											)
											);
							if( !empty( $check_marchio ) ){
								$verificato = 1;
							}
						}					
						
			// TODO testare la verifica per stagione
					// 4) se la verifica sul marchio non ha dato esito positivo, verifico sulla stagione
						if( $verificato == 0 ){
							
							$stagione = mysqlSelectValue( $c, "SELECT id_stagione from prodotti_stagioni WHERE id_prodotto = ? ORDER BY ordine ASC",
											array(
												array( "s" => $prodotto )
											)
											);

							$check_stagione = mysqlSelectValue( $c, "SELECT id from coupon_stagioni WHERE id_coupon = ? AND id_stagione = ?",
											array(
												array( "s" => $coupon['id']),
												array( "s" => $stagione )
											)
											);
							if( !empty( $check_stagione ) ){
								$verificato = 1;
							}
						}					



						
						// se l'articolo (per prodotto o categoria di appartenenza) rientra nello sconto, calcolo lo sconto
						if( $verificato == 1 ){
								
							// se è fisso
							if( $sconto_fisso > 0 ){
								$sconto = $sconto_fisso;
								return $sconto;
							}
							elseif( $sconto_perc > 0 ){
					
								$sconto += $articolo['totale_riga'] * $sconto_perc/100;

							}						
						}
					}
				}
			}	
		}

		// se ho un carrello pieno...
		if( ! empty($carrello) ){
		
			if( isset( $carrello['coupon'] ) && !empty( $carrello['coupon'] ) ){

				// TODO: bisognerebbe separare il caso in cui il codice coupon non esiste da quello in cui esiste ma non è più valido				
				
				// controllo che il codice coupon sia valido, altrimenti restituisco 0
				$coupon = mysqlSelectRow( $c, "SELECT * from coupon WHERE id = ? AND ("
										. "(timestamp_inizio IS NULL AND timestamp_fine IS NULL) OR (timestamp_inizio <= ? AND timestamp_fine >= ?) OR (timestamp_inizio <= ? AND timestamp_fine IS NULL) )", 
							array(
								array( "s" => $carrello['coupon']),
								array( "s" => time() ),
								array( "s" => time() ),
								array( "s" => time() )
							)
						);
				
				// TODO: inserire la parte di verifica per il multiuso

					
			}
			
			// se ho un coupon valido
			if( !empty( $coupon ) ) {
				
				// verifico se lo sconto è in percentuale o in euro
				$sconto_fisso = ( !empty( $coupon['sconto_fisso'] ) ) ? $coupon['sconto_fisso'] : 0;
				$sconto_perc = ( !empty( $coupon['sconto_percentuale'] ) ) ? $coupon['sconto_percentuale'] : 0;


				// per ogni articolo vado a vedere se posso applicare lo sconto
				foreach( $carrello['carrelli_articoli'] as $articolo ) {
					
				// cerco il prodotto per l'articolo corrente
					$prodotto = mysqlSelectValue( $c, "SELECT id_prodotto from articoli WHERE id = ? ",
											array(
												array( "s" => $articolo['id_articolo'] )
											)
											);
				
				// leggo i dati sul prezzo del prodotto per chiamare la variazionePrezzo							
					$prodRow = mysqlSelectRow( $c, "SELECT * from prezzi_view WHERE id_prodotto = ? AND id_listino = ? ",
											array(
												array( "s" => $prodotto ),
												array( "s" => $carrello['id_listino'] )
											)
											);

					$variazione_prezzo = variazionePrezzo( $c, $carrello['id_listino'], $prodotto, $prodRow['prezzo_lordo']);
					
					// se non c'è variazione sull'articolo procedo col calcolo del coupon
					if( empty( $variazione_prezzo['tipoSconto'] ) ) {
	
						// verifico se lo sconto è globale (es. nuovi utenti o iscrizione newsletter)
						if( $coupon['se_globale'] == 1 ){
							$verificato = 1;	// l'articolo è automaticamente verificato (lo sconto vale per tutto)
						}
						else {
							$verificato = 0;	// l'articolo deve essere verificato tramite prodotto e/o categoria
						}
						
						
					// 1) se lo sconto non è globale verifico se è associato al prodotto di cui fa parte l'articolo					
						if( $verificato == 0 ){

							$check_prodotto = mysqlSelectValue( $c, "SELECT id from coupon_prodotti WHERE id_coupon = ? AND id_prodotto = ?",
												array(
													array( "s" => $coupon['id']),
													array( "s" => $prodotto )
												)
												);
							
							// se lo sconto era applicato al prodotto, l'articolo è verificato
							if( !empty( $check_prodotto ) ){
								$verificato = 1;
							}
						}
						
						
					// 2) se la verifica sul prodotto non ha dato esito positivo, verifico sulla categoria
						if( $verificato == 0 ){
							
							$categoria = mysqlSelectValue( $c, "SELECT id_categoria from prodotti_categorie WHERE id_prodotto = ? ORDER BY ordine ASC",
											array(
												array( "s" => $prodotto )
											)
											);
											
							// cerco l'elenco delle categorie genitore
							do {
								
								$check_categoria = mysqlSelectValue( $c, "SELECT id from coupon_categorie_prodotti WHERE id_coupon = ? AND id_categoria_prodotti = ?",
											array(
												array( "s" => $coupon['id']),
												array( "s" => $categoria )
											)
											);
								
								$genitore = mysqlSelectValue( $c, "SELECT id_genitore from categorie_prodotti WHERE id = ?", 
									array(
										array( "s" => $categoria)
									)
								);

								$categoria = $genitore;

							} while( $genitore != NULL && empty($check_categoria) );
						
							if( !empty( $check_categoria ) ){
								$verificato = 1;
							}
						}
			
			// TODO testare la verifica per marchio
					// 4) se la verifica sulla categoria non ha dato esito positivo, verifico sul marchio
						if( $verificato == 0 ){
							
							$marchio = mysqlSelectValue( $c, "SELECT id_marchio from prodotti WHERE id_prodotto = ?",
											array(
												array( "s" => $prodotto )
											)
											);

							$check_marchio = mysqlSelectValue( $c, "SELECT id from coupon_marchi WHERE id_coupon = ? AND id_marchio = ?",
											array(
												array( "s" => $coupon['id']),
												array( "s" => $marchio )
											)
											);
							if( !empty( $check_marchio ) ){
								$verificato = 1;
							}
						}					
						
			// TODO testare la verifica per stagione
					// 4) se la verifica sul marchio non ha dato esito positivo, verifico sulla stagione
						if( $verificato == 0 ){
							
							$stagione = mysqlSelectValue( $c, "SELECT id_stagione from prodotti_stagioni WHERE id_prodotto = ? ORDER BY ordine ASC",
											array(
												array( "s" => $prodotto )
											)
											);

							$check_stagione = mysqlSelectValue( $c, "SELECT id from coupon_stagioni WHERE id_coupon = ? AND id_stagione = ?",
											array(
												array( "s" => $coupon['id']),
												array( "s" => $stagione )
											)
											);
							if( !empty( $check_stagione ) ){
								$verificato = 1;
							}
						}					



						
						// se l'articolo (per prodotto o categoria di appartenenza) rientra nello sconto, calcolo lo sconto
						if( $verificato == 1 ){
								
							// se è fisso
							if( $sconto_fisso > 0 ){
								$sconto = $sconto_fisso;
								return $sconto;
							}
							elseif( $sconto_perc > 0 ){
								$prezzo_lordo_complessivo = mysqlSelectValue( $c, "SELECT prezzo_lordo_complessivo from carrelli_articoli WHERE id_carrello = ? AND id_articolo = ?",
											array(
												array( "s" => $carrello['id']),
												array( "s" => $articolo['id_articolo'] )
											)
											);
																		
								$sconto += $prezzo_lordo_complessivo*$sconto_perc/100;
							}						
						}
					}
				}
			}	
		}
		
		return $sconto;

    }


	// SDF
	/* la funzione prende in ingresso:
		- la connessione
		- il listino
		- il codice prodotto
		- il prezzo complessivo (unitario * quantita)
		- la quantità
	   
	   restituisce un array con:
		- il tipo di sconto (fisso o percentuale)
		- il valore dello sconto (es. 15)
		- l'elemento a cui è applicato lo sconto (marchio, prodottom categoria, ...)
		- l'importo dello sconto
		- il prezzo scontato (se non c'è sconto sarà pari al prezzo di partenza)
	*/
	
    function variazionePrezzo( $c, $list, $idProd, $prezzoProd, $qtProd = 1 ) {
		
		$tipoSconto = '';
		$sconto = '';
		$sconto_su = '';
		$importoSconto = 0;
		$prezzoScontato = $prezzoProd;

				
// se ho un prodotto		
		if( !empty($idProd) ){

	// cerco variazioni nel prodotto per il listino corrente
#			if( empty( $id_variazione_prezzo ) ){
				$id_variazione_prezzo = mysqlSelectValue( $c, "SELECT variazioni_prezzi_prodotti.id_variazione_prezzo from variazioni_prezzi_prodotti INNER JOIN variazioni_prezzi_listini ON variazioni_prezzi_prodotti.id_variazione_prezzo = variazioni_prezzi_listini.id_variazione_prezzo WHERE id_prodotto = ?  AND id_listino = ?", 
							array(
								array( "s" => $idProd),
								array( "s" => $list)
							)
						);
				
				$sconto_su = ( !empty($id_variazione_prezzo) && $sconto_su == '' ) ? 'prodotto' : '';
#			}


	// cerco variazioni nelle categorie per il listino corrente
			if( empty( $id_variazione_prezzo ) ){
				
				// categoria di ordine maggiore per il prodotto
				$categoria = mysqlSelectValue( $c, "SELECT id_categoria from prodotti_categorie WHERE id_prodotto = ? ORDER BY prodotti_categorie.ordine DESC LIMIT 1", 
						array(
							array( "s" => $idProd)
						)
					);
				

				// cerco l'elenco delle categorie genitore
				do {

					$id_variazione_prezzo = mysqlSelectValue( $c, "SELECT variazioni_prezzi_categorie.id_variazione_prezzo FROM variazioni_prezzi_categorie INNER JOIN variazioni_prezzi_listini ON variazioni_prezzi_categorie.id_variazione_prezzo = variazioni_prezzi_listini.id_variazione_prezzo WHERE id_categoria_prodotti = ?  AND id_listino = ?", 
						array(
							array( "s" => $categoria),
							array( "s" => $list)
						)
					);	
					
					$genitore = mysqlSelectValue( $c, "SELECT id_genitore from categorie_prodotti WHERE id = ?", 
						array(
							array( "s" => $categoria)
						)
					);

					$categoria = $genitore;

				} while( $genitore != NULL && empty($id_variazione_prezzo) );
				
				$sconto_su = (!empty($id_variazione_prezzo) && $sconto_su == '' ) ? 'categoria' : '';
		
			}


// cerco variazioni per il marchio per il listino corrente
			if( empty( $id_variazione_prezzo ) ){
				
				// cerco il marchio relativo al prodotto corrente
				$marchio = mysqlSelectValue( $c, "SELECT id_marchio from prodotti WHERE id = ?", 
						array(
							array( "s" => $idProd)
						)
					);
					
				if( !empty( $marchio ) ){
					$id_variazione_prezzo = mysqlSelectValue( $c, "SELECT variazioni_prezzi_marchi.id_variazione_prezzo FROM variazioni_prezzi_marchi INNER JOIN variazioni_prezzi_listini ON variazioni_prezzi_marchi.id_variazione_prezzo = variazioni_prezzi_listini.id_variazione_prezzo WHERE id_marchio = ?  AND id_listino = ?", 
								array(
									array( "s" => $marchio),
									array( "s" => $list)
								)
							);
					$sconto_su = (!empty($id_variazione_prezzo) && $sconto_su == '' ) ? 'marchio' : '';
				}
			}
				
// cerco variazioni per stagione per il listino corrente
			if( empty( $id_variazione_prezzo ) ){	
				
				// cerco la stagione relativa al prodotto corrente (vedere come procedere se ce n'è più di una)
				$stagione = mysqlSelectValue( $c, "SELECT id_stagione from prodotti_stagioni WHERE id_prodotto = ?", 
						array(
							array( "s" => $idProd)
						)
					);
					
				if( !empty( $stagione ) ){
					$id_variazione_prezzo = mysqlSelectValue( $c, "SELECT variazioni_prezzi_stagioni.id_variazione_prezzo from variazioni_prezzi_stagioni INNER JOIN variazioni_prezzi_listini ON variazioni_prezzi_stagioni.id_variazione_prezzo = variazioni_prezzi_listini.id_variazione_prezzo WHERE id_stagione = ?  AND id_listino = ?", 
								array(
									array( "s" => $stagione),
										array( "s" => $list)
								)
							);
					$sconto_su = (!empty($id_variazione_prezzo) && $sconto_su == '' ) ? 'stagione' : '';
				}
			}

			
	// se ho un id variazione prezzo...
			if( !empty( $id_variazione_prezzo ) ) {

				// verifico se la variazione esiste ed è valida
				$variazione_prezzo = mysqlSelectRow( $c, "SELECT * from variazioni_prezzi WHERE id = ? AND ("
									. "(timestamp_inizio IS NULL AND timestamp_fine IS NULL) OR (timestamp_inizio <= ? AND timestamp_fine >= ?) OR ( timestamp_inizio <= ? AND timestamp_fine IS NULL ) )", 
						array(
							array( "s" => $id_variazione_prezzo),
							array( "s" => time() ),
							array( "s" => time() ),
							array( "s" => time() )
						)
					);
				
				// se è valida...
				if( !empty($variazione_prezzo) ){
			
					// verifico se lo sconto è in percentuale o in euro
					$sconto_fisso = ( !empty( $variazione_prezzo['sconto_fisso'] ) ) ? $variazione_prezzo['sconto_fisso'] : 0;
					$sconto_perc = ( !empty( $variazione_prezzo['sconto_percentuale'] ) ) ? $variazione_prezzo['sconto_percentuale'] : 0;
			
					// se è in euro
					if( $sconto_fisso > 0 ){
						$tipoSconto = 'fisso';
						$sconto = $sconto_fisso;
						$importoSconto = $sconto_fisso * $qtProd;
						$importoSconto = str_replace( ',', '.', $importoSconto );
						$prezzoScontato = $prezzoProd - $importoSconto;
						$prezzoScontato = str_replace( ',', '.', $prezzoScontato );
					}
					elseif( $sconto_perc > 0 ){
						$tipoSconto = 'percentuale';
						$sconto = $sconto_perc;
						$importoSconto = $prezzoProd * $sconto_perc/100;
						$importoSconto = str_replace( ',', '.', $importoSconto );
						$prezzoScontato = ( $prezzoProd * ( 1 - $sconto_perc/100 ) );
						$prezzoScontato = str_replace( ',', '.', $prezzoScontato );
					}						
				}
			}	
		}
		
		// array di valori da ritornare
		$datiSconto = array(
							'tipoSconto' 	 => $tipoSconto,
							'sconto' 		 => $sconto,
							'sconto_su'		 => $sconto_su,
							'importoSconto'  => $importoSconto,
							'prezzoScontato' => $prezzoScontato
							);		
		
	#	writeToFile( 'chiamata funzione variazionePrezzo su prodotto ' . $idProd . ' restituito array' . PHP_EOL . print_r( $datiSconto, true ), 'var/log/carts/variazione_prezzo.'.time().'.log' );
		return $datiSconto;

    }
