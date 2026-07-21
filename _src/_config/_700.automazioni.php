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
     * Runlevel 700 = importazione, elaborazione ed esportazione dei dati.
     *
     */

    // namespace delle automazioni pianificate
    $cf['automazioni'] = array();

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     *
     *
     */

    // collegamento a $ct
    $ct['automazioni'] = &$cf['automazioni'];
