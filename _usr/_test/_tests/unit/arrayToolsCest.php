<?php

class arrayToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // string2array() -> deve restituire un array con i valori separati dal separatore di default
    public function string2array01(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_string2array.01.php');
        $I->see('[0]=> string(4) "val1"');
        $I->see('[1]=> string(4) "val2"');
        $I->see('[2]=> string(4) "val3"');
    }

    // string2array() -> deve restituire un array con i valori separati dal separatore specificato
    public function string2array02(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_string2array.02.php');
        $I->see('[0]=> string(4) "val1"');
        $I->see('[1]=> string(4) "val2"');
        $I->see('[2]=> string(4) "val3"');
    }

    // string2array() -> deve restituire un array vuoto
    public function string2array03(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_string2array.03.php');
        $I->see('array(0) {');
    }

    // array2string() -> deve restituire una stringa con i valori separati dal separatore di default
    public function array2string01(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_array2string.01.php');
        $I->see('(14) "val1|val2|val3"');
    }

    // array2string() -> deve restituire una stringa con i valori separati dal separatore di default
    public function array2string02(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_array2string.02.php');
        $I->see('(14) "val1;val2;val3"');
    }

    // array2string() -> deve restituire una stringa vuota
    public function array2string03(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_array2string.03.php');
        $I->see('(0) ""');
    }

    // rksort() -> deve restituire un array ordinato per chiave
    public function rksort(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_rksort.01.php');
        $I->see('string(12) "key1key2key3"');
        $I->see('string(8) "key4key5"');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }
}