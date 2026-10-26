<?php

    /**
     * test del riconoscimento del sito dall'host
     *
     * Apache accetta l'Host in qualunque combinazione di maiuscole e minuscole, quindi anche _src/_config/_015.site.php
     * deve riconoscere il sito senza distinguerle: fino al 26/10/2026 la regex era case-sensitive e un host valido
     * scritto in maiuscolo ( Host: GESTIONALE.POLMASI.IT ) rispondeva 404 "sito non trovato"
     *
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall(); curl manda l'Host così come
     * è scritto nell'URL
     *
     */

    class hostCest {

        // l'host in maiuscolo risponde come quello in minuscolo
        public function hostMaiuscolo( FrontendTester $I ) {

            global $cf;

            $host = parse_url( $cf['site']['url'], PHP_URL_HOST );

            $minuscolo = $this->scarica( strtolower( $host ), '/', $raw );
            $maiuscolo = $this->scarica( strtoupper( $host ), '/', $raw );

            $I->assertNotEquals( 404, $maiuscolo, 'l\'host ' . strtoupper( $host ) . ' non riconosce il sito' );
            $I->assertEquals( $minuscolo, $maiuscolo, 'l\'host ' . strtoupper( $host ) . ' risponde diversamente da ' . strtolower( $host ) );

        }

        /**
         * scarica una pagina senza browser, con l'host indicato, per averne lo status HTTP
         *
         * @param       string      $host           l'host da mettere nell'URL, e quindi nell'header Host
         * @param       string      $pagina         il percorso della pagina
         * @param       string      $raw            il corpo della risposta
         *
         * @return      int                         lo status HTTP della risposta
         *
         */
        protected function scarica( $host, $pagina, &$raw ) {

            global $cf;

            $raw = NULL;
            $status = NULL;

            $url = rtrim( preg_replace( '/^(https?:\/\/)[^\/:]+/i', '${1}' . $host, $cf['site']['url'] ), '/' ) . $pagina;

            restCall( $url, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, array(), NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw );

            return (int) $status;

        }

    }
