<?php

    /**
     * test degli endpoint interni chiamati da un anonimo
     *
     * verifica che gli endpoint di servizio del nucleo ( /status, /cf, /report/memcache, /print/*, /api/security.403 )
     * non diano a chi non ha fatto il login ne' informazioni sull'installazione ( versioni, percorsi assoluti, albero
     * della configurazione ) ne' dati: devono rispondere 401, 403 o 404, oppure 200 con un corpo che non rivela
     * niente di tutto questo ( S-008 )
     *
     * le richieste partono da restCall() senza login; un test rosso qui vuol dire che l'endpoint e' aperto
     * e non ha nessuna chiamata di privilegio: non va coperto, va protetto
     *
     */

    class endpointAnonimiCest {

        // scarica un percorso senza login; restituisce lo status HTTP
        private function scarica( $percorso, &$raw ) {

            global $cf;

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . $percorso,
                METHOD_GET,
                NULL,
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

            return (int) $status;

        }

        // un 200 che rivela l'installazione: versione di PHP, percorsi assoluti del deploy, credenziali
        private function rivela( $raw ) {

            $rivela = array();

            if( strpos( (string) $raw, DIR_BASE ) !== false ) {
                $rivela[] = 'percorso assoluto del deploy';
            }

            if( preg_match( '/versione di PHP|PHP Version|PHP \d+\.\d+\.\d+/i', (string) $raw ) ) {
                $rivela[] = 'versione di PHP';
            }

            if( preg_match( '/password|passwd|secret/i', (string) $raw ) ) {
                $rivela[] = 'riferimenti a password o file segreti';
            }

            if( preg_match( '/<title>variabili del framework<\/title>/i', (string) $raw ) ) {
                $rivela[] = 'albero della configurazione $cf';
            }

            return $rivela;

        }

        // S-008 endpoint interni: un anonimo li ottiene negati o vuoti di informazioni
        public function endpointInterniDaAnonimo( FrontendTester $I ) {

            $aperti = array();

            foreach( array( '/status', '/cf', '/geo', '/status/framework', '/status/cf', '/status/geo', '/status/session', '/report/memcache', '/report/cookie', '/api/security.403', '/print/default.csv' ) as $percorso ) {

                $status = $this->scarica( $percorso, $raw );

                if( in_array( $status, array( 401, 403, 404 ) ) ) {
                    continue;
                }

                $rivela = $this->rivela( $raw );

                if( ! empty( $rivela ) ) {
                    $aperti[] = $percorso . ' ( ' . $status . ': ' . implode( ', ', $rivela ) . ' )';
                }

            }

            $I->assertEmpty( $aperti, 'endpoint interni aperti a un anonimo: ' . implode( '; ', $aperti ) );

        }

    }
