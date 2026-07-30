<?php

    /**
     * attivazione della configurazione delle automazioni pianificate
     *
     * Gemello di _700.automazioni.php, secondo la convenzione dei runlevel accoppiati: nel file che
     * finisce per 0 si dichiarano i default (un ramo per profilo), in quello che finisce per 5 si
     * integra la configurazione esterna e si collegano le scorciatoie. Stessa divisione di
     * _120/_125 (mysql), _040/_045 (cache), _110/_115 (google), _600/_605 (common).
     *
     * Da qui in poi il codice legge sempre da $cf['automazioni']['profile'], che e' il ramo
     * dell'ambiente corrente: cosi' src/config.json puo' portare i valori di tutti gli ambienti e
     * restare deployabile tale e quale.
     *
     * Runlevel 700 = importazione, elaborazione ed esportazione dei dati.
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     *
     *
     */

    // configurazione extra
    if( isset( $cx['automazioni'] ) ) {
        $cf['automazioni'] = array_replace_recursive( $cf['automazioni'], $cx['automazioni'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     *
     *
     */

    // collegamento all'array $ct
    $ct['automazioni']                  = &$cf['automazioni'];

    /**
     * collegamento scorciatoie
     * ========================
     *
     *
     */

    // link al profilo corrente.
    // A differenza degli altri namespace a profili il link e' condizionato: i profili delle
    // automazioni non sono dichiarati dallo standard ma dal progetto (src/config/700.automazioni.php),
    // e un progetto che non abbia automazioni non ne dichiara nessuno. Senza guardia si creerebbe qui
    // un profilo vuoto per il solo effetto del riferimento.
    if( isset( $cf['automazioni']['profiles'][ SITE_STATUS ] ) ) {
        $cf['automazioni']['profile']   = &$cf['automazioni']['profiles'][ SITE_STATUS ];
    }
