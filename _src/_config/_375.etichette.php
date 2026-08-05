<?php

    /**
     * applicazione dei formati delle etichette
     *
     * Questo runlevel segue l'inclusione del runlevel 370 di base, dei moduli e delle rispettive controparti
     * custom, quindi a questo punto tutte le etichette sono dichiarate e si possono recepire le direttive
     * presenti nei file di configurazione JSON/YAML sotto il ramo etichette.
     *
     * Tipicamente un progetto ridefinisce il solo formato:
     *
     *     "etichette": { "colli": { "formato": [ 65, 56 ] } }
     *
     * mentre le misure del contenuto restano quelle di riferimento e vengono riscalate al momento della
     * stampa da scalaEtichetta(). Se serve forzare una misura invece di lasciarla scalare la si dichiara
     * accanto al formato, nello stesso gruppo in cui compare nel riferimento:
     *
     *     "etichette": { "colli": { "formato": [ 65, 56 ], "verticali": { "barcode": 40 } } }
     *
     * Per rendere i formati disponibili al template manager viene collegato $ct['etichette'] a &$cf['etichette'].
     *
     * @file
     *
     */

    // configurazione extra
    if( isset( $cx['etichette'] ) ) {
        $cf['etichette'] = array_replace_recursive( $cf['etichette'], $cx['etichette'] );
    }

    // collegamento all'array $ct
    $ct['etichette'] = &$cf['etichette'];

    // debug
    // dieText( print_r( $cf['etichette'], true ) );
