<?php

/**
 *
 *
 *
 *
 * @todo documentare
 * @todo spiegare bene la logica con cui vengono uniti i dati, quali prevalgono, eccetera
 * @todo fornire queste informazioni anche nell'interfaccia grafica quando l'utente deve cliccare
 *
 * @file
 *
 */

// inclusione del framework
if (!defined('CRON_RUNNING')) {
    require '../../_config.php';
}

// inizializzo l'array del risultato
$status = array();

// ...
if (isset($_REQUEST['src'])) {

    // ...
    if (isset($_REQUEST['dst'])) {

        // ...
        $status = unisciAnagrafiche(
            $_REQUEST['src'],
            $_REQUEST['dst']
        );
    }
} else {
    /*
        // ...
        $status['aggiornare'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT id, partita_iva, codice_fiscale 
            FROM anagrafica 
            WHERE (
                ( codice_fiscale != "" AND codice_fiscale IS NOT NULL ) 
                OR ( partita_iva != "" AND partita_iva IS NOT NULL ) 
            )
            ORDER BY timestamp_aggiornamento ASC LIMIT 1'
        );
*/
    // ...
    $status['aggiornare'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT anagrafica.id, anagrafica.codice_fiscale, anagrafica.partita_iva

        FROM anagrafica
        
        INNER JOIN anagrafica AS duplicati ON (
        (
        duplicati.codice_fiscale = anagrafica.codice_fiscale AND anagrafica.codice_fiscale != "" AND anagrafica.codice_fiscale IS NOT NULL
        )
        OR
        duplicati.partita_iva = anagrafica.partita_iva AND anagrafica.partita_iva != "" AND anagrafica.partita_iva IS NOT NULL
        )
        AND
        duplicati.id != anagrafica.id
        )
        
        ORDER BY anagrafica.timestamp_aggiornamento ASC
        
        LIMIT 1'
    );

    // ...
    $status['duplicati'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, codice_fiscale, partita_iva 
            FROM anagrafica 
            WHERE id != ? 
            AND ( ( ( partita_iva = ? OR partita_iva = ? ) AND partita_iva != "" AND partita_iva IS NOT NULL ) 
            OR ( codice_fiscale = ? AND codice_fiscale != "" AND codice_fiscale IS NOT NULL ) ) 
            ORDER BY codice DESC',
        array(
            array('s' => $status['aggiornare']['id']),
            array('s' => $status['aggiornare']['partita_iva']),
            array('s' => str_pad($status['aggiornare']['partita_iva'], 11, '0', STR_PAD_LEFT)),
            array('s' => $status['aggiornare']['codice_fiscale'])
        )
    );

    // ...
    foreach ($status['duplicati'] as $duplicato) {

        // controlli formali
        if (strlen($duplicato['partita_iva']) < strlen($status['aggiornare']['partita_iva'])) {

            // ...
            $status['correzioni']['partita_iva'] = $status['aggiornare']['partita_iva'];
        }

        // ...
        unisciAnagrafiche($duplicato['id'], $status['aggiornare']['id']);

        // echo 'unisco #' . $duplicato['id'] . ' con #' . $status['aggiornare']['id'];

    }

    // applicazione correzioni
    foreach ($status['correzioni'] as $campo => $correzione) {

        // ...
        $status['aggiustamenti'][] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE anagrafica SET ' . $campo . ' = ? WHERE id = ?',
            array(
                array('s' => $correzione),
                array('s' => $status['aggiornare']['id'])
            )
        );
    }

    // ...
    $status['aggiornamento'] = mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE anagrafica SET timestamp_aggiornamento = ? WHERE id = ?',
        array(
            array('s' => time()),
            array('s' => $status['aggiornare']['id'])
        )
    );
}

// output
if (!defined('CRON_RUNNING')) {
    buildJson($status);
}
