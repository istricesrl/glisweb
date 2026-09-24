<?php

    /**
     * test delle cache
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // ...
    // print_r( getFbPageAccessToken( $_REQUEST['tk'] ) );
     print_r( getFbPageReviews( $cf['facebook']['profile']['pages']['OrchideaBeautyCarpi'] ) );
