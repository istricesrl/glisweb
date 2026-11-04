<?php

    /**
     * test dell'etichetta di documenti_view nel canone
     *
     * fino al 2026-11-04 il __label__ di documenti_view nel file base era un concat su sigla della tipologia e data:
     * un documento senza tipologia o senza data aveva l'etichetta NULL, e nelle tendine compariva col solo id. Ora i
     * pezzi facoltativi stanno in un concat_ws, come in periodi_view, e a documento completo la stringa resta quella
     * di prima
     *
     * si prova l'espressione del file base e non la vista viva: i database esistenti tengono la vista in cui sono
     * nati, e il canone intero di documenti_view non gira dove documenti non ha ancora id_carrelli_articoli. Si
     * valuta sulle stesse tabelle da cui la vista prende i pezzi dell'etichetta
     *
     */

    class vistaDocumentiLabelCest {

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

        // l'espressione di __label__ di documenti_view nel file base, valutata sul documento indicato
        protected function etichetta( BackendTester $I, $documento ) {

            $sql = file_get_contents( DIR_BASE . '_usr/_database/_patch/_090000999999.views.sql' );
            $blocco = substr( $sql, strpos( $sql, 'CREATE OR REPLACE VIEW `documenti_view`' ) );
            $blocco = substr( $blocco, 0, strpos( $blocco, 'AS __label__' ) );
            $espressione = substr( $blocco, strrpos( $blocco, 'documenti.id_account_aggiornamento,' ) + strlen( 'documenti.id_account_aggiornamento,' ) );

            return $I->grabFromDatabase(
                'SELECT ' . $espressione . ' FROM documenti'
                . ' LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia'
                . ' LEFT JOIN anagrafica a2 ON a2.id = documenti.id_destinatario'
                . ' WHERE documenti.id = ?',
                array( $documento )
            );

        }

        // senza tipologia e senza data l'etichetta c'e' lo stesso
        public function senzaTipologiaNeData( BackendTester $I ) {

            $documento = $I->haveInDatabase( 'documenti', array(
                'nome' => $I->grabTestName( 'incompleto' ),
                'numero' => '7'
            ) );

            $I->assertEquals( '7 per ', $this->etichetta( $I, $documento ) );

        }

        // a documento completo l'etichetta e' quella di prima: sigla, numero/sezionale, data, destinatario
        public function completoComePrima( BackendTester $I ) {

            $tipologia = $I->grabFromDatabase( 'SELECT id FROM tipologie_documenti WHERE sigla IS NOT NULL ORDER BY id LIMIT 1' );
            $I->assertNotEmpty( $tipologia, 'serve una tipologia di documento con la sigla' );
            $sigla = $I->grabFromDatabase( 'SELECT sigla FROM tipologie_documenti WHERE id = ?', array( $tipologia ) );

            $documento = $I->haveInDatabase( 'documenti', array(
                'nome' => $I->grabTestName( 'completo' ),
                'id_tipologia' => $tipologia,
                'numero' => '7',
                'sezionale' => 'A',
                'data' => '2026-11-04'
            ) );

            $I->assertEquals( $sigla . ' 7/A del 2026-11-04 per ', $this->etichetta( $I, $documento ) );

        }

    }
