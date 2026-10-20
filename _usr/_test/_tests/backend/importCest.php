<?php

    /**
     * test dell'importazione dei CSV dallo spool
     *
     * verifica che un CSV lungo non si elabori in una richiesta sola ( _740.controller.php lo spezza in parti con
     * csvFileSplit() e manda l'originale in done/ ) e che ogni parte passi in done/ solo dopo che la controller()
     * l'ha scritta ( _750.controller.php ); l'importazione la innesca il report /_src/_api/_report/_import.php, che
     * gira come il cron
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

        // pulizia prima e dopo ogni test
        public function _before( BackendTester $I ) {
            $this->pulisci( $I );
        }

        public function _after( BackendTester $I ) {
            $this->pulisci( $I );
        }

        // un CSV oltre la soglia si spezza in parti, e ogni parte si archivia solo dopo essere stata scritta
        public function importazioneSpezzata( BackendTester $I ) {

            $righe = array( 'nome' );
            for( $i = 1; $i <= self::RIGHE; $i++ ) {
                $righe[] = 'TEST-E2E-import-' . $i;
            }
            $this->scrivi( DIR_VAR_SPOOL_IMPORT . self::FILE, implode( PHP_EOL, $righe ) . PHP_EOL );

            // primo giro: il file si spezza e l'originale va in done/, senza scrivere niente
            $this->importa();
            $I->assertFileDoesNotExist( DIR_VAR_SPOOL_IMPORT . self::FILE );
            $I->assertFileExists( DIR_VAR_SPOOL_IMPORT . '99.post.test.parte.0001.csv' );
            $I->assertFileExists( DIR_VAR_SPOOL_IMPORT . '99.post.test.parte.0002.csv' );
            $I->assertCount( 1, glob( DIR_VAR_SPOOL_IMPORT_DONE . '*/' . self::FILE ) );
            $I->assertEquals( 0, $this->conta( $I ) );

            // secondo giro: la prima parte si scrive e si archivia, la seconda aspetta ( collisione di tabelle )
            $this->importa();
            $I->assertEquals( 1000, $this->conta( $I ) );
            $I->assertFileDoesNotExist( DIR_VAR_SPOOL_IMPORT . '99.post.test.parte.0001.csv' );
            $I->assertFileExists( DIR_VAR_SPOOL_IMPORT . '99.post.test.parte.0002.csv' );

            // terzo giro: la seconda parte
            $this->importa();
            $I->assertEquals( self::RIGHE, $this->conta( $I ) );
            $I->assertCount( 0, glob( DIR_VAR_SPOOL_IMPORT . '99.post.test*.csv' ) );
            $I->assertCount( 3, glob( DIR_VAR_SPOOL_IMPORT_DONE . '*/99.post.test*.csv' ) );

        }

        /**
         * innesca un giro di importazione come farebbe il cron
         *
         */
        protected function importa() {

            global $cf;

            $raw = NULL;
            $status = NULL;

            restCall( rtrim( $cf['site']['url'], '/' ) . '/_src/_api/_report/_import.php', METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, array(), NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw, $headers, 120 );

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
