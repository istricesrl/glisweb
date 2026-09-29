<?php

    /**
     * libreria per la gestione delle variabili
     *
     * Questa libreria contiene funzioni di utilità generica che lavorano sulle variabili PHP indipendentemente dal
     * loro tipo.
     *
     * introduzione
     * ============
     * Questa libreria raccoglie le piccole funzioni di servizio che non appartengono a nessuna delle librerie tematiche
     * ( array, stringhe, file, eccetera ) perché operano su variabili di qualsiasi tipo. Al momento contiene la sola
     * funzione swap().
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono raggruppate in base al lavoro che svolgono.
     *
     * funzioni di manipolazione
     * -------------------------
     * Le funzioni in questo gruppo servono per manipolare il contenuto delle variabili.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * swap()                           | scambia il contenuto di due variabili
     *
     * dipendenze
     * ==========
     * Questa libreria non ha dipendenze.
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
     * FUNZIONI DI MANIPOLAZIONE
     */

    /**
     * scambia il contenuto di due variabili
     *
     * Questa funzione scambia fra loro i valori delle due variabili passate, che sono entrambe passate per riferimento
     * e vengono quindi modificate sul posto: dopo la chiamata $x contiene il vecchio valore di $y e viceversa. Le due
     * variabili possono essere di qualsiasi tipo, anche diverso fra loro; se una delle due non è definita, dopo lo
     * scambio l'altra vale NULL.
     *
     * @param       mixed       $x      la prima variabile, modificata sul posto
     * @param       mixed       $y      la seconda variabile, modificata sul posto
     *
     * @return      void
     *
     */
    function swap( &$x, &$y ) {
        list($x,$y) = array($y, $x);
    }
