<?php

class apcuToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // apcuUniqueKey() -> deve restituire un valore con il suffisso univoco del sito
    public function apcuUniqueKey(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuUniqueKey.01.php');
        $I->see('GLISDEV_ISTRICESRL_COM_TEST');
    }

    // apcuAddKeyAgeSuffix() -> deve restituire un valore con il suffisso '_AGE'
    public function apcuAddKeyAgeSuffix(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuAddKeyAgeSuffix.01.php');
        $I->see('TEST_AGE');
    }

    // apcuWrite() -> deve restituire true
    public function apcuWrite(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuWrite.01.php');
        $I->see('boolean true');
    }

    // apcuGetKeyAge() -> deve restituire un int
    public function apcuGetKeyAge(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuGetKeyAge.01.php');
        $I->see('boolean true');
        $I->see('int ');
    }

    // apcuRead() -> deve restituire il valore scritto con apcuWrite()
    public function apcuRead(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuRead.01.php');
        $I->see('boolean true');
        $I->see('TEST CONTENT');
    }

    // apcuDelete() -> deve restituire true
    public function apcuDelete(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuDelete.01.php');
        $I->see('boolean true');
    }

    // apcuFlush() -> deve restituire true
    public function apcuFlush(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuFlush.01.php');
        $I->see('boolean true');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}
