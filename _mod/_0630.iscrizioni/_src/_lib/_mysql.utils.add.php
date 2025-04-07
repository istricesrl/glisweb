<?php

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function cleanIscrizioniViewStatic() {

        global $cf;

        return mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE iscrizioni_view_static FROM iscrizioni_view_static
            LEFT JOIN contratti ON contratti.id = iscrizioni_view_static.id
            WHERE contratti.id IS NULL;'
        );

    }

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function emptyIscrizioniViewStatic() {

        global $cf;

        return mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM iscrizioni_view_static;'
        );

    }
