<?php

    function path2url( $t, $s = 1, $m = NULL, $d = NULL ) {

        global $cf;

        $base = trim( $cf['sites'][ $s ]['url'], '/' );

        if( ! empty( $m ) ) {
            $base .= '/mailing/' . $m;
            if( ! empty( $d ) ) {
                $base .= '/' . $d;
            }
        }

        // var_dump( $t );

        $encoding = mb_detect_encoding( $t, 'auto' );

        var_dump( $encoding );

        if( $encoding != false ) {

            if( $encoding != 'UTF-8' ) {

                logWrite( 'encoding non UTF-8 per ' . $t, 'details/localization', LOG_ERR );

                $utf8t = iconv( $encoding, 'UTF-8', $t );

                if( ! empty( $utf8t ) ) {
                    $t = $utf8t;
                } else {
                    logWrite( 'errore di iconv() da ' . $encoding . ' a UTF-8 per ' . $t, 'details/localization', LOG_ERR );
                }

            }

        } else {
            logWrite( 'encoding non trovato per ' . $t, 'details/localization', LOG_ERR );
        }

#        $t = ( $encoding === false ) ? $t : ( $encoding != 'UTF-8' ) ? iconv( $encoding, 'UTF-8', $t ) : $t;

        var_dump( $t );

        $dom = new DOMDocument( '1.0', 'utf-8' );
        libxml_use_internal_errors( true );

        if( strpos( $t, '<html' ) === false ) {
            $hp = '<html>';
            $ha = '</html>';
        } else {
            $hp = $ha = '';
        }

        if( strpos( $t, '<body' ) === false ) {
            $bp = '<body>';
            $ba = '</body>';
        } else {
            $bp = $ba = '';
        }

        $etc = $hp . $bp . $t . $ba . $ha;
        $dom->loadHTML( '<?xml version="1.0" encoding="UTF-8"?>' . $etc );
        $xpath = new DOMXPath( $dom );
        libxml_clear_errors();

        $doc = $dom->getElementsByTagName("html")->item(0);
        $src = $xpath->query(".//@src");

        foreach ( $src as $sr ) {
            if( substr( $sr->nodeValue, 0, 1 ) == '/' ) {
                $sr->nodeValue = $base . $sr->nodeValue;
            }
        }

        $output = $dom->saveXML( $doc->documentElement );

        // var_dump( $output );

        return $output;

    }
