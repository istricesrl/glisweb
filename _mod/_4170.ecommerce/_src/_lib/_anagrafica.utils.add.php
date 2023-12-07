<?php

    function aggiornaProprietarioCarrello( &$carrello ) {

        global $cf;

        if( isset( $_SESSION['account']['id'] ) && ! empty( $_SESSION['account']['id'] ) ) {

            $checkIdAccount = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id FROM account WHERE id = ?',
                array(
                    array( 's' => $_SESSION['account']['id'] )
                )
            );

            if( ! empty( $checkIdAccount ) && ( ! isset( $carrello['intestazione_id_account'] ) || empty( $carrello['intestazione_id_account'] ) ) ) {

                $carrello['intestazione_id_account'] = $_SESSION['account']['id'];

            }

        }

        if( isset( $_SESSION['account']['id_anagrafica'] ) && ! empty( $_SESSION['account']['id_anagrafica'] ) ) {

            $checkIdAnagrafica = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id FROM anagrafica WHERE id = ?',
                array(
                    array( 's' => $_SESSION['account']['id_anagrafica'] )
                )
            );

            if( ! empty( $checkIdAnagrafica ) && ( ! isset( $carrello['intestazione_id_anagrafica'] ) || empty( $carrello['intestazione_id_anagrafica'] ) ) ) {

                $carrello['intestazione_id_anagrafica'] = $_SESSION['account']['id_anagrafica'];

            }

        }

    }
