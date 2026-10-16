<?php

    /**
     * test della sicurezza degli account e dei test stessi
     *
     * controlla che i controller before della tabella account ( _0010.anagrafica e _AC000.account ) salvino la
     * password come hash, che non rifacciano l'hash di un hash quando girano tutti e due, e che senza password la
     * tolgano dai dati da scrivere; i controller si includono direttamente, cosi' il test gira anche dove i moduli
     * non sono attivi, e si saltano quelli che il deploy non ha ( la linea latest non ha _0010.anagrafica ); controlla infine che il bootstrap dei test si fermi, senza collegarsi a niente, se l'host
     * di produzione e' dato in GLISWEB_TEST_HOST, e che passi a DEV o TEST se lo ricava dalla cartella
     *
     */

    class accountSicurezzaCest {

        // controller before della tabella account, nell'ordine in cui li include la controller()
        protected $controller = array(
            '_mod/_0010.anagrafica/_src/_inc/_controllers/_account.before.php',
            '_mod/_AC000.account/_src/_inc/_controllers/_account.before.php'
        );

        // i controller presenti sul deploy
        public function _before( UnitTester $I ) {

            $this->controller = array_values( array_filter( $this->controller, function( $file ) { return file_exists( DIR_BASE . $file ); } ) );

        }

        // la password scritta dal form diventa un hash, con ciascuno dei controller e con tutti insieme
        public function hashDellaPassword( UnitTester $I ) {

            $password = bin2hex( random_bytes( 8 ) );

            if( empty( $this->controller ) ) {
                $I->markTestSkipped( 'il deploy non ha controller before per la tabella account' );
            }

            foreach( array_merge( array_chunk( array_keys( $this->controller ), 1 ), array( array_keys( $this->controller ) ) ) as $giro ) {

                $vs = array( 'username' => array( 's' => 'test' ), 'password' => array( 's' => $password ) );
                $ks = array( 'username', 'password' );

                foreach( $giro as $c ) {
                    $vs = $this->controller( $this->controller[ $c ], METHOD_POST, $vs, $ks );
                }

                $I->assertNotEquals( $password, $vs['password']['s'], 'la password e\' rimasta in chiaro' );
                $I->assertTrue( passwordVerify( $password, $vs['password']['s'] ), 'l\'hash non corrisponde alla password ( ' . implode( '+', $giro ) . ' )' );

            }

        }

        // senza password il campo esce dai dati da scrivere, e l'hash nel database resta quello di prima
        public function senzaPassword( UnitTester $I ) {

            foreach( $this->controller as $file ) {

                $vs = array( 'username' => array( 's' => 'test' ), 'password' => array( 's' => NULL ) );
                $ks = array( 'username', 'password' );

                $vs = $this->controller( $file, METHOD_UPDATE, $vs, $ks );

                $I->assertArrayNotHasKey( 'password', $vs, $file );
                $I->assertNotContains( 'password', $ks, $file );

            }

        }

        // il bootstrap dei test si ferma prima di ogni connessione se l'host di produzione e' dato esplicitamente
        public function bootstrapInProduzione( UnitTester $I ) {

            $host = $this->hostProduzione();

            if( empty( $host ) ) {
                $I->markTestSkipped( 'il deploy non ha un host di produzione configurato' );
            }

            exec( 'GLISWEB_TEST_HOST=' . escapeshellarg( $host ) . ' ' . escapeshellarg( PHP_BINARY ) . ' ' . escapeshellarg( DIR_BASE . '_usr/_test/_bootstrap.php' ) . ' 2>&1', $output, $esito );

            $I->assertEquals( 1, $esito, 'il bootstrap non si e\' fermato con l\'host ' . $host );
            $I->assertStringContainsString( 'e\' di produzione, i test non si eseguono', implode( PHP_EOL, $output ) );

        }

        // con l'host ricavato dalla cartella ( GLISWEB_TEST_AUTO ), un host di produzione diventa quello DEV o TEST dello stesso sito
        public function hostDallaCartella( UnitTester $I ) {

            $host = $this->hostProduzione( true );

            if( empty( $host ) ) {
                $I->markTestSkipped( 'il deploy non ha un sito con host di produzione e host DEV o TEST' );
            }

            // si simula una cartella col nome dell'host di produzione: GLISWEB_TEST_AUTO definita prima del bootstrap
            $codice = 'define( "GLISWEB_TEST_AUTO", true ); include ' . var_export( DIR_BASE . '_usr/_test/_bootstrap.php', true ) . '; echo PHP_EOL . "status:" . SITE_STATUS;';
            exec( 'GLISWEB_TEST_HOST=' . escapeshellarg( $host ) . ' ' . escapeshellarg( PHP_BINARY ) . ' -r ' . escapeshellarg( $codice ) . ' 2>&1', $output, $esito );

            $I->assertEquals( 0, $esito, implode( PHP_EOL, $output ) );
            $I->assertContains( end( $output ), array( 'status:' . DEVELOPEMENT, 'status:' . TESTING ), 'l\'host ' . $host . ' non e\' passato a DEV o TEST' );

        }

        /**
         * un host di produzione dalla configurazione del deploy
         *
         * @param       boolean     $alternativo    se vero, solo fra i siti che hanno anche un host DEV o TEST
         *
         * @return      string                      l'host, o NULL se non ce n'e'
         *
         */
        protected function hostProduzione( $alternativo = false ) {

            global $cf;

            foreach( $cf['sites'] as $site ) {
                if( ! empty( $site['domains'][ PRODUCTION ] ) && ( ! $alternativo || ! empty( $site['domains'][ DEVELOPEMENT ] ) || ! empty( $site['domains'][ TESTING ] ) ) ) {
                    return ( ( empty( $site['hosts'][ PRODUCTION ] ) ) ? NULL : $site['hosts'][ PRODUCTION ] . '.' ) . $site['domains'][ PRODUCTION ];
                }
            }

            return NULL;

        }

        /**
         * include un controller con le variabili che gli passa la controller()
         *
         * @param       string      $file           il percorso del controller, relativo a DIR_BASE
         * @param       string      $a              il metodo corrente
         * @param       array       $vs             i valori da scrivere
         * @param       array       $ks             le chiavi da scrivere
         *
         * @return      array                       i valori dopo il controller
         *
         */
        protected function controller( $file, $a, $vs, &$ks ) {

            $t = 'account';

            include DIR_BASE . $file;

            return $vs;

        }

    }
