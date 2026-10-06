<?php

use Codeception\Template\Acceptance;

class cryptographyToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // encryptString() -> deve restituire una stringa crittografata
    public function encryptString(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cryptography.tools/_encryptString.01.php');
        $I->see("string 'y32VOlv7x3MuzMn7' (length=16)");
    }

    // decryptString() -> deve restituire una stringa decrittografata
    public function decryptString(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cryptography.tools/_decryptString.01.php');
        $I->see("string 'TEST CONTENT' (length=12)");
    }

    // getAvailableHashMethod() -> deve restituire un array di metodi di hash disponibili
    public function getAvailableHashMethod(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cryptography.tools/_getAvailableHashMethod.01.php');

        $page = $I->grabPageSource();

        $validMethods = [
            "sha3-512",
            "sha512",
            "sha256",
            "bcrypt"
        ];

        $matches = array_filter($validMethods, function($method) use ($page) { return strpos($page, $method) !== false; });
        $I->assertNotEmpty($matches, 'Nessuno dei metodi di hash attesi è presente nella pagina');
    }

    // getAvailableHashMethods() -> deve restituire un array di metodi di hash disponibili
    public function getAvailableHashMethods(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cryptography.tools/_getAvailableHashMethods.01.php');

        $page = $I->grabPageSource();

        $validMethods = [
            "sha3-512",
            "sha512",
            "sha256",
            "bcrypt"
        ];

        $matches = array_filter($validMethods, function($method) use ($page) { return strpos($page, $method) !== false; });
        $I->assertNotEmpty($matches, 'Nessuno dei metodi di hash attesi è presente nella pagina');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}