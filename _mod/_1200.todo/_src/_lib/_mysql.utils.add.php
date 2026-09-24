<?php

    /**
     * aggiorna todo_view_static per un todo
     *
     * QUESTA FUNZIONE ERA VUOTA, E NON ERA INNOCUO ( fix 2026-09-15 ).
     *
     * Il corpo era commentato e non restava niente: ogni chiamata non faceva nulla. Chi la chiama
     * pero' c'e', ed e' il percorso normale di salvataggio di un todo:
     *
     *  - _todo.finally.php la chiama esplicitamente dopo il salvataggio dalla form;
     *  - mysqlInsertRow() la cerca per nome ( 'update' + CamelCase della statica ) e, trovandola,
     *    la chiama e scrive a log "aggiornata view statica todo per id #N".
     *
     * Il risultato era che todo_view_static NON veniva mai aggiornata salvando un todo, e il log
     * diceva di si'. Siccome ogni elenco legge la statica quando esiste ( getStaticViewExtension ),
     * il sintomo e' l'elenco dei todo che non mostra le modifiche appena fatte — esattamente il
     * guasto muto descritto in refreshStaticView(), dove sta scritto che era gia' costato incidenti.
     *
     * Il vecchio corpo commentato faceva `REPLACE INTO todo_view_static SELECT * FROM todo_view`,
     * che accoppia le colonne per POSIZIONE ed e' il motivo per cui era stato disattivato: bastava
     * una colonna di scarto fra vista e statica per farlo fallire. refreshStaticView() elenca i
     * campi e usa solo quelli presenti da entrambe le parti, quindi fa la stessa cosa senza quel
     * difetto — e riporta l'esito invece di ignorarlo.
     *
     * @param  mixed $id l'id del todo da riportare nella statica
     * @return bool      l'esito dell'aggiornamento
     */
    function updateTodoViewStatic( $id ) {

        global $cf;

        return refreshStaticView( $cf['mysql']['connection'], 'todo', $id );

    }
