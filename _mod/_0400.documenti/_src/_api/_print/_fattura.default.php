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
	    'SELECT documenti.*,  '.
	    'tipologie_documenti.codice AS codice_tipologia, condizioni_pagamento.codice AS codice_pagamento '.
	    'FROM documenti '.
	    'INNER JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia '.
        'INNER JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento '.
	    'WHERE documenti.id = ?',
	    array( array( 's' => $_REQUEST['__documento__'] ) )
	);

    // verifico la presenza del progressivo di invio
	if( empty( $doc['progressivo_invio'] ) ) { dieText( 'progressivo invio mancante' ); }

    // TODO
    $doc['divisa'] = 'EUR';

    // TODO
    if($doc['esigibilita'] != NULL ){
        $doc['codice_esigibilita'] = $doc['esigibilita'];
    } else {
        $doc['codice_esigibilita'] = 'I';
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
        'SELECT modalita_pagamento.codice AS codice_pagamento, '.
        'date_format( from_unixtime(timestamp_scadenza), "%Y-%m-%d" ) AS data_standard, '.
        ' pagamenti.importo_lordo_totale, iban.iban AS iban  '.
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
	if( empty( $src['codice_archivium'] ) ) { dieText( 'codice archivium azienda inviante vuoto' ); }

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
        'WHERE anagrafica_indirizzi.id_anagrafica = ? ',
        array( array( 's' => $src['id'] ) )
    );


    // indirizzo fiscale
    $sri['indirizzo_fiscale'] = $sri['tipologia'] . ' ' . $sri['indirizzo'] . ', ' . $sri['civico'];

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


/**
 * NOTA è possibile emettere fattura elettronica verso privati senza SDI e PEC specificando '0000000'
 * lasciando vuoto il campo PECDestinatario e omettendo il campo IdFiscaleIVA
    // verifico la presenza di SDI o PEC del destinatario
    if( $dst['codice_sdi'] == '0000000' && empty( $dst['pec_sdi'] ) ) {
        dieText('PEC e SDI assenti' );
    }
 */

    // codice SDI di default a '0000000' per i destinatari senza codice SDI
    if( empty( $dst['codice_sdi'] ) && ! empty( $dst['id_pec_sdi'] ) ) {
        $dst['codice_sdi'] = '0000000';
    }

    // verifico che il codice SDI risponda al pattern corretto
    if( ! preg_match( '/[a-zA-Z0-9]+/', $dst['codice_sdi'] ) ) {
        dieText('valore non corretto per codice SDI: ' . $dst['codice_sdi'] );
    }

    if( !empty($dst['id_pec_sdi'])){
        $dst['pec_sdi'] =  mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT indirizzo from mail where id = ?',
            array( array( 's' => $dst['id_pec_sdi'] ) ) );
    }

    // denominazione fiscale
    $dst['denominazione_fiscale'] = trim( $dst['nome'] . ' ' . $dst['cognome'] . ' ' . $dst['denominazione'] );

    // recupero i dati della sede dell'emittente
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
        'WHERE anagrafica_indirizzi.id_anagrafica = ? ',
        array( array( 's' => $dst['id'] ) )
    );

    // indirizzo fiscale
    $dsi['indirizzo_fiscale'] = $dsi['tipologia'] . ' ' . $dsi['indirizzo'] . ', ' . $dsi['civico'];

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

