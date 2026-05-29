<?php

    /**
     * hook di rigenerazione dell'id di sessione per il modulo e-commerce
     *
     * Viene incluso da _src/_config/_210.auth.php subito dopo session_regenerate_id() al login interattivo
     * (anti session fixation). In questo modulo il carrello a database è collegato alla sessione tramite la
     * colonna carrelli.session (vedi _src/_config/_750.controller.php): al cambio di id di sessione la riga
     * resterebbe orfana, quindi qui la "ri-puntiamo" dal vecchio al nuovo id e allineiamo il valore tenuto in
     * $_SESSION['carrello']['session'].
     *
     * Dati disponibili (valorizzati dall'hook in _210.auth.php):
     * - $cf['session']['regenerate']['old_id']  id di sessione precedente
     * - $cf['session']['regenerate']['new_id']  id di sessione corrente (nuovo)
     */

    // procedo solo con una connessione attiva e un vecchio id (l'hook gira solo dopo una rigenerazione effettiva)
    if( ! empty( $cf['mysql']['connection'] ) && ! empty( $cf['session']['regenerate']['old_id'] ) ) {

        // ri-punto il carrello a database dal vecchio al nuovo id di sessione
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE carrelli SET session = ? WHERE session = ?',
            array(
                array( 's' => $cf['session']['regenerate']['new_id'] ),
                array( 's' => $cf['session']['regenerate']['old_id'] )
            )
        );

        // allineo il valore tenuto in sessione (il carrello attivo sopravvive alla rigenerazione)
        if( isset( $_SESSION['carrello']['session'] ) ) {
            $_SESSION['carrello']['session'] = $cf['session']['regenerate']['new_id'];
        }

        // log
        logWrite( 'carrello ri-puntato dalla sessione ' . $cf['session']['regenerate']['old_id'] . ' alla sessione ' . $cf['session']['regenerate']['new_id'], 'cart' );

    }
