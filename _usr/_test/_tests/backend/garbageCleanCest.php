<?php

    /**
     * test del task garbage.clean
     *
     * scritto il 04/11/2026 insieme al cestino dei file ( trashFile() e emptyTrash() di _src/_lib/_filesystem.tools.php ): il
     * task svuota le cartelle del giorno di tmp/.garbage/ oltre common.garbage.giorni, e in anteprima non tocca niente
     *
     * la cartella di prova si chiama 20000101.<pid>, così è una cartella del giorno vecchia senza confondersi con quelle
     * vere; il task toglie anche le cartelle vere oltre il termine, che è il suo lavoro
     *
     */

    class garbageCleanCest {

        // cartella del giorno di prova
        protected $cartella;

        // creazione della cartella di prova
        public function _before( BackendTester $I ) {

            $this->cartella = DIR_TMP_GARBAGE . '20000101.' . getmypid() . '/';

            checkFile( $this->cartella . 'var/uploads/TEST-E2E-cestino.txt' );

        }

        // pulizia dopo il test; di solito la cartella l'ha già tolta il task, e la cache di stat() di PHP la darebbe
        // ancora per presente
        public function _after( BackendTester $I ) {

            clearstatcache();

            if( is_dir( $this->cartella ) ) {
                recursiveDelete( $this->cartella );
            }

        }

        // l'anteprima indica la cartella vecchia e non la cancella, il giro vero la cancella
        public function cartellaVecchiaSvuotata( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );

            $I->amOnPage( '/task/garbage.clean?dryrun=1' );
            $I->see( '20000101.' . getmypid() );
            $I->assertDirectoryExists( $this->cartella );

            $I->amOnPage( '/task/garbage.clean' );
            $I->see( '20000101.' . getmypid() );

            // la cartella la toglie il processo di Apache: la cache di stat() di questo processo non lo sa
            clearstatcache();
            $I->assertDirectoryDoesNotExist( $this->cartella );

        }

        // una cartella del giorno di oggi resta
        public function cartellaDiOggiTenuta( BackendTester $I ) {

            $oggi = DIR_TMP_GARBAGE . date( 'Ymd' ) . '/var/uploads/TEST-E2E-' . getmypid() . '.txt';

            checkFile( $oggi );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/task/garbage.clean' );

            clearstatcache();
            $I->assertFileExists( $oggi );

            deleteFile( $oggi );

        }

    }
