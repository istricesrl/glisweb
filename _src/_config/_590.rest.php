<?php

    /**
     * chiamate REST in uscita
     *
     * introduzione
     * ============
     * Le chiamate HTTP in uscita del framework e dei moduli passano per restCall() ( _src/_lib/_rest.tools.php ); qui
     * si configura quello che riguarda tutte, e per ora e' soltanto il finto REST dei test automatici.
     *
     * finto REST per i test
     * ---------------------
     * Durante i test automatici le chiamate verso gli host elencati in $cf['rest']['mock']['hosts'] non vanno al
     * servizio vero ma al finto REST avviato da _src/_sh/_codeception.run.sh ( _usr/_test/_rest.mock.php ), che
     * risponde come gli dicono i test e registra le richieste ricevute; il collegamento lo fa _595.rest.php. Un
     * progetto elenca qui gli host dei gestionali e dei servizi che i test non devono toccare:
     *
     * ```yaml
     * rest:
     *   mock:
     *     hosts:
     *       - "api.gestionale.it"
     * ```
     *
     * L'host esempio.test e' sempre deviato: il dominio .test e' riservato e non esiste, e lo usano i test del framework.
     *
     */

    /**
     * finto REST per i test
     * =====================
     *
     *
     */

    // host deviati verso il finto REST durante i test
    $cf['rest']['mock']['hosts']                = array();
