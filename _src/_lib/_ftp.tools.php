<?php

    function ftpGetTransferTypeByFile( $f ) {

        fullpath( $f );

        if( isBinaryFile( $f ) ) {
            return FTP_BINARY;
        } else {
            return FTP_ASCII;
        }

    }
