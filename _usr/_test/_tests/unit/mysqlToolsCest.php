<?php

class mysqlToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // mysqlPatchCurrentSchema() -> deve restituire il livello di _etc/_current.schema, e zero dove il file non c'è
    public function mysqlPatchCurrentSchema(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_mysql.tools/_mysqlPatchCurrentSchema.01.php');
        $I->see('string(12) "' . trim( strtok( file_get_contents( DIR_BASE . '_etc/_current.schema' ), "\n" ) ) . '"');
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

    // mysqlPatchTranslateAlter() -> MODIFY / CHANGE COLUMN IF EXISTS: senza IF se la colonna c'è, clausola tolta se non c'è
    public function mysqlPatchTranslateAlter(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_mysql.tools/_mysqlPatchTranslateAlter.01.php');
        $I->see('ALTER TABLE `account` MODIFY COLUMN `username` char(255) DEFAULT NULL');
        $I->see('ALTER TABLE `account` CHANGE COLUMN `username` `username` char(255) DEFAULT NULL');
        $I->see('account.colonna_inesistente non c\'è');
        $I->dontSee('clausola non tradotta');
    }

}
