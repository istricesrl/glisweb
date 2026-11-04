<?php

/**
 * test di _src/_lib/_uptime.tools.php e di /status/uptime
 *
 * le funzioni che toccano la rete e il filesystem del server ( uptimeSiti(), uptimeControlla(), uptimeVista() ) si
 * provano con _src/_sh/_uptime.check.sh --secco: qui si provano la lettura dei vhost e la logica del giro
 *
 */

class uptimeToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // uptimePubblico() -> un vhost di prova solo locale ( /etc/hosts verso 127.0.0.1 ) non si controlla
    public function pubblico(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_uptime.tools/_uptime.01.php');
        $I->see('pubblico 35.195.114.10: true');
        $I->see('pubblico 10.0.0.1: false');
        $I->see('pubblico localhost: false');
        $I->see('pubblico nessuno.invalid: false');
    }

    // uptimeVhost() -> solo i virtual host sulla 443, col primo nome, e la document root senza barra finale
    public function vhost(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_uptime.tools/_uptime.01.php');
        $I->see('vhost /var/www/uno/dev: uno.example.it');
        $I->see('vhost /var/www/due/dev: due.example.it');
        $I->dontSee('www.uno.example.it');
        $I->see('vhost sulla 80: assente');
    }

    // uptimeAggiorna() -> giù al terzo fallimento consecutivo, su al primo controllo riuscito
    public function isteresi(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_uptime.tools/_uptime.01.php');
        $I->see('fallimento 2: su');
        $I->see('fallimento 3: giu');
        $I->see('dopo un controllo riuscito: su, fallimenti 0');
    }

    // uptimeConsenso() -> giù solo se lo vede giù anche un altro server, e avvisa il primo in ordine alfabetico
    public function consenso(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_uptime.tools/_uptime.01.php');
        $I->see('giu anche per un altro: giu, mittente true');
        $I->see('giu anche per un altro che viene prima: giu, mittente false');
        $I->see('su per un altro: su');
        $I->see('nessun altro risponde: nonconfermato, mittente true');
    }

    // uptimeTransizione() e uptimeDowntime() -> un evento all'inizio e uno alla fine, e la riga del periodo
    public function downtime(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_uptime.tools/_uptime.01.php');
        $I->see('eventi: inizio, NULL, fine dopo 600 secondi');
        $I->see('riga del DOWNTIME.md: | 2026-11-04 10:00 | 2026-11-04 10:10 | 10 min | sito.it | sì | timeout |');
        $I->see('siti di altri deploy esclusi: si');
    }

    // /status/uptime -> per tutti solo OK, senza versioni né nomi; senza il token giusto la vista non si vede
    public function statusPubblico(UnitTester $I)
    {
        $I->amOnPage('/status/uptime');
        $I->seeResponseCodeIs(200);
        $I->see('OK');
        $I->dontSee('versione');
        $I->haveHttpHeader('X-Glisweb-Uptime', 'token-sbagliato');
        $I->amOnPage('/status/uptime');
        $I->seeResponseCodeIs(403);
    }

}
