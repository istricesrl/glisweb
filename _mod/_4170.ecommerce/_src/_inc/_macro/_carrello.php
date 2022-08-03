<?php

    $ct['etc']['id_provincia'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT provincie.nome AS __label__, provincie.sigla, provincie.id '
        .'FROM provincie '
        .'ORDER BY __label__ '
    );
