<?php

class apcuToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // senza l'estensione APCu le funzioni di scrittura e lettura restituiscono false, e non c'e' niente da provare;
    // l'estensione si guarda nel processo dei test, che di solito ha la stessa configurazione di PHP del sito
    protected function saltaSenzaApcu(UnitTester $I)
    {
        if( ! function_exists( 'apcu_store' ) ) {
            $I->markTestSkipped( 'APCu non installato' );
        }
    }

    // apcuUniqueKey() -> deve restituire un valore con il suffisso univoco del sito
    public function apcuUniqueKey(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuUniqueKey.01.php');
        $I->see( APCU_UNIQUE_SEED . 'TEST' );
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
        $this->saltaSenzaApcu($I);
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuWrite.01.php');
        $I->see('bool(true)');
    }

    // apcuGetKeyAge() -> deve restituire un int
    public function apcuGetKeyAge(UnitTester $I)
    {
        $this->saltaSenzaApcu($I);
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuGetKeyAge.01.php');
        $I->see('bool(true)');
        $I->see('int(');
    }

    // apcuRead() -> deve restituire il valore scritto con apcuWrite()
    public function apcuRead(UnitTester $I)
    {
        $this->saltaSenzaApcu($I);
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuRead.01.php');
        $I->see('bool(true)');
        $I->see('TEST CONTENT');
    }

    // apcuDelete() -> deve restituire true
    public function apcuDelete(UnitTester $I)
    {
        $this->saltaSenzaApcu($I);
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuDelete.01.php');
        $I->see('bool(true)');
    }

    // apcuFlush() -> deve restituire true
    public function apcuFlush(UnitTester $I)
    {
        $this->saltaSenzaApcu($I);
        $I->amOnPage('/_usr/_examples/_lib/_apcu.tools/_apcuFlush.01.php');
        $I->see('bool(true)');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}
