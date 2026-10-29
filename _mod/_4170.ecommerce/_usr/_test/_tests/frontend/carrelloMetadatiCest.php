<?php

    /**
     * test dei metadati del carrello
     *
     * dal 2026-10-12 il controller del carrello registra in metadati i valori di __carrello__[__metadati__], ma solo
     * quelli dichiarati in $cf['ecommerce']['fields']['metadati']: lo standard non ne dichiara nessuno, quindi un
     * metadato inventato dalla richiesta non deve finire nel database; i carrelli si riconoscono dal nome
     * dell'intestatario che porta il prefisso TEST-E2E-, e i metadati se ne vanno con loro ( ON DELETE CASCADE )
     *
     */

    class carrelloMetadatiCest {

        // pulizia prima del test
        public function _before( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // pulizia dopo il test
        public function _after( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // un metadato non dichiarato non viene scritto
        public function metadatoNonDichiaratoIgnorato( FrontendTester $I ) {

            $nome = $I->grabTestName( 'metadati' );
            $metadato = $I->grabTestName( 'non_dichiarato' );

            // la pagina del carrello e non la home: dove / e' rediretta il redirect arriva prima dei controller del carrello
            $I->amOnPageId( 'carrello', array( '__carrello__' => array(
                'intestazione_nome' => $nome,
                '__metadati__' => array( $metadato => 'valore' )
            ) ) );

            $id = $I->grabFromDatabase( 'SELECT id FROM carrelli WHERE intestazione_nome = ?', array( $nome ) );
            if( empty( $id ) ) {
                $I->fail( 'carrello ' . $nome . ' non creato, vedi var/log/test/cart' );
            }

            $I->dontSeeInDatabase( 'metadati', array( 'id_carrello' => $id, 'nome' => $metadato ) );

        }

    }
