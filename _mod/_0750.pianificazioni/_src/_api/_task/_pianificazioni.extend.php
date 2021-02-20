<?php

    /**
     * l'allungatore che gira ad es. una volta a settimana e deve allungare la pianificazione. Questo prende tutte le pianificazioni tali
     * per cui (giorni_rinnovo > 0 AND data_fine < oggi + giorni_rinnovo) che quindi sono da allungare e aggiorna
     * data_fine = oggi + giorni_rinnovo > nome del task: _pianificazioni.extend.php
     */

    // NOTA usare le funzioni di ACL per verificare se l'azione è autorizzata
