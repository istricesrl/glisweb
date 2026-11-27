<?php

class modulaUtilsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // modulaQta2Testo() -> deve restituire il testo con la virgola e tre decimali
    public function modulaQta2Testo(UnitTester $I)
    {
        $I->amOnPage('/_mod/_I0200.modula/_usr/_examples/_lib/_modula.utils/_modulaQta2Testo.01.php');
        $I->see('"1,000"');
        $I->see('"12,500"');
        $I->see('"1500,000"');
    }

    // modulaTesto2Qta() -> deve restituire il numero corrispondente al testo
    public function modulaTesto2Qta(UnitTester $I)
    {
        $I->amOnPage('/_mod/_I0200.modula/_usr/_examples/_lib/_modula.utils/_modulaTesto2Qta.01.php');
        $I->see('1,000 ok');
        $I->see('12,500 ok');
        $I->see('0,000 ok');
        $I->dontSee(' ko');
    }

    // modulaToken() -> deve restituire il token con le credenziali giuste e NULL con quelle sbagliate
    public function modulaToken(UnitTester $I)
    {
        $I->amOnPage('/_mod/_I0200.modula/_usr/_examples/_lib/_modula.utils/_modulaToken.01.php');
        $I->see('token ok');
        $I->see('NULL');
    }

    // modulaImport() -> deve accettare l'import valido e restituire l'errore del WMS sugli altri
    public function modulaImport(UnitTester $I)
    {
        $I->amOnPage('/_mod/_I0200.modula/_usr/_examples/_lib/_modula.utils/_modulaImport.01.php');
        $I->see('400 IMP_ORDINI_RIGHE[0]: RIG_QTAR non valida');
        $I->see('0 Failed to connect');
    }

    // modulaExport() -> deve restituire i pacchetti in ordine, ripeterli fino all'ack e finire con 204
    public function modulaExport(UnitTester $I)
    {
        $I->amOnPage('/_mod/_I0200.modula/_usr/_examples/_lib/_modula.utils/_modulaExport.01.php');
        $I->see('primo CHUNK ordini 2');
        $I->see('ripetuto si');
        $I->see('A1 evasa 2');
        $I->see('MANCA evasa 0');
        $I->see('secondo END ordini 1');
        $I->see('status 204');
    }

    // modulaArticoli() -> l'anagrafica passa, un ordine su un articolo ignoto fa rifiutare l'intero pacchetto
    public function modulaArticoli(UnitTester $I)
    {
        $I->amOnPage('/_mod/_I0200.modula/_usr/_examples/_lib/_modula.utils/_modulaArticoli.01.php');
        $I->see('anagrafica accettata');
        $I->see('ordine noto accettato');
        $I->see('ordine ignoto rifiutato');
        $I->see('Violata integrita');
        $I->see('ordini nel WMS 1');
    }

    // modulaGiacenze() -> deve restituire le giacenze per codice, confermare il pacchetto e reggere il 204
    public function modulaGiacenze(UnitTester $I)
    {
        $I->amOnPage('/_mod/_I0200.modula/_usr/_examples/_lib/_modula.utils/_modulaGiacenze.01.php');
        $I->see('A1 giacenza 60');
        $I->see('articoli 2');
        $I->see('nuovo pacchetto si');
        $I->see('vuote []');
    }

    // modulaAck() -> deve rifiutare un GUID che il WMS non ha emesso
    public function modulaAck(UnitTester $I)
    {
        $I->amOnPage('/_mod/_I0200.modula/_usr/_examples/_lib/_modula.utils/_modulaAck.01.php');
        $I->see('ack rifiutato');
    }

}
