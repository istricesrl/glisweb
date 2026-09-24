<?php

    /**
     * libreria per la gestione dei file a larghezza di colonna fissa
     * 
     * Questa libreria è destinata a contenere le funzioni per leggere e scrivere i dati in formato a larghezza di colonna
     * fissa; al momento è soltanto un segnaposto e non contiene alcuna funzione.
     * 
     * introduzione
     * ============
     * Nel formato a larghezza di colonna fissa ( detto anche "fixed width", da cui l'acronimo FSV ) ogni riga del file
     * rappresenta una riga di una tabella e ogni campo occupa sempre lo stesso numero di caratteri, completato con spazi
     * o zeri di riempimento; non esistono quindi separatori né delimitatori, e per leggere un campo occorre conoscere la
     * sua posizione di partenza e la sua lunghezza. È un formato tipico dei tracciati bancari e degli scambi con i sistemi
     * gestionali più datati.
     * 
     * La libreria dovrà offrire per questo formato le stesse operazioni che _csv.tools.php offre per il formato CSV,
     * seguendone l'architettura e la convenzione dei nomi delle funzioni; fino ad allora il file esiste soltanto perché
     * il posto sia già riservato. Essendo un file _*.*.php in _src/_lib/ viene comunque caricato da _src/_config.php
     * insieme alle altre librerie, senza effetti.
     * 
     * TODO implementare sul modello di _csv.tools.php
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     * 
     * funzioni
     * ========
     * Questa libreria non definisce ancora funzioni.
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
