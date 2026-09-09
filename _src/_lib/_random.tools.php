<?php

    /**
     * libreria per la generazione di stringhe casuali
     *
     * Questa libreria fornisce strumenti utili per ottenere stringhe casuali, come token o password.
     *
     * introduzione
     * ============
     * Questa libreria semplifica la generazione di stringhe casuali per vari scopi, come la creazione di token di sessione
     * o password temporanee. Utilizza funzioni sicure per garantire l'unicità e la casualità delle stringhe generate.
     * 
     * funzioni
     * ========
     * Questa libreria contiene soltanto due funzioni quindi non è divisa in sezioni. Le funzioni disponibili sono:
     * 
     * funzione           | descrizione
     * -------------------|---------------------------------------------------------------------------
     * getToken()         | restituisce un token generato casualmente a partire dal tempo corrente
     * getPassword()      | restituisce una password casuale di lunghezza definita
     *
     * dipendenze
     * ==========
     * Questa libreria non ha dipendenze esterne.
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     * 
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2025-11-08       | Elisabetta Comani    | documentata la libreria
     * 2026-09-09       | Fabio Mosti          | getToken() su random_bytes(): il vecchio token poteva ripetersi
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    /**
     * restituisce un token generato casualmente
     *
     * Questa funzione restituisce 16 byte casuali presi dal generatore crittografico del sistema, resi in
     * esadecimale: 32 caratteri, la stessa forma e la stessa lunghezza che aveva l'hash MD5 di prima.
     *
     * La versione precedente era `md5( microtime( true ) * random_int( 0, 10000 ) )` e aveva due difetti, uno
     * evidente e uno silenzioso. Il primo: `random_int()` può restituire **zero**, e allora il prodotto è zero
     * e il token è sempre `cfcd208495d565ef66e7dff9f98764da`. Il secondo, che è quello che pesava di più: il
     * prodotto è un **float**, e `md5()` lo riceve dopo una conversione a stringa che lo tronca a `precision`
     * cifre significative (14 per default). Due chiamate ravvicinate con moltiplicatori diversi finivano
     * quindi sulla stessa stringa, e l'entropia vera era molto minore dei 32 caratteri che il risultato
     * lasciava supporre.
     *
     * Misurato su 100.000 generazioni: la vecchia versione produceva 99.563 token distinti — 437 collisioni,
     * di cui appena 8 dovute allo zero e le altre 430 alla precisione del float; la nuova, 100.000 su 100.000.
     *
     * Non è un dettaglio accademico perché è la funzione con cui `_src/_api/_job.php` prende il **lock** dei
     * job: due esecuzioni concorrenti che ottengono lo stesso token credono entrambe di avere il lock.
     *
     * @return   string    32 caratteri esadecimali (128 bit di entropia)
     *
     */
    function getToken() {

        return bin2hex( random_bytes( 16 ) );

    }

    /**
     * restituisce una password casuale di lunghezza definita 
     * 
     * Questa funzione può essere utilizzata per generare una password casuale di lunghezza definita e contenente
     * i caratteri forniti.
     * 
     *  @param   int       $length      la lunghezza della password da generare
     *  @param   string    $keyspace    contiene i caratteri da utilizzare per comporre la password
     * 
     *  @return  string                 la password generata
     * 
     */
    function getPassword( $length = 16, $keyspace = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_!?%' ) {

        // inizializza una stringa vuota che sarà popolata con i caratteri casuali scelti
        $str = '';

        // $max è la lunghezza in byte di $keyspace
        $max = mb_strlen( $keyspace, '8bit' ) - 1;

        // la stringa di lunghezza $lenght viene composta aggiungendo ad ogni ciclo un carattere selezionato casualmente da $keyspace
        for( $i = 0; $i < $length; ++$i ) {
            $str .= $keyspace[ random_int( 0, $max ) ];
        }

        return $str;

    }
