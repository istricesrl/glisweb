<?php

    /**
     * test dell'autenticazione del nucleo
     *
     * verifica le strade con cui si entra nel back-end e quelle con cui non si deve entrare: il form di login con
     * credenziali giuste e sbagliate, l'account disattivato, il logout, la rigenerazione dell'id di sessione, il
     * token JWT, gli header HTTP Basic e Bearer, il diniego per gruppo e il giro di reimpostazione della password
     *
     * il login dal form si puo' provare perche' per la durata della suite il reCAPTCHA e' spento ( vedi l'helper
     * Glisweb ); gli header HTTP Basic e Bearer il browser non li sa mandare, quindi quelle prove passano da
     * restCall() e guardano l'HTML della risposta
     *
     * gli account di test sono condivisi con gli altri test della suite: quello che si cambia ( stato, mail,
     * password ) si rimette com'era prima di finire
     *
     */

    class authCest {

        // indirizzo mail usato per la reimpostazione della password
        const MAIL = 'TEST-E2E-auth@example.com';

        // pulizia prima e dopo ogni test
        public function _before( BackendTester $I ) {
            $this->pulisci( $I );
        }

        public function _after( BackendTester $I ) {
            $this->pulisci( $I );
        }

        // login dal form con le credenziali giuste
        public function loginDalForm( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $this->loginForm( $I, $account['username'], $account['password'] );
            $I->dontSeeElement( '#formLogin' );

        }

        // login dal form con la password sbagliata
        public function passwordErrata( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $this->loginForm( $I, $account['username'], 'TEST-E2E-' . $account['password'] );
            $I->seeElement( '#formLogin' );

        }

        // login dal form con un utente che non esiste
        public function utenteInesistente( BackendTester $I ) {

            $this->loginForm( $I, 'TEST-E2E-nessuno', 'TEST-E2E-nessuna' );
            $I->seeElement( '#formLogin' );

        }

        // un account disattivato non entra, anche con la password giusta
        public function accountInattivo( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $I->updateInDatabase( 'account', array( 'id' => $account['id'], 'se_attivo' => 0 ) );

            try {
                $this->loginForm( $I, $account['username'], $account['password'] );
                $I->seeElement( '#formLogin' );
            } finally {
                $I->updateInDatabase( 'account', array( 'id' => $account['id'], 'se_attivo' => 1 ) );
            }

        }

        // il logout chiude la sessione
        public function logout( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $this->loginForm( $I, $account['username'], $account['password'] );
            $I->dontSeeElement( '#formLogin' );

            $I->amOnPage( '/admin.it-IT.html?__logout__=1' );
            $I->amOnPage( '/admin.it-IT.html' );
            $I->seeElement( '#formLogin' );

            // il logout chiude tutte le sessioni dell'account ( indice multisito, vedi _220.auth.php ), compresa
            // quella salvata da amLoggedInAs() per gli altri test: lo snapshot va buttato, cosi' viene rifatto
            $I->deleteSessionSnapshot( 'test-roots' );

        }

        // al login dal form l'id di sessione cambia ( anti session fixation )
        public function rigenerazioneIdSessione( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $I->amOnPage( '/admin.it-IT.html' );
            $prima = $I->grabCookie( 'PHPSESSID' );
            $I->assertNotEmpty( $prima, 'nessun cookie di sessione prima del login' );

            $this->loginForm( $I, $account['username'], $account['password'], false );
            $I->dontSeeElement( '#formLogin' );

            $dopo = $I->grabCookie( 'PHPSESSID' );
            $I->assertNotEmpty( $dopo, 'nessun cookie di sessione dopo il login' );
            $I->assertNotEquals( $prima, $dopo, 'l\'id di sessione non e\' stato rigenerato al login' );

        }

        // login col token JWT nella query string
        public function loginJwt( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $I->amOnPage( '/admin.it-IT.html?j=' . $account['jwt'] );
            $I->dontSeeElement( '#formLogin' );

        }

        // un token JWT alterato non apre niente
        public function jwtAlterato( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $I->amOnPage( '/admin.it-IT.html?j=' . $account['jwt'] . 'x' );
            $I->seeElement( '#formLogin' );

        }

        // login con gli header HTTP Basic
        public function loginHttpBasic( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $I->assertStringNotContainsString( 'id="formLogin"', $this->scarica( '/admin.it-IT.html', $account['username'], $account['password'] ) );
            $I->assertStringContainsString( 'id="formLogin"', $this->scarica( '/admin.it-IT.html', $account['username'], 'TEST-E2E-' . $account['password'] ) );

        }

        // login con l'header Authorization Bearer, che porta il token JWT
        public function loginBearer( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $I->assertStringNotContainsString( 'id="formLogin"', $this->scarica( '/admin.it-IT.html', NULL, NULL, $account['jwt'] ) );
            $I->assertStringContainsString( 'id="formLogin"', $this->scarica( '/admin.it-IT.html', NULL, NULL, $account['jwt'] . 'x' ) );

        }

        // un gruppo non staff entra, ma la dashboard gli resta negata
        public function diniegoPerGruppo( BackendTester $I ) {

            $account = $I->grabTestAccount( 'users' );

            $this->loginForm( $I, $account['username'], $account['password'] );
            $I->seeElement( '#formLogin' );

            // la sessione c'e': la pagina del suo gruppo si apre
            $I->amOnPageId( 'app' );
            $I->dontSeeElement( '#formLogin' );

            // e la dashboard dello staff no
            $I->amOnPageId( 'dashboard' );
            $I->seeElement( '#formLogin' );

        }

        // reimpostazione della password: richiesta, mail in coda, token, nuova password
        public function reimpostazionePassword( BackendTester $I ) {

            $account = $I->grabTestAccount( 'users' );

            $idMail = $I->haveInDatabase( 'mail', array( 'indirizzo' => self::MAIL, 'timestamp_inserimento' => time() ) );
            $I->updateInDatabase( 'account', array( 'id' => $account['id'], 'id_mail' => $idMail ) );
            $hashPrima = $I->grabFromDatabase( 'SELECT password FROM account WHERE id = ?', array( $account['id'] ) );

            // la richiesta mette il token sull'account e la mail in coda
            $I->amOnPageId( 'password.reset' );
            $I->submitForm( '#form-login', array( '__pwreset__[email]' => self::MAIL ) );
            $I->see( 'abbiamo inviato una mail' );

            $tk = $I->grabFromDatabase( 'SELECT token FROM account WHERE id = ?', array( $account['id'] ) );
            $I->assertNotEmpty( $tk, 'la richiesta non ha messo il token sull\'account' );
            $I->assertGreaterThan( 0, (int) $I->grabFromDatabase( 'SELECT count(*) FROM mail_out WHERE destinatari LIKE ?', array( '%' . self::MAIL . '%' ) ), 'nessuna mail in coda' );

            // il token apre il campo della nuova password; si rimette la stessa, cosi' l'account resta usabile
            $I->amOnPageId( 'password.reset', array( 'tk' => $tk ) );
            $I->seeElement( 'input[name="__pwreset__[password]"]' );
            $I->submitForm( '#form-login', array( '__pwreset__[password]' => $account['password'] ) );
            $I->see( 'password reimpostata con successo' );

            // il token e' consumato e l'hash e' stato riscritto
            $I->dontSeeInDatabase( 'account', array( 'id' => $account['id'], 'token' => $tk ) );
            $I->assertNotEquals( $hashPrima, $I->grabFromDatabase( 'SELECT password FROM account WHERE id = ?', array( $account['id'] ) ) );

            // la password reimpostata funziona
            $this->loginForm( $I, $account['username'], $account['password'], true, 'app' );
            $I->dontSeeElement( '#formLogin' );

        }

        // una mail che non corrisponde ad alcun account e un token inventato non portano da nessuna parte
        public function reimpostazionePasswordRifiutata( BackendTester $I ) {

            $I->amOnPageId( 'password.reset' );
            $I->submitForm( '#form-login', array( '__pwreset__[email]' => self::MAIL ) );
            $I->see( 'la mail inserita non corrisponde ad alcun account valido' );

            $I->amOnPageId( 'password.reset', array( 'tk' => 'TEST-E2E-token' ) );
            $I->see( 'il token non è valido' );
            $I->dontSeeElement( 'input[name="__pwreset__[password]"]' );

        }

        /**
         * login dal form della pagina indicata, come lo farebbe un utente
         *
         * il bottone del form passa dal reCAPTCHA lato client, quindi si invia il form direttamente
         *
         */
        protected function loginForm( BackendTester $I, $user, $pasw, $apri = true, $pagina = 'dashboard' ) {

            if( $apri ) {
                $I->amOnPageId( $pagina );
            }

            $I->seeElement( '#formLogin' );
            $I->submitForm( '#formLogin', array( '__login__[user]' => $user, '__login__[pasw]' => $pasw ) );

        }

        /**
         * scarica una pagina senza browser, con gli header di autenticazione che il browser non sa mandare
         *
         * @return      string                      l'HTML della risposta
         *
         */
        protected function scarica( $pagina, $user = NULL, $pasw = NULL, $token = NULL ) {

            global $cf;

            $raw = NULL;
            $status = NULL;

            restCall( rtrim( $cf['site']['url'], '/' ) . $pagina, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, array(), $user, $pasw, $error, $token, CURLAUTH_BASIC, $raw );

            return (string) $raw;

        }

        /**
         * toglie la mail di test dall'account, la mail stessa e le mail rimaste in coda
         *
         */
        protected function pulisci( BackendTester $I ) {

            $account = $I->grabTestAccount( 'users' );

            $I->updateInDatabase( 'account', array( 'id' => $account['id'], 'id_mail' => NULL, 'token' => NULL ) );
            $I->deleteTestRecords( 'mail_out', 'destinatari', true );
            $I->deleteTestRecords( 'mail', 'indirizzo' );

        }

    }
