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
        $I->see('string(120) "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJrZXkxIjoidmFsMSIsImtleTIiOiJ2YWwyIn0.fCgASJgFuiqPXoxCWpJM_UYaBDNVF_3vfg1JPeUMURQ"');
    }

    // checkJwt() -> deve restituire true se il token passato è corretto
    public function checkJwt01(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_jwt.tools/_checkJwt.01.php');
        $I->see('bool(true)');
    }

    // checkJwt() -> deve restituire false se il token passato è errato
    public function checkJwt02(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_jwt.tools/_checkJwt.02.php');
        $I->see('bool(false)');
    }

    // cleanJwt() -> deve restituire una stringa pulita
    public function cleanJwt(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_jwt.tools/_cleanJwt.01.php');
        $I->see('string(18) "prova-token_clean1"');
    }

    // jwt2array() -> deve restituire un array del token passato
    public function jwt2array(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_jwt.tools/_jwt2array.01.php');
        $I->see('array(2) {');
        $I->see('["head"]=>');
        $I->see('array(2) {');
        $I->see('["typ"]=> string(3) "JWT"');
        $I->see('["alg"]=> string(5) "HS256"');
        $I->see('["data"]=>');
        $I->see('array(2) {');
        $I->see('["key1"]=> string(4) "val1"');
        $I->see('["key2"]=> string(4) "val2"');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}