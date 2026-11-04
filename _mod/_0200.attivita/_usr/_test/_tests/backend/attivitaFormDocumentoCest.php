<?php

    /**
     * test della tendina documento nel form delle attivita'
     *
     * aprendo un'attivita' che ha un documento la tendina si riduce a quel documento; fino al 2026-11-04 la query
     * filtrava documenti_view su id_documento, colonna che la vista non ha, e la tendina restava vuota
     * ( eurosnodi, 2026-11-03 )
     *
     * la tendina passa da REST ( api documenti ): frm.selectBox non scrive un select con le option ma un input
     * nascosto, col documento in value e la sua etichetta in placeholder-api; se la query non trova il documento la
     * macro ripiega sull'id, quindi si guarda l'etichetta. Il documento ha tipologia e data perché senza __label__ è
     * NULL ( concat su sigla e data ) e il ripiego sull'id non si distinguerebbe dall'errore. Il documento si passa
     * con l'attivita' salvata e non in GET come attivita[id_documento]: quello _750.controller.php lo rilegge come
     * blocco dati e lo svuota, i preset passano da __preset__
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

        // toglie i record di test, dall'attivita' verso il documento
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'attivita_view_static', 'nome' );
            $I->deleteTestRecords( 'attivita', 'nome' );
            $I->deleteTestRecords( 'documenti', 'nome' );

        }

        // un'attivita' con un documento si apre col documento nella tendina, con la sua etichetta
        public function tendinaDocumentoPreimpostata( BackendTester $I ) {

            $tipologia = $I->grabFromDatabase( 'SELECT id FROM tipologie_documenti ORDER BY id LIMIT 1' );
            $I->assertNotEmpty( $tipologia, 'serve almeno una tipologia di documento' );

            $documento = $I->haveInDatabase( 'documenti', array(
                'nome' => $I->grabTestName( 'documento' ),
                'id_tipologia' => $tipologia,
                'numero' => '1',
                'data' => date( 'Y-m-d' )
            ) );

            $etichetta = $I->grabFromDatabase( 'SELECT __label__ FROM documenti_view WHERE id = ?', array( $documento ) );
            $I->assertNotEmpty( $etichetta );

            $attivita = $I->haveInDatabase( 'attivita', array(
                'nome' => $I->grabTestName( 'attivita' ),
                'id_documento' => $documento
            ) );
            $I->haveInStaticView( 'attivita', $attivita );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'attivita.form', array( 'attivita' => array( 'id' => $attivita ) ) );

            $I->assertEquals( $documento, $I->grabAttributeFrom( 'input[name="attivita[id_documento]"]', 'value' ) );
            $I->assertEquals( trim( $etichetta ), trim( $I->grabAttributeFrom( 'input[name="attivita[id_documento]"]', 'placeholder-api' ) ) );

        }

    }

