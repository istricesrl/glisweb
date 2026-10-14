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

            // il titolo dice cosa si gestisce, non solo "gestione"
            $I->see( 'gestione anagrafica', 'h1' );

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

        // la stessa scelta fatta da tastiera: ESC chiude la lista, freccia giu' attiva la voce, ENTER la sceglie
        // senza mandare il form ( gh#13 )
        public function tastiera( BackendTester $I ) {

            $denominazione = $I->grabTestName( 'tastiera' );

            $I->amLoggedInAs( 'roots' );

            // anagrafica da scegliere
            $I->amOnPageId( 'anagrafica.form' );
            $I->fillField( 'anagrafica[denominazione]', $denominazione );
            $I->click( '#form-anagrafica button .fa-floppy-disk' );
            $idAnagrafica = $I->grabFromDatabase( 'SELECT id FROM anagrafica WHERE denominazione = ?', array( $denominazione ) );

            // ESC chiude la lista
            $I->amOnPageId( 'anagrafica.archivio.telefoni.form' );
            $I->fillField( '#telefoni_id_anagrafica_inputbox', $denominazione );
            $I->waitForElementVisible( '#telefoni_id_anagrafica_list li[value="' . $idAnagrafica . '"]', 10 );
            $I->pressKey( '#telefoni_id_anagrafica_inputbox', \Facebook\WebDriver\WebDriverKeys::ESCAPE );
            $I->waitForElementNotVisible( '#telefoni_id_anagrafica_list', 5 );

            // la si riapre, freccia giu' attiva l'unica voce ed ENTER la sceglie
            $I->fillField( '#telefoni_id_anagrafica_inputbox', $denominazione );
            $I->waitForElementVisible( '#telefoni_id_anagrafica_list li[value="' . $idAnagrafica . '"]', 10 );
            $I->pressKey( '#telefoni_id_anagrafica_inputbox', \Facebook\WebDriver\WebDriverKeys::ARROW_DOWN );
            $I->seeElement( '#telefoni_id_anagrafica_list li.active[value="' . $idAnagrafica . '"]' );
            $I->pressKey( '#telefoni_id_anagrafica_inputbox', \Facebook\WebDriver\WebDriverKeys::ENTER );
            $I->waitForElementNotVisible( '#telefoni_id_anagrafica_list', 5 );
            $I->seeInField( 'telefoni[id_anagrafica]', (string) $idAnagrafica );

            // ENTER non ha mandato il form: nessun telefono collegato
            $I->dontSeeInDatabase( 'telefoni', array( 'id_anagrafica' => $idAnagrafica ) );

        }

    }
