<?php

class mysqlToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // mysqlPatchCurrentDb() -> deve restituire il livello di _etc/_current.db, e zero dove il file non c'è
    public function mysqlPatchCurrentDb(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_mysql.tools/_mysqlPatchCurrentDb.01.php');
        $I->see('string(12) "' . trim( strtok( file_get_contents( DIR_BASE . '_etc/_current.db' ), "\n" ) ) . '"');
        $I->see('string(12) "000000000000"');
    }

    // mysqlPatchCheck() -> deve accettare il livello vero e rifiutare un database pieno a zero o sotto il canone
    public function mysqlPatchCheck(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_mysql.tools/_mysqlPatchCheck.01.php');
        $I->see('livello vero: bool(true)');
        $I->see('livello a zero: bool(false)');
        $I->see('nessuna patch registrata');
        $I->see('livello sotto il canone: bool(false)');
        $I->see('anteriore al canone');
    }

}
