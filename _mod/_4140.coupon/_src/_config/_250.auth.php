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
            'coupon' => array(
                  CONTROL_FULL => array('roots'),
                  CONTROL_FILTERED => array('staff'),
                  METHOD_GET => array('users')
            ),
            'coupon_categorie_prodotti' => array(
                  CONTROL_FULL => array('roots'),
                  CONTROL_FILTERED => array('staff')
            ),
            'coupon_prodotti' => array(
                  CONTROL_FULL => array('roots'),
                  CONTROL_FILTERED => array('staff')
            ),
            'coupon_listini' => array(
                  CONTROL_FULL => array('roots'),
                  CONTROL_FILTERED => array('staff')
            ),
            'coupon_marchi' => array(
                  CONTROL_FULL => array('roots'),
                  CONTROL_FILTERED => array('staff')
            )
      )
);

// debug
// print_r( $cf['auth']['permissions'] );