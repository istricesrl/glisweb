<?php

    /**
     * dichiarazione delle configurazioni del modulo Modula
     *
     * Il modulo parla col WMS Modula dei magazzini verticali attraverso il protocollo WebService 1.11: il WMS
     * espone i suoi job in modalita' server e il gestionale li chiama da client, mandando gli ordini in POST,
     * scaricando gli esiti in GET e confermandoli con l'ack. Le funzioni stanno in _src/_lib/_modula.utils.php.
     *
     * sezione profili
     * ===============
     * Come per gli altri servizi esterni la configurazione sta per profilo, perche' ogni ambiente ha il suo WMS
     * ( o nessuno ): qui si dichiarano solo i default, il merge con config.json e il link al profilo corrente
     * stanno in _035.common.php. Le chiavi:
     *
     * chiave       | significato
     * -------------|---------------------------------------------------------------------------------------
     * url          | URL di base del servizio, p.es. http://10.0.0.10:8080; con NULL il modulo non chiama nulla
     * auth         | 'bearer' ( token chiesto a /token con utente e password ) oppure 'basic'
     * username     | utente del servizio
     * password     | password del servizio: va SOLO in src/shadow.json, mai in config.json
     * jobs         | nomi dei job configurati sul WMS, per funzione: import ed export degli ordini, import
     *              | dell'anagrafica articoli, export delle giacenze
     * timeout      | attesa massima della risposta, in secondi
     *
     */

    // profili di funzionamento
    $cf['modula']['profiles'][ DEVELOPEMENT ] =
    $cf['modula']['profiles'][ TESTING ]      =
    $cf['modula']['profiles'][ PRODUCTION ]   = array(
        'url'       => NULL,
        'auth'      => 'bearer',
        'username'  => NULL,
        'password'  => NULL,
        'jobs'      => array(
            'import'    => 'CFG-IMP-ORDINI',
            'export'    => 'CFG-EXP-ORDINI',
            'articoli'  => 'CFG-IMP-ARTICOLI',
            'giacenze'  => 'CFG-EXP-GIACENZE'
        ),
        'timeout'   => 30
    );
