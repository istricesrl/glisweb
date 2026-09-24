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
    echo path2url(
        '<style type="text/css">h1 {
            color: red;
            }
        </style>

        <h1>test</h1>
        
        <p>test</p>
        
        <p><img alt="" src="/var/contenuti/16446037289273283379649193113738.jpg" style="width: 720px; height: 540px;"></p>'
    );
