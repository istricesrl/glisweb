<?php

// tabella della vista
$ct['view']['table'] = 'turni';

// id della vista
$ct['view']['id'] = md5( $ct['view']['table'] );

// tendina mesi
foreach( range( 1, 12 ) as $mese ) {
    $ct['etc']['select']['mesi'][ $mese ] =  int2month( $mese ) ;
}

// tendina anni
foreach( range( date( 'Y' ) - 2,  date( 'Y' ) ) as $y ) {
    $ct['etc']['select']['anni'][ $y ] = $y ;
}

// tendina contratti
$ct['etc']['select']['contratti'] = mysqlQuery(
    $cf['mysql']['connection'],
    'SELECT id, __label__ FROM contratti_view'
);


$nomigiorni = array(
    '1' => 'L',
    '2' => 'M',
    '3' => 'M',
    '4' => 'G',
    '5' => 'V',
    '6' => 'S',
    '7' => 'D'
);

// preset filtri custom per mese e anno
if( ! isset( $_REQUEST['__turni__']['mese'] ) && ! isset( $_REQUEST['__turni__']['anno'] ) ) {
    $_REQUEST['__turni__']['mese'] = date('m');
    $_REQUEST['__turni__']['anno'] = date('Y');
}

$giorni = array();
$mese = intval( $_REQUEST['__turni__']['mese'] );
$anno = intval( $_REQUEST['__turni__']['anno'] );


// array delle festività
$festivi = array(
    '01/01', 	// Capodanno
    '06/01',  	// Epifania
    date("d/m", easter_date( $anno ) ),		// Pasqua calcolata per l'anno corrente
    date("d/m", strtotime( date("Y-m-d", easter_date( $anno ) ) . '+ 1 days') ),	// Pasquetta calcolata per l'anno corrente
    '25/04',  	// Liberazione
    '01/05',  	// Festa Lavoratori
    '02/06',  	// Festa Repubblica
    '15/08',  	// Ferragosto
    '01/11',  	// Tutti i santi
    '08/12',  	// Immacolata
    '25/12',  	// Natale
    '26/12' 	// Santo Stefano
);

// costruisco l'elenco giorni
$giorni = array();

for( $d=1; $d<=31; $d++ )
{
    $time=mktime(12, 0, 0, $mese, $d, $anno);          
    if (date('m', $time) == $mese){   
        $giorni[] = intval( date('d', $time) );
    }
}

// se ho un contratto in request leggo i turni corrispondenti
if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_contratto']['EQ'] ) ){

    foreach( $giorni as $giorno ){
        // giorno 
        $ct['etc']['giorni'][ $giorno ]['giorno'] = $giorno;
    
        $ct['etc']['giorni'][ $giorno ]['data'] = date( 'Y-m-d', strtotime("$anno-$mese-$giorno") );
    
        // numero da 1 a 7, se la funzione date restituisce 0 (domenica) setto 7 per uniformità con i giorni degli orari_contratti
        $ct['etc']['giorni'][ $giorno ]['numero'] = ( date( 'w', strtotime("$anno-$mese-$giorno") ) == 0 ) ? '7' : date( 'w', strtotime("$anno-$mese-$giorno") );
    
        // nome del giorno (lun, mar, mer, ...)
        $ct['etc']['giorni'][ $giorno ]['nome'] = $nomigiorni[ $ct['etc']['giorni'][ $giorno ]['numero'] ];
    
        // controllo se è festivo
        if(  $ct['etc']['giorni'][ $giorno ]['numero'] == 7 || in_array( date( 'd/m', strtotime("$anno-$mese-$giorno") ), $festivi ) ){
                $ct['etc']['giorni'][ $giorno ]['festivo'] = 1;
        }

        // leggo l'elenco dei turni inseriti per la data corrente (questo include eventuali errori)
        $elenco_turni = mysqlQuery( 
            $cf['mysql']['connection'],
            'SELECT turno FROM turni WHERE id_contratto = ? AND data_inizio <= ? AND data_fine >= ?',
            array(
                array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_contratto']['EQ'] ),
                array( 's' => $ct['etc']['giorni'][ $giorno ]['data'] ),
                array( 's' => $ct['etc']['giorni'][ $giorno ]['data'] )
            )
        );

        if( !empty( $elenco_turni ) ){
            foreach ( $elenco_turni as $t ){
                $ct['etc']['giorni'][ $giorno ]['turni'][ $t['turno'] ] = $t['turno'];
            }
        }
        else{
            $ct['etc']['giorni'][ $giorno ]['turni'][ 1 ] = 1;
        }

    }


    // leggo l'elenco degli orari previsti per i vari turni e costruisco l'array dei turni
    $orari_contratti = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT * FROM orari_contratti WHERE id_contratto = ? AND se_lavoro = 1 ORDER BY turno, id_giorno',
        array( array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_contratto']['EQ'] ) )
    );

    foreach( $orari_contratti as $o ){
        $ct['etc']['turni'][ $o['turno'] ][] = array( 
            'giorno' => $nomigiorni[ $o['id_giorno'] ],
            'ora_inizio' => $o['ora_inizio'],
            'ora_fine' => $o['ora_fine']
        );
    }

    $ct['etc']['orari'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT * FROM orari_contratti WHERE id_contratto = ? AND se_lavoro = 1 ORDER BY turno, id_giorno',
        array( array( 's' => $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_contratto']['EQ'] ) )
    );

}






// modal orari turno
$ct['page']['contents']['metro']['orari'][] = array(
    'modal' => array( 'id' => 'orari_turno', 'include' => 'inc/turni.schema.modal.orari.html' )
);

// gestione default
require DIR_SRC_INC_MACRO . '_default.tools.php';
