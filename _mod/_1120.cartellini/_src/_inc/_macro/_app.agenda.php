<?php
 //$_SESSION['account']['id_anagrafica'] =1;

    if( !isset($_REQUEST['__d__'])){

        if( isset( $_SESSION['__data_web__']) ){
            $_REQUEST['__d__'] = $_SESSION['__data_web__'];
        } else {
            $_REQUEST['__d__'] = date("Y-m-d");
        }
        
    }

    if( isset($_REQUEST['__d__']) ){

        $_SESSION['__data_web__'] = $_REQUEST['__d__'];

        if( isset( $_SESSION['account']['id_anagrafica'] ) && ! empty( $_SESSION['account']['id_anagrafica'] ) ){

            $ct['etc']['attivita'] = mysqlQuery(
              //  $cf['memcache']['index'],
              //  $cf['memcache']['connection'],
                $cf['mysql']['connection'], 
                'SELECT attivita_view_static.*, concat_ws(\' \', coalesce(anagrafica.cognome, \'\'), coalesce(anagrafica.nome, \'\') ) AS responsabile, group_concat( DISTINCT telefoni.numero SEPARATOR \' | \' ) AS telefoni FROM attivita_view_static '.
                'LEFT JOIN todo ON todo.id = attivita_view_static.id_todo '.
                'LEFT JOIN anagrafica ON anagrafica.id = todo.id_responsabile '.
                'LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id '.
                'WHERE attivita_view_static.id_anagrafica = ? AND attivita_view_static.data_programmazione = ? GROUP BY attivita_view_static.id ORDER BY attivita_view_static.ora_inizio_programmazione',
                array( array( 's' => $_SESSION['account']['id_anagrafica'] ), array( 's' => $_REQUEST['__d__'] ) )
            );
    
        }
    }


