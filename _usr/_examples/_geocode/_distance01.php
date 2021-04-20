<?php

    /**
     * test delle cache
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // NOTA la latitudine si riferisce all'asse N/S la longitudine all'asse E/W

    // Piazza Maggiore a Bologna si trova a 44°29′37.28″N 11°20′34.98″E
    // Melbourne in Australia si trova a -37.840935, and the longitude is 144.946457 (37° 50' 27.3660'' S and 144° 56' 47.2452'')
    // la distanza fra Bologna e Melbourne è 16,115.80 km
    echo 'Piazza Maggiore a Bologna si trova a ' . string2coords( '44°29\'37.28"N' ) . 'lt ' . string2coords( '11°20\'34.98"E' ) . 'lg' . HTML_EOL;
    echo 'Melbourne in Australia si trova a ' . string2coords( '37°50′27.366″S' ) . 'lt ' . string2coords( '144°56′47.2452″E' ) . 'lg' . HTML_EOL;
    echo 'la distanza fra Piazza Maggiore e Melbourne è ' . m2km( getCoordsDistance( string2coords( '44°29\'37.28"N' ), string2coords( '11°20\'34.98"E' ), string2coords( '37°50′27.366″S' ), string2coords( '144°56′47.2452″E' ) ) ) . 'km' . HTML_EOL;
