<?php

/**
 *
 *
 *
 *
 *
 *
 *
 *
 * @todo documentare
 *
 * @file
 *
 */

// array dei permessi
$cf['auth']['permissions'] = array_merge_recursive(
    $cf['auth']['permissions'],
    array(
        'listini' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_clienti' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        ),
        'listini_gruppi' => array(
            CONTROL_FULL => array('roots'),
            CONTROL_FILTERED => array('staff')
        )
    )
);
