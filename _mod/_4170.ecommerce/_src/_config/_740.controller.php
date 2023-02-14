<?php

    /**
     * gestione carrello lato admin
     * 
     * 
     * 
     */

    // TODO verificare che l'utente abbia i privilegi sufficienti per chiudere il carrello
    if( true ) {

        if( isset( $_REQUEST['ck_cassa'] ) && isset( $_SESSION['carrello']['id'] ) ) {

            // debug
            // print_r( $_SESSION['carrello'] );

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

                        $anagrafica = mysqlSelectRow(
                            $cf['mysql']['connection'],
                            'SELECT * FROM anagrafica_view WHERE id = ?',
                            array(
                                array( 's' => $riga['destinatario_id_anagrafica'] )
                            )
                        );

                        $nome = 'documento creato automaticamente per il carrello #' . $_SESSION['carrello']['id'] . ' anagrafica ' . $anagrafica['__label__'];
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

                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id_documento' => $idDocumento,
                                'id_articolo' => $riga['id_articolo'],
                                'importo_netto_totale' => $riga['prezzo_netto_finale'],
                                'nome' => 'riga automatica da carrello #' . $_SESSION['carrello']['id']
                            ),
                            'documenti_articoli'
                        );

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

    // die( print_r( $ct['carrello']['documenti'], true ) );
