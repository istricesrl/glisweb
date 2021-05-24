<?php


        $i = $_REQUEST['id'];
        print_r($i);
 

    $update = mysqlQuery( 
            $cf['mysql']['connection'], 
            'UPDATE documenti SET timestamp_chiusura = ? WHERE id = ?',
            array( 
                array( 's' => time() ), 
                array( 's' => $_REQUEST['id'] ) ) );

    $documento = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            'SELECT * FROM  documenti_view  WHERE id = ?',
            array( 
                array( 's' => $_REQUEST['id'] ) ) );

    print_r($documento);
    