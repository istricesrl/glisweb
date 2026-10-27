<?php

    /**
     * test di numero_posti in __report_lezioni_corsi__
     *
     * fino al 2026-10-27 updateReportLezioniCorsi() scriveva '∞' in numero_posti, che e' int, quando il corso aveva il
     * metadato iscritti_max senza testo: con lo strict mode l'INSERT si fermava con 1366 e la lezione restava fuori dal
     * report ( polmasi, 27/10 ); adesso numero_posti e' NULL e l'infinito resta nella sola etichetta posti_disponibili
     *
     * corso e lezione si scrivono nel database e si riconoscono dal prefisso TEST-E2E-; il metadato se ne va col
     * progetto, la riga di report si toglie per codice
     *
     */

    class reportLezioniCorsiPostiCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $I->deleteTestRecords( '__report_lezioni_corsi__', 'codice' );
            $I->deleteTestRecords( 'todo', 'nome' );
            $I->deleteTestRecords( 'progetti', 'nome' );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $I->deleteTestRecords( '__report_lezioni_corsi__', 'codice' );
            $I->deleteTestRecords( 'todo', 'nome' );
            $I->deleteTestRecords( 'progetti', 'nome' );

        }

        // un corso con iscritti_max senza testo e' senza limite: la lezione entra nel report con numero_posti NULL
        public function lezioneSenzaLimiteDiPosti( BackendTester $I ) {

            if( ! $I->grabFromDatabase( 'SELECT count(*) FROM information_schema.tables WHERE table_schema = database() AND table_name = "__report_lezioni_corsi__"' ) ) {
                $I->markTestSkipped( 'il database non ha __report_lezioni_corsi__' );
            }

            $tipologia = $I->grabFromDatabase( 'SELECT id FROM tipologie_todo WHERE id_genitore = 6 ORDER BY id LIMIT 1' );

            if( ! $tipologia ) {
                $I->markTestSkipped( 'il database non ha tipologie di lezione ( tipologie_todo figlie della 6 )' );
            }

            $progetto = $I->haveInDatabase( 'progetti', array(
                'nome' => $I->grabTestName( 'corso' ),
                'timestamp_aggiornamento' => time()
            ) );

            $I->haveInDatabase( 'metadati', array(
                'id_progetto' => $progetto,
                'nome' => 'iscritti_max',
                'testo' => NULL
            ) );

            $lezione = $I->haveInDatabase( 'todo', array(
                'id_progetto' => $progetto,
                'id_tipologia' => $tipologia,
                'nome' => $I->grabTestName( 'lezione' ),
                'codice' => $I->grabTestName( 'lezione' )
            ) );

            $I->amLoggedInAs( 'roots' );

            $I->amOnPage( '/task/0920.corsi/report.lezioni.corsi.popolazione?id=' . $lezione );
            $I->seeInDatabase( '__report_lezioni_corsi__', array( 'id' => $lezione ) );

            // seeInDatabase() confronta con =, che su NULL non trova niente
            $I->assertEquals( 1, $I->grabFromDatabase( 'SELECT count(*) FROM __report_lezioni_corsi__ WHERE id = ? AND numero_posti IS NULL', array( $lezione ) ) );

        }

    }
