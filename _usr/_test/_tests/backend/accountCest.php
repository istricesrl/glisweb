<?php

    /**
     * test della pagina account della web app
     *
     * verifica che la pagina app.account si apra per un account loggato e mostri il form dei dati
     * e quello del cambio password; fino al 27/11/2026 la pagina puntava a una macro del modulo 0010
     * e a uno schema che minerva non aveva, e su un deploy senza quel modulo non si apriva
     *
     */

    class accountCest {

        // la pagina si apre col form dei dati dell'account
        public function paginaAccount( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/account.it-IT.html' );
            $I->dontSeeElement( '#formLogin' );
            $I->seeElement( '#formAccount' );
            foreach( array( 'nome', 'cognome', 'mail', 'telefono', 'cellulare', 'password0', 'password1', 'password2' ) as $campo ) {
                $I->seeElement( '[name="__account__[' . $campo . ']"]' );
            }
            $I->seeElement( '#formLogout' );

        }

    }
