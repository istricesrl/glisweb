<?php

    /**
     * test delle macro di _src/_twig/_lib/_form.twig
     *
     * le macro si renderizzano davvero, dalla pagina di esempio di _usr/_examples/_core/, e si controlla l'HTML che
     * producono; fino al 24/11/2026 field.noempty di select() non toglieva l'opzione vuota
     *
     */

    class twigFormCest {

        // select() -> senza noempty apre con l'opzione vuota, con noempty no e il browser preseleziona la prima
        public function selectNoempty( UnitTester $I ) {

            $I->amOnPage( '/_usr/_examples/_core/_form.select.noempty.01.php' );
            $I->see( "noempty='' opzione vuota: si, attributo empty: si, opzioni: 3" );
            $I->see( "noempty=1 opzione vuota: no, attributo empty: no, opzioni: 2" );

        }

    }
