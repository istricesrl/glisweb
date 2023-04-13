<?php

    require '../../../_src/_config.php';

    $payload = array(
        'client_id' => $cf['session']['id'],
        'events' => array(
            array(
                'name' => 'test_event',
                'params' => array(
                    'page_location' => '/bogus'
                )
            )
        )
    );

    $response = restCall(
        GA4_MEASUREMENT_URL . GA4_MEASUREMENT_ENDPOINT_COLLECT . '?measurement_id='.$cf['google']['profile']['analytics']['ua'].'&api_secret='.$cf['google']['profile']['analytics']['mp']['secret'],
        METHOD_POST,
        $payload,
        MIME_APPLICATION_JSON,
        NULL,
        $status
    );

    header( 'Content-type: text/plain' );
    var_dump( $response );
    echo print_r( $status, true ) . PHP_EOL;
    // echo GA4_MEASUREMENT_URL . PHP_EOL;
