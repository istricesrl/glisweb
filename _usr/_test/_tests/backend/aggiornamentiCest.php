<?php

    /**
     * test della distribuzione degli aggiornamenti
     *
     * verifica che /api/aggiornamenti ( _src/_api/_aggiornamenti.php ) serva il manifest e il file pubblicati in
     * var/spool/aggiornamenti/<sorgente>/, che rifiuti un segreto sbagliato e che non serva un file diverso da
     * quello dichiarato nel manifest; la firma non la guarda il deploy, quindi qui basta una firma finta
     *
     * la sorgente e' la prima di debug.log.remoti.sorgenti del deploy; se ha gia' un aggiornamento pubblicato il test
     * si salta, per non sovrascriverlo, e il materiale del test resta nello spool solo per la sua durata
     *
     */

    class aggiornamentiCest {

        // contenuto del file pubblicato dal test
        const CONTENUTO = 'TEST-E2E aggiornamento';

        // cartella della sorgente, se il test ci ha pubblicato
        protected $cartella = NULL;

        // pulizia dopo ogni test
        public function _after( BackendTester $I ) {
            $this->pulisci();
        }

        // il manifest e il file si servono, e il file e' quello pubblicato
        public function manifestEFile( BackendTester $I ) {

            list( $sorgente, $segreto ) = $this->pubblica( $I );

            $r = $this->chiedi( $sorgente, $segreto, '', $status );
            $I->assertEquals( 200, $status );
            $I->assertEquals( 'OK', $r['status'] );
            $I->assertEquals( '0.0.0', $r['versione'] );
            $I->assertEquals( hash( 'sha256', self::CONTENUTO ), $r['sha256'] );
            $I->assertEquals( strlen( self::CONTENUTO ), $r['dimensione'] );

            $this->chiedi( $sorgente, $segreto, '&scarica=1', $status, $raw );
            $I->assertEquals( 200, $status );
            $I->assertEquals( self::CONTENUTO, $raw );

        }

        // un segreto sbagliato non vede niente
        public function segretoSbagliato( BackendTester $I ) {

            list( $sorgente, $segreto ) = $this->pubblica( $I );

            $r = $this->chiedi( $sorgente, 'TEST-E2E-sbagliato', '', $status );
            $I->assertEquals( 401, $status );
            $I->assertEquals( 'KO', $r['status'] );

        }

        // un file che non corrisponde all'hash del manifest non si serve
        public function fileAlterato( BackendTester $I ) {

            list( $sorgente, $segreto ) = $this->pubblica( $I );

            file_put_contents( $this->cartella . 'TEST-E2E.bin', 'alterato', FILE_APPEND );

            $this->chiedi( $sorgente, $segreto, '&scarica=1', $status );
            $I->assertEquals( 503, $status );

        }

        /**
         * pubblica il materiale del test nella cartella della prima sorgente, o salta il test
         *
         */
        protected function pubblica( BackendTester $I ) {

            global $cf;

            if( empty( $cf['debug']['log']['remoti']['sorgenti'] ) ) {
                $I->markTestSkipped( 'il deploy non ha sorgenti in debug.log.remoti.sorgenti' );
            }

            foreach( $cf['debug']['log']['remoti']['sorgenti'] as $nome => $sorgente ) {
                if( ! empty( $sorgente['segreto'] ) ) {

                    $cartella = DIR_VAR_SPOOL . 'aggiornamenti/' . $nome . '/';

                    // un aggiornamento vero non si tocca
                    if( file_exists( $cartella . 'manifest.json' ) ) {
                        $I->markTestSkipped( 'la sorgente ' . $nome . ' ha gia\' un aggiornamento pubblicato' );
                    }

                    if( ! is_dir( $cartella ) ) {
                        mkdir( $cartella, 0775, true );
                    }
                    $this->cartella = $cartella;

                    file_put_contents( $cartella . 'TEST-E2E.bin', self::CONTENUTO );
                    file_put_contents( $cartella . 'manifest.json', json_encode( array(
                        'versione' => '0.0.0',
                        'file'     => 'TEST-E2E.bin',
                        'sha256'   => hash( 'sha256', self::CONTENUTO ),
                        'firma'    => 'TEST-E2E'
                    ) ) );

                    return array( $nome, $sorgente['segreto'] );

                }
            }

            $I->markTestSkipped( 'nessuna sorgente di debug.log.remoti.sorgenti ha il segreto' );

        }

        /**
         * chiede il manifest o il file come farebbe un software esterno
         *
         */
        protected function chiedi( $sorgente, $segreto, $extra, &$status, &$raw = NULL ) {

            global $cf;

            $status = NULL;

            return restCall( rtrim( $cf['site']['url'], '/' ) . '/api/aggiornamenti?sorgente=' . urlencode( $sorgente ) . $extra, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $status, array( 'gliswebLogKey' => $segreto ), NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw, $headers, 30 );

        }

        /**
         * toglie il materiale del test, e la cartella della sorgente se e' rimasta vuota
         *
         */
        protected function pulisci() {

            if( $this->cartella !== NULL ) {

                foreach( array( 'TEST-E2E.bin', 'manifest.json' ) as $file ) {
                    if( file_exists( $this->cartella . $file ) ) {
                        unlink( $this->cartella . $file );
                    }
                }

                if( is_dir( $this->cartella ) && count( scandir( $this->cartella ) ) == 2 ) {
                    rmdir( $this->cartella );
                }

                $this->cartella = NULL;

            }

        }

    }
