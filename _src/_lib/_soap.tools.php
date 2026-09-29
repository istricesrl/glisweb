<?php

    /**
     * segnaposto per una libreria SOAP di progetto
     *
     * Questo file è vuoto di proposito e non va cancellato: esiste perché un progetto possa avere la sua
     * src/lib/soap.tools.php.
     *
     * introduzione
     * ============
     * _src/_config.php carica solo le librerie che hanno un file standard: fa glob() su _src/_lib/_*.*.php ( e sulle
     * _src/_lib/ dei moduli attivi ) e per ciascun file cerca la controparte custom con path2custom(), che se esiste
     * viene inclusa al posto dello standard ( o, col suffisso .add.php, dopo di esso ). Un file in src/lib/ senza il
     * suo gemello in _src/_lib/ non viene incluso mai. È una scelta di progetto: solo ciò che ha una controparte
     * standard si può customizzare.
     *
     * Il framework non ha un client SOAP proprio; questo file vuoto è il gancio che permette a un progetto che ne ha
     * bisogno di scriverne uno in src/lib/soap.tools.php e di vederlo caricato con le altre librerie.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Questa libreria non definisce funzioni.
     *
     * dipendenze
     * ==========
     * Questa libreria non ha dipendenze.
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */
