<?php

    /**
     * profili Criteo
     *
     * In questo file vengono integrati i dati dichiarati al runlevel _650.criteo.php con quelli presenti
     * nei file di configurazione JSON/YAML, generali e per sito, dopodiché $cf['criteo'] viene collegato
     * a $ct['criteo'] e viene agganciato il profilo corrente, che è quello che legge lo snippet
     * _src/_twig/_inc/_criteo.twig.
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     *
     *
     */

    // configurazione extra
    if( isset( $cx['criteo'] ) ) {
        $cf['criteo'] = array_replace_recursive( $cf['criteo'], $cx['criteo'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['criteo'] ) ) {
        $cf['criteo'] = array_replace_recursive( $cf['criteo'], $cf['site']['criteo'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     *
     *
     */

    // collegamento all'array $ct
    $ct['criteo'] = &$cf['criteo'];

    /**
     * scorciatoia per il profilo corrente
     * ===================================
     *
     *
     */

    // link al profilo corrente
    $cf['criteo']['profile'] = &$cf['criteo']['profiles'][ SITE_STATUS ];

    /**
     * debug del runlevel
     * ==================
     * Questa sezione contiene alcune righe commentate utili per il debug del runlevel.
     *
     */

    // debug
    // print_r( $cf['criteo']['profile'] );
