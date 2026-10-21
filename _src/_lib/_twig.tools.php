<?php

    /**
     * libreria per l'uso di Twig fuori dai template di pagina
     *
     * Questa libreria contiene le funzioni che servono quando Twig ( twig/twig, Composer ) compila testi che non sono
     * template di pagina: stampe, destinatari delle mail, testi composti al volo.
     *
     * introduzione
     * ============
     * Compilare con Twig un testo che contiene dati scritti da un utente è pericoloso: Twig esegue la sintassi che trova,
     * e un nome come {{['id']|map('system')}} fa eseguire un comando al server. I dati dell'utente vanno quindi sempre
     * passati nel contesto e richiamati coi segnaposto; dove questo non si può garantire, il testo si pulisce prima con
     * twigPulisci().
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono.
     *
     * funzioni di compilazione
     * ------------------------
     * Le funzioni in questo gruppo compilano testi con Twig.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * twigRenderText()                 | compila con Twig un array di template, anche annidato
     *
     * funzioni di sicurezza
     * ---------------------
     * Le funzioni in questo gruppo rendono innocui i testi prima che arrivino a Twig.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * twigPulisci()                    | neutralizza la sintassi Twig in una stringa
     *
     * dipendenze
     * ==========
     * Questa libreria non dipende da altre funzioni del framework; richiede twig/twig ( Composer ).
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-10-14       | Fabio Mosti          | aggiunta twigPulisci() contro l'esecuzione di codice via Twig
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * FUNZIONI DI COMPILAZIONE
     */

    /**
     * compila con Twig un array di template, anche annidato
     *
     * Questa funzione compila con Twig ogni elemento dell'array, scendendo negli array annidati, e sostituisce ogni
     * template con il testo prodotto.
     *
     * @param       array       $tpls       l'array dei template, modificato sul posto
     * @param       array       $dati       il contesto passato a Twig
     *
     * @return      void
     *
     */
    function twigRenderText( &$tpls, $dati ) {

        $twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $tpls ) );

        foreach( $tpls as $key => $tpl ) {

            if( is_array( $tpls[ $key ] ) ) {
                twigRenderText( $tpls[ $key ], $dati );
            } else {
                $tpls[ $key ] = $twig->render( $key, $dati );
            }

        }

    }

    /**
     * FUNZIONI DI SICUREZZA
     */

    /**
     * neutralizza la sintassi Twig in una stringa
     *
     * Questa funzione spezza ogni delimitatore Twig ( {{, {% e {# ) inserendo uno spazio dopo la graffa, così Twig lo
     * tratta come testo e lo restituisce com'è; anche {{{ diventa innocuo. Con $segnaposto vero lascia intatti i
     * segnaposto puri, cioè un percorso di variabile senza filtri, chiamate né indici ( {{ dt.email }} ), e neutralizza
     * tutto il resto: è la forma da usare sui testi che devono poter richiamare il contesto, come i destinatari di
     * queueMailFromTemplate(). Un valore che non è una stringa viene convertito; una stringa vuota resta vuota.
     *
     * Un segnaposto puro scritto da un utente viene comunque risolto, ma legge solo il contesto passato a Twig e non
     * può eseguire codice: nel contesto non va messo niente che non debba finire nel testo prodotto.
     *
     * @param       mixed       $s              il testo da pulire
     * @param       bool        $segnaposto     vero per lasciare intatti i segnaposto puri, falso ( default ) per
     *                                          neutralizzare tutto
     *
     * @return      string                      il testo pulito
     *
     */
    function twigPulisci( $s, $segnaposto = false ) {

        // NB una graffa in fondo a un pezzo si spezza anche lei, perché subito dopo può venire un segnaposto
        // lasciato intatto, e insieme formerebbero un delimitatore ( {{{ dt.email }} )
        $parti = ( $segnaposto ) ? preg_split( '/(\{\{\s*[A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z0-9_]+)*\s*\}\})/', (string) $s, -1, PREG_SPLIT_DELIM_CAPTURE ) : array( (string) $s );

        // i pezzi pari sono testo, i dispari segnaposto puri
        foreach( $parti as $i => $parte ) {
            if( $i % 2 == 0 ) {
                $parti[ $i ] = preg_replace( '/\{(?=[{%#]|$)/', '{ ', $parte );
            }
        }

        return implode( '', $parti );

    }
