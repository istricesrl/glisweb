<?php

    /**
     * test dell'API della struttura api/cli del nucleo
     *
     * verifica _src/_api/_cli.php: senza chiave, o con una chiave che non esiste, risponde 401 con status KO e una sola
     * risposta JSON; con la chiave avuta da api/login risponde l'account senza password, permessi e privilegi, e l'albero
     * del menu admin con le stesse regole di permesso di buildMenu(); in POST JSON rinnova la chiave ( rinnova ), cerca
     * nelle viste per le tendine ( cerca ) e restituisce le righe di una pagina vista ( pagina )
     *
     * si usano gli account test-roots e test-users creati dall'helper Glisweb, con la loro password vera ( grabTestAccount );
     * la chiave vive su Redis, quindi senza Redis il deploy non sa fare il login via chiave e il test lo dice
     *
     */

    class cliApiCest {

        // chiama api/cli, con l'header gliswebAuthKey se c'e' una chiave e in POST JSON se ci sono dati; restituisce lo
        // status HTTP e la risposta decodificata
        private function cli( $chiave, &$risposta, &$raw, $dati = NULL ) {

            global $cf;

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . '/api/cli',
                ( $dati === NULL ) ? METHOD_GET : METHOD_POST,
                $dati,
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

        // rinnova: la chiave resta buona e la risposta e' corta, senza menu
        public function rinnova( BackendTester $I ) {

            $chiave = $this->chiave( $I, 'roots' );

            $status = $this->cli( $chiave, $risposta, $raw, array( 'rinnova' => true ) );

            $I->assertEquals( 200, $status, 'risposta: ' . substr( (string) $raw, 0, 300 ) );
            $I->assertEquals( 'OK', $risposta['status'] ?? NULL );
            $I->assertTrue( $risposta['rinnovato'] ?? false, 'non dice rinnovato' );
            $I->assertArrayNotHasKey( 'menu', $risposta, 'il rinnovo ha dato il menu' );

            $this->cli( $chiave, $risposta, $raw );
            $I->assertEquals( 'OK', $risposta['status'] ?? NULL, 'dopo il rinnovo la chiave non vale piu\'' );

        }

        // cerca: solo sulle viste del framework, almeno due caratteri, per testo o per id
        public function cerca( BackendTester $I ) {

            $chiave = $this->chiave( $I, 'roots' );

            $this->cli( $chiave, $risposta, $raw, array( 'cerca' => array( 'tabella' => 'tabella_che_non_esiste', 'q' => 'ita' ) ) );
            $I->assertEquals( 'KO', $risposta['status'] ?? NULL, 'una tabella senza vista ha risposto: ' . substr( (string) $raw, 0, 200 ) );

            $this->cli( $chiave, $risposta, $raw, array( 'cerca' => array( 'tabella' => 'lingue', 'q' => 'i' ) ) );
            $I->assertEquals( 'KO', $risposta['status'] ?? NULL, 'un carattere solo ha risposto' );

            $this->cli( $chiave, $risposta, $raw, array( 'cerca' => array( 'tabella' => 'lingue', 'q' => 'italia' ) ) );
            $I->assertEquals( 'OK', $risposta['status'] ?? NULL, 'risposta: ' . substr( (string) $raw, 0, 300 ) );
            $I->assertContains( 'italiano', array_column( $risposta['cerca']['voci'] ?? array(), '__label__' ), 'italiano non trovato' );

            $this->cli( $chiave, $risposta, $raw, array( 'cerca' => array( 'tabella' => 'lingue', 'id' => 1 ) ) );
            $I->assertEquals( 'italiano', $risposta['cerca']['voci'][0]['__label__'] ?? NULL, 'l\'id 1 non e\' italiano' );

        }

        // pagina: 404 se non esiste, le righe di una vista twig del menu admin; una vista della generazione vecchia
        // ( .view.html, i deploy coi moduli legacy ) non e' ancora gestita e lo dice
        public function pagina( BackendTester $I ) {

            $chiave = $this->chiave( $I, 'roots' );

            $status = $this->cli( $chiave, $risposta, $raw, array( 'pagina' => 'pagina.che.non.esiste' ) );
            $I->assertEquals( 404, $status, 'pagina inesistente: ' . substr( (string) $raw, 0, 200 ) );
            $I->assertEquals( 'KO', $risposta['status'] ?? NULL );

            // una vista qualsiasi del menu admin per generazione, per non legarsi a un modulo
            $this->cli( $chiave, $menu, $raw );
            $viste = array();
            $cerca = function( $voci ) use ( &$cerca, &$viste ) {
                foreach( (array) $voci as $voce ) {
                    if( preg_match( '/\.view\.(twig|html)$/', (string) ( $voce['schema'] ?? '' ), $m ) && ! isset( $viste[ $m[1] ] ) ) {
                        $viste[ $m[1] ] = $voce['id'];
                    }
                    $cerca( $voce['content'] ?? array() );
                }
            };
            $cerca( $menu['menu']['admin'] ?? array() );
            $I->assertNotEmpty( $viste, 'nessuna vista nel menu admin di roots' );

            if( isset( $viste['html'] ) ) {
                $this->cli( $chiave, $risposta, $raw, array( 'pagina' => $viste['html'] ) );
                $I->assertEquals( 'schema non ancora gestito', $risposta['err'] ?? NULL, $viste['html'] . ': ' . substr( (string) $raw, 0, 300 ) );
            }

            if( ! isset( $viste['twig'] ) ) {
                return;
            }
            $vista = $viste['twig'];

            $status = $this->cli( $chiave, $risposta, $raw, array( 'pagina' => $vista ) );
            $I->assertEquals( 200, $status, $vista . ': ' . substr( (string) $raw, 0, 300 ) );
            $I->assertEquals( 'OK', $risposta['status'] ?? NULL, $vista . ': ' . substr( (string) $raw, 0, 300 ) );
            $I->assertEquals( $vista, $risposta['pagina'] ?? NULL );
            $I->assertIsArray( $risposta['view']['data'] ?? NULL, $vista . ': la vista non ha righe' );

        }

    }
