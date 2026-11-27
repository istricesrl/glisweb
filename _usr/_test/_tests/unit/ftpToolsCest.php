<?php

use Codeception\Template\Acceptance;

class ftpToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // i test FTP vogliono il server FTP del profilo
    private function ftp(UnitTester $I)
    {
        global $cf;
        if( empty( $cf['ftp']['server'] ) ) {
            $I->markTestSkipped( 'il deploy non ha un server FTP configurato' );
        }
    }

    // i test SFTP vogliono il server SFTP di prova di _codeception.run.sh ( sshd, ssh-keygen e l'estensione ssh2 )
    private function sftp(UnitTester $I)
    {
        global $cf;
        if( empty( $cf['ftp']['servers']['test.sftp'] ) ) {
            $I->markTestSkipped( 'manca il server SFTP di prova ( sshd, ssh-keygen o l\'estensione ssh2 )' );
        }
    }

    // ftpConnect() -> si connette al server FTP
    public function ftpConnect(UnitTester $I)
    {
        $this->ftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpConnect.01.php');
        $I->see("FTP Buffer");
        $I->dontSee('bool(false)');
    }

    // ftpClose() -> chiude la connessione al server FTP
    public function ftpClose(UnitTester $I)
    {
        $this->ftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpClose.01.php');
        $I->see('bool(true)');
        $I->dontSee('bool(false)');
    }

    // ftpPutFile() -> carica un file sul server FTP
    public function ftpPutFile(UnitTester $I)
    {
        $this->ftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpPutFile.01.php');
        $I->see('bool(true)');
        $I->dontSee('bool(false)');
    }

    // ftpGetFile() -> scarica un file dal server FTP
    public function ftpGetFile(UnitTester $I)
    {
        $this->ftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpGetFile.01.php');
        $I->see('string(10)');
        $I->dontSee('bool(false)');
    }

    // ftpGetUploadTypeByFile() -> restituisce il tipo di upload in base al file
    public function ftpGetUploadTypeByFile(UnitTester $I)
    {
        $this->ftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpGetUploadTypeByFile.01.php');
        $I->see('int(1)');
        $I->dontSee('bool(false)');
    }

    // ftpGetFileTime() -> data di un file appena caricato, false per uno che non c'e'
    public function ftpGetFileTime(UnitTester $I)
    {
        $this->ftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpGetFileTime.01.php');
        $I->see('bool(true)');
        $I->see('bool(false)');
    }

    // ftpConnect() in SFTP -> connessione con la chiave, e la cartella di login
    public function sftpConnect(UnitTester $I)
    {
        $this->sftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpConnect.02.php');
        $I->see('string(4) "sftp"');
        $I->see('var/test/sftp.mock.d/home/');
        $I->dontSee('bool(false)');
    }

    // ftpConnect() in SFTP -> con un'impronta della host key sbagliata la connessione si rifiuta
    public function sftpConnectImprontaSbagliata(UnitTester $I)
    {
        $this->sftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpConnect.03.php');
        $I->see('bool(false)');
    }

    // ftpClose() in SFTP -> chiude la sessione SSH
    public function sftpClose(UnitTester $I)
    {
        $this->sftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpClose.02.php');
        $I->see('bool(true)');
        $I->dontSee('bool(false)');
    }

    // ftpPutFile() in SFTP -> carica un file con un percorso relativo alla cartella di login
    public function sftpPutFile(UnitTester $I)
    {
        $this->sftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpPutFile.02.php');
        $I->see('bool(true)');
        $I->dontSee('bool(false)');
    }

    // ftpGetFile() in SFTP -> carica un file e lo riscarica
    public function sftpGetFile(UnitTester $I)
    {
        $this->sftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpGetFile.02.php');
        $I->see('string(10)');
        $I->dontSee('bool(false)');
    }

    // ftpListFiles() in SFTP -> elenca la cartella, senza . e ..
    public function sftpListFiles(UnitTester $I)
    {
        $this->sftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpListFiles.02.php');
        $I->see('array(1)');
        $I->see('.txt"');
    }

    // ftpGetFileTime() in SFTP -> data di un file appena caricato, false per uno che non c'e'
    public function sftpGetFileTime(UnitTester $I)
    {
        $this->sftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpGetFileTime.02.php');
        $I->see('bool(true)');
        $I->see('bool(false)');
    }

    // ftpPutFile(), ftpListFiles() e ftpGetFile() in SFTP -> # e ? nei nomi, che il wrapper ssh2.sftp:// leggerebbe come URL
    public function sftpNomiConCancelletto(UnitTester $I)
    {
        $this->sftp( $I );
        $I->amOnPage('/_usr/_examples/_lib/_ftp.tools/_ftpPutFile.03.php');
        $I->see('caricato: bool(true)');
        $I->see('elencato: bool(true)');
        $I->see('riscaricato uguale: bool(true)');
        $I->see('collegamenti rimasti: int(0)');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}
