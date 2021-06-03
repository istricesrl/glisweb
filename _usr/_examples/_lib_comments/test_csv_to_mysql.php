<?php

require '../../_src/_lib/_mysql.tools.php';
require '../../_src/_lib/_txt.tools.php';

$cn = mysqli_init();

// riduco il tempo massimo di connessione per evitare rallentamenti
mysqli_options( $cn, MYSQLI_OPT_CONNECT_TIMEOUT, 3 );

// connessione,
mysqli_real_connect(
    $cn,
    '127.0.0.1',
    'root',
    'new-password');

var_dump($cn);
// primo parametro : CONESSIONE AL DB
mysqli_select_db($cn, 'glisweb');

// SECONDO PARAMETRO : QUERY
$q = "SELECT * FROM `anarafica`";
// TERZO PARAMETRO : NUMERO DI VALORI : + DI UNO = TRUE?
$p = 1;
// ULTIMO PARAMETRO : ARRAY CON I VALORI?
$e = array( "Nome" => "Mario");
// $lock = mysql_affected_rows();

mysqlQuery($cn, $q );