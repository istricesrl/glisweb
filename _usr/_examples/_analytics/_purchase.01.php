<?php

    require '../../../_src/_config.php';

    ga4purchase(
        $cf['google']['profile']['analytics']['ua'],
        $cf['google']['profile']['analytics']['mp']['secret'],
        $cf['session']['carrello']
    );
