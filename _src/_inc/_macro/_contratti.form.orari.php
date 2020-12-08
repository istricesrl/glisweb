<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */


	// tabella gestita
	$ct['form']['table'] = 'contratti';
	
    // tendina per i costi contratto
    if( isset( $_REQUEST['contratti']['id'] ) ) {
        $ct['etc']['select']['costi_contratti'] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM costi_contratti_view WHERE id_contratto = ?',
            array( array( 's' => $_REQUEST['contratti']['id'] ) )
        );
    }
    
    // tendina giorni
    $ct['etc']['select']['giorno'] = array( 
        array( 'id' => '1', '__label__' => 'lunedi' ),
        array( 'id' => '2', '__label__' => 'martedi' ),
        array( 'id' => '3', '__label__' => 'mercoledi' ),
        array( 'id' => '4', '__label__' => 'giovedi' ),
        array( 'id' => '5', '__label__' => 'venerdi' ),
        array( 'id' => '6', '__label__' => 'sabato' ),
        array( 'id' => '0', '__label__' => 'domenica' )
    );
    
    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

?>