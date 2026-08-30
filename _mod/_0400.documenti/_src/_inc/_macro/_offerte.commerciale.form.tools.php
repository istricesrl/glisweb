<?php

    /**
     * macro degli strumenti delle offerte
     *
     * La scheda strumenti e' fra i tab di offerte.commerciale.form fin da quando le pagine delle
     * offerte sono state scritte, ma questa macro non esisteva: aprendola si otteneva
     * "impossibile trovare la macro di pagina". Per ora la scheda e' vuota, cioe' si apre e non
     * offre nessuna operazione; gli strumenti si aggiungono qui quando servono, con la stessa forma
     * usata in _documenti.form.tools.php ( voci in $ct['page']['contents']['metro'][ <gruppo> ] e
     * gruppi dichiarati in $ct['page']['contents']['metros'] ).
     *
     * @todo implementare gli strumenti delle offerte
     *
     * @file
     *
     */

    // tabella della vista
    $ct['form']['table'] = 'documenti';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';
