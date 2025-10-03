<?php

    /**
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    /**
     *
     * TODO documentare
     * 
     */
    function tendinaCategorieAnagrafica() {

        global $cf;

        return mysqlCachedQuery(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM categorie_anagrafica_view'
        );

    }

    /**
     *
     * TODO documentare
     * 
     */
    function tendinaIdAnagraficaCollaboratori() {

        global $cf;

        return mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static'
        );

    }

    /**
     * 
     * 
     * TODO documentare
     * 
     */
    function updateAnagraficaViewStatic($id)
    {

        global $cf;

        // var_dump( $id );

        $riga = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT
                    anagrafica.id,
                    tipologie_anagrafica.nome AS tipologia,
                    anagrafica.codice,
                    anagrafica.riferimento,
                    anagrafica.nome,
                    anagrafica.cognome,
                    anagrafica.denominazione,
                    anagrafica.soprannome,
                    anagrafica.sesso,
                    anagrafica.codice_fiscale,
                    anagrafica.partita_iva,
                    ranking.nome AS ranking,
                    anagrafica.recapiti,
                    anagrafica.anno_nascita,
                    anagrafica.mese_nascita,
                    anagrafica.giorno_nascita,
                    concat_ws( \'-\', anagrafica.anno_nascita, lpad( anagrafica.mese_nascita, 2, \'0\' ), lpad( anagrafica.giorno_nascita, 2, \'0\' ) ) AS data_nascita,
                    anagrafica.id_comune_nascita,
                    anagrafica.data_archiviazione,
                    anagrafica.id_account_inserimento,
                    anagrafica.timestamp_inserimento,
                    anagrafica.id_account_aggiornamento,
                    anagrafica.timestamp_aggiornamento
                FROM anagrafica
                    LEFT JOIN tipologie_anagrafica ON tipologie_anagrafica.id = anagrafica.id_tipologia
                    LEFT JOIN ranking ON ranking.id = anagrafica.id_ranking
                WHERE anagrafica.id = ? ',
            array(
                array('s' => $id)
            )
        );

        // print_r( $riga );

        if (! empty($riga['id'])) {

            updateAnagraficaViewStaticCategorie($id, $riga);

            updateAnagraficaViewStaticTelefoni($id, $riga);

            updateAnagraficaViewStaticMail($id, $riga);

            updateAnagraficaViewStaticIndirizzi($id, $riga);

            $tRef = time();

            foreach (array('timestamp_inserimento', 'timestamp_aggiornamento') as $fRef) {
                if (empty($riga[$fRef])) {
                    $riga[$fRef] = $tRef;
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE anagrafica SET ' . $fRef . ' = ? WHERE id = ?',
                        array(
                            array('s' => $riga[$fRef]),
                            array('s' => $riga['id'])
                        )
                    );
                }
            }

            // $riga['__label__'] = ( ! empty( $riga['soprannome'] ) ) ? $riga['soprannome'] : ( ( ! empty( $riga['denominazione'] ) ) ? $riga['denominazione'] : ( trim( implode( ' ', array( $riga['nome'], $riga['cognome'] ) ) ) ) );
            $riga['__label__'] = (
                (
                    (! empty($riga['codice']))
                    ? $riga['codice'] . ' '
                    : NULL
                )
                .
                (
                    (! empty($riga['soprannome']))
                    ? $riga['soprannome']
                    : (
                        (! empty($riga['denominazione']))
                        ? $riga['denominazione']
                        : (trim(implode(' ', array($riga['nome'], $riga['cognome']))))
                    )
                )
            );

            mysqlInsertRow(
                $cf['mysql']['connection'],
                $riga,
                'anagrafica_view_static'
            );
        } else {

            mysqlQuery($cf['mysql']['connection'], 'DELETE FROM anagrafica_view_static WHERE id = ?', array(array('s' => $id)));

        }

    }

    /**
     * 
     * 
     * 
     * TODO documentare
     * 
     */
    function updateAnagraficaViewStaticCategorie($id, &$riga = NULL)
    {

        global $cf;

        $categorie = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT
                    max( categorie_anagrafica.se_prospect ) AS se_prospect,
                    max( categorie_anagrafica.se_lead ) AS se_lead,
                    max( categorie_anagrafica.se_cliente ) AS se_cliente,
                    max( categorie_anagrafica.se_fornitore ) AS se_fornitore,
                    max( categorie_anagrafica.se_produttore ) AS se_produttore,
                    max( categorie_anagrafica.se_collaboratore ) AS se_collaboratore,
                    max( categorie_anagrafica.se_interno ) AS se_interno,
                    max( categorie_anagrafica.se_esterno ) AS se_esterno,
                    max( categorie_anagrafica.se_commerciale ) AS se_commerciale,
                    max( categorie_anagrafica.se_concorrente ) AS se_concorrente,
                    max( categorie_anagrafica.se_gestita ) AS se_gestita,
                    max( categorie_anagrafica.se_amministrazione ) AS se_amministrazione,
                    max( categorie_anagrafica.se_notizie ) AS se_notizie,
                    group_concat( DISTINCT categorie_anagrafica_path( categorie_anagrafica.id ) SEPARATOR \' | \' ) AS categorie
                FROM anagrafica_categorie
                    LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
                WHERE anagrafica_categorie.id_anagrafica = ? ',
            array(
                array('s' => $id)
            )
        );

        if (! empty($riga)) {

            $riga = array_merge(
                $riga,
                $categorie
            );
        } else {

            $riga['id'] = $id;

            mysqlInsertRow(
                $cf['mysql']['connection'],
                $riga,
                'anagrafica_view_static'
            );
        }

        $tCat = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( timestamp_aggiornamento ) FROM anagrafica_categorie WHERE id_anagrafica = ?',
            array(array('s' => $riga['id']))
        );

        if ($tCat > $riga['timestamp_aggiornamento']) {
            $riga['timestamp_aggiornamento'] = $tCat;
        }
    }

    /**
     * 
     * 
     * 
     * TODO documentare
     * 
     */
    function updateAnagraficaViewStaticIndirizzi($id, &$riga = NULL)
    {

        global $cf;

        $indirizzi = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT regioni.id_stato, comuni.id_provincia
                FROM anagrafica_indirizzi
                    LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
                    LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
                    LEFT JOIN provincie ON provincie.id = comuni.id_provincia
                    LEFT JOIN regioni ON regioni.id = provincie.id_regione
                    LEFT JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo
                WHERE anagrafica_indirizzi.id_anagrafica = ? 
                AND anagrafica_indirizzi.indirizzo IS NULL
                ORDER BY ruoli_indirizzi.se_sede_legale DESC
                LIMIT 1 ',
            array(
                array('s' => $id)
            )
        );

        if (! empty($riga)) {

            $riga = array_merge(
                $riga,
                $indirizzi
            );
        } else {

            $riga['id'] = $id;

            mysqlInsertRow(
                $cf['mysql']['connection'],
                $riga,
                'anagrafica_view_static'
            );
        }
    }

    /**
     * 
     * 
     * 
     * TODO documentare
     * 
     */
    function updateAnagraficaViewStaticTelefoni($id, &$riga = NULL)
    {

        global $cf;

        $telefoni = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT
                    group_concat( DISTINCT telefoni.numero SEPARATOR \' | \' ) AS telefoni
                FROM telefoni
                WHERE id_anagrafica = ? ',
            array(
                array('s' => $id)
            )
        );

        if (! empty($riga)) {

            $riga = array_merge(
                $riga,
                $telefoni
            );
        } else {

            $riga['id'] = $id;

            mysqlInsertRow(
                $cf['mysql']['connection'],
                $riga,
                'anagrafica_view_static'
            );
        }
    }

    /**
     * 
     * 
     * TODO documentare
     * 
     * 
     */
    function updateAnagraficaViewStaticMail($id, &$riga = NULL)
    {

        global $cf;

        $mail = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT
                    group_concat( DISTINCT mail.indirizzo SEPARATOR \' | \' ) AS mail
                FROM mail
                WHERE id_anagrafica = ? ',
            array(
                array('s' => $id)
            )
        );

        if (! empty($riga)) {

            $riga = array_merge(
                $riga,
                $mail
            );
        } else {

            $riga['id'] = $id;

            mysqlInsertRow(
                $cf['mysql']['connection'],
                $riga,
                'anagrafica_view_static'
            );
        }
    }

    /**
     * 
     * TODO documentare
     * 
     * TODO implementare la cancellazione di specifiche righe
     * 
     */
    function cleanAnagraficaViewStatic()
    {

        global $cf;

        return mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE anagrafica_view_static FROM anagrafica_view_static
                LEFT JOIN anagrafica ON anagrafica.id = anagrafica_view_static.id
                WHERE anagrafica.id IS NULL;'
        );
    }

    /**
     * 
     * TODO documentare
     * 
     */
    function emptyAnagraficaViewStatic()
    {

        global $cf;

        return mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM anagrafica_view_static'
        );
    }

