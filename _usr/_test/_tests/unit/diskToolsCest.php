<?php

class diskToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // diskUniqueKey() -> deve aggiungere il seme del sito una volta sola
    public function diskUniqueKey(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskUniqueKey.01.php');
        $I->see( '"' . DISK_UNIQUE_SEED . 'TEST"' );
    }

    // diskAddKeyAgeSuffix() -> deve restituire un valore con il suffisso '_AGE'
    public function diskAddKeyAgeSuffix(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskAddKeyAgeSuffix.01.php');
        $I->see('TEST_AGE');
    }

    // diskKeyPath() -> una chiave con barre resta un file solo dentro la cartella della cache
    public function diskKeyPath(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskKeyPath.01.php');
        $I->see('bool(true)');
        $I->see('..%2FTEST%2F..%2FCHIAVE');
    }

    // diskWrite() -> deve restituire true, creare il file e non lasciare temporanei
    public function diskWrite(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskWrite.01.php');
        $I->see('bool(true)');
        $I->dontSee('bool(false)');
        $I->see('int(0)');
    }

    // diskRead() -> deve restituire il valore scritto con diskWrite(), anche un array
    public function diskRead(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskRead.01.php');
        $I->dontSee('bool(false)');
        $I->see('TEST CONTENT');
    }

    // diskRead() -> una chiave scaduta deve restituire false e il suo file deve sparire
    public function diskReadScaduta(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskRead.02.php');
        $I->seeInSource("bool(true)\nbool(false)\nbool(false)");
    }

    // diskRead() -> una chiave che non esiste deve restituire false
    public function diskReadInesistente(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskRead.03.php');
        $I->see('bool(false)');
    }

    // diskGetKeyAge() -> deve restituire il timestamp della scrittura
    public function diskGetKeyAge(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskGetKeyAge.01.php');
        $I->see('int(');
        $I->dontSee('bool(false)');
    }

    // diskDelete() -> deve restituire true e togliere la chiave e la sua eta'
    public function diskDelete(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskDelete.01.php');
        $I->seeInSource("bool(true)\nbool(true)\nbool(false)\nbool(false)");
    }

    // diskDelete() -> una chiave che non esiste deve restituire false
    public function diskDeleteInesistente(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskDelete.02.php');
        $I->see('bool(false)');
    }

    // diskFlush() -> deve togliere le chiavi del sito corrente e lasciare quelle degli altri siti
    public function diskFlush(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_disk.tools/_diskFlush.01.php');
        $I->seeInSource("bool(true)\nbool(true)\nbool(true)\nbool(false)\nstring(12) \"TEST CONTENT\"");
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}
