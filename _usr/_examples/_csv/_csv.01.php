<?php

    /**
     * test delle funzioni del filesystem
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

    // esempio
    print_r( csvFile2array( 'tmp/upload/csv/iscritti/iscritti.csv') );
