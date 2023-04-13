<?php

// Function to check response time
function pingIp($domain,$port='80'){
    $starttime = microtime(true);
    $file      = @fsockopen($domain, $port, $errno, $errstr, 10);
    $stoptime  = microtime(true);
    $status    = 0;

    if( ! $file ) {
        $status = -1;  // Site is down
        $status = false;
    } else {
        fclose($file);
        $status = ($stoptime - $starttime) * 1000;
        $status = floor($status);
        $status = true;
    }
    return $status;
}