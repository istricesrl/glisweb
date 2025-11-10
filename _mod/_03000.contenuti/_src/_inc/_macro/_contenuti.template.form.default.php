<?php

    // ...
    if( $ct['page']['id'] != 'contenuti.template.form.editor' ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['contenuti.template.form.editor']
        );
    }
