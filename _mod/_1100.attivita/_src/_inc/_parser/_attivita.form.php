<?php

// inserimento id matricola se viene scannerizzato il barcode
if( isset( $_REQUEST[ 'attivita' ]['__matricola__'] ) ){

        $_REQUEST[ 'attivita' ]['id_matricola'] =  mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM matricole_view WHERE __label__ = ?', array( array( 's' => $_REQUEST['attivita']['__matricola__'] ) )
        );
    
}