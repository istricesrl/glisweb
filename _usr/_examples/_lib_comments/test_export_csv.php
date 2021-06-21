<?php

define( 'DIR_BASE', '/var/www/html/glisweb/' );

use phpDocumentor\Reflection\PseudoTypes\True_;

require '../../_src/_lib/_mysql.tools.php';
require '../../_src/_lib/_txt.tools.php';
require '../../_src/_lib/_log.tools.php';
require '../../_src/_lib/_log.utils.php';
require '../../_src/_lib/_timer.tools.php';
require '../../_src/_lib/_array.tools.php';
require '../../_src/_lib/_filesystem.tools.php';
require '../../_src/_lib/_csv.tools.php';

$cn = mysqli_init();

// riduco il tempo massimo di connessione per evitare rallentamenti
mysqli_options( $cn, MYSQLI_OPT_CONNECT_TIMEOUT, 3 );

// connessione
mysqli_real_connect(
    $cn,
    '127.0.0.1',
    'root',
    'new-password');

mysqli_select_db($cn, 'glisweb');

$q = "SELECT `Nome`,`Cognome` FROM `anagrafica`";

header('content-type: text/plain;');

$table = (mysqlQuery($cn, $q));

// passo la tabella di mysql tradotta in array e la traducco in formato csv
var_dump(array2csv($table));

$filename = 'usr/examples/file3.csv';

csvFile2array( $filename );

