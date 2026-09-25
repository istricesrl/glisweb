<?php

    /**
     * macro del form attività, scheda pianificazione
     *
     * Questa macro prepara la pagina produzione.attivita.form.pianificazioni, la scheda che il modulo _PI000.pianificazioni
     * aggiunge al form delle attività di _AT000.attivita ( il blocco RELAZIONI CON IL MODULO
     * PIANIFICAZIONI nelle sue pagine ): il collegamento alla pianificazione da cui l'attività è nata, se c'è, e il comando
     * che crea una pianificazione nuova con l'attività come modello ( il task pianificazione.da.oggetto ), che porta al
     * form della pianificazione per completarla. Le schede gemelle sono quelle del form delle fatture di _DO010.fatture e del
     * form dei documenti di _DO000.documenti.
     *
     * -# tabella gestita
     * -# gruppi di controlli
     * -# pianificazione di origine
     * -# comandi
     * -# macro di default
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'attivita';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '01.origine' => array(
            'label' => 'pianificazione di origine'
        ),
        '03.elaborazioni' => array(
            'label' => 'elaborazioni'
        )
    );

    // pianificazione da cui è nata l'attività
    if( ! empty( $_REQUEST[ $ct['form']['table'] ]['id_pianificazione'] ) ) {
        $ct['page']['contents']['metro']['01.origine'][] = array(
            'url' => $cf['contents']['pages']['pianificazioni.form']['url'][ LINGUA_CORRENTE ] . '?pianificazioni[id]=' . $_REQUEST[ $ct['form']['table'] ]['id_pianificazione'],
            'icon' => NULL,
            'fa' => 'fa-calendar',
            'title' => 'pianificazione #' . $_REQUEST[ $ct['form']['table'] ]['id_pianificazione'],
            'text' => 'questa attività è stata creata dalla pianificazione, apri il suo form'
        );
    }

    // creazione di una pianificazione con l'attività come modello
    if( ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) && getPrivilege( 'GESTIONE_PIANIFICAZIONI' ) ) {
        $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
            'ws' => '/task/PI000.pianificazioni/pianificazione.da.oggetto?entita=attivita&id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
            'callback' => 'function( data ) { window.open( "' . $cf['contents']['pages']['pianificazioni.form']['url'][ LINGUA_CORRENTE ] . '?pianificazioni[id]=" + data.pianificazione.id, "_self" ); }',
            'confirm' => true,
            'icon' => NULL,
            'fa' => 'fa-calendar-plus',
            'title' => 'pianifica questa attività',
            'text' => 'crea una pianificazione che ha questa attività come modello'
        );
    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
