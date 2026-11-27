<?php

    /**
     * test dell'importazione dei CSV dallo spool
     *
     * verifica che un CSV lungo non si elabori in una richiesta sola ( _740.controller.php lo spezza in parti con
     * csvFileSplit() e manda l'originale in done/ ), che ogni parte passi in done/ solo dopo che la controller()
     * l'ha scritta ( _750.controller.php ) e che due giri concorrenti non importino gli stessi file ( il lock
     * FILE_IMPORT_LOCK ); l'importazione la innesca il report /_src/_api/_report/_import.php, che gira come il cron
     *
     * il cron di sistema importa dallo stesso spool mentre il test gira, quindi il test non conta giro per giro:
     * fino al 12/11/2026 si aspettava 0, 1000 e 1500 righe dopo il primo, il secondo e il terzo giro, e su
     * utensilerialughese il giro del cron fra due giri del test ne ha fatte 1533. Si verifica il risultato finale,
     * e il lock lo si prende dal test
     *
     * le righe vanno nella tabella test, col nome che comincia con TEST-E2E-, e i file restano nello spool e in done/
     * solo per la durata del test
     *
     */

    class importCest {

        // nome del file da importare
        const FILE = '99.post.test.csv';

        // righe del file, una parte e mezza con la soglia di default
        const RIGHE = 1500;

        // giri di importazione oltre i quali il file si considera bloccato
        const GIRI = 8;

        // il lock preso dal test, che _after() rilascia anche se il test fallisce
        protected $lock = false;

        // pulizia prima e dopo ogni test
        public function _before( BackendTester $I ) {
            $this->pulisci( $I );
        }

        public function _after( BackendTester $I ) {
            $this->rilascia();
            $this->pulisci( $I );
        }

        // un CSV oltre la soglia si spezza in parti, ogni parte si archivia dopo essere stata scritta, e nessuna riga si
        // scrive due volte, chiunque abbia fatto i giri
        public function importazioneSpezzata( BackendTester $I ) {

            $this->richiediSegreto( $I );

            $this->scrivi( DIR_VAR_SPOOL_IMPORT . self::FILE, $this->csv( self::RIGHE ) );

            // giri finché nello spool non resta niente del test
            for( $i = 0; $i < self::GIRI && count( glob( DIR_VAR_SPOOL_IMPORT . '99.post.test*.csv' ) ); $i++ ) {
                $this->importa();
            }

            $I->assertCount( 0, glob( DIR_VAR_SPOOL_IMPORT . '99.post.test*.csv' ), 'dopo ' . self::GIRI . ' giri restano file del test nello spool' );

            // l'originale e le due parti
            $I->assertCount( 1, glob( DIR_VAR_SPOOL_IMPORT_DONE . '*/' . self::FILE ) );
            $I->assertCount( 3, glob( DIR_VAR_SPOOL_IMPORT_DONE . '*/99.post.test*.csv' ) );

            // nessuna riga doppia
            $I->assertEquals( self::RIGHE, $this->conta( $I ) );

        }

        // mentre un altro giro tiene il lock un giro non importa niente, e appena il lock si libera l'importazione riparte
        public function lockFermaIlGiroConcorrente( BackendTester $I ) {

            $this->richiediSegreto( $I );

            // il lock lo prende il test, aspettando il giro del cron se lo tiene lui
            $I->assertTrue( $this->prendi(), 'il lock dell\'importazione non si libera' );

            $this->scrivi( DIR_VAR_SPOOL_IMPORT . self::FILE, $this->csv( 10 ) );

            $raw = $this->importa();
            $I->assertStringContainsString( 'importazione in corso in un altro giro, salto', (string) $raw );
            $I->assertFileExists( DIR_VAR_SPOOL_IMPORT . self::FILE );
            $I->assertEquals( 0, $this->conta( $I ) );

            // libero il lock e l'importazione riparte
            $this->rilascia();
            for( $i = 0; $i < self::GIRI && file_exists( DIR_VAR_SPOOL_IMPORT . self::FILE ); $i++ ) {
                $this->importa();
            }
            $I->assertFileDoesNotExist( DIR_VAR_SPOOL_IMPORT . self::FILE );
            $I->assertEquals( 10, $this->conta( $I ) );

        }

        /**
         * senza la chiave _740.controller.php scarta ogni riga per chiave di sicurezza mancante
         *
         */
        protected function richiediSegreto( BackendTester $I ) {

            global $cf;

            if( empty( $cf['auth']['import']['secret'] ) ) {
                $I->markTestSkipped( 'il deploy non ha auth.import.secret' );
            }

        }

        /**
         * il testo di un CSV di test con $n righe di dati
         *
         */
        protected function csv( $n ) {

            $righe = array( 'nome' );
            for( $i = 1; $i <= $n; $i++ ) {
                $righe[] = 'TEST-E2E-import-' . $i;
            }

            return implode( PHP_EOL, $righe ) . PHP_EOL;

        }

        /**
         * innesca un giro di importazione come farebbe il cron, e ne restituisce il report
         *
         */
        protected function importa() {

            global $cf;

            $raw = NULL;
            $status = NULL;

            restCall( rtrim( $cf['site']['url'], '/' ) . '/_src/_api/_report/_import.php', METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, array(), NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw, $headers, 120 );

            return $raw;

        }

        /**
         * prende il lock dell'importazione come un giro del cron, aspettando fino a un minuto che lo lasci chi lo tiene
         *
         */
        protected function prendi() {

            $nuovo = ! file_exists( FILE_IMPORT_LOCK );

            $this->lock = @fopen( FILE_IMPORT_LOCK, 'c' );
            if( $this->lock === false ) {
                return false;
            }

            // il file creato dal test deve restare apribile da Apache
            if( $nuovo && function_exists( 'posix_getuid' ) && posix_getuid() === 0 ) {
                chown( FILE_IMPORT_LOCK, 'www-data' );
                chgrp( FILE_IMPORT_LOCK, 'www-data' );
            }

            for( $i = 0; $i < 60; $i++ ) {
                if( flock( $this->lock, LOCK_EX | LOCK_NB ) ) {
                    return true;
                }
                sleep( 1 );
            }

            $this->rilascia();

            return false;

        }

        /**
         * rilascia il lock preso dal test
         *
         */
        protected function rilascia() {

            if( $this->lock !== false ) {
                flock( $this->lock, LOCK_UN );
                fclose( $this->lock );
                $this->lock = false;
            }

        }

        /**
         * scrive un file nello spool, leggibile e spostabile da Apache
         *
         */
        protected function scrivi( $file, $testo ) {

            file_put_contents( $file, $testo );

            if( function_exists( 'posix_getuid' ) && posix_getuid() === 0 ) {
                chown( $file, 'www-data' );
                chgrp( $file, 'www-data' );
            }

        }

        /**
         * conta le righe di test importate
         *
         */
        protected function conta( BackendTester $I ) {

            global $cf;

            return (int) mysqlSelectValue( $cf['mysql']['connection'], 'SELECT count(*) FROM test WHERE nome LIKE ?', array( array( 's' => 'TEST-E2E-import-%' ) ) );

        }

        /**
         * toglie le righe di test e i file del test dallo spool e da done/
         *
         */
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'test', 'nome' );

            foreach( array_merge( glob( DIR_VAR_SPOOL_IMPORT . '99.post.test*.csv' ), glob( DIR_VAR_SPOOL_IMPORT_DONE . '*/99.post.test*.csv' ) ) as $file ) {
                unlink( $file );
            }

        }

    }
