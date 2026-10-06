<?php

class filesystemToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // fullPath() -> deve restituire il percorso assoluto partendo da quello relativo
    public function fullPath(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_fullPath.01.php');
        $I->see("'/var/www/glisdev.istricesrl.com/dev/src/config.json'");
        $I->dontSee('boolean false');
    }

    // getFullPath() -> deve restituire il percorso assoluto partendo da quello relativo
    public function getFullPath(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFullPath.01.php');
        $I->see("'/var/www/glisdev.istricesrl.com/dev/src/config.json'");
        $I->dontSee('boolean false');
    }

    // shortPath() -> deve restituire il percorso relativo partendo da quello assoluto
    public function shortPath01(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_shortPath.01.php');
        $I->see("'src/config.json'");
        $I->dontSee('boolean false');
    }

    // shortPath() -> deve restituire il percorso relativo partendo da quello assoluto
    public function shortPath02(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_shortPath.02.php');
        $I->see("'src/config.json'");
        $I->dontSee('boolean false');
    }

    // getShortPath() -> deve restituire il percorso relativo partendo da quello assoluto
    public function getShortPath(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getShortPath.01.php');
        $I->see("'src/config.json'");
        $I->dontSee('boolean false');
    }

    // absoultePath() -> deve restituire il percorso pulito da punti e barre
    public function absoultePath(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_absolutePath.01.php');
        $I->see("'/_etc/_common/_lorem.conf'");
        $I->see("'/_common/_lorem.conf'");
        $I->dontSee('boolean false');
    }

    // openFile() -> deve restituire una risorsa puntatore a file
    public function openFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_openFile.01.php');
        $I->see(':resource');
        $I->dontSee('boolean false');
    }

    // closeFile() -> deve restituire true in caso di chiusura effettuata con successo del file
    public function closeFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_closeFile.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // writeToFile() -> deve restituire true in caso di scrittura effettuata con successo
    public function writeToFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_writeToFile.01.php');
        $I->see('boolean true');
        $I->see('prova writeToFile');
        $I->dontSee('boolean false');
    }

    // overwriteFile() -> deve restituire true in caso di sovrascrittura effettuata con successo
    public function overwriteToFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_overwriteToFile.01.php');
        $I->see('boolean true');
        $I->see('prova overwriteToFile');
        $I->dontSee('boolean false');
    }

    // appendToFile() -> deve restituire true in caso di aggiunta effettuata con successo
    public function appendToFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_appendToFile.01.php');
        $I->see('boolean true');
        $I->see('prova appendToFile');
        $I->dontSee('boolean false');
    }

    // readFromFile() -> deve restituire il contenuto del file in forma di array
    public function readFromFileAsArray(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_readFromFile.01.php');
        $I->see('boolean true');
        $I->see('array (size=1)');
        $I->see('prova readFromFile');
        $I->dontSee('boolean false');
    }

    // readFromFile() -> deve restituire il contenuto del file in forma di stringa
    public function readFromFileAsString(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_readFromFile.02.php');
        $I->see('boolean true');
        $I->see('prova readFromFile');
        $I->dontSee('boolean false');
    }

    // readStringFromFile() -> deve restituire il contenuto del file in forma di stringa
    public function readStringFromFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_readStringFromFile.01.php');
        $I->see('boolean true');
        $I->see('prova readStringFromFile');
        $I->dontSee('boolean false');
    }

    // readArrayFromFile() -> deve restituire il contenuto del file in forma di array
    public function readArrayFromFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_readArrayFromFile.01.php');
        $I->see('boolean true');
        $I->see('array (size=1)');
        $I->see('prova readArrayFromFile');
        $I->dontSee('boolean false');
    }

    // writeArrayToFile() -> deve restituire true in caso di scrittura effettuata con successo
    public function writeArrayToFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_writeArrayToFile.01.php');
        $I->see('boolean true');
        $I->see('array (size=2)');
        $I->see('prova writeArrayToFile riga 1');
        $I->see('prova writeArrayToFile riga 2');
        $I->dontSee('boolean false');
    }

    // readKeyValueArrayFromFile() -> deve restituire il contenuto del file in forma di array
    public function readKeyValueArrayFromFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_readKeyValueArrayFromFile.01.php');
        $I->see('boolean true');
        $I->see('array (size=2)');
        $I->see("'key 1' => string 'prova readKeyValueArrayFromFile riga 1'");
        $I->see("'key 2' => string 'prova readKeyValueArrayFromFile riga 2'");
        $I->dontSee('boolean false');
    }

    // writeKeyValueArrayToFile() -> deve restituire true in caso di scrittura effettuata con successo
    public function writeKeyValueArrayToFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_writeKeyValueArrayToFile.01.php');
        $I->see('boolean true');
        $I->see('array (size=2)');
        $I->see('prova writeKeyValueArrayToFile riga 1');
        $I->see('prova writeKeyValueArrayToFile riga 2');
        $I->dontSee('boolean false');
    }

    // fileTrimLines() -> deve restituire un file senza le righe tagliate
    public function fileTrimLines(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_fileTrimLines.01.php');
        $I->see('boolean true');
        $I->dontSee('prova fileTrimLines riga 1');
        $I->see('prova fileTrimLines riga 2');
        $I->see('prova fileTrimLines riga 3');
        $I->dontSee('boolean false');
    }

    // getFolderIterator() -> deve restituire un iteratore di directory
    public function getFolderIterator(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFolderIterator.01.php');
        $I->see('object(RecursiveIteratorIterator)');
        $I->dontSee('boolean false');
    }

    // checkFolder() -> deve creare una cartella se non esiste
    public function checkFolder(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_checkFolder.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // checkFile() -> deve creare un file se non esiste
    public function checkFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_checkFile.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // deleteFolder() -> deve eliminare una cartella
    public function deleteFolder(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_deleteFolder.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // deleteFile() -> deve eliminare un file
    public function deleteFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_deleteFile.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // recursiveDelete() -> deve eliminare una cartella e tutto il suo contenuto
    public function recursiveDelete(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_recursiveDelete.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // emptyFolder() -> deve svuotare una cartella
    public function emptyFolder(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_emptyFolder.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // moveFile() -> deve spostare un file in una cartella data
    public function moveFileToFolder(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_moveFile.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // moveFile() -> deve spostare un file in un percorso dato
    public function moveFileToFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_moveFile.02.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // copyFile() -> deve copiare un file in una cartella data
    public function copyFileToFolder(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_copyFile.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // copyFile() -> deve copiare un file in un percorso dato
    public function copyFileToFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_copyFile.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // copyFile() -> deve copiare un file remoto in una cartella data
    public function copyFileFromRemoteToFolder(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_copyFile.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // copyFile() -> deve copiare un file remoto in un percorso dato
    public function copyFileFromRemoteToFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_copyFile.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // dirTree2Array() -> deve restituire un array con la struttura delle cartelle
    public function dirTreeToArray(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_dirTreeToArray.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
        $I->see('/sub1');
        $I->see('/sub2');
    }

    // getFileSize() -> deve restituire la dimensione di un file
    public function getFileSize(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFileSize.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // getFolderSize() -> deve restituire la dimensione di una cartella
    public function getFolderSize(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFolderSize.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // getSize() -> deve restituire la dimensione di un file o di una cartella
    public function getSize(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getSize.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
    }

    // getRecursiveFileList() -> deve restituire un array con la lista dei file
    public function getRecursiveFileList(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getRecursiveFileList.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
        $I->see('f1.txt');
        $I->see('f2.txt');
        $I->see('f3.txt');
    }

    // getFilteredFileList() -> deve restituire un array con la lista dei file filtrata
    public function getFilteredFileList(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFilteredFileList.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
        $I->see('/f3.log');
    }

    // getFileList() -> deve restituire un array con la lista dei file
    public function getFileList(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFileList.01.php');
        $I->see('boolean true');
        $I->dontSee('boolean false');
        $I->see('f1.txt');
        $I->see('f2.txt');
        $I->see('f3.txt');
    }

    // getRecursiveFolderList() -> deve restituire un array con la lista delle cartelle
    // TODO test non ancora implementato
    public function getRecursiveFolderList(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getRecursiveFolderList.01.php');
    }

    // getFilteredFolderList() -> deve restituire un array con la lista delle cartelle filtrata
    // TODO test non ancora implementato
    public function getFilteredFolderList(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFilteredFolderList.01.php');
    }

    // getFolderList() -> deve restituire un array con la lista delle cartelle
    // TODO test non ancora implementato
    public function getFolderList(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFolderList.01.php');
    }

    // getRecursiveFullList() -> deve restituire un array con la lista di file e cartelle
    // TODO test non ancora implementato
    public function getRecursiveFullList(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getRecursiveFullList.01.php');
    }

    // getFullList() -> deve restituire un array con la lista di file e cartelle
    // TODO test non ancora implementato
    public function getFullList(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFullList.01.php');
    }

    // getFolderName() -> deve restituire il nome della cartella
    // TODO test non ancora implementato
    public function getFolderName(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFolderName.01.php');
    }

    // getFileExtension() -> deve restituire l'estensione del file
    // TODO test non ancora implementato
    public function getFileExtension(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFileExtension.01.php');
    }

    // getFileNameWithoutExtension() -> deve restituire il nome del file senza estensione
    // TODO test non ancora implementato
    public function getFileNameWithoutExtension(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFileNameWithoutExtension.01.php');
    }

    // globRecursive() -> deve restituire un array con la lista di file e cartelle
    // TODO test non ancora implementato
    public function globRecursive(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_globRecursive.01.php');
    }

    // findFileType() -> deve restituire il mime type di un file
    // TODO test non ancora implementato
    public function findFileType(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_findFileType.01.php');
    }

    // isBinaryFile() -> deve restituire true se il file è binario
    // TODO test non ancora implementato
    public function isBinaryFile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_isBinaryFile.01.php');
    }

    // fileExists() -> deve restituire true se il file esiste
    // TODO test non ancora implementato
    public function fileExists(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_fileExists.01.php');
    }

    // getFileModifiedTime() -> deve restituire il timestamp dell'ultima modifica del file
    // TODO test non ancora implementato
    public function getFileModifiedTime(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_getFileModifiedTime.01.php');
    }

    // checkFileConsistency() -> deve restituire true se il file è stato modificato entrò un certo intervallo di tempo
    // TODO test non ancora implementato
    public function checkFileConsistency(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_filesystem.tools/_checkFileConsistency.01.php');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}
