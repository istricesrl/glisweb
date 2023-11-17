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

        $dom = new DOMDocument;  
        libxml_use_internal_errors(true);
        
        $dom->loadHTML( $t ); 
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
        
        return $output;

    }
