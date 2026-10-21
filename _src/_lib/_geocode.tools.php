<?php

    /**
     * libreria per la geolocalizzazione
     * 
     * Questa libreria contiene funzioni per lavorare con le coordinate geografiche e con gli indirizzi: calcolo delle
     * distanze, conversione fra gradi sessagesimali e decimali, scomposizione degli indirizzi.
     * 
     * introduzione
     * ============
     * Le funzioni di questa libreria non chiamano servizi esterni: fanno soltanto calcoli e parsing di stringhe. Per
     * ottenere le coordinate di un indirizzo tramite un servizio di geocoding si veda _src/_lib/_mapquest.tools.php.
     * Le coordinate decimali sono espresse in gradi, positive per nord ed est e negative per sud e ovest; i gradi
     * sessagesimali sono espressi come terna gradi, primi, secondi più la direzione (N, S, E, W).
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni di calcolo
     * -------------------
     * Le funzioni in questo gruppo servono per fare calcoli sulle coordinate.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * getCoordsDistance()              | calcola la distanza in chilometri fra due punti
     * 
     * funzioni di conversione
     * -----------------------
     * Le funzioni in questo gruppo servono per convertire le coordinate fra i vari formati.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * degrees2coords()                 | converte gradi, primi e secondi in coordinata decimale
     * coords2degrees()                 | converte una coordinata decimale in gradi, primi e secondi
     * string2degrees()                 | estrae gradi, primi, secondi e direzione da una stringa
     * string2coords()                  | converte una stringa in gradi sessagesimali in coordinata decimale
     * 
     * funzioni per gli indirizzi
     * --------------------------
     * Le funzioni in questo gruppo servono per manipolare gli indirizzi.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * splitAddress()                   | separa il numero civico dal resto dell'indirizzo
     * 
     * dipendenze
     * ==========
     * Questa libreria non ha dipendenze da altre librerie del framework; utilizza soltanto le funzioni native di PHP.
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
     * FUNZIONI DI CALCOLO
     */

    /**
     * calcola la distanza in chilometri fra due punti
     * 
     * Questa funzione calcola la distanza sulla superficie terrestre fra due punti dati in coordinate decimali, con la
     * legge sferica dei coseni: l'angolo al centro in gradi viene moltiplicato per 60 (un grado vale sessanta miglia
     * nautiche) e poi per 1,853 (i chilometri in un miglio nautico). È usata ad esempio da
     * _mod/_1000.produzione/_src/_lib/_mysql.utils.php per dare un punteggio di vicinanza.
     * 
     * NB: quando i due punti coincidono (o sono molto vicini) l'argomento di acos() per effetto degli arrotondamenti
     * può superare di poco 1, e fino al 2026-09-24 la funzione restituiva allora NAN invece di 0 (circa il 3% dei casi
     * con coordinate casuali identiche); ora l'argomento viene limitato all'intervallo [-1, 1].
     *
     * @param       float       $ltf    la latitudine del punto di partenza
     * @param       float       $lgf    la longitudine del punto di partenza
     * @param       float       $ltt    la latitudine del punto di arrivo
     * @param       float       $lgt    la longitudine del punto di arrivo
     * 
     * @return      float               la distanza fra i due punti in chilometri
     * 
     */
    function getCoordsDistance( $ltf, $lgf, $ltt, $lgt ) {

        $rad = M_PI / 180;

        $tha = $lgf - $lgt;

        $dst = sin( $ltf * $rad ) 
            * sin( $ltt * $rad ) + cos( $ltf * $rad )
            * cos( $ltt * $rad ) * cos( $tha * $rad );

        // limito l'argomento di acos() all'intervallo [-1, 1] per gli errori di arrotondamento
        $dst = max( -1, min( 1, $dst ) );

        return acos( $dst ) / $rad * 60 *  1.853;

    }

    /**
     * FUNZIONI DI CONVERSIONE
     */

    /**
     * converte gradi, primi e secondi in coordinata decimale
     * 
     * Questa funzione converte una coordinata espressa in gradi, primi e secondi nella corrispondente coordinata
     * decimale; il risultato è positivo se la direzione è 'N' o 'E', negativo per qualsiasi altro valore (quindi anche
     * per una direzione vuota o scritta in minuscolo).
     * 
     * @param       float       $deg    i gradi
     * @param       float       $min    i primi
     * @param       float       $sec    i secondi
     * @param       string      $dir    la direzione (N, S, E, W)
     * 
     * @return      float               la coordinata decimale
     * 
     */
    function degrees2coords( $deg, $min, $sec, $dir ) {
    
        $mod = ( in_array( $dir, array( 'N', 'E' ) ) ? 1 : -1 );

        return ( ( $deg + ( ( ( $min * 60) + ( $sec ) ) / 3600 ) ) * $mod );

    }
    
    /**
     * converte una coordinata decimale in gradi, primi e secondi
     * 
     * Questa funzione separa la parte intera di una coordinata decimale (i gradi, restituiti come stringa e con il
     * segno) dalla parte decimale, che converte in primi e secondi. La direzione non viene restituita: per le
     * coordinate negative il segno resta sui gradi. La separazione avviene sul punto della rappresentazione testuale del
     * numero, per cui se la coordinata non ha parte decimale (ad esempio 45) PHP emette un warning per l'indice mancante
     * e primi e secondi valgono zero.
     * 
     * @param       float       $dec    la coordinata decimale
     * 
     * @return      array               un array con le chiavi deg, min e sec
     * 
     */
    function coords2degrees( $dec ) {

        $vars = explode( '.', $dec );
        $deg = $vars[0];
        $tempma = '0.' . $vars[1];
    
        $tempma = $tempma * 3600;
        $min = floor( $tempma / 60 );
        $sec = $tempma - ( $min * 60 );
    
        return array( 'deg' => $deg, 'min' => $min, 'sec' => $sec );

    }

    /**
     * estrae gradi, primi, secondi e direzione da una stringa
     * 
     * Questa funzione cerca in una stringa una coordinata nel formato 45°30'15.5"N (accetta anche i simboli ′ ’ ″ ” e
     * gli spazi fra gradi, primi e secondi, ma non fra i secondi e la direzione) e restituisce un array con i quattro
     * elementi trovati, come stringhe. Se la stringa non corrisponde al formato restituisce un array vuoto. I numeri
     * possono contenere la virgola, ma i valori con la virgola non sono numerici per PHP e se passati a
     * degrees2coords() vengono troncati alla parte intera con un warning.
     * 
     * @param       string      $s      la stringa da analizzare
     * 
     * @return      array               un array con gradi, primi, secondi e direzione, oppure un array vuoto
     * 
     */
    function string2degrees( $s ) {

        // preg_match_all( '([0-9\.]+)°[\s]*([0-9\.]+)[\']+[\s]*([0-9\.]+)[\'\"]+[\s]*([NSWE]){1}', $s, $a );
        // preg_match_all( "/([0-9\.]+)°[\s]*([0-9\.]+)[\']+[\s]*([0-9\.]+)[\'\"]+[\s]*([NSWE]){1}/gm", $s, $a );
        // /([0-9\.]+)°[\s]*([0-9\.]+)[']{1}[\s]*([0-9\.]+)[\'\"]{1,2}[\s]*([NSWE]){1}/g
        // preg_match_all( '/([0-9\.]+)°[\s]*([0-9\.]+)/'[\s]*([0-9\.]+)[\'\"]+[\s]*([NSWE]){1}/g', $s, $a );
        // OK /([0-9.,]+)[°]{1}[\s]*([0-9.,]+)['′]{1}[\s]*([0-9.,]+)['"″]{1,2}[\s]*([NSWE]){1}/g
        // preg_match_all( '/([0-9]+)//', $s, $a );
        // OK? preg_match_all( '/([0-9.,]+)[°]{1}[\s]*([0-9.,]+)[\'′]{1}[\s]*([0-9.,]+)[\'"″]{1,2}[\s]*([NSWE]){1}/', $s, $a );
        // preg_match_all( "/([0-9.,]+)[°]{1}[\s]*([0-9.,]+)[']{1}[\s]*([0-9.,]+)['\"]{1,2}[\s]*([NSWE]){1}/", $s, $a );
        // OOK? preg_match_all( '/([0-9.,]+)°[\s]*([0-9.,]+)\'/', '23.1°11.2\'', $a );
        // preg_match_all( '/([0-9.,]+)°[\s]*([0-9.,]+)[\'′]+[\s]*([0-9.,]+)[\'"″]+([NSWE]{1})/', '23.1°11.2\' 15,7"', $a );

        // preg_match( '/([0-9.,]+)°[\s]*([0-9.,]+)[\'′]+[\s]*([0-9.,]+)[\'"″]+([NSWE]{1})/', $s, $a );
        preg_match( '/([0-9.,]+)°[\s]*([0-9.,]+)[\'′’]+[\s]*([0-9.,]+)[\'"″”]+([NSWE]{1})/', $s, $a );

        // print_r( array_slice( $a, 1 ) );

        return array_slice( $a, 1 );

    }

    /**
     * converte una stringa in gradi sessagesimali in coordinata decimale
     * 
     * Questa funzione analizza la stringa con string2degrees() e converte il risultato con degrees2coords(). Se la
     * stringa non è nel formato previsto gli indici dell'array sono assenti, PHP emette dei warning e il risultato è
     * zero invece di un valore di errore.
     * 
     * @param       string      $s      la stringa da convertire, ad esempio 45°30'15"N
     * 
     * @return      float               la coordinata decimale
     * 
     */
    function string2coords( $s ) {

        $a = string2degrees( $s );

        return degrees2coords( $a[0], $a[1], $a[2], $a[3] );

    }

    /**
     * FUNZIONI PER GLI INDIRIZZI
     */

    /**
     * separa il numero civico dal resto dell'indirizzo
     * 
     * Questa funzione cerca il civico in fondo all'indirizzo (una o più cifre seguite eventualmente da cifre, lettere
     * o barre, come 5, 20 o 20/A, separate dal resto con uno spazio o una virgola) e restituisce separatamente
     * l'indirizzo, ripulito da spazi e virgole ai bordi, e il civico; il civico viene tolto solo dalla fine della
     * stringa, per cui "Via 20 Settembre 20" diventa "Via 20 Settembre" e "20". Se il civico non viene trovato la
     * chiave civico è NULL e l'indirizzo è quello passato, ripulito allo stesso modo.
     *
     * NB: fino al 2026-09-24 l'espressione regolare richiedeva almeno due caratteri ( "Via Roma 5" restava senza
     * civico ) e il civico veniva tolto con str_replace() da tutto l'indirizzo ( "Via 20 Settembre 20" diventava
     * "Via  Settembre" ).
     *
     * @param       string      $a      l'indirizzo completo di civico
     * 
     * @return      array               un array con le chiavi indirizzo e civico
     * 
     */
    function splitAddress( $a ) {

        // $a = strtolower( $a );

        // trovo il civico
        preg_match( '/(^|[\s,])([0-9]+[\/0-9a-zA-Z]*)\s*$/', $a, $pCivici );
        $pCivico = ( is_array( $pCivici ) && ! empty( $pCivici ) ) ? $pCivici[2] : NULL;

        // pulisco l'indirizzo, togliendo il civico solo dalla fine
        $pIndirizzo = trim( ( ( $pCivico === NULL ) ? $a : substr( rtrim( $a ), 0, - strlen( $pCivico ) ) ), ' ,' );

        return array( 'indirizzo' => $pIndirizzo, 'civico' => $pCivico );

    }
