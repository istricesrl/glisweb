<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../../../_src/_config.php';

    // configurazioni specifiche
    $cnf['estensione'] = 'xml';

    // inclusione dei dati base
	require DIR_BASE . '_mod/_0400.documenti/_src/_api/_print/_fattura.default.php';

    // debug
	// header( 'Content-type: text/plain;' );
	// die( print_r( $doc, true ) );
	// die( print_r( $src, true ) );
	// die( print_r( $dst, true ) );

    // creazione dell'oggetto XML
	$xml = new XMLWriter();

    // specifico il file di destinazione
	$xml->openURI( $outFile );

    // inizio il documento
	$xml->startDocument( '1.0', 'UTF-8' );

    // attivo l'indentazione
	$xml->setIndent( true );
	$xml->setIndentString( '  ' );

    // root element
	$xml->startElement( 'p:FatturaElettronica' );
	
	// versione PA o privati
	if( !$dst['se_pubblica_amministrazione'] == 1 ){
		$xml->writeAttribute( 'versione', 'FPR12' );
	} else {
		$xml->writeAttribute( 'versione', 'FPA12' );
	}

	$xml->writeAttribute( 'xmlns:ds', 'http://www.w3.org/2000/09/xmldsig#' );
	$xml->writeAttribute( 'xmlns:p', 'http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2' );
	$xml->writeAttribute( 'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
	$xml->writeAttribute( 'xsi:schemaLocation', 'http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2 http://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2/Schema_del_file_xml_FatturaPA_versione_1.2.xsd' );

    // - FatturaElettronicaHeader
	$xml->startElement( 'FatturaElettronicaHeader' );

    // - - DatiTrasmissione
	$xml->startElement( 'DatiTrasmissione' );

    // - - - IdTrasmittente
	$xml->startElement( 'IdTrasmittente' );

    // - - - - IdPaese / lo stato del trasmittente
	$xml->writeElement( 'IdPaese', $sri['sigla_stato'] );

    // - - - - IdCodice / identificativo fiscale del trasmittente
	$xml->writeElement( 'IdCodice', $src['codice_fiscale'] );

    // - - - /IdTrasmittente
	$xml->endElement();

    // - - - ProgressivoInvio / identificativo univoco del documento
	$xml->writeElement( 'ProgressivoInvio', $doc['progressivo_invio'] );

	if( ! $dst['se_pubblica_amministrazione'] == 1 ) {
		// - - - FormatoTrasmissione / privati
		$xml->writeElement( 'FormatoTrasmissione', 'FPR12' );
	} else {
		// - - - FormatoTrasmissione / privati
		$xml->writeElement( 'FormatoTrasmissione', 'FPA12' );
	}

    // - - - CodiceDestinatario / codice SDI del destinatario
	$xml->writeElement( 'CodiceDestinatario', $dst['codice_sdi'] );

    // - - - PECDestinatario / PEC del destinatario
	if( ! empty( $dst['pec_sdi'] ) ) {
	    $xml->writeElement( 'PECDestinatario', $dst['pec_sdi'] );
	}

    // - - /DatiTrasmissione
	$xml->endElement();

    // - - CedentePrestatore
	$xml->startElement( 'CedentePrestatore' );

    // - - - DatiAnagrafici
	$xml->startElement( 'DatiAnagrafici' );

    // - - - - IdFiscaleIVA
	$xml->startElement( 'IdFiscaleIVA' );

    // - - - - - IdPaese / lo stato del cedente
	$xml->writeElement( 'IdPaese', $sri['sigla_stato'] );

    // - - - - - IdCodice / la partita IVA del cedente
	$xml->writeElement( 'IdCodice', $src['partita_iva'] );

    // - - - - /IdFiscaleIVA
	$xml->endElement();

    // - - - - Anagrafica
	$xml->startElement( 'Anagrafica' );

    // - - - - - Denominazione / la denominazione del cedente
	$xml->writeElement( 'Denominazione', $src['denominazione_fiscale'] );

    // - - - - /Anagrafica
	$xml->endElement();

    // - - - - RegimeFiscale / il regime fiscale del cedente
	if( empty( $srr['codice'] ) ) {
		die( 'regime fiscale inviante non specificato o errato' );
	} else {
		$xml->writeElement( 'RegimeFiscale', $srr['codice'] );
	}

    // - - - /DatiAnagrafici
	$xml->endElement();

    // - - - Sede
	$xml->startElement( 'Sede' );

    // - - - - Indirizzo / l'indirizzo della sede del cedente
	$xml->writeElement( 'Indirizzo', $sri['indirizzo_fiscale'] );

    // - - - - CAP / il CAP della sede del cedente
	$xml->writeElement( 'CAP', $sri['cap'] );

    // - - - - Comune / il comune della sede del cedente
	$xml->writeElement( 'Comune', $sri['comune'] );

    // - - - - Provincia / la sigla della provincia della sede del cedente
	$xml->writeElement( 'Provincia', $sri['provincia'] );

    // - - - - Nazione / la nazione della sede del cedente
	$xml->writeElement( 'Nazione', $sri['sigla_stato'] );

    // - - - /Sede
	$xml->endElement();

    // - - /CedentePrestatore
	$xml->endElement();

    // - - CessionarioCommittente
	$xml->startElement( 'CessionarioCommittente' );

    // - - - DatiAnagrafici
	$xml->startElement( 'DatiAnagrafici' );

    // azienda / privato
	if( empty( $dst['partita_iva'] ) ) {

	    // - - - - CodiceFiscale / il codice fiscale del cliente privato
		$xml->writeElement( 'CodiceFiscale', strtoupper( $dst['codice_fiscale'] ) );

	} else {

	    // - - - - IdFiscaleIVA
		$xml->startElement( 'IdFiscaleIVA' );

	    // - - - - - IdPaese / lo stato del cedente
		$xml->writeElement( 'IdPaese', $dsi['sigla_stato'] );

	    // - - - - - IdCodice / la partita IVA del cedente
		$xml->writeElement( 'IdCodice', $dst['partita_iva'] );

	    // - - - - /IdFiscaleIVA
		$xml->endElement();

	}

    // - - - - Anagrafica
	$xml->startElement( 'Anagrafica' );

    // azienda / privato
	if( empty( $dst['partita_iva'] ) && ( !empty($dst['cognome']) ) ) {

	    // - - - - - Nome / il nome del cliente privato
		$xml->writeElement( 'Nome', $dst['nome'] );

	    // - - - - - Cognome / il cognome del cliente privato
		$xml->writeElement( 'Cognome', $dst['cognome'] );

	} else {

	    // - - - - - Denominazione / la denominazione del cliente aziendale
		$xml->writeElement( 'Denominazione', $dst['denominazione_fiscale'] );

	}

    // - - - - /Anagrafica
	$xml->endElement();

    // - - - /DatiAnagrafici
	$xml->endElement();

    // - - - Sede
	$xml->startElement( 'Sede' );

    // - - - - Indirizzo / l'indirizzo della sede del cliente
	$xml->writeElement( 'Indirizzo', $dsi['indirizzo_fiscale'] );

    // - - - - CAP / il CAP della sede del cliente
	$xml->writeElement( 'CAP', $dsi['cap'] );

    // - - - - Comune / il comune della sede del cliente
	$xml->writeElement( 'Comune', $dsi['comune'] );

    // - - - - Provincia / la sigla della provincia della sede del cliente
	$xml->writeElement( 'Provincia', $dsi['provincia'] );

    // - - - - Nazione / la nazione della sede del cliente
	$xml->writeElement( 'Nazione', $dsi['sigla_stato'] );

    // - - - /Sede
	$xml->endElement();

    // - - /CessionarioCommittente
	$xml->endElement();

    // - /FatturaElettronicaHeader
	$xml->endElement();

    // - FatturaElettronicaBody
	$xml->startElement( 'FatturaElettronicaBody' );

    // - - DatiGenerali
	$xml->startElement( 'DatiGenerali' );

    // - - - DatiGeneraliDocumento
	$xml->startElement( 'DatiGeneraliDocumento' );

    // - - - - TipoDocumento / la tipologia del documento
	$xml->writeElement( 'TipoDocumento', $doc['codice_tipologia'] );

    // - - - - Divisa / la valuta del documento
	$xml->writeElement( 'Divisa', $doc['divisa'] );

    // - - - - Data / la data del documento
	$xml->writeElement( 'Data', $doc['data'] );

    // - - - - Numero / il numero del documento
	$xml->writeElement( 'Numero', $doc['numero'] );

    // - - - - ImportoTotaleDocumento / l'importo lordo totale del documento
	$xml->writeElement( 'ImportoTotaleDocumento',  $doc['tot']['importo_lordo_totale'] );

    // - - - - Causale / la causale del documento
	$xml->writeElement( 'Causale', $doc['causale'] );

    // - - - /DatiGeneraliDocumento
	$xml->endElement();

	if( $dst['se_pubblica_amministrazione'] == 1 ){

		if( empty( $doc['cig']) ){die( 'cig mancante' ); } 

		if( empty( $doc['riferimento']) ){die( 'riferimento documento per PA assente' ); } 

		// - - - DatiOrdineAcquisto
		$xml->startElement( 'DatiOrdineAcquisto' );

		$xml->writeElement( 'RiferimentoNumeroLinea', '1' );

		$xml->writeElement( 'IdDocumento', $doc['riferimento']);

		$xml->writeElement( 'CodiceCIG', $doc['cig'] );

		if(!empty( $doc['cup'] )){
			$xml->writeElement( 'CodiceCUP', $doc['cup'] );
			
		}

		// - - - /DatiOrdineAcquisto
		$xml->endElement();

	
	}

	// ciclo sulle fatture collegate
	foreach( $dcl AS $dc ) {

		// - - - DatiFattureCollegate

		// - - - - RiferimentoNumeroLinea

		// - - - - IdDocumento

		// - - - - Data

		// - - - /DatiFattureCollegate

	}

	// ciclo sui DDT collegati
	// TODO
	// - - - DatiDDT
	// - - - - NumeroDDT
	// - - - - DataDDT
	// - - - - RiferimentoNumeroLinea
	// - - - /DatiDDT

	// - - /DatiGenerali
	$xml->endElement();

    // - - DatiBeniServizi
	$xml->startElement( 'DatiBeniServizi' );

    // ciclo sulle righe
	foreach( $doc['righe'] as $num => $row ) {

	    // - - - DettaglioLinee
		$xml->startElement( 'DettaglioLinee' );

	    // - - - - NumeroLinea / il numero della riga
		$xml->writeElement( 'NumeroLinea', $num + 1 );

	    // - - - - Descrizione / la descrizione della riga
		$xml->writeElement( 'Descrizione', xmlEntities( $row['nome'] ) );

	    // - - - - Quantita / la quantità della riga
		$xml->writeElement( 'Quantita',  $row['qtd']  );

	    // - - - - Unita' di misura / l'unità di misura della riga
		$xml->writeElement( 'UnitaMisura', $row['udm']  );

	    // - - - - PrezzoUnitario / il prezzo netto unitario della riga
		$xml->writeElement( 'PrezzoUnitario', $row['importo_netto_unitario']  );

	    // - - - - PrezzoTotale / il prezzo netto totale della riga
		$xml->writeElement( 'PrezzoTotale', $row['importo_netto_totale']  );

	    // - - - - AliquotaIVA / l'aliquota IVA della riga
		$xml->writeElement( 'AliquotaIVA', $row['aliquota'] );

	    // - - - - Natura / il codice di esenzione IVA della riga
		if( ! empty( $row['codice_iva'] ) ) {
		    $xml->writeElement( 'Natura', $row['codice_iva'] );
		}

		// controllo arrotondamento
		// TODO questo non andrebbe fatto nel file _fattura.default.php in modo da impattare anche sul PDF?
		if( sprintf( '%0.2f', $row['importo_netto_unitario'] * $row['qtd'] ) != sprintf( '%0.2f',$row['importo_netto_totale'] ) ) {
			die( 'errore di arrotondamento riga '.($num+1).': '.$row['nome'].' importo totale '.$row['importo_netto_totale'] . ' diverso da ' . ( $row['importo_netto_unitario'] * $row['qtd'] ) );
		}
		
	    // - - - /DettaglioLinee
		$xml->endElement();

	}

    // ciclo sulle aliquote IVA
	foreach( $doc['iva'] as $iva => $row ) {

	    // - - - DatiRiepilogo
		$xml->startElement( 'DatiRiepilogo' );

	    // - - - - AliquotaIVA / l'aliquota IVA della riga
		$xml->writeElement( 'AliquotaIVA', xmlFloat( $row['aliquota'] ) );

	    // - - - - Natura / il codice di esenzione IVA della riga
		if( ! empty( $row['codice'] ) ) {
		    $xml->writeElement( 'Natura', $row['codice'] );
		}

	    // - - - - ImponibileImporto / l'imponibile della riga
		$xml->writeElement( 'ImponibileImporto', $row['imponibile_tot'] );

	    // - - - - Imposta / l'imposta della riga
		$xml->writeElement( 'Imposta', $row['tot'] );

	    // - - - - EsigibilitaIVA / l'esigibilità della riga
		$xml->writeElement( 'EsigibilitaIVA', $doc['codice_esigibilita'] );

	    // - - - - RiferimentoNormativo / il riferimento normativo dell'esenzione della riga
		if( ! empty( $row['riferimento'] ) ) {
		    $xml->writeElement( 'RiferimentoNormativo', xmlEntities( $row['riferimento'] ) );
		}

	    // - - - /DatiRiepilogo
		$xml->endElement();

	}

    // - - /DatiBeniServizi
	$xml->endElement();

    // - - DatiPagamento
	$xml->startElement( 'DatiPagamento' );

    // - - CondizioniPagamento / le condizioni di pagamento del documento
	$xml->writeElement( 'CondizioniPagamento', $doc['condizioni_pagamento'] );

    // ciclo sulle scadenze
	foreach( $doc['pagamenti'] as $row ) {

	    // - - - DettaglioPagamento
		$xml->startElement( 'DettaglioPagamento' );

	    // - - - - ModalitaPagamento / la modalità di pagamento di questa scadenza
		$xml->writeElement( 'ModalitaPagamento', $row['codice_pagamento'] );

	    // - - - - DataScadenzaPagamento / la data di scadenza di questa scadenza
		$xml->writeElement( 'DataScadenzaPagamento', $row['data_standard'] );

	    // - - - - ImportoPagamento / l'importo di questa scadenza
		$xml->writeElement( 'ImportoPagamento', $row['importo_lordo_totale'] );

		if( !empty( $row['iban'] ) ){
			// - - - - iban 
			$xml->writeElement( 'IBAN', $row['iban'] );
		}

	    // - - - /DettaglioPagamento
		$xml->endElement();

	}

    // - - /DatiPagamento
	$xml->endElement();

    // - /FatturaElettronicaBody
	$xml->endElement();

    // fine del root element
	$xml->endElement();

    // fine del document
	$xml->endDocument();

    // scrittura su file
	$xml->flush();

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
		if( $dst['se_pubblica_amministrazione'] == 1 ){
			array_splice( $rows, 1, 0, array( '<?xml-stylesheet type="text/xsl" href="'.$cf['site']['url'].'_src/_xsl/fatturaPA_v1.2.1.xsl" ?>' . PHP_EOL ) );
		} else {
			array_splice( $rows, 1, 0, array( '<?xml-stylesheet type="text/xsl" href="'.$cf['site']['url'].'_src/_xsl/fatturaordinaria_v1.2.1.xsl" ?>' . PHP_EOL ) );
		}
		buildXml( implode( $rows ) );
    }

