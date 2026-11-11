<?php

    /**
     * test dei form dei veicoli
     *
     * i veicoli sono asset di una tipologia con se_veicoli ( canone, riga 236 ): la maschera delle tipologie le crea
     * in tipologie_asset col flag di classe acceso, la maschera del veicolo scrive su asset, e la vista virtuale
     * veicoli_view li elenca; un asset di una tipologia senza il flag non è un veicolo e nella vista non compare
     *
     */

    class veicoliFormCest {

        // pulizia prima del test, per i record rimasti da giri interrotti; gli asset vanno tolti per primi, perché
        // la tipologia dice cos'è la riga e non si cancella finché un asset la usa
        public function _before( BackendTester $I ) {
            $I->deleteTestRecords( 'asset', 'nome' );
            $I->deleteTestRecords( 'tipologie_asset', 'nome' );
        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {
            $I->deleteTestRecords( 'asset', 'nome' );
            $I->deleteTestRecords( 'tipologie_asset', 'nome' );
        }

        // la tipologia creata dal modulo nasce nel ramo dei veicoli
        public function tipologia( BackendTester $I ) {
            $nome = $I->grabTestName( 'tipologia' );
            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'logistica.tipologie.veicoli.form' );
            $I->fillField( 'tipologie_asset[nome]', $nome );
            $I->click( '#form-tipologie_asset button .fa-floppy-disk' );
            $I->seeInDatabase( 'tipologie_asset', array( 'nome' => $nome, 'se_veicoli' => 1 ) );
        }

        // il veicolo si scrive su asset e si ritrova nella vista virtuale; un asset fuori dal ramo dei veicoli no
        public function veicolo( BackendTester $I ) {
            $tipologia = $I->grabTestName( 'tipologia' );
            $nome = $I->grabTestName( 'veicolo' );
            $altro = $I->grabTestName( 'altro' );
            $I->amLoggedInAs( 'roots' );
            // tipologia dei veicoli, dalla maschera del modulo
            $I->amOnPageId( 'logistica.tipologie.veicoli.form' );
            $I->fillField( 'tipologie_asset[nome]', $tipologia );
            $I->click( '#form-tipologie_asset button .fa-floppy-disk' );
            $idTipologia = $I->grabFromDatabase( 'SELECT id FROM tipologie_asset WHERE nome = ?', array( $tipologia ) );
            // veicolo
            $I->amOnPageId( 'logistica.veicoli.form' );
            $I->selectOption( 'asset[id_tipologia]', (string) $idTipologia );
            $I->fillField( 'asset[codice]', 'MUL-TEST' );
            $I->fillField( 'asset[nome]', $nome );
            $I->click( '#form-asset button .fa-floppy-disk' );
            $I->seeInDatabase( 'asset', array( 'nome' => $nome, 'id_tipologia' => $idTipologia, 'codice' => 'MUL-TEST' ) );
            $I->seeInDatabase( 'veicoli_view', array( 'nome' => $nome ) );
            // un asset di una tipologia senza se_veicoli non compare fra i veicoli
            $idAltra = $I->haveInDatabase( 'tipologie_asset', array( 'nome' => $altro ) );
            $I->haveInDatabase( 'asset', array( 'nome' => $altro, 'id_tipologia' => $idAltra ) );
            $I->dontSeeInDatabase( 'veicoli_view', array( 'nome' => $altro ) );
            // e il veicolo si ritrova cercandolo nell'elenco
            $I->amOnPageId( 'logistica.veicoli.view' );
            $I->fillField( 'input[name$="[__search__]"]', $nome );
            $I->pressKey( 'input[name$="[__search__]"]', \Facebook\WebDriver\WebDriverKeys::ENTER );
            $I->waitForText( $nome, 10 );
        }

    }
