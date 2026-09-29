<?php

    /**
     * libreria per la retrocompatibilità con il vecchio sistema di log
     *
     * Questa libreria è inserita solo per garantire la retrocompatibilità con il vecchio sistema di log del framework.
     *
     * introduzione
     * ============
     * Il sistema di log attuale del framework è basato sulla funzione core logger(), definita in _src/_config.php, che
     * scrive il messaggio nel file DIR_VAR_LOG . $f . '.' . livello . '.' . anno e mese . '.log' se il livello del
     * messaggio rientra in quello corrente ( LOG_CURRENT_LEVEL ); per i dettagli si vedano i commenti a logger().
     *
     * Le due funzioni di questa libreria sono i nomi del vecchio sistema di log, conservati perché ancora chiamati dal
     * codice esistente ( logWrite() in particolare è usata da diverse librerie del framework ); entrambe si limitano a
     * inoltrare il messaggio a logger() e ignorano i parametri che il vecchio sistema usava e il nuovo non prevede più.
     * Nel codice nuovo si chiama direttamente logger().
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti, ma usa come valori di default dei parametri di logWrite() le costanti
     * LOG_DEBUG ( di PHP ), DIR_VAR_LOG, LOG_CURRENT_LEVEL e SITE_STATUS, definite in fase di configurazione.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono tutte alias mantenuti per retrocompatibilità.
     *
     * funzioni di retrocompatibilità
     * ------------------------------
     * Nel corso del tempo il sistema di log è stato sostituito da logger(); per garantire la retrocompatibilità con le
     * versioni precedenti del framework sono state mantenute delle funzioni wrapper che richiamano la nuova funzione.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * logWrite()                       | scrive un messaggio di log tramite logger()
     * logMsg()                         | scrive un messaggio nel log dei deprecati tramite logger()
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
     * 2026-09-24       | Fabio Mosti          | documentazione
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * ALIAS DI FUNZIONI INSERITI PER RETROCOMPATIBILITÀ
     */

    /**
     * scrive un messaggio di log tramite logger()
     *
     * Questa funzione inoltra a logger() il messaggio, il nome del file di log e il livello; gli altri tre parametri
     * ( la cartella dei log, il livello corrente e lo stato del sito ) sono accettati per compatibilità con le vecchie
     * chiamate ma vengono ignorati, per cui il file di log sta sempre in DIR_VAR_LOG e il filtro sul livello è sempre
     * quello di LOG_CURRENT_LEVEL. Il messaggio viene scritto solo se il suo livello è minore o uguale a quello corrente.
     *
     * NOTA i valori di default dei parametri $t e $s sono le costanti LOG_CURRENT_LEVEL e SITE_STATUS, che PHP valuta
     * al momento della chiamata quando il parametro è omesso: se logWrite() venisse chiamata prima che il runlevel che le
     * definisce sia stato eseguito, la chiamata fallirebbe per costante non definita anche se il valore non viene usato.
     *
     * @param       string      $m      il messaggio da scrivere
     * @param       string      $f      il nome del file di log, relativo a DIR_VAR_LOG ( default 'site' )
     * @param       int         $l      il livello del messaggio, una delle costanti LOG_* di PHP ( default LOG_DEBUG )
     * @param       string      $d      la cartella dei log ( ignorato )
     * @param       int         $t      il livello di log corrente ( ignorato )
     * @param       string      $s      lo stato del sito ( ignorato )
     *
     * @return      void
     *
     */
    function logWrite( $m, $f = 'site', $l = LOG_DEBUG, $d = DIR_VAR_LOG, $t = LOG_CURRENT_LEVEL, $s = SITE_STATUS ) {
        logger( $m, $f, $l );
    }
        
    /**
     * scrive un messaggio nel log dei deprecati tramite logger()
     *
     * Questa funzione scrive il messaggio con logger() nel file di log 'deprecated' al livello di default ( LOG_DEBUG ).
     * Gli altri tre parametri, passati per riferimento, sono accettati solo perché facevano parte della firma del vecchio
     * sistema di log: vengono ignorati e non sono modificati. Nel framework non ci sono più chiamanti.
     *
     * @param       string      $m      il messaggio da scrivere
     * @param       mixed       $o      parametro del vecchio sistema ( ignorato, per riferimento, default NULL )
     * @param       array       $a      parametro del vecchio sistema ( ignorato, per riferimento, default array vuoto )
     * @param       mixed       $t      parametro del vecchio sistema ( ignorato, per riferimento, default NULL )
     *
     * @return      void
     *
     */
    function logMsg( $m, &$o = NULL, &$a = array(), &$t = NULL ) {
        logger( $m, 'deprecated' );
    }
