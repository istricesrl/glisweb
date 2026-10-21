<?php

    /**
     * 
     * 
     * 
     * https://platform.openai.com/docs/api-reference/making-requests
     * 
     * 
     */

    require '../../../_src/_config.php';

    $payload = array(
        "model" => "text-davinci-003",
        "prompt" => "say this is a test",
        "temperature" => 0,
        "max_tokens" => 7
    );

    $answer = restCall(
        "https://api.openai.com/v1/completions",
        METHOD_POST,
        $payload,
        MIME_APPLICATION_JSON,
        MIME_APPLICATION_JSON,
        $status,
        array(),
        NULL,
        NULL,
        $error,
        $cf['openai']['profile']['api']['secret']
    );

    header( 'Content-type: text/plain' );
    print_r( $status );
    print_r( $answer );
    print_r( $error );
