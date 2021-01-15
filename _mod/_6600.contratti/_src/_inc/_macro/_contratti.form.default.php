<?php

    // tabella gestita
    $ct['form']['table'] = 'contratti';

    // leggo il turno massimo inserito
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        $tm = mysqlSelectValue( 
            $cf['mysql']['connection'],        
            'SELECT max(turno) from orari_contratti WHERE id_contratto = ?',
            array( array( 's' => $_REQUEST['contratti']['id'] ) )
        );
    }

    // se non sono presenti orari, quindi turni, rimuovo tutte le tab tranne la prima
    if( empty( $tm) ){
        foreach( range( 2, 9 ) as $i ){
            $ct['page']['etc']['tabs'] = array_diff(
                $ct['page']['etc']['tabs'],
                ['contratti.form.orari.' . $i] );
        }
    }
    // se sono presenti meno di 8 turni, rimuovo le tab successive tranne la prima (es. 3 turni, nascondo dalla 5 alla 9)
    elseif( $tm < 8 ){
        foreach( range( $tm + 2, 9 ) as $i ){
            $ct['page']['etc']['tabs'] = array_diff(
                $ct['page']['etc']['tabs'],
                ['contratti.form.orari.' . $i] );
        }
    }




