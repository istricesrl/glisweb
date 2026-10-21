<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     */

    /**
     * 
     * TODO documentare 
     * 
     */
    function tendinaTipologieListini() {

        global $cf;

        return mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_listini_view ORDER BY __label__'
        );

    }


    /**
     * restituisce gli ID dei listini di acquisto
     *
     * Un listino è di acquisto quando ha un emittente e l'emittente non è una delle aziende gestite
     * ( tendinaAziendeGestite() ); tutti gli altri, compresi quelli senza emittente, sono di vendita. La
     * funzione serve alle viste dei listini di vendita, che con le sole restrizioni di __restrict__ non
     * possono dire "emittente vuoto oppure fra le aziende gestite": le viste escludono invece gli ID
     * restituiti da qui.
     *
     * @return      array       gli ID dei listini di acquisto, eventualmente vuoto
     *
     */
    function listiniAcquistoId() {

        global $cf;

        return mysqlSelectColumn(
            'id',
            $cf['mysql']['connection'],
            'SELECT id FROM listini WHERE id_emittente IS NOT NULL AND NOT FIND_IN_SET( id_emittente, ? )',
            array( array( 's' => implode( ',', array_column( tendinaAziendeGestite() ?: array(), 'id' ) ) ) )
        );

    }
