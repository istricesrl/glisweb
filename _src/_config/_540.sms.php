<?php

    /**
     * server e profili SMS
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    /**
     * definizione dei server
     * ======================
     * 
     * 
     */

    // server disponibili
    $cf['sms']['servers']            = array();

    /**
     * definizione dei profili
     * =======================
     * 
     * 
     */

    // profili di funzionamento
    $cf['sms']['profiles'][ DEVELOPEMENT ]         =
    $cf['sms']['profiles'][ TESTING ]    =
    $cf['sms']['profiles'][ PRODUCTION ]    = NULL;

    /**
     * coda degli SMS
     * ==============
     * Il task di invio ( `_src/_api/_task/_sms.queue.send.php` ) marca con il proprio token l'SMS che sta inviando; se il
     * processo muore prima di togliere il token la riga resterebbe bloccata per sempre, quindi all'inizio di ogni giro il
     * task sblocca gli SMS marcati da più di `minuti_sblocco` minuti, come fa quello delle mail con la chiave omonima di
     * `_350.mail.php`. Il valore si cambia da `src/config.json` o `src/config.yaml` ( chiave `sms.minuti_sblocco` ).
     *
     */

    // minuti dopo i quali un SMS marcato e mai rilasciato torna in coda
    $cf['sms']['minuti_sblocco']     = 60;
