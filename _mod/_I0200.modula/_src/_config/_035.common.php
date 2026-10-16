<?php

    /**
     * attivazione delle configurazioni del modulo Modula
     *
     * Fa il merge della configurazione letta da config.json e shadow.json sui default dichiarati in
     * _030.common.php e aggancia il profilo dell'ambiente corrente, da cui le funzioni del modulo leggono
     * sempre: $cf['modula']['profile'], mai $cf['modula']['<chiave>'].
     *
     */

    // configurazione extra
    if( isset( $cx['modula'] ) ) {
        $cf['modula'] = array_replace_recursive( $cf['modula'], $cx['modula'] );
    }

    // collegamento all'array $ct
    $ct['modula'] = &$cf['modula'];

    // link al profilo corrente
    $cf['modula']['profile'] = &$cf['modula']['profiles'][ SITE_STATUS ];
