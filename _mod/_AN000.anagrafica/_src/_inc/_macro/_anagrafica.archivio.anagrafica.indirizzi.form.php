<?php

    /**
     * macro form anagrafica archivio anagrafica indirizzi
     * 
     * Questa è la macro del modulo di gestione degli indirizzi dell'anagrafica. La tabella anagrafica_indirizzi
     * contiene gli indirizzi associati ad un'anagrafica.
     * 
     * La tabella anagrafica_indirizzi contiene già tutte le colonne necessarie per registrare un indirizzo completo,
     * tuttavia negli scenari in cui è possibile che si verifichino forti duplicazioni di indirizzi bisogna valutare
     * di ricorrere alla tabella indirizzi, e usare anagrafica_indirizzi come tabella di associazione tra anagrafica
     * e indirizzo.
     * 
     */

    /**
     * configurazione del form
     * =======================
     * 
     * 
     * 
     */

    // tabella gestita
    $ct['form'] = array(
        'table' => 'anagrafica_indirizzi',
    );

    /**
     * dati delle tendine
     * ==================
     * 
     * 
     * 
     * 
     * 
     */

    // tendina ruoli indirizzi
    $ct['etc']['select']['ruoli_indirizzi'] = tendinaRuoliIndirizzi();

    // tendina tipologie indirizzi
    $ct['etc']['select']['tipologie_indirizzi'] = tendinaTipologieIndirizzi();

    /**
     * macro di default
     * ================
     * 
     * 
     * 
     * 
     */

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    /**
     * debug del form
     * ==============
     * 
     * 
     * 
     */

    // debug
    // print_r( $_REQUEST );
