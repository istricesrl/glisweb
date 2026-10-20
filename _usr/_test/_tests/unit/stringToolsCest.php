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
        $I->see('string(11) "20,00 Bytes"');
        $I->see('string(7) "1,95 Kb"');
        $I->see('string(7) "1,91 Mb"');
        $I->see('string(7) "1,86 Gb"');
        $I->see('string(7) "1,82 Tb"');
    }

    // riduciCaratteriDoppi() -> deve restituire una stringa con i caratteri doppi ridotti
    public function riduciCaratteriDoppi(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_riduciCaratteriDoppi.01.php');
        $I->see('string(19) "stringa di prova 01"');
        $I->see('string(20) "stringa +di prova 02"');
        $I->see('string(19) "stringa di prova 03"');
    }

    // empty2null() -> deve restituire null se la stringa è vuota
    public function empty2null(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_empty2null.01.php');
        $I->see('[0]=> string(3) "123"');
        $I->see('[1]=> string(3) "123"');
        $I->see('[2]=> NULL');
        $I->see('[3]=> string(1) "0"');
        $I->see('[4]=> NULL');
        $I->see('[5]=> NULL');
        $I->see('[6]=> string(3) "abc"');
        $I->see('[7]=> string(3) "abc"');
    }

    // string2boolean() -> deve restituire un booleano a partire da una stringa
    public function string2boolean(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_string2boolean.01.php');
        $I->see('bool(true)');
        $I->see('bool(true)');
        $I->see('bool(false)');
    }

    // boolean2string() -> deve restituire una stringa a partire da un booleano
    public function boolean2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_boolean2string.01.php');
        $I->see('string(4) "True"');
        $I->see('string(5) "False"');
    }

    // riduciStringa() -> deve restituire una stringa con la lunghezza ridotta
    public function riduciStringa(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_riduciStringa.01.php');
        $I->see('string(6) "str~01"');
        $I->see('string(7) "str~ 01"');
        $I->see('string(7) "str+ 01"');
    }

    // int2month() -> deve restituire il nome del mese a partire da un intero
    public function int2month(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_int2month.01.php');
        $I->see('[0]=> string(7) "Gennaio"');
        $I->see('[1]=> string(8) "Febbraio"');
        $I->see('[2]=> string(5) "Marzo"');
        $I->see('[3]=> string(6) "Aprile"');
        $I->see('[4]=> string(6) "Maggio"');
        $I->see('[5]=> string(6) "Giugno"');
        $I->see('[6]=> string(6) "Luglio"');
        $I->see('[7]=> string(6) "Agosto"');
        $I->see('[8]=> string(9) "Settembre"');
        $I->see('[9]=> string(7) "Ottobre"');
        $I->see('[10]=> string(8) "Novembre"');
        $I->see('[11]=> string(8) "Dicembre"');
        $I->see('[12]=> string(21) "mese sconosciuto (13)"');
    }

    // int2day() -> deve restituire il nome del giorno a partire da un intero
    public function int2day(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_int2day.01.php');
        $I->see('[0]=> string(7) "Lunedì"');
        $I->see('[1]=> string(8) "Martedì"');
        $I->see('[2]=> string(10) "Mercoledì"');
        $I->see('[3]=> string(8) "Giovedì"');
        $I->see('[4]=> string(8) "Venerdì"');
        $I->see('[5]=> string(6) "Sabato"');
        $I->see('[6]=> string(22) "giorno sconosciuto (7)"');
    }

    // logLvl2string() -> deve restituire il nome del livello di log a partire da un intero
    public function logLvl2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_logLvl2string.01.php');
        $I->see('[0]=> string(9) "LOG_EMERG"');
        $I->see('[1]=> string(9) "LOG_ALERT"');
        $I->see('[2]=> string(8) "LOG_CRIT"');
        $I->see('[3]=> string(7) "LOG_ERR"');
        $I->see('[4]=> string(11) "LOG_WARNING"');
        $I->see('[5]=> string(10) "LOG_NOTICE"');
        $I->see('[6]=> string(8) "LOG_INFO"');
        $I->see('[7]=> string(9) "LOG_DEBUG"');
        $I->see('[8]=> NULL');
    }

    // reportLvl2string() -> deve restituire il nome del livello di report a partire da un intero
    public function reportLvl2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_reportLvl2string.01.php');
        $I->see('[0]=> string(7) "E_ERROR"');
        $I->see('[1]=> string(9) "E_WARNING"');
        $I->see('[2]=> string(7) "E_PARSE"');
        $I->see('[3]=> string(8) "E_NOTICE"');
        $I->see('[4]=> string(12) "E_CORE_ERROR"');
        $I->see('[5]=> string(14) "E_CORE_WARNING"');
        $I->see('[6]=> string(15) "E_COMPILE_ERROR"');
        $I->see('[7]=> string(17) "E_COMPILE_WARNING"');
        $I->see('[8]=> string(12) "E_USER_ERROR"');
        $I->see('[9]=> string(14) "E_USER_WARNING"');
        $I->see('[10]=> string(13) "E_USER_NOTICE"');
        $I->see('[11]=> string(8) "E_STRICT"');
        $I->see('[12]=> string(19) "E_RECOVERABLE_ERROR"');
    }

    // ts2string() -> deve restituire una data leggibile a partire da un timestamp
    public function ts2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_ts2string.01.php');
        $I->see('string(14) "30 agosto 2024"');
    }

    // date2string() -> deve restituire una data leggibile a partire da una data
    public function date2string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_date2string.01.php');
        $I->see('string(14) "30 agosto 2024"');
    }

    // str_start_with() -> deve restituire true se la stringa inizia con il prefisso
    public function str_start_with(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_str_starts_with.01.php');
        $I->see('bool(true)');
        $I->see('bool(false)');
    }

    // str_starts_with_array() -> deve restituire true se la stringa inizia con uno dei prefissi
    public function str_starts_with_array(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_str_starts_with_array.01.php');
        $I->see('bool(true)');
        $I->see('bool(false)');
        $I->see('bool(true)');
    }

    // m2km() -> deve restituire una stringa con la distanza in km
    public function m2km(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_m2km.01.php');
        $I->see('int(1)');
    }

    // km2m() -> deve restituire una stringa con la distanza in metri
    public function km2m(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_km2m.01.php');
        $I->see('int(1000)');
    }

    // removeBom() -> deve restituire una stringa senza il BOM
    public function removeBom(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_removeBom.01.php');
        $I->see('string(13) "Hello, world!"');
    }

    // domainFromUrl() -> deve restituire il dominio a partire da un URL
    public function domainFromUrl(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_domainFromURL.01.php');
        $I->see('string(14) "www.google.com"');
    }

    // inRegexpArray() -> deve restituire true se la stringa corrisponde a una delle espressioni regolari
    public function inRegexpArray(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_inRegexpArray.01.php');
        $I->see('bool(true)');
        $I->see('bool(false)');
    }

    // clean_string() -> deve restituire una stringa pulita
    public function clean_string(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_clean_string.01.php');
        // il puntino U+2024 resta: dal 06/10/2026 clean_string() toglie solo i separatori invisibili
        $I->see('string(19) "Hello , world! ․ "');
    }

    // isBinaryString() -> deve restituire true se la stringa è binaria
    public function isBinaryString(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_isBinaryString.01.php');
        //$I->see('bool(false)');
        //$I->see('bool(true)');
    }

    // string2YmdHis() -> deve normalizzare i nomi storti e rifiutare quelli non validi
    public function string2YmdHis(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_string.tools/_string2YmdHis.01.php');
        $I->see("20261013150401");
        $I->see("20260604140101");
        $I->see("20231025123000");
        $I->see("false");
        $I->see("true");
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}