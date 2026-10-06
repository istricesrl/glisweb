<?php

    /**
     * test del form dell'anagrafica
     *
     * inserisce un'anagrafica dal form, la ritrova nella vista e nel database, poi le collega un numero di
     * telefono dal form dei telefoni, scegliendo l'anagrafica con la tendina intelligente
     *
     */

    class anagraficaFormCest {

        // pulizia prima del test, per i record rimasti da giri interrotti; i telefoni vanno tolti per primi,
        // perche' cancellando l'anagrafica il loro id_anagrafica diventa NULL e resterebbero orfani
        public function _before( BackendTester $I ) {

            $I->deleteTestRecords( 'telefoni', 'note' );
            $I->deleteTestRecords( 'anagrafica', 'denominazione' );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $I->deleteTestRecords( 'telefoni', 'note' );
            $I->deleteTestRecords( 'anagrafica', 'denominazione' );

        }

        // inserimento di un'anagrafica e controllo nella vista
        public function inserimento( BackendTester $I ) {

            $denominazione = $I->grabTestName( 'anagrafica' );

            $I->amLoggedInAs( 'roots' );

            // compilazione e salvataggio del form
            $I->amOnPageId( 'anagrafica.form' );
            $I->fillField( 'anagrafica[denominazione]', $denominazione );
            $I->fillField( 'anagrafica[note]', 'inserita dal test automatico' );
            $I->click( '#form-anagrafica button .fa-floppy-disk' );

            // il record e' nel database
            $I->seeInDatabase( 'anagrafica', array( 'denominazione' => $denominazione ) );

            // e si ritrova cercandolo nella vista
            $I->amOnPageId( 'anagrafica.view' );
            $I->fillField( 'input[name$="[__search__]"]', $denominazione );
            $I->pressKey( 'input[name$="[__search__]"]', \Facebook\WebDriver\WebDriverKeys::ENTER );
            $I->waitForText( $denominazione, 10 );

        }

        // collegamento di un telefono all'anagrafica, scelta con la tendina intelligente
        public function telefono( BackendTester $I ) {

            $denominazione = $I->grabTestName( 'telefono' );
            $numero = '0' . mt_rand( 100000000, 999999999 );

            $I->amLoggedInAs( 'roots' );

            // anagrafica a cui collegare il telefono
            $I->amOnPageId( 'anagrafica.form' );
            $I->fillField( 'anagrafica[denominazione]', $denominazione );
            $I->click( '#form-anagrafica button .fa-floppy-disk' );
            $idAnagrafica = $I->grabFromDatabase( 'SELECT id FROM anagrafica WHERE denominazione = ?', array( $denominazione ) );

            // la tendina intelligente cerca dopo tre caratteri e mostra i risultati in una lista
            $I->amOnPageId( 'anagrafica.archivio.telefoni.form' );
            $I->fillField( '#telefoni_id_anagrafica_inputbox', $denominazione );
            $I->waitForElementVisible( '#telefoni_id_anagrafica_list li[value="' . $idAnagrafica . '"]', 10 );
            $I->click( '#telefoni_id_anagrafica_list li[value="' . $idAnagrafica . '"]' );
            $I->seeInField( 'telefoni[id_anagrafica]', (string) $idAnagrafica );

            // salvataggio
            $I->fillField( 'telefoni[numero]', $numero );
            $I->fillField( 'telefoni[note]', $I->grabTestName( 'telefono' ) );
            $I->click( '#form-telefoni button .fa-floppy-disk' );
            $I->seeInDatabase( 'telefoni', array( 'id_anagrafica' => $idAnagrafica, 'numero' => $numero ) );

        }

    }
