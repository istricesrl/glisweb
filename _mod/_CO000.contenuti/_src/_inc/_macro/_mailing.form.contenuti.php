<?php

    /**
     * contenuti del mailing
     *
     * Mittente, oggetto e testo del mailing, una riga di `contenuti` per lingua; `_genera.mail.php` di
     * `_ML000.mailing` li legge per comporre le mail. Sul modello di `_mail.template.form.contenuti.php`.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'mailing';

    // sotto tabella gestita
    $ct['form']['subtable'] = 'contenuti';

    // macro di default per i contenuti multilingua
    require DIR_SRC_INC_MACRO . '_default/_default.form.multilingua.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
