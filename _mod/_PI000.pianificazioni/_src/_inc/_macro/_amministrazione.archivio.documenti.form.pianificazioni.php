<?php

    /**
     * macro del form documenti, scheda pianificazione
     *
     * Questa macro prepara la pagina amministrazione.archivio.documenti.form.pianificazioni, la scheda che il modulo
     * _PI000.pianificazioni aggiunge al form dei documenti di _DO000.documenti ( il blocco RELAZIONI CON IL MODULO
     * PIANIFICAZIONI nelle sue pagine ): il collegamento alla pianificazione da cui il documento è nato, se c'è, e il comando
     * che crea una pianificazione nuova con il documento come modello ( il task pianificazione.da.oggetto ), che porta al
     * form della pianificazione per completarla. Le schede gemelle sono quelle del form delle fatture di _DO010.fatture e del
     * form delle attività di _AT000.attivita.
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
    $ct['form']['table'] = 'documenti';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '01.origine' => array(
            'label' => 'pianificazione di origine'
        ),
        '03.elaborazioni' => array(
            'label' => 'elaborazioni'
        )
    );

    // pianificazione da cui è nato il documento
    if( ! empty( $_REQUEST[ $ct['form']['table'] ]['id_pianificazione'] ) ) {
        $ct['page']['contents']['metro']['01.origine'][] = array(
            'url' => $cf['contents']['pages']['pianificazioni.form']['url'][ LINGUA_CORRENTE ] . '?pianificazioni[id]=' . $_REQUEST[ $ct['form']['table'] ]['id_pianificazione'],
            'icon' => NULL,
            'fa' => 'fa-calendar',
            'title' => 'pianificazione #' . $_REQUEST[ $ct['form']['table'] ]['id_pianificazione'],
            'text' => 'questo documento è stato creato dalla pianificazione, apri il suo form'
        );
    }

    // creazione di una pianificazione con il documento come modello
    if( ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) && getPrivilege( 'GESTIONE_PIANIFICAZIONI' ) ) {
        $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
            'ws' => '/task/PI000.pianificazioni/pianificazione.da.oggetto?entita=documenti&id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
            'callback' => 'function( data ) { window.open( "' . $cf['contents']['pages']['pianificazioni.form']['url'][ LINGUA_CORRENTE ] . '?pianificazioni[id]=" + data.pianificazione.id, "_self" ); }',
            'confirm' => true,
            'icon' => NULL,
            'fa' => 'fa-calendar-plus',
            'title' => 'pianifica questo documento',
            'text' => 'crea una pianificazione che ha questo documento, con righe e pagamenti, come modello'
        );
    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
