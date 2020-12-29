<?php

if( isset( $_REQUEST['__cartellini__'] ) ){
    // tabella della vista
    $ct['view']['table'] = 'attivita';

    // id della vista
    if( ! isset( $ct['view']['id'] ) ) {
        $ct['view']['id'] = md5(
        $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
        );
    }
        
    writeToFile('chiamata controller cartellini' . PHP_EOL, 'var/log/cartellini.log');

    if( isset( $_REQUEST['__cartellini__'] ) && is_array( $_REQUEST['__cartellini__'] ) 
        && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] ) 
        && isset(  $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) 
        && isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) 
    ) {

        appendToFile('mese: ' . $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] . ', anno: ' .  $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] . ', operatore: ' . $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] . PHP_EOL, 'var/log/cartellini.log');
        appendToFile( print_r( $_REQUEST['__cartellini__'], true ) . PHP_EOL, 'var/log/cartellini.log');

        
        foreach( $_REQUEST['__cartellini__'] as $k => $v ){

            // se ho un orario valido
            if( $v > 0 ){
                $s = explode("_",$k);

                $giorno = $s[0];
                $id_tipologia = $s[1];
                $mese = $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'];
                $anno =  $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'];
                $data = $anno . '/' . $mese . '/' . $giorno;

                appendToFile('data: ' . $data . ', id_tipologia: ' . $id_tipologia . ', ore: ' . $v . PHP_EOL, 'var/log/cartellini.log');
        
                mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO attivita (data, id_anagrafica, id_tipologia, ore, nome,  id_account_inserimento, timestamp_inserimento ) VALUES( ?, ?, ?, ?, ?, ?, ? )',
                    array( 
                        array( 's' =>  $data ),
                        array( 's' =>  $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ),
                        array( 's' =>  $id_tipologia ),
                        array( 's' =>  str_replace( ",", ".", $v ) ),
                        array( 's' => 'attività del '.$data),
                        array( 's' => ( isset( $_SESSION['account']['id']) && is_numeric($_SESSION['account']['id']) ?  $_SESSION['account']['id'] : NULL ) ),
                        array( 's' => time() )
                    )
                );
            }
        }

    }
}