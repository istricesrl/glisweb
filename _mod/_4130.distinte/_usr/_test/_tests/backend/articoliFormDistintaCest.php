<?php

    /**
     * test della linguetta distinta base della scheda articolo
     *
     * dal 2026-11-24 la distinta base sta nel modulo _4130.distinte, che dipende da _4100.prodotti: la linguetta la
     * inserisce questo modulo nella scheda articolo, e c'e' solo dove il modulo e' attivo
     *
     */

    class articoliFormDistintaCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {
            $this->pulisci( $I );
        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {
            $this->pulisci( $I );
        }

        // toglie i record di test, dagli articoli verso il prodotto; il componente porta il prefisso solo nel codice,
        // perche' la chiave esterna di distinta.id_componente non cancella a cascata: prima va via l'articolo composto,
        // e con lui la riga di distinta, e solo dopo il componente
        protected function pulisci( BackendTester $I ) {
            $I->deleteTestRecords( 'articoli', 'nome' );
            $I->deleteTestRecords( 'articoli', 'codice' );
            $I->deleteTestRecords( 'prodotti', 'nome' );
        }

        // la linguetta c'e' nella scheda articolo e mostra il componente con la sua quantita'
        public function componenteVisibile( BackendTester $I ) {

            $prodotto = $I->haveInDatabase( 'prodotti', array( 'nome' => $I->grabTestName( 'prodotto' ) ) );
            $articolo = $I->haveInDatabase( 'articoli', array( 'id_prodotto' => $prodotto, 'codice' => $I->grabTestName( 'padre' ), 'nome' => $I->grabTestName( 'articolo' ) ) );
            $componente = $I->haveInDatabase( 'articoli', array( 'id_prodotto' => $prodotto, 'codice' => $I->grabTestName( 'figlio' ), 'nome' => 'componente della distinta' ) );
            $I->haveInDatabase( 'distinta', array( 'id_articolo' => $articolo, 'id_componente' => $componente, 'quantita' => 3 ) );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'articoli.form.distinta', array( 'articoli' => array( 'id' => $articolo ) ) );
            $I->see( 'distinta base' );
            $I->seeElement( 'input[name$="[quantita]"][value="3"]' );

            $I->amOnPageId( 'articoli.form', array( 'articoli' => array( 'id' => $articolo ) ) );
            $I->see( 'distinta base', '.nav-tabs' );

        }

    }
