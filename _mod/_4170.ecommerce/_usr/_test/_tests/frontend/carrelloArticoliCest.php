<?php

    /**
     * test degli articoli richiesti per codice
     *
     * dal 2026-10-12 il controller del carrello traduce in id anche gli id_articolo di __carrello__[__articoli__] che
     * sono un codice ( articoli.codice ), e scarta quelli il cui codice non esiste: un codice inventato dalla richiesta
     * non deve lasciare righe in carrelli_articoli, né per __articolo__ né per __articoli__; i carrelli si riconoscono
     * dal nome dell'intestatario che porta il prefisso TEST-E2E-, e le righe se ne vanno con loro
     *
     */

    class carrelloArticoliCest {

        // pulizia prima del test
        public function _before( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // pulizia dopo il test
        public function _after( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // apre un carrello con la richiesta data e ne restituisce l'id
        protected function apriCarrello( FrontendTester $I, $nome, $parametri ) {

            // la pagina del carrello e non la home: dove / e' rediretta il redirect arriva prima dei controller del carrello
            $I->amOnPageId( 'carrello', array( '__carrello__' => array_merge( $parametri, array( 'intestazione_nome' => $nome ) ) ) );

            $id = $I->grabFromDatabase( 'SELECT id FROM carrelli WHERE intestazione_nome = ?', array( $nome ) );
            if( empty( $id ) ) {
                $I->fail( 'carrello ' . $nome . ' non creato, vedi var/log/test/cart' );
            }

            return $id;

        }

        // un codice inesistente in __articolo__ non entra nel carrello
        public function articoloCodiceInesistenteScartato( FrontendTester $I ) {

            $codice = $I->grabTestName( 'codice' );

            $id = $this->apriCarrello( $I, $I->grabTestName( 'articolo' ), array(
                '__articolo__' => array( 'id_articolo' => $codice, 'quantita' => 1 )
            ) );

            $I->dontSeeInDatabase( 'carrelli_articoli', array( 'id_carrello' => $id ) );

        }

        // un codice inesistente in __articoli__ non entra nel carrello
        public function articoliCodiceInesistenteScartato( FrontendTester $I ) {

            $codice = $I->grabTestName( 'codice' );

            $id = $this->apriCarrello( $I, $I->grabTestName( 'articoli' ), array(
                '__articoli__' => array( $codice => array( 'id_articolo' => $codice, 'quantita' => 1 ) )
            ) );

            $I->dontSeeInDatabase( 'carrelli_articoli', array( 'id_carrello' => $id ) );

        }

    }
