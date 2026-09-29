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

    /**
     * limite di tentativi
     * ===================
     * Un SMS che non parte resta in coda e viene riprovato dopo tante ore quanti sono i tentativi fatti; arrivato a
     * `tentativi_massimi` tentativi falliti il task di invio non lo riprova più: la riga resta in `sms_out` marcata con il
     * token dedicato `TROPPI_TENTATIVI`, che la esclude dal giro normale, da `hard=1` e da `full=1`, e l'errore va nel log
     * `sms`, come fa il task delle mail con la chiave omonima di `_350.mail.php`. Lo fa ripartire, con i tentativi
     * azzerati, l'invio forzato dalla scheda dell'SMS in uscita ( `id=<id>` ). Il valore si cambia da `src/config.json` o
     * `src/config.yaml` ( chiave `sms.tentativi_massimi` ); con 0 il limite non c'è.
     *
     */

    // tentativi falliti dopo i quali un SMS non si riprova più
    $cf['sms']['tentativi_massimi']  = 10;
