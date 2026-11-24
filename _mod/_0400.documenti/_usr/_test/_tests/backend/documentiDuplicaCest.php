<?php

    /**
     * test della duplicazione di un documento
     *
     * dal 2026-11-24 la duplicazione sta nello standard ( task documenti.duplica, nato dalla duplicazione delle offerte
     * di LUGHESE ): la copia nasce senza codice, con le righe senza codice e la figlia agganciata alla copia della
     * madre; numerazione e destinatario dipendono da documenti.duplica.numera e documenti.duplica.destinatario, e il
     * test li verifica con tutt'e due i valori; i prezzi attuali si provano solo dove il modulo listini e' attivo,
     * altrove il task deve dire che copia i prezzi originali
     *
     */

    class documentiDuplicaCest {

        // dati del documento di partenza
        protected $dati = array();

        // pulizia prima del test, per i record rimasti da giri interrotti; le righe vanno tolte prima dei documenti, i
        // prezzi prima degli articoli e dei listini
        public function _before( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // la copia ha codici vuoti, le righe figlie sotto la copia della madre e i prezzi della riga di partenza
        public function duplicaConPrezziOriginali( BackendTester $I ) {

            $this->preparaDocumento( $I );

            $madre = $this->haveRiga( $I, array( 'codice' => $I->grabTestName( 'madre' ), 'ordine' => 10, 'quantita' => 2, 'prezzo_netto_unitario' => 900, 'prezzo_netto_totale' => 1800, 'importo_netto_totale' => 1800 ) );
            $this->haveRiga( $I, array( 'codice' => $I->grabTestName( 'figlia' ), 'ordine' => 10, 'id_genitore' => $madre ) );

            $I->amLoggedInAs( 'roots' );

            $I->amOnPage( '/task/0400.documenti/documenti.duplica?id=' . $this->dati['documento'] );
            $I->see( 'duplicate 2 righe su 2' );

            $copia = $this->grabCopia( $I );
            $I->assertNull( $I->grabFromDatabase( 'SELECT codice FROM documenti WHERE id = ?', array( $copia ) ) );

            // numerata solo con documenti.duplica.numera: sezionale dell'anno e data di oggi, altrimenti tutto vuoto
            $numero = $I->grabFromDatabase( 'SELECT concat_ws( "|", numero, sezionale, data ) FROM documenti WHERE id = ?', array( $copia ) );
            if( $numero !== '' && $numero !== NULL ) {
                $I->assertStringEndsWith( '|' . date( 'Y' ) . '|' . date( 'Y-m-d' ), $numero );
            }

            // destinatario tenuto o tolto per intero, secondo documenti.duplica.destinatario
            $I->assertContains( $I->grabFromDatabase( 'SELECT id_destinatario FROM documenti WHERE id = ?', array( $copia ) ), array( NULL, $this->dati['destinatario'] ) );

            // due righe senza codice, la figlia sotto la copia della madre, prezzi invariati
            $I->assertEquals( 2, $I->grabFromDatabase( 'SELECT count(*) FROM documenti_articoli WHERE id_documento = ? AND codice IS NULL', array( $copia ) ) );
            $I->assertEquals( 1, $I->grabFromDatabase(
                'SELECT count(*) FROM documenti_articoli f INNER JOIN documenti_articoli m ON m.id = f.id_genitore WHERE f.id_documento = ? AND m.id_documento = ?',
                array( $copia, $copia )
            ) );
            $I->assertEquals( '900.00|1800.00', $I->grabFromDatabase( 'SELECT concat_ws( "|", prezzo_netto_unitario, prezzo_netto_totale ) FROM documenti_articoli WHERE id_documento = ? AND id_genitore IS NULL', array( $copia ) ) );

        }

        // con prezzi=attuali la riga con un articolo prende il prezzo di listino di oggi e ricalcola gli importi con
        // quantita' e sconto della riga di partenza; senza il modulo listini il task lo dice e copia i prezzi originali
        public function duplicaConPrezziAttuali( BackendTester $I ) {

            $this->preparaDocumento( $I );

            $codice = $I->grabTestName( 'articolo' );
            $articolo = $I->haveInDatabase( 'articoli', array( 'codice' => $codice, 'nome' => $codice ) );
            $listino = $I->haveInDatabase( 'listini', array( 'nome' => $this->dati['nome'] ) );
            $I->haveInDatabase( 'prezzi', array( 'id_articolo' => $articolo, 'id_listino' => $listino, 'prezzo' => 1000, 'note' => $this->dati['nome'] ) );

            $this->haveRiga( $I, array( 'id_articolo' => $articolo, 'id_listino' => $listino, 'ordine' => 10, 'quantita' => 2, 'sconto_percentuale' => 10, 'prezzo_netto_unitario' => 900, 'prezzo_netto_totale' => 1800, 'importo_netto_totale' => 1620 ) );

            $I->amLoggedInAs( 'roots' );

            $I->amOnPage( '/task/0400.documenti/documenti.duplica?id=' . $this->dati['documento'] . '&prezzi=attuali' );
            $I->see( 'duplicate 1 righe su 1' );

            $senzaListini = strpos( $I->grabPageSource(), 'senza il modulo listini' ) !== false;

            $I->assertEquals(
                ( $senzaListini ) ? '900.00|1800.00|1620.00' : '1000.00|2000.00|1800.00',
                $I->grabFromDatabase( 'SELECT concat_ws( "|", prezzo_netto_unitario, prezzo_netto_totale, importo_netto_totale ) FROM documenti_articoli WHERE id_documento = ?', array( $this->grabCopia( $I ) ) )
            );

        }

        // scrive un documento di partenza, col codice e con un destinatario
        protected function preparaDocumento( BackendTester $I ) {

            $this->dati = array( 'nome' => $I->grabTestName( 'duplica' ) );
            $this->dati['destinatario'] = $I->grabFromDatabase( 'SELECT min( id ) FROM anagrafica' );

            $this->dati['documento'] = $I->haveInDatabase( 'documenti', array(
                'id_tipologia' => $I->grabFromDatabase( 'SELECT min( id ) FROM tipologie_documenti' ),
                'codice' => $this->dati['nome'],
                'sezionale' => 'TEST',
                'numero' => 1,
                'data' => date( 'Y-m-d' ),
                'nome' => $this->dati['nome'],
                'id_emittente' => $this->dati['destinatario'],
                'id_destinatario' => $this->dati['destinatario']
            ) );

        }

        // scrive una riga del documento di partenza
        protected function haveRiga( BackendTester $I, $riga ) {

            return $I->haveInDatabase( 'documenti_articoli', array_merge( array( 'id_documento' => $this->dati['documento'], 'nome' => $this->dati['nome'] ), $riga ) );

        }

        // la copia del documento di partenza
        protected function grabCopia( BackendTester $I ) {

            $copia = $I->grabFromDatabase( 'SELECT max( id ) FROM documenti WHERE nome = ? AND id <> ?', array( $this->dati['nome'], $this->dati['documento'] ) );
            $I->assertNotEmpty( $copia, 'documento duplicato non trovato' );

            return $copia;

        }

        // toglie i record di test
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'documenti_articoli', 'nome' );
            $I->deleteTestRecords( 'documenti', 'nome' );
            $I->deleteTestRecords( 'prezzi', 'note' );
            $I->deleteTestRecords( 'articoli', 'nome' );
            $I->deleteTestRecords( 'listini', 'nome' );

        }

    }
