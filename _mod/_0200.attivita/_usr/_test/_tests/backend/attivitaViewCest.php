<?php

    /**
     * test delle date nella vista delle attivita'
     *
     * dal 2026-09-22 _default.view.php converte gia' le date AAAA-MM-GG in GG/MM/AAAA, e le macro di vista che dopo
     * le ripassavano da date( 'd/m/Y', strtotime( ... ) ) leggevano GG/MM come MM/GG: col giorno sopra il 12 la data
     * diventava 01/01/1970, negli altri casi giorno e mese si scambiavano ( segnalato da polmasi il 2026-10-29 su
     * _0630.iscrizioni ); la stessa riconversione stava in diciannove macro di nove moduli, e questo test la prova su
     * attivita.view, che mostra sia data_programmazione sia data_attivita
     *
     */

    class attivitaViewCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // toglie le attivita' di test, dalla statica e dalla tabella
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'attivita_view_static', 'nome' );
            $I->deleteTestRecords( 'attivita', 'nome' );

        }

        // le date escono una volta sola in GG/MM/AAAA, col giorno sopra e sotto il 12
        public function dateNonRiconvertite( BackendTester $I ) {

            // giorno sopra il 12: riconvertita diventava 01/01/1970; la vista ordina per data_attivita crescente, e una
            // data del 2000 tiene la riga nella prima pagina
            $attivita = $I->haveInDatabase( 'attivita', array(
                'nome' => $I->grabTestName( 'date' ),
                'data_attivita' => '2000-09-24'
            ) );
            $I->haveInStaticView( 'attivita', $attivita );

            // giorno fino al 12: riconvertita scambiava giorno e mese
            $attivita = $I->haveInDatabase( 'attivita', array(
                'nome' => $I->grabTestName( 'date' ),
                'data_programmazione' => '2026-10-05'
            ) );
            $I->haveInStaticView( 'attivita', $attivita );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'attivita.view' );

            $I->see( '24/09/2000' );
            $I->see( '05/10/2026' );
            $I->dontSee( '01/01/1970' );
            $I->dontSee( '10/05/2026' );

        }

    }
