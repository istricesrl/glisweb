<?php

    /**
     * test della copia locale dei CSS esterni
     *
     * verifica che i CSS esterni e in preload della home vengano serviti dalla copia locale in var/cache/css/
     * ( _src/_api/_pages.php, caching locale delle risorse esterne ), che le copie rispondano e non siano vuote, e
     * che i font copiati dai loro url() siano integri: fino al 27/10/2026 writeToFile() ci aggiungeva un a capo, e
     * un WOFF piu' lungo di quanto dice la sua intestazione il browser lo scarta
     *
     * la copia si fa alla prima richiesta e si usa dalla seconda, quindi la home si scarica due volte; su un deploy
     * il cui template non dichiara CSS esterni le verifiche non trovano copie e passano senza provare niente
     *
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall()
     *
     */

    class cacheCssCest {

        // i CSS esterni della home escono dalla copia locale, che risponde e non e' vuota
        public function copieLocaliServite( FrontendTester $I ) {

            $this->scarica( '/', $raw );
            $I->assertEquals( 200, $this->scarica( '/', $raw ) );

            preg_match_all( '/<link rel="stylesheet" href="(\/var\/cache\/css\/[^"]+)"/', $raw, $copie );

            foreach( $copie[1] as $copia ) {
                $I->assertEquals( 200, $this->scarica( $copia, $css ), 'la copia ' . $copia . ' non risponde' );
                $I->assertNotEmpty( trim( $css ), 'la copia ' . $copia . ' e\' vuota' );
            }

        }

        // in var/cache/css/ non ci sono file vuoti: un download fallito non scrive niente
        public function nessunaCopiaVuota( FrontendTester $I ) {

            foreach( $this->copie() as $file ) {
                $I->assertGreaterThan( 0, filesize( $file ), 'la copia ' . $file . ' e\' vuota' );
            }

        }

        // i font WOFF e WOFF2 copiati sono lunghi quanto dice la loro intestazione
        public function fontIntegri( FrontendTester $I ) {

            foreach( $this->copie() as $file ) {
                $testa = file_get_contents( $file, false, NULL, 0, 12 );
                if( strlen( $testa ) == 12 && in_array( substr( $testa, 0, 4 ), array( 'wOFF', 'wOF2' ) ) ) {
                    $I->assertEquals( unpack( 'N', substr( $testa, 8, 4 ) )[1], filesize( $file ), 'il font ' . $file . ' non e\' integro' );
                }
            }

        }

        /**
         * restituisce i file della copia locale dei CSS
         *
         * @return      array                       i percorsi assoluti dei file in var/cache/css/
         *
         */
        protected function copie() {

            $copie = array();

            if( is_dir( DIR_VAR_CACHE . 'css' ) ) {
                foreach( new RecursiveIteratorIterator( new RecursiveDirectoryIterator( DIR_VAR_CACHE . 'css', FilesystemIterator::SKIP_DOTS ) ) as $file ) {
                    if( $file->isFile() ) {
                        $copie[] = $file->getPathname();
                    }
                }
            }

            return $copie;

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
