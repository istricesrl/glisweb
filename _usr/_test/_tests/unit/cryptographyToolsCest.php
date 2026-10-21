<?php

use Codeception\Template\Acceptance;

class cryptographyToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // encryptString() -> deve restituire il base64 di IV, testo cifrato e MAC, con un IV diverso a ogni chiamata
    public function encryptString(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cryptography.tools/_encryptString.01.php');
        $I->see("base64 valido: true");
        $I->see("lunghezza grezza: 60");
        $I->see("contiene il chiaro: false");
        $I->see("IV diverso a ogni chiamata: true");
        $I->see("risultati diversi: true");
        $I->see("round trip: 'TEST CONTENT'");
        $I->see("round trip del secondo: 'TEST CONTENT'");
    }

    // decryptString() -> deve restituire la stringa decrittografata, e false se la stringa non è autentica
    public function decryptString(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cryptography.tools/_decryptString.01.php');
        $I->see("round trip: 'TEST CONTENT'");
        $I->see("round trip da URL: 'TEST CONTENT'");
        $I->see("MAC alterato: false");
        $I->see("testo cifrato alterato: false");
        $I->see("chiave sbagliata: false");
        $I->see("formato vecchio: false");
        $I->see("stringa vuota: false");
        $I->see("non base64: false");
        $I->see("troppo corta: false");
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