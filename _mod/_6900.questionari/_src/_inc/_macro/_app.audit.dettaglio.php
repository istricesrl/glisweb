<?php

    // tabella gestita
	$ct['form']['table'] = 'audit';

    if( isset( $_REQUEST[$ct['form']['table']]['id'] ) ){

        $ct['etc']['audit'] = mysqlSelectRow(
            $cf['mysql']['connection'], 
            'SELECT a.*, i.__label__ as indirizzo from audit_view AS a '.
            'LEFT JOIN progetti AS p ON a.id_progetto = p.id '.
            'LEFT JOIN indirizzi_view AS i ON p.id_indirizzo = i.id '.
            'WHERE a.id = ?',
            array( array( 's' => $_REQUEST[$ct['form']['table']]['id'] ) )
        );

        // elenco dei controlli
        $ct['etc']['controlli']['progetto'] = mysqlQuery(
            $cf['mysql']['connection'], 
            'SELECT c.*, q.nome as questionario '.
            'FROM controlli as c '.
            'LEFT JOIN questionari_view AS q ON c.id_questionario = q.id '.
            'WHERE c.id_audit = ? AND c.id_anagrafica IS NULL',
            array( array( 's' => $_REQUEST[$ct['form']['table']]['id'] ) )
        );

        $ct['etc']['controlli']['anagrafica'] = mysqlQuery(
            $cf['mysql']['connection'], 
            'SELECT c.*, q.nome as questionario, min( IFNULL( timestamp_completamento, 0 ) ) as completamento '.
            'FROM controlli as c '.
            'LEFT JOIN questionari_view AS q ON c.id_questionario = q.id '.
            'WHERE c.id_audit = ? AND c.id_anagrafica IS NOT NULL GROUP BY q.id',
            array( array( 's' => $_REQUEST[$ct['form']['table']]['id'] ) )
        );

        // questionari
        $ct['etc']['select']['questionari'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM questionari_view' );

        // anagrafiche
        $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );

        #print_r( $ct['etc']['controlli']['progetto'] );
        #print_r( $ct['etc']['controlli']['anagrafica'] );
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';
