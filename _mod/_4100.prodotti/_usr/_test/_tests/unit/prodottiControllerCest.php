<?php

/**
 * test dei controller finally del modulo _4100.prodotti
 *
 * le scritture su articoli, prodotti, prodotti_categorie e articoli_caratteristiche devono tenere allineata
 * articoli_view_static; fino al 2026-11-04 i controller degli articoli stavano in _src/_api/_inc/_controllers/,
 * dove controller() non guarda, e la statica dal back-end non si aggiornava mai ( LUGHESE )
 *
 */

class prodottiControllerCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        global $cf;
        // senza la chiave gli esempi non possono firmare le righe, e si fermano prima di scrivere
        if( empty( $cf['auth']['import']['secret'] ) ) {
            $I->markTestSkipped( 'il deploy non ha auth.import.secret' );
        }
    }

    // controller() -> ogni scrittura su un articolo o su una tabella che alimenta articoli_view la riallinea nella statica
    public function staticaArticoli(UnitTester $I)
    {
        $I->amOnPage('/_mod/_4100.prodotti/_usr/_examples/_lib/_controller.tools/_controller.01.php');
        $I->dontSee('segreto di importazione assente');
        $I->dontSee('vista statica degli articoli assente');
        $I->see('articolo nella statica: si');
        $I->see('categorie nella statica come nella vista: si');
        $I->see('prodotto nella statica come nella vista: si');
        $I->see('statica rigenerata dalla caratteristica: si');
        $I->see('nome nella statica come nella vista: si');
        $I->see('articolo tolto dalla statica: si');
        $I->dontSee(': no');
    }

}
