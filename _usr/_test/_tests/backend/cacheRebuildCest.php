<?php

    /**
     * test della ricostruzione della cache ( /task/memcache.clean e /task/cache.rebuild )
     *
     * scritto il 12/11/2026 insieme a _src/_api/_task/_cache.rebuild.php: fino a quel giorno memcache.clean chiedeva la
     * ricostruzione forzata prima di controllare i privilegi, e anche un anonimo respinto faceva ricostruire pagine e sitemap
     * ( 10-17 secondi a richiesta su utensilerialughese ); la ricostruzione poi andava persa, perché il task svuotava la
     * cache subito dopo, e la rifaceva il primo visitatore
     *
     * i test verificano che l'anonimo sia respinto subito, che cache.rebuild non parta senza un gettone valido e che lo
     * consumi, e che dopo memcache.clean il report dica la ricostruzione riuscita e l'albero delle pagine sia già in cache
     *
     * gli status HTTP il browser non li espone, quindi le richieste senza sessione passano da restCall()
     *
     */

    class cacheRebuildCest {

        // un anonimo è respinto da memcache.clean senza far partire la ricostruzione
        public function anonimoRespintoSubito( BackendTester $I ) {

            $inizio = microtime( true );
            $I->assertEquals( 403, $this->chiama( '/task/memcache.clean', $raw ) );
            $I->assertLessThan( 3, microtime( true ) - $inizio, 'il 403 all\'anonimo arriva dopo la ricostruzione' );

        }

        // cache.rebuild senza gettone, o con un gettone che non esiste, risponde 403 prima del framework
        public function rebuildSenzaGettone( BackendTester $I ) {

            $I->assertEquals( 403, $this->chiama( '/task/cache.rebuild', $raw ) );
            $I->assertEquals( 403, $this->chiama( '/task/cache.rebuild?t=' . str_repeat( '0', 32 ), $raw ) );
            // un gettone con dentro un percorso lo ferma già Apache ( 400 ), altrimenti lo ferma il controllo del formato
            $I->assertContains( $this->chiama( '/task/cache.rebuild?t=../../../_config', $raw ), array( 400, 403 ) );

        }

        // il gettone vale una volta sola
        public function gettoneUsaEGetta( BackendTester $I ) {

            $gettone = bin2hex( random_bytes( 16 ) );

            $I->assertTrue( checkFolder( DIR_VAR_SPOOL_REBUILD ) && touch( DIR_VAR_SPOOL_REBUILD . $gettone ) );

            $I->assertEquals( 200, $this->chiama( '/task/cache.rebuild?t=' . $gettone, $raw ), 'la prima chiamata col gettone non riesce: ' . $raw );
            $I->assertTrue( json_decode( $raw, true )['esito'] );
            $I->assertEquals( 403, $this->chiama( '/task/cache.rebuild?t=' . $gettone, $raw ), 'il gettone è stato accettato due volte' );

        }

        // dopo memcache.clean il report dice la ricostruzione riuscita e l'albero delle pagine è già in cache
        public function ricostruzioneRiportata( BackendTester $I ) {

            global $cf;

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/task/memcache.clean' );

            $status = json_decode( $I->executeJS( 'return document.body.innerText;' ), true );

            $I->assertTrue( $status['esito'], 'memcache.clean non riuscito: ' . json_encode( $status ) );
            $I->assertGreaterThan( 0, $status['siti'][ SITE_CURRENT ]['ricostruzione']['pagine'] );
            $I->assertTrue( $status['siti'][ SITE_CURRENT ]['ricostruzione']['scrittura'] );

            // la prima richiesta dopo la pulizia trova l'albero già pronto; da qui si vede solo se il motore è memcache, perché
            // l'APCU di Apache da riga di comando non si vede
            if( $status['siti'][ SITE_CURRENT ]['ricostruzione']['motore'] === 'memcache' ) {
                $I->assertNotFalse( cacheRead( CONTENTS_PAGES_KEY ), 'dopo la pulizia l\'albero delle pagine non è in cache' );
            }

        }

        // con ?deploy=1 il report c'è per ogni sito del deploy, e dice com'è andata la ricostruzione di ciascuno
        public function ricostruzioneDeploy( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/task/memcache.clean?deploy=1' );

            $status = json_decode( $I->executeJS( 'return document.body.innerText;' ), true );

            $I->assertEquals( 'deploy', $status['portata'] );
            $I->assertNotEmpty( $status['siti'] );

            // un sito che non si raggiunge ( p.es. un host che non è nel DNS ) non si ricostruisce, ma il task lo svuota da sé e
            // lo dice in riserva: il test fallisce solo se un sito non è stato né ricostruito né svuotato
            foreach( $status['siti'] as $id => $sito ) {
                $I->assertTrue( ! empty( $sito['ricostruzione']['esito'] ) || isset( $sito['riserva'] ), 'il sito ' . $id . ' ( ' . $sito['fqdn'] . ' ) non è stato né ricostruito né svuotato: ' . json_encode( $sito ) );
                if( empty( $sito['ricostruzione']['esito'] ) ) {
                    $I->assertFalse( $status['esito'], 'un sito non ricostruito e l\'esito complessivo è positivo' );
                }
            }

        }

        /**
         * chiama un URL del sito senza sessione e ne restituisce lo status HTTP
         *
         * @param       string      $percorso       il percorso, a partire dalla radice del sito
         * @param       string      $raw            il corpo della risposta
         *
         * @return      int                         lo status HTTP
         *
         */
        protected function chiama( $percorso, &$raw ) {

            global $cf;

            $raw = NULL;
            $status = NULL;
            $headers = array();

            restCall( rtrim( $cf['site']['url'], '/' ) . $percorso, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, array(), NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw, $headers, 120 );

            return (int) $status;

        }

    }
