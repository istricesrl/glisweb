<?php

    /**
     * esempio di string2rewrite()
     *
     * L'output è controllato da _usr/_test/_tests/unit/rewriteToolsCest.php: un titolo normale non deve cambiare,
     * e i caratteri che la RewriteRule del .htaccess non accetta ( # e = ) devono sparire dallo slug.
     *
     */

    require '../../../../_src/_config.php';

    var_dump( string2rewrite( 'Caffè & Tè: 10% più' ) );
    var_dump( string2rewrite( 'USA1941 Motore FANUC A06B0313B-006#7000' ) );
    var_dump( string2rewrite( 'WEB1583832616 Fresa Coromant D40,0 Z=26' ) );
