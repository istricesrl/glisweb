<?php

    /**
     * duplicazione di un documento
     *
     * Crea un nuovo documento copiando testata e righe di quello passato in $_REQUEST['id'], di qualunque tipologia.
     * Nasce dalla duplicazione delle offerte di LUGHESE ( richiesta Montanari del 02/10/2026 ), portata nello standard
     * il 24/11/2026.
     *
     * la testata
     * ==========
     * Della testata si tiene tutto, tranne quello che appartiene alla vita del documento di partenza: codice, invio,
     * chiusura, archiviazione e token. Il codice va svuotato anche perche' documenti.codice ha un indice unico, e
     * copiarlo fa fallire l'INSERT su ogni documento che ne abbia uno ( Zoli, report test del 06/10/2026 ).
     *
     * Due comportamenti dipendono dalla configurazione ( _030.common.php ):
     * - $cf['documenti']['duplica']['numera']: con true la copia prende sezionale dell'anno, il progressivo successivo
     *   della sua numerazione ( generaProssimoNumeroDocumento(), la stessa del pulsante OTTIENI NUMERO ) e la data di
     *   oggi; con false ( default ) numero, sezionale e data restano vuoti, e il documento si numera dalla scheda;
     * - $cf['documenti']['duplica']['destinatario']: con true ( default ) la copia tiene destinatario e sedi; con false
     *   nasce senza, per chi duplica un documento per farne uno a un altro cliente.
     *
     * le righe
     * ========
     * Le righe si copiano con mysqlDuplicateRow() e non lasciandole a mysqlDuplicateRowRecursive() come fa
     * _ddt.da.ordine.php: documenti_articoli si riferisce a se stessa con id_genitore, e una copia ricorsiva
     * lascerebbe le righe figlie agganciate alle madri del documento di partenza. Si copiano quindi prima le righe
     * principali e poi le figlie, rimappando id_genitore sulle copie. Anche il codice delle righe si svuota, per lo
     * stesso indice unico della testata. Le righe la cui copia fallisce non si contano fra le duplicate e finiscono
     * negli errori.
     *
     * i prezzi
     * ========
     * Con $_REQUEST['prezzi'] = 'originali' ( default ) le righe si copiano coi loro prezzi. Con 'attuali', e solo se il
     * modulo listini e' attivo, ogni riga con un articolo prende il prezzo di listino di oggi ( prezzoListinoArticolo()
     * del modulo listini ) e gli importi si ricalcolano con quantita' e sconti della riga di partenza
     * ( importiRigaDocumento() ); se il listino non ha piu' quell'articolo la copia resta senza prezzo e senza importi,
     * da completare a mano, invece di portarsi dietro un prezzo vecchio. Le righe senza articolo ( testo libero, righe
     * di sconto ) si copiano come sono. I float si scrivono col punto: con la locale italiana PHP 7.3 li renderebbe
     * "4082,5", e qui non c'e' la normalizzazione del controller.
     *
     * Le scritture non passano dal controller, quindi la vista statica delle offerte va riallineata qui, come fa
     * _documenti.finally.php.
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_DOCUMENTI' );

    // inizializzo l'array del risultato
	$status = array();

    // se è passato un ID documento
    if( isset( $_REQUEST['id'] ) ) {

        // seleziono il documento da duplicare
        $status['current'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM documenti WHERE id = ?',
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        // verifico che il documento richiesto sia valido
        if( ! empty( $status['current']['id'] ) ) {

            // account e momento della duplicazione
            $account = ( isset( $_SESSION['account']['id'] ) ) ? $_SESSION['account']['id'] : NULL;
            $adesso = time();

            // prezzi di oggi solo se richiesti e se c'e' il modulo listini
            $attuali = ( isset( $_REQUEST['prezzi'] ) && $_REQUEST['prezzi'] == 'attuali' );
            if( $attuali && ! in_array( '4120.listini', $cf['mods']['active']['array'] ) ) {
                $status['err'][] = 'prezzi attuali richiesti senza il modulo listini, copio i prezzi originali';
                $attuali = false;
            }

            // campi della testata da non copiare
            $testata = array(
                'codice' => NULL,
                'timestamp_invio' => NULL,
                'progressivo_invio' => NULL,
                'note_invio' => NULL,
                'timestamp_chiusura' => NULL,
                'note_chiusura' => NULL,
                'data_archiviazione' => NULL,
                'note_archiviazione' => NULL,
                'token' => NULL,
                'id_account_inserimento' => $account,
                'timestamp_inserimento' => $adesso,
                'id_account_aggiornamento' => $account,
                'timestamp_aggiornamento' => $adesso
            );

            // numerazione ( il lock preso da generaProssimoNumeroDocumento() cade a fine richiesta e copre l'INSERT )
            if( ! empty( $cf['documenti']['duplica']['numera'] ) ) {
                $testata['sezionale'] = date( 'Y' );
                $testata['numero'] = generaProssimoNumeroDocumento( $status['current']['id_tipologia'], $testata['sezionale'], $status['current']['id_emittente'] );
                $testata['data'] = date( 'Y-m-d' );
                $status['info'][] = 'procedo con la duplicazione come documento ' . $testata['numero'] . '/' . $testata['sezionale'];
            } else {
                $testata['sezionale'] = $testata['numero'] = $testata['data'] = NULL;
                $status['info'][] = 'procedo con la duplicazione senza numero';
            }

            // destinatario
            if( empty( $cf['documenti']['duplica']['destinatario'] ) ) {
                $testata = array_merge( $testata, array_fill_keys( array( 'id_destinatario', 'id_sede_destinatario', 'id_destinatario_spedizione', 'id_sede_destinatario_spedizione' ), NULL ) );
            }

            // status
            $status['new'] = array();

            // duplicazione della testata
            mysqlDuplicateRow(
                $cf['mysql']['connection'],
                'documenti',
                $status['current']['id'],
                NULL,
                $testata,
                $status['new']
            );

            if( isset( $status['new']['id'] ) && ! empty( $status['new']['id'] ) ) {

                // corrispondenza fra le righe di partenza e le loro copie
                $copie = array();

                // righe col prezzo aggiornato a listino, e righe rimaste senza
                $aggiornate = $senzaPrezzo = 0;

                // righe di partenza, prima le principali e poi le figlie
                $righe = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT id, id_genitore, id_articolo, id_listino, quantita, sconto_percentuale, sconto_valore FROM documenti_articoli WHERE id_documento = ? ORDER BY id_genitore IS NOT NULL, id',
                    array( array( 's' => $status['current']['id'] ) )
                );

                // duplico le righe forzando id_documento e rimappando id_genitore
                foreach( $righe as $riga ) {

                    // prezzo e importi di oggi, solo se richiesti e per le righe con un articolo
                    $prezzi = array();
                    if( $attuali && ! empty( $riga['id_articolo'] ) ) {
                        $listino = prezzoListinoArticolo( $cf['mysql']['connection'], $riga['id_articolo'], $riga['id_listino'] );
                        if( ! empty( $listino ) ) {
                            $prezzi = array_merge(
                                array( 'prezzo_netto_unitario' => $listino['prezzo'], 'id_listino' => $listino['id_listino'] ),
                                importiRigaDocumento( $listino['prezzo'], $riga['quantita'], $riga['sconto_percentuale'], $riga['sconto_valore'], $listino['aliquota'] )
                            );
                            foreach( $prezzi as &$valore ) {
                                if( is_float( $valore ) ) {
                                    $valore = number_format( $valore, 2, '.', '' );
                                }
                            }
                            unset( $valore );
                            $aggiornate++;
                        } else {
                            $prezzi = array_fill_keys( array( 'prezzo_netto_unitario', 'prezzo_netto_totale', 'importo_netto_totale', 'importo_lordo_totale', 'importo_lordo_finale' ), NULL );
                            $senzaPrezzo++;
                        }
                    }

                    $copia = mysqlDuplicateRow(
                        $cf['mysql']['connection'],
                        'documenti_articoli',
                        $riga['id'],
                        NULL,
                        array_merge( $prezzi, array(
                            'id_documento' => $status['new']['id'],
                            'codice' => NULL,
                            'id_genitore' => ( empty( $riga['id_genitore'] ) || ! isset( $copie[ $riga['id_genitore'] ] ) ) ? NULL : $copie[ $riga['id_genitore'] ],
                            'data' => $testata['data'],
                            'id_account_inserimento' => $account,
                            'timestamp_inserimento' => $adesso,
                            'id_account_aggiornamento' => $account,
                            'timestamp_aggiornamento' => $adesso
                        ), ( empty( $cf['documenti']['duplica']['destinatario'] ) ) ? array( 'id_destinatario' => NULL ) : array() )
                    );

                    // registro la copia, o l'errore
                    if( ! empty( $copia ) ) {
                        $copie[ $riga['id'] ] = $copia;
                    } else {
                        $status['err'][] = 'impossibile duplicare la riga ' . $riga['id'];
                    }

                }

                // status
                $status['info'][] = 'duplicate ' . count( $copie ) . ' righe su ' . count( $righe );
                if( $attuali ) {
                    $status['info'][] = 'prezzi aggiornati a listino su ' . $aggiornate . ' righe, ' . $senzaPrezzo . ' senza prezzo di listino';
                }

                // vista statica delle offerte
                if( ! empty( getStaticView( NULL, $cf['mysql']['connection'], 'offerte' ) ) ) {
                    refreshStaticView( $cf['mysql']['connection'], 'offerte', $status['new']['id'] );
                }

            } else {

                // status
                $status['err'][] = 'impossibile duplicare il documento';

            }

        } else {

            // status
            $status['err'][] = 'documento non trovato';

        }

    } else {

        // status
        $status['err'][] = 'ID documento non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
