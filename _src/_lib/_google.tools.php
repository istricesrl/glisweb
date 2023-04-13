<?php

    /**
     * vedi
     * https://github.com/googleapis/google-api-php-client
     * 
     * 
     * 
     * 
     */

    /**
     * 
     */
    function googleGetAccessToken( $app ) {
/*
        // chiamata
        $result = restCall(
            'https://accounts.google.com/o/oauth2/v2/auth',
            METHOD_GET,
            array(
                'client_id' => $app['id'],
                'client_secret' => $app['secret'],
                'auth_code' => '',
                'grant_type' => 'authorization_code',
                'response_type' => 'application/json'
            ),
            'query',
            MIME_APPLICATION_JSON,
            $status,
            array(),
            NULL,
            NULL,
            $error
        );
*/
        print_r( $result );

    }

    /**
     * set CLIENT_ID=your_client_id
     * set CLIENT_SECRET=your_client_secret
     * set SCOPE=https://www.googleapis.com/auth/business.manage
     * set ENDPOINT=https://accounts.google.com/o/oauth2/v2/auth
     * set REDIRECT_URI=https://developers.google.com/oauthplayground
     * 
     * set URL="%ENDPOINT%?client_id=%CLIENT_ID%&response_type=code&scope=%SCOPE%&access_type=offline&redirect_uri=%REDIRECT_URI%"
     * 
     * @REM start iexplore %URL%
     * @REM start microsoft-edge:%URL%
     * start chrome %URL%
     * 
     * set /p AUTH_CODE=""
     * 
     * curl ^
     * --data client_id=%CLIENT_ID% ^
     * --data client_secret=%CLIENT_SECRET% ^
     * --data code=%AUTH_CODE% ^
     * --data redirect_uri=%REDIRECT_URI% ^
     * --data grant_type=authorization_code ^
     * https://www.googleapis.com/oauth2/v4/token
     * 
     * 
     */