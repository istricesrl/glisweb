<?php

    /**
     * libreria per la gestione della localizzazione
     * 
     * La gestione delle lingue, della localizzazione, dei charset, è un'attività che può presentare complessità non banali. Questa libreria
     * semplifica la gestione di questi aspetti in modo da semplificare e irrobustire il codice.
     * 
     * introduzione
     * ============
     * La localizzazione è quell'insieme di attività che permette di adattare un'applicazione a un determinato contesto culturale. Questo
     * richiede l'utilizzo di tecniche anche piuttosto complesse, motivo per cui si è ritenuto opportuno creare una libreria apposita.
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti proprie.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in due gruppi, le funzioni per la gestione del multilingua e le funzioni per la gestione dei
     * charset.
     * 
     * funzioni per la gestione del multilingua
     * ----------------------------------------
     * Queste funzioni rispondono all'esigenza di gestire correttamente gli scenari multilingua.
     * 
     * funzione                             | descrizione
     * -------------------------------------|---------------------------------------------------------------
     * parseHttpRequestedLanguage()         | legge le lingue richieste dal client
     * 
     * funzioni per la gestione dei charset
     * ------------------------------------
     * Queste funzioni aiutano a gestire la trasformazione da un charset all'altro, l'identificazione del charset e altre attività simili.
     * 
     * funzione                             | descrizione
     * -------------------------------------|---------------------------------------------------------------
     * string2utf8()                        | converte una stringa in UTF-8
     * 
     * dipendenze
     * ==========
     * questa libreria non ha dipendenze.
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2024-02-05       | Fabio Mosti          | refactoring completo della libreria
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    /**
     * ricava la lingua dal browser
     * 
     * Questa funzione analizza l'header $_SERVER['HTTP_ACCEPT_LANGUAGE'] inviato dal browser per capire quale
     * lingua utilizzare.
     *
     * @return        string            il valore della lingua corrente del browser
     *
     */
    function parseHttpRequestedLanguage()
    {

        $langs = array();

        if (isset($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {

            preg_match_all('/([a-z]{1,8}(-[a-z]{1,8})?)\s*(;\s*q\s*=\s*(1|0\.[0-9]+))?/i', $_SERVER['HTTP_ACCEPT_LANGUAGE'], $lang_parse);

            if (count($lang_parse[1])) {

                $langs = array_combine($lang_parse[1], $lang_parse[4]);

                foreach ($langs as $lang => $val) {
                    if ($val === '') $langs[$lang] = 1;
                }

                arsort($langs, SORT_NUMERIC);
            }
        }

        return $langs;
    }

    /**
     * ricodifica una stringa in UTF-8
     *
     * Questa funzione ricodifica in UTF-8 una stringa o un array. Originariamente
     * sviluppata da Silvia De Falco
     * 
     * @param        mixed        $mixed        la stringa o l'array da ricodificare
     *
     * @return       mixed                      la stringa o l'array ricodificati
     *
     */
    function string2utf8($mixed, $encoding = null)
    {
        if( is_array( $mixed ) ) {
            // Se è un array, ricodifica ogni elemento ricorsivamente
            foreach ($mixed as $key => $value) {
                $mixed[$key] = string2utf8($value, $encoding);
            }
            return $mixed;
        } else {
            if ($encoding === null) {
                $encoding = mb_detect_encoding($mixed, mb_detect_order(), true);
            }
            if (is_array($mixed)) {
                foreach ($mixed as $key => $value) {
                    $mixed[$key] = string2utf8($value, $encoding);
                }
            } elseif (is_string($mixed)) {
                return mb_convert_encoding($mixed, "UTF-8", $encoding);
            }
            return $mixed;
        }
    }
