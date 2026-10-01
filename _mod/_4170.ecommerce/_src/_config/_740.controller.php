<?php

    /**
     * gestione carrello lato admin
     * 
     * 
     * 
     */

    // debug
    // print_r( $_REQUEST['__carrello__'] );

    // TODO verificare che l'utente abbia i privilegi sufficienti per chiudere il carrello
    // NOTA tutto da rifare qui
    if( false ) {

        if( isset( $_REQUEST['ck_cassa'] ) && isset( $_SESSION['carrello']['id'] ) ) {

            // debug
            // print_r( $_SESSION['carrello'] );

            // log
            logger( 'controller chiusura carrello ' . $_SESSION['carrello']['id'] . ' in cassa ' . $_REQUEST['ck_cassa'], 'cassa' );

            /*
            // trovo il provider
            $provider = mysqlSelectCachedValue(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT nome FROM modalita_pagamento WHERE id = ?',
                array(
                    array( 's' => $_REQUEST['ck_cassa'] )
                )
            );
            */

            // dati di pagamento
            $payment = array(
                'id'						=> $_SESSION['carrello']['id'],
                'session'					=> NULL,
                'provider_checkout'			=> basename( __FILE__ ),
                'timestamp_checkout'		=> time(),
                'timestamp_pagamento'		=> time(),
                'codice_pagamento'			=> $_SESSION['account']['anagrafica'],
//                'provider_pagamento'		=> $provider,
                'provider_pagamento'        => $_REQUEST['ck_cassa'],
                'importo_pagamento'			=> $_SESSION['carrello']['prezzo_lordo_finale'],
                'status_pagamento'			=> 'PAGATO IN CASSA'
            );

            // registro il pagamento
            mysqlInsertRow(
                $cf['mysql']['connection'],
                $payment,
                'carrelli'
            );

            // aggiorno la $_SESSION
            $_SESSION['carrello'] = array_replace_recursive(
                $_SESSION['carrello'],
                $payment
            );

            // creo i documenti
            if( isset( $_REQUEST['ck_documento'] ) ) {

                // documento singolo o documento separato per righe
                if( true ) {

                    foreach( $_SESSION['carrello']['articoli'] as $riga ) {

                        // ( fix 2026-09-28 ) era `SELECT * FROM anagrafica_view WHERE id = ?` per usarne
                        // solo la __label__: col segnaposto la condizione non entra nella vista, che si
                        // materializza per intero ( 13 s in produzione su polmasi, per ogni riga del
                        // carrello, 100-300 documenti al giorno ); con l'id scritto 0,02 s. Si resta
                        // sulla vista viva e non sulla statica perche' la __label__ della statica puo'
                        // avere un'altra forma e cambierebbe il nome dei documenti
                        $anagrafica = mysqlSelectLabel(
                            $cf['mysql']['connection'],
                            'anagrafica',
                            '_view',
                            $riga['destinatario_id_anagrafica']
                        );

                        $nome = 'documento creato automaticamente per il carrello #' . $_SESSION['carrello']['id'] . ' anagrafica ' . $anagrafica;
                        $sezionale = 'C/' . date('Y');
                        $emittente = trovaIdAziendaGestita();
                        $numero = generaProssimoNumeroDocumento( $_REQUEST['ck_cassa'], $sezionale, $emittente );

                        $idDocumento = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id_tipologia' => $_REQUEST['ck_cassa'],
                                'nome' => $nome,
                                'numero' => $numero,
                                'sezionale' => $sezionale,
                                'id_emittente' => $emittente,
                                'id_destinatario' => $riga['destinatario_id_anagrafica'],
                                'data' => date('Y-m-d')
                            ),
                            'documenti'
                        );
    
                        // die( $nome . PHP_EOL );

                        // la riga dell'articolo, senza la spedizione, che va in una riga a parte
                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id_documento' => $idDocumento,
                                'id_articolo' => $riga['id_articolo'],
                                'importo_netto_totale' => $riga['prezzo_netto_finale'] - ( $riga['costo_spedizione_netto'] ?? 0 ),
                                'nome' => 'riga automatica da carrello #' . $_SESSION['carrello']['id']
                            ),
                            'documenti_articoli'
                        );

                        // reparto dell'articolo, per l'aliquota della riga di spedizione
                        $idReparto = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT id_reparto FROM articoli WHERE id = ?',
                            array( array( 's' => $riga['id_articolo'] ) )
                        );

                        // spedizione della riga ( politica 'articolo' ) e, sul primo documento, quella dell'ordine ( 'ordine' )
                        $spedizioneNetto = ( $riga['costo_spedizione_netto'] ?? 0 );
                        $spedizioneLordo = ( $riga['costo_spedizione_lordo'] ?? 0 );
                        if( empty( $ct['carrello']['documenti'] ) ) {
                            $spedizioneNetto += ( $_SESSION['carrello']['costo_spedizione_netto'] ?? 0 );
                            $spedizioneLordo += ( $_SESSION['carrello']['costo_spedizione_lordo'] ?? 0 );
                        }
                        aggiungiRigaSpedizioneDocumento( $cf['mysql']['connection'], $idDocumento, $spedizioneNetto, $spedizioneLordo, $idReparto );

                        $ct['carrello']['documenti'][] = $idDocumento;

                    }

                    // die( print_r( $ct['carrello']['documenti'], true ) );

                }

                // die( $_SESSION['carrello']['fatturazione_id_tipologia_documento'] );

            }

        } else {

            // die( 'carrello non presente?' );

        }

    }

    // debug
    // die( print_r( $ct['carrello']['documenti'], true ) );
    // echo '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';
    // echo '<pre>' . print_r( $_REQUEST['__carrello__'], true ) . '</pre>';
    // die();
