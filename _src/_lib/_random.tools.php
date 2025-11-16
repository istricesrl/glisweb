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
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    /**
     * restituisce un token generato casualmente a partire dal tempo corrente 
     * 
     * Questa funzione moltiplica il timestamp in millisecondi per un numero casuale e restituisce il risultato
     * crittografato con MD5.
     * 
     * @return   string    hash MD5 (32 caratteri esadecimali)
     * 
     */
    function getToken() {

        return md5( microtime( true ) * random_int( 0, 10000 ) );

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
