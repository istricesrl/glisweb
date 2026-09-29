<?php

    /**
     * libreria per la verifica delle stringhe JSON
     *
     * Questa libreria contiene funzioni per verificare se una stringa contiene JSON valido e per decodificarla
     * segnalando il tipo di errore.
     *
     * introduzione
     * ============
     * Le funzioni di questa libreria sono un sottile strato sopra json_decode() e json_last_error(); servono quando
     * prima di utilizzare una stringa che dovrebbe contenere JSON si vuole sapere se è valida. Al momento della stesura
     * di questa documentazione nessun file del framework o dei moduli le richiama.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     *
     * funzioni di verifica
     * --------------------
     * Le funzioni in questo gruppo servono per verificare la validità delle stringhe JSON.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * jsonCheck()                      | verifica se una stringa contiene JSON valido
     * jsonValidate()                   | decodifica una stringa JSON scrivendo nel log l'eventuale errore
     *
     * dipendenze
     * ==========
     * Questa libreria non ha dipendenze da altre librerie del framework; oltre alle funzioni native di PHP richiede
     * soltanto la seguente funzione:
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
     * FUNZIONI DI VERIFICA
     */

    /**
     * verifica se una stringa contiene JSON valido
     *
     * Questa funzione prova a decodificare la stringa con json_decode() e restituisce true se non si è verificato
     * alcun errore, false altrimenti; il risultato della decodifica viene scartato. Una stringa vuota non è JSON
     * valido e produce false, mentre la stringa 'null' è JSON valido e produce true.
     *
     * @param       string      $string     la stringa da verificare
     *
     * @return      bool                    true se la stringa è JSON valido, false altrimenti
     *
     */
function jsonCheck($string) {
 json_decode($string);
 return (json_last_error() == JSON_ERROR_NONE);
}

    /**
     * decodifica una stringa JSON scrivendo nel log l'eventuale errore
     *
     * Questa funzione decodifica la stringa con json_decode() (gli oggetti JSON diventano quindi oggetti stdClass e non
     * array associativi) e ne restituisce il risultato; se la decodifica fallisce scrive nel log json, a livello LOG_ERR,
     * il messaggio in inglese corrispondente al codice di json_last_error() e restituisce false. Una stringa vuota è
     * considerata errore di sintassi. Poiché anche la stringa 'false' decodificata vale false, per distinguere i due casi
     * si usi jsonCheck().
     *
     * NB: fino al 2026-09-24 in caso di errore la funzione terminava lo script con exit() stampando il messaggio; nel
     * framework non ha chiamanti, e una funzione di libreria non deve decidere di fermare chi la chiama.
     *
     * @param       string      $string     la stringa JSON da decodificare
     *
     * @return      mixed                   il valore decodificato, oppure false se la decodifica non è riuscita
     *
     */
function jsonValidate($string)
{
    // decode the JSON data
    $result = json_decode($string);

    // switch and check possible JSON errors
    switch (json_last_error()) {
        case JSON_ERROR_NONE:
            $error = ''; // JSON is valid // No error has occurred
            break;
        case JSON_ERROR_DEPTH:
            $error = 'The maximum stack depth has been exceeded.';
            break;
        case JSON_ERROR_STATE_MISMATCH:
            $error = 'Invalid or malformed JSON.';
            break;
        case JSON_ERROR_CTRL_CHAR:
            $error = 'Control character error, possibly incorrectly encoded.';
            break;
        case JSON_ERROR_SYNTAX:
            $error = 'Syntax error, malformed JSON.';
            break;
        // PHP >= 5.3.3
        case JSON_ERROR_UTF8:
            $error = 'Malformed UTF-8 characters, possibly incorrectly encoded.';
            break;
        // PHP >= 5.5.0
        case JSON_ERROR_RECURSION:
            $error = 'One or more recursive references in the value to be encoded.';
            break;
        // PHP >= 5.5.0
        case JSON_ERROR_INF_OR_NAN:
            $error = 'One or more NAN or INF values in the value to be encoded.';
            break;
        case JSON_ERROR_UNSUPPORTED_TYPE:
            $error = 'A value of a type that cannot be encoded was given.';
            break;
        default:
            $error = 'Unknown JSON error occured.';
            break;
    }

    if ($error !== '') {
        // scrivo l'errore nel log e restituisco false invece di terminare lo script
        logger('errore nella decodifica JSON: ' . $error, 'json', LOG_ERR);
        return false;
    }

    // everything is OK
    return $result;
}

