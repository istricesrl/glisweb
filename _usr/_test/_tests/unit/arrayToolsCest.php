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
        $I->see("0 => string 'val1' (length=4)");
        $I->see("1 => string 'val2' (length=4)");
        $I->see("2 => string 'val3' (length=4)");
    }

    // string2array() -> deve restituire un array con i valori separati dal separatore specificato
    public function string2array02(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_string2array.02.php');
        $I->see("0 => string 'val1' (length=4)");
        $I->see("1 => string 'val2' (length=4)");
        $I->see("2 => string 'val3' (length=4)");
    }

    // string2array() -> deve restituire un array vuoto
    public function string2array03(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_string2array.03.php');
        $I->see("array (size=0)");
    }

    // array2string() -> deve restituire una stringa con i valori separati dal separatore di default
    public function array2string01(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_array2string.01.php');
        $I->see("'val1|val2|val3' (length=14)");
    }

    // array2string() -> deve restituire una stringa con i valori separati dal separatore di default
    public function array2string02(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_array2string.02.php');
        $I->see("'val1;val2;val3' (length=14)");
    }

    // array2string() -> deve restituire una stringa vuota
    public function array2string03(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_array2string.03.php');
        $I->see("'' (length=0)");
    }

    // rksort() -> deve restituire un array ordinato per chiave
    public function rksort(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_array.tools/_rksort.01.php');
        $I->see("string 'key1key2key3' (length=12)");
        $I->see("string 'key4key5' (length=8)");
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }
}