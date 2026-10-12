<?php

class rewriteToolsCest 
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // string2rewrite() -> deve restituire uno slug che la RewriteRule del .htaccess accetta
    // NOTA si controlla l'output di var_dump() senza xdebug, che non e' installato ovunque
    public function string2rewrite(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_rewrite.tools/_string2rewrite.01.php');
        $I->see('string(24) "caffe-te-10-percento-piu"');
        $I->see('string(37) "usa1941-motore-fanuc-a06b0313b0067000"');
        $I->see('string(37) "web1583832616-fresa-coromant-d400-z26"');
    }

}
