<?php

// https://api.html-tidy.org/tidy/quickref_5.6.0.html

ob_start();

echo "<html>a html document</html>";

$html = ob_get_clean();

// Specify configuration
$config = array(
           'indent'         => true,
           'output-html'    => true,
           'wrap'           => 0
        );

// Tidy
$tidy = new tidy;
$tidy->parseString( $html, $config, 'utf8' );
$tidy->cleanRepair();

// Output
echo $tidy;
