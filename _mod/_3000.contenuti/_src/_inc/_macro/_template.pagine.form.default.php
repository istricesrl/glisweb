<?php

    // ...
    if( $ct['page']['id'] != 'template.pagine.form.editor' ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['template.pagine.form.editor']
        );
    }
