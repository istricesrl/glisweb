<?php

    /**
     * test delle schede giacenze e movimenti del magazzino: il codice accanto all'id
     *
     * le schede magazzini.form.giacenze e magazzini.form.movimenti leggono __report_giacenza_magazzini__ e
     * __report_movimenti_magazzini__; fino al 24/11/2026 la colonna "codice articolo" mostrava l'id, che sui deploy
     * dove gli articoli vengono da un gestionale non coincide col codice e all'operatore non dice niente; dal 24/11
     * le schede espongono codice_articolo e codice_prodotto con quell'etichetta, mentre l'id resta nascosto per
     * l'apertura della riga
     *
     * i report non si ripopolano, perché i task riscrivono righe vere: la riga si scrive a mano per un articolo e un
     * mastro veri, usati in sola lettura, coi codici di test riconoscibili nella pagina, e si toglie in _before() e
     * _after(); il codice prodotto è nascosto di default, quindi si cerca nel sorgente
     *
     * la scheda movimenti ha la stessa correzione ma non ha un metodo qui: col filtro mastri_path_check() sulle due
     * colonne del mastro la pagina impiega minuti anche su un mastro senza movimenti, oltre il timeout del renderer
     * ( voce nel TODO.md del 24/11/2026 )
     *
     */

    class magazziniReportCodiceCest {

        // pulizia prima del test, per i resti di un giro interrotto
        public function _before( BackendTester $I ) {
            $I->deleteTestRecords( '__report_giacenza_magazzini__', 'id' );
            $I->deleteTestRecords( '__report_movimenti_magazzini__', 'note_aggiornamento' );
        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {
            $I->deleteTestRecords( '__report_giacenza_magazzini__', 'id' );
            $I->deleteTestRecords( '__report_movimenti_magazzini__', 'note_aggiornamento' );
        }

        public function giacenzeColCodice( BackendTester $I ) {

            // un articolo vero e un mastro vero senza righe nei report, così la riga di test è l'unica della pagina
            $idArticolo = $I->grabFromDatabase( 'SELECT id FROM articoli ORDER BY id LIMIT 1' );
            $idMastro = $I->grabFromDatabase( 'SELECT id FROM mastri WHERE NOT EXISTS ( SELECT 1 FROM __report_giacenza_magazzini__ WHERE id_mastro = mastri.id ) AND NOT EXISTS ( SELECT 1 FROM __report_movimenti_magazzini__ WHERE id_mastro_provenienza = mastri.id OR id_mastro_destinazione = mastri.id ) ORDER BY id LIMIT 1' );
            $codiceArticolo = $I->grabTestName( 'ga' );
            $codiceProdotto = $I->grabTestName( 'gp' );
            $I->haveInDatabase( '__report_giacenza_magazzini__', array(
                'id' => $I->grabTestName( 'g' ),
                'id_mastro' => $idMastro,
                'id_articolo' => $idArticolo,
                'codice_articolo' => $codiceArticolo,
                'codice_prodotto' => $codiceProdotto,
                'articolo' => 'articolo di test',
                'totale' => 1,
                'timestamp_aggiornamento' => time()
            ) );

            // la scheda del magazzino porta le colonne dei codici, coi codici della riga
            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'magazzini.form.giacenze', array( 'mastri' => array( 'id' => $idMastro ) ) );
            $I->see( $codiceArticolo );
            $I->seeInSource( $codiceProdotto );

        }

    }
