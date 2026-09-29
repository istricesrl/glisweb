<?php

    /**
     * macro del form pianificazioni, scheda modello
     *
     * Questa macro prepara la pagina pianificazioni.form.modello, dove si scrive il modello dell'oggetto che la
     * pianificazione crea: le colonne model_* ( model_X finisce nella colonna X dell'oggetto, vedi
     * pianificazioniRiga() in _mod/_PI000.pianificazioni/_src/_lib/_pianificazioni.utils.php ). I campi, e quindi le
     * tendine, dipendono dall'entità scelta nella scheda principale; per i documenti il template mostra anche il sub
     * form delle pianificazioni figlie, che sono il modello delle righe e dei pagamenti.
     *
     * La logica viene da _pianificazioni.form.modello.php e _pianificazioni.form.modello.documenti.php di
     * _0100.pianificazioni, che avevano il modello dei soli documenti: quelli delle altre entità sono nuovi e
     * seguono i form delle rispettive tabelle nei moduli di nuova generazione.
     *
     * -# tabella gestita
     * -# tendine comuni
     * -# tendine per entità
     * -# macro di default
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'pianificazioni';

    // entità della pianificazione
    $entita = $_REQUEST[ $ct['form']['table'] ]['entita'] ?? NULL;

    // tendina entità delle pianificazioni figlie di un documento
    $ct['etc']['select']['entita'] = array(
        array( 'id' => 'documenti_articoli', '__label__' => 'riga' ),
        array( 'id' => 'pagamenti', '__label__' => 'pagamento' )
    );

    // tendine per righe e pagamenti ( documenti, e righe e pagamenti autonomi )
    if( in_array( $entita, array( 'documenti', 'documenti_articoli', 'pagamenti' ) ) ) {

        // tendina udm
        $ct['etc']['select']['udm'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM udm_view'
        );

        // tendina listini
        $ct['etc']['select']['listini'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM listini_view'
        );

        // tendina reparti
        $ct['etc']['select']['reparti'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM reparti_view'
        );

        // tendina modalità di pagamento
        $ct['etc']['select']['modalita_pagamento'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM modalita_pagamento_view'
        );

        // tendina fine mese
        $ct['etc']['select']['fine_mese'] = array(
            array( 'id' => '1', '__label__' => 'fine mese' )
        );

    }

    // tendine per entità
    if( $entita == 'documenti' ) {

        // tendina tipologie documenti
        $ct['etc']['select']['tipologie_documenti'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_documenti_view ORDER BY __label__ ASC'
        );

        // tendina condizioni di pagamento
        $ct['etc']['select']['condizioni_pagamento'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM condizioni_pagamento_view ORDER BY __label__ ASC'
        );

        // esigibilità iva
        $ct['etc']['select']['esigibilita'] = array(
            array( 'id' => 'I', '__label__'=> 'I - immediata' ),
            array( 'id' =>'D', '__label__'=> 'D - differita' ),
            array( 'id' =>'S', '__label__'=> 'S - scissione dei pagamenti')
        );

        // tendine sedi e IBAN dell'emittente
        if( ! empty( $_REQUEST[ $ct['form']['table'] ]['model_id_emittente'] ) ) {

            // tendina sedi emittente
            $ct['etc']['select']['id_sedi_emittente'] = mysqlCachedIndexedQuery(
                $cf['memcache']['index'],
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT anagrafica_indirizzi_view.id, __label__ FROM anagrafica_indirizzi_view WHERE anagrafica_indirizzi_view.id_anagrafica = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['model_id_emittente'] ) )
            );

            // tendina IBAN
            $ct['etc']['select']['iban'] = mysqlCachedIndexedQuery(
                $cf['memcache']['index'],
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT id, __label__ FROM iban_view WHERE id_anagrafica = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['model_id_emittente'] ) )
            );

        }

        // tendina sedi destinatario
        if( ! empty( $_REQUEST[ $ct['form']['table'] ]['model_id_destinatario'] ) ) {
            $ct['etc']['select']['id_sedi_destinatario'] = mysqlCachedIndexedQuery(
                $cf['memcache']['index'],
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT anagrafica_indirizzi_view.id, __label__ FROM anagrafica_indirizzi_view WHERE anagrafica_indirizzi_view.id_anagrafica = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['model_id_destinatario'] ) )
            );
        }

    } elseif( $entita == 'pagamenti' ) {

        // tendina IBAN
        $ct['etc']['select']['iban'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM iban_view'
        );

    } elseif( $entita == 'todo' ) {

        // tendina tipologie todo
        $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, nome AS __label__ FROM tipologie_todo ORDER BY nome ASC'
        );

    } elseif( $entita == 'attivita' ) {

        // tendina tipologie attività
        $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_attivita_view ORDER BY __label__ ASC'
        );

    } elseif( $entita == 'rinnovi' ) {

        // tendina tipologie rinnovi
        $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, nome AS __label__ FROM tipologie_rinnovi ORDER BY nome ASC'
        );

    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
