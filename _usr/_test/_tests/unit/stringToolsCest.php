<?php

class stringToolsCest 
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // writeByte() -> deve restituire una stringa con la dimensione e relativa unità di misura
    public function writeByte(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_writeBytes.01.php');
        $I->see("string '20,00 Bytes' (length=11)");
        $I->see("string '1,95 Kb' (length=7)");
        $I->see("string '1,91 Mb' (length=7)");
        $I->see("string '1,86 Gb' (length=7)");
        $I->see("string '1,82 Tb' (length=7)");
    }

    // riduciCaratteriDoppi() -> deve restituire una stringa con i caratteri doppi ridotti
    public function riduciCaratteriDoppi(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_riduciCaratteriDoppi.01.php');
        $I->see("string 'stringa di prova 01' (length=19)");
        $I->see("string 'stringa +di prova 02' (length=20)");
        $I->see("string 'stringa di prova 03' (length=19)");
    }

    // empty2null() -> deve restituire null se la stringa è vuota
    public function empty2null(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_empty2null.01.php');
        $I->see("0 => string '123' (length=3)");
        $I->see("1 => string '123' (length=3)");
        $I->see("2 => null");
        $I->see("3 => string '0' (length=1)");
        $I->see("4 => null");
        $I->see("5 => null");
        $I->see("6 => string 'abc' (length=3)");
        $I->see("7 => string 'abc' (length=3)");
    }

    // string2boolean() -> deve restituire un booleano a partire da una stringa
    public function string2boolean(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_string2boolean.01.php');
        $I->see("boolean true");
        $I->see("boolean true");
        $I->see("boolean false");
    }

    // boolean2string() -> deve restituire una stringa a partire da un booleano
    public function boolean2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_boolean2string.01.php');
        $I->see("string 'True' (length=4)");
        $I->see("string 'False' (length=5)");
    }

    // riduciStringa() -> deve restituire una stringa con la lunghezza ridotta
    public function riduciStringa(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_riduciStringa.01.php');
        $I->see("string 'str~01' (length=6)");
        $I->see("string 'str~ 01' (length=7)");
        $I->see("string 'str+ 01' (length=7)");
    }

    // int2month() -> deve restituire il nome del mese a partire da un intero
    public function int2month(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_int2month.01.php');
        $I->see("0 => string 'Gennaio' (length=7)");
        $I->see("1 => string 'Febbraio' (length=8)");
        $I->see("2 => string 'Marzo' (length=5)");
        $I->see("3 => string 'Aprile' (length=6)");
        $I->see("4 => string 'Maggio' (length=6)");
        $I->see("5 => string 'Giugno' (length=6)");
        $I->see("6 => string 'Luglio' (length=6)");
        $I->see("7 => string 'Agosto' (length=6)");
        $I->see("8 => string 'Settembre' (length=9)");
        $I->see("9 => string 'Ottobre' (length=7)");
        $I->see("10 => string 'Novembre' (length=8)");
        $I->see("11 => string 'Dicembre' (length=8)");
        $I->see("12 => string 'mese sconosciuto (13)' (length=21)");
    }

    // int2day() -> deve restituire il nome del giorno a partire da un intero
    public function int2day(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_int2day.01.php');
        $I->see("0 => string 'Lunedì' (length=7)");
        $I->see("1 => string 'Martedì' (length=8)");
        $I->see("2 => string 'Mercoledì' (length=10)");
        $I->see("3 => string 'Giovedì' (length=8)");
        $I->see("4 => string 'Venerdì' (length=8)");
        $I->see("5 => string 'Sabato' (length=6)");
        $I->see("6 => string 'giorno sconosciuto (7)' (length=22)");
    }

    // logLvl2string() -> deve restituire il nome del livello di log a partire da un intero
    public function logLvl2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_logLvl2string.01.php');
        $I->see("0 => string 'LOG_EMERG' (length=9)");
        $I->see("1 => string 'LOG_ALERT' (length=9)");
        $I->see("2 => string 'LOG_CRIT' (length=8)");
        $I->see("3 => string 'LOG_ERR' (length=7)");
        $I->see("4 => string 'LOG_WARNING' (length=11)");
        $I->see("5 => string 'LOG_NOTICE' (length=10)");
        $I->see("6 => string 'LOG_INFO' (length=8)");
        $I->see("7 => string 'LOG_DEBUG' (length=9)");
        $I->see("8 => null");
    }

    // reportLvl2string() -> deve restituire il nome del livello di report a partire da un intero
    public function reportLvl2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_reportLvl2string.01.php');
        $I->see("0 => string 'E_ERROR' (length=7)");
        $I->see("1 => string 'E_WARNING' (length=9)");
        $I->see("2 => string 'E_PARSE' (length=7)");
        $I->see("3 => string 'E_NOTICE' (length=8)");
        $I->see("4 => string 'E_CORE_ERROR' (length=12)");
        $I->see("5 => string 'E_CORE_WARNING' (length=14)");
        $I->see("6 => string 'E_COMPILE_ERROR' (length=15)");
        $I->see("7 => string 'E_COMPILE_WARNING' (length=17)");
        $I->see("8 => string 'E_USER_ERROR' (length=12)");
        $I->see("9 => string 'E_USER_WARNING' (length=14)");
        $I->see("10 => string 'E_USER_NOTICE' (length=13)");
        $I->see("11 => string 'E_STRICT' (length=8)");
        $I->see("12 => string 'E_RECOVERABLE_ERROR' (length=19)");
    }

    // ts2string() -> deve restituire una data leggibile a partire da un timestamp
    public function ts2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_ts2string.01.php');
        $I->see("string '30 agosto 2024' (length=14)");
    }

    // date2string() -> deve restituire una data leggibile a partire da una data
    public function date2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_date2string.01.php');
        $I->see("string '30 agosto 2024' (length=14)");
    }

    // str_start_with() -> deve restituire true se la stringa inizia con il prefisso
    public function str_start_with(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_str_starts_with.01.php');
        $I->see("boolean true");
        $I->see("boolean false");
    }

    // str_starts_with_array() -> deve restituire true se la stringa inizia con uno dei prefissi
    public function str_starts_with_array(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_str_starts_with_array.01.php');
        $I->see("boolean true");
        $I->see("boolean false");
        $I->see("boolean true");
    }

    // m2km() -> deve restituire una stringa con la distanza in km
    public function m2km(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_m2km.01.php');
        $I->see("int 1");
    }

    // km2m() -> deve restituire una stringa con la distanza in metri
    public function km2m(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_km2m.01.php');
        $I->see("int 1000");
    }

    // removeBom() -> deve restituire una stringa senza il BOM
    public function removeBom(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_removeBom.01.php');
        $I->see("string 'Hello, world!' (length=13)");
    }

    // domainFromUrl() -> deve restituire il dominio a partire da un URL
    public function domainFromUrl(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_domainFromURL.01.php');
        $I->see("string 'www.google.com' (length=14)");
    }

    // inRegexpArray() -> deve restituire true se la stringa corrisponde a una delle espressioni regolari
    public function inRegexpArray(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_inRegexpArray.01.php');
        $I->see("boolean true");
        $I->see("boolean false");
    }

    // clean_string() -> deve restituire una stringa pulita
    public function clean_string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_clean_string.01.php');
        $I->see("string 'Hello , world! ' (length=15)");
    }

    // isBinaryString() -> deve restituire true se la stringa è binaria
    public function isBinaryString(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_isBinaryString.01.php');
        //$I->see("boolean false");
        //$I->see("boolean true");
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}