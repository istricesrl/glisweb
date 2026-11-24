<?php

    /**
     * test delle etichette che mostrano il codice e non l'id
     *
     * il 2026-11-24 la ricognizione «id mostrato al posto del codice» ha trovato nel canone delle viste e dei report
     * sei etichette che stampavano l'id di un'entità che ha un codice ( lotti, documenti_articoli, attivita, todo,
     * carrelli, carrelli_consensi, il report delle iscrizioni ): ora mostrano coalesce( codice, id ), cioè il codice,
     * e l'id solo come ripiego quando il codice manca
     *
     * come in vistaDocumentiLabelCest si prova l'espressione del file base e non la vista viva, perché i database
     * esistenti tengono la vista in cui sono nati finché il ricaricamento dei file base non la rifà
     *
     */

    class vistaEtichetteCodiceCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // toglie i carrelli di test
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'nome' );

        }

        // il blocco di una vista nel file base delle viste
        protected function blocco( $vista ) {

            $sql = file_get_contents( DIR_BASE . '_usr/_database/_patch/_090000999999.views.sql' );
            $blocco = substr( $sql, strpos( $sql, 'CREATE OR REPLACE VIEW `' . $vista . '`' ) );

            return substr( $blocco, 0, strpos( $blocco, ";\n" ) );

        }

        // l'espressione di __label__ di carrelli_view nel file base, valutata sul carrello indicato
        protected function etichetta( BackendTester $I, $carrello ) {

            $blocco = $this->blocco( 'carrelli_view' );
            $blocco = substr( $blocco, 0, strpos( $blocco, 'AS __label__' ) );
            $espressione = substr( $blocco, strrpos( $blocco, ",\n" ) + 2 );

            return $I->grabFromDatabase( 'SELECT ' . $espressione . ' FROM carrelli WHERE carrelli.id = ?', array( $carrello ) );

        }

        // un carrello col codice si etichetta col codice
        public function carrelloColCodice( BackendTester $I ) {

            $carrello = $I->haveInDatabase( 'carrelli', array(
                'nome' => $I->grabTestName( 'col-codice' ),
                'codice' => 'TESTE2ECOD'
            ) );

            $I->assertEquals( 'TESTE2ECOD', $this->etichetta( $I, $carrello ) );

        }

        // un carrello senza codice ripiega sull'id
        public function carrelloSenzaCodice( BackendTester $I ) {

            $carrello = $I->haveInDatabase( 'carrelli', array(
                'nome' => $I->grabTestName( 'senza-codice' )
            ) );

            $I->assertEquals( (string) $carrello, (string) $this->etichetta( $I, $carrello ) );

        }

        // nel canone non restano le espressioni che stampavano l'id al posto del codice
        public function nienteIdAlPostoDelCodice( BackendTester $I ) {

            $vecchie = array(
                'lotti_view' => "\t\t\tarticoli.id,\n",
                'documenti_articoli_view' => "coalesce( documenti_articoli.id_articolo, '' )",
                'attivita_view' => "concat( asset.id, ' ', asset.nome )",
                'todo_view' => "concat(' su ',`todo`.`id_progetto`",
                'carrelli_consensi_view' => "coalesce( carrelli_consensi.id_carrello, '' )"
            );

            foreach( $vecchie as $vista => $vecchia ) {
                $I->assertNotEmpty( $this->blocco( $vista ), $vista . ' non trovata nel file base' );
                $I->assertFalse( strpos( $this->blocco( $vista ), $vecchia ) !== false, $vista );
            }

            $report = file_get_contents( DIR_BASE . '_usr/_database/_patch/_100000999999.reports.sql' );
            $I->assertFalse( strpos( $report, "concat( 'rinnovo ', rinnovi.id, " ) !== false, 'report iscrizioni' );

        }

        // mastri_articoli_view mostra il codice dell'articolo, nella colonna e nell'etichetta
        public function mastriArticoliColCodice( BackendTester $I ) {

            $blocco = $this->blocco( 'mastri_articoli_view' );
            $I->assertNotEmpty( $blocco, 'mastri_articoli_view non trovata nel file base' );
            $I->assertEquals( 2, substr_count( $blocco, "concat_ws( ' ', coalesce( articoli.codice, articoli.id ), prodotti.nome, articoli.nome )" ) );

        }

    }
