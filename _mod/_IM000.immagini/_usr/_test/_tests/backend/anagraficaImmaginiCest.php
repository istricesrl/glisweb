<?php

    /**
     * test della linguetta immagini della scheda anagrafica
     *
     * la pagina anagrafica.form.immagini di IM000.immagini usa le macro di AN000.anagrafica: senza quel modulo non va
     * dichiarata, e sulla scheda legacy di 0010.anagrafica deve restare la linguetta immagini del modulo legacy
     *
     * NOTA il test va rosso solo su un deploy che non ha la cartella _mod/_AN000.anagrafica: dove c'e', anche spento, il
     * loader dei template trova lo stesso lib/anagrafica.form.sub.twig
     *
     */

    class anagraficaImmaginiCest {

        // la linguetta immagini si apre, con o senza AN000.anagrafica
        public function linguettaImmagini( BackendTester $I ) {

            $I->clearGliswebCache();

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'anagrafica.form.immagini' );

            $I->dontSee( 'Unable to find template' );
            $I->seeElement( '.nav-link.active[href*="/anagrafica/immagini."]' );

        }

    }
