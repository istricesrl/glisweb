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

    // getTable() -> il nome solo per una tabella esistente con un nome valido, false per vuota, inesistente o maligna
    public function getTable(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_mysql.tools/_getTable.01.php');
        $I->see("esistente: 'anagrafica'");
        $I->see('vuota: false');
        $I->see('assente: false');
        $I->see('inesistente: false');
        $I->see('maligna: false');
        $I->see('array: false');
    }

    // getStaticViewExtension() -> '_view' senza statica e con una statica vuota accanto a una tabella piena, '_view_static' altrimenti
    public function getStaticViewExtension(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_mysql.tools/_getStaticViewExtension.01.php');
        $I->see('senza statica: [_view]');
        $I->see('tutte e due vuote: [_view_static]');
        $I->see('statica non popolata: [_view]');
        $I->see('statica popolata: [_view_static]');
    }

    // fillStaticViews() -> popola a lotti la statica vuota accanto a una tabella con righe, salta quella senza tabella base
    public function fillStaticViews(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_mysql.tools/_fillStaticViews.01.php');
        $I->see('popolata: test_e2e_statica_view_static 5 righe');
        $I->see('saltata: test_e2e_orfana_view_static nessuna tabella test_e2e_orfana: si popola col suo task');
        $I->see('errori: 0');
        $I->see('secondo giro popolate: 0');
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
