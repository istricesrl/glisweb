<?php

    /**
     * dichiarazione delle configurazioni del modulo mastri
     *
     * unita' di misura
     * ================
     * Le maschere di magazzino mostrano all'operatore la parola al posto del codice dell'unita' di misura
     * ( confezioniArticolo() in _src/_lib/_mysql.utils.add.php ). I codici sono quelli del gestionale di
     * ciascun progetto, quindi lo standard non ne dichiara nessuno: il progetto li elenca nel ramo mastri
     * di src/config.json, codice => [ singolare, plurale ], p.es.
     *
     *     "mastri": { "udm": { "parole": { "SC": [ "scatola", "scatole" ], "PC": [ "pacco", "pacchi" ] } } }
     *
     * Un codice che non e' dichiarato si mostra cosi' com'e'.
     *
     * @file
     *
     */

    // unita' di misura
    $cf['mastri']['udm']['parole'] = array();
