<?php

    /**
     * test del task che genera il DDT da una missione di prelievo
     *
     * il task /task/0400.documenti/ddt.da.missione legge le righe di lista agganciate alla missione e per ogni documento
     * di origine crea ( o ritrova ) un DDT di tipologia 4 col codice DDT-<codice documento>, lo collega con la relazione
     * di ruolo 3 alla missione e alla lista, e gli scrive una riga DDT-R-<codice riga> con l'articolo e la quantità
     *
     * il test verifica che le righe del DDT ci siano davvero: fino al 23/11/2026 la riga si portava dietro la tipologia
     * del documento ( 4 o 7 ) in documenti_articoli.id_tipologia, che è una chiave esterna verso
     * tipologie_documenti_articoli dove quei valori non esistono, e l'INSERT IGNORE la scartava senza errore; il task
     * rispondeva bene, il DDT nasceva, e restava vuoto
     *
     * la missione è di tipologia 34, perché il task rifiuta le altre, e resta aperta: il cron ddt.da.missioni.chiuse
     * lavora solo le missioni chiuse, quindi non le genera un DDT suo, e il test passa forza=1; le relazioni non hanno un
     * campo marcato, ma cadono in cascata col DDT, mentre le righe vanno tolte prima dei documenti ( id_documento è NO
     * ACTION ); DDT e righe del DDT portano il prefisso di test in mezzo al codice, quindi si cercano ovunque
     *
     * gli articoli li crea il test, con un prodotto, tutti col prefisso di test nel nome, perché il test deve girare su
     * qualunque deploy: si tolgono dopo i documenti, prima gli articoli e poi il prodotto
     *
     */

    class ddtDaMissioneCest {

        // id dei due articoli di test, creati da articoli()
        private $articoli = array();

        // crea un prodotto e due articoli di test e ne tiene gli id
        private function articoli( BackendTester $I ) {
            $prodotto = $I->haveInDatabase( 'prodotti', array( 'nome' => $I->grabTestName( 'p' ) ) );
            $this->articoli = array();
            for( $i = 0; $i < 2; $i++ ) {
                $this->articoli[] = $I->haveInDatabase( 'articoli', array( 'id_prodotto' => $prodotto, 'codice' => $I->grabTestName( 'a' ), 'nome' => $I->grabTestName( 'a' ) ) );
            }
        }

        // pulizia prima del test, per i resti di un giro interrotto
        public function _before( BackendTester $I ) {
            $this->pulizia( $I );
        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {
            $this->pulizia( $I );
        }

        // toglie le righe ( della lista e del DDT ) e poi i documenti, le relazioni cadono in cascata; poi articoli e prodotto
        private function pulizia( BackendTester $I ) {
            $I->deleteTestRecords( 'documenti_articoli', 'codice', true );
            $I->deleteTestRecords( 'documenti', 'codice', true );
            $I->deleteTestRecords( 'articoli', 'nome' );
            $I->deleteTestRecords( 'prodotti', 'nome' );
        }

        // crea una missione aperta e una lista di prelievo con due righe agganciate alla missione, e restituisce id della
        // missione e codice della lista
        private function missione( BackendTester $I ) {
            $this->articoli( $I );
            $idMissione = $I->haveInDatabase( 'documenti', array( 'id_tipologia' => 34, 'codice' => $I->grabTestName( 'm' ) ) );
            $codiceLista = $I->grabTestName( 'l' );
            $idLista = $I->haveInDatabase( 'documenti', array( 'id_tipologia' => 7, 'codice' => $codiceLista ) );
            foreach( $this->articoli as $i => $articolo ) {
                $I->haveInDatabase( 'documenti_articoli', array( 'id_documento' => $idLista, 'id_missione' => $idMissione, 'id_articolo' => $articolo, 'quantita' => $i + 2, 'codice' => $I->grabTestName( 'r' ) ) );
            }
            return array( $idMissione, $codiceLista );
        }

        // lancia il task come root
        private function task( BackendTester $I, $idMissione, $forza = true ) {
            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/task/0400.documenti/ddt.da.missione?missione=' . $idMissione . ( ( $forza ) ? '&forza=1' : '' ) );
        }

        public function ddtConRighe( BackendTester $I ) {
            list( $idMissione, $codiceLista ) = $this->missione( $I );
            $this->task( $I, $idMissione );

            // il DDT nasce, di tipologia 4, collegato a missione e lista
            $idDdt = $I->grabFromDatabase( 'SELECT id FROM documenti WHERE codice = ? AND id_tipologia = 4', array( 'DDT-' . $codiceLista ) );
            $I->assertNotEmpty( $idDdt );
            $I->assertEquals( 2, $I->grabFromDatabase( 'SELECT count(*) FROM relazioni_documenti WHERE id_documento = ? AND id_ruolo = 3', array( $idDdt ) ) );

            // e ha le sue righe, una per riga della lista, con articolo e quantità: è il controllo che sarebbe fallito
            $I->assertEquals( 2, $I->grabFromDatabase( 'SELECT count(*) FROM documenti_articoli WHERE id_documento = ?', array( $idDdt ) ) );
            foreach( $this->articoli as $i => $articolo ) {
                $I->assertEquals( $i + 2, $I->grabFromDatabase( 'SELECT quantita FROM documenti_articoli WHERE id_documento = ? AND id_articolo = ?', array( $idDdt, $articolo ) ) );
            }

            // un secondo giro ritrova il DDT e non raddoppia niente
            $this->task( $I, $idMissione );
            $I->assertEquals( 1, $I->grabFromDatabase( 'SELECT count(*) FROM documenti WHERE codice = ?', array( 'DDT-' . $codiceLista ) ) );
            $I->assertEquals( 2, $I->grabFromDatabase( 'SELECT count(*) FROM documenti_articoli WHERE id_documento = ?', array( $idDdt ) ) );
            $I->assertEquals( 2, $I->grabFromDatabase( 'SELECT count(*) FROM relazioni_documenti WHERE id_documento = ? AND id_ruolo = 3', array( $idDdt ) ) );
        }

        public function missioneAperta( BackendTester $I ) {
            list( $idMissione, $codiceLista ) = $this->missione( $I );

            // senza forza una missione aperta non genera niente
            $this->task( $I, $idMissione, false );
            $I->see( 'non e\' chiusa' );
            $I->assertEquals( 0, $I->grabFromDatabase( 'SELECT count(*) FROM documenti WHERE codice = ?', array( 'DDT-' . $codiceLista ) ) );
        }

    }
