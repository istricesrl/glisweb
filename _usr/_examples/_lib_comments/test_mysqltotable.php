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

mysqli_real_connect(
    $cn,
    '127.0.0.1',
    'root',
    'new-password');

mysqli_select_db($cn, 'glisweb');

$q = "SELECT `Nome`,`Cognome` FROM `anagrafica`";

header('content-type: text/plain;');

// presenta i dati di mysql in una tabella
echo txtTable(
    // imposto l'intestazione e la sua dimensione
    array( 'Nome' => 30, 'Cognome' => 40 ),
    // trasforma la query in un array passandoli la connessione e la query
    mysqlQuery( $cn, $q ),
    // rinomino l'intestazione
    array( 'Nome' => 'nome persona', 'Cognome' => 'cognome persona' )
);

