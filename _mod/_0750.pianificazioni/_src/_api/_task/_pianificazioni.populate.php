<?php

    /**
     * il riempitore che gira ad es. ogni minuto e crea fisicamente gli oggetti. Questo prende le pianificazioni
     * che hanno data_fine > data_ultimo_oggetto e vede se ci sono oggetti da creare, li crea, aggiorna data_ultimo_oggetto
     * e pareggia data_fine = data_ultimo_oggetto > nome del task: _pianificazioni.populate.php
     */

    // NOTA usare le funzioni di ACL per verificare se l'azione è autorizzata
