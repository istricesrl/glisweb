<?php

    /**
     * test dei link alle versioni della pagina nelle altre lingue
     *
     * verifica che l'head di una pagina pubblicata in più lingue porti un <link rel="alternate" hreflang="…"> per ogni
     * lingua, verso l'URL di quella lingua, come lo emette _src/_twig/_inc/_page.head.twig; per le pagine che dichiarano
     * canonical un'altra pagina gli URL sono quelli della canonica
     *
     * i test leggono l'albero delle pagine dal framework avviato da _usr/_test/_bootstrap.php, quindi valgono per le
     * lingue che il deploy ha davvero: su un deploy con una lingua sola la verifica controlla che i link non ci siano
     *
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall()
     *
     */

    class hreflangCest {

        // l'head della prima pagina che risponde dichiara le versioni in tutte le lingue, o nessuna se la lingua è una
        public function linkAlternate( FrontendTester $I ) {

            global $cf;

            $lingua = $cf['localization']['language']['ietf'];

            foreach( $cf['contents']['pages'] as $id => $page ) {

                if( empty( $page['path'][ $lingua ] ) || ! empty( $page['canonical'] ) && $page['canonical'] != $id ) {
                    continue;
                }

                if( $this->scarica( $page['path'][ $lingua ], $raw ) == 200 && strpos( $raw, '<!-- file: _inc/_page.head.twig -->' ) !== false ) {

                    if( count( $page['url'] ) > 1 ) {
                        foreach( $page['url'] as $l => $u ) {
                            $I->assertStringContainsString( '<link rel="alternate" hreflang="' . $l . '" href="' . $u . '">', $raw, 'manca la versione ' . $l . ' di ' . $id );
                        }
                    } else {
                        $I->assertStringNotContainsString( 'hreflang=', $raw, 'la pagina ' . $id . ' ha una lingua sola e dichiara versioni in altre lingue' );
                    }

                    return;

                }

            }

        }

        /**
         * scarica una pagina del sito e ne restituisce lo status HTTP
         *
         * @param       string      $pagina         il percorso della pagina, a partire dalla radice del sito
         * @param       string      $raw            il corpo della risposta
         *
         * @return      int                         lo status HTTP
         *
         */
        protected function scarica( $pagina, &$raw ) {

            global $cf;

            $raw = NULL;
            $status = NULL;

            restCall( rtrim( $cf['site']['url'], '/' ) . $pagina, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, array(), NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw );

            return (int) $status;

        }

    }
