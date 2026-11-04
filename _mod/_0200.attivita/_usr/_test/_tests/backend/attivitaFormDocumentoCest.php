<?php

    /**
     * test della tendina documento nel form delle attivita'
     *
     * quando arriva attivita[id_documento] la tendina si riduce al documento indicato; fino al 2026-11-04 la query
     * filtrava documenti_view su id_documento, colonna che la vista non ha, e la tendina restava vuota
     * ( eurosnodi, 2026-11-03 )
     *
     */

    class attivitaFormDocumentoCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // toglie i documenti di test
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'documenti', 'nome' );

        }

        // col preset del documento la tendina contiene quel documento
        public function tendinaDocumentoPreimpostata( BackendTester $I ) {

            $documento = $I->haveInDatabase( 'documenti', array(
                'nome' => $I->grabTestName( 'documento' )
            ) );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'attivita.form', array( 'attivita' => array( 'id_documento' => $documento ) ) );

            $I->seeElementInDOM( 'select[name="attivita[id_documento]"] option[value="' . $documento . '"]' );

        }

    }
