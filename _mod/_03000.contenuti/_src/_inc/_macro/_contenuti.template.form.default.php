<?php

    /**
     * macro di default per i form dei contenuti
     * 
     * Questa macro contiene logiche comuni a tutte le schede della gestione dei contenuti.
     * 
     * 
     * 
     */

    // rimuovo la tab dell'editor se non sono nella pagina dell'editor
    if( $ct['page']['id'] != 'contenuti.template.form.editor' ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['contenuti.template.form.editor']
        );
    }
