<?php

/**
 * test della guardia delle patch ( _src/_sh/_patch.guardia.sh )
 *
 * la guardia rifiuta un commit che cambia lo schema nei file base senza una patch datata, a meno che
 * il messaggio dichiari "Senza-patch: <motivo>"; qui la si prova su un repository git temporaneo,
 * mettendo in stage file diversi e controllandone l'exit code, senza toccare il repository vero
 *
 */

class patchGuardiaCest
{

    // repository temporaneo
    private $repo;

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        $this->repo = sys_get_temp_dir() . '/glisweb-test-guardia-patch-' . getmypid();
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
        $guardia = realpath( __DIR__ . '/../../../../_src/_sh/_patch.guardia.sh' );
        exec( 'cd ' . escapeshellarg( $this->repo ) . ' && bash ' . escapeshellarg( $guardia ) . ' --staged .msg', $out, $rc );
        return $rc;
    }

    // tabelle senza patch -> rifiutato
    public function tabelleSenzaPatch(UnitTester $I)
    {
        $I->assertEquals( 1, $this->guardia( array( '_usr/_database/_patch/_010000999999.tables.sql' ), 'prova' ) );
    }

    // vincoli senza patch -> rifiutato
    public function vincoliSenzaPatch(UnitTester $I)
    {
        $I->assertEquals( 1, $this->guardia( array( '_usr/_database/_patch/_060000999999.constraints.sql' ), 'prova' ) );
    }

    // tabelle con la patch datata -> accettato
    public function tabelleConPatch(UnitTester $I)
    {
        $I->assertEquals( 0, $this->guardia( array( '_usr/_database/_patch/_010000999999.tables.sql', '_usr/_database/_patch/_202611041900.prova.sql' ), 'prova' ) );
    }

    // assorbimento di un rilascio: la patch datata tolta conta come patch -> accettato
    public function assorbimento(UnitTester $I)
    {
        $this->guardia( array( '_usr/_database/_patch/_202611041900.prova.sql' ), 'prova' );
        exec( 'git -C ' . escapeshellarg( $this->repo ) . ' -c user.name=t -c user.email=t@t commit -q -m prova 2>&1', $o, $rc );
        $I->assertEquals( 0, $rc, implode( "\n", $o ) );
        exec( 'git -C ' . escapeshellarg( $this->repo ) . ' rm -q _usr/_database/_patch/_202611041900.prova.sql 2>&1', $o, $rc );
        $I->assertEquals( 0, $rc, implode( "\n", $o ) );
        $I->assertEquals( 0, $this->guardia( array( '_usr/_database/_patch/_010000999999.tables.sql' ), 'prova' ) );
    }

    // deroga dichiarata -> accettato
    public function derogaDichiarata(UnitTester $I)
    {
        $I->assertEquals( 0, $this->guardia( array( '_usr/_database/_patch/_010000999999.tables.sql' ), "prova\n\nSenza-patch: solo commenti nel file base" ) );
    }

    // deroga senza motivo -> rifiutato
    public function derogaVuota(UnitTester $I)
    {
        $I->assertEquals( 1, $this->guardia( array( '_usr/_database/_patch/_010000999999.tables.sql' ), "prova\n\nSenza-patch:" ) );
    }

    // viste: non vanno nelle patch, non sono sotto guardia -> accettato
    public function soloViste(UnitTester $I)
    {
        $I->assertEquals( 0, $this->guardia( array( '_usr/_database/_patch/_090000999999.views.sql' ), 'prova' ) );
    }

    // nessun file base -> accettato
    public function nienteSchema(UnitTester $I)
    {
        $I->assertEquals( 0, $this->guardia( array( '_usr/_docs/_read/300.database.md' ), 'prova' ) );
    }

}
