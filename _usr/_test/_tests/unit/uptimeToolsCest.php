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

    // uptimeProfilo() -> il profilo che il bootstrap darebbe all'host: si controllano solo quelli che cominciano per PROD
    public function profilo(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_uptime.tools/_uptime.01.php');
        $I->see("profilo esempio.istricesrl.it: 'DEV'");
        $I->see("profilo www.esempio.it: 'PROD'");
        $I->see("profilo esempio.it: 'PROD'"); // con www fra gli host, il www è facoltativo
        $I->see("profilo magazzino.interno.esempio.it: 'PRODWMS'");
        $I->see("profilo altro.it: NULL");
        $I->see('profilo come il bootstrap: true'); // uptimeProfilo() e _015.site.php usano la stessa site2regexp()
    }

    // uptimeEsterni() -> i siti esterni hanno i default, codice 200 e nessun testo atteso, e non hanno deploy
    public function esterni(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_uptime.tools/_uptime.01.php');
        $I->see('esterni: www.esterno.it');
        $I->see('esterno: codice 200, testo NULL, lento 5, soglia 3, deploy NULL');
    }

    // uptimeImpronta() -> l'impronta della sezione esterni: non cambia con l'ordine delle chiavi, cambia col contenuto
    public function impronta(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_uptime.tools/_uptime.01.php');
        $I->see('impronta riordinata: true, impronta diversa: true');
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

    // uptimeAggiorna() -> lento solo dopo tre giri di fila oltre la soglia, che si sceglie per sito
    public function lento(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_uptime.tools/_uptime.01.php');
        $I->see('lento a freddo e poi veloce: false');
        $I->see('giro lento 2: false');
        $I->see('giro lento 3: true');
        $I->see('soglia del sito a 10 secondi: false');
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
