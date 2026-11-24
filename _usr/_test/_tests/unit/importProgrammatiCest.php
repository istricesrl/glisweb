<?php

    /**
     * test dello smistamento delle cartelle programmate dell'importazione ( _src/_config/_740.controller.php )
     *
     * Il blocco che sposta i file dalle cartelle di var/spool/import/todo/<AAAAMMGGHHMMSS>/ a var/spool/import/
     * gira dentro il controller, che lavora sulle costanti DIR_VAR_SPOOL_IMPORT_TODO e DIR_VAR_SPOOL_IMPORT e non
     * si puo' includere da solo senza toccare lo spool vero del deploy. Il test quindi legge il blocco dal sorgente,
     * sostituisce le due costanti con due cartelle temporanee sotto var/test/ e lo esegue: prova il codice vero,
     * non una copia, e un blocco che non si trova piu' e' un test rosso.
     *
     * Fino al 24/11/2026 la cartella programmata si eliminava solo dentro il ramo dei file, e una cartella vuota
     * restava in todo/ per sempre, rielencata a ogni giro del cron ( segnalato da eurosnodi ).
     *
     */

    class importProgrammatiCest {

        private $base;

        public function _before( UnitTester $I ) {
            $this->base = DIR_BASE . 'var/test/import.programmati.' . getmypid() . '/';
            @mkdir( $this->base . 'todo/', 0775, true );
        }

        // deleteFolder() non e' ricorsiva: la cartella temporanea si svuota a mano
        public function _after( UnitTester $I ) {
            $voci = new RecursiveIteratorIterator( new RecursiveDirectoryIterator( $this->base, FilesystemIterator::SKIP_DOTS ), RecursiveIteratorIterator::CHILD_FIRST );
            foreach( $voci as $voce ) {
                $voce->isDir() ? rmdir( $voce->getPathname() ) : unlink( $voce->getPathname() );
            }
            rmdir( $this->base );
        }

        // estrae il blocco delle cartelle programmate e lo esegue sulle cartelle temporanee
        private function esegui( UnitTester $I ) {

            $codice = file_get_contents( DIR_SRC_CONFIG . '_740.controller.php' );

            $inizio = strpos( $codice, "\$cf['import']['programmati'] = getDirList( DIR_VAR_SPOOL_IMPORT_TODO );" );
            $I->assertNotFalse( $inizio, 'blocco delle cartelle programmate non trovato in _740.controller.php' );

            // il blocco finisce con la graffa che chiude l'if( ! empty( $cf['import']['programmati'] ) )
            $apertura = strpos( $codice, '{', strpos( $codice, "if( ! empty( \$cf['import']['programmati'] ) )", $inizio ) );
            for( $i = $apertura, $livello = 0; $i < strlen( $codice ); $i++ ) {
                if( $codice[ $i ] === '{' ) { $livello++; }
                if( $codice[ $i ] === '}' && --$livello === 0 ) { break; }
            }
            $blocco = substr( $codice, $inizio, $i - $inizio + 1 );

            // prima TODO, che contiene l'altro nome
            $blocco = str_replace( 'DIR_VAR_SPOOL_IMPORT_TODO', '$todo', $blocco );
            $blocco = str_replace( 'DIR_VAR_SPOOL_IMPORT', '$import', $blocco );

            $todo   = $this->base . 'todo/';
            $import = $this->base;
            $cf     = array( 'import' => array() );

            eval( $blocco );

            return $cf;

        }

        // una cartella programmata nel passato e vuota si elimina
        public function cartellaVuotaEliminata( UnitTester $I ) {

            mkdir( $this->base . 'todo/20200101000000/' );

            $this->esegui( $I );

            $I->assertDirectoryDoesNotExist( $this->base . 'todo/20200101000000/', 'la cartella programmata vuota e\' rimasta in todo/' );

        }

        // una cartella nel passato con un file: il file passa nella cartella di importazione e la cartella si elimina
        public function cartellaConFileSpostataEliminata( UnitTester $I ) {

            mkdir( $this->base . 'todo/20200101000000/' );
            file_put_contents( $this->base . 'todo/20200101000000/prova.csv', "a\n1\n" );

            $this->esegui( $I );

            $I->assertFileExists( $this->base . 'prova.csv', 'il file programmato non e\' arrivato nella cartella di importazione' );
            $I->assertDirectoryDoesNotExist( $this->base . 'todo/20200101000000/', 'la cartella programmata svuotata e\' rimasta in todo/' );

        }

        // una cartella programmata nel futuro non si tocca
        public function cartellaFuturaIntatta( UnitTester $I ) {

            mkdir( $this->base . 'todo/29991231235959/' );
            file_put_contents( $this->base . 'todo/29991231235959/prova.csv', "a\n1\n" );

            $this->esegui( $I );

            $I->assertFileExists( $this->base . 'todo/29991231235959/prova.csv', 'una cartella programmata nel futuro e\' stata elaborata' );
            $I->assertFileDoesNotExist( $this->base . 'prova.csv' );

        }

    }
