<?php

    /**
     * test della linguetta articoli della scheda prodotto
     *
     * dal 2026-11-04 ( rilievi Lughese del 30/10 ) la sotto vista degli articoli mostra il codice, come l'elenco degli
     * articoli: la ricerca di una sotto vista guarda solo le colonne mostrate, e senza la colonna un articolo non si
     * trovava per codice
     *
     */

    class prodottiFormArticoliCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {
            $this->pulisci( $I );
        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {
            $this->pulisci( $I );
        }

        // toglie i record di test, dagli articoli verso il prodotto; anche dalla statica degli articoli, dove c'e',
        // perche' la cancellazione diretta non passa dal controller che la allinea
        protected function pulisci( BackendTester $I ) {
            if( $I->grabFromDatabase( 'SELECT count(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = "articoli_view_static"' ) ) {
                $I->deleteTestRecords( 'articoli_view_static', 'nome' );
            }
            $I->deleteTestRecords( 'articoli', 'nome' );
            $I->deleteTestRecords( 'prodotti', 'nome' );
        }

        // la linguetta mostra il codice dell'articolo, e la ricerca lo trova
        public function codiceCercabile( BackendTester $I ) {

            $prodotto = $I->haveInDatabase( 'prodotti', array( 'nome' => $I->grabTestName( 'prodotto' ) ) );
            $codice = $I->grabTestName( 'codice' );
            foreach( array( $codice, $I->grabTestName( 'altro' ) ) as $c ) {
                $articolo = $I->haveInDatabase( 'articoli', array( 'id_prodotto' => $prodotto, 'codice' => $c, 'nome' => $I->grabTestName( 'articolo' ) ) );
                $I->haveInStaticView( 'articoli', $articolo );
            }

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'prodotti.form.articoli', array( 'prodotti' => array( 'id' => $prodotto ) ) );
            $I->see( 'codice', 'table thead' );
            $I->see( $codice, 'table tbody' );

            $I->fillField( 'input[name$="[__search__]"]', $codice );
            $I->pressKey( 'input[name$="[__search__]"]', \Facebook\WebDriver\WebDriverKeys::ENTER );
            $I->waitForElement( 'input[name$="[__search__]"]', 10 );
            $I->see( $codice, 'table tbody' );
            $I->assertEquals( 1, count( $I->grabMultiple( 'table tbody tr' ) ) );

        }

    }
