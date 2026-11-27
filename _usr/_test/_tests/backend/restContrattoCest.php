<?php

    /**
     * test del contratto dell'API REST generica del nucleo
     *
     * verifica _src/_api/_rest.php ( api/<entita>[/<id>] ): un nome di entita' ostile in __ws__ non produce errori SQL
     * ne' dati ( S-016 ) e un account senza permessi, o un anonimo, non legge, non modifica e non cancella le righe
     * di un'altra anagrafica ( S-017 )
     *
     * il record di prova ha la denominazione TEST-E2E-<id> e si toglie in _before() e _after(); le richieste
     * partono da restCall(), col JWT dell'account di test nell'header Authorization
     *
     */

    class restContrattoCest {

        // pulizia prima e dopo ogni test
        public function _before( BackendTester $I ) {
            $I->deleteTestRecords( 'anagrafica', 'denominazione' );
        }

        public function _after( BackendTester $I ) {
            $I->deleteTestRecords( 'anagrafica', 'denominazione' );
        }

        // chiama il percorso REST con il JWT di un gruppo ( o da anonimo ); restituisce lo status HTTP
        private function chiama( $metodo, $percorso, $jwt, &$raw, $dati = NULL ) {

            global $cf;

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . $percorso,
                $metodo,
                $dati,
                MIME_APPLICATION_JSON,
                MIME_APPLICATION_JSON,
                $status,
                $jwt ? array( 'Authorization' => 'Bearer ' . $jwt ) : array(),
                NULL,
                NULL,
                $error,
                NULL,
                CURLAUTH_BASIC,
                $raw
            );

            return (int) $status;

        }

        // S-016 rest: nomi di entita' ostili in __ws__ non danno errori SQL, ne' dati, ne' un 500
        public function nomiEntitaOstili( BackendTester $I ) {

            $jwt = $I->grabTestAccount( 'roots' )['jwt'];

            $nomi = array(
                "'",
                "anagrafica' OR '1'='1",
                'anagrafica; DROP TABLE anagrafica',
                'anagrafica`',
                '%2e%2e%2f%2e%2e%2fetc',
                'anagrafica[]',
                '__report_anagrafica',
                'information_schema.tables',
                'mysql.user',
            );

            foreach( $nomi as $nome ) {

                $query = ( strpos( $nome, '%' ) !== false ) ? $nome : rawurlencode( $nome );

                $status = $this->chiama( METHOD_GET, '/api/anagrafica?__ws__=' . $query, $jwt, $raw );

                $I->assertLessThan( 500, $status, 'il nome ' . $nome . ' risponde ' . $status );
                $I->assertDoesNotMatchRegularExpression( '/SQL syntax|mysqli?_|You have an error|Warning:|Fatal error|Stack trace/i', (string) $raw, 'il nome ' . $nome . ' fa uscire un errore interno: ' . substr( (string) $raw, 0, 200 ) );
                $I->assertStringNotContainsString( 'User', (string) $raw, 'il nome ' . $nome . ' espone la tabella mysql.user' );

            }

        }

        // S-017 rest: un anonimo e un account senza permessi non leggono, modificano o cancellano una anagrafica altrui
        public function scritturaSenzaPermessi( BackendTester $I ) {

            $denominazione = \Helper\Glisweb::RECORD_PREFIX . uniqid();

            $id = $I->haveInDatabase( 'anagrafica', array( 'denominazione' => $denominazione ) );

            $jwtUtente = $I->grabTestAccount( 'users' )['jwt'];

            foreach( array( 'anonimo' => NULL, 'test-users' => $jwtUtente ) as $chi => $jwt ) {

                $status = $this->chiama( METHOD_GET, '/api/anagrafica/' . $id, $jwt, $raw );
                $I->assertContains( $status, array( 401, 403 ), $chi . ': GET risponde ' . $status );
                $I->assertStringNotContainsString( $denominazione, (string) $raw, $chi . ': GET espone la riga' );

                $status = $this->chiama( METHOD_PUT, '/api/anagrafica/' . $id, $jwt, $raw, array( 'denominazione' => $denominazione . '-MODIFICATA' ) );
                $I->assertContains( $status, array( 401, 403 ), $chi . ': PUT risponde ' . $status );

                $status = $this->chiama( METHOD_DELETE, '/api/anagrafica/' . $id, $jwt, $raw );
                $I->assertContains( $status, array( 401, 403 ), $chi . ': DELETE risponde ' . $status );

                $I->assertEquals( $denominazione, $I->grabFromDatabase( 'SELECT denominazione FROM anagrafica WHERE id = ?', array( $id ) ), $chi . ': la riga e\' stata modificata o cancellata' );

            }

        }

    }
