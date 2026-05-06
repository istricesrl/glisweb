<?php

    /**
     * applicazione delle configurazioni di uso comune
     *
     * logica di applicazione delle configurazioni
     * ===========================================
     * Questo runlevel segue l'inclusione del runlevel 030, quindi recepisce eventuali modifiche alla
     * configurazione di quel runlevel eventualmente fatte in custom; inoltre recepisce eventuali direttive
     * presenti nei file di configurazione JSON/YAML.
     *
     * Per rendere disponibile la configurazione di uso comune al template manager viene collegato
     * $ct['common'] a &$cf['common'].
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * In questa sezione vengono recepite le eventuali direttive presenti nei file di configurazione
     * JSON/YAML integrandole con l'array $cf['common'].
     *
     */

    // configurazione extra
    if( isset( $cx['common'] ) ) {
        $cf['common'] = array_replace_recursive( $cf['common'], $cx['common'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * Questa scorciatoia rende disponibili le informazioni di uso comune al template manager.
     *
     */

    // collegamento all'array $ct
    $ct['common'] = &$cf['common'];

    /**
     * debug del runlevel
     * ==================
     * In questa sezione sono presenti, commentate, delle righe utili per il debug di questo runlevel.
     *
     */

    // debug
    // dieText( print_r( $cf['common'], true ) );
    // echo 'OUTPUT';
