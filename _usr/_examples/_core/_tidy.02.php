<?php

    // https://api.html-tidy.org/tidy/quickref_5.6.0.html

    ob_start();

    echo "<!-- a html document -->";
    echo "<html><head><title></title></head><body>a html document<!-- commento --></body></html>";

    $html = ob_get_clean();

    $config = array(
            'indent'         => true,
            'output-html'    => true,
            'wrap'           => 0
            );

    $tidy = new tidy;
    $tidy->parseString( $html, $config, 'utf8' );
    $tidy->cleanRepair();

    echo $tidy . PHP_EOL;

    echo "<!-- a html document -->";
