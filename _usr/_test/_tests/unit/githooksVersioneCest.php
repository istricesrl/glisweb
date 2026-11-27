<?php

/**
 * test degli hook git sulla versione del framework ( .githooks/pre-commit e commit-msg )
 *
 * _etc/_current.version deve cambiare solo insieme a un commit: pre-commit la riscrive prima che
 * commit-msg legga il messaggio, quindi se commit-msg rifiuta il commit deve rimetterla com'era;
 * qui lo si prova su un repository git temporaneo con gli hook e le guardie del framework, senza
 * toccare il repository vero
 *
 */

class githooksVersioneCest
{

    // repository temporaneo
    private $repo;

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        $this->repo = sys_get_temp_dir() . '/glisweb-test-githooks-' . getmypid();
        exec( 'rm -rf ' . escapeshellarg( $this->repo ) );
        $radice = realpath( __DIR__ . '/../../../..' );
        foreach( array( '.githooks', '_src/_sh', '_etc' ) as $dir ) {
            mkdir( $this->repo . '/' . $dir, 0777, true );
        }
        foreach( array( '.githooks/pre-commit', '.githooks/commit-msg', '_src/_sh/_test.guardia.sh', '_src/_sh/_patch.guardia.sh' ) as $file ) {
            copy( $radice . '/' . $file, $this->repo . '/' . $file );
            chmod( $this->repo . '/' . $file, 0755 );
        }
        file_put_contents( $this->repo . '/_etc/_current.version', "20000101000000\n" );
        $this->git( 'init -q' );
        $this->git( 'config user.email test@example.invalid' );
        $this->git( 'config user.name test' );
        $this->git( 'add -A' );
        $this->git( 'commit -q --no-verify -m base' );
        $this->git( 'config core.hooksPath .githooks' );
    }

    // pulizia post test
    public function _after(UnitTester $I)
    {
        exec( 'rm -rf ' . escapeshellarg( $this->repo ) );
    }

    // lancia un comando git nel repository temporaneo, restituendo l'exit code
    private function git( $args )
    {
        exec( 'cd ' . escapeshellarg( $this->repo ) . ' && git ' . $args . ' > /dev/null 2>&1', $out, $rc );
        return $rc;
    }

    // mette in stage un file e prova a committarlo col messaggio dato, restituendo l'exit code
    private function commit( $file, $messaggio )
    {
        @mkdir( dirname( $this->repo . '/' . $file ), 0777, true );
        file_put_contents( $this->repo . '/' . $file, 'x' );
        $this->git( 'add ' . escapeshellarg( $file ) );
        return $this->git( 'commit -q -m ' . escapeshellarg( $messaggio ) );
    }

    // commit rifiutato -> la versione resta quella dell'ultimo commit, su disco e in stage
    public function rifiutatoNonTocca(UnitTester $I)
    {
        $I->assertNotEquals( 0, $this->commit( '_src/_lib/_prova.tools.php', 'prova' ) );
        $I->assertEquals( "20000101000000\n", file_get_contents( $this->repo . '/_etc/_current.version' ) );
        exec( 'cd ' . escapeshellarg( $this->repo ) . ' && git status --porcelain -- _etc/_current.version', $out );
        $I->assertEquals( array(), $out );
    }

    // commit accettato -> la versione cambia ed entra nel commit
    public function accettatoAggiorna(UnitTester $I)
    {
        $I->assertEquals( 0, $this->commit( 'leggimi.md', 'prova' ) );
        exec( 'cd ' . escapeshellarg( $this->repo ) . ' && git show HEAD:_etc/_current.version', $out );
        $I->assertNotEquals( '20000101000000', $out[0] );
        $I->assertEquals( $out[0] . "\n", file_get_contents( $this->repo . '/_etc/_current.version' ) );
    }

}
