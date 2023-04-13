<?php

    /**
     * test delle cache
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // output
	echo '<pre style="font-family: monospace;">';
    echo 'esempio duplicazione ricorsiva' . PHP_EOL;

    // inserisco un'anagrafica di test
    $idOrig = mysqlInsertRow(
        $cf['mysql']['connection'],
        array(
            'id' => NULL,
            'nome' => 'Test Duplicazione',
            'cognome' => 'Originale'
        ),
        'anagrafica'
    );

    // inserisco il telefono
    $idTelOrig = mysqlInsertRow(
        $cf['mysql']['connection'],
        array(
            'id' => NULL,
            'id_anagrafica' => $idOrig,
            'numero' => '123456789',
            'descrizione' => 'Originale'
        ),
        'telefoni'
    );

    // sostituzioni
    $subs = array(
        't' => array(
            'anagrafica' => array(
                't' => array(
                    'telefoni' => array(
                        'f' => array(
                            'descrizione' => 'Duplicato'
                        )
                    )
                ),
                'f' => array(
                    'cognome' => 'Duplicato'
                )
            )
        )
    );


    // duplicazione
    mysqlDuplicateRowRecursive(
        $cf['mysql']['connection'],
        'anagrafica',
        $idOrig,
        NULL,
        $subs
    );

    // dati
    print_r(
        mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT nome, cognome, numero, descrizione FROM anagrafica LEFT JOIN telefoni ON telefoni.id_anagrafica = anagrafica.id WHERE nome LIKE "%Duplicazione%"'
        )
    );

    // pulizia
    mysqlQuery(
        $cf['mysql']['connection'],
        'DELETE FROM anagrafica WHERE nome LIKE "%Duplicazione%"'
    );

    // output
    echo '</pre>';
