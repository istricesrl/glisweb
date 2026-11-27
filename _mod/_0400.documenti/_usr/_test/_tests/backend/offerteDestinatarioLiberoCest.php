<?php

    /**
     * test del destinatario in testo libero nella scheda dell'offerta
     *
     * dal 2026-11-24 documenti.destinatario tiene il destinatario di chi non è in anagrafica ( patch 202611241900 ),
     * e il flag documenti.destinatario.libero lo espone nel form delle offerte; il test vale con tutt'e due i valori del
     * flag: spento, il campo non c'è e il cliente resta obbligatorio; acceso, il cliente diventa facoltativo e l'offerta
     * si salva col solo testo, che documenti_view restituisce come destinatario
     *
     */

    class offerteDestinatarioLiberoCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $I->deleteTestRecords( 'documenti', 'nome' );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $I->deleteTestRecords( 'documenti', 'nome' );

        }

        // il campo c'è solo col flag acceso, e col flag acceso l'offerta si salva senza cliente
        public function destinatarioInTestoLibero( BackendTester $I ) {

            $nome = $I->grabTestName( 'destinatario libero' );
            $testo = "Officina Prova srl\nvia delle Prove 1\n48022 Lugo RA";

            $I->amLoggedInAs( 'roots' );

            $I->amOnPageId( 'offerte.commerciale.form' );
            $I->seeElement( '#form-documenti' );

            // flag spento: niente campo, e il cliente resta obbligatorio; il selectBox e' un campo nascosto piu' la casella
            // visibile, ed e' la casella a portare required
            if( ! $I->executeJS( 'return $( "textarea#documenti_destinatario" ).length;' ) ) {
                $I->seeElementInDOM( '#documenti_id_destinatario_inputbox[required]' );
                return;
            }

            // flag acceso: il cliente non è più obbligatorio
            $I->dontSeeElementInDOM( '#documenti_id_destinatario_inputbox[required]' );

            $I->executeJS( '$( "#documenti_destinatario" ).val( ' . json_encode( $testo ) . ' );'
                         . '$( "#documenti_nome" ).val( ' . json_encode( $nome ) . ' );'
                         . 'submitFormOkay = true; $( "#form-documenti" ).get( 0 ).submit();' );
            $I->waitForJS( 'return $( "#id" ).length && $( "#id" ).val() != "";', 15 );

            $I->assertNull( $I->grabFromDatabase( 'SELECT id_destinatario FROM documenti WHERE nome = ?', array( $nome ) ) );
            $I->assertEquals( $testo, str_replace( "\r\n", "\n", $I->grabFromDatabase( 'SELECT destinatario FROM documenti WHERE nome = ?', array( $nome ) ) ) );
            $I->assertEquals( $testo, str_replace( "\r\n", "\n", $I->grabFromDatabase( 'SELECT destinatario FROM documenti_view WHERE nome = ?', array( $nome ) ) ) );

        }

    }
