<?php

    /**
     * test del task report.corsi.popolazione
     *
     * fino al 2026-10-26 il task girava a rotazione su tutti i progetti con la colonna
     * progetti.timestamp_aggiornamento_report_corsi, che il canone non ha: su un database nato dal canone ogni chiamata
     * si fermava con 1054; adesso sceglie il progetto cambiato dopo la sua riga di report, o che la riga non ce l'ha
     *
     * il progetto si scrive nel database e si riconosce dal nome, col prefisso TEST-E2E-; la sua riga di report se ne va
     * con lui, perche' cleanReportCorsi() toglie le righe dei progetti che non ci sono piu'
     *
     */

    class reportCorsiPopolazioneCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $I->deleteTestRecords( 'progetti', 'nome' );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $I->deleteTestRecords( 'progetti', 'nome' );

        }

        // il progetto nuovo entra nel report, e alla chiamata dopo non viene ripreso
        public function progettoNuovoNelReport( BackendTester $I ) {

            // la tabella del report e' nei file base dal 2026-10-26: ai database installati prima la porta la migrazione
            // del canone, e finche' non c'e' il task non ha dove scrivere
            if( ! $I->grabFromDatabase( 'SELECT count(*) FROM information_schema.tables WHERE table_schema = database() AND table_name = "__report_corsi__"' ) ) {
                $I->markTestSkipped( 'il database non ha __report_corsi__' );
            }

            $progetto = $I->haveInDatabase( 'progetti', array(
                'nome' => $I->grabTestName( 'corso' ),
                'timestamp_aggiornamento' => time()
            ) );

            $I->amLoggedInAs( 'roots' );

            $I->amOnPage( '/task/0920.corsi/report.corsi.popolazione' );
            $I->seeInDatabase( '__report_corsi__', array( 'id' => $progetto ) );

            $I->amOnPage( '/task/0920.corsi/report.corsi.popolazione' );
            $I->dontSee( '"' . $progetto . '"' );

        }

    }
