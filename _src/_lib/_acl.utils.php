<?php

    /**
     * libreria di supporto per la gestione di utenti e permessi
     * 
     * Questa libreria contiene le funzioni per la gestione di utenti e permessi. Per una trattazione dettagliata
     * sul sistema di autorizzazione del framework si faccia riferimento ai commenti del file dev/_src/_config/_200.auth.php.
     *
     * introduzione
     * ============
     * Questa libreria è pensata per semplificare le verifiche su permessi e diritti, fornendo funzioni semplici che
     * consentano di scrivere codice più chiaro e leggibile.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti proprie.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in tre gruppi, le funzioni per i permessi, quelle per i diritti e quelle
     * di utilità generale.
     * 
     * funzioni per i permessi
     * -----------------------
     * Queste funzioni riguardano specificamente le operazioni di verifica dei permessi degli utenti.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * getPagePermission()              | verifica se l'utente ha i permessi per accedere a una pagina
     * getAclPermission()               | verifica se l'utente ha i permessi per effettuare un'azione su una tabella
     * 
     * funzioni per i diritti
     * ----------------------
     * Queste funzioni riguardano specificamente le operazioni di verifica dei diritti degli utenti.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * getAclRights()                   | verifica se l'utente ha i diritti per effettuare una certa azione su una data riga di una tabella
     * getAclRightsAccountId()          | restituisce l'ID dell'account corrente
     * getAclRightsTable()              | restituisce il nome della tabella di ACL per una data tabella
     * 
     * funzioni di utilità generale
     * ----------------------------
     * Queste funzioni riguardano specificamente le operazioni di utilità generale.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * checkFirmaImportazione()         | verifica la firma di importazione
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2025-05-18       | Fabio Mosti          | refactoring completo della libreria
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     * 
     * 
     */

    /**
     * FUNZIONI PER I PERMESSI
     */

    /**
     * questa funzione verifica se l'utente ha i permessi per accedere a una pagina
     *
     * Questa funzione verifica se l'utente ha i permessi per accedere a una pagina incrociando i gruppi associati
     * all'account corrente (salvati in $_SESSION['account']['gruppi']) con i gruppi autorizzati a visualizzare la pagina
     * (presenti in $cf['contents']['pages'][$p]['auth']['groups']).
     * 
     * Se l'utente non ha i permessi per accedere alla pagina, viene restituito false, altrimenti true. Se la pagina
     * non ha restrizioni di accesso, viene restituito true; se l'utente non ha gruppi con cui richiedere l'accesso, viene
     * restituito false.
     * 
     * @param       string      $p      ID della pagina
     * 
     * @return      boolean             true se l'utente ha i permessi per accedere alla pagina, false altrimenti
     * 
     */
    function getPagePermission( $p ) {

        // namespace globale
        global $cf;

        // se viene passato $cf['page'] anziché l'ID della pagina
        if(is_array($p)) {
            $p = $p['id'];
        }

        // pagina su cui lavorare
        if(isset($cf['contents']['pages'][$p])) {

            // scorciatoia
            $pag = $cf['contents']['pages'][$p];

            // controllo
            if(! isset($pag['auth']['groups'])) {

                // la pagina non ha restrizioni di accesso
                return true;

            } elseif(! isset($_SESSION['account']['gruppi'])) {

                // l'utente non ha gruppi con cui richiedere l'accesso
                return false;

            } elseif(count(array_intersect($pag['auth']['groups'], $_SESSION['account']['gruppi'])) > 0) {

                // c'è un intersezione fra i gruppi dell'utente e quelli autorizzati a visualizzare la pagina
                return true;

            }
        }

        // di default, ritorno false
        return false;

    }

    /**
     * questa funzione verifica se l'utente ha i permessi per effettuare un'azione su una tabella
     * 
     * Questa funzione verifica tramite il confronto fra i permessi dell'utente e quelli della tabella
     * se l'utente ha i permessi per effettuare una certa azione su quella tabella. I permessi dell'utente
     * sono memorizzati in $_SESSION['account']['permissions'], organizzati in un array associativo con le
     * chiavi costituite dal nome della tabella e i valori costituiti da un array di permessi ossia di
     * azioni che possono essere effettuate. Se l'azione richiesta è presente fra i permessi dell'utente,
     * viene restituito true, altrimenti false.
     * 
     * @param       string      $t      nome della tabella
     * @param       string      $a      azione da effettuare
     * @param       array       $i      array dei permessi dell'utente per la tabella
     * 
     * @return      boolean             true se l'utente ha i permessi per effettuare l'azione, false altrimenti
     *
     */
    function getAclPermission($t, $a, &$i = NULL) {

        // namespace globale
        global $cf;

        // le entità con suffisso _attivi e _archiviati di default hanno gli stessi permessi dell'entità base
        // TODO fare questa cosa solo se non esiste il permesso esplicito per attivi e archiviati
        $t = str_replace(array('_attivi', '_archiviati'), '', $t);

        // log
        logger('richiesta di accesso per ' . $t . '/' . $a, 'auth');

        // controllo permessi
        if (isset($_SESSION['account']['permissions'][$t])) {

            // passaggio ricorsivo dei permessi
            $i['__auth__'] = $_SESSION['account']['permissions'][$t];

            // stringa dei permessi ricorsivi
            $auth = implode(',', $i['__auth__']);

            // autorizzazione
            if (in_array($a, $i['__auth__'])) {

                // log
                logger('accesso consentito per permessi espliciti ' . $t . '/' . $a . ' -> ' . $auth, 'auth');

                // concessione del permesso
                return true;

            } elseif (in_array(CONTROL_FULL, $i['__auth__'])) {

                // log
                logger('accesso consentito per FULL CONTROL ' . $t . '/' . $a . ' -> ' . $auth, 'auth');

                // concessione del permesso
                return true;

            } elseif (in_array(CONTROL_FILTERED, $i['__auth__'])) {

                // log
                logger('accesso consentito per FILTERED CONTROL ' . $t . '/' . $a . ' -> ' . $auth, 'auth');

                // concessione del permesso
                return true;

            } else {

                // log
                logger('accesso non consentito per ' . $t . '/' . $a . ' in ' . $auth, 'auth', LOG_INFO);

                // negazione del permesso
                return false;

            }

        }

        // log
        logger('permessi non settati in SESSION per ' . $t, 'auth', LOG_INFO);

        // default
        return false;

    }

    /**
     * FUNZIONI PER I DIRITTI
     */

    /**
     * questa funzione verifica se l'utente ha i diritti per effettuare una certa azione su una data riga di una tabella
     *
     * Questa funzione verifica se l'utente ha i diritti per effettuare una certa azione su una data riga di una tabella controllando se
     * esiste una tabella di ACL per la tabella data, e nel caso se l'utente ha i diritti per effettuare l'azione richiesta in base
     * a quanto contenuto nella tabella di ACL. Se l'utente ha i diritti per effettuare l'azione, viene restituito true, altrimenti false.
     * Se la tabella di ACL non esiste, viene restituito true. Se l'utente ha i diritti di FULL CONTROL, viene restituito true.
     * 
     * @param       string      $t      nome della tabella
     * @param       string      $a      azione da effettuare
     * @param       int         $id     ID della riga della tabella
     * @param       array       $i      array dei permessi dell'utente per la tabella
     * 
     * @return      boolean             true se l'utente ha i diritti per effettuare l'azione, false altrimenti
     *
     */
    function getAclRights($t, $a, $id, &$i = NULL) {

        // namespace globale
        global $cf;

        // ...
        // TODO fare questa cosa solo se non esiste il permesso esplicito per attivi e archiviati
        $t = str_replace(array('_attivi', '_archiviati'), '', $t);

        // log
        logger('richiesta di accesso per ' . $t . '/' . $id . '/' . $a, 'auth');

        // passaggio ricorsivo dei permessi
        $i['__auth__'] = $_SESSION['account']['permissions'][$t];

        // verifico se l'utente ha il pieno controllo sulla tabella
        if (in_array(CONTROL_FULL, $i['__auth__'])) {

            // log
            logger('accesso FULL per ' . $t . '/' . $id . '/' . $a, 'auth');

            // default
            return true;

        } else {

            // log
            logger('accesso FULL non consentito per ' . $t . '/' . $id . '/' . $a . ', procedo...', 'auth');

            // prelevo la tabella delle ACL
            $aclTb = getAclRightsTable($t);

            // prelevo l'utente per il controllo ACL
            $aclId = getAclRightsAccountId();

            // log
            logger('verifico i diritti tramite tabella ACL: ' . $aclTb . ' per ID account: ' . $aclId, 'auth');

            // se esistono ACL per questa entità
            if (empty($aclTb)) {

                // log
                logger('nessuna tabella di ACL presente per ' . $t . ' (' . $id . '/' . $a . '), autorizzazione concessa', 'auth');

                // default
                return true;

            } else {

                // log
                logger('tabella di ACL presente per ' . $t . ' (' . $id . '/' . $a . '), procedo...', 'auth');

                // valuto la riga
                $r = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    "SELECT concat_ws( ',', group_concat( $aclTb.permesso SEPARATOR ',' ), if( ( $t.id_account_inserimento = ? ), 'FULL', NULL ) ) AS t 
                    FROM $t
                    LEFT JOIN $aclTb ON $aclTb.id_entita = $t.id
                    LEFT JOIN account_gruppi ON ( account_gruppi.id_gruppo = $aclTb.id_gruppo OR gruppi_path_check( $aclTb.id_gruppo, account_gruppi.id_gruppo ) OR $aclTb.id_account = ? ) 
                    WHERE ( account_gruppi.id_account = ? OR $t.id_account_inserimento = ? ) 
                    AND $t.id = ? ",
                    array(
                        array('s' => $aclId), 
                        array('s' => $aclId), 
                        array('s' => $aclId), 
                        array('s' => $aclId), 
                        array('s' => $id)
                    )
                );

                // creo l'array delle autorizzazioni
                $i['__auth__'] = explode(',', $r);

                // log
                logger('diritti letti per ' . $t . '/' . $id . '/' . $a . ': ' . $r, 'auth');

                // controllo dei diritti
                if (in_array($a, $i['__auth__'])) {

                    // log
                    logger('diritti concessi per tabella di ACL su ' . $t . '/' . $id . '/' . $a, 'auth');

                    // concedo i diritti
                    return true;

                } elseif (in_array(CONTROL_FULL, $i['__auth__'])) {

                    // log
                    logger('diritti concessi per FULL CONTROL su ' . $t . '/' . $id . '/' . $a, 'auth');

                    // concedo i diritti
                    return true;

                } elseif (in_array(CONTROL_FILTERED, $i['__auth__'])) {

                    // log
                    logger('diritti concessi per FILTERED CONTROL su ' . $t . '/' . $id . '/' . $a, 'auth');

                    // concedo i diritti
                    return true;

                } else {

                    // log
                    logger('diritti negati su ' . $t . '/' . $id . '/' . $a . ' in (' . $r . ')', 'auth');

                    // nego i diritti
                    return false;
                }

            }

        }

        // log
        logger('accesso non consentito per ' . $t . '/' . $id . '/' . $a, 'auth');

        // default
        return false;

    }

    /**
     * questa funzione restituisce l'ID dell'account corrente
     *
     * Questa funzione restituisce l'ID dell'account corrente, se presente in $_SESSION['account']['id'], altrimenti
     * restituisce false.
     *
     * @return      int|bool             l'ID dell'account corrente, oppure false se non presente
     *
     */
    function getAclRightsAccountId() {
        return (isset($_SESSION['account']['id'])) ? $_SESSION['account']['id'] : false;
    }

    /**
     * questa funzione restituisce il nome della tabella di ACL per una data tabella
     * 
     * Questa funzione restituisce il nome della tabella di ACL per una data tabella, se presente. Se la tabella di ACL
     * non esiste, viene restituito NULL. Se l'utente ha i diritti di FULL CONTROL, viene restituito NULL. Se l'utente
     * è root, viene restituito NULL. Se la tabella di ACL esiste, viene restituito il nome della tabella di ACL.
     * 
     * @param       string      $t      nome della tabella
     * 
     * @return      string|null           il nome della tabella di ACL, oppure NULL se non esiste
     *
     *
     */
    function getAclRightsTable($t) {

        // namespace globale
        global $cf;

        // ...
        // TODO fare questa cosa solo se non esiste il permesso esplicito per attivi e archiviati
        $t = str_replace(array('_attivi', '_archiviati'), '', $t);

        // verifico se l'utente non è root
        if ($_SESSION['account']['username'] == 'root' || in_array('roots', $_SESSION['account']['gruppi'])) {

            // log
            logger('accesso root concesso a ' . $_SESSION['account']['username'] . ' (' . implode(',', $_SESSION['account']['gruppi']) . ') per ' . $t, 'auth');

            // default
            return NULL;

        } elseif (in_array(CONTROL_FULL, $_SESSION['account']['permissions'][$t])) {

            // log
            logger('accesso FULL concesso a ' . $_SESSION['account']['username'] . ' (' . implode(',', $_SESSION['account']['gruppi']) . ') per ' . $t, 'auth');

            // default
            return NULL;

        } else {

            // verifico se esiste la tabella $t_gruppi
            #		    $r = mysqlSelectCachedValue(
            $r = mysqlSelectValue(
                $cf['mysql']['connection'],
                "SELECT table_name FROM information_schema.tables WHERE table_name = '__acl_${t}__' AND table_schema = database()"
            );

            // log
            logger($_SESSION['account']['username'] . ' (' . implode(',', $_SESSION['account']['gruppi']) . ') tabella di ACL ' . $r . ' trovata per ' . $t, 'auth');

            // risultato
            return $r;
        }

        // log
        logger('accesso non filtrato concesso a ' . $_SESSION['account']['username'] . ' (' . implode(',', $_SESSION['account']['gruppi']) . ') per ' . $t, 'auth');

        // default
        return NULL;
    }

    /**
     * FUNZIONI DI UTILITÀ GENERALE
     */

    /**
     * questa funzione verifica la firma di importazione
     * 
     * Questa funzione verifica la firma di importazione di una riga di una tabella, confrontando la firma presente nella riga
     * con la firma calcolata a partire dalla tabella e dalla chiave segreta di importazione. Se la firma è corretta,
     * viene restituito true, altrimenti false. Se la chiave segreta di importazione non è presente, viene restituito false.
     * Per ulteriori informazioni sul funzionamento della verifica tramite chiave di importazione, si vedano i commenti
     * al file /_src/_config/_740.controller.php.
     * 
     * @param       array       $row    riga della tabella da verificare
     * @param       string      $table  nome della tabella
     * 
     * @return      boolean             true se la firma è corretta, false altrimenti
     * 
     */
    function checkFirmaImportazione($row, $table) {

        global $cf;

        if (isset($cf['auth']['import']['secret'])) {

            $challenge = hash(
                getAvailableHashMethod(),
                $table . $cf['auth']['import']['secret']
            );

            if (isset($row['__firma__']) && $row['__firma__'] == $challenge) {

                return true;

            } elseif (isset($row['__firma__']) && $row['__firma__'] != $challenge) {

                logger('firma non corrispondente: ' . $row['__firma__'] . ' (prevista: ' . $challenge . ') per: ' . print_r($row, true), 'firme', LOG_ERR);

            } else {

                logger('firma non trovata per: ' . print_r($row, true), 'firme', LOG_ERR);

            }

        }

        return false;
    }
