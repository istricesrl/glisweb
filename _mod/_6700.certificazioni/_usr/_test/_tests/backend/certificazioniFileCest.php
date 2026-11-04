<?php

    /**
     * test della cancellazione dei file di una certificazione
     *
     * scritto il 04/11/2026: cancellando una certificazione i suoi file restavano sul disco, e dove la FK
     * file.id_anagrafica_certificazioni è SET NULL anche le righe di file ( 200 su polmasi, certificati medici ); ora
     * _anagrafica.certificazioni.before.php cancella le righe e sposta i file nel cestino ( trashFile(), dal 04/11/2026 ),
     * salvo un percorso usato anche da un'altra riga
     *
     * le righe si cancellano passando da controller(); certificazioni e file di test hanno il prefisso TEST-E2E-
     *
     */

    class certificazioniFileCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulizia( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulizia( $I );

        }

        // toglie certificazioni, righe di file e file di test
        protected function pulizia( BackendTester $I ) {

            $I->deleteTestRecords( 'file', 'path', true );
            $I->deleteTestRecords( 'anagrafica_certificazioni', 'nome' );

            foreach( glob( DIR_BASE . 'var/uploads/certificazioni/TEST-E2E-*' ) as $f ) {
                unlink( $f );
            }

            foreach( glob( DIR_TMP_GARBAGE . '*/var/uploads/certificazioni/TEST-E2E-*' ) as $f ) {
                unlink( $f );
            }

        }

        // scrive passando da controller(), con la firma di importazione e il controllo pieno sulla tabella per la sola
        // durata della chiamata, come indirizziGiaPresentiCest; restituisce lo stato
        protected function scrivi( $tabella, &$dati, $metodo ) {

            global $cf;

            $segreto = $cf['auth']['import']['secret'] ?? NULL;
            $cf['auth']['import']['secret'] = $segreto ?? uniqid( 'TEST-E2E-', true );

            $dati['__firma__'] = hash( getAvailableHashMethod(), $tabella . $cf['auth']['import']['secret'] );

            $sessione = $_SESSION['account'] ?? NULL;
            $_SESSION['account']['permissions'][ $tabella ] = array( CONTROL_FULL );

            $stato = controller( $cf['mysql']['connection'], $cf['memcache']['connection'], $dati, $tabella, $metodo );

            if( $sessione === NULL ) {
                unset( $_SESSION['account'] );
            } else {
                $_SESSION['account'] = $sessione;
            }

            if( $segreto === NULL ) {
                unset( $cf['auth']['import']['secret'] );
            }

            return $stato;

        }

        // crea una certificazione con un file allegato, scritto anche sul disco; restituisce id e percorso
        protected function certificazioneConFile( BackendTester $I ) {

            $nome = $I->grabTestName( 'certificazione' );
            $path = 'var/uploads/certificazioni/' . $nome . '.txt';

            checkFolder( DIR_BASE . 'var/uploads/certificazioni' );
            file_put_contents( DIR_BASE . $path, $nome );

            $id = $I->haveInDatabase( 'anagrafica_certificazioni', array( 'nome' => $nome ) );
            $I->haveInDatabase( 'file', array( 'id_anagrafica_certificazioni' => $id, 'path' => $path ) );

            return array( $id, $path );

        }

        // cancellando la certificazione vanno via la riga di file e il file sul disco, che finisce nel cestino
        public function fileCancellatoConLaCertificazione( BackendTester $I ) {

            list( $id, $path ) = $this->certificazioneConFile( $I );

            $dati = array( 'id' => $id );
            $this->scrivi( 'anagrafica_certificazioni', $dati, METHOD_DELETE );

            $I->dontSeeInDatabase( 'anagrafica_certificazioni', array( 'id' => $id ) );
            $I->dontSeeInDatabase( 'file', array( 'path' => $path ) );
            $I->assertFileDoesNotExist( DIR_BASE . $path );
            $I->assertFileExists( DIR_TMP_GARBAGE . date( 'Ymd' ) . '/' . $path );

        }

        // un percorso usato anche da un'altra riga di file resta sul disco
        public function fileCondivisoNonCancellato( BackendTester $I ) {

            list( $id, $path ) = $this->certificazioneConFile( $I );
            $I->haveInDatabase( 'file', array( 'path' => $path ) );

            $dati = array( 'id' => $id );
            $this->scrivi( 'anagrafica_certificazioni', $dati, METHOD_DELETE );

            $I->dontSeeInDatabase( 'file', array( 'path' => $path, 'id_anagrafica_certificazioni' => $id ) );
            $I->seeInDatabase( 'file', array( 'path' => $path ) );
            $I->assertFileExists( DIR_BASE . $path );

        }

    }
