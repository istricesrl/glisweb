<?php

    /**
     * test dell'API della struttura api/cli del nucleo
     *
     * verifica _src/_api/_cli.php: senza chiave, o con una chiave che non esiste, risponde 401 con status KO e una sola
     * risposta JSON; con la chiave avuta da api/login risponde l'account senza password, permessi e privilegi, e l'albero
     * del menu admin con le stesse regole di permesso di buildMenu()
     *
     * si usano gli account test-roots e test-users creati dall'helper Glisweb, con la loro password vera ( grabTestAccount );
     * la chiave vive su Redis, quindi senza Redis il deploy non sa fare il login via chiave e il test lo dice
     *
     */

    class cliApiCest {

        // chiama api/cli, con l'header gliswebAuthKey se c'e' una chiave; restituisce lo status HTTP e la risposta decodificata
        private function cli( $chiave, &$risposta, &$raw ) {

            global $cf;

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . '/api/cli',
                METHOD_GET,
                NULL,
                MIME_APPLICATION_JSON,
                MIME_TEXT_PLAIN,
                $status,
                ( $chiave === NULL ) ? array() : array( 'gliswebAuthKey' => $chiave ),
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

        // fa il login su api/login con l'account di test del gruppo e restituisce la chiave
        private function chiave( BackendTester $I, $gruppo ) {

            global $cf;

            $account = $I->grabTestAccount( $gruppo );

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . '/api/login',
                METHOD_POST,
                array( '__login__' => array( 'user' => $account['username'], 'pasw' => $account['password'] ) ),
                MIME_APPLICATION_JSON,
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

            $I->assertNotEmpty( $risposta['token'] ?? NULL, 'api/login non ha dato la chiave: ' . substr( (string) $raw, 0, 200 ) );

            return $risposta['token'];

        }

        // gli id delle pagine dell'albero, a tutti i livelli
        private function ids( $menu ) {

            $ids = array();

            foreach( (array) $menu as $voce ) {
                $ids[] = $voce['id'];
                $ids = array_merge( $ids, $this->ids( $voce['content'] ?? array() ) );
            }

            return $ids;

        }

        // api/cli senza chiave, con una chiave inesistente o malformata: 401, KO, e una risposta sola
        public function senzaLogin( BackendTester $I ) {

            $casi = array(
                'senza chiave'          => NULL,
                'chiave inesistente'    => bin2hex( random_bytes( 16 ) ),
                'chiave malformata'     => 'non-una-chiave',
            );

            foreach( $casi as $nome => $chiave ) {

                $status = $this->cli( $chiave, $risposta, $raw );

                $I->assertEquals( 401, $status, $nome . ': status diverso da 401' );
                $I->assertIsArray( $risposta, $nome . ': la risposta non e\' un JSON solo: ' . substr( (string) $raw, 0, 200 ) );
                $I->assertEquals( 'KO', $risposta['status'] ?? NULL, $nome . ': non risponde KO' );
                $I->assertArrayNotHasKey( 'menu', $risposta, $nome . ': ha dato il menu' );
                $I->assertArrayNotHasKey( 'account', $risposta, $nome . ': ha dato l\'account' );

            }

        }

        // api/cli con la chiave di test-roots: account senza dati riservati e un albero del menu admin
        public function conChiave( BackendTester $I ) {

            $account = $I->grabTestAccount( 'roots' );

            $status = $this->cli( $this->chiave( $I, 'roots' ), $risposta, $raw );

            $I->assertEquals( 200, $status, 'risposta: ' . substr( (string) $raw, 0, 300 ) );
            $I->assertIsArray( $risposta, 'la risposta non e\' JSON: ' . substr( (string) $raw, 0, 200 ) );
            $I->assertEquals( 'OK', $risposta['status'] ?? NULL );
            $I->assertEquals( $account['username'], $risposta['account']['username'] ?? NULL );
            $I->assertArrayNotHasKey( 'password', $risposta['account'] );
            $I->assertArrayNotHasKey( 'permissions', $risposta['account'] );
            $I->assertArrayNotHasKey( 'privilegi', $risposta['account'] );
            $I->assertStringNotContainsString( $account['password'], (string) $raw, 'la password e\' nella risposta' );
            $I->assertNotEmpty( $risposta['menu']['admin'] ?? NULL, 'il menu admin di roots e\' vuoto' );

            foreach( $risposta['menu']['admin'] as $voce ) {
                foreach( array( 'id', 'label', 'priority', 'title', 'location', 'schema', 'content' ) as $chiave ) {
                    $I->assertArrayHasKey( $chiave, $voce, 'voce ' . ( $voce['id'] ?? '?' ) . ' senza ' . $chiave );
                }
            }

        }

        // il menu di test-users non ha pagine che roots non vede: i permessi filtrano, non aggiungono
        public function permessi( BackendTester $I ) {

            $this->cli( $this->chiave( $I, 'roots' ), $roots, $raw );
            $this->cli( $this->chiave( $I, 'users' ), $users, $raw );

            $I->assertEquals( 'OK', $users['status'] ?? NULL, 'risposta: ' . substr( (string) $raw, 0, 300 ) );
            $I->assertEmpty(
                array_diff( $this->ids( $users['menu']['admin'] ?? array() ), $this->ids( $roots['menu']['admin'] ?? array() ) ),
                'test-users vede pagine che test-roots non vede'
            );
            $I->assertLessThan(
                count( $this->ids( $roots['menu']['admin'] ?? array() ) ),
                count( $this->ids( $users['menu']['admin'] ?? array() ) ),
                'test-users vede tutto il menu admin di test-roots'
            );

        }

    }
