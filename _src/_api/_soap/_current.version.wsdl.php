<?php

    header('Content-type: application/xml; charset=utf-8');

    $output = file_get_contents( './_current.version.wsdl' );

    $output = str_replace( '{{HTTP_HOST}}', $_SERVER['HTTP_HOST'], $output );

    echo $output;

    exit(0);
