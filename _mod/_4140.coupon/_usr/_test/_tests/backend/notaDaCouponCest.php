<?php

    /**
     * test del task nota.da.coupon sul consumo del coupon
     *
     * il task rimborsa il residuo di un coupon con una nota di credito e un pagamento legato al coupon; fino al
     * 2026-10-13 il pagamento non valorizzava `coupon_valore`, e siccome tutte le query del residuo ( coupon_view,
     * cassa, app ) sommano solo quel campo, il coupon rimborsato restava scalabile per intero nelle iscrizioni
     *
     *
     * il coupon e l'intestatario si scrivono nel database, il task si chiama via HTTP da root; il coupon si
     * riconosce dal codice e nota di credito e pagamento dal nome, che contengono il prefisso TEST-E2E-
     *
     */

    class notaDaCouponCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // toglie pagamenti, note di credito, coupon e anagrafiche di test, in quest'ordine per le chiavi esterne
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'pagamenti', 'nome', true );
            $I->deleteTestRecords( 'documenti', 'nome', true );
            $I->deleteTestRecords( 'coupon', 'codice' );
            $I->deleteTestRecords( 'anagrafica', 'nome' );

        }

        // dopo la nota di credito il coupon non ha piu' residuo
        public function rimborsoConsumaCoupon( BackendTester $I ) {

            $codice = substr( $I->grabTestName( 'cpn' ), 0, 32 );

            $anagrafica = $I->haveInDatabase( 'anagrafica', array(
                'nome' => $I->grabTestName( 'socio' ),
                'cognome' => 'rimborso coupon'
            ) );

            $coupon = $I->haveInDatabase( 'coupon', array(
                'codice' => $codice,
                'nome' => $codice,
                'id_anagrafica' => $anagrafica,
                'sconto_fisso' => 50
            ) );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/task/4140.coupon/nota.da.coupon?coupon=' . $coupon );

            $I->seeInDatabase( 'pagamenti', array( 'id_coupon' => $coupon, 'coupon_valore' => 50 ) );

            $residuo = $I->grabFromDatabase( 'SELECT coupon_residuo FROM coupon_view WHERE id = ?', array( $coupon ) );
            $I->assertEquals( 0, (float) $residuo, 'coupon rimborsato con nota di credito ancora spendibile' );

        }

    }
