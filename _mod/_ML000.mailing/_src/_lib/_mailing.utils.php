<?php

    /**
     * libreria per il consenso alle comunicazioni della newsletter
     *
     * Raccoglie in un posto solo la regola che decide chi può ricevere un mailing, così che la popolazione delle
     * liste, la preparazione dei destinatari e la generazione delle mail la applichino tutte uguale.
     *
     * introduzione
     * ============
     * Il consenso che conta per la newsletter è INVIO_COMUNICAZIONI_MARKETING, nella tabella `anagrafica_consensi`
     * sul modello di `_mod/_0350.registrazione/_src/_inc/_macro/_registrazione.php`. Una riga di consenso sta
     * sull'anagrafica ( `id_anagrafica` ) oppure sul singolo indirizzo ( `id_mail`, aggiunto dalla patch
     * `_202610011500.consensi.mail.sql` ): dal sito pubblico si iscrive un indirizzo senza anagrafica, e il link
     * di disiscrizione arriva a un indirizzo, non a una persona.
     *
     * La regola, decisa da Fabio il 2026-10-01:
     *
     * - un indirizzo **senza nessuna riga** di consenso entra: le liste storiche e le anagrafiche importate non ne
     *   hanno, e pretenderlo avrebbe svuotato tutte le liste esistenti;
     * - è escluso se **l'ultima riga** fra quelle del suo indirizzo e quelle della sua anagrafica non è un
     *   consenso prestato; l'ultima, e non una qualsiasi, perché chi si era tolto e si riscrive dal sito deve
     *   tornare a riceverla.
     *
     * ⚠ La regola guarda l'indirizzo, non la riga di `mail`. La tabella ammette lo stesso indirizzo più volte ( la
     * chiave unica è su anagrafica e indirizzo, e le righe senza anagrafica non collidono ), e su un deploy con le
     * anagrafiche importate da un gestionale capita spesso: se la revoca valesse solo per la riga su cui è stata
     * scritta, la copia dell'indirizzo attaccata a un'altra anagrafica continuerebbe a ricevere la newsletter.
     * Quindi le righe di consenso che contano sono quelle di tutte le righe di `mail` con lo stesso indirizzo e
     * delle loro anagrafiche.
     *
     * NOTA un consenso negato può essere scritto come `se_prestato = NULL` e non come zero: è quello che fa
     * `_registrazione.php`, perché mysqlInsertRow() passa i valori da empty2null(). Per questo una riga con
     * `se_prestato` NULL conta come una revoca.
     *
     * ⚠ La regola non protegge chi si è tolto da uno strumento precedente che non ne ha lasciato traccia: se
     * l'indirizzo arriva da un'importazione senza una riga di revoca, per questa libreria non si è mai tolto.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     *
     * funzioni per il consenso
     * ------------------------
     * funzione                         | descrizione
     * ---------------------------------|------------------------------------------------------------------------
     * mailingCondizioneConsenso()      | restituisce la condizione SQL che lascia passare gli indirizzi non revocati
     * mailingSeConsenso()              | dice se un indirizzo può ricevere la newsletter
     * mailingRegistraConsenso()        | registra il consenso o la revoca di un indirizzo
     *
     * dipendenze
     * ==========
     * funzione                         | libreria di appartenenza
     * ---------------------------------|------------------------------------------------------------------------
     * mysqlSelectValue()               | _src/_lib/_mysql.tools.php
     * mysqlQuery()                     | _src/_lib/_mysql.tools.php
     * logWrite()                       | _src/_lib/_log.utils.php
     *
     * changelog
     * =========
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-10-01       | Fabio Mosti          | prima versione, con la conversione di _7000.mailing
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     * @file
     *
     */

    /**
     * FUNZIONI PER IL CONSENSO
     */

    /**
     * restituisce la condizione SQL che lascia passare gli indirizzi non revocati
     *
     * La condizione si mette nel WHERE di una query che legge la tabella `mail` ( o un suo alias ) e lascia
     * passare l'indirizzo se l'ultima riga di consenso INVIO_COMUNICAZIONI_MARKETING fra quelle delle righe di
     * `mail` con lo stesso indirizzo e quelle delle loro anagrafiche è un consenso prestato, oppure se righe non
     * ce ne sono. Il consenso si cerca per
     * codice e non per id, perché sui deploy di prima di marzo `consensi.id` è ancora il codice ( si veda
     * `_202609301700.consensi.sql` ).
     *
     * @param   string  $alias  il nome o l'alias della tabella `mail` nella query
     *
     * @return  string          la condizione SQL, senza parametri posizionali
     *
     */
    function mailingCondizioneConsenso( $alias = 'mail' ) {

        return 'coalesce( ( '.
            'SELECT coalesce( anagrafica_consensi.se_prestato, 0 ) FROM anagrafica_consensi '.
            'INNER JOIN consensi ON consensi.id = anagrafica_consensi.id_consenso '.
            'INNER JOIN mail AS mail_consenso ON ( mail_consenso.id = anagrafica_consensi.id_mail '.
            'OR mail_consenso.id_anagrafica = anagrafica_consensi.id_anagrafica ) '.
            'WHERE consensi.codice = \'INVIO_COMUNICAZIONI_MARKETING\' '.
            'AND mail_consenso.indirizzo = ' . $alias . '.indirizzo '.
            'ORDER BY coalesce( anagrafica_consensi.timestamp_consenso, anagrafica_consensi.timestamp_aggiornamento, anagrafica_consensi.timestamp_inserimento, 0 ) DESC, anagrafica_consensi.id DESC '.
            'LIMIT 1 '.
        '), 1 ) != 0';

    }

    /**
     * dice se un indirizzo può ricevere la newsletter
     *
     * Applica a un singolo indirizzo la stessa condizione di mailingCondizioneConsenso(); serve a
     * `_genera.mail.php`, che deve rinunciare a un destinatario che ha revocato il consenso dopo che l'elenco
     * dei destinatari era già stato preparato.
     *
     * @param   int     $idMail l'id della riga della tabella `mail`
     *
     * @return  bool            true se l'indirizzo può ricevere la newsletter
     *
     */
    function mailingSeConsenso( $idMail ) {

        global $cf;

        return (bool) mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count( mail.id ) FROM mail WHERE mail.id = ? AND ' . mailingCondizioneConsenso( 'mail' ),
            array(
                array( 's' => $idMail )
            )
        );

    }

    /**
     * registra il consenso o la revoca di un indirizzo
     *
     * Scrive sulla riga di `anagrafica_consensi` dell'indirizzo, e non della sua anagrafica: chi si toglie con il
     * link della mail toglie quell'indirizzo, e la revoca per la persona si fa dalla scheda dell'anagrafica. La
     * riga è una sola per indirizzo ( chiave unica `id_mail, id_consenso` ) e si aggiorna; la storia resta nel
     * log `mailing`. Si scrive con una query e non con mysqlInsertRow(), che trasformerebbe lo zero della revoca
     * in NULL.
     *
     * @param   int     $idMail     l'id della riga della tabella `mail`
     * @param   bool    $prestato   true per il consenso, false per la revoca
     * @param   string  $nota       da dove arriva il consenso ( il modulo, il link di disiscrizione... )
     *
     * @return  mixed               l'esito della query, o false se il consenso non esiste
     *
     */
    function mailingRegistraConsenso( $idMail, $prestato, $nota = NULL ) {

        global $cf;

        // ID del consenso
        $idConsenso = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM consensi WHERE codice = ?',
            array( array( 's' => 'INVIO_COMUNICAZIONI_MARKETING' ) )
        );

        // se il consenso non esiste non c'è dove scrivere
        if( empty( $idConsenso ) ) {
            logWrite( 'il consenso INVIO_COMUNICAZIONI_MARKETING non esiste nella tabella consensi, non registrato per la mail #' . $idMail, 'mailing', LOG_ERR );
            return false;
        }

        // timestamp del consenso
        $timestamp = time();

        // testo del consenso
        $testo = 'il ' . date( 'd/m/Y', $timestamp ) . ' alle ' . date( 'H:i:s', $timestamp ) . ( ( empty( $prestato ) ) ? ' è stato revocato' : ' è stato prestato' ) . ' il consenso per INVIO_COMUNICAZIONI_MARKETING per la mail #' . $idMail . ( ( ! empty( $nota ) ) ? ' ( ' . $nota . ' )' : NULL );

        // log
        logWrite( $testo, 'mailing' );

        // registro il consenso
        return mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO anagrafica_consensi ( id_mail, id_consenso, se_prestato, note, timestamp_consenso, timestamp_inserimento ) '.
            'VALUES ( ?, ?, ?, ?, ?, ? ) '.
            'ON DUPLICATE KEY UPDATE se_prestato = VALUES( se_prestato ), note = VALUES( note ), '.
            'timestamp_consenso = VALUES( timestamp_consenso ), timestamp_aggiornamento = VALUES( timestamp_inserimento )',
            array(
                array( 's' => $idMail ),
                array( 's' => $idConsenso ),
                array( 's' => ( empty( $prestato ) ) ? 0 : 1 ),
                array( 's' => $testo ),
                array( 's' => $timestamp ),
                array( 's' => $timestamp )
            )
        );

    }
