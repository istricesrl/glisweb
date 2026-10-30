<?php

    /**
     * test della risposta dell'API cron
     *
     * /api/cron non chiede login, perche' la chiama il cron di sistema; fino al 2026-10-26 rispondeva a chiunque con
     * l'intero $cf['cron'] ( percorsi dei task, esiti, errori, stato dei job ), adesso il dettaglio lo vede solo chi
     * ha GESTIONE_SISTEMA e gli altri ricevono l'esito e gli orari del run
     *
     * il test esegue davvero due run di cron sul deploy: e' quello che fa il cron di sistema ogni minuto
     *
     */

    class cronOutputCest {

        // da anonimo solo l'esito
        public function anonimo( BackendTester $I ) {

            $I->amOnPage( '/api/cron' );
            $I->see( '"esito"' );
            $I->dontSee( '"token"' );
            $I->dontSee( '"durata_massima"' );

        }

        // con GESTIONE_SISTEMA il dettaglio completo
        public function conPrivilegio( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/api/cron' );
            $I->see( '"token"' );
            $I->dontSee( '"esito"' );

        }

        // un task di un modulo spento non gira, e rilascia il lock
        // NOTA il modulo e il file non esistono: se il controllo del modulo mancasse, l'errore sarebbe quello del file
        public function taskDiModuloSpento( BackendTester $I ) {

            $I->deleteTestRecords( 'task', 'task', true );

            $id = $I->haveInDatabase( 'task', array(
                'task' => '_mod/_ZZ000.spento/_src/_api/_task/_' . $I->grabTestName( 'cron' ) . '.php',
                'iterazioni' => 1
            ) );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/api/cron' );
            $I->see( 'del modulo ZZ000.spento, che non' );
            $I->seeInDatabase( 'task', array( 'id' => $id, 'token' => NULL ) );

            $I->deleteTestRecords( 'task', 'task', true );

        }

    }
