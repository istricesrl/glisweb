<?php

    /**
     * test della raccolta dei log remoti
     *
     * verifica che /api/log ( _src/_api/_log.php ) scriva le righe di una sorgente dichiarata in
     * var/log/remoti/<host>/, una per file di livello, e che rifiuti un segreto sbagliato, un host che prova a
     * uscire dalla cartella e un invio con troppe righe; i messaggi su piu' righe o che somigliano a un attacco viaggiano
     * in base64, come li manda il software, perche' ModSecurity li fermerebbe prima dell'endpoint
     *
     * la sorgente e' la prima di debug.log.remoti.sorgenti del deploy; l'host e' TEST-E2E-log, e la sua cartella
     * resta in var/log/remoti/ solo per la durata del test
     *
     */

    class logCest {

        // host del test
        const HOST = 'TEST-E2E-log';

        // pulizia prima e dopo ogni test
        public function _before( BackendTester $I ) {
            $this->pulisci();
        }

        public function _after( BackendTester $I ) {
            $this->pulisci();
        }

        // le righe valide si scrivono nel file del loro livello, le malformate si contano come scartate
        public function scritturaRighe( BackendTester $I ) {

            list( $sorgente, $segreto ) = $this->sorgente( $I );

            $r = $this->invia( $sorgente, $segreto, self::HOST, array(
                array( 'livello' => 'info', 'data' => '2026-10-26 18:00:00', 'codifica' => 'base64', 'messaggio' => base64_encode( "TEST-E2E prova\nsu due righe" ) ),
                array( 'livello' => 3, 'canale' => 'socket', 'messaggio' => 'TEST-E2E errore' ),
                array( 'livello' => 'inesistente', 'messaggio' => 'TEST-E2E scartata' )
            ), $status );

            $I->assertEquals( 200, $status );
            $I->assertEquals( 'OK', $r['status'] );
            $I->assertEquals( 2, $r['scritte'] );
            $I->assertEquals( 1, $r['scartate'] );

            // la data del mittente fra parentesi quadre, e il messaggio su una riga sola
            $info = DIR_VAR_LOG . 'remoti/' . self::HOST . '/' . $sorgente . '.info.' . date( 'Ym' ) . '.log';
            $I->assertFileExists( $info );
            $I->assertStringContainsString( '[2026-10-26 18:00:00] TEST-E2E prova su due righe', file_get_contents( $info ) );
            $I->assertFileExists( DIR_VAR_LOG . 'remoti/' . self::HOST . '/' . $sorgente . '.socket.err.' . date( 'Ym' ) . '.log' );

        }

        // in base64 passa anche quello che ModSecurity prenderebbe per un attacco, e si scrive in chiaro; una base64 non valida o una codifica sconosciuta scartano la riga
        public function messaggiCodificati( BackendTester $I ) {

            list( $sorgente, $segreto ) = $this->sorgente( $I );

            $r = $this->invia( $sorgente, $segreto, self::HOST, array(
                array( 'livello' => 'warning', 'codifica' => 'base64', 'messaggio' => base64_encode( "TEST-E2E ../../etc/passwd; rm -rf /tmp/x\nriga due" ) ),
                array( 'livello' => 'warning', 'codifica' => 'base64', 'messaggio' => 'TEST-E2E non e\' base64!' ),
                array( 'livello' => 'warning', 'codifica' => 'rot13', 'messaggio' => 'GRFG-R2R' )
            ), $status );

            $I->assertEquals( 200, $status );
            $I->assertEquals( 1, $r['scritte'] );
            $I->assertEquals( 2, $r['scartate'] );

            $warning = DIR_VAR_LOG . 'remoti/' . self::HOST . '/' . $sorgente . '.warning.' . date( 'Ym' ) . '.log';
            $I->assertFileExists( $warning );
            $I->assertStringContainsString( 'TEST-E2E ../../etc/passwd; rm -rf /tmp/x riga due', file_get_contents( $warning ) );

        }

        // un segreto sbagliato non scrive niente
        public function segretoSbagliato( BackendTester $I ) {

            list( $sorgente, $segreto ) = $this->sorgente( $I );

            $r = $this->invia( $sorgente, 'TEST-E2E-sbagliato', self::HOST, array(
                array( 'livello' => 'info', 'messaggio' => 'TEST-E2E rifiutata' )
            ), $status );

            $I->assertEquals( 401, $status );
            $I->assertEquals( 'KO', $r['status'] );
            $I->assertDirectoryDoesNotExist( DIR_VAR_LOG . 'remoti/' . self::HOST );

        }

        // un host che non e' un nome valido non diventa un percorso, e oltre il limite di righe non si scrive
        public function ingressiNonValidi( BackendTester $I ) {

            list( $sorgente, $segreto ) = $this->sorgente( $I );

            // NOTA non '../' davanti all'host: dove c'e' il Core Rule Set lo ferma ModSecurity ( 930110 ) prima dell'endpoint
            $r = $this->invia( $sorgente, $segreto, 'sottocartella/' . self::HOST, array(
                array( 'livello' => 'info', 'canale' => 'TEST-E2E', 'messaggio' => 'TEST-E2E host non valido' )
            ), $status );

            // la riga finisce nella cartella dell'IP, col canale del test
            $I->assertEquals( 200, $status );
            $I->assertDirectoryDoesNotExist( DIR_VAR_LOG . self::HOST );
            $I->assertCount( 1, glob( DIR_VAR_LOG . 'remoti/*/' . $sorgente . '.TEST-E2E.info.*.log' ) );

            $righe = array_fill( 0, 101, array( 'livello' => 'info', 'messaggio' => 'TEST-E2E troppe' ) );
            $r = $this->invia( $sorgente, $segreto, self::HOST, $righe, $status );

            $I->assertEquals( 400, $status );
            $I->assertDirectoryDoesNotExist( DIR_VAR_LOG . 'remoti/' . self::HOST );

        }

        /**
         * prima sorgente dichiarata nel deploy, o test saltato
         *
         */
        protected function sorgente( BackendTester $I ) {

            global $cf;

            if( empty( $cf['debug']['log']['remoti']['sorgenti'] ) ) {
                $I->markTestSkipped( 'il deploy non ha sorgenti in debug.log.remoti.sorgenti' );
            }

            foreach( $cf['debug']['log']['remoti']['sorgenti'] as $nome => $sorgente ) {
                if( ! empty( $sorgente['segreto'] ) ) {
                    return array( $nome, $sorgente['segreto'] );
                }
            }

            $I->markTestSkipped( 'nessuna sorgente di debug.log.remoti.sorgenti ha il segreto' );

        }

        /**
         * manda un gruppo di righe a /api/log come farebbe un software esterno
         *
         */
        protected function invia( $sorgente, $segreto, $host, $righe, &$status ) {

            global $cf;

            $raw = NULL;
            $status = NULL;

            return restCall( rtrim( $cf['site']['url'], '/' ) . '/api/log', METHOD_POST, array( 'sorgente' => $sorgente, 'host' => $host, 'righe' => $righe ), MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $status, array( 'gliswebLogKey' => $segreto ), NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw, $headers, 30 );

        }

        /**
         * toglie la cartella dell'host del test e i file del canale del test nelle cartelle degli IP
         *
         */
        protected function pulisci() {

            foreach( array_merge( glob( DIR_VAR_LOG . 'remoti/' . self::HOST . '/*' ), glob( DIR_VAR_LOG . 'remoti/*/*.TEST-E2E.*.log' ) ) as $file ) {
                unlink( $file );
            }

            if( is_dir( DIR_VAR_LOG . 'remoti/' . self::HOST ) ) {
                rmdir( DIR_VAR_LOG . 'remoti/' . self::HOST );
            }

        }

    }
