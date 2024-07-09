<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // array dei permessi
    $cf['auth']['permissions'] = array(
        'account' => array(
            CONTROL_FULL            => array( 'roots' )
        ),
        'account_gruppi' => array(
            CONTROL_FULL            => array( 'roots' )
        ),
        'account_gruppi_attribuzione' => array(
            CONTROL_FULL            => array( 'roots' )
        ),

        // TODO commenti MySQL OK fin qui

        'anagrafica' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'anagrafica_categorie' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'anagrafica_cittadinanze' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'anagrafica_indirizzi' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'anagrafica_settori' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'attesa' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'attivita' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'badge' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'contatti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),

        // TODO l'ordine alfabetico arriva fin qui

        'abbonamenti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'abbonamenti_attivi' => array(  // TODO eliminare
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'abbonamenti_archiviati' => array(  // TODO eliminare
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'contratti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'contratti_anagrafica' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'contratti_progetti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'contratti_attivi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'contratti_archiviati' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'costi_contratti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'orari_contratti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'tipologie_contratti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),        
        'rinnovi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'crediti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'relazioni_anagrafica' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'todo' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'todo_categorie' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'tipologie_todo' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        '__report_backlog_todo__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_sprint_todo__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_planned_todo__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_done_todo__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'campagne' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'pagine' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'menu' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'macro' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'pubblicazioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'recensioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__templates__' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        '__template_files__' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'notizie' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'categorie_notizie' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'notizie_categorie' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'notizie_categorie_prodotti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'notizie_prodotti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'video' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'audio' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'annunci' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'categorie_annunci' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'annunci_categorie' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'annunci_categorie_prodotti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'annunci_prodotti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'banner' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'banner_pagine' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'banner_zone' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'popup' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'popup_pagine' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'risorse' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'categorie_risorse' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'risorse_categorie' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'categorie_prodotti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' ),
            METHOD_GET => array( 'users' )
        ),
        'categorie_prodotti_caratteristiche' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'prodotti_categorie' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'caratteristiche' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'listini_gruppi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'prodotti' => array(
            CONTROL_FULL => array( 'roots' ),              
            CONTROL_FILTERED => array( 'staff' ),
            METHOD_GET => array( 'users' )
        ),
        'articoli' => array(
            CONTROL_FULL => array( 'roots' ),              
            CONTROL_FILTERED => array( 'staff' ),
            METHOD_GET => array( 'users' )
        ),
        'prezzi' => array(
            CONTROL_FULL => array( 'roots' )
        ),          
        'prodotti_categorie' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'prodotti_caratteristiche' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'articoli_caratteristiche' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'relazioni_prodotti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'relazioni_articoli' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'tipologie_prodotti' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'udm' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'listini' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_clienti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_zone' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_gruppi' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'sconti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'sconti_listini' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'sconti_articoli' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'tipologie_sconti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'modalita_spedizione' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'matricole' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'progetti_matricole' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'listini' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_clienti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_zone' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_clienti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_zone' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_gruppi' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'sconti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'sconti_listini' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'sconti_articoli' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'tipologie_sconti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_gruppi' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'coupon' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff'),
            METHOD_GET => array('users')
        ),
        'coupon_categorie_prodotti' => array(
                CONTROL_FULL => array('roots'),
                CONTROL_FILTERED => array('staff')
        ),
        'coupon_prodotti' => array(
                CONTROL_FULL => array('roots'),
                CONTROL_FILTERED => array('staff')
        ),
        'coupon_listini' => array(
                CONTROL_FULL => array('roots'),
                CONTROL_FILTERED => array('staff')
        ),
        'coupon_marchi' => array(
                CONTROL_FULL => array('roots'),
                CONTROL_FILTERED => array('staff')
        ),
        'corrispondenza' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' ),
            METHOD_GET => array( 'users' )
        ),
        'atti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' ),
            METHOD_GET => array( 'users' )
        ),
        'pesi' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'formati' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'contatti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'campagne' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'matricole' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'certificazioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'certificazioni_archiviati' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'certificazioni_completa' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'tipologie_certificazioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'anagrafica_certificazioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'progetti_certificazioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'valutazioni_certificazioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'mailing' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'mailing_mail' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'mailing_liste' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'liste' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'liste_mail' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'immobili' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'immobili_anagrafica' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'immobili_caratteristiche' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'edifici' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'edifici_caratteristiche' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'menu' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'valutazioni' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'licenze' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'software' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'licenze_software' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ticket' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ticket_archiviati' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ticket_attivi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ticket_gestiti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ticket_chiusi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'corsi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'discipline' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'fasce' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'livelli' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'recuperi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_corsi__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_iscritti_corsi__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_lezioni_corsi__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'audio' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'categorie_anagrafica' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'comuni' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff', 'users', 'guests' )
        ),
        'stati' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff', 'users', 'guests' )
        ),
        'contenuti' => array(
            CONTROL_FULL => array( 'roots' ,'staff'),
        ),
        'file' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'gruppi' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'istruzioni' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'iban' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'immagini' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'indirizzi' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'indirizzi_caratteristiche' => array(
            CONTROL_FULL => array( 'roots','staff' )
        ),
        'iscrizioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'iscrizioni_attivi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'iscrizioni_archiviati' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'job' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )    
        ),
        'tesseramenti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'tesseramenti_attivi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'tesseramenti_archiviati' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_tesseramenti_anagrafica__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'valutazioni' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'valutazioni_certificazioni' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'luoghi' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'mail' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'mail_out' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'mail_sent' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'progetti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'progetti_archivio' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'progetti_commerciale' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'progetti_commerciale_archivio' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'progetti_amministrazione' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'progetti_amministrazione_archivio' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'progetti_produzione' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'progetti_produzione_archivio' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'categorie_progetti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'pause_progetti' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'progetti_anagrafica' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'anagrafica_progetti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'progetti_categorie' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'macro' => array(
            CONTROL_FULL => array( 'roots' )
        ),
        'relazioni_progetti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'relazioni_categorie_progetti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ruoli_categorie_progetti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'todo' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_avanzamento_progetti__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_avanzamento_trattative__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_avanzamento_trattative_attive__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_avanzamento_trattative_gestite__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_avanzamento_amministrazione__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_avanzamento_amministrazione_attiva__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_avanzamento_amministrazione_gestita__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_status_contratti__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'mastri' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'magazzini' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'conti' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'registri' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        '__report_mastri__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_giacenza_magazzini__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_movimenti_magazzini__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_giacenza_mastri__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_mastri_orari__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_giacenza_ore__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_movimenti_ore__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_giacenze_mastri_quantitativi_gerarchico__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ) ,
        '__report_mastri_articoli__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'metadati' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'periodi' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'orari' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'pianificazioni' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'redirect' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'sms_out' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'sms_sent' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'task' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'telefoni' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'template' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'zone_indirizzi' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'tipologie_attivita' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'tipologie_luoghi' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'tipologie_periodi' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'tipologie_zone' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'ranking' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'reparti' => array(
            CONTROL_FULL => array( 'roots' ),
            METHOD_GET => array( 'staff' )
        ),
        'url' => array(
            CONTROL_FULL => array( 'roots', 'staff' )
        ),
        'video' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'zone' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'zone_stati' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'documenti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'documenti_articoli' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'relazioni_documenti_articoli' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'pagamenti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'proforma' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'righe_proforma' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'fatture' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'righe_fatture' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'fatture_attive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'righe_fatture_attive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ricevute_attive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'righe_ricevute_attive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'fatture_passive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'righe_fatture_passive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ricevute_passive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'righe_ricevute_passive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ddt' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ddt_attivi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ddt_passivi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'note_credito' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'note_credito_attive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'righe_note_credito_attive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'note_credito_passive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'righe_note_credito_passive' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'relazioni_documenti' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ordini' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ordini_attivi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        'ordini_passivi' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_documenti_carrelli__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED        => array( 'staff' )
        ),
        '__report_giacenza_crediti__' => array(
            CONTROL_FULL => array( 'roots' ),
            CONTROL_FILTERED => array( 'staff' )
        ),
        '__report_variazioni_anagrafica__' => array(
            CONTROL_FULL => array( 'roots','staff' )
        )
    );
 