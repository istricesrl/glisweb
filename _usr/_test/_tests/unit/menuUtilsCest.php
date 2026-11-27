<?php

/**
 * test di _src/_lib/_menu.utils.php
 *
 * pagesCheck() deve trovare i genitori e le linguette che non esistono e i percorsi duplicati, che la costruzione
 * dell'albero in _src/_config/_320.pages.php aggiusta in silenzio, e non deve segnalare le pagine che in una lingua un
 * percorso non ce l'hanno
 *
 */

class menuUtilsCest
{

    // pagesCheck() -> un messaggio per ogni problema, niente per una struttura sana
    public function pagesCheck(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_menu.utils/_pagesCheck.01.php');
        $I->see('la pagina esempio.view ha la linguetta esempio.tools, che non esiste');
        $I->see('la pagina esempio.form.doppia ha lo stesso percorso di esempio.form.testo in it-IT ( testo )');
        $I->see('la pagina esempio.form.orfana è figlia di esempio.inesistente, che non esiste');
        $I->dontSee('esempio.senza.titolo');
        $I->dontSee('esempio.esterna');
        $I->see('sana: 0');
    }

    // pagesIndexAdd() -> a parità di percorso l'ultima candidata è la pagina al suo posto, l'orfana sola resta
    public function pagesIndexAdd(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_menu.utils/_pagesIndexAdd.01.php');
        $I->see('prima la dashboard: contenuti');
        $I->dontSee('prima la dashboard: contenuti.form');
        $I->see('prima l\'orfana: contenuti');
        $I->dontSee('prima l\'orfana: contenuti.form');
        $I->see('orfana sola: catalogo.marchi.form');
    }

}
