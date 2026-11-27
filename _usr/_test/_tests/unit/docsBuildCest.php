<?php

/**
 * test del generatore della documentazione ( _src/_cli/_docs.build.php )
 *
 * la protezione della documentazione di progetto e' fail-closed, quindi il generatore non deve mai
 * dichiarare "protezione garantita" o "pubblicata" quando la scrittura e' fallita, e deve uscire con
 * un codice diverso da zero perche' _gw.upgrade.sh e _codeception.run.sh se ne accorgano; qui lo si
 * prova con --test su un deploy finto temporaneo, facendo fallire le scritture con un file al posto
 * di una cartella, che fallisce anche da root ( un chmod no: root lo scavalca )
 *
 */

class docsBuildCest
{

    // deploy finto temporaneo
    private $deploy;

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        $this->deploy = sys_get_temp_dir() . '/glisweb-test-docs-build-' . getmypid();
        exec( 'rm -rf ' . escapeshellarg( $this->deploy ) );
        $radice = realpath( __DIR__ . '/../../../..' );
        foreach( array( '_src/_cli', 'etc/secret', 'usr', 'var/spool/test/20261117000000' ) as $dir ) {
            mkdir( $this->deploy . '/' . $dir, 0777, true );
        }
        copy( $radice . '/_src/_cli/_docs.build.php', $this->deploy . '/_src/_cli/_docs.build.php' );
        symlink( $radice . '/_src/_lib', $this->deploy . '/_src/_lib' );
        file_put_contents( $this->deploy . '/etc/secret/.htpasswd', "docs:x\n" );
        file_put_contents( $this->deploy . '/var/spool/test/20261117000000/esito.md', "# esito\n\n- esito: ok\n" );
    }

    // pulizia post test
    public function _after(UnitTester $I)
    {
        exec( 'rm -rf ' . escapeshellarg( $this->deploy ) );
    }

    // lancia la pubblicazione dell'esito dei test, restituendo exit code e output
    private function genera()
    {
        $cmd = 'cd ' . escapeshellarg( $this->deploy ) . ' && php _src/_cli/_docs.build.php --test 2>&1';
        exec( $cmd, $out, $rc );
        return array( $rc, implode( "\n", $out ) );
    }

    // tutto scrivibile -> protezione e pubblicazione, uscita zero
    public function pubblicazioneRiuscita(UnitTester $I)
    {
        list( $rc, $out ) = $this->genera();
        $I->assertEquals( 0, $rc, $out );
        $I->assertStringContainsString( 'protezione garantita in usr/pages/test/.htaccess', $out );
        $I->assertStringContainsString( "pubblicata l'esecuzione 20261117000000", $out );
        $I->assertFileExists( $this->deploy . '/usr/pages/test/index.html' );
    }

    // la cartella non si crea -> niente "garantita", niente pubblicazione, uscita 3
    public function cartellaNonCreata(UnitTester $I)
    {
        touch( $this->deploy . '/usr/pages' );
        list( $rc, $out ) = $this->genera();
        $I->assertEquals( 3, $rc, $out );
        $I->assertStringContainsString( 'NON protetta usr/pages/test', $out );
        $I->assertStringNotContainsString( 'protezione garantita', $out );
        $I->assertStringNotContainsString( 'pubblicata', $out );
    }

    // la pagina non si scrive -> la protezione si', la pubblicazione no, uscita 3
    public function paginaNonScritta(UnitTester $I)
    {
        mkdir( $this->deploy . '/usr/pages/test/index.html', 0777, true );
        list( $rc, $out ) = $this->genera();
        $I->assertEquals( 3, $rc, $out );
        $I->assertStringContainsString( 'protezione garantita', $out );
        $I->assertStringContainsString( 'NON generato usr/pages/test/index.html: scrittura fallita', $out );
        $I->assertStringNotContainsString( 'pubblicata', $out );
    }

}
