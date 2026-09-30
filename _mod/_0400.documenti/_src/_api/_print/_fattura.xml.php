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
     * f                | un JSON con il percorso del file ( usato dal task _fattura.invia.sdi.php ), oppure, se il
     *                  | file ha errori, con gli errori nella chiave errori e senza il percorso
     * d                | il file XML in download, anche se ha errori ( che vanno nel log xml )
     * nessuno          | la fattura in forma leggibile, trasformata in HTML sul server con il foglio di stile, con
     *                  | gli errori e gli avvisi sopra la fattura
     *
     * validazione e visualizzazione
     * -----------------------------
     * Prima di essere restituito il file viene validato con xmlValidate() contro lo schema ufficiale, che sta in
     * _mod/_0400.documenti/_src/_xml/_xsd/, e passa per alcuni controlli che lo schema non fa e lo SDI sì, o che le
     * specifiche chiedono per il tipo di documento ( la nota di credito senza la fattura collegata, la fattura
     * differita TD24 senza DDT, le nature generiche N2, N3 e N6, la data di una fattura collegata successiva a quella
     * del documento ). Gli errori fermano solo l'invio allo SDI ( parametro f ), perché un file che ne ha verrebbe
     * scartato: la visualizzazione li mostra sopra la fattura, insieme agli avvisi ( cose da verificare che non
     * fermano niente, come il bollo che forse è dovuto ), e il download scarica comunque il file e li scrive nel log.
     * Fino al 2026-09-30 un file non valido non si poteva nemmeno guardare: al suo posto arrivavano gli errori. Se lo
     * schema manca la validazione viene saltata. La visualizzazione usa i fogli di stile ufficiali in
     * _mod/_0400.documenti/_src/_xml/_xsl/, quello della PA se il destinatario ha se_pubblica_amministrazione, e la
     * trasformazione si fa sul server con xmlTransform(), perché i browser stanno abbandonando XSLT ( Chrome smette di
     * applicare <?xml-stylesheet?> dal novembre 2026 ); solo se sul server manca l'estensione xsl il file viene mandato
     * al browser con il riferimento al foglio di stile, come si faceva fino al 2026-09-29, e gli errori stanno in un
     * commento in testa al file.
     *
     * conformità alle specifiche
     * --------------------------
     * Il 2026-09-25 il file è stato rivisto contro lo schema Schema_VFPR12_v1.2.3.xsd ( specifiche tecniche 1.9 ) e
     * verificato validando con DOMDocument::schemaValidate() fatture di prova a privati con PEC, a PA con CIG e CUP e a
     * persone fisiche. Il 2026-09-29 è stato riletto contro le specifiche 1.9.1, in vigore dal 15 maggio 2026, che non
     * cambiano lo schema: l'attributo versione resta FPR12 / FPA12 e il namespace resta quello della 1.2. I codici
     * ( TipoDocumento, RegimeFiscale, Natura, ModalitaPagamento ) arrivano dal database così come sono, e i valori
     * nuovi ( TD28, TD29, RF20, MP23... ) li porta la patch _202609291300.fatturapa.codici.sql.
     *
     * Il 2026-09-30 sono arrivati i blocchi che mancavano, con i dati che li alimentano ( patch
     * _202609301800.fatturapa.blocchi.sql ), letti e calcolati da generaContenutiDocumento():
     *
     * blocco                   | da dove arriva
     * -------------------------|-----------------------------------------------------------------------------------
     * DatiRitenuta             | documenti_ritenute ( tipo RT01 - RT06, aliquota, causale ); l'importo, se non è
     *                          | indicato, si calcola sulle righe soggette ( documenti_articoli.se_ritenuta ) e sui
     *                          | contributi di cassa soggetti; le righe soggette hanno Ritenuta SI
     * DatiBollo                | documenti.se_bollo_virtuale e documenti.importo_bollo
     * DatiCassaPrevidenziale   | documenti_casse_previdenziali ( cassa TC01 - TC22, aliquota, IVA ); il contributo
     *                          | entra nel riepilogo della sua aliquota e nel totale del documento
     * DatiFattureCollegate     | i documenti collegati con un ruolo che ha se_xml ( 'fattura collegata' )
     * DatiDDT                  | i documenti di trasporto collegati con un ruolo che ha se_xml ( 'DDT collegato' )
     *
     * In DatiFattureCollegate e DatiDDT RiferimentoNumeroLinea si scrive solo se alcune righe, e non tutte, sono legate
     * alle righe del documento collegato ( relazioni_documenti_articoli ); l'IdDocumento e il NumeroDDT sono il numero
     * del documento collegato, come lo scrive Numero di questo file.
     *
     * @todo decidere come trattare i testi più lunghi del massimo consentito dallo schema ( oltre a RiferimentoNormativo )
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

    // testi con una lunghezza massima nello schema ( Denominazione 80, Nome e Cognome 60, Descrizione 1000 ): oltre il
    // massimo lo SDI scarta la fattura, per cui si troncano e lo si dice fra gli avvisi; dopo $testoFattura() il testo e'
    // ASCII, per cui substr() non spezza caratteri
	$troncati = array();
	$testoLimitato = function( $t, $max, $campo ) use ( $testoFattura, &$troncati ) {
	    $t = $testoFattura( $t );
	    if( strlen( $t ) > $max ) {
		$troncati[] = 'testo troncato a ' . $max . ' caratteri, il massimo dello schema: ' . $campo;
		$t = substr( $t, 0, $max );
	    }
	    return $t;
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
	            'Denominazione' => $testoLimitato( $dati['src']['denominazione_fiscale'], 80, 'la denominazione del cedente' )
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
		    'Nome' => $testoLimitato( $dati['dst']['nome'], 60, 'il nome del cliente' ),
		    // - - - - - Cognome / il cognome del cliente privato
		    'Cognome' => $testoLimitato( $dati['dst']['cognome'], 60, 'il cognome del cliente' )
		);

	} else {

		$anagraficaCessionario['Anagrafica'] = array(
		    // - - - - - Denominazione / la denominazione del cliente
		    'Denominazione' => $testoLimitato( $dati['dst']['denominazione_fiscale'], 80, 'la denominazione del cliente' )
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

    // errori, che fermano l'invio allo SDI, e avvisi, che non fermano niente; oltre alla validazione contro lo schema, i
    // controlli che lo schema non fa ( vedi l'intestazione )
	$errori = array();
	$avvisi = $troncati;

    // - - DatiGeneraliDocumento
	$generaliDocumento = array(
	    // - - - - TipoDocumento / la tipologia del documento
	    'TipoDocumento' => $dati['doc']['codice_tipologia'],
	    // - - - - Divisa / la valuta del documento
	    'Divisa' => $dati['doc']['divisa'],
	    // - - - - Data / la data del documento
	    'Data' => $dati['doc']['data'],
	    // - - - - Numero / il numero del documento
	    'Numero' => $dati['doc']['numero']
	);

    // - - - - DatiRitenuta / le ritenute, una per tipo
	foreach( $dati['doc']['ritenute'] as $ritenuta ) {
	    $generaliDocumento['DatiRitenuta'][] = array(
	        // - - - - - TipoRitenuta / il tipo di ritenuta ( RT01 - RT06 )
	        'TipoRitenuta' => $ritenuta['codice_ritenuta'],
	        // - - - - - ImportoRitenuta / l'importo della ritenuta
	        'ImportoRitenuta' => $ritenuta['importo'],
	        // - - - - - AliquotaRitenuta / l'aliquota della ritenuta
	        'AliquotaRitenuta' => $ritenuta['aliquota'],
	        // - - - - - CausalePagamento / la causale del pagamento, come nella Certificazione Unica
	        'CausalePagamento' => $ritenuta['causale_pagamento']
	    );
	    if( empty( $ritenuta['causale_pagamento'] ) ) {
	        $errori[] = 'la ritenuta ' . $ritenuta['codice_ritenuta'] . ' non ha la causale del pagamento';
	    }
	}

    // - - - - DatiBollo / il bollo assolto in modo virtuale
	if( ! empty( $dati['doc']['se_bollo_virtuale'] ) ) {
	    $generaliDocumento['DatiBollo'] = array( 'BolloVirtuale' => 'SI' );
	    if( ! empty( $dati['doc']['importo_bollo'] ) ) {
	        $generaliDocumento['DatiBollo']['ImportoBollo'] = xmlFloat( $dati['doc']['importo_bollo'] );
	    }
	}

    // - - - - DatiCassaPrevidenziale / i contributi alle casse previdenziali
    // NOTA il contributo entra nel totale del documento e, con la sua IVA, nel riepilogo della sua aliquota ( controlli
    // 00419, 00422 e 00444 dello SDI )
	$totaleDocumento = $dati['doc']['tot']['importo_lordo_totale'];
	foreach( $dati['doc']['casse'] as $cassa ) {
	    $blocco = array(
	        // - - - - - TipoCassa / la cassa ( TC01 - TC22 )
	        'TipoCassa' => $cassa['codice_cassa'],
	        // - - - - - AlCassa / l'aliquota del contributo
	        'AlCassa' => $cassa['aliquota'],
	        // - - - - - ImportoContributoCassa / l'importo del contributo
	        'ImportoContributoCassa' => $cassa['importo'],
	        // - - - - - ImponibileCassa / l'importo su cui si calcola il contributo
	        'ImponibileCassa' => $cassa['imponibile'],
	        // - - - - - AliquotaIVA / l'IVA applicata al contributo
	        'AliquotaIVA' => $cassa['aliquota_iva']
	    );
	    // - - - - - Ritenuta / se il contributo è soggetto a ritenuta ( controllo 00415: serve DatiRitenuta )
	    if( ! empty( $cassa['se_ritenuta'] ) ) {
	        if( ! empty( $dati['doc']['ritenute'] ) ) {
	            $blocco['Ritenuta'] = 'SI';
	        } else {
	            $avvisi[] = 'il contributo ' . $cassa['codice_cassa'] . ' è segnato come soggetto a ritenuta, ma il documento non ha ritenute: non viene indicato come tale';
	        }
	    }
	    // - - - - - Natura / la natura del contributo senza IVA
	    if( $cassa['aliquota_iva'] == 0 && ! empty( $cassa['codice_iva'] ) ) {
	        $blocco['Natura'] = $cassa['codice_iva'];
	    }
	    if( empty( $cassa['id_iva'] ) ) {
	        $errori[] = 'il contributo ' . $cassa['codice_cassa'] . ' non ha l\'aliquota IVA';
	    }
	    $generaliDocumento['DatiCassaPrevidenziale'][] = $blocco;
	    // riepilogo e totale
	    if( isset( $dati['doc']['iva'][ $cassa['id_iva'] ] ) ) {
	        $dati['doc']['iva'][ $cassa['id_iva'] ]['imponibile_tot'] += $cassa['importo'];
	        $dati['doc']['iva'][ $cassa['id_iva'] ]['tot'] += $cassa['importo_iva'];
	    } else {
	        $dati['doc']['iva'][ $cassa['id_iva'] ] = array(
	            'imponibile_tot' => $cassa['importo'],
	            'tot' => $cassa['importo_iva'],
	            'codice' => $cassa['codice_iva'],
	            'aliquota' => $cassa['aliquota_iva'],
	            'riferimento' => $cassa['descrizione_iva']
	        );
	    }
	    $totaleDocumento += $cassa['importo'] + $cassa['importo_iva'];
	}

    // - - - - ImportoTotaleDocumento / l'importo lordo totale del documento, con i contributi di cassa e la loro IVA
	$generaliDocumento['ImportoTotaleDocumento'] = xmlFloat( $totaleDocumento );

    // - - - - Causale / la causale del documento, in blocchi da 200 caratteri ( il massimo dello schema; l'elemento e'
    // ripetibile ) spezzati possibilmente fra una parola e l'altra; vuota non si scrive, perche' lo schema non ammette
    // un elemento senza testo
	$causale = trim( $testoFattura( $dati['doc']['causale'] ?? '' ) );
	if( $causale !== '' ) {
	    $generaliDocumento['Causale'] = explode( "\n", wordwrap( preg_replace( '/\s+/', ' ', $causale ), 200, "\n", true ) );
	}

    // - - DatiGenerali
	$generali = array(
	    // - - - DatiGeneraliDocumento
	    'DatiGeneraliDocumento' => $generaliDocumento
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
	foreach( $dati['doc']['collegati']['fatture'] as $collegata ) {

	    // - - - DatiFattureCollegate
		$blocco = array();

	    // - - - - RiferimentoNumeroLinea / le righe a cui si riferisce, se non è tutto il documento
		if( ! empty( $collegata['linee'] ) ) {
		    $blocco['RiferimentoNumeroLinea'] = $collegata['linee'];
		}

	    // - - - - IdDocumento / il numero della fattura collegata
		$blocco['IdDocumento'] = $collegata['numero'];

	    // - - - - Data / la data della fattura collegata ( controllo 00418: non può essere successiva a questa )
		if( ! empty( $collegata['data'] ) ) {
		    $blocco['Data'] = $collegata['data'];
		    if( $collegata['data'] > $dati['doc']['data'] ) {
		        $errori[] = 'la fattura collegata n. ' . $collegata['numero'] . ' ha una data successiva a quella del documento';
		    }
		}

	    // - - - - CodiceCUP e CodiceCIG / i codici della fattura collegata
		if( ! empty( $collegata['cup'] ) ) {
		    $blocco['CodiceCUP'] = $collegata['cup'];
		}
		if( ! empty( $collegata['cig'] ) ) {
		    $blocco['CodiceCIG'] = $collegata['cig'];
		}

		if( empty( $collegata['numero'] ) ) {
		    $errori[] = 'una fattura collegata non ha il numero';
		}

	    // - - - /DatiFattureCollegate
		$generali['DatiFattureCollegate'][] = $blocco;

	}

    // la nota di credito indica sempre la fattura che rettifica
	if( $dati['doc']['codice_tipologia'] == 'TD04' && empty( $dati['doc']['collegati']['fatture'] ) ) {
	    $errori[] = 'la nota di credito non indica la fattura a cui si riferisce: va collegata nelle relazioni del documento, con il ruolo "fattura collegata"';
	}

    // ciclo sui DDT collegati
	foreach( $dati['doc']['collegati']['ddt'] as $ddt ) {

	    // - - - DatiDDT
		$blocco = array(
		    // - - - - NumeroDDT / il numero del documento di trasporto
		    'NumeroDDT' => $ddt['numero'],
		    // - - - - DataDDT / la data del documento di trasporto
		    'DataDDT' => $ddt['data']
		);

	    // - - - - RiferimentoNumeroLinea / le righe a cui si riferisce, se non è tutta la fattura
		if( ! empty( $ddt['linee'] ) ) {
		    $blocco['RiferimentoNumeroLinea'] = $ddt['linee'];
		}

		if( empty( $ddt['numero'] ) || empty( $ddt['data'] ) ) {
		    $errori[] = 'un documento di trasporto collegato non ha il numero o la data';
		}

	    // - - - /DatiDDT
		$generali['DatiDDT'][] = $blocco;

	}

    // la fattura differita indica i documenti di trasporto
	if( $dati['doc']['codice_tipologia'] == 'TD24' && empty( $dati['doc']['collegati']['ddt'] ) ) {
	    $errori[] = 'la fattura differita TD24 non indica i documenti di trasporto: vanno collegati nelle relazioni del documento, con il ruolo "DDT collegato"';
	} elseif( $dati['doc']['codice_tipologia'] == 'TD25' && empty( $dati['doc']['collegati']['ddt'] ) ) {
	    $avvisi[] = 'la fattura differita TD25 non indica documenti di trasporto';
	}

    // - - DatiBeniServizi
	$beniServizi = array( 'DettaglioLinee' => array(), 'DatiRiepilogo' => array() );

    // ciclo sulle righe
	foreach( $dati['doc']['righe'] as $num => $row ) {

	    // - - - DettaglioLinee
		$linea = array(
		    // - - - - NumeroLinea / il numero della riga
		    'NumeroLinea' => $num + 1,
		    // - - - - Descrizione / la descrizione della riga
		    'Descrizione' => $testoLimitato( $row['nome'], 1000, 'la descrizione della riga ' . ( $num + 1 ) ),
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

	    // - - - - Ritenuta / se la riga è soggetta a ritenuta ( controllo 00411: serve DatiRitenuta )
		if( ! empty( $row['se_ritenuta'] ) ) {
		    if( ! empty( $dati['doc']['ritenute'] ) ) {
		        $linea['Ritenuta'] = 'SI';
		    } else {
		        $avvisi[] = 'la riga ' . ( $num + 1 ) . ' è segnata come soggetta a ritenuta, ma il documento non ha ritenute: non viene indicata come tale';
		    }
		}

	    // - - - - Natura / il codice di esenzione IVA della riga
		if( ! empty( $row['codice_iva'] ) ) {
		    $linea['Natura'] = $row['codice_iva'];
		}

	    // le nature generiche N2, N3 e N6 lo SDI le scarta dal 2021 ( controllo 00445 ): le aliquote che le hanno sono
	    // archiviate, ma i documenti di prima le citano ancora
		if( in_array( $row['codice_iva'], array( 'N2', 'N3', 'N6' ) ) ) {
		    $errori[] = 'la riga ' . ( $num + 1 ) . ' ha la natura generica ' . $row['codice_iva'] . ', che lo SDI non accetta più: va scelto un reparto con un\'aliquota che ha la natura di dettaglio';
		}

		// controllo arrotondamento
		// TODO questo non andrebbe fatto nel file _fattura.default.php in modo da impattare anche sul PDF?
		if( sprintf( '%0.2f', $row['importo_netto_unitario'] * $row['qtd'] ) != sprintf( '%0.2f',$row['importo_netto_totale'] ) ) {
			die( 'errore di arrotondamento riga '.($num+1).': '.$row['nome'].' importo totale '.$row['importo_netto_totale'] . ' diverso da ' . ( $row['importo_netto_unitario'] * $row['qtd'] ) );
		}

	    // - - - /DettaglioLinee
		$beniServizi['DettaglioLinee'][] = $linea;

	}

    // il bollo sulle operazioni senza IVA oltre 77,47 euro: non si può dedurre con certezza dalle nature ( le esportazioni
    // e le cessioni intracomunitarie, per esempio, ne sono esenti ), per cui è un avviso e non un errore
	$senzaIva = 0;
	foreach( $dati['doc']['iva'] as $row ) {
	    if( preg_match( '/^(N1|N2|N3\.[3-6]|N4)/', (string) $row['codice'] ) ) {
	        $senzaIva += $row['imponibile_tot'];
	    }
	}
	if( $senzaIva > 77.47 && empty( $dati['doc']['se_bollo_virtuale'] ) ) {
	    $avvisi[] = 'le operazioni senza IVA superano 77,47 euro e il documento non ha il bollo virtuale: verificare se l\'imposta di bollo è dovuta';
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
	    // NOTA con i contributi di cassa imponibile e imposta sono somme, e vanno riportati a due decimali
		$riepilogo['ImponibileImporto'] = xmlFloat( $row['imponibile_tot'] );

	    // - - - - Imposta / l'imposta della riga
		$riepilogo['Imposta'] = xmlFloat( $row['tot'] );

	    // - - - - EsigibilitaIVA / l'esigibilità della riga
		if( ! empty( $dati['doc']['codice_esigibilita'] ) ) {
		    $riepilogo['EsigibilitaIVA'] = $dati['doc']['codice_esigibilita'];
		}

	    // - - - - RiferimentoNormativo / il riferimento normativo dell'esenzione della riga
	    // NOTA per le specifiche il riferimento normativo si indica solo con la Natura: la descrizione di un'aliquota
	    // ordinaria ( "IVA 22%" ) non è una norma, e fino al 2026-09-25 finiva lo stesso nel riepilogo
	    // NOTA lo schema ammette al massimo 100 caratteri, e alcune descrizioni della tabella iva sono più lunghe ( quella
	    // del regime forfettario ne ha 123 ): fino al 2026-09-29 finivano intere e il file non era valido; il testo è già
	    // ASCII, per cui substr() non spezza caratteri
		if( ! empty( $row['codice'] ) && ! empty( $row['riferimento'] ) ) {
		    $riepilogo['RiferimentoNormativo'] = substr( $testoFattura( $row['riferimento'] ), 0, 100 );
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

    // validazione contro lo schema ufficiale ( gli errori si aggiungono a quelli dei controlli )
	$erroriSchema = array();
	xmlValidate( implode( $rows ), DIR_BASE . '_mod/_0400.documenti/_src/_xml/_xsd/Schema_VFPR12_v1.2.3.xsd', $erroriSchema );
	foreach( $erroriSchema as $errore ) {
	    $errori[] = 'schema FatturaPA, ' . $errore;
	}

    // gli errori vanno nel log, qualunque sia l'uscita
	if( ! empty( $errori ) ) {
	    logger( 'la fattura ' . basename( $outFile ) . ' ( documento ' . $dati['doc']['id'] . ' ) non si può inviare allo SDI: ' . implode( ' | ', $errori ), 'xml', LOG_ERR );
	}

    // foglio di stile per la visualizzazione, PA o privati
	$xsl = DIR_BASE . '_mod/_0400.documenti/_src/_xml/_xsl/' . ( ( $dati['dst']['se_pubblica_amministrazione'] == 1 ) ? 'fatturaPA_v1.2.3.xsl' : 'fatturaordinaria_v1.2.3.xsl' );

    // uscita
    // NOTA gli errori fermano solo l'invio allo SDI, che scarterebbe il file: con f al posto del percorso arrivano gli
    // errori; il download scarica comunque il file, e la visualizzazione mostra errori e avvisi sopra la fattura
	if( isset( $_REQUEST['f'] ) ) {
	    if( ! empty( $errori ) ) {
	        buildJson( array( 'errori' => $errori ) );
	    } else {
	        buildJson( array( 'file' => $outFile ) );
	    }
    } elseif( isset( $_REQUEST['d'] ) ) {
	    header( 'Content-disposition: attachment; filename=' . basename( $outFile ) );
        buildXml( implode( $rows ) );
	} elseif( ( $html = xmlTransform( implode( $rows ), $xsl ) ) !== false ) {
	    // riquadro con errori e avvisi, subito dopo l'apertura del body della pagina prodotta dal foglio di stile
	    $riquadro = '';
	    if( ! empty( $errori ) ) {
	        $riquadro .= '<div style="margin:1em;padding:.5em 1em;border:2px solid #c00;background:#fee;font-family:sans-serif;">'
	            . '<p><strong>Questa fattura non può essere inviata allo SDI:</strong></p><ul><li>'
	            . implode( '</li><li>', array_map( 'htmlspecialchars', $errori ) ) . '</li></ul></div>';
	    }
	    if( ! empty( $avvisi ) ) {
	        $riquadro .= '<div style="margin:1em;padding:.5em 1em;border:2px solid #c90;background:#ffe;font-family:sans-serif;">'
	            . '<p><strong>Da verificare:</strong></p><ul><li>'
	            . implode( '</li><li>', array_map( 'htmlspecialchars', $avvisi ) ) . '</li></ul></div>';
	    }
	    if( ! empty( $riquadro ) ) {
	        $html = preg_replace_callback( '/<body[^>]*>/i', function( $m ) use ( $riquadro ) { return $m[0] . $riquadro; }, $html, 1 );
	    }
	    build( $html, MIME_TEXT_HTML );
	} else {
	    // NOTA senza l'estensione xsl la trasformazione la fa il browser, finché la supporta; errori e avvisi stanno in un
	    // commento in testa al file, perché la pagina la costruisce il browser
	    header( 'Content-disposition: inline; filename=' . basename( $outFile ) );
		$testa = array( '<?xml-stylesheet type="text/xsl" href="' . $cf['site']['url'] . getShortPath( $xsl ) . '" ?>' . PHP_EOL );
		if( ! empty( $errori ) || ! empty( $avvisi ) ) {
		    $testa[] = '<!-- ' . str_replace( '--', '- -', implode( PHP_EOL, array_merge( $errori, $avvisi ) ) ) . ' -->' . PHP_EOL;
		}
		array_splice( $rows, 1, 0, $testa );
		buildXml( implode( $rows ) );
    }

