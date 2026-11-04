<?php

    /**
     * test del campo ordine delle righe di un documento
     *
     * dal 2026-11-04 ( riunione Lughese del 30/10 ) un oggetto figlio nuovo prende l'ordine dopo i fratelli, a passi
     * di dieci: getNextOrder() lo mette nel __preset__ del form aperto dal + di una sub view, duplicate() di main.js
     * lo scrive nella riga nuova di un sotto form; e una sub view senza altri criteri si ordina per ordine
     *
     */

    class documentiArticoliOrdineCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {
            $this->pulisci( $I );
        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {
            $this->pulisci( $I );
        }

        // toglie i record di test, dalle righe verso il documento
        protected function pulisci( BackendTester $I ) {
            $I->deleteTestRecords( 'documenti_articoli', 'nome' );
            $I->deleteTestRecords( 'documenti', 'nome' );
        }

        // crea un documento con tre righe scritte fuori ordine ( 30, 10, 25 ) e restituisce gli id
        protected function documento( BackendTester $I ) {
            $documento = $I->haveInDatabase( 'documenti', array(
                'nome' => $I->grabTestName( 'documento' )
            ) );
            $righe = array();
            foreach( array( 30, 10, 25 ) as $ordine ) {
                $righe[ $ordine ] = $I->haveInDatabase( 'documenti_articoli', array(
                    'id_documento' => $documento,
                    'nome' => $I->grabTestName( 'riga ' . $ordine ),
                    'ordine' => $ordine
                ) );
            }
            return array( $documento, $righe );
        }

        // il form della riga aperto dal + della sub view propone il multiplo di dieci dopo il più alto
        public function ordineDalPiu( BackendTester $I ) {
            list( $documento, $righe ) = $this->documento( $I );
            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'righe.offerte.commerciale.form', array( '__preset__' => array( 'documenti_articoli' => array( 'id_documento' => $documento ) ) ) );
            $I->seeInField( 'documenti_articoli[ordine]', '40' );
        }

        // la sub view delle righe, senza altri criteri, segue il campo ordine e non l'ordine di inserimento
        public function subViewPerOrdine( BackendTester $I ) {
            list( $documento, $righe ) = $this->documento( $I );
            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'offerte.commerciale.form.righe', array( 'documenti' => array( 'id' => $documento ) ) );
            $ids = array_values( array_intersect( array_map( 'trim', $I->grabMultiple( 'table tbody tr td:first-child' ) ), array_map( 'strval', $righe ) ) );
            $I->assertEquals( array( (string) $righe[10], (string) $righe[25], (string) $righe[30] ), $ids );
        }

        // la riga nuova di un sotto form prende l'ordine dopo le righe presenti, con gli zeri davanti se le righe li hanno
        public function ordineDuplicate( BackendTester $I ) {
            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'offerte.commerciale.view' );
            foreach( array( '30' => array( '10', '25' ), '0030' => array( '0010', '0025' ), '10' => array() ) as $atteso => $valori ) {
                $html = '<fieldset id="prova_ordine"><div id="prova_-1" class="form-sub hidden"><input name="t[s][-1][ordine]" value="" disabled></div>';
                foreach( $valori as $n => $v ) {
                    $html .= '<div id="prova_' . $n . '" class="form-sub"><input name="t[s][' . $n . '][ordine]" value="' . $v . '"></div>';
                }
                $html .= '</fieldset>';
                $valore = $I->executeJS(
                    '$( "#prova_ordine" ).remove(); $( "body" ).append( arguments[0] ); duplicate( "prova_ordine" ); return $( "#prova_ordine" ).children( "div" ).first().find( "input" ).val();',
                    array( $html )
                );
                $I->assertEquals( $atteso, $valore );
            }
        }

    }
