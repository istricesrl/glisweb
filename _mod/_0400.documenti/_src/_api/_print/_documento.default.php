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

    // verifico la presenza di un ID documento
    if( ! isset( $_REQUEST['__documento__'] ) || empty( $_REQUEST['__documento__'] ) ) { dieText('ID documento mancante'); }

    // recupero i dati del documento
    $doc = mysqlSelectRow(
        $cf['mysql']['connection'],
	    'SELECT documenti.*, '.
	    'tipologie_documenti.se_fattura, tipologie_documenti.se_nota_credito, tipologie_documenti.se_nota_debito, tipologie_documenti.nome AS tipologia, '.
        'greatest( tipologie_documenti.se_fattura, tipologie_documenti.se_nota_credito, tipologie_documenti.se_nota_debito ) AS se_progressivo_invio_richiesto, '.
        'tipologie_documenti.codice AS codice_tipologia, '.
        'condizioni_pagamento.codice AS codice_pagamento '.
	    'FROM documenti '.
	    'INNER JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia '.
        'INNER JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento '.
	    'WHERE documenti.id = ?',
	    array( array( 's' => $_REQUEST['__documento__'] ) )
	);

    // verifico l'identità dell'utente
    if( ! in_array( 'roots', array_keys( $_SESSION['groups'] ) ) && ( $doc['id_destinatario'] != $_SESSION['account']['id_anagrafica'] ) && ( ! isset( $_REQUEST['t'] ) || $_REQUEST['t'] != $doc['token'] ) ) {
        dieText('autorizzazioni insufficienti a visualizzare il documento');
    }

    // TODO svuoto il token
    // ...

    // annoto l'attività di stampa
    mysqlInsertRow(
        $cf['mysql']['connection'],
        array(
            'id_tipologia' => 22,
            'id_documento' => $doc['id'],
            'data_attivita' => date('Y-m-d'),
            'ora_inizio' => date( 'H:i:s' ),
            'ora_fine' => date( 'H:i:s' )
        ),
        'attivita'
    );

    // debug
    // print_r( $doc );

    // TODO
    if( empty( $doc ) ) {
        die('esigibilità IVA o mdalità pagamento non impostate');
    }

    // verifico la presenza del progressivo di invio
	if( ! empty( $doc['se_progressivo_invio_richiesto'] ) && empty( $doc['progressivo_invio'] ) ) { dieText( 'progressivo invio mancante' ); }

    // TODO
    $doc['divisa'] = 'EUR';

    // TODO
    if( ! empty( $doc['esigibilita'] ) ) {
        $doc['codice_esigibilita'] = $doc['esigibilita'];
    } else {
        // $doc['codice_esigibilita'] = 'I';
        die('codice esigibilità IVA non impostato');
    }
    
    /**
     * NOTA Esigibilità Dell’IVA: Immediata, Differita, Scissione
     * Codici IVA fattura elettronica: cosa significa esegibilità dell’IVA? Sono vari i casi in cui è obbligatorio pagare l’IVA per una transazione commerciale,
     * di qualsiasi genere. Questa imposta può però essere saldata in modi e maniere del tutto differenti tra loro. Il comportamento che si desidera tenere
     * nei confronti dell’imposta è da indicare all’interno della fattura elettronica. Bisogna segnalare sia l’esigibilità sia la modalità del versamento.
     * L’IVA infatti può essere esigibile immediatamente nel momento in cui si esegue la transazione. In questi casi si indica il codice “I”, ossia esigibilità immediata.
     * Volendo è invece possibile effettuare il pagamento dell’IVA solo nel momento in cui si riceve il pagamento per la fattura che si sta emettendo. In questi
     * casi si utilizza il codice “D”, ossia IVA Differita. Esiste una terza opzione, da indicare con il codice IVA in fattura elettronica “S”, che indica la
     * scissione dei pagamenti (meglio nota come split payment).
     */

    // TODO
    $doc['condizioni_pagamento'] = $doc['codice_pagamento'];

    /**

     * NOTA condizioni di pagamento
     * TP01 Pagamento a rate: viene impostato un pagamento a rate dove è possibile impostare una sola rata, nel caso infatti in cui il cliente non abbia saldato la fattura al momento dell’emissione o sia necessario indicare dei dati Bancari, attraverso questo tipo di pagamento sarà possibile impostare tali dati.
     * TP02 Pagamento completo: va impostato nel caso in cui il pagamento sia stato già completato;
     * TP03 Anticipo: nel caso in cui un cliente depositi un anticipo si potrà utilizzare questa modalità di pagamento indicando i dati specifici.
     */

     // TODO
    $doc['causale'] = 'vendita';

    // inizializzo il totale
    $doc['tot']['importo_netto_totale'] = 0;
    $doc['tot']['importo_iva_totale'] = 0;
    $doc['tot']['importo_lordo_totale'] = 0;

    // carico le righe del documento
    $doc['righe'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT documenti_articoli.*, '.
        'iva.aliquota, iva.codice, iva.id AS id_iva, iva.nome AS nome_iva, iva.codice AS codice_iva, iva.descrizione AS descrizione_iva, '.
        'udm.sigla AS udm FROM documenti_articoli '.
        'INNER JOIN reparti ON reparti.id = documenti_articoli.id_reparto '.
        'INNER JOIN iva ON iva.id = reparti.id_iva '.
        'INNER JOIN udm ON udm.id = documenti_articoli.id_udm '.
        'WHERE documenti_articoli.id_documento = ? '.
        'AND documenti_articoli.id_genitore IS NULL',
        array( array( 's' => $doc['id'] ) )
    );

    // controllo contenuto
    if( empty( $doc['righe'] ) ) {
        dieText('inserire almeno una riga');
    }

    // elaboro i totali
    foreach( $doc['righe'] as &$riga ) {

        $riga['qtd'] = ( empty( $riga['quantita'] ) ) ? 1 : $riga['quantita'];

        $riga['importo_netto_unitario']         = str_replace( ',', '.', round( ( $riga['importo_netto_totale'] / $riga['qtd'] ), 2 ) );
        $riga['importo_netto_totale']           = str_replace( ',', '.', round( $riga['importo_netto_totale'] , 2 ) );
        $riga['importo_iva_totale']             = str_replace( ',', '.', round( $riga['importo_netto_totale'] * ( $riga['aliquota'] / 100 ), 2 ) );
        $riga['importo_lordo_totale']           = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_totale'] + $riga['importo_iva_totale'] ) );
        $riga['aliquota']                       = str_replace( ',', '.', sprintf( '%0.2f', round( $riga['aliquota'], 2 ) ) );

        $doc['tot']['importo_netto_totale']     += $riga['importo_netto_totale'];
        $doc['tot']['importo_iva_totale']       += $riga['importo_iva_totale'];
        $doc['tot']['importo_lordo_totale']     += $riga['importo_lordo_totale'];

        if( isset( $doc['iva'][ $riga['id_iva'] ]['tot'] ) ) {
            $doc['iva'][ $riga['id_iva'] ]['imponibile_tot'] += $riga['importo_netto_totale'];
            $doc['iva'][ $riga['id_iva'] ]['tot'] += $riga['importo_iva_totale'];
        } else {
            $doc['iva'][ $riga['id_iva'] ] = array(
                'tot' => $riga['importo_iva_totale'],
                'imponibile_tot' => str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_totale'] ) ),
                'nome' => $riga['nome_iva'],
                'codice' => $riga['codice_iva'],
                'aliquota' => str_replace( ',', '.', sprintf( '%0.2f', $riga['aliquota'] ) ),
                'riferimento' => ( ( ! empty( $riga['descrizione_iva'] ) ) ? $riga['descrizione_iva'] : NULL )
            );
        }

        $riga['importo_netto_unitario']                     = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_unitario'] ) );
        $riga['importo_netto_totale']                       = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_totale'] ) );
        $riga['importo_iva_totale']                         = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_iva_totale'] ) );
        $riga['importo_lordo_totale']                       = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_lordo_totale'] ) );
        $doc['iva'][ $riga['id_iva'] ]['imponibile_tot']    = str_replace( ',', '.', sprintf( '%0.2f', round( $doc['iva'][ $riga['id_iva'] ]['imponibile_tot'], 2 ) ) );
        $doc['iva'][ $riga['id_iva'] ]['tot']               = str_replace( ',', '.', sprintf( '%0.2f', round( $doc['iva'][ $riga['id_iva'] ]['tot'], 2 ) ) );

    }

    // formattazione totali
    if( ! empty( $doc['tot'] ) ){
		foreach( $doc['tot'] as &$tot ) {
			$tot = str_replace( ',', '.', sprintf( '%0.2f', $tot ) );
		}
	}

    // formattazione IVA
	if( ! empty( $doc['iva'] ) ) {
		foreach( $doc['iva'] as &$tot ) {
			$tot['tot'] = str_replace( ',', '.', sprintf( '%0.2f', $tot['tot'] ) );
		}
	}

    // carico i pagamenti per il documento
    $doc['pagamenti'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT pagamenti.nome, modalita_pagamento.codice AS codice_pagamento, modalita_pagamento.nome AS modalita ,'.
        'date_format( data_scadenza, "%d/%m/%Y" ) AS data_italiana, '.
        'date_format( data_scadenza, "%Y-%m-%d" ) AS data_standard, '.
        'pagamenti.importo_lordo_totale, iban.iban AS iban  '.
        'FROM pagamenti '.
        'LEFT JOIN modalita_pagamento ON modalita_pagamento.id = pagamenti.id_modalita_pagamento '.
        'LEFT JOIN iban ON iban.id = pagamenti.id_iban '.
        'WHERE pagamenti.id_documento = ?',
        array( array( 's' => $doc['id'] ) )
    );

    // debug
    /*
    $doc['pagamenti'] = array(
        array(
            'codice_pagamento' => 'MP01',
            'data_standard' => '2022-01-31',
            'importo_lordo_totale' => '122.00'
        )
    );
    */

    // elaboro i pagamenti
    // TODO

    // inizializzo il progressivo di invio
    /*
    if( empty( $doc['progressivo_invio'] ) ) {
        $doc['progressivo_invio'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT coalesce( ( max( progressivo_invio ) + 1 ), 1 ) AS t FROM documenti'
        );
    }
    */

    /**
     * NOTA il progressivo di invio dovrebbe essere assegnato al momento dell'invio? come facciamo per quelli che si
     * scaricano l'XML e lo inviano a mano? bisogna rileggersi la documentazione della fatturazione elettronica
     */

    // recupero i dati dell'emittente
	$src = mysqlSelectRow(
        $cf['mysql']['connection'],
	    'SELECT * FROM anagrafica WHERE id = ?',
	    array( array( 's' => $doc['id_emittente'] ) )
	);

    // verifico la presenza del progressivo di invio
	if( empty( $src['codice_archivium'] ) && ! empty( $cf['archivium']['profile'] ) ) { dieText( 'codice archivium azienda inviante vuoto' ); }

    // denominazione fiscale
    $src['denominazione_fiscale'] = trim( $src['nome'] . ' ' . $src['cognome'] . ' ' . $src['denominazione'] );

    // recupero i dati della sede dell'emittente
    $sri = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT tipologie_indirizzi.nome AS tipologia, indirizzi.indirizzo, indirizzi.civico, indirizzi.cap, '.
        'comuni.nome AS comune, provincie.sigla AS provincia, '.
        'stati.iso31661alpha2 AS sigla_stato '.
        'FROM anagrafica_indirizzi '.
        'INNER JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo '.
        'INNER JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia '.
        'INNER JOIN comuni ON comuni.id = indirizzi.id_comune '.
        'INNER JOIN provincie ON provincie.id = comuni.id_provincia '.
        'INNER JOIN regioni ON regioni.id = provincie.id_regione '.
        'INNER JOIN stati ON stati.id = regioni.id_stato '.
        'WHERE anagrafica_indirizzi.id_anagrafica = ? AND indirizzi.id = ?',
        array(
            array( 's' => $src['id'] ),
            array( 's' => $doc['id_sede_emittente'] )
        )
    );

    // controllo indirizzo
    if( empty( $sri ) ) {
        dieText('richiesto indirizzo sede emittente');
    }

    // recupero il logo dell'azienda emittente
	$sri['logo'] = anagraficaGetLogo( $doc['id_emittente'] );

    // indirizzo fiscale
    $sri['indirizzo_fiscale'] = $sri['tipologia'] . ' ' . $sri['indirizzo'] . ', ' . $sri['civico'];
    $sri['comune_indirizzo_fiscale'] = $sri['cap'] . ' ' . $sri['comune'] . ' ' . $sri['provincia'];

    // regime fiscale dell'emittente
    $srr = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT * FROM regimi WHERE id = ?',
        array( array( 's' => $src['id_regime'] ) )
    );

    // recupero i dati del destinatario
	$dst = mysqlSelectRow(
        $cf['mysql']['connection'],
	    'SELECT anagrafica.*, tipologie_anagrafica.se_pubblica_amministrazione FROM anagrafica LEFT JOIN tipologie_anagrafica ON tipologie_anagrafica.id = anagrafica.id_tipologia  WHERE anagrafica.id = ?',
	    array( array( 's' => $doc['id_destinatario'] ) )
	);

    // se il documento è una fattura, lo SDI è richiesto
    if( $doc['se_fattura'] ) {

        // codice SDI di default a '0000000' per i privati senza codice SDI
        if( empty( $dst['codice_sdi'] ) && empty( $dst['partita_iva'] ) ) {
            $dst['codice_sdi'] = '0000000';
        }

        // verifico che il codice SDI risponda al pattern corretto
        if( ! preg_match( '/[a-zA-Z0-9]+/', $dst['codice_sdi'] ) ) {
            dieText('valore non corretto per codice SDI: ' . $dst['codice_sdi'] );
        }

        // destinatari con PEC
        if( ! empty( $dst['id_pec_sdi'] ) ) {
            $dst['pec_sdi'] =  mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT indirizzo from mail where id = ?',
                array( array( 's' => $dst['id_pec_sdi'] ) ) );
        }

        // controllo CIG
        if( ! empty( $dst['se_pubblica_amministrazione'] ) ) {
            if( empty( $doc['cig'] ) ) {
                dieText('richiesto CIG per emettere fattura PA' );
            }
    # TODO verificare se è sempre obbligatorio
    #        if( empty( $doc['cup'] ) ) {
    #            dieText('richiesto CUP per emettere fattura PA' );
    #        }
            if( empty( $doc['riferimento'] ) ) {
                dieText('richiesto riferimento per emettere fattura PA' );
            }
        }

    }

    // denominazione fiscale
    $dst['denominazione_fiscale'] = trim( $dst['nome'] . ' ' . $dst['cognome'] . ' ' . $dst['denominazione'] );

    // recupero i dati della sede destinatario
    $dsi = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT tipologie_indirizzi.nome AS tipologia, indirizzi.indirizzo, indirizzi.civico, indirizzi.cap, '.
        'comuni.nome AS comune, provincie.sigla AS provincia, '.
        'stati.iso31661alpha2 AS sigla_stato '.
        'FROM anagrafica_indirizzi '.
        'INNER JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo '.
        'INNER JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia '.
        'INNER JOIN comuni ON comuni.id = indirizzi.id_comune '.
        'INNER JOIN provincie ON provincie.id = comuni.id_provincia '.
        'INNER JOIN regioni ON regioni.id = provincie.id_regione '.
        'INNER JOIN stati ON stati.id = regioni.id_stato '.
        'WHERE anagrafica_indirizzi.id_anagrafica = ? AND indirizzi.id = ?',
        array(
            array( 's' => $dst['id'] ),
            array( 's' => $doc['id_sede_destinatario'] )
        )
    );

    // debug
    // print_r( $dsi );

    // controllo indirizzo
    if( empty( $dsi ) ) {
        dieText('richiesto indirizzo sede destinatario');
    }

    // indirizzo fiscale
    $dsi['indirizzo_fiscale'] = $dsi['tipologia'] . ' ' . $dsi['indirizzo'] . ', ' . $dsi['civico'];
    $dsi['comune_indirizzo_fiscale'] = $dsi['cap'] . ' ' . $dsi['comune'] . ' ' . $dsi['provincia'];

    // documenti collegati
    // TODO selezionare in base al ruolo
    // TODO selezionare solo le fatture
    // TODO fare la UNION in $dcl anche delle relazioni fra righe (una riga di nota di credito può far riferimento a una o più righe di fattura specifiche e non all'intera fattura)
    $dcl = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT documenti_view.* '.
        'FROM relazioni_documenti '.
        'INNER JOIN documenti_view ON documenti_view.id = relazioni_documenti.id_documento_collegato '.
        'WHERE relazioni_documenti.id_documento = ?',
        array( array( 's' => $doc['id'] ) )
    );

    // TODO DDT collegati
    // cercare i DDT
    // compilare la sezione <DatiDDT>

    // nome del file
	$outFileName =
	    $sri['sigla_stato'].                    // va espresso secondo lo standard ISO 3166-1 alpha-2
	    $src['codice_fiscale'].                 // il codice fiscale dell'azienda emittente
	    '_'.                                    // separatore
	    $doc['progressivo_invio'].              // progressivo univoco del documento
	    '.'.$cnf['estensione'];                 // estensione

    /**
     * NOTA cos'è la sigla stato?
     */

    // percorso del file di output
	$outFilePath = DIR_VAR_SPOOL_DOCS . 'fatture/' . $cnf['estensione'] . '/';

    // verifico il path del file di output
    checkFolder( $outFilePath );

    // file di output
	$outFile = $outFilePath . $outFileName;

    /**
     * Fattura elettronica a privato senza p iva: obbligo di legge
     * Emettere Fattura elettronica a privato senza p iva è obbligatorio. È la legge a stabilirlo. Ed è obbligatorio sin dal primo gennaio 2019 per effetto della Legge di Bilancio. Una regola che riguarda tutte le operazioni B2C che hanno per oggetto la cessione di beni mobili e immobili effettuate da un soggetto IVA verso un cliente o un consumatore finale. Nonostante questa specifica esistono come 4 eccezioni alla regola principale. In altre parole alcuni soggetti sono esonerati dall’obbligo di emettere fattura elettronica a privato senza p iva. È questo il caso, ad esempio, dei contribuenti che agiscono nel regime forfettario. È comunque sempre possibile adottarla come scelta libera.
     * 
     * Fattura elettronica a privato senza p iva, senza codice destinatario e senza PEC
     * I privati senza partita Iva non hanno alcun obbligo di dotarsi di PEC, oppure di codice destinatario, anche se devono ricevere una fattura elettronica. Resta il fatto che, in alcuni casi, un’azienda o un professionista debba emettere fattura elettronica a privato senza p iva. In questo caso, in fase di compilazione della e-fattura, deve:
     * 
     * inserire il codice convenzionale: “0000000” (7 zeri) nel campo “CodiceDestinatario”
     * Lasciare vuoto senza compilazione il campo “IdFiscaleIVA” e specificare solo l’eventuale Codice Fiscale del destinatario
     * Lasciare vuoto il campo “PECDestinatario”.
     * Inoltre il Provvedimento 89757 del Direttore dell’Agenzia delle entrate ha stabilito che:
     * 
     * Il Sistema di Interscambio recapita la fattura elettronica al destinatario direttamente nell’area riservata del sito di AdE
     * È obbligatorio consegnare al cliente una copia cartacea o digitale ed informarlo che l’originale si trova sul sito dell’Agenzia delle Entrate
     * Inoltre è importante sapere che alcuni software/piattaforme sono in grado di convertire il formato XML in uno leggibile in altri formati desiderati.
     * 
     * Fattura elettronica a privato senza p iva, senza codice univoco, ma con PEC
     * Può capitare che qualche privato abbia la PEC, ma non per questo il codice univoco. In questi casi allora bisogna:
     * 
     * inserire il codice convenzionale: “0000000” (7 zeri) nel campo “CodiceDestinatario”
     * Lasciare vuoto senza compilazione il campo “IdFiscaleIVA” e specificare solo l’eventuale Codice Fiscale del destinatario
     * compilare il campo “PECDestinatario”.
     * Il sistema di Interscambio, questa volta, recapiterà alla PEC del destinatario la fattura elettronica. SDI mette comunque a disposizione del destinatario una copia della fattura all’interno dell’area privata sul sito di agenzia delle Entrate.
     * 
     * Fattura elettronica a privato senza p iva
     * 
     * Privato senza p iva, con codice univoco
     * Anche se si tratta di un caso davvero molto raro, è pur sempre probabile. In questo caso, in fase di compilazione della fattura elettronica bisogna:
     * 
     * inserire nel campo “CodiceDestinatario” il codice comunicato
     * Lasciare vuoto senza compilazione il campo “IdFiscaleIVA” e specificare solo l’eventuale Codice Fiscale del destinatario
     * Compilare o meno il campo “PECDestinatario”.
     * Per quanto riguarda l’invio invece SDI recapita la fattura elettronica all’indirizzo corrispondente al codice destinatario.
     * 
     * Privato senza p iva e cliente estero
     * Si tratta di un caso piuttosto frequente, che deve essere gestito come segue:
     * 
     * inserire il codice convenzionale: “XXXXXXX” (7 volte X) nel campo “CodiceDestinatario”
     * indicare nel campo “CodiceFiscale” il codice fiscale del destinatario
     * Lasciare vuoto senza compilazione il campo “IdFiscaleIVA” e specificare solo l’eventuale Codice Fiscale del destinatario
     * In questo specifico caso però il Sistema di Interscambio non è in grado di recapitare la fattura elettronica al destinatario. Questo perché non la può recapitare all’estero, visto che il sistema di fatturazione elettronica esiste (al momento) solo in Italia. Questo significa che la fattura deve essere consegnata a mano al cliente. Il formato può essere cartaceo, oppure digitale nella forma che lui desidera.
     * 
     */

