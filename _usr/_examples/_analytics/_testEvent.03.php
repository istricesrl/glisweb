<?php

    require '../../../_src/_config.php';

    $payload = array(
        'client_id' => $cf['session']['id'],
        'events' => array(
            array(
                'name' => 'test_event_03',
                'params' => array(
                    'test_param' => 'bogus'
                )
            )
        )
    );

    ga4event(
        $cf['google']['profile']['analytics']['ua'],
        $cf['google']['profile']['analytics']['mp']['secret'],
        $payload
    );
