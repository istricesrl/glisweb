<?php

    /**
     * macro del form pianificazioni, scheda strumenti
     *
     * Questa macro prepara la pagina pianificazioni.form.tools, con i comandi sulla singola pianificazione: creare
     * subito gli oggetti scaduti ( il task pianificazioni.populate con l'id, come il pulsante "esegui il task" di
     * _mod/_0030.strumenti/_src/_inc/_macro/_task.form.tools.php ) e fermarla a una data, con o senza la cancellazione
     * degli oggetti successivi ( il task pianificazioni.stop, dal modal ferma della fase a modelli di
     * _0100.pianificazioni ). I comandi compaiono solo a chi ha il privilegio GESTIONE_PIANIFICAZIONI, che è quello
     * richiesto dai due task.
     *
     * -# tabella gestita
     * -# gruppi di controlli
     * -# comandi
     * -# macro di default
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'pianificazioni';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '03.elaborazioni' => array(
            'label' => 'elaborazioni'
        )
    );

    // comandi sulla pianificazione
    if( ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) && getPrivilege( 'GESTIONE_PIANIFICAZIONI' ) ) {

        // creazione degli oggetti scaduti
        $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
            'ws' => '/task/PI000.pianificazioni/pianificazioni.populate?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
            'callback' => 'function() { location.reload(); }',
            'icon' => NULL,
            'fa' => 'fa-calendar-plus',
            'title' => 'crea gli oggetti',
            'text' => 'crea subito gli oggetti scaduti di questa pianificazione ( i documenti uno alla volta )'
        );

        // interruzione
        $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
            'modal' => array( 'id' => 'ferma_pianificazione', 'include' => 'inc/pianificazioni.form.tools.modal.ferma.twig' ),
            'icon' => NULL,
            'fa' => 'fa-calendar-xmark',
            'title' => 'ferma la pianificazione',
            'text' => 'imposta la data di fine ed eventualmente cancella gli oggetti successivi'
        );

    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
