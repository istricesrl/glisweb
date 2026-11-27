<?php

    /**
     * test della legenda «aggiornato» delle schede
     *
     * dal 2026-11-04 ( rilievi Lughese del 30/10 ) una scheda il cui record non ha timestamp_aggiornamento non
     * mostra piu' l'ora corrente come data dell'ultimo aggiornamento: |date di Twig su un valore vuoto restituisce
     * adesso. La guardia sta in tutti i template athena della generazione vecchia; il test la verifica sulla scheda
     * dei documenti, la piu' usata, e sul caso con la data
     *
     */

    class aggiornatoSenzaDataCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {
            $I->deleteTestRecords( 'documenti', 'nome' );
        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {
            $I->deleteTestRecords( 'documenti', 'nome' );
        }

        // senza data di aggiornamento la legenda lo dice, e non mostra l'ora corrente
        public function senzaData( BackendTester $I ) {
            $documento = $I->haveInDatabase( 'documenti', array(
                'nome' => $I->grabTestName( 'documento' )
            ) );
            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'documenti.form', array( 'documenti' => array( 'id' => $documento ) ) );
            $I->see( 'data di aggiornamento non registrata' );
            $I->dontSee( 'aggiornato ' . date( 'Y/m/d' ) );
        }

        // con la data di aggiornamento la legenda la mostra come prima
        public function conData( BackendTester $I ) {
            $documento = $I->haveInDatabase( 'documenti', array(
                'nome' => $I->grabTestName( 'documento' ),
                'timestamp_aggiornamento' => 1704067200
            ) );
            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'documenti.form', array( 'documenti' => array( 'id' => $documento ) ) );
            $I->see( 'aggiornato ' . date( 'Y/m/d H:i:s', 1704067200 ) );
            $I->dontSee( 'data di aggiornamento non registrata' );
        }

    }
