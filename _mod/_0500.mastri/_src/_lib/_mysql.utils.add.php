<?php

    /**
     * 
     * @todo documentare
     * 
     */
    function updateReportGiacenzaMagazzini( $idMastro, $idArticolo, $idMatricola = NULL ) {

        global $cf;

        $riga['id'] = trim( implode( '|', array( $idMastro, $idArticolo, $idMatricola ) ), '|' );

        $riga['id_mastro'] = $idMastro;

        $riga['nome'] = mysqlSelectCachedValue(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT mastri_path( ? )',
            array(
                array( 's' => $idMastro )
            )
        );

        $riga['id_articolo'] = $idArticolo;

        print_r( $riga );

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function cleanReportGiacenzaMagazzini() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function updateReportGiacenzaMagazziniFoglie() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function cleanReportGiacenzaMagazziniFoglie() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function updateReportGiacenzaMagazziniFoglieAttive() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function cleanReportGiacenzaMagazziniFoglieAttive() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function updateReportMovimentiMagazzini() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function cleanReportMovimentiMagazzini() {}
