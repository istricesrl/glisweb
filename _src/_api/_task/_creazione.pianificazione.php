<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'inizio creazione pianificazione', 'pianificazione', LOG_ERR );

    if( isset($_REQUEST) && !empty($_REQUEST['__data__'])  ){

        $status['__status__'] = 'OK';
        //if ( empty($_REQUEST['datafine']) || $_REQUEST['datafine'] === NULL ){ $_REQUEST['datafine']= date('Y-m-d', strtotime($_REQUEST['data'].' +'.$_REQUEST['cad'] * $_REQUEST['nr'].' days' )); }
        //print_r($_REQUEST);


    /*     
        $number = ['first', 'second', 'third', 'fourth','fifth','sixth'];
        $days = ['Monday', 'Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday' ];
  


$data = $_REQUEST['data'];
$cadenza = 1;
$n_g = numOfDayInWeek($data, $days[ date('N', strtotime($data)) - 1 ]);
$data_fine = date('Y-m-d', strtotime($data. ' + '.$cadenza * 5 .' months -1 day'));
$data_temp = date("Y-m-d", strtotime("+ ".$cadenza." month", strtotime($data)));
                    $data_temp = date(date('Y',strtotime($data_temp))."-".date('m',strtotime($data_temp))."-01");
                    $data_temp = date("Y-m-d", strtotime($number[ $n_g -1 ]." ".$days[ date('N', strtotime($data))-1 ], strtotime($data_temp." -1 day")));
                    echo($data_temp);
                    echo "<br>";
                    if( date('m', strtotime($data_temp)) != ((date('m',  strtotime($data)) + $cadenza) % 12 ) ){
                        echo "no <br>";
                        echo $days[ date('N', strtotime($data))-1 ]."<br>"; 
                        $data_temp = date("Y-m-d", strtotime("last ".$days[ date('N', strtotime($data))-1 ], strtotime($data_temp)));   
                    }
echo($data_temp);
die();

echo($number[ $n_g -1]." ".$days[ date('N', strtotime($data))-1 ]);

$data_temp = date("Y-m-d", strtotime("+ ".$cadenza." month", strtotime($data)));
$data_temp = date(date('Y',strtotime($data_temp))."-".date('m',strtotime($data_temp))."-01");
$data_temp = date("Y-m-d", strtotime($number[ $n_g -1]." ".$days[ date('N', strtotime($data))-1 ], strtotime($data_temp." -1 day")));
echo($data_temp."<br>");
  die(); 
 */
      
        $restult = creazionePianificazioneTask( $cf['mysql']['connection'], $_REQUEST['__data__'], $_REQUEST['__p__'],$_REQUEST['__cad__'], $_REQUEST['__datafine__'], $_REQUEST['__nr__'],$_REQUEST['__gs__'],$_REQUEST['__rm__'],$_REQUEST['__ra__']);
    
        if( $restult ){
            $status['__status__'] = 'creazione pianificazione completata';
        } else {
            $status['__status__'] = 'creazione pianificazione NON completata: controllare i dati e la connessione';
        }

    } else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
