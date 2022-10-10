<?php

    // require '../../../../../_src/_config.php';

    if( isset( $_REQUEST['id_audit'] ) ){

        $ct['etc']['audit'] = mysqlSelectRow(
            $cf['mysql']['connection'], 
            'SELECT a.*, i.__label__ as indirizzo from audit_view AS a '.
            'LEFT JOIN progetti AS p ON a.id_progetto = p.id '.
            'LEFT JOIN indirizzi_view AS i ON p.id_indirizzo = i.id '.
            'WHERE a.id = ?',
            array( array( 's' => $_REQUEST['id_audit'] ) )
        );

        // elenco dei controlli
        $ct['etc']['controlli']['progetto'] = mysqlQuery(
            $cf['mysql']['connection'], 
            'SELECT c.*, q.nome as questionario '.
            'FROM controlli as c '.
            'LEFT JOIN questionari_view AS q ON c.id_questionario = q.id '.
            'WHERE c.id_audit = ? AND c.id_anagrafica IS NULL',
            array( array( 's' => $_REQUEST['id_audit'] ) )
        );

        $ct['etc']['controlli']['anagrafica'] = mysqlQuery(
            $cf['mysql']['connection'], 
            'SELECT c.*, q.nome as questionario '.
            'FROM controlli as c '.
            'LEFT JOIN questionari_view AS q ON c.id_questionario = q.id '.
            'WHERE c.id_audit = ? AND c.id_anagrafica IS NOT NULL GROUP BY q.id',
            array( array( 's' => $_REQUEST['id_audit'] ) )
        );

        //print_r( $ct['etc']['controlli']['progetto'] );
        //print_r( $ct['etc']['controlli']['anagrafica'] );
    }



    require DIR_SRC_INC_MACRO . '_default.tools.php';
