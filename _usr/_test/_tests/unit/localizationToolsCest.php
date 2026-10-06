<?php

use Codeception\Template\Acceptance;

class localizationToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // parseHttpRequestedLanguage() -> deve restituire un token JWT
    public function parseHttpRequestedLanguage(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_localization.tools/_parseHttpRequestedLanguage.01.php');
        $I->see("array");
    }

    // string2utf8() -> deve restituire un token JWT
    public function string2utf8(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_localization.tools/_string2utf8.01.php');
        $I->see("'èéòàìù'");
        $I->see("UTF-8");
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}