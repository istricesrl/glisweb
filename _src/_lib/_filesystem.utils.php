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

        $encoding = mb_detect_encoding( $t );
        $t = $encoding ? @iconv( $encoding, 'UTF-8', $t ) : $t;

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

        $dom->loadHTML( '<?xml version="1.0" encoding="UTF-8"?>' . $hp . $bp . $t . $ba . $ha );
        $xpath = new DOMXPath( $dom );
        libxml_clear_errors();

        $doc = $dom->getElementsByTagName("html")->item(0);
        $src = $xpath->query(".//@src");

        foreach ( $src as $sr ) {
            if( substr( $sr->nodeValue, 0, 1 ) == '/' ) {
                $sr->nodeValue = $base . $sr->nodeValue;
            }
        }

        $output = @$dom->saveXML( $doc->documentElement );
        
        return $output;

    }
