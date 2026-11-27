<?php

class cacheUtilsCest
{

    // senza APCU il test del motore apcu non ha senso
    protected function saltaSenzaApcu(UnitTester $I)
    {
        if( ! function_exists( 'apcu_store' ) ) {
            $I->markTestSkipped( 'APCu non installato' );
        }
    }

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // cacheEngine() -> sceglie un motore, rispetta quello forzato e ignora quello che non esiste
    public function cacheEngine(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheEngine.01.php');
        $I->seeInSource("bool(true)\nstring(4) \"disk\"\nbool(true)");
    }

    // cacheWrite() -> con il motore disco deve scrivere il file in var/spool/cache/
    public function cacheWrite(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheWrite.01.php');
        $I->seeInSource("bool(true)\nbool(true)");
    }

    // cacheRead() -> deve rileggere quello che ha scritto cacheWrite(), con ogni motore disponibile
    public function cacheRead(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheRead.01.php');
        $I->see('disk: OK');
        $I->dontSee('KO');
    }

    // cacheRead() -> l'albero delle pagine scritto da _330.pages.php deve essere in cache, con qualunque motore
    public function cacheReadAlberoPagine(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheRead.02.php');
        $I->see('bool(true)');
        $I->dontSee('bool(false)');
    }

    // cacheRead() -> con il motore apcu una chiave assente dall'APCU si cerca su disco, e la scrittura nell'APCU toglie la copia su disco
    public function cacheReadApcuDisco(UnitTester $I)
    {
        $this->saltaSenzaApcu($I);
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheRead.03.php');
        $I->seeInSource("string(18) \"TEST CONTENT DISCO\"\nbool(true)\nbool(false)");
    }

    // cacheGetKeyAge() -> deve restituire il timestamp della scrittura
    public function cacheGetKeyAge(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheGetKeyAge.01.php');
        $I->see('bool(true)');
    }

    // cacheDelete() -> deve togliere la chiave
    public function cacheDelete(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheDelete.01.php');
        $I->seeInSource("bool(true)\nbool(true)\nbool(false)");
    }

    // cacheFlush() -> deve svuotare il sito corrente in tutti i motori, anche in quelli che la richiesta non usa
    public function cacheFlush(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheFlush.01.php');
        $I->seeInSource("bool(true)\nbool(false)\nbool(false)");
    }

    // cacheAdd() -> deve scrivere la chiave solo se non c'e'
    public function cacheAdd(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheAdd.01.php');
        $I->seeInSource("bool(true)\nbool(false)\nstring(5) \"PRIMO\"");
    }

    // cacheAdd() come lock -> mentre un'altra richiesta ricostruisce, chi trova la cache vecchia usa la copia e non ricostruisce
    public function cacheAddLockPagine(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_cache.utils/_cacheAdd.02.php');
        $I->seeInSource("bool(true)\nint(200)\nbool(true)");
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}
