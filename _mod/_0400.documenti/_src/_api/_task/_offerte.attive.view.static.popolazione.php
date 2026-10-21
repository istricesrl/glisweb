<?php

    /**
     * popolazione della vista statica delle offerte: NOME VECCHIO
     *
     * Dal 04/10/2026 la statica e' offerte_view_static ( tutte le offerte, non piu' le sole attive ) e il task
     * si chiama _offerte.view.static.popolazione.php. Questo file resta perche' qualche deploy potrebbe avere
     * pianificato il nome vecchio: rimanda a quello nuovo.
     *
     * @file
     *
     */

    // rimando al task col nome nuovo
    require __DIR__ . '/_offerte.view.static.popolazione.php';
