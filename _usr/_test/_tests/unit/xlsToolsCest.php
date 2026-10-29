<?php

/**
 * test di _src/_lib/_xls.tools.php
 *
 * xlsLoad() deve leggere un foglio normale e resistere ai file costruiti apposta delle CVE-2026-108358, 108359 e
 * 108360 di PhpSpreadsheet: l'esempio punta gli indirizzi esterni al finto REST dei test, e qui si controlla che non
 * gli sia arrivato niente
 *
 */

class xlsToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        $I->assertTrue( \Helper\RestMock::attivo(), 'il finto REST lo avvia _src/_sh/_codeception.run.sh' );
        \Helper\RestMock::pulisci();
    }

    // xlsLoad() -> legge i valori di un xlsx normale, non apre l'ODS, e non chiama gli indirizzi esterni di immagini e DTD
    public function xlsLoad(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_xls.tools/_xlsLoad.01.php');
        $I->see('normale: [["nome","codice"],["Mario","001"],["Anna","002"]]');
        $I->see('ods: false');
        $I->dontSee('ODS letto');
        $I->see('immagine: [["nome","codice"],["Mario","001"],["Anna","002"]]');
        $I->see('dtd: ');
        $I->assertCount( 0, \Helper\RestMock::richieste(), 'richieste partite verso indirizzi esterni' );
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
        \Helper\RestMock::pulisci();
    }

}
