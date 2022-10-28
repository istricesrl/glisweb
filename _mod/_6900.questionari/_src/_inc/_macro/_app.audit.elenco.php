<?php

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

            $ct['etc']['audit'] = mysqlQuery(
                $cf['mysql']['connection'], 
                'SELECT a.*, i.__label__ as indirizzo from audit_view AS a '.
                'LEFT JOIN progetti AS p ON a.id_progetto = p.id '.
                'LEFT JOIN indirizzi_view AS i ON p.id_indirizzo = i.id '.
                'WHERE a.id_somministratore = ? AND a.data_audit = ?',
                array( array( 's' => $_SESSION['account']['id_anagrafica'] ), array( 's' => $_REQUEST['__d__'] ) )
            );

            // tendina progetti
            $ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
                $cf['memcache']['index'],
                $cf['memcache']['connection'],
                $cf['mysql']['connection'], 
                'SELECT id, __label__ FROM progetti_view' );
    
        }
    }


