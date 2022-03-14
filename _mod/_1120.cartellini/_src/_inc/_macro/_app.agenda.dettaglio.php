<?php

    if( isset( $_REQUEST['attivita'] ) ){

        $ct['etc']['attivita'] = mysqlSelectRow(
            $cf['mysql']['connection'], 
            'SELECT attivita_view.*, tipologie_attivita.nome AS tipologia, todo.id_responsabile , concat_ws(\' \', coalesce(anagrafica.cognome, \'\'), coalesce(anagrafica.nome, \'\') ) AS responsabile, group_concat( DISTINCT telefoni.numero SEPARATOR \' | \' ) AS telefoni FROM attivita_view '.
            'LEFT JOIN todo ON todo.id = attivita_view.id_todo '.
            'LEFT JOIN anagrafica ON anagrafica.id = todo.id_responsabile '.
            'LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id '.
            'LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita_view.id_tipologia '.
            'WHERE attivita_view.id = ?  GROUP BY attivita_view.id ORDER BY attivita_view.ora_inizio_programmazione',
            array( array( 's' => $_REQUEST['attivita'] ) )
        );

        $ct['etc']['tel']= mysqlSelectColumn(
            'numero',
            $cf['mysql']['connection'],
            'SELECT numero FROM telefoni WHERe id_anagrafica = ?',
            array( array( 's' => $ct['etc']['attivita']['id_responsabile'] ) )
        );

        if( !empty($ct['etc']['attivita']['ora_inizio']) ){
            $now = new DateTime();
            $future_date = new DateTime($ct['etc']['attivita']['data_attivita'].' '.$ct['etc']['attivita']['ora_inizio']);
            
            $interval = $future_date->diff($now);
            
            $ct['etc']['ore'] = ($interval->format("%a") * 24) + $interval->format("%h"). " ore e ". $interval->format(" %i minuti ");
            
            
        }
    }



    require DIR_SRC_INC_MACRO . '_default.tools.php';
