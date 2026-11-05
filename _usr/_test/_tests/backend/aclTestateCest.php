<?php

    /**
     * test dei permessi sulla tabella testate
     *
     * verifica la voce testate di $cf['auth']['acl'] in _src/_config/_250.auth.php: lo staff legge le testate dalle
     * API come le altre tabelle delle risorse ( categorie_risorse, risorse_categorie ), un account senza permessi no;
     * fino al 2026-11-05 la voce mancava e nessuno, a parte roots, poteva usare la tabella
     * ( punto 6 dello schema canonico, riga 190 )
     *
     * il record di prova ha il nome TEST-E2E-<id> e si toglie in _before() e _after(); le richieste partono da
     * restCall(), col JWT dell'account di test nell'header Authorization
     *
     */

    class aclTestateCest {

        // pulizia prima e dopo ogni test
        public function _before( BackendTester $I ) {
            $I->deleteTestRecords( 'testate', 'nome' );
        }

        public function _after( BackendTester $I ) {
            $I->deleteTestRecords( 'testate', 'nome' );
        }

        // chiama il percorso REST con il JWT di un gruppo; restituisce lo status HTTP
        private function chiama( $metodo, $percorso, $jwt, &$raw ) {

            global $cf;

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . $percorso,
                $metodo,
                NULL,
                MIME_APPLICATION_JSON,
                MIME_APPLICATION_JSON,
                $status,
                array( 'Authorization' => 'Bearer ' . $jwt ),
                NULL,
                NULL,
                $error,
                NULL,
                CURLAUTH_BASIC,
                $raw
            );

            return (int) $status;

        }

        // lo staff legge una testata
        public function letturaStaff( BackendTester $I ) {

            $nome = \Helper\Glisweb::RECORD_PREFIX . uniqid();
            $id = $I->haveInDatabase( 'testate', array( 'nome' => $nome ) );

            $status = $this->chiama( METHOD_GET, '/api/testate/' . $id, $I->grabTestAccount( 'staff' )['jwt'], $raw );
            $I->assertEquals( 200, $status, 'test-staff: GET risponde ' . $status );
            $I->assertStringContainsString( $nome, (string) $raw, 'test-staff: GET non restituisce la testata' );

        }

        // un account senza permessi non la legge
        public function letturaNegata( BackendTester $I ) {

            $nome = \Helper\Glisweb::RECORD_PREFIX . uniqid();
            $id = $I->haveInDatabase( 'testate', array( 'nome' => $nome ) );

            $status = $this->chiama( METHOD_GET, '/api/testate/' . $id, $I->grabTestAccount( 'users' )['jwt'], $raw );
            $I->assertContains( $status, array( 401, 403 ), 'test-users: GET risponde ' . $status );
            $I->assertStringNotContainsString( $nome, (string) $raw, 'test-users: GET espone la testata' );

        }

    }
