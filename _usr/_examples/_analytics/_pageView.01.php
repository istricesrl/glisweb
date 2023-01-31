<?php

    require '../../../_src/_config.php';

    /*
        $ch = curl_init();

        curl_setopt( $ch, CURLOPT_URL, 'www.google-analytics.com/collect' );
        curl_setopt( $ch, CURLOPT_POST, 1 );
        curl_setopt( $ch, CURLOPT_POSTFIELDS, 
        http_build_query( array(
            'v' => '1',
            't' => 'pageview',
            'dp' => '/foobar',
            'tid' => $cf['google']['analytics']['ua'],
            'cid' => '696969'
        ) )
        );

        curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );

        $rs = curl_exec( $ch );

        curl_close( $ch );

    */

    $payload = array(
        'client_id' => $cf['session']['id'],
        'events' => array(
            array(
                'name' => 'page_view',
                'params' => array(
                    'page_location' => '/bogus',
                    'page_title' => 'Bogus!'
                )
            )
        )
    );

    restCall(
        GA4_MEASUREMENT_URL . 'mp/collect?measurement_id='.$cf['google']['profile']['analytics']['ua'].'&api_secret='.$cf['google']['profile']['analytics']['mp']['secret'],
        METHOD_POST,
        $payload,
        MIME_APPLICATION_JSON,
        MIME_APPLICATION_JSON,
        $status
    );

    header( 'Content-type: text/plain' );
    print_r( $status );
