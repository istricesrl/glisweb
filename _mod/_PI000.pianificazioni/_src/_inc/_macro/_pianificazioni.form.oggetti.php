<?php

    /**
     * macro del form pianificazioni, scheda oggetti creati
     *
     * Questa macro prepara la pagina pianificazioni.form.oggetti, l'elenco degli oggetti che la pianificazione ha creato:
     * le righe della tabella della sua entità ( vedi pianificazioniEntita() in
     * _mod/_PI000.pianificazioni/_src/_lib/_pianificazioni.utils.php ) con id_pianificazione uguale al suo id. Ha la forma
     * delle schede elenco dei moduli di nuova generazione ( per esempio la scheda pagamenti del form dei documenti,
     * _mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.pagamenti.php ), senza inserimento
     * perché gli oggetti li crea la pianificazione.
     *
     * Ogni riga apre il form dell'oggetto nel modulo che lo gestisce: per ogni entità le pagine di gestione sono in ordine
     * di preferenza, prima quella del modulo di nuova generazione e poi quella del modulo legacy, e si usa la prima
     * dichiarata, cioè di un modulo attivo. Se nessun modulo dell'entità è attivo l'elenco c'è lo stesso, senza link.
     *
     * -# tabella gestita
     * -# pagine di gestione degli oggetti
     * -# configurazione della vista
     * -# macro di default
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'pianificazioni';

    // entità della pianificazione
    $entita = pianificazioniEntita( $_REQUEST[ $ct['form']['table'] ]['entita'] ?? NULL );

    // pagine di gestione degli oggetti, in ordine di preferenza
    $pagine = array(
        'documenti'             => array( 'amministrazione.archivio.documenti.form', 'documenti.form' ),
        'todo'                  => array( 'todo.form', 'agenda.todo.form' ),
        'attivita'              => array( 'produzione.attivita.form', 'attivita.form' ),
        'rinnovi'               => array( 'rinnovi.contratti.form' ),
        'documenti_articoli'    => array( 'amministrazione.archivio.documenti.articoli.form', 'documenti.articoli.form' ),
        'pagamenti'             => array( 'amministrazione.archivio.documenti.pagamenti.form', 'pagamenti.form' )
    );

    // vista degli oggetti creati
    if( ! empty( $entita ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {

        // informazioni della vista
        $ct['view'] = array(
            'table' => $entita['tabella'],
            'open' => array(
                'table' => $entita['tabella']
            ),
            'cols' => array(
                'id' => '#',
                $entita['data'] => 'data',
                '__label__' => 'oggetto'
            ),
            'class' => array(
                'id' => 'd-none d-md-table-cell',
                $entita['data'] => 'no-wrap',
                '__label__' => 'text-start'
            ),
            '__restrict__' => array(
                'id_pianificazione' => array( 'EQ' => $_REQUEST[ $ct['form']['table'] ]['id'] )
            ),
            '__sort__' => array(
                $entita['data'] => 'DESC'
            )
        );

        // i rinnovi non hanno una vista, e quindi nemmeno __label__
        if( $entita['tabella'] == 'rinnovi' ) {
            $ct['view']['cols'] = array( 'id' => '#', 'data_inizio' => 'dal', 'data_fine' => 'al', 'codice' => 'codice' );
            $ct['view']['class'] = array( 'id' => 'd-none d-md-table-cell', 'data_inizio' => 'no-wrap', 'data_fine' => 'no-wrap', 'codice' => 'text-start' );
        }

        // pagina di gestione del primo modulo attivo
        foreach( $pagine[ $entita['tabella'] ] as $pagina ) {
            if( isset( $cf['contents']['pages'][ $pagina ] ) ) {
                $ct['view']['open']['page'] = $pagina;
                break;
            }
        }

        // macro di default
        require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
