<?php

    /**
     * libreria per la numerazione dei documenti
     *
     * Questa libreria contiene le funzioni con cui il modulo _DO000.documenti calcola il numero da dare a un nuovo
     * documento, lo stesso calcolo che nella generazione precedente fa _mod/_0400.documenti/_src/_lib/_mysql.utils.add.php.
     *
     * introduzione
     * ============
     * Un documento si numera per emittente, sezionale e numerazione: la numerazione è la colonna omonima di
     * tipologie_documenti ( F per fatture, note di credito e di debito, R per le ricevute... ), e documenti di tipologie
     * diverse con la stessa numerazione condividono la sequenza. Il numero nuovo è il più alto già usato più uno.
     *
     * Le funzioni sono copiate da _0400.documenti il 2026-09-25, perché le pianificazioni di documenti del modulo
     * _PI000.pianificazioni funzionino anche con il solo _DO000.documenti attivo. I due moduli non si attivano mai
     * insieme ( i deploy passano dall'uno all'altro ), per cui le funzioni hanno lo stesso nome e nessuna guardia
     * function_exists(): chi le chiama le trova qualunque dei due moduli sia attivo. Una correzione alla logica va fatta
     * in tutti e due i file finché _0400.documenti esiste.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono raccolte in un solo gruppo.
     *
     * funzioni di numerazione
     * -----------------------
     * Le funzioni in questo gruppo calcolano il numero dei documenti.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * generaInfoNumeroDocumento()      | restituisce l'ultimo documento numerato di un sezionale
     * generaProssimoNumeroDocumento()  | restituisce il prossimo numero libero di un sezionale
     *
     * dipendenze
     * ==========
     * Questa libreria richiede le seguenti funzioni esterne.
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * mysqlSelectRow()                 | _src/_lib/_mysql.tools.php
     * mysqlSelectValue()               | _src/_lib/_mysql.tools.php
     * logger()                         | _src/_config.php
     *
     * changelog
     * =========
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-25       | Fabio Mosti          | prima versione, copiata da _0400.documenti
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * FUNZIONI DI NUMERAZIONE
     */

    /**
     * restituisce l'ultimo documento numerato di un sezionale
     *
     * Questa funzione restituisce id, sezionale, numero e numerazione del documento con il numero più alto fra quelli
     * dell'emittente $idEmittente nel sezionale $sezionale con la stessa numerazione della tipologia $idTipologia; se
     * non ce n'è nessuno restituisce un array con il solo numero a zero. Il numero si confronta come intero, per cui un
     * numero non numerico conta zero.
     *
     * @param       int         $idTipologia    la tipologia del documento da numerare
     * @param       string      $sezionale      il sezionale
     * @param       int         $idEmittente    l'emittente
     *
     * @return      array                       la riga dell'ultimo documento, o array( 'numero' => 0 )
     *
     */
    function generaInfoNumeroDocumento( $idTipologia, $sezionale, $idEmittente ) {

        global $cf;

        // seleziono l'ultimo progressivo utilizzato
        $status['current'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT documenti.id, documenti.sezionale, coalesce( cast( numero as unsigned ), 0 ) AS numero, numerazione FROM documenti '.
            'INNER JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia '.
            'WHERE id_emittente = ? AND sezionale = ? '.
            'AND tipologie_documenti.numerazione = ( SELECT numerazione FROM tipologie_documenti AS t1 WHERE t1.id = ? ) '.
            'ORDER BY coalesce( cast( numero as unsigned ), 0 ) DESC LIMIT 1',
            array(
                array( 's' => $idEmittente ),
                array( 's' => $sezionale ),
                array( 's' => $idTipologia )
            )
        );

        // nessun documento nel sezionale
        if( ! isset( $status['current']['numero'] ) ) {
            $status['current']['numero'] = 0;
        }

        return $status['current'];

    }

    /**
     * restituisce il prossimo numero libero di un sezionale
     *
     * Questa funzione restituisce il numero dell'ultimo documento del sezionale ( vedi generaInfoNumeroDocumento() ) più
     * uno, dopo aver preso il lock MySQL della numerazione.
     *
     * ⚠ Il numero non è un contatore atomico: chi lo chiede lo usa più tardi, quando inserisce il documento, e due
     * richieste che entrano insieme nella finestra calcolano lo stesso numero. Per questo la funzione prende il lock
     * <database>.documenti.numerazione e NON lo rilascia: deve coprire anche l'INSERT del chiamante, e cade da solo alla
     * fine della richiesta perché la connessione MySQL del framework non è persistente. Se il lock non arriva entro
     * dieci secondi si prosegue lo stesso, con un log di errore. La storia completa ( due ricevute sovrapposte su un
     * deploy in esercizio il 2026-09-14 ) è nel commento alla funzione gemella di _0400.documenti.
     *
     * @param       int         $idTipologia    la tipologia del documento da numerare
     * @param       string      $sezionale      il sezionale
     * @param       int         $idEmittente    l'emittente
     *
     * @return      int                         il prossimo numero libero
     *
     */
    function generaProssimoNumeroDocumento( $idTipologia, $sezionale, $idEmittente ) {

        global $cf;

        // lock della numerazione, che si rilascia alla fine della richiesta
        $lock = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT GET_LOCK( concat( database(), ".documenti.numerazione" ), 10 ) AS l'
        );

        // si prosegue anche senza lock
        if( empty( $lock ) ) {
            logger(
                'attenzione: lock della numerazione documenti non acquisito entro 10 secondi, procedo comunque'
                . ' ( sezionale ' . $sezionale . ', tipologia ' . $idTipologia . ' )',
                'documenti',
                LOG_ERR
            );
        }

        // ultimo documento del sezionale
        $row = generaInfoNumeroDocumento( $idTipologia, $sezionale, $idEmittente );

        return $row['numero'] + 1;

    }
