<?php

    /**
     * test della vista e della scheda di gestione dei carrelli
     *
     * la vista mostra il cliente ( nome, cognome, e-mail ), l'esito del pagamento e il sito, ed e' ordinata dal
     * carrello piu' recente; la scheda mostra e salva i dati fiscali dell'intestatario e del destinatario, che il
     * front end raccoglie e che fino al 19/10/2026 nel back end non si vedevano
     *
     * i carrelli si riconoscono dal nome dell'intestatario che porta il prefisso TEST-E2E-
     *
     */
    class carrelliFormCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {
            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );
        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {
            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );
        }

        // scrive un carrello confermato, che anche i filtri di default della vista standard mostrano
        protected function carrello( BackendTester $I, $nome, $mail ) {
            return $I->haveInDatabase( 'carrelli', array(
                'intestazione_nome' => $nome,
                'intestazione_cognome' => 'Prova',
                'intestazione_mail' => $mail,
                'intestazione_codice_fiscale' => 'PRVTST80A01H501U',
                'intestazione_partita_iva' => '01234567890',
                'intestazione_pec' => 'test-e2e-carrelli@pec.istricesrl.it',
                'intestazione_sdi' => 'ABC1234',
                'destinatario_codice_fiscale' => 'PRVDST80A41H501X',
                'codice_coupon' => 'TEST-E2E-COUPON',
                'status_pagamento' => 'TEST-E2E-ESITO',
                'timestamp_checkout' => time(),
                'timestamp_inserimento' => time()
            ) );
        }

        // il carrello si trova nella vista cercandolo per e-mail, con le colonne del cliente e del pagamento
        public function vista( BackendTester $I ) {

            $mail = 'test-e2e-carrelli-vista@istricesrl.it';
            $this->carrello( $I, $I->grabTestName( 'carrelli' ), $mail );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'carrelli.view' );

            foreach( array( 'nome', 'cognome', 'e-mail', 'esito', 'sito' ) as $colonna ) {
                $I->see( $colonna, 'thead' );
            }

            $I->fillField( 'input[name$="[__search__]"]', $mail );
            $I->pressKey( 'input[name$="[__search__]"]', \Facebook\WebDriver\WebDriverKeys::ENTER );
            $I->waitForText( $mail, 10 );
            $I->see( 'TEST-E2E-ESITO' );

        }

        // la scheda mostra i dati fiscali e il coupon, e salva una modifica del codice fiscale
        public function scheda( BackendTester $I ) {

            $id = $this->carrello( $I, $I->grabTestName( 'carrelli' ), 'test-e2e-carrelli-scheda@istricesrl.it' );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'carrelli.form', array( 'carrelli' => array( 'id' => $id ) ) );

            $I->seeInField( 'carrelli[intestazione_codice_fiscale]', 'PRVTST80A01H501U' );
            $I->seeInField( 'carrelli[intestazione_partita_iva]', '01234567890' );
            $I->seeInField( 'carrelli[intestazione_pec]', 'test-e2e-carrelli@pec.istricesrl.it' );
            $I->seeInField( 'carrelli[intestazione_sdi]', 'ABC1234' );
            $I->seeInField( 'carrelli[destinatario_codice_fiscale]', 'PRVDST80A41H501X' );
            $I->seeInField( 'carrelli[codice_coupon]', 'TEST-E2E-COUPON' );
            $I->seeElement( '#carrelli_intestazione_id_comune_inputbox' );
            $I->seeElement( '#carrelli_destinatario_id_stato_nascita_inputbox' );

            $I->fillField( 'carrelli[intestazione_codice_fiscale]', 'PRVTST80A01H501Z' );
            // la scheda e' su athena ( Font Awesome 4 ): il pulsante si prende dal suo placeholder, non dall'icona
            $I->click( '#form-carrelli button[placeholder="salva e rimani nella pagina attuale"]' );
            // il clic non aspetta la risposta della POST: senza attesa il database si guarda prima del salvataggio
            $I->wait( 3 );
            $I->seeInDatabase( 'carrelli', array( 'id' => $id, 'intestazione_codice_fiscale' => 'PRVTST80A01H501Z' ) );

        }

    }
