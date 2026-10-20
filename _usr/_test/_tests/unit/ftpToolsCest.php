<?php

use Codeception\Template\Acceptance;

class ftpToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        global $cf;
        if( empty( $cf['ftp']['server'] ) ) {
            $I->markTestSkipped( 'il deploy non ha un server FTP configurato' );
        }
    }

    // ftpConnect() -> si connette al server FTP
    public function ftpConnect(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpConnect.01.php');
        $I->see("FTP Buffer");
        $I->dontSee('bool(false)');
    }

    // ftpClose() -> chiude la connessione al server FTP
    public function ftpClose(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpClose.01.php');
        $I->see('bool(true)');
        $I->dontSee('bool(false)');
    }

    // ftpPutFile() -> carica un file sul server FTP
    public function ftpPutFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpPutFile.01.php');
        $I->see('bool(true)');
        $I->dontSee('bool(false)');
    }

    // ftpGetFile() -> scarica un file dal server FTP
    public function ftpGetFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpGetFile.01.php');
        $I->see('string(10)');
        $I->dontSee('bool(false)');
    }

    // ftpGetUploadTypeByFile() -> restituisce il tipo di upload in base al file
    public function ftpGetUploadTypeByFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpGetUploadTypeByFile.01.php');
        $I->see('int(1)');
        $I->dontSee('bool(false)');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}