<?php

    /**
     * configurazione del modulo documenti
     *
     * Valori di default delle opzioni del modulo, che il deploy può cambiare con la chiave documenti dei file di
     * configurazione ( src/config.json, src/config.yaml ) o per sito; la fusione la fa _035.common.php.
     *
     * @file
     *
     */

    // destinatario in testo libero
    // Con true il form delle offerte espone il campo documenti.destinatario, e il PDF lo stampa al posto
    // dell'anagrafica quando il documento non ha un id_destinatario. Spento di default: per i documenti fiscali
    // il destinatario dev'essere un'anagrafica, e un deploy che non lo chiede non deve vedere il campo.
    $cf['documenti']['destinatario']['libero']          = false;

    // cliente tenuto nella duplicazione
    // Con true la copia di un documento tiene destinatario e sedi dell'originale; con false nasce senza,
    // e il destinatario si sceglie sulla copia ( chi duplica un preventivo per farne uno a un altro cliente ).
    $cf['documenti']['duplica']['destinatario']         = true;

    // numerazione nella duplicazione
    // Con true la copia di un documento prende subito sezionale dell'anno, numero successivo e data di oggi;
    // con false nasce senza, e si numera dalla scheda come un documento nuovo.
    $cf['documenti']['duplica']['numera']               = false;
