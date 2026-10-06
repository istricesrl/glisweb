<?php

    /**
     * test della gestione di account e gruppi
     *
     * inserisce un account dal form assegnandogli un gruppo dal subform, controlla che la password finisca nel
     * database come hash e che salvando senza password l'hash resti quello di prima, verifica che il gruppo
     * assegnato dal form dia davvero i permessi ( l'account entra dal form di login e apre le maschere riservate
     * a roots ) e che un gruppo diverso li neghi; infine inserisce un gruppo, lo ritrova nella vista e lo elimina
     * passando dalla pagina di conferma
     *
     */

    class accountCest {

        // pulizia prima del test, per i record rimasti da giri interrotti; le righe di account_gruppi se ne
        // vanno in cascata con l'account
        public function _before( BackendTester $I ) {

            $I->deleteTestRecords( 'account', 'username' );
            $I->deleteTestRecords( 'gruppi', 'nome' );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $I->deleteTestRecords( 'account', 'username' );
            $I->deleteTestRecords( 'gruppi', 'nome' );

        }

        // inserimento di un account con un gruppo e controllo nella vista
        public function inserimento( BackendTester $I ) {

            $username = $I->grabTestName( 'account' );
            $password = bin2hex( random_bytes( 8 ) );

            $I->amLoggedInAs( 'roots' );

            $idAccount = $this->inserisciAccount( $I, $username, $password, 'roots' );

            // la password e' salvata come hash, non in chiaro
            $hash = $I->grabFromDatabase( 'SELECT password FROM account WHERE id = ?', array( $idAccount ) );
            $I->assertNotEquals( $password, $hash, 'la password e\' stata salvata in chiaro' );
            $I->assertTrue( passwordVerify( $password, $hash ), 'l\'hash salvato non corrisponde alla password' );

            // e si ritrova cercandolo nella vista
            $I->amOnPageId( 'account.view' );
            $I->fillField( 'input[name$="[__search__]"]', $username );
            $I->pressKey( 'input[name$="[__search__]"]', \Facebook\WebDriver\WebDriverKeys::ENTER );
            $I->waitForText( $username, 10 );

        }

        // salvando il form con la password vuota l'hash resta quello di prima
        public function modificaSenzaPassword( BackendTester $I ) {

            $username = $I->grabTestName( 'modifica' );
            $hash = passwordHash( bin2hex( random_bytes( 8 ) ) );

            $idAccount = $I->haveInDatabase( 'account', array( 'username' => $username, 'password' => $hash, 'se_attivo' => 1, 'timestamp_inserimento' => time() ) );

            $I->amLoggedInAs( 'roots' );

            // il campo password si presenta vuoto, anche se l'account ce l'ha
            $I->amOnPageId( 'account.form', array( 'account' => array( 'id' => $idAccount ) ) );
            $I->seeInField( 'account[password]', '' );

            // si cambia lo username e si salva senza toccare la password
            $I->fillField( 'account[username]', $username . '-bis' );
            $I->click( '#form-account button .fa-floppy-disk' );

            $I->seeInDatabase( 'account', array( 'id' => $idAccount, 'username' => $username . '-bis', 'password' => $hash ) );

        }

        // il gruppo assegnato dal form da' i permessi, e un altro gruppo li nega
        public function permessiDelGruppo( BackendTester $I ) {

            $username = $I->grabTestName( 'permessi' );
            $password = bin2hex( random_bytes( 8 ) );

            // account creato da roots e assegnato al gruppo roots
            $I->amLoggedInAs( 'roots' );
            $this->inserisciAccount( $I, $username, $password, 'roots' );

            // si esce, e si rientra dal form con l'account appena creato
            $I->amOnPage( '/admin.it-IT.html?__logout__=1' );
            $I->deleteSessionSnapshot( 'test-roots' );
            $this->loginForm( $I, $username, $password, 'account.view' );

            // la vista degli account, riservata a roots, si apre
            $I->amOnPageId( 'account.view' );
            $I->dontSeeElement( '#formLogin' );

            // un account del gruppo users entra, ma il form degli account gli resta negato
            $users = $I->grabTestAccount( 'users' );
            $I->amOnPage( '/admin.it-IT.html?__logout__=1' );
            $this->loginForm( $I, $users['username'], $users['password'], 'app' );
            $I->amOnPageId( 'app' );
            $I->dontSeeElement( '#formLogin' );
            $I->amOnPageId( 'account.form' );
            $I->seeElement( '#formLogin' );

        }

        // inserimento di un gruppo, controllo nella vista ed eliminazione
        public function gruppo( BackendTester $I ) {

            $nome = $I->grabTestName( 'gruppo' );
            $idGenitore = $I->grabFromDatabase( 'SELECT id FROM gruppi WHERE nome = ?', array( 'users' ) );

            $I->amLoggedInAs( 'roots' );

            // compilazione e salvataggio del form
            $I->amOnPageId( 'gruppi.form' );
            $I->selectOption( 'gruppi[id_genitore]', (string) $idGenitore );
            $I->fillField( 'gruppi[nome]', $nome );
            $I->click( '#form-gruppi button .fa-floppy-disk' );

            $I->seeInDatabase( 'gruppi', array( 'nome' => $nome, 'id_genitore' => $idGenitore ) );
            $idGruppo = $I->grabFromDatabase( 'SELECT id FROM gruppi WHERE nome = ?', array( $nome ) );

            // si ritrova cercandolo nella vista
            $I->amOnPageId( 'gruppi.view' );
            $I->fillField( 'input[name$="[__search__]"]', $nome );
            $I->pressKey( 'input[name$="[__search__]"]', \Facebook\WebDriver\WebDriverKeys::ENTER );
            $I->waitForText( $nome, 10 );

            // eliminazione dal form, passando dalla pagina di conferma
            $I->amOnPageId( 'gruppi.form', array( 'gruppi' => array( 'id' => $idGruppo ) ) );
            $I->click( '#form-gruppi button .fa-trash' );
            $I->waitForElementVisible( '#form-delete', 10 );
            $I->click( '#form-delete input[type="submit"]' );

            $I->dontSeeInDatabase( 'gruppi', array( 'id' => $idGruppo ) );

        }

        /**
         * inserisce un account dal form, assegnandogli un gruppo dal subform
         *
         * @return      integer                     l'id dell'account inserito
         *
         */
        protected function inserisciAccount( BackendTester $I, $username, $password, $gruppo ) {

            $idGruppo = $I->grabFromDatabase( 'SELECT id FROM gruppi WHERE nome = ?', array( $gruppo ) );

            // compilazione e salvataggio del form; la prima riga del subform dei gruppi e' gia' aperta
            $I->amOnPageId( 'account.form' );
            $I->fillField( 'account[username]', $username );
            $I->fillField( 'account[password]', $password );
            // il checkbox visibile non ha name: e' quello accanto al campo nascosto che porta il valore
            $I->checkOption( '#account_se_attivo + input[type="checkbox"]' );
            $I->selectOption( 'account[account_gruppi][0][id_gruppo]', (string) $idGruppo );
            $I->click( '#form-account button .fa-floppy-disk' );

            // l'account e il suo gruppo sono nel database
            $I->seeInDatabase( 'account', array( 'username' => $username, 'se_attivo' => 1 ) );
            $idAccount = $I->grabFromDatabase( 'SELECT id FROM account WHERE username = ?', array( $username ) );
            $I->seeInDatabase( 'account_gruppi', array( 'id_account' => $idAccount, 'id_gruppo' => $idGruppo ) );

            return $idAccount;

        }

        // login dal form di una pagina riservata
        protected function loginForm( BackendTester $I, $user, $pasw, $pagina ) {

            $I->amOnPageId( $pagina );
            $I->seeElement( '#formLogin' );
            $I->submitForm( '#formLogin', array( '__login__[user]' => $user, '__login__[pasw]' => $pasw ) );

        }

    }
