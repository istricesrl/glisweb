<?php

    // https://api.html-tidy.org/tidy/quickref_5.6.0.html

    ob_start();

    echo "<!DOCTYPE html>";
    echo "<!-- a html document -->";
    echo "<html><!-- commento --><head><title></title><!-- commento --></head><!-- commento -->";
    echo "<body>a html document<!-- commento --></body></html>";

    $html = ob_get_clean();

    $config = array(
            'indent'         => true,
            'output-html'    => true,
            'vertical-space' => true,
            'wrap'           => 0
            );

    $tidy = new tidy;
    $tidy->parseString( $html, $config, 'utf8' );
    $tidy->cleanRepair();

    echo $tidy . PHP_EOL;

    echo "<!-- a html document -->";
