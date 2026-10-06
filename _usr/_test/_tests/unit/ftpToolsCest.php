<?php

use Codeception\Template\Acceptance;

class ftpToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // ftpConnect() -> si connette al server FTP
    public function ftpConnect(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpConnect.01.php');
        $I->see("FTP Buffer");
        $I->dontSee('boolean false');
    }

    // ftpClose() -> chiude la connessione al server FTP
    public function ftpClose(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpClose.01.php');
        $I->see("boolean true");
        $I->dontSee("boolean false");
    }

    // ftpPutFile() -> carica un file sul server FTP
    public function ftpPutFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpPutFile.01.php');
        $I->see("boolean true");
        $I->dontSee("boolean false");
    }

    // ftpGetFile() -> scarica un file dal server FTP
    public function ftpGetFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpGetFile.01.php');
        $I->see("(length=10)");
        $I->dontSee("boolean false");
    }

    // ftpGetUploadTypeByFile() -> restituisce il tipo di upload in base al file
    public function ftpGetUploadTypeByFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpGetUploadTypeByFile.01.php');
        $I->see("int 1");
        $I->dontSee("boolean false");
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}