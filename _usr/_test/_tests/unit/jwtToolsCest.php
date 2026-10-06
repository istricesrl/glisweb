<?php

use Codeception\Template\Acceptance;

class jwtToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // getJwt() -> deve restituire un token JWT
    public function getJwt(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_jwt.tools/_getJwt.01.php');
        $I->see("string 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJrZXkxIjoidmFsMSIsImtleTIiOiJ2YWwyIn0.fCgASJgFuiqPXoxCWpJM_UYaBDNVF_3vfg1JPeUMURQ' (length=120)");
    }

    // checkJwt() -> deve restituire true se il token passato è corretto
    public function checkJwt01(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_jwt.tools/_checkJwt.01.php');
        $I->see('boolean true');
    }

    // checkJwt() -> deve restituire false se il token passato è errato
    public function checkJwt02(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_jwt.tools/_checkJwt.02.php');
        $I->see('boolean false');
    }

    // cleanJwt() -> deve restituire una stringa pulita
    public function cleanJwt(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_jwt.tools/_cleanJwt.01.php');
        $I->see("string 'prova-token_clean1' (length=18)");
    }

    // jwt2array() -> deve restituire un array del token passato
    public function jwt2array(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_jwt.tools/_jwt2array.01.php');
        $I->see("array (size=2)");
        $I->see("'head' => ");
        $I->see("array (size=2)");
        $I->see("'typ' => string 'JWT' (length=3)");
        $I->see("'alg' => string 'HS256' (length=5)");
        $I->see("'data' => ");
        $I->see("array (size=2)");
        $I->see("'key1' => string 'val1' (length=4)");
        $I->see("'key2' => string 'val2' (length=4)");
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}