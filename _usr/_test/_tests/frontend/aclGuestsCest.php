<?php

    /**
     * test dei permessi di lettura per gli anonimi
     *
     * verifica $cf['auth']['guests'] di _src/_config/_250.auth.php e il ramo corrispondente di getAclPermission():
     * chi non e' connesso legge dalle API le tabelle di lookup dell'elenco ( le tendine dei form pubblici, p.es. i
     * comuni ), e riceve 401 su tutte le altre e su qualunque scrittura
     *
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall() senza cookie di sessione
     *
     */

    class aclGuestsCest {

        // una tabella dell'elenco si legge senza login
        public function letturaConsentita( FrontendTester $I ) {

            $I->assertEquals( 200, $this->chiama( '/api/comuni?__info__[comuni][__search__]=roma', METHOD_GET, $raw ) );
            $I->assertEquals( 200, $this->chiama( '/api/stati', METHOD_GET, $raw ) );

        }

        // una tabella fuori dall'elenco resta chiusa
        public function letturaNegata( FrontendTester $I ) {

            $I->assertEquals( 401, $this->chiama( '/api/anagrafica', METHOD_GET, $raw ) );

        }

        // anche sulle tabelle dell'elenco l'anonimo non scrive
        public function scritturaNegata( FrontendTester $I ) {

            $I->assertEquals( 401, $this->chiama( '/api/comuni', METHOD_POST, $raw, array( 'nome' => \Helper\Glisweb::RECORD_PREFIX . uniqid() ) ) );

        }

        /**
         * chiama l'API senza sessione e restituisce lo status HTTP
         *
         * @param string $pagina il percorso da chiamare
         * @param string $metodo il metodo HTTP
         * @param string $raw il corpo della risposta ( per riferimento )
         * @param array $dati i dati da inviare
         *
         * @return int lo status HTTP
         *
         */
        protected function chiama( $pagina, $metodo, &$raw, $dati = NULL ) {

            global $cf;

            $raw = NULL;
            $status = NULL;
            $headers = array();

            restCall( rtrim( $cf['site']['url'], '/' ) . $pagina, $metodo, $dati, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $status, $headers, NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw );

            return (int) $status;

        }

    }
