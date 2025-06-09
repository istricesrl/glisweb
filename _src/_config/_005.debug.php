<?php

    /**
     * applicazione delle configurazioni relative al debug del sistema
     *
     * logica di applicazione delle configurazioni
     * ===========================================
     * Questo runlevel segue l'inclusione del runlevel 000, quindi recepisce eventuali modifiche alla
     * configurazione di quel runlevel eventualmente fatte in custom; inoltre recepisce eventuali direttive
     * presenti nei file di configurazione JSON/YAML.
     * 
     * Per rendere disponibile la configurazione di debug al template manager viene collegato
     * $ct['debug'] a &$cf['debug'].
     * 
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * In questa sezione vengono recepite le eventuali direttive presenti nei file di configurazione
     * JSON/YAML integrandole con l'array $cf['debug'].
     * 
     */

    // configurazione extra
    if( isset( $cx['debug'] ) ) {
        $cf['debug'] = array_replace_recursive( $cf['debug'], $cx['debug'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * Qquesta scorciatoia rende disponibili le informazioni di debug al template manager.
     * 
     */

    // collegamento a $ct
    $ct['debug'] = &$cf['debug'];

    /**
     * debug del runlevel
     * ==================
     * In questa sezione sono presenti, commentate, delle righe utili per il debug di questo runlevel.
     * 
     */

    // debug
    // print_r( $cf['debug'] );
    // error_reporting( E_ALL );
    // ini_set( 'display_errors', TRUE );
    // echo 'OUTPUT';
