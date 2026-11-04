<?php

    /**
     * test di duplicate() in src/js/main.js dei template _athena
     *
     * dal 2026-11-04 la riga nuova di un sotto form prende nel campo ordine il multiplo di dieci dopo il più alto fra
     * le righe presenti, con gli zeri davanti se le righe li hanno; questo test lo prova sulla dashboard, che usa
     * _src/_tpl/_athena/, mentre la copia di _src/_templates/_athena/ la prova documentiArticoliOrdineCest nel
     * modulo documenti
     *
     */

    class duplicateOrdineCest {

        // la riga nuova prende 30 dopo 10 e 25, 0030 dopo 0010 e 0025, 10 se non ci sono righe
        public function ordineDuplicate( BackendTester $I ) {
            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'dashboard' );
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
