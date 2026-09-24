<?php

    /**
     * 1 - setta a zero giorni_rinnovo
     * 2 - setta data_fine al valore ricevuto
     * 3 - cancella tutte le entità collegate successive alla data_fine
     * 
     * "successivo" significa con il campo che ha placeholder %data% nel JSON per l'entità collegata
     * 
     *
     *
     *
     * @todo commentare
     * @todo usare le funzioni di ACL per verificare se l'azione è autorizzata
     * @file
     *
     */

    // imposto la modalità hard
    $_REQUEST['hard'] = 1;

    // fallback su _pianificazioni.clean.php
    require '_pianificazioni.clean.php';
