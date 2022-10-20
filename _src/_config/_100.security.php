    <?php

    /**
     * 
     * @todo finire di documentare
     *
     * @file
     *
     */

    // intercettazione tentativi di SQL injection
    /*
    if( stripos( $_SERVER['QUERY_STRING'], 'SELECT' ) !== false ) {
        http_response_code( 400 );
        die('SQL injection failed');
        }
    
        if( stripos( $_SERVER['QUERY_STRING'], 'WHERE' ) !== false ) {
        http_response_code( 400 );
        die('SQL injection failed');
        }
    
        if( stripos( $_SERVER['QUERY_STRING'], 'SLEEP' ) !== false ) {
        http_response_code( 400 );
        die('SQL injection failed');
        }
    
        if( stripos( $_SERVER['QUERY_STRING'], 'script' ) !== false ) {
        http_response_code( 400 );
        die('SQL injection failed');
        }
    
    */
    