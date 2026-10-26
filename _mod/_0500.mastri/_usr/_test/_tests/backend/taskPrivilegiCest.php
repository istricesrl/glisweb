<?php

    /**
     * test dei privilegi dei task del modulo mastri
     *
     * fino al 2026-10-26 rifornimenti.da.sottoscorta e i due task di popolazione dei report di magazzino non
     * chiamavano checkTaskPrivilege(), e rispondevano a una GET anonima eseguendo il lavoro: il primo crea le
     * missioni di rifornimento, gli altri riscrivono __report_giacenza_magazzini__ e __report_movimenti_magazzini__
     *
     * i report si raggiungono sia da /task/report/0500.mastri/<task> sia dal percorso del file, che .htaccess non
     * blocca: il controllo sta nel file, quindi vale per tutti e due, e il test li prova entrambi
     *
     * il test non esegue i task: da anonimo devono fermarsi prima di toccare il database
     *
     */

    class taskPrivilegiCest {

        // da anonimo i task rispondono che i privilegi non bastano
        public function taskSenzaLogin( BackendTester $I ) {

            $percorsi = array(
                '/task/0500.mastri/rifornimenti.da.sottoscorta',
                '/task/report/0500.mastri/report.giacenza.magazzini.popolazione',
                '/task/report/0500.mastri/report.movimenti.magazzini.popolazione',
                '/_mod/_0500.mastri/_src/_api/_task/_report/_report.giacenza.magazzini.popolazione.php',
                '/_mod/_0500.mastri/_src/_api/_task/_report/_report.movimenti.magazzini.popolazione.php'
            );

            foreach( $percorsi as $percorso ) {
                $I->amOnPage( $percorso );
                $I->see( 'privilegi insufficienti' );
            }

        }

    }
