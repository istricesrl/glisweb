<?php

    if( !isset($_REQUEST['__d__'])){
        $_REQUEST['__d__'] = date("Y-m-d");
    }

    if( isset( $_SESSION['account']['id_anagrafica'] ) && ! empty( $_SESSION['account']['id_anagrafica'] ) ){

        $ct['etc']['attivita'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT attivita_view.*, concat_ws(\' \', coalesce(anagrafica.cognome, \'\'), coalesce(anagrafica.nome, \'\') ) AS responsabile, group_concat( DISTINCT telefoni.numero SEPARATOR \' | \' ) AS telefoni FROM attivita_view '.
            'LEFT JOIN todo ON todo.id = attivita_view.id_todo '.
            'LEFT JOIN anagrafica ON anagrafica.id = todo.id_responsabile '.
            'LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id '.
            'WHERE attivita_view.id_anagrafica = ? AND attivita_view.data_programmazione = ? GROUP BY attivita_view.id ORDER BY attivita_view.ora_inizio_programmazione',
            array( array( 's' => $_SESSION['account']['id_anagrafica'] ), array( 's' => $_REQUEST['__d__'] ) )
        );

        

    }

