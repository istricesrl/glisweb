<?php

    /**
     * test dell'importo dell'ordine PayPal del carrello e della sua verifica alla cattura
     *
     * l'API dell'ordine ( _mod/_4170.ecommerce/_src/_api/_paypal.advanced.order.php ) manda a PayPal quello che il
     * carrello vale nel database ( importoOrdineCarrello(), _src/_lib/_mysql.tools.add.php del modulo ) e lo scrive in
     * carrelli.importo_pagamento; la cattura ( _paypal.advanced.capture.php ), prima di muovere i soldi, chiede a
     * verificaImportoOrdineCarrello() se il carrello vale ancora quella cifra, e se no non cattura; fino al 05/11/2026
     * l'ordine partiva con la testata in sessione, e su polmasi dal 01/09 circa 30 catture non tornavano con le ricevute
     *
     * nessuna chiamata a PayPal: ordine_pagamento e importo_pagamento si scrivono a mano; la cattura vera vuole il
     * carrello in sessione, e qui si prova la funzione che decide; i carrelli si riconoscono dal prefisso TEST-E2E-
     * nel nome dell'intestatario
     *
     */

    class paypalOrdineImportoRigheCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulizia( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulizia( $I );

        }

        // toglie i carrelli di test, prima le righe
        protected function pulizia( BackendTester $I ) {

            global $cf;

            mysqlQuery( $cf['mysql']['connection'], 'DELETE carrelli_articoli FROM carrelli_articoli INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello WHERE carrelli.intestazione_nome LIKE ?', array( array( 's' => 'TEST-E2E-%' ) ) );
            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // un carrello di test con le sue righe; restituisce l'id del carrello e quelli delle righe
        protected function carrello( BackendTester $I, $testata, $righe, $carrello = array() ) {

            $id = $I->haveInDatabase( 'carrelli', array_replace( array(
                'intestazione_nome' => $I->grabTestName( 'paypal' ),
                'prezzo_lordo_finale' => $testata
            ), $carrello ) );

            $ids = array();
            foreach( $righe as $prezzo ) {
                $ids[] = $I->haveInDatabase( 'carrelli_articoli', array( 'id_carrello' => $id, 'quantita' => 1, 'prezzo_lordo_finale' => $prezzo ) );
            }

            return array( $id, $ids );

        }

        // (a) la testata dice 50, le righe 10 + 20: l'ordine vale le righe
        public function testataDiversaDalleRighe( BackendTester $I ) {

            global $cf;

            list( $id ) = $this->carrello( $I, 50, array( 10, 20 ) );

            $I->assertEquals( 30, importoOrdineCarrello( $cf['mysql']['connection'], $id ) );

        }

        // il coupon si toglie dalla testata e la spedizione d'ordine si aggiunge; il prezzo 0 salvato NULL vale zero
        public function couponSpedizioneEPrezzoNull( BackendTester $I ) {

            global $cf;

            list( $id ) = $this->carrello( $I, 0, array( 10, 20, NULL ), array( 'sconto_valore_coupon' => 5, 'costo_spedizione_lordo' => 7 ) );

            $I->assertEquals( 32, importoOrdineCarrello( $cf['mysql']['connection'], $id ) );

        }

        // un carrello che non esiste non ha importo
        public function carrelloInesistente( BackendTester $I ) {

            global $cf;

            $I->assertFalse( importoOrdineCarrello( $cf['mysql']['connection'], -1 ) );

        }

        // (c) righe invariate dall'ordine alla cattura: si cattura
        public function righeInvariate( BackendTester $I ) {

            global $cf;

            $ordine = 'TEST-E2E-' . strtoupper( uniqid() );
            list( $id ) = $this->carrello( $I, 30, array( 10, 20 ), array( 'ordine_pagamento' => $ordine, 'importo_pagamento' => 30 ) );

            $verifica = verificaImportoOrdineCarrello( $cf['mysql']['connection'], $id, $ordine );

            $I->assertTrue( $verifica['ok'], json_encode( $verifica ) );

        }

        // (b) una riga cambiata dopo l'ordine: niente cattura
        public function rigaCambiata( BackendTester $I ) {

            global $cf;

            $ordine = 'TEST-E2E-' . strtoupper( uniqid() );
            list( $id, $righe ) = $this->carrello( $I, 30, array( 10, 20 ), array( 'ordine_pagamento' => $ordine, 'importo_pagamento' => 30 ) );

            $I->updateInDatabase( 'carrelli_articoli', array( 'id' => $righe[0], 'prezzo_lordo_finale' => 15 ) );

            $verifica = verificaImportoOrdineCarrello( $cf['mysql']['connection'], $id, $ordine );

            $I->assertFalse( $verifica['ok'] );
            $I->assertEquals( 35, $verifica['trovato'] );

        }

        // una riga entrata fuori sessione dopo l'ordine: niente cattura
        public function rigaAggiunta( BackendTester $I ) {

            global $cf;

            $ordine = 'TEST-E2E-' . strtoupper( uniqid() );
            list( $id ) = $this->carrello( $I, 30, array( 10, 20 ), array( 'ordine_pagamento' => $ordine, 'importo_pagamento' => 30 ) );

            $I->haveInDatabase( 'carrelli_articoli', array( 'id_carrello' => $id, 'quantita' => 1, 'prezzo_lordo_finale' => 12 ) );

            $I->assertFalse( verificaImportoOrdineCarrello( $cf['mysql']['connection'], $id, $ordine )['ok'] );

        }

        // un ordine che non è quello del carrello, o creato prima della verifica ( senza importo ), non si cattura
        public function ordineAltroOSenzaImporto( BackendTester $I ) {

            global $cf;

            $ordine = 'TEST-E2E-' . strtoupper( uniqid() );
            list( $id ) = $this->carrello( $I, 30, array( 10, 20 ), array( 'ordine_pagamento' => $ordine, 'importo_pagamento' => 30 ) );
            $I->assertFalse( verificaImportoOrdineCarrello( $cf['mysql']['connection'], $id, $ordine . 'X' )['ok'] );

            list( $vecchio ) = $this->carrello( $I, 30, array( 10, 20 ), array( 'ordine_pagamento' => $ordine . 'V' ) );
            $I->assertFalse( verificaImportoOrdineCarrello( $cf['mysql']['connection'], $vecchio, $ordine . 'V' )['ok'] );

        }

    }
