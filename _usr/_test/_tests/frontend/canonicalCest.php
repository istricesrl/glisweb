<?php

    /**
     * test degli URL canonici
     *
     * verifica il canonical delle pagine generate dai moduli che pubblicano un contenuto in più categorie ( prodotti,
     * articoli, notizie, annunci, risorse ): ogni pagina del contenuto dichiara canonical la stessa pagina, quella della
     * prima categoria, e quella pagina dichiara canonical sé stessa; nella sitemap vanno solo le pagine canoniche, e
     * l'head della pagina doppione porta il <link rel="canonical"> verso la canonica
     *
     * i test leggono l'albero delle pagine dal framework avviato da _usr/_test/_bootstrap.php, quindi valgono per i
     * contenuti che il deploy ha davvero: su un deploy senza contenuti in più categorie le verifiche non trovano
     * doppioni e passano senza provare niente
     *
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall()
     *
     */

    class canonicalCest {

        // la canonical di una pagina esiste ed è canonica di sé stessa, senza catene
        public function canonicalStabile( FrontendTester $I ) {

            global $cf;

            foreach( $this->doppioni() as $id => $canonical ) {
                $I->assertArrayHasKey( $canonical, $cf['contents']['pages'], 'la canonical ' . $canonical . ' di ' . $id . ' non esiste' );
                $I->assertTrue(
                    empty( $cf['contents']['pages'][ $canonical ]['canonical'] ) || $cf['contents']['pages'][ $canonical ]['canonical'] == $canonical,
                    'la canonical ' . $canonical . ' di ' . $id . ' rimanda a sua volta a ' . $cf['contents']['pages'][ $canonical ]['canonical']
                );
            }

        }

        // nella sitemap non ci sono pagine che dichiarano canonical un'altra pagina
        public function sitemapSoloCanonical( FrontendTester $I ) {

            global $cf;

            $I->assertEquals( 200, $this->scarica( '/sitemap.xml', $raw ) );

            $lingua = $cf['localization']['language']['ietf'];

            foreach( $this->doppioni() as $id => $canonical ) {
                if( ! empty( $cf['contents']['pages'][ $id ]['url'][ $lingua ] ) ) {
                    $I->assertStringNotContainsString( '<loc>' . $cf['contents']['pages'][ $id ]['url'][ $lingua ] . '</loc>', $raw, 'il doppione ' . $id . ' è nella sitemap' );
                }
            }

        }

        // l'head della pagina doppione dichiara la canonica
        public function linkCanonical( FrontendTester $I ) {

            global $cf;

            $lingua = $cf['localization']['language']['ietf'];

            foreach( $this->doppioni() as $id => $canonical ) {
                if( $this->scarica( $cf['contents']['pages'][ $id ]['path'][ $lingua ], $raw ) == 200 ) {
                    $I->assertStringContainsString( '<link rel="canonical" href="' . $cf['contents']['pages'][ $canonical ]['url'][ $lingua ] . '">', $raw );
                    return;
                }
            }

        }

        /**
         * restituisce le pagine che dichiarano canonical una pagina diversa da sé stesse
         *
         * @return      array                       l'id della pagina come chiave e l'id della sua canonical come valore
         *
         */
        protected function doppioni() {

            global $cf;

            $doppioni = array();

            foreach( $cf['contents']['pages'] as $id => $page ) {
                if( ! empty( $page['canonical'] ) && $page['canonical'] != $id ) {
                    $doppioni[ $id ] = $page['canonical'];
                }
            }

            return $doppioni;

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
