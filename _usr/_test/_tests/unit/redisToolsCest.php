<?php

class redisToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // redisUniqueKey() -> deve restituire un valore con il suffisso univoco del sito
    public function redisUniqueKey(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_redis.tools/_redisUniqueKey.01.php');
        $I->see( REDIS_UNIQUE_SEED . 'TEST' );
    }

    // redisAddKeyAgeSuffix() -> deve restituire un valore con il suffisso '_AGE'
    public function redisAddKeyAgeSuffix(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_redis.tools/_redisAddKeyAgeSuffix.01.php');
        $I->see('TEST_AGE');
    }

    // redis.servers.<n>.db -> la connessione deve lavorare sul database configurato ( db0 se manca )
    public function redisDatabase(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_config/_framework/_redis.database.01.php');
        $I->see('database OK');
    }

    // redisWrite() -> deve restituire OK
    public function redisWrite(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_redis.tools/_redisWrite.01.php');
        $I->see('"OK');
    }

    // redisRead() -> deve restituire il valore scritto con apcuWrite()
    public function redisRead(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_redis.tools/_redisRead.01.php');
        $I->see('"OK');
        $I->see('TEST CONTENT');
    }

    // redisGetKeyAge() -> deve restituire un int
    public function redisGetKeyAge(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_redis.tools/_redisGetKeyAge.01.php');
        $I->see('"OK');
        $I->see('string(10)');
    }

    // redisDelete() -> deve restituire true
    public function redisDelete(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_redis.tools/_redisDelete.01.php');
        $I->see('"OK');
        $I->see('int(1)');
    }

    // redisFlush() -> deve restituire true
    public function redisFlush(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_redis.tools/_redisFlush.01.php');
        $I->see('bool(true)');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}
