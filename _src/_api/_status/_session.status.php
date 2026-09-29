<?php

    /**
     * alias di _session.php per i template Athena legacy
     *
     * Le copie di Athena legacy nei custom interrogano /status/session.status ogni minuto: questo file resta per
     * loro e risponde come /status/session.
     *
     * @file
     *
     */

    // fallback su _session.php
    require '_session.php';
