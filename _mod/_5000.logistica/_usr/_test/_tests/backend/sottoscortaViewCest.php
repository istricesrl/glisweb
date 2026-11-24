<?php

    /**
     * test della vista del sottoscorta
     *
     * la vista legge __report_sottoscorta__, che il task /task/0500.mastri/rifornimenti.da.sottoscorta riscrive a ogni
     * giro; dal 24/11/2026 il report porta anche codice_articolo, e la colonna "articolo" della vista mostra il codice
     * e non l'id: l'id non coincide col codice e all'operatore non dice niente
     *
     * il task non si lancia, perché crea missioni di rifornimento vere nel database del deploy: la riga del report si
     * scrive a mano, col prefisso di test nell'id e nel codice, e si toglie in _before() e _after()
     *
     */

    class sottoscortaViewCest {

        // pulizia prima del test, per i resti di un giro interrotto
        public function _before( BackendTester $I ) {
            $I->deleteTestRecords( '__report_sottoscorta__', 'id' );
        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {
            $I->deleteTestRecords( '__report_sottoscorta__', 'id' );
        }

        public function codiceAlPostoDellId( BackendTester $I ) {

            // un articolo vero, in sola lettura, e un codice di test riconoscibile nella pagina
            $idArticolo = $I->grabFromDatabase( 'SELECT id FROM articoli ORDER BY id LIMIT 1' );
            $codice = $I->grabTestName( 'sc' );
            $I->haveInDatabase( '__report_sottoscorta__', array(
                'id' => $I->grabTestName( 'r' ),
                'id_articolo' => $idArticolo,
                'codice_articolo' => $codice,
                'articolo' => 'articolo di test',
                'collocazione' => 'TEST',
                'se_allarme' => 1,
                'esito' => 'non rifornibile',
                'timestamp_aggiornamento' => time(),
                '__label__' => $codice
            ) );

            // la vista mostra il codice ( il filtro di default è se_allarme = 1 ); la riga si cerca, perché fra le
            // ubicazioni vere in allarme potrebbe non cadere nella prima pagina
            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'logistica.sottoscorta.view' );
            $I->see( 'articolo', 'thead' );
            $I->fillField( 'input[name$="[__search__]"]', $codice );
            $I->pressKey( 'input[name$="[__search__]"]', \Facebook\WebDriver\WebDriverKeys::ENTER );
            $I->waitForText( $codice, 10 );
            $I->see( 'articolo di test' );

        }

    }
