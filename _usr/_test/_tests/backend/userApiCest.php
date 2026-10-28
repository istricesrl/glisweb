<?php

    /**
     * test dell'API di login api/login del nucleo
     *
     * verifica _src/_api/_user.php: le credenziali giuste danno l'account e un token senza la password, quelle
     * sbagliate, vuote o un corpo JSON non valido danno solo 'login errato' senza dettagli ( S-015 )
     *
     * si usa l'account test-users creato dall'helper Glisweb, con la sua password vera ( grabTestAccount )
     *
     * non si prova la protezione da brute force: nel sorgente e' un TODO, e centinaia di login errati fatti dal test
     * farebbero scattare il firewall sull'IP di chi lancia la suite
     *
     */

    class userApiCest {

        // chiama api/login con un array ( inviato come JSON ) o con una stringa ( inviata cosi' com'e' ); restituisce lo status HTTP e la risposta decodificata
        private function login( $corpo, &$risposta, &$raw ) {

            global $cf;

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . '/api/login',
                METHOD_POST,
                $corpo,
                is_string( $corpo ) ? MIME_APPLICATION_XML : MIME_APPLICATION_JSON,
                MIME_TEXT_PLAIN,
                $status,
                array(),
                NULL,
                NULL,
                $error,
                NULL,
                CURLAUTH_BASIC,
                $raw
            );

            $risposta = json_decode( (string) $raw, true );

            return (int) $status;

        }

        // S-015 api/login: le credenziali giuste danno l'account e un token, mai la password
        public function loginCorretto( BackendTester $I ) {

            $account = $I->grabTestAccount( 'users' );

            $this->login( array( '__login__' => array( 'user' => $account['username'], 'pasw' => $account['password'] ) ), $risposta, $raw );

            $I->assertIsArray( $risposta, 'la risposta non e\' JSON: ' . substr( (string) $raw, 0, 200 ) );
            $I->assertEquals( $account['username'], $risposta['username'] ?? NULL, 'risposta: ' . substr( (string) $raw, 0, 300 ) );
            $I->assertNotEmpty( $risposta['token'] ?? NULL, 'manca il token' );
            $I->assertStringNotContainsString( $account['password'], (string) $raw, 'la password e\' nella risposta' );
            $I->assertArrayNotHasKey( 'password', $risposta );
            $I->assertArrayNotHasKey( 'permissions', $risposta );

        }

        // S-015 api/login: password sbagliata, utente inesistente, credenziali vuote e JSON non valido danno tutti 'login errato'
        public function loginErrato( BackendTester $I ) {

            $account = $I->grabTestAccount( 'users' );

            $casi = array(
                'password sbagliata'    => array( '__login__' => array( 'user' => $account['username'], 'pasw' => 'sbagliata-' . uniqid() ) ),
                'utente inesistente'    => array( '__login__' => array( 'user' => \Helper\Glisweb::RECORD_PREFIX . uniqid(), 'pasw' => 'x' ) ),
                'credenziali vuote'     => array( '__login__' => array( 'user' => '', 'pasw' => '' ) ),
                'senza credenziali'     => array(),
                'JSON non valido'       => '{"__login__": { "user": ',
                'campi come array'      => array( '__login__' => array( 'user' => array( 'a' ), 'pasw' => array( 'b' ) ) ),
            );

            foreach( $casi as $nome => $corpo ) {

                $status = $this->login( $corpo, $risposta, $raw );

                // un corpo malformato o con campi array e' fermato prima del login ( firewall, o rifiuto del framework sui parametri non stringa ): basta che non esca un token
                if( ! is_array( $risposta ) ) {
                    $I->assertStringNotContainsString( 'token', (string) $raw, $nome . ': la risposta cita un token' );
                    $I->assertStringNotContainsString( $account['username'], (string) $raw, $nome . ': la risposta cita l\'utente' );
                    continue;
                }

                $I->assertIsArray( $risposta, $nome . ': la risposta non e\' JSON: ' . substr( (string) $raw, 0, 200 ) );
                $I->assertEquals( 'KO', $risposta['status'] ?? NULL, $nome . ': non risponde KO' );
                $I->assertEquals( 'login errato', $risposta['err'] ?? NULL, $nome . ': messaggio diverso da login errato' );
                $I->assertArrayNotHasKey( 'token', $risposta, $nome . ': ha dato un token' );
                $I->assertStringNotContainsString( $account['username'], (string) $raw, $nome . ': la risposta cita l\'utente' );

            }

        }

    }
