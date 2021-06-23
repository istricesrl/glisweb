<?php

if( isset( $_REQUEST[ 'documenti' ]['__comando__'] ) ){
    if( $_REQUEST[ 'documenti' ]['__comando__'] == 'CMD.TPL.0001'  ){

        $_REQUEST[ 'documenti' ]['id_tipologia'] = 1;
    
    } elseif( $_REQUEST[ 'documenti' ]['__comando__'] == 'CMD.TPL.0009'  ){
    
        $_REQUEST[ 'documenti' ]['id_tipologia'] = 9;
    
    }
}
