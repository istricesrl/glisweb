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
     *
     * TODO documentare
     *
     */
    function parseHttpRequestedLanguage()
    {

        $langs = array();

        if (isset($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
            // break up string into pieces (languages and q factors)
            preg_match_all('/([a-z]{1,8}(-[a-z]{1,8})?)\s*(;\s*q\s*=\s*(1|0\.[0-9]+))?/i', $_SERVER['HTTP_ACCEPT_LANGUAGE'], $lang_parse);

            if (count($lang_parse[1])) {
                // create a list like "en" => 0.8
                $langs = array_combine($lang_parse[1], $lang_parse[4]);

                // set default to 1 for any without q factor
                foreach ($langs as $lang => $val) {
                    if ($val === '') $langs[$lang] = 1;
                }

                // sort list based on value
                arsort($langs, SORT_NUMERIC);
            }
        }

        return $langs;
    }

    /**
     * SDF funzione per ricodificare in UTF-8 (utile anche per contenuto da codificare in Json
     * 
     * TODO documentare
     *
     */
    function string2utf8($mixed)
    {
        if (is_array($mixed)) {
            foreach ($mixed as $key => $value) {
                $mixed[$key] = string2utf8($value);
            }
        } elseif (is_string($mixed)) {
            return mb_convert_encoding($mixed, "UTF-8", "UTF-8");
        }
        return $mixed;
    }
