<?php

    /**
     * libreria per la gestione dei JSON Web Token
     * 
     * Questa libreria contiene le funzioni per la creazione e gestione dei token JWT
     * 
     * introduzione
     * ============
     * I JSON Web Token (JWT) sono un metodo standard aperto (RFC 7519) per creare token di accesso che possono essere verificati 
     * in modo sicuro da un server. Più in generale, i JWT consentono di passare informazioni cifrate da un server all'altro tramite
     * una stringa che può essere facilmente inclusa in link o form.
     * 
     * ATTENZIONE! Chiunque possieda un token JWT può utilizzarlo, anche se non può leggere i dati al suo interno senza sapere la chiave
     * chiave segreta. Questo ad esempio significa che se un attaccante intercetta il token JWT di login a un sito, può effettuare il
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * login utilizzandolo esattamente come farebbe il legittimo destinatario del token stesso.
     * 
     * Da un punto di vista pratico, i token JWT sono costituiti da tre parti dove la terza è l'hash delle prime due; si veda il codice
     * della funzione getJwt() per i dettagli.
     * 
     * Ulteriori informazioni sul funzionamento dei token JWT sono disponibili ai seguenti link:
     * 
     * - https://jwt.io/
     * - https://www.sitepoint.com/php-authorization-jwt-json-web-tokens/
     * - https://auth0.com/learn/token-based-authentication-made-easy/
     * - https://hasura.io/blog/best-practices-of-using-jwt-with-graphql/
     * - https://dev.to/robdwaller/how-to-create-a-json-web-token-using-php-3gml
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti proprie.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono contenute in un unico gruppo. 
     * 
     * funzione                  | descrizione
     * ------------------------- | ---------------------------------------------------
     * getJwt()                  | crea un token JWT
     * checkJwt()                | verifica un token JWT
     * cleanJwt()                | pulisce un token JWT
     * jwt2array()               | converte un token JWT in un array
     *
     * dipendenze
     * ==========
     * Questa libreria non dipende da altre librerie.
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2024-08-13       | Sara Tullini         | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * crea un token JWT
     * 
     * Questa funzione crea un token JWT a partire da un array associativo di dati e una chiave segreta.
     * 
     * @param   array       $a      array di dati da codificare
     * @param   string      $s      chiave segreta
     * 
     * @return  string              token JWT
     * 
     */
    function getJwt( $a = array(), $s = NULL ) {

        $eh = cleanJwt( base64_encode( json_encode( ['typ' => 'JWT', 'alg' => 'HS256'] ) ) );
        
        $ep = cleanJwt( base64_encode( json_encode( $a ) ) );
        
        $hp = $eh . '.' . $ep;
        
        $sg = cleanJwt( base64_encode( hash_hmac( 'sha256', $hp, $s, true ) ) );
        
        $jwt = $hp . '.' . $sg;
        
        return $jwt;
    
    }

    /**
     * verifica un token JWT
     * 
     * Questa funzione verifica un token JWT a partire da un token e una chiave segreta. 
     * 
     * @param   string      $t      token JWT
     * @param   string      $s      chiave segreta
     * 
     * @return  boolean             esito della verifica
     * 
     */
    function checkJwt( $t = NULL, $s = NULL ) {

        $jwt = explode('.', $t);
        
        $rs = $jwt[2];
        
        $hp = $jwt[0] . '.' . $jwt[1];
        
        $sg = cleanJwt( base64_encode( hash_hmac( 'sha256', $hp, $s, true ) ) );
        
        if($sg == $rs) {
            return true;
        }

        return false;
    
    }

    /**
     * pulisce un token JWT
     * 
     * Questa funzione pulisce un token JWT da caratteri non validi.
     * 
     * @param   string      $s      token JWT
     * 
     * @return  string              token JWT pulito
     * 
     */
    function cleanJwt( $s ) {

        return str_replace( ['+', '/', '='], ['-', '_', ''], $s );

    }

    /**
     * converte un token JWT in un array
     * 
     * Questa funzione converte un token JWT in un array. 
     * 
     * @param   string      $t      token JWT
     * @param   string      $s      chiave segreta
     * 
     * @return  array               array di dati
     * 
     */
    function jwt2array( $t, $s ) {

        $r = array();

        if( checkJwt( $t, $s ) ) {

            $tx = explode( '.', $t );  
            $th = base64_decode( $tx[0] );
            $tp = base64_decode( $tx[1] );
            $r['head'] = json_decode( $th, true );
            $r['data'] = json_decode( $tp, true );

        }

        return $r;

    }
