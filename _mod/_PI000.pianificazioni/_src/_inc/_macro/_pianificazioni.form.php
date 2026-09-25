<?php

    /**
     * macro del form pianificazioni
     *
     * Questa macro prepara la pagina pianificazioni.form, dove si dice QUANDO la pianificazione crea gli oggetti:
     * entità, periodicità, cadenza, giorni della settimana, schema di ripetizione e date. Il COME, cioè il modello
     * dell'oggetto, sta nella scheda pianificazioni.form.modello. La logica viene dal form della fase a modelli di
     * _0100.pianificazioni ( periodicità dalla tabella, attiva dal, finestra in giorni ) e dalla scheda delle todo della
     * fase precedente, l'unica che avesse i giorni della settimana e la ripetizione posizionale.
     *
     * -# tabella gestita
     * -# tendine
     * -# macro di default
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'pianificazioni';

    // tendina entità che si possono generare ( le righe e i pagamenti autonomi si aggiungono a un documento esistente )
    $ct['etc']['select']['entita'] = array(
        array( 'id' => 'documenti', '__label__' => 'documenti' ),
        array( 'id' => 'todo', '__label__' => 'todo' ),
        array( 'id' => 'attivita', '__label__' => 'attività' ),
        array( 'id' => 'rinnovi', '__label__' => 'rinnovi' ),
        array( 'id' => 'documenti_articoli', '__label__' => 'righe di un documento' ),
        array( 'id' => 'pagamenti', '__label__' => 'pagamenti di un documento' )
    );

    // solo le entità gestite da un modulo attivo ( vedi pianificazioniEntitaAttiva() ); quella di una pianificazione
    // esistente resta nella tendina anche se il suo modulo è stato spento, perché salvando il form non vada persa
    foreach( $ct['etc']['select']['entita'] as $k => $v ) {
        if( ! pianificazioniEntitaAttiva( $v['id'] ) ) {
            if( isset( $_REQUEST[ $ct['form']['table'] ]['entita'] ) && $_REQUEST[ $ct['form']['table'] ]['entita'] == $v['id'] ) {
                $ct['etc']['select']['entita'][ $k ]['__label__'] .= ' ( modulo non attivo )';
            } else {
                unset( $ct['etc']['select']['entita'][ $k ] );
            }
        }
    }

    // tendina periodicità
    $ct['etc']['select']['periodicita'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM periodicita_view ORDER BY giorni ASC'
    );

    // tendina schema di ripetizione ( vedi creazionePianificazione() in _src/_lib/_cron.utils.php )
    $ct['etc']['select']['schema_ripetizione'] = array(
        array( 'id' => 1, '__label__' => 'stesso giorno del mese' ),
        array( 'id' => 2, '__label__' => 'stesso giorno della settimana ( es. secondo martedì )' )
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
