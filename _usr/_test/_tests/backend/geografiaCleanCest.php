<?php

    /**
     * test del task geografia.clean
     *
     * scritto il 25/11/2026 con la correzione del task: guardava solo indirizzi.id_comune, e dal 10/07/2026 la fonte
     * degli indirizzi e' anagrafica_indirizzi; su utensilerialughese avrebbe cancellato 18.905 comuni su 20.130
     *
     * il task si prova SOLO in anteprima ( dryrun=1 ): lanciato davvero cancellerebbe la geografia del deploy di test
     *
     */

    class geografiaCleanCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $I->deleteTestRecords( 'anagrafica_indirizzi', 'codice' );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $I->deleteTestRecords( 'anagrafica_indirizzi', 'codice' );

        }

        // lancia l'anteprima e ne restituisce il risultato
        protected function anteprima( BackendTester $I ) {

            $I->amOnPage( '/task/geografia.clean?dryrun=1' );

            return json_decode( $I->executeJS( 'return document.body.innerText;' ), true );

        }

        // un comune citato solo da anagrafica_indirizzi non e' piu' da cancellare
        public function comuneDiAnagraficaIndirizziSalvo( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );

            $prima = $this->anteprima( $I );
            $I->assertContains( 'anagrafica_indirizzi.id_comune', $prima['riferimenti']['comuni'] );
            $I->assertNotEmpty( $prima['esempi']['comuni'], 'nel deploy di test serve almeno un comune non citato' );

            // cito il primo comune che il task cancellerebbe
            $idComune = $prima['esempi']['comuni'][0];
            $I->haveInDatabase( 'anagrafica_indirizzi', array(
                'codice' => $I->grabTestName( 'geo' ),
                'id_comune' => $idComune
            ) );

            $dopo = $this->anteprima( $I );
            $I->assertEquals( $prima['da cancellare']['comuni'] - 1, $dopo['da cancellare']['comuni'] );
            $I->assertNotContains( $idComune, $dopo['esempi']['comuni'] );

        }

    }
