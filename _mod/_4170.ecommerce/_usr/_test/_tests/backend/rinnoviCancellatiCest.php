<?php

    /**
     * test delle righe di carrello rimaste in sessione dopo una cancellazione nel database
     *
     * lo STEP 5 di _750.controller.php riscrive a ogni richiesta tutte le righe di $_SESSION['carrello']['articoli']:
     * se nel frattempo è stato cancellato il rinnovo di una riga ( la FK mette a NULL id_rinnovo nel database, la
     * sessione no ) o il carrello stesso, la riscrittura falliva con un 1452 e la riga restava a carrello a far pagare
     * una quota che non esisteva più ( polmasi, 27/10/2026 ); gli STEP 0.1 e 0.2 tolgono di mezzo il carrello e le
     * righe orfane, salvo le righe con denaro incassato o documento emesso, che restano senza il rinnovo
     *
     * le pagine si aprono da roots; contratti e anagrafiche si riconoscono dal prefisso TEST-E2E- nel nome
     *
     */

    class rinnoviCancellatiCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulizia( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulizia( $I );

        }

        // toglie carrelli, contratti e anagrafiche di test, coi rinnovi e le righe
        protected function pulizia( BackendTester $I ) {

            global $cf;

            // i carrelli si raccolgono prima: le righe se ne vanno in CASCADE col carrello
            $carrelli = mysqlSelectColumn( 'id_carrello', $cf['mysql']['connection'], 'SELECT DISTINCT carrelli_articoli.id_carrello FROM carrelli_articoli INNER JOIN anagrafica ON anagrafica.id = carrelli_articoli.destinatario_id_anagrafica WHERE anagrafica.nome LIKE ?', array( array( 's' => 'TEST-E2E-%' ) ) );
            foreach( (array) $carrelli as $carrello ) {
                mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM carrelli WHERE id = ?', array( array( 's' => $carrello ) ) );
            }
            mysqlQuery( $cf['mysql']['connection'], 'DELETE rinnovi FROM rinnovi INNER JOIN contratti ON contratti.id = rinnovi.id_contratto WHERE contratti.nome LIKE ?', array( array( 's' => 'TEST-E2E-%' ) ) );
            $I->deleteTestRecords( 'contratti', 'nome' );
            $I->deleteTestRecords( 'anagrafica', 'nome' );

        }

        // una persona di test con un contratto e il suo rinnovo; restituisce persona, rinnovo e articolo
        protected function rinnovo( BackendTester $I ) {

            $anagrafica = $I->haveInDatabase( 'anagrafica', array(
                'nome' => $I->grabTestName( 'socio' ),
                'cognome' => 'Carrello',
                'timestamp_inserimento' => time()
            ) );

            $contratto = $I->haveInDatabase( 'contratti', array(
                'nome' => $I->grabTestName( 'contratto' ),
                'timestamp_inserimento' => time()
            ) );

            $articolo = $I->grabFromDatabase( 'SELECT id FROM articoli ORDER BY id DESC LIMIT 1' );
            $I->assertNotEmpty( $articolo, 'articolo da mettere a carrello' );

            $rinnovo = $I->haveInDatabase( 'rinnovi', array(
                'id_contratto' => $contratto,
                'data_inizio' => date( 'Y-m-d' ),
                'data_fine' => date( 'Y-m-d', strtotime( '+30 days' ) )
            ) );

            return array( $anagrafica, $rinnovo, $articolo );

        }

        // mette a carrello la quota del rinnovo
        protected function carrello( BackendTester $I, $anagrafica, $rinnovo, $articolo ) {

            $I->amOnPageId( 'ecommerce.carrello', array(
                '__carrello__' => array(
                    '__articolo__' => array(
                        'quantita' => 1,
                        'id_iva' => $I->grabFromDatabase( 'SELECT id FROM iva ORDER BY id LIMIT 1' ),
                        'id_articolo' => $articolo,
                        'destinatario_id_anagrafica' => $anagrafica,
                        'id_rinnovo' => $rinnovo
                    )
                )
            ) );

        }

        // righe di carrello del rinnovo
        protected function righe( BackendTester $I, $rinnovo ) {

            return (int) $I->grabFromDatabase( 'SELECT count(*) FROM carrelli_articoli WHERE id_rinnovo = ?', array( $rinnovo ) );

        }

        // la riga il cui rinnovo è stato cancellato mentre era a carrello si toglie, e le altre si scrivono
        public function rinnovoCancellatoTolto( BackendTester $I ) {

            global $cf;

            list( $anagrafica, $rinnovo, $articolo ) = $this->rinnovo( $I );
            list( $anagrafica2, $rinnovo2, $articolo2 ) = $this->rinnovo( $I );

            $I->amLoggedInAs( 'roots' );
            $this->carrello( $I, $anagrafica, $rinnovo, $articolo );
            $riga = $I->grabFromDatabase( 'SELECT id FROM carrelli_articoli WHERE id_rinnovo = ?', array( $rinnovo ) );
            $I->assertNotEmpty( $riga, 'riga di carrello del rinnovo' );

            // un altro operatore cancella il rinnovo: la FK mette a NULL id_rinnovo sulla riga, la sessione no
            mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM rinnovi WHERE id = ?', array( array( 's' => $rinnovo ) ) );

            // la richiesta successiva riscrive le righe di sessione
            $this->carrello( $I, $anagrafica2, $rinnovo2, $articolo2 );

            $I->assertEquals( 0, (int) $I->grabFromDatabase( 'SELECT count(*) FROM carrelli_articoli WHERE id = ?', array( $riga ) ), 'riga del rinnovo cancellato' );
            $I->assertEquals( 1, $this->righe( $I, $rinnovo2 ), 'righe di carrello dell\'altra quota' );

        }

        // la riga già incassata resta anche se il rinnovo è stato cancellato
        public function rinnovoCancellatoIncassatoResta( BackendTester $I ) {

            global $cf;

            list( $anagrafica, $rinnovo, $articolo ) = $this->rinnovo( $I );
            list( $anagrafica2, $rinnovo2, $articolo2 ) = $this->rinnovo( $I );

            $I->amLoggedInAs( 'roots' );
            $this->carrello( $I, $anagrafica, $rinnovo, $articolo );
            $riga = $I->grabFromDatabase( 'SELECT id FROM carrelli_articoli WHERE id_rinnovo = ?', array( $rinnovo ) );
            $carrello = $I->grabFromDatabase( 'SELECT id_carrello FROM carrelli_articoli WHERE id = ?', array( $riga ) );

            $I->haveInDatabase( 'pagamenti', array(
                'id_carrello' => $carrello,
                'id_carrelli_articoli' => $riga,
                'importo_lordo_finale' => 10,
                'timestamp_pagamento' => time()
            ) );

            mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM rinnovi WHERE id = ?', array( array( 's' => $rinnovo ) ) );

            $this->carrello( $I, $anagrafica2, $rinnovo2, $articolo2 );

            $I->assertEquals( 1, (int) $I->grabFromDatabase( 'SELECT count(*) FROM carrelli_articoli WHERE id = ?', array( $riga ) ), 'riga incassata del rinnovo cancellato' );
            $I->assertEquals( 1, $this->righe( $I, $rinnovo2 ), 'righe di carrello dell\'altra quota' );

        }

        // il carrello di sessione cancellato nel database si stacca, e la richiesta dopo ne apre uno nuovo
        public function carrelloCancellatoStaccato( BackendTester $I ) {

            global $cf;

            list( $anagrafica, $rinnovo, $articolo ) = $this->rinnovo( $I );
            list( $anagrafica2, $rinnovo2, $articolo2 ) = $this->rinnovo( $I );

            $I->amLoggedInAs( 'roots' );
            $this->carrello( $I, $anagrafica, $rinnovo, $articolo );
            $carrello = $I->grabFromDatabase( 'SELECT id_carrello FROM carrelli_articoli WHERE id_rinnovo = ?', array( $rinnovo ) );
            $I->assertNotEmpty( $carrello, 'carrello della sessione' );

            // il carrello viene cancellato dall'elenco o dalla pulizia dei carrelli abbandonati
            mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM carrelli WHERE id = ?', array( array( 's' => $carrello ) ) );

            $this->carrello( $I, $anagrafica2, $rinnovo2, $articolo2 );

            $nuovo = $I->grabFromDatabase( 'SELECT id_carrello FROM carrelli_articoli WHERE id_rinnovo = ?', array( $rinnovo2 ) );
            $I->assertNotEmpty( $nuovo, 'carrello nuovo con l\'altra quota' );
            $I->assertNotEquals( $carrello, $nuovo, 'il carrello nuovo non è quello cancellato' );

        }

    }
