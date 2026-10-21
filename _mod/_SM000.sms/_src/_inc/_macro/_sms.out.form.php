<?php

    /**
     * macro della scheda di un SMS in uscita
     *
     * Macro della pagina `sms.out.form`: dichiara `sms_out` come tabella gestita e lascia il resto alla macro di default;
     * il template è `sms.out.form.twig` del modulo. Ricalca `_mail.out.form.php` del modulo `MA000.mail`.
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'sms_out';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
