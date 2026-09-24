<?php

    /**
     * namespace di configurazione delle automazioni pianificate
     *
     * Questo file inizializza $cf['automazioni'], il namespace in cui i task pianificati (tabella task,
     * API /api/cron) leggono i propri interruttori e parametri di perimetro. Il framework standard non
     * definisce alcuna automazione: i default e i valori veri vivono nella controparte custom di progetto
     * (src/config/700.automazioni.php) e, per gli interruttori, in src/config.json.
     *
     * Il file deve esistere anche se vuoto: il loop dei runlevel in _src/_config.php fa glob() sui soli
     * file standard e ricava la controparte custom con path2custom(), quindi un file custom privo di
     * gemello standard non verrebbe mai incluso.
     *
     * Come tutti i namespace a profili (mysql, memcache, redis, google, teamsystem...) la configurazione
     * e' divisa in due file, secondo la convenzione dei runlevel accoppiati:
     *
     *   _700 (questo)  dichiarazione: si costruisce l'array dei default, un ramo per profilo
     *   _705           attivazione: merge di src/config.json, collegamento a $ct, link al profilo corrente
     *
     * Runlevel 700 = importazione, elaborazione ed esportazione dei dati.
     *
     */

    // namespace delle automazioni pianificate
    $cf['automazioni'] = array();
