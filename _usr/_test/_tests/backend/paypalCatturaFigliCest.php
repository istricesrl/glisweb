<?php

    /**
     * test della quadratura fra l'ordine PayPal del "paga insieme" e i pagamenti che la cattura registra
     *
     * l'API dell'ordine ( _mod/_F030.pagamenti/_src/_api/_paypal.advanced.order.php ) scrive sul master la cifra mandata a
     * PayPal e marca i figli aperti con l'ordine; la cattura ( _paypal.advanced.capture.php ) prima di muovere i soldi
     * chiede a verificaFigliOrdinePaypal() ( _src/_lib/_paypal.utils.php ) se i figli marcati e ancora aperti valgono
     * quella cifra, e se no non cattura; su polmasi da settembre al 01/11/2026 nove incassi non tornavano con la
     * registrazione, per 988 EUR ( 640 EUR incassati, 128 registrati, l'ultimo )
     *
     * nessuna chiamata a PayPal: ordine_pagamento e importo_pagamento si scrivono a mano, e il rifiuto della cattura sta
     * prima della restCall; i pagamenti si riconoscono dal prefisso TEST-E2E- nel nome; il "paga insieme" vuole la
     * colonna pagamenti.id_genitore, che lo schema standard non ha ancora: senza, il test si salta
     *
     */

    class paypalCatturaFigliCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->saltaSenzaGenitore( $I );
            $this->pulizia( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulizia( $I );

        }

        // senza pagamenti.id_genitore non c'e' il "paga insieme" e non c'e' niente da provare
        protected function saltaSenzaGenitore( BackendTester $I ) {

            if( ! $I->grabFromDatabase( 'SELECT count(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = ? AND column_name = ?', array( 'pagamenti', 'id_genitore' ) ) ) {
                $I->markTestSkipped( 'pagamenti.id_genitore non presente nello schema' );
            }

        }

        // toglie i pagamenti di test, prima i figli e poi i master
        protected function pulizia( BackendTester $I ) {

            $I->deleteTestRecords( 'pagamenti', 'nome' );

        }

        // un pagamento di test
        protected function pagamento( BackendTester $I, $importo, $riga = array() ) {

            return $I->haveInDatabase( 'pagamenti', array_replace( array(
                'nome' => $I->grabTestName( 'paypal' ),
                'data_scadenza' => date( 'Y-m-d' ),
                'importo_lordo_totale' => $importo,
                'importo_lordo_finale' => $importo
            ), $riga ) );

        }

        // un master con due figli da 10 e 20 EUR, ordine creato per 30 EUR; restituisce ordine, master e figli
        protected function pagaInsieme( BackendTester $I ) {

            $ordine = 'TEST-E2E-' . strtoupper( uniqid() );

            $master = $this->pagamento( $I, 30, array( 'ordine_pagamento' => $ordine, 'importo_pagamento' => 30 ) );
            $primo = $this->pagamento( $I, 10, array( 'id_genitore' => $master, 'ordine_pagamento' => $ordine ) );
            $secondo = $this->pagamento( $I, 20, array( 'id_genitore' => $master, 'ordine_pagamento' => $ordine ) );

            return array( $ordine, $master, $primo, $secondo );

        }

        // figli invariati dall'ordine alla cattura: si cattura, e si registrano tutti e due
        public function figliInvariati( BackendTester $I ) {

            list( $ordine, $master, $primo, $secondo ) = $this->pagaInsieme( $I );

            $verifica = verificaFigliOrdinePaypal( $master, $ordine );

            $I->assertTrue( $verifica['ok'], json_encode( $verifica ) );
            $I->assertEquals( array( $primo, $secondo ), array_column( $verifica['figli'], 'id' ) );

        }

        // un figlio spostato su un altro master dopo l'ordine ( il caso del 01/11 ): niente cattura
        public function figlioSpostato( BackendTester $I ) {

            list( $ordine, $master, $primo, $secondo ) = $this->pagaInsieme( $I );

            $altro = $this->pagamento( $I, 20 );
            $I->updateInDatabase( 'pagamenti', array( 'id' => $secondo, 'id_genitore' => $altro ) );

            $verifica = verificaFigliOrdinePaypal( $master, $ordine );

            $I->assertFalse( $verifica['ok'] );
            $I->assertEquals( 10, round( $verifica['trovato'], 2 ) );

        }

        // un figlio rifatto con un altro importo ( buono applicato dopo l'ordine ): niente cattura
        public function figlioCambiato( BackendTester $I ) {

            list( $ordine, $master, $primo, $secondo ) = $this->pagaInsieme( $I );

            $I->updateInDatabase( 'pagamenti', array( 'id' => $primo, 'importo_lordo_finale' => 5 ) );

            $I->assertFalse( verificaFigliOrdinePaypal( $master, $ordine )['ok'] );

        }

        // un figlio pagato altrove ( in cassa ) fra l'ordine e la cattura: non si riscrive, e la cattura non parte
        public function figlioGiaPagato( BackendTester $I ) {

            list( $ordine, $master, $primo, $secondo ) = $this->pagaInsieme( $I );

            $I->updateInDatabase( 'pagamenti', array( 'id' => $primo, 'timestamp_pagamento' => time() ) );

            $verifica = verificaFigliOrdinePaypal( $master, $ordine );

            $I->assertFalse( $verifica['ok'] );
            $I->assertEquals( array( $secondo ), array_column( $verifica['figli'], 'id' ) );

        }

        // un figlio aggiunto dopo l'ordine non e' stato incassato: non entra nella somma, e non viene registrato
        public function figlioAggiunto( BackendTester $I ) {

            list( $ordine, $master, $primo, $secondo ) = $this->pagaInsieme( $I );

            $terzo = $this->pagamento( $I, 15, array( 'id_genitore' => $master ) );

            $verifica = verificaFigliOrdinePaypal( $master, $ordine );

            $I->assertTrue( $verifica['ok'], json_encode( $verifica ) );
            $I->assertNotContains( $terzo, array_column( $verifica['figli'], 'id' ) );

        }

        // senza figli si confronta l'importo del pagamento di adesso con quello dell'ordine
        public function senzaFigli( BackendTester $I ) {

            $ordine = 'TEST-E2E-' . strtoupper( uniqid() );
            $pagamento = $this->pagamento( $I, 40, array( 'ordine_pagamento' => $ordine, 'importo_pagamento' => 40 ) );

            $I->assertTrue( verificaFigliOrdinePaypal( $pagamento, $ordine )['ok'] );

            $I->updateInDatabase( 'pagamenti', array( 'id' => $pagamento, 'importo_lordo_finale' => 45 ) );

            $I->assertFalse( verificaFigliOrdinePaypal( $pagamento, $ordine )['ok'] );

        }

        // un ordine senza la cifra registrata ( creato prima della verifica ) non si cattura
        public function senzaImportoOrdine( BackendTester $I ) {

            $ordine = 'TEST-E2E-' . strtoupper( uniqid() );
            $pagamento = $this->pagamento( $I, 40, array( 'ordine_pagamento' => $ordine ) );

            $I->assertFalse( verificaFigliOrdinePaypal( $pagamento, $ordine )['ok'] );

        }

        // l'API di cattura trova il master anche se i figli portano lo stesso ordine, rifiuta e lascia tutto com'era
        public function catturaRifiutata( BackendTester $I ) {

            list( $ordine, $master, $primo, $secondo ) = $this->pagaInsieme( $I );

            $altro = $this->pagamento( $I, 20 );
            $I->updateInDatabase( 'pagamenti', array( 'id' => $secondo, 'id_genitore' => $altro ) );

            $I->amOnPage( '/api/F030.pagamenti/paypal.advanced.capture?id=' . $ordine );

            $I->see( 'diverso dai pagamenti da registrare' );
            $I->assertEquals( 1, $I->grabFromDatabase( 'SELECT count(*) FROM pagamenti WHERE id = ?', array( $master ) ), 'il master resta' );
            $I->assertEquals( 0, $I->grabFromDatabase( 'SELECT count(*) FROM pagamenti WHERE id IN ( ?, ? ) AND timestamp_pagamento IS NOT NULL', array( $primo, $secondo ) ), 'nessun figlio pagato' );

        }

    }
