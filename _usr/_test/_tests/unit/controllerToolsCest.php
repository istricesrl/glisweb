<?php

/**
 * test di _src/_lib/_controller.tools.php
 *
 * controller() non deve scrivere le sottoform quando la scrittura del padre è fallita: senza l'id del padre
 * resterebbero con la chiave esterna NULL ( account_gruppi orfane su polmasi, 29/10/2026 )
 *
 */

class controllerToolsCest
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

    // controller() -> un account con username già usato dà 409 e la sua sottoform account_gruppi non viene scritta
    public function sottoformPadreFallito(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_controller.tools/_controller.01.php');
        $I->dontSee('segreto di importazione assente');
        $I->see('primo account: 200');
        $I->see('secondo account: 409');
        $I->see('sottoform orfane: 0');
    }

    // controller() -> il controller di immagini mette NON_SCALABILE a un SVG e lo toglie quando il percorso diventa un JPEG
    public function immagineNonScalabile(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_controller.tools/_controller.02.php');
        $I->dontSee('segreto di importazione assente');
        $I->see('inserimento: 200');
        $I->see("token col percorso SVG: 'NON_SCALABILE'");
        $I->see('aggiornamento: 200');
        $I->see('token col percorso JPEG: NULL');
    }

    // isFieldPresent(), getNextOrder() e controller() -> le sottoform senza indice SORTING seguono il campo ordine, e la prossima riga prende il multiplo di dieci dopo il più alto
    public function ordineSottoform(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_controller.tools/_controller.03.php');
        $I->dontSee('segreto di importazione assente');
        $I->dontSee('servono almeno tre gruppi');
        $I->see('ordine in account_gruppi: true');
        $I->see('campo inesistente: false');
        $I->see('inserimento: 200');
        $I->see("prossimo ordine: '40'");
        $I->see('campo non valido: NULL');
        $I->see('tabella senza ordine: NULL');
        $I->see('ordine delle sottoform: 15, 20, 30');
    }

}
