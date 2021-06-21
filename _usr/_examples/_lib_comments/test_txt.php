<?php

require '../../_src/_lib/_txt.tools.php';
require '../../_src/_lib/_string.tools.php';

$p= "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
$c = 'funzione txt line ';
$t = "TITOLO";
$d= 'Altra string';
$columns = ['nome','cognome'];
$test_header = array('frutta');
$data = [[' Luigi','Verdi'], ['Giovanni','Pasquale']];
$test_array = array('apples', 'bananas', 'oranges', 'pears');

header('content-type: text/plain;');

(txt2fixed($columns, $d));

// ordina i dati in una tabella : 
// nome persona                  cognome persona                         
// -----------------------------------------------
// Mario                         Rossi                                   
// Luigi                         Bianchi   

echo txtTable(
    array( 'nome' => 30, 'cognome' => 40 ),
    array(
        array( 'nome' => 'Mario', 'cognome' => 'Rossi' ),
        array( 'nome' => 'Luigi', 'cognome' => 'Bianchi' )
    ),
    array( 'nome' => 'nome persona', 'cognome' => 'cognome persona' )
);

// titolo : maiuscola + linea + data e ora : 
// =========================================================[ 2021-06-01 17:46:23 ]
print_r(txtHeader($t));

 // manda a capo
txtLine($c);
print_r(txtLine($c));

// ordina il testo in paragrafo : 
print_r(txtText($p));

// tronca la lungezza del testo : 
print_r(justify($p));

// accorcia le due sting passate in parametro 
print_r(txt2fixed($t, $d));

// formata la variabile $p e la $d allo stesso formato
print_r(txtData($p,$d));

//stampa data e orario
print_r(txtDateTimeLine($p));

