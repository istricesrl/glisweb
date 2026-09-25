<?php

    /**
     * stampa della fattura elettronica in formato XML FatturaPA
     *
     * Questo file genera l'XML della fattura elettronica ( formato FatturaPA 1.2, FPR12 per i privati e FPA12 per la
     * pubblica amministrazione ) del documento indicato in $_REQUEST['__documento__']. I dati vengono preparati da
     * _documento.default.php con generaContenutiDocumento(), che fa anche il controllo di autorizzazione e sceglie il file
     * di destinazione in DIR_VAR_SPOOL_DOCS . 'fatture/xml/'; il nome del file è quello richiesto dallo SDI ( sigla dello
     * stato, codice fiscale dell'emittente e progressivo di invio ).
     *
     * La fattura viene costruita come array, nell'ordine degli elementi richiesto dallo schema, e scritta con array2xml()
     * ( _src/_lib/_xml.tools.php ); gli elementi facoltativi si aggiungono all'array solo quando hanno un valore, perché
     * un elemento vuoto non è valido per lo schema. Il file viene poi restituito in tre modi:
     *
     * parametro        | risultato
     * -----------------|-----------------------------------------------------------------------------------------
     * f                | un JSON con il percorso del file ( usato dal task _fattura.invia.sdi.php )
     * d                | il file XML in download
     * nessuno          | il file XML inline, con il foglio di stile per la visualizzazione nel browser
     *
     * conformità alle specifiche
     * --------------------------
     * Il 2026-09-25 il file è stato rivisto contro lo schema Schema_VFPR12_v1.2.3.xsd ( specifiche tecniche 1.9 ) e
     * verificato validando con DOMDocument::schemaValidate() fatture di prova a privati con PEC, a PA con CIG e CUP e a
     * persone fisiche. Restano da fare: DatiBollo per le operazioni senza IVA sopra 77,47 euro, DatiFattureCollegate per
     * le note di credito ( generaContenutiDocumento() non restituisce i documenti collegati ), DatiDDT, la troncatura dei
     * testi alle lunghezze massime dello schema ( per esempio RiferimentoNormativo a 100 caratteri ).
     *
     * @todo DatiBollo, DatiFattureCollegate, DatiDDT
     * @todo decidere come trattare i testi più lunghi del massimo consentito dallo schema
     *
     * @file
     *
     */

    // inclusione del framework
	require_once '../../../../../_src/_config.php';

    // configurazioni specifiche
    $cnf['estensione'] = 'xml';
    $cnf['cartella'] = 'fatture';

    // inclusione dei dati base
	require DIR_BASE . '_mod/_0400.documenti/_src/_api/_print/_documento.default.php';

	// die( print_r( $dati, true ) );
    // error_reporting( E_ALL );
    // ini_set( 'display_errors', TRUE );

    // annoto l'attività di stampa
    mysqlInsertRow(
        $cf['mysql']['connection'],
        array(
            'id_tipologia' => 24,
            'id_documento' => $dati['doc']['id'],
            'data_attivita' => date('Y-m-d'),
            'nome' => 'stampa documento',
            'ora_inizio' => date( 'H:i:s' ),
            'ora_fine' => date( 'H:i:s' )
        ),
        'attivita'
    );

    // debug
	// header( 'Content-type: text/plain;' );
	// die( print_r( $dati['doc'], true ) );
	// die( print_r( $dati['src'], true ) );
	// die( print_r( $dati['dst'], true ) );

    // testi liberi: xmlEntities() li translittera in ASCII ( le lettere accentate perdono l'accento, € diventa EUR ), ma fa
    // anche l'escape delle &, che array2xml() rifà: senza togliere il primo escape "Rossi & Figli" arrivava nella fattura
    // come "Rossi &amp;amp; Figli" ( issue 591, corretto il 2026-09-25 )
	$testoFattura = function( $t ) {
	    return str_replace( '&amp;', '&', xmlEntities( $t ) );
	};

    // versione PA o privati
	$versione = ( empty( $dati['dst']['se_pubblica_amministrazione'] ) ) ? 'FPR12' : 'FPA12';

    // root element, in forma di array per array2xml()
    // NOTA fino al 2026-09-25 la fattura veniva scritta con XMLWriter; array2xml() produce lo stesso documento ( stessi
    // elementi, valori e ordine, verificato con xml2array() e C14N su fatture a privati, PA e persone fisiche, e validato
    // contro Schema_VFPR12_v1.2.3.xsd ), ma il testo cambia in due punti che per l'XML non contano: le dichiarazioni xmlns
    // della radice vengono prima dell'attributo versione, e le " nel testo restano " invece di &quot;
	$fattura = array(
	    'p:FatturaElettronica' => array(
	        '@' => array(
	            'versione' => $versione,
	            'xmlns:ds' => 'http://www.w3.org/2000/09/xmldsig#',
	            'xmlns:p' => 'http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2',
	            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
	            'xsi:schemaLocation' => 'http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2 http://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2/Schema_del_file_xml_FatturaPA_versione_1.2.xsd'
	        )
	    )
	);

    // - - DatiTrasmissione
	$trasmissione = array(
	    // - - - IdTrasmittente
	    'IdTrasmittente' => array(
	        // - - - - IdPaese / lo stato del trasmittente
	        'IdPaese' => $dati['sri']['sigla_stato'],
	        // - - - - IdCodice / identificativo fiscale del trasmittente
	        'IdCodice' => $dati['src']['codice_fiscale']
	    ),
	    // - - - ProgressivoInvio / identificativo univoco del documento
	    'ProgressivoInvio' => $dati['doc']['progressivo_invio'],
	    // - - - FormatoTrasmissione / privati o PA
	    'FormatoTrasmissione' => $versione
	);

    // NOTA un destinatario privato che non ha comunicato il codice SDI si indica con il codice convenzionale 0000000,
    // anche quando ha la partita IVA ( generaContenutiDocumento() lo imposta solo per chi non ce l'ha ): un codice vuoto
    // non è valido per lo schema; alla PA invece il codice ufficio serve sempre, e se manca il file viene scartato
	if( empty( $dati['dst']['codice_sdi'] ) && $dati['dst']['se_pubblica_amministrazione'] != 1 ) {
	    $dati['dst']['codice_sdi'] = '0000000';
	}

    // - - - CodiceDestinatario / codice SDI del destinatario
	$trasmissione['CodiceDestinatario'] = $dati['dst']['codice_sdi'];

    // - - - PECDestinatario / PEC del destinatario
    // NOTA la PEC si scrive solo con il codice 0000000: con un codice valorizzato lo SDI scarta il file ( errore 00426 )
	if( ! empty( $dati['dst']['pec_sdi'] ) && $dati['dst']['codice_sdi'] == '0000000' ) {
	    $trasmissione['PECDestinatario'] = $dati['dst']['pec_sdi'];
	}

    // - - - - RegimeFiscale / il regime fiscale del cedente
	if( empty( $dati['srr']['codice'] ) ) {
		die( 'regime fiscale inviante non specificato o errato' );
	}

    // - - CedentePrestatore
	$cedente = array(
	    // - - - DatiAnagrafici
	    'DatiAnagrafici' => array(
	        // - - - - IdFiscaleIVA
	        'IdFiscaleIVA' => array(
	            // - - - - - IdPaese / lo stato del cedente
	            'IdPaese' => $dati['sri']['sigla_stato'],
	            // - - - - - IdCodice / la partita IVA del cedente
	            'IdCodice' => $dati['src']['partita_iva']
	        ),
	        // - - - - Anagrafica
	        'Anagrafica' => array(
	            // - - - - - Denominazione / la denominazione del cedente
	            'Denominazione' => $dati['src']['denominazione_fiscale']
	        ),
	        // - - - - RegimeFiscale / il regime fiscale del cedente
	        'RegimeFiscale' => $dati['srr']['codice']
	    ),
	    // - - - Sede
	    'Sede' => array(
	        // - - - - Indirizzo / l'indirizzo della sede del cedente
	        'Indirizzo' => $dati['sri']['indirizzo_fiscale'],
	        // - - - - CAP / il CAP della sede del cedente
	        'CAP' => $dati['sri']['cap'],
	        // - - - - Comune / il comune della sede del cedente
	        'Comune' => $dati['sri']['comune'],
	        // - - - - Provincia / la sigla della provincia della sede del cedente
	        'Provincia' => $dati['sri']['provincia'],
	        // - - - - Nazione / la nazione della sede del cedente
	        'Nazione' => $dati['sri']['sigla_stato']
	    )
	);

    // - - - - dati fiscali del cessionario, azienda / privato
	if( empty( $dati['dst']['partita_iva'] ) ) {

	    // - - - - CodiceFiscale / il codice fiscale del cliente privato
		$anagraficaCessionario = array( 'CodiceFiscale' => strtoupper( $dati['dst']['codice_fiscale'] ) );

	} else {

	    // - - - - IdFiscaleIVA
		$anagraficaCessionario = array(
		    'IdFiscaleIVA' => array(
		        // - - - - - IdPaese / lo stato del cessionario
		        'IdPaese' => $dati['dsi']['sigla_stato'],
		        // - - - - - IdCodice / la partita IVA del cessionario
		        'IdCodice' => $dati['dst']['partita_iva']
		    )
		);

	}

    // - - - - Anagrafica, azienda / privato
	if( empty( $dati['dst']['partita_iva'] ) && ( !empty($dati['dst']['cognome']) ) ) {

		$anagraficaCessionario['Anagrafica'] = array(
		    // - - - - - Nome / il nome del cliente privato
		    'Nome' => $testoFattura( $dati['dst']['nome'] ),
		    // - - - - - Cognome / il cognome del cliente privato
		    'Cognome' => $testoFattura( $dati['dst']['cognome'] )
		);

	} else {

		$anagraficaCessionario['Anagrafica'] = array(
		    // - - - - - Denominazione / la denominazione del cliente
		    'Denominazione' => $testoFattura( $dati['dst']['denominazione_fiscale'] )
		);

	}

    // - - CessionarioCommittente
	$cessionario = array(
	    // - - - DatiAnagrafici
	    'DatiAnagrafici' => $anagraficaCessionario,
	    // - - - Sede
	    'Sede' => array(
	        // - - - - Indirizzo / l'indirizzo della sede del cliente
	        'Indirizzo' => $dati['dsi']['indirizzo_fiscale'],
	        // - - - - CAP / il CAP della sede del cliente
	        'CAP' => $dati['dsi']['cap'],
	        // - - - - Comune / il comune della sede del cliente
	        'Comune' => $dati['dsi']['comune'],
	        // - - - - Provincia / la sigla della provincia della sede del cliente
	        'Provincia' => $dati['dsi']['provincia'],
	        // - - - - Nazione / la nazione della sede del cliente
	        'Nazione' => $dati['dsi']['sigla_stato']
	    )
	);

    // - FatturaElettronicaHeader
	$fattura['p:FatturaElettronica']['FatturaElettronicaHeader'] = array(
	    'DatiTrasmissione' => $trasmissione,
	    'CedentePrestatore' => $cedente,
	    'CessionarioCommittente' => $cessionario
	);

    // - - DatiGenerali
	$generali = array(
	    // - - - DatiGeneraliDocumento
	    'DatiGeneraliDocumento' => array(
	        // - - - - TipoDocumento / la tipologia del documento
	        'TipoDocumento' => $dati['doc']['codice_tipologia'],
	        // - - - - Divisa / la valuta del documento
	        'Divisa' => $dati['doc']['divisa'],
	        // - - - - Data / la data del documento
	        'Data' => $dati['doc']['data'],
	        // - - - - Numero / il numero del documento
	        'Numero' => $dati['doc']['numero'],
	        // - - - - ImportoTotaleDocumento / l'importo lordo totale del documento
	        'ImportoTotaleDocumento' => $dati['doc']['tot']['importo_lordo_totale'],
	        // - - - - Causale / la causale del documento
	        'Causale' => $dati['doc']['causale']
	    )
	);

	if( $dati['dst']['se_pubblica_amministrazione'] == 1 ){

		if( empty( $dati['doc']['cig']) ){die( 'cig mancante' ); }

		if( empty( $dati['doc']['riferimento']) ){die( 'riferimento documento per PA assente' ); }

		// - - - DatiOrdineAcquisto
		// NOTA RiferimentoNumeroLinea non si scrive: l'ordine riguarda tutta la fattura, e in questo caso per le specifiche
		// l'elemento non va valorizzato; fino al 2026-09-25 si scriveva 1, che lega CIG e CUP alla sola prima riga
		$generali['DatiOrdineAcquisto'] = array( 'IdDocumento' => $dati['doc']['riferimento'] );

		if( ! empty( $dati['doc']['cup'] ) ) {
			$generali['DatiOrdineAcquisto']['CodiceCUP'] = $dati['doc']['cup'];
		}

		$generali['DatiOrdineAcquisto']['CodiceCIG'] = $dati['doc']['cig'];

	}

	// ciclo sulle fatture collegate
	if( isset( $dati['dcl'] ) && ! empty( $dati['dcl'] ) ) {
		foreach( $dati['dcl'] AS $dcl ) {

			// - - - DatiFattureCollegate

			// - - - - RiferimentoNumeroLinea

			// - - - - IdDocumento

			// - - - - Data

			// - - - /DatiFattureCollegate

		}
	}

	// ciclo sui DDT collegati
	// TODO
	// - - - DatiDDT
	// - - - - NumeroDDT
	// - - - - DataDDT
	// - - - - RiferimentoNumeroLinea
	// - - - /DatiDDT

    // - - DatiBeniServizi
	$beniServizi = array( 'DettaglioLinee' => array(), 'DatiRiepilogo' => array() );

    // ciclo sulle righe
	foreach( $dati['doc']['righe'] as $num => $row ) {

	    // - - - DettaglioLinee
		$linea = array(
		    // - - - - NumeroLinea / il numero della riga
		    'NumeroLinea' => $num + 1,
		    // - - - - Descrizione / la descrizione della riga
		    'Descrizione' => $testoFattura( $row['nome'] ),
		    // - - - - Quantita / la quantità della riga
		    // NOTA lo schema vuole almeno due decimali: la colonna quantita è decimal(9,2), ma a una riga senza quantità
		    // generaContenutiDocumento() assegna l'intero 1, che scritto com'è rendeva il file non valido
		    'Quantita' => xmlFloat( $row['qtd'] )
		);

	    // - - - - Unita' di misura / l'unità di misura della riga
		if( ! empty( $row['udm'] ) ) {
		    $linea['UnitaMisura'] = $row['udm'];
		}

	    // - - - - PrezzoUnitario / il prezzo netto unitario della riga
		$linea['PrezzoUnitario'] = $row['importo_netto_unitario'];

	    // - - - - PrezzoTotale / il prezzo netto totale della riga
		$linea['PrezzoTotale'] = $row['importo_netto_totale'];

	    // - - - - AliquotaIVA / l'aliquota IVA della riga
		$linea['AliquotaIVA'] = $row['aliquota'];

	    // - - - - Natura / il codice di esenzione IVA della riga
		if( ! empty( $row['codice_iva'] ) ) {
		    $linea['Natura'] = $row['codice_iva'];
		}

		// controllo arrotondamento
		// TODO questo non andrebbe fatto nel file _fattura.default.php in modo da impattare anche sul PDF?
		if( sprintf( '%0.2f', $row['importo_netto_unitario'] * $row['qtd'] ) != sprintf( '%0.2f',$row['importo_netto_totale'] ) ) {
			die( 'errore di arrotondamento riga '.($num+1).': '.$row['nome'].' importo totale '.$row['importo_netto_totale'] . ' diverso da ' . ( $row['importo_netto_unitario'] * $row['qtd'] ) );
		}

	    // - - - /DettaglioLinee
		$beniServizi['DettaglioLinee'][] = $linea;

	}

    // ciclo sulle aliquote IVA
	foreach( $dati['doc']['iva'] as $iva => $row ) {

	    // - - - DatiRiepilogo
		$riepilogo = array(
		    // - - - - AliquotaIVA / l'aliquota IVA della riga
		    'AliquotaIVA' => xmlFloat( $row['aliquota'] )
		);

	    // - - - - Natura / il codice di esenzione IVA della riga
		if( ! empty( $row['codice'] ) ) {
		    $riepilogo['Natura'] = $row['codice'];
		}

	    // - - - - ImponibileImporto / l'imponibile della riga
		$riepilogo['ImponibileImporto'] = $row['imponibile_tot'];

	    // - - - - Imposta / l'imposta della riga
		$riepilogo['Imposta'] = $row['tot'];

	    // - - - - EsigibilitaIVA / l'esigibilità della riga
		if( ! empty( $dati['doc']['codice_esigibilita'] ) ) {
		    $riepilogo['EsigibilitaIVA'] = $dati['doc']['codice_esigibilita'];
		}

	    // - - - - RiferimentoNormativo / il riferimento normativo dell'esenzione della riga
	    // NOTA per le specifiche il riferimento normativo si indica solo con la Natura: la descrizione di un'aliquota
	    // ordinaria ( "IVA 22%" ) non è una norma, e fino al 2026-09-25 finiva lo stesso nel riepilogo
		if( ! empty( $row['codice'] ) && ! empty( $row['riferimento'] ) ) {
		    $riepilogo['RiferimentoNormativo'] = $testoFattura( $row['riferimento'] );
		}

	    // - - - /DatiRiepilogo
		$beniServizi['DatiRiepilogo'][] = $riepilogo;

	}

    // - FatturaElettronicaBody
	$fattura['p:FatturaElettronica']['FatturaElettronicaBody'] = array(
	    'DatiGenerali' => $generali,
	    'DatiBeniServizi' => $beniServizi
	);

    // NOTA DatiPagamento è facoltativo, ma se c'è vuole almeno un DettaglioPagamento: un documento senza pagamenti
    // produceva un blocco con le sole condizioni, che lo schema rifiuta
	if( ! empty( $dati['doc']['pagamenti'] ) ) {

	    // - - DatiPagamento
		$pagamento = array(
		    // - - CondizioniPagamento / le condizioni di pagamento del documento
		    'CondizioniPagamento' => $dati['doc']['condizioni_pagamento'],
		    'DettaglioPagamento' => array()
		);

	    // ciclo sulle scadenze
		foreach( $dati['doc']['pagamenti'] as $row ) {

		    // - - - DettaglioPagamento
			$scadenza = array(
			    // - - - - ModalitaPagamento / la modalità di pagamento di questa scadenza
			    'ModalitaPagamento' => $row['codice_pagamento']
			);

		    // - - - - DataScadenzaPagamento / la data di scadenza di questa scadenza
			if( ! empty( $row['data_standard'] ) ) {
			    $scadenza['DataScadenzaPagamento'] = $row['data_standard'];
			}

		    // - - - - ImportoPagamento / l'importo di questa scadenza
			$scadenza['ImportoPagamento'] = $row['importo_lordo_totale'];

			if( !empty( $row['iban'] ) ){
				// - - - - iban
				$scadenza['IBAN'] = $row['iban'];
			}

		    // - - - /DettaglioPagamento
			$pagamento['DettaglioPagamento'][] = $scadenza;

		}

	    // - - /DatiPagamento
		$fattura['p:FatturaElettronica']['FatturaElettronicaBody']['DatiPagamento'] = $pagamento;

	}

    // scrittura su file
	array2xml( $fattura, getShortPath( $outFile ) );

    // leggo l'XML per righe
	$rows = readFromFile( $outFile );

    // se è richiesto il download
	if( isset( $_REQUEST['f'] ) ) {
        buildJson( array( 'file' => $outFile ) );
    } elseif( isset( $_REQUEST['d'] ) ) {
	    header( 'Content-disposition: attachment; filename=' . basename( $outFile ) );
        buildXml( implode( $rows ) );
	} else {
	    header( 'Content-disposition: inline; filename=' . basename( $outFile ) );
		if( $dati['dst']['se_pubblica_amministrazione'] == 1 ){
			array_splice( $rows, 1, 0, array( '<?xml-stylesheet type="text/xsl" href="'.$cf['site']['url'].'_src/_xsl/fatturaPA_v1.2.1.xsl" ?>' . PHP_EOL ) );
		} else {
			array_splice( $rows, 1, 0, array( '<?xml-stylesheet type="text/xsl" href="'.$cf['site']['url'].'_src/_xsl/fatturaordinaria_v1.2.1.xsl" ?>' . PHP_EOL ) );
		}
		buildXml( implode( $rows ) );
    }

