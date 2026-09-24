<?php

    /**
     * server e profili Slack
     *
     *
     *
     *
     *
     * https://api.slack.com/apps/
     *
     *
     * TODO documentare
     *
     *
     */

    /**
     * definizione dei server
     * ======================
     * 
     * 
     */

    // server disponibili
    $cf['slack']['servers']                     = array();

    /**
     * definizione dei profili
     * =======================
     * 
     * 
     */

    // profili di funzionamento
    $cf['slack']['profiles'][ DEVELOPEMENT ]    =
    $cf['slack']['profiles'][ TESTING ]         =
    $cf['slack']['profiles'][ PRODUCTION ]      = NULL;
