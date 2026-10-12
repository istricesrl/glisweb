<?php

    /**
     * test dei consensi del carrello
     *
     * fino al 2026-10-12 il controller del carrello registrava i consensi di __consensi__[__carrello__] prima di creare
     * il carrello ( STEP 2 ), quindi sulla prima richiesta la riga di carrelli_consensi restava senza id_carrello; ora
     * li registra dopo ( STEP 3.3 ) e il consenso arrivato insieme alla richiesta che crea il carrello deve essere legato
     * a quel carrello; i carrelli si riconoscono dal nome dell'intestatario che porta il prefisso TEST-E2E-, e i consensi
     * se ne vanno con loro ( ON DELETE CASCADE )
     *
     */

    class carrelloConsensiCest {

        // pulizia prima del test
        public function _before( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // pulizia dopo il test
        public function _after( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // il consenso inviato con la richiesta che crea il carrello è legato al carrello
        public function consensoSulCarrelloNuovo( FrontendTester $I ) {

            $nome = $I->grabTestName( 'consensi' );

            $I->amOnPage( '/?' . http_build_query( array(
                '__carrello__' => array( 'intestazione_nome' => $nome ),
                '__consensi__' => array( '__carrello__' => array( 'PRIVACY_POLICY' => array( 'value' => 1 ) ) )
            ) ) );

            $id = $I->grabFromDatabase( 'SELECT id FROM carrelli WHERE intestazione_nome = ?', array( $nome ) );
            if( empty( $id ) ) {
                $I->fail( 'carrello ' . $nome . ' non creato, vedi var/log/cart' );
            }

            $idConsenso = $I->grabFromDatabase( 'SELECT id FROM consensi WHERE codice = ?', array( 'PRIVACY_POLICY' ) );

            $I->seeInDatabase( 'carrelli_consensi', array( 'id_carrello' => $id, 'id_consenso' => $idConsenso, 'se_prestato' => 1 ) );

        }

    }
