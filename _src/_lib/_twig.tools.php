<?php

    function twigRenderText( &$tpls, $dati ) {

        $twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $tpls ) );

        foreach( $tpls as $key => $tpl ) {

            if( is_array( $tpls[ $key ] ) ) {
                twigRenderText( $tpls[ $key ], $dati );
            } else {
                $tpls[ $key ] = $twig->render( $key, $dati );
            }

        }

    }
