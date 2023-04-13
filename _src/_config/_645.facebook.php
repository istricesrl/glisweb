<?php

    /**
     * server e profili facebook
     *
     *
     *
     * pixel di Fb -> https://www.facebook.com/business/help/952192354843755?id=1205376682832142
     * eventi Fb -> https://www.facebook.com/business/help/402791146561655?id=1205376682832142
     * conversioni Fb -> https://developers.facebook.com/docs/marketing-api/conversions-api/
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // link al profilo corrente
	$cf['facebook']['profile']			= &$cf['facebook']['profiles'][ $cf['site']['status'] ];
