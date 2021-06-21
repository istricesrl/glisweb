<?php

define( 'DIR_BASE', '/var/www/html/glisweb/' );

use phpDocumentor\Reflection\PseudoTypes\True_;

require '../../_src/_lib/_array.tools.php';

require '../../_src/_lib/_filesystem.tools.php';

require '../../_src/_lib/_csv.tools.php';

$s = "parole da trasformare in un array"; 
$c = ",";
$info = ["Mario","Luigi","Salvatore","Rino","Gabriele","Alessandro"];
$users = [['Mario Rossi', 'Italia'],['Christian Ronaldo', 'Brasile'],['Zinedine Zidane', 'Francia']];
$e = ["array","trasformare"];
$info = array("peter" => array("age" => 21, "gender" => "male"), "john"  => array("age" => 19, "gender" => "male"),"mary" => array("age" => 20,"gender" => "female"));
$diff_info = array("peter" => array("age" => 23, "gender" => "male"));
$an = [1,2,3,4,5,6];
$en = [1,4,5,6];
$str1 = "--";
$str2 = "  ";
$csvdata = array(
    array( "nome" => "mario", "cognome" => "rossi" ),
    array( "nome" => "giovanni", "cognome" => "verdi" )
);

// TEST LIBRERIE ARRAY

echo "test pagina <br>";

echo "0 . $s <br>";

string2array( $s, $c );

echo "1 . $s, $c <br>";

#trasforma una string in un array 

array2string($a, $c);

echo "2 . array2string($a, $c)<br>";

echo "3 . $a<br>";

echo "4 . $c<br>";


// torna un tipo presente nell'array : 
rksort($info);

echo "Echo : rksort($info)<br>";

print_r($info);

echo "1 <br>";

trimArray($an, 5);

print_r($an);

//stampa l'array : senza le differenze dell'array a rispetto all'array e

RemoveFromArray($an, $en);

print_r($an);

// scrive in minuscolo la string di un array

arrayLowercase($a);

print_r($a);

// definisce le colonne di un array 

array_column($a,$e);

print_r($a);

//  presenta le chiavi dell'array

arrayKeyValuesImplode($info, $str1, $str2);

print_r(arrayKeyValuesImplode($info, $str1, $str2));


// inserisce l'array "data" nell'array "arr" alla referenza "ref"

$ref = 'kb';
$arr = array( 'ka' => 'va', 'kb' => 'vb', 'kc' => 'vc' );
$data = array( 'XXX' => 'YYY' );

$res = arrayInsertAssoc($ref,$data,$arr);

print_r( $res );
