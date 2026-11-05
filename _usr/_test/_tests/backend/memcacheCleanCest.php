<?php

    /**
     * test del task memcache.clean sulla cache su disco
     *
     * scritto il 05/11/2026 insieme a _src/_lib/_cache.utils.php: quando manca memcache l'albero delle pagine finisce
     * nell'APCU o su disco ( var/spool/cache/ ), e il task deve svuotare anche quelli, altrimenti una modifica ai file di
     * definizione delle pagine non si vede; la portata resta quella del task, il sito corrente senza parametri
     *
     * le chiavi di prova si scrivono da qui con diskWrite(): il bootstrap dei test usa lo stesso host delle pagine, quindi
     * il seme del sito è lo stesso; l'APCU di Apache da qui non si vede, e la prova la fa cacheUtilsCest ( unit )
     *
     */

    class memcacheCleanCest {

        // chiave di prova
        protected $chiave = 'TEST-E2E-MEMCACHE-CLEAN';

        // un sito che non è del deploy
        protected $altro = 'altro.sito.test';

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulizia();

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulizia();

        }

        // toglie le chiavi di prova
        protected function pulizia() {

            diskDelete( $this->chiave );
            diskDelete( $this->chiave, $this->altro );

        }

        // senza parametri il task toglie dal disco le chiavi del sito corrente e lascia quelle degli altri siti
        public function discoDelSitoSvuotato( BackendTester $I ) {

            $I->assertTrue( diskWrite( $this->chiave, 'TEST' ) );
            $I->assertTrue( diskWrite( $this->chiave, 'TEST', 0, $this->altro ) );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/task/memcache.clean' );
            $I->see( '"disk"' );

            // il file lo toglie il processo di Apache: la cache di stat() di questo processo non lo sa
            clearstatcache();
            $I->assertFalse( diskRead( $this->chiave ), 'la chiave del sito corrente non c\'è più' );
            $I->assertEquals( 'TEST', diskRead( $this->chiave, $this->altro ), 'la chiave dell\'altro sito resta' );

        }

    }
