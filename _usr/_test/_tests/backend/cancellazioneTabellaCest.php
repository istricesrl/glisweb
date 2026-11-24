<?php

    /**
     * test della validazione della tabella nella pagina di cancellazione
     *
     * fino al 2026-11-24 _src/_inc/_macro/_delete.php concatenava __delete__[table], che arriva dalla querystring, nella
     * query di mysqlSelectLabel(): senza parametri la pagina dava 'Table doesn't exist' su 'SELECT __label__ FROM _view'
     * ( polmasi, 23/11/2026 ), e con un nome costruito apposta eseguiva l'SQL ricevuto. Ora la tabella passa da
     * getTable(): un nome non valido o inesistente non fa query, e la pagina mostra solo il numero della riga
     *
     */

    class cancellazioneTabellaCest {

        // la pagina della richiesta di cancellazione, senza conferma
        protected function apri( BackendTester $I, $tabella, $id ) {

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'delete', array( '__delete__' => array( 'table' => $tabella, 'id' => $id, 'target' => '/', 'rollback' => '/' ) ) );

        }

        // con una tabella vera c'e' l'etichetta, letta dalla vista o dalla statica, e non il numero della riga
        public function tabellaValida( BackendTester $I ) {

            $id = $I->grabFromDatabase( 'SELECT id FROM anagrafica_view WHERE __label__ IS NOT NULL ORDER BY id LIMIT 1' );

            $this->apri( $I, 'anagrafica', $id );
            $I->seeElement( 'h1' );
            $I->dontSee( 'riga #' . $id, 'h1' );

        }

        // senza tabella niente query: solo il numero della riga
        public function tabellaVuota( BackendTester $I ) {

            $this->apri( $I, '', 1 );
            $I->see( 'riga #1', 'h1' );

        }

        // un nome con dentro dell'SQL non arriva al database: col codice vecchio la condizione iniettata sceglieva
        // un'altra riga e il titolo ne mostrava l'etichetta; il payload evita le parole che il firewall applicativo
        // ( _src/_inc/_macro/_security.php ) blocca prima della macro, come union select
        public function tabellaMaligna( BackendTester $I ) {

            $altro = $I->grabFromDatabase( 'SELECT id FROM anagrafica_view WHERE __label__ IS NOT NULL ORDER BY id DESC LIMIT 1' );

            $this->apri( $I, 'anagrafica_view WHERE id = ' . $altro . ' #', 1 );
            $I->see( 'riga #1', 'h1' );

        }

    }
