<?php

    /**
     * test del task images.resize e del report della sua coda
     *
     * fino al 2026-10-30 il task stava in due copie e quella nella tabella task calcolava l'orientamento opposto uguale a
     * quello dell'immagine, quindi i tagli dell'altro orientamento non nascevano; una riga marcata da un giro morto restava
     * fuori dalla coda per sempre, e il task girava a vuoto sui file che non sono immagini
     *
     * le righe si scrivono in immagini col nome TEST-E2E-; l'immagine di prova e i formati che il task ne ricava si
     * tolgono da DIR_VAR_IMMAGINI in _after(). Il task si chiama sempre con id=, così non prende le immagini vere della
     * coda; lo sblocco delle righe abbandonate invece lavora su tutta la tabella, com'è giusto che faccia
     *
     */

    class imagesResizeCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $I->deleteTestRecords( 'immagini', 'nome' );
            $this->togliFile();

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $I->deleteTestRecords( 'immagini', 'nome' );
            $this->togliFile();

        }

        // file di prova e formati ricavati
        private function togliFile() {

            $it = new RecursiveIteratorIterator( new RecursiveDirectoryIterator( DIR_VAR_IMMAGINI, FilesystemIterator::SKIP_DOTS ) );
            foreach( $it as $f ) {
                if( strpos( $f->getFilename(), 'TEST-E2E-' ) === 0 ) {
                    unlink( $f->getPathname() );
                }
            }

        }

        // un'immagine orizzontale riceve anche i tagli verticali
        public function tagliNellOrientamentoOpposto( BackendTester $I ) {

            $nome = $I->grabTestName( 'scalamento' );

            $im = imagecreatetruecolor( 400, 200 );
            imagejpeg( $im, DIR_VAR_IMMAGINI . $nome . '.jpg' );
            imagedestroy( $im );

            $id = $I->haveInDatabase( 'immagini', array(
                'nome' => $nome,
                'path' => 'var/immagini/' . $nome . '.jpg'
            ) );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/task/IM000.immagini/images.resize?id=' . $id );

            $I->assertFileExists( DIR_VAR_IMMAGINI . '160l/' . $nome . '.jpg' );
            $I->assertFileExists( DIR_VAR_IMMAGINI . '240p/' . $nome . '.jpg' );
            $I->seeInDatabase( 'immagini', array( 'id' => $id, 'token' => NULL, 'tentativi' => 0 ) );
            $I->dontSeeInDatabase( 'immagini', array( 'id' => $id, 'timestamp_scalamento' => NULL ) );

        }

        // un file che non è un'immagine esce dalla coda col token di stato
        public function fileNonScalabile( BackendTester $I ) {

            $id = $I->haveInDatabase( 'immagini', array(
                'nome' => $I->grabTestName( 'svg' ),
                'path' => 'var/immagini/logo.svg'
            ) );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/task/IM000.immagini/images.resize?id=' . $id );

            $I->seeInDatabase( 'immagini', array( 'id' => $id, 'token' => 'NON_SCALABILE', 'timestamp_scalamento' => NULL ) );

        }

        // una riga abbandonata si sblocca, all'ultimo tentativo si ferma, e lo scalamento forzato la fa ripartire
        public function rigaAbbandonata( BackendTester $I ) {

            global $cf;

            $id = $I->haveInDatabase( 'immagini', array(
                'nome' => $I->grabTestName( 'bloccata' ),
                'path' => 'var/immagini/TEST-E2E-inesistente.jpg',
                'token' => 'TEST-E2E-giro-morto',
                'tentativi' => $cf['image']['tentativi_massimi'] - 1,
                'timestamp_elaborazione' => time() - ( $cf['image']['minuti_sblocco'] + 1 ) * 60
            ) );

            $svg = $I->haveInDatabase( 'immagini', array(
                'nome' => $I->grabTestName( 'svg' ),
                'path' => 'var/immagini/logo.svg'
            ) );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPage( '/task/IM000.immagini/images.resize?id=' . $svg );

            $I->seeInDatabase( 'immagini', array( 'id' => $id, 'token' => 'TROPPI_TENTATIVI', 'tentativi' => $cf['image']['tentativi_massimi'] ) );

            $I->amOnPage( '/status/images.resize.status' );
            $I->see( 'immagini ferme per troppi tentativi (' );
            $I->see( 'TEST-E2E-inesistente.jpg' );

            $I->amOnPage( '/task/IM000.immagini/images.resize?id=' . $id );

            $I->seeInDatabase( 'immagini', array( 'id' => $id, 'token' => NULL, 'tentativi' => 0 ) );

        }

    }
