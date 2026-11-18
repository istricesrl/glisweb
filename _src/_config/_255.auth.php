<?php

    /**
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     */

    /**
     * integrazione dei permessi da file Json/Yaml
     * ===========================================
     *
     * _205.auth.php integra $cx['auth'] prima che _250.auth.php dichiari l'array dei permessi, che lo riassegna da capo:
     * per questo i permessi di config.json / config.yaml si integrano qui, dopo lo standard e dopo src/config/250.auth.php.
     * Fino al 2026-11-18 andavano persi in silenzio ( bernispa, auth.permissions.__report_barcode_qta__ ).
     *
     * Valgono le regole di array_replace_recursive(): un'entità nuova si aggiunge, e l'elenco dei gruppi di un'entità
     * esistente si sovrascrive per posizione, quindi da qui si possono aggiungere gruppi ma non toglierne; per togliere
     * un gruppo a un'entità dello standard si usa src/config/250.auth.php.
     *
     */

    // configurazione extra
    if( isset( $cx['auth']['permissions'] ) ) {
        $cf['auth']['permissions'] = array_replace_recursive( $cf['auth']['permissions'], $cx['auth']['permissions'] );
    }

    /**
     * elaborazione dei permessi per l'account connesso
     * ================================================
     * 
     * 
     * 
     */

    // popolo l'array dei permessi
    if( $cf['auth']['status'] == LOGIN_SUCCESS ) {

        // se la sessione corrente ha almeno un gruppo associato
        if( isset( $_SESSION['account']['gruppi'] ) ) {

            // per ogni entità $t valuto le coppie permesso / gruppi $w
            foreach( $cf['auth']['permissions'] as $t => $w ) {

                // per ogni coppia permesso $k / gruppi $j
                foreach( $w as $k => $j ) {

                    // se almeno un gruppo associato alla sessione corrente è presente tra i gruppi autorizzati
                    if( array_intersect( $_SESSION['account']['gruppi'], $j ) ) {
                        $_SESSION['account']['permissions'][ $t ][] = $k;
                    }

                }
            }

        }

    } elseif( isset( $_SESSION['account'] ) && ! empty( $_SESSION['account'] ) ) {

        // ...
        $cf['auth']['status'] = LOGIN_LOGGED;

    }

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // print_r( $_SESSION['account'] );
    // print_r( $_SESSION['account']['permissions'] );
    // print_r( $cf['auth'] );
    // echo $cf['auth']['status'];
