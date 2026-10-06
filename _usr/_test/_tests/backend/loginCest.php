<?php

    /**
     * test del login nel back-end
     *
     * verifica che l'account di test creato dall'helper Glisweb entri nel back-end ( col token JWT, vedi l'helper ),
     * ed e' il test da cui partire per capire se l'ambiente dei test di back-end ( chromedriver, URL del sito, database ) e' a posto
     *
     */

    class loginCest {

        // login con l'account di test del gruppo roots
        public function loginRoots( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/admin.it-IT.html' );
            $I->dontSeeElement( '#formLogin' );

        }

    }
