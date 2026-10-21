<?php

    /**
     * profili Smartsupp
     *
     * In questo file vengono integrati i dati dichiarati al runlevel _690.smartsupp.php con quelli presenti
     * nei file di configurazione JSON/YAML, generali e per sito, dopodiché $cf['smartsupp'] viene collegato
     * a $ct['smartsupp'] e viene agganciato il profilo corrente, che è quello che legge lo snippet
     * _src/_twig/_inc/_smartsupp.twig.
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     *
     *
     */

    // configurazione extra
    if( isset( $cx['smartsupp'] ) ) {
        $cf['smartsupp'] = array_replace_recursive( $cf['smartsupp'], $cx['smartsupp'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['smartsupp'] ) ) {
        $cf['smartsupp'] = array_replace_recursive( $cf['smartsupp'], $cf['site']['smartsupp'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     *
     *
     */

    // collegamento all'array $ct
    $ct['smartsupp'] = &$cf['smartsupp'];

    /**
     * scorciatoia per il profilo corrente
     * ===================================
     *
     *
     */

    // link al profilo corrente
    $cf['smartsupp']['profile'] = &$cf['smartsupp']['profiles'][ SITE_STATUS ];

    /**
     * debug del runlevel
     * ==================
     * Questa sezione contiene alcune righe commentate utili per il debug del runlevel.
     *
     */

    // debug
    // print_r( $cf['smartsupp']['profile'] );
