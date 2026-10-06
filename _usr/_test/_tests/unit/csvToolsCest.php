<?php

class csvToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // csvFile2array() -> deve restituire il contenuto del CSV di test
    public function csvFile2array(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_csvFile2array.01.php');
        $I->see("'col1' => string 'val1' (length=4)");
        $I->see("'col2' => string 'val2' (length=4)");
        $I->see("'col3' => string 'val3' (length=4)");
    }

    // csvString2array() -> deve restituire il contenuto del CSV di test
    public function csvString2array(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_csvString2array.01.php');
        $I->see("'col1' => string 'val1' (length=4)");
        $I->see("'col2' => string 'val2' (length=4)");
        $I->see("'col3' => string 'val3' (length=4)");
    }

    // csvString2array() -> deve restituire il contenuto del CSV di test
    public function csvArray2array(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_csvArray2array.01.php');
        $I->see("'col1' => string 'val1' (length=4)");
        $I->see("'col2' => string 'val2' (length=4)");
        $I->see("'col3' => string 'val3' (length=4)");
    }

    // csvFile2matrix() -> deve restituire il contenuto del CSV di test
    public function csvFile2matrix(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_csvFile2matrix.01.php');
        $I->see("0 => string 'val1' (length=4)");
        $I->see("1 => string 'val2' (length=4)");
        $I->see("2 => string 'val3' (length=4)");
    }

    // csvString2matrix() -> deve restituire il contenuto del CSV di test
    public function csvString2matrix(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_csvString2matrix.01.php');
        $I->see("0 => string 'val1' (length=4)");
        $I->see("1 => string 'val2' (length=4)");
        $I->see("2 => string 'val3' (length=4)");
    }

    // csvArray2matrix() -> deve restituire il contenuto del CSV di test
    public function csvArray2matrix(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_csvArray2matrix.01.php');
        $I->see("0 => string 'val1' (length=4)");
        $I->see("1 => string 'val2' (length=4)");
        $I->see("2 => string 'val3' (length=4)");
    }

    // array2csvFile() -> deve restituire il contenuto del CSV di test
    public function array2csvFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_array2csvFile.01.php');
        $I->see("col1,col2,col3");
        $I->see("val1,val2,val3");
    }

    // array2csvString() -> deve restituire il contenuto del CSV di test
    public function array2csvString(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_array2csvString.01.php');
        $I->see("col1,col2,col3");
        $I->see("val1,val2,val3");
    }

    // array2csvArray() -> deve restituire il contenuto del CSV di test
    public function array2csvArray(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_array2csvArray.01.php');
        $I->see("0 => string 'col1,col2,col3'");
        $I->see("1 => string 'val1,val2,val3'");
    }

    // matrix2csvFile() -> deve restituire il contenuto del CSV di test
    public function matrix2csvFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_matrix2csvFile.01.php');
        $I->see("col1,col2,col3");
        $I->see("val1,val2,val3");
    }

    // matrix2csvString() -> deve restituire il contenuto del CSV di test
    public function matrix2csvString(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_matrix2csvString.01.php');
        $I->see("col1,col2,col3");
        $I->see("val1,val2,val3");
    }

    // matrix2csvArray() -> deve restituire il contenuto del CSV di test
    public function matrix2csvArray(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_matrix2csvArray.01.php');
        $I->see("0 => string 'col1,col2,col3'");
        $I->see("1 => string 'val1,val2,val3'");
    }

    // guessCsvSeparator() -> deve restituire il separatore del CSV di test
    public function guessCsvSeparator(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_guessCsvSeparator.01.php');
        $I->see("string ';' (length=1)");
    }

    // csvRow2array() -> deve restituire il contenuto del CSV di test
    public function csvRow2array(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_csvRow2array.01.php');
        $I->see("'col1' => string 'val1' (length=4)");
        $I->see("'col2' => string 'val2' (length=4)");
        $I->see("'col3' => string 'val3' (length=4)");
    }

    // csvRow2vector() -> deve restituire il contenuto del CSV di test
    public function csvRow2vector(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_csv.tools/_csvRow2vector.01.php');
        $I->see("0 => string 'val1' (length=4)");
        $I->see("1 => string 'val2' (length=4)");
        $I->see("2 => string 'val3' (length=4)");
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}
