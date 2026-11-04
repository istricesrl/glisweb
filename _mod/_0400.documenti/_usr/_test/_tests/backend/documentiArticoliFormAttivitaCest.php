<?php

    /**
     * test della scheda attivita' di una riga di documento
     *
     * fino al 2026-11-04 la macro della scheda chiedeva ad attivita_view note_programmazione, note_interne, testo e
     * id_documenti_articoli, che la vista non ha, e la pagina si fermava con un 1054 ( polmasi, 2026-11-04 ); in piu'
     * il template della scheda non esisteva; un'attivita' appartiene alla riga attraverso la sua todo, e questo test
     * prova che la scheda mostra quelle e non le altre
     *
     */

    class documentiArticoliFormAttivitaCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // toglie i record di test, dalle foglie verso il documento
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'attivita_view_static', 'nome' );
            $I->deleteTestRecords( 'attivita', 'nome' );
            $I->deleteTestRecords( 'todo', 'nome' );
            $I->deleteTestRecords( 'documenti_articoli', 'nome' );
            $I->deleteTestRecords( 'documenti', 'nome' );

        }

        // la scheda si apre e mostra le attivita' delle todo della riga, non le altre
        public function attivitaDellaRiga( BackendTester $I ) {

            $documento = $I->haveInDatabase( 'documenti', array(
                'nome' => $I->grabTestName( 'documento' )
            ) );

            $riga = $I->haveInDatabase( 'documenti_articoli', array(
                'id_documento' => $documento,
                'nome' => $I->grabTestName( 'riga' )
            ) );

            $todo = $I->haveInDatabase( 'todo', array(
                'id_documenti_articoli' => $riga,
                'nome' => $I->grabTestName( 'todo' )
            ) );

            // attivita' della riga, attraverso la todo
            $attivita = $I->haveInDatabase( 'attivita', array(
                'id_todo' => $todo,
                'nome' => $I->grabTestName( 'della riga' ),
                'data_programmazione' => '2026-11-24'
            ) );
            $I->haveInStaticView( 'attivita', $attivita );

            // attivita' senza todo, che nella scheda non deve comparire
            $attivita = $I->haveInDatabase( 'attivita', array(
                'nome' => $I->grabTestName( 'estranea' ),
                'data_programmazione' => '2026-11-25'
            ) );
            $I->haveInStaticView( 'attivita', $attivita );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'documenti.articoli.form.attivita', array( 'documenti_articoli' => array( 'id' => $riga ) ) );

            $I->see( '24/11/2026' );
            $I->dontSee( '25/11/2026' );

        }

    }
