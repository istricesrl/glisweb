<?php

    /**
     * libreria per la registrazione dei consensi privacy
     * 
     * Questa libreria contiene le funzioni che registrano sul database i consensi privacy prestati dagli utenti
     * attraverso i moduli di contatto del sito.
     * 
     * introduzione
     * ============
     * I moduli di contatto gestiti dal modulo _CT000.contatti possono contenere delle checkbox per i consensi privacy,
     * generate dalla macro Twig checkConsensi() di _src/_twig/_lib/_privacy.twig, i cui campi hanno il nome nella forma
     * __ct__[nomemodulo][__privacy__][CODICECONSENSO]. La controller _mod/_CT000.contatti/_src/_config/_750.controller.php,
     * dopo aver salvato il contatto nella tabella contatti, passa il blocco dati del modulo a associazioneConsensiContatto()
     * che registra i consensi prestati nelle tabelle consensi_contatti e, se l'utente è loggato, consensi_anagrafica. La
     * legenda dei consensi si trova nella tabella consensi. Per ulteriori dettagli si vedano _mod/_CT000.contatti/READ.md
     * e _usr/_docs/_read/406.howto.privacy.md.
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni per i consensi
     * -----------------------
     * Le funzioni in questo gruppo servono per registrare i consensi privacy prestati dagli utenti.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * associazioneConsensiContatto()   | registra i consensi prestati tramite un modulo di contatto
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * mysqlSelectValue()               | _src/_lib/_mysql.tools.php
     * mysqlInsertRow()                 | _src/_lib/_mysql.tools.php
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    // debug
    // dieText( print_r( $_REQUEST, true ) );

    /**
     * FUNZIONI PER I CONSENSI
     */

    /**
     * registra i consensi prestati tramite un modulo di contatto
     * 
     * Questa funzione riceve il blocco dati di un modulo di contatto già salvato e, per ogni consenso presente nella
     * chiave __privacy__ con valore vero, cerca nella tabella consensi l'id corrispondente al codice e inserisce una
     * riga in consensi_contatti (legata al contatto) e, se è valorizzato __id_anagrafica__, una seconda riga in
     * consensi_anagrafica (legata all'anagrafica dell'utente loggato). I consensi non prestati (valore falso o vuoto)
     * non vengono registrati, così come quelli il cui codice non esiste nella tabella consensi. Se mancano le chiavi
     * __id_contatto__ o __privacy__, o se __privacy__ non è un array, la funzione non fa niente.
     * 
     * La funzione non restituisce l'esito degli inserimenti e non segnala gli eventuali errori.
     * 
     * @param       array       $v      il blocco dati del modulo di contatto, con le chiavi __id_contatto__, __privacy__
     *                                  (array codice consenso => valore), __modulo__ e facoltativamente __id_anagrafica__
     * 
     * @return      void
     * 
     */
    function associazioneConsensiContatto( $v ) {

        global $cf;

        if( isset( $v['__id_contatto__'] ) && isset( $v['__privacy__'] ) && is_array( $v['__privacy__'] ) ) {

            foreach( $v['__privacy__'] as $codiceConsenso => $valoreConsenso ) {

                if( $valoreConsenso == true ) {

                    $idConsenso = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT id FROM consensi WHERE codice = ?',
                        array(
                            array( 's' => $codiceConsenso ),
                        )
                    );

                    if( ! empty( $idConsenso ) ) {

                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'modulo' => $v['__modulo__'],
                                'id_contatto' => $v['__id_contatto__'],
                                'id_consenso' => $idConsenso,
                                'valore' => $valoreConsenso,
                                'timestamp_inserimento' => time(),
                            ),
                            'consensi_contatti'
                        );

                        if( ! empty( $v['__id_anagrafica__'] ) ) {

                            mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'modulo' => $v['__modulo__'],
                                    'id_anagrafica' => $v['__id_anagrafica__'],
                                    'id_consenso' => $idConsenso,
                                    'valore' => $valoreConsenso,
                                    'timestamp_inserimento' => time(),
                                ),
                                'consensi_anagrafica'
                            );

                        }

                    }

                }

            }

        }

    }
