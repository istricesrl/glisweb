<?php

    /**
     * macro della scheda di un SMS inviato
     *
     * Macro della pagina `sms.sent.form`: dichiara `sms_sent` come tabella gestita e lascia il resto alla macro di default;
     * il template è `sms.sent.form.twig` del modulo. Ricalca `_mail.sent.form.php` del modulo `MA000.mail`.
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'sms_sent';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
