<?php

    /**
     * iscrizione alla newsletter dal sito pubblico
     *
     * Registra presso il modulo contatti ( `_CT000.contatti` o `_0300.contatti` ) il form `newsletter`, che si
     * spedisce come `__ct__[newsletter][...]` e che la controller `_newsletter.php` trasforma in un'iscrizione.
     *
     * configurazione
     * ==============
     * chiave       | descrizione
     * -------------|---------------------------------------------------------------------------------------------
     * controller   | le controller da eseguire alla ricezione del form
     * liste        | le liste a cui si può iscrivere chi compila il form, per id o per nome; se il form spedisce il
     *              | campo `lista` l'indirizzo va solo in quella ( se è fra queste ), altrimenti in tutte
     *
     * Il deploy cambia le liste dalla configurazione, p.es. in `src/config.json`:
     *
     * ```
     * "contatti": { "newsletter": { "liste": [ "newsletter" ] } }
     * ```
     *
     * NOTA i moduli contatti assegnano `$cf['contatti']` per intero nel loro `_030.common.php`, che gira prima
     * di questo; per questo qui si integra e non si assegna. La configurazione da file la fonde poi il
     * `_035.common.php` di `_CT000.contatti` ( `_0300.contatti` la fonde prima, ed è per questo che i valori già
     * presenti vincono su quelli di default ).
     *
     * @file
     *
     */

    // form di iscrizione alla newsletter
    $cf['contatti']['newsletter'] = array_replace(
        array(
            'controller' => array( '_mod/_ML000.mailing/_src/_inc/_controllers/_form/_newsletter.php' ),
            'liste' => array( 'newsletter' )
        ),
        $cf['contatti']['newsletter'] ?? array()
    );
