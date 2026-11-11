<?php

/**
 * test dello script degli screenshot della documentazione ( _src/_sh/_docs.shots.sh )
 *
 * lo script deve rifiutare un DOCS_HOST senza protocollo, che farebbe fotografare il login, e sui
 * deploy senza var/docs.build.conf deve saltare gli scatti dello standard, che finirebbero sotto
 * _usr/ coi dati del cliente; qui lo si prova con --dry-run su un deploy finto temporaneo, che non
 * scarica e non scrive niente, quindi chromium e il sito non servono
 *
 */

class docsShotsCest
{

    // deploy finto temporaneo
    private $deploy;

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        $this->deploy = sys_get_temp_dir() . '/glisweb-test-docs-shots-' . getmypid();
        exec( 'rm -rf ' . escapeshellarg( $this->deploy ) );
        $radice = realpath( __DIR__ . '/../../../..' );
        foreach( array( '_src/_sh/_lib', '_usr/_docs', 'usr/docs', '_etc', 'var' ) as $dir ) {
            mkdir( $this->deploy . '/' . $dir, 0777, true );
        }
        copy( $radice . '/_src/_sh/_docs.shots.sh', $this->deploy . '/_src/_sh/_docs.shots.sh' );
        copy( $radice . '/_src/_sh/_lib/_functions.sh', $this->deploy . '/_src/_sh/_lib/_functions.sh' );
        touch( $this->deploy . '/_etc/_current.release' );
        file_put_contents( $this->deploy . '/_usr/_docs/a.md', "<!-- @shot: std.uno | /admin | 800x600 -->\n" );
        file_put_contents( $this->deploy . '/usr/docs/b.md', "<!-- @shot: prj.due | /x | 800x600 -->\n" );
    }

    // pulizia post test
    public function _after(UnitTester $I)
    {
        exec( 'rm -rf ' . escapeshellarg( $this->deploy ) );
    }

    // lancia lo script in prova con l'host dato, restituendo exit code e output
    private function scatti( $host )
    {
        $cmd = 'DOCS_USER=x DOCS_PASS=y DOCS_HOST=' . escapeshellarg( $host )
             . ' bash ' . escapeshellarg( $this->deploy . '/_src/_sh/_docs.shots.sh' ) . ' --dry-run --force 2>&1';
        exec( $cmd, $out, $rc );
        return array( $rc, implode( "\n", $out ) );
    }

    // host senza protocollo -> rifiutato
    public function hostSenzaProtocollo(UnitTester $I)
    {
        if( ! $this->chromium() ) { $I->markTestSkipped( 'chromium non installato' ); }
        list( $rc, $out ) = $this->scatti( 'example.invalid' );
        $I->assertEquals( 1, $rc );
        $I->assertStringContainsString( 'senza protocollo', $out );
    }

    // deploy cliente -> lo scatto dello standard si salta, quello di progetto no
    public function standardSaltatoSulCliente(UnitTester $I)
    {
        if( ! $this->chromium() ) { $I->markTestSkipped( 'chromium non installato' ); }
        list( $rc, $out ) = $this->scatti( 'https://example.invalid' );
        $I->assertEquals( 0, $rc );
        $I->assertStringContainsString( 'saltato   std.uno', $out );
        $I->assertStringContainsString( 'prj.due -> ./usr/docs/shot/prj.due.png', $out );
    }

    // deploy del framework -> si fotografano tutti e due
    public function standardSulFramework(UnitTester $I)
    {
        if( ! $this->chromium() ) { $I->markTestSkipped( 'chromium non installato' ); }
        touch( $this->deploy . '/var/docs.build.conf' );
        list( $rc, $out ) = $this->scatti( 'https://example.invalid' );
        $I->assertEquals( 0, $rc );
        $I->assertStringContainsString( 'std.uno -> ./_usr/_docs/_shot/std.uno.png', $out );
        $I->assertStringNotContainsString( 'saltato', $out );
    }

    // lo script esce prima di tutto se chromium manca, quindi senza non c'e' niente da provare
    private function chromium()
    {
        exec( 'command -v chromium || command -v chromium-browser || command -v google-chrome', $out, $rc );
        return $rc === 0;
    }

}
