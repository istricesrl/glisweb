<?php

    /**
     * libreria per l'interazione con Slack
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     *
     * @todo finire di implementare
     * @todo finire di documentare
     *
     */
    function slackTxtMsg( $c, $t ) {

        $r = restCall(
            'https://hooks.slack.com/services/'.$c['sa'].'/'.$c['sb'].'/'.$c['sc'],
            METHOD_POST,
            array( 'text' => $t ),
            MIME_APPLICATION_JSON,
            MIME_APPLICATION_JSON,
            $e
        );

        return $e;

    }
