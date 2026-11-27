<?php

/**
 * test della guardia dei test ( _src/_sh/_test.guardia.sh )
 *
 * la guardia rifiuta un commit che tocca il codice senza toccare nessun test, a meno che il
 * messaggio dichiari "Senza-test: <motivo>"; qui la si prova su un repository git temporaneo,
 * mettendo in stage file diversi e controllandone l'exit code, senza toccare il repository vero
 *
 */

class testGuardiaCest
{

    // repository temporaneo
    private $repo;

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        $this->repo = sys_get_temp_dir() . '/glisweb-test-guardia-' . getmypid();
        exec( 'rm -rf ' . escapeshellarg( $this->repo ) );
        mkdir( $this->repo );
        exec( 'git -C ' . escapeshellarg( $this->repo ) . ' init -q' );
    }

    // pulizia post test
    public function _after(UnitTester $I)
    {
        exec( 'rm -rf ' . escapeshellarg( $this->repo ) );
    }

    // mette in stage i file indicati e lancia la guardia col messaggio dato, restituendo l'exit code
    private function guardia( $files, $messaggio )
    {
        foreach( $files as $file ) {
            @mkdir( dirname( $this->repo . '/' . $file ), 0777, true );
            file_put_contents( $this->repo . '/' . $file, 'x' );
            exec( 'git -C ' . escapeshellarg( $this->repo ) . ' add ' . escapeshellarg( $file ) );
        }
        file_put_contents( $this->repo . '/.msg', $messaggio );
        $guardia = realpath( __DIR__ . '/../../../../_src/_sh/_test.guardia.sh' );
        exec( 'cd ' . escapeshellarg( $this->repo ) . ' && bash ' . escapeshellarg( $guardia ) . ' --staged .msg', $out, $rc );
        return $rc;
    }

    // codice senza test -> rifiutato
    public function codiceSenzaTest(UnitTester $I)
    {
        $I->assertEquals( 1, $this->guardia( array( '_src/_lib/_prova.tools.php' ), 'prova' ) );
    }

    // codice di un modulo senza test -> rifiutato
    public function moduloSenzaTest(UnitTester $I)
    {
        $I->assertEquals( 1, $this->guardia( array( '_mod/_AN000.anagrafica/_src/_inc/_prova.php' ), 'prova' ) );
    }

    // codice col suo test -> accettato
    public function codiceConTest(UnitTester $I)
    {
        $I->assertEquals( 0, $this->guardia( array( '_src/_lib/_prova.tools.php', '_usr/_test/_tests/unit/provaCest.php' ), 'prova' ) );
    }

    // codice con la pagina di esempio della libreria -> accettato
    public function codiceConEsempio(UnitTester $I)
    {
        $I->assertEquals( 0, $this->guardia( array( '_src/_lib/_prova.tools.php', '_usr/_examples/_lib/_prova.tools/_prova.01.php' ), 'prova' ) );
    }

    // codice con la deroga dichiarata -> accettato
    public function codiceConDeroga(UnitTester $I)
    {
        $I->assertEquals( 0, $this->guardia( array( '_src/_lib/_prova.tools.php' ), "prova\n\nSenza-test: servizio esterno senza sandbox" ) );
    }

    // deroga senza motivo -> rifiutato
    public function derogaVuota(UnitTester $I)
    {
        $I->assertEquals( 1, $this->guardia( array( '_src/_lib/_prova.tools.php' ), "prova\n\nSenza-test:" ) );
    }

    // solo documentazione -> accettato
    public function soloDocumentazione(UnitTester $I)
    {
        $I->assertEquals( 0, $this->guardia( array( '_usr/_docs/_read/180.test.md' ), 'prova' ) );
    }

    // librerie esterne -> non sono codice nostro, accettato
    public function libreriaEsterna(UnitTester $I)
    {
        $I->assertEquals( 0, $this->guardia( array( '_src/_lib/_ext/vendor/x.php' ), 'prova' ) );
    }

}
