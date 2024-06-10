<?php

function aggiungiPrezzi( &$p, $id, $f ) {

    global $cf;
    
    $prezzi['prodotto'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT prezzi_view.*, iva.aliquota, '
        .'( prezzi_view.prezzo * ( ( iva.aliquota + 100 ) / 100 ) ) AS prezzo_lordo '
        .'FROM prezzi_view '
        .'LEFT JOIN iva ON iva.id = prezzi_view.id_iva '
        .'WHERE prezzi_view.' . $f . ' = ? ',
        array( array( 's' => $id ) )
    );

    $prezzi['articoli'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT prezzi_view.*, iva.aliquota, '
        .'( prezzi_view.prezzo * ( ( iva.aliquota + 100 ) / 100 ) ) AS prezzo_lordo '
        .'FROM prezzi_view '
        .'LEFT JOIN iva ON iva.id = prezzi_view.id_iva '
        .'LEFT JOIN articoli ON articoli.id = prezzi_view.id_articolo '
        .'WHERE prezzi_view.id_articolo = articoli.id AND articoli.id_prodotto = ? ',
        array( array( 's' => $id ) )
    );

    if( empty( $prezzi['prodotto'] ) ) {
        $prezzi['prodotto'] = $prezzi['articoli'][0];
    }


    // TODO l'array dei prezzi va sotto contents, la chiave dev'essere il nome del listino, il prezzo del prodotto
    // dev'essere il prezzo dell'articolo più alto, tenere conto di eventuali listini associati all'account connesso

/*

VEDI COME SONO GESTITI I PREZZI DEGLI ARTICOLI NELLA PAGINA PRODOTTO:

Array
(
    [0] => Array
        (
            [cappello] => 
            [h1] => N-E-XT
            [id] => N-E-XT ND000X0003D
            [id_colore] => 
            [id_taglia] => 
            [ietf] => it-IT
            [metadati] => Array
                (
                )

            [prezzi] => Array
                (
                    [DEFAULT] => Array
                        (
                            [__label__] => N-E-XT ND000X0003D 1064.00000 DEFAULT EUR IVA 22%
                            [aliquota] => 22.00
                            [id] => 8
                            [id_account_aggiornamento] => 
                            [id_account_inserimento] => 
                            [id_articolo] => N-E-XT ND000X0003D
                            [id_iva] => 1
                            [id_listino] => 1
                            [id_prodotto] => 
                            [iso4217] => EUR
                            [iva] => IVA 22%
                            [listino] => DEFAULT
                            [prezzo] => 1064.00000
                            [prezzo_lordo] => 1298.08000000000
                            [utf8] => €
                        )

                )

            [specifiche] => 
            [title] => N-E-XT
        )

)
 -->

*/

/*
    $meta = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT metadati.*, lingue.ietf FROM metadati '.
        'LEFT JOIN lingue ON lingue.id = metadati.id_lingua '.
        'WHERE ' . $f . ' = ?',
        array(
            array( 's' => $id )
        )
    );
*/

// print_r( $meta );

#        foreach( $meta as $mta ) {
/*
        if( empty( $mta['ietf'] ) ) {
            $p['metadati'][ $mta['nome'] ] = $mta['testo'];
        } else {
            $p['metadati'][ $mta['nome'] ][ $mta['ietf'] ] = $mta['testo'];
        }
*/
#                $p['metadati'] = array_replace_recursive(
#                    $p['metadati'],
#                    metadati2associativeArray( $mta )
#                );

        if( isset( ( $p['prezzi'] ) ) && is_array( $p['prezzi'] ) ) {

            $p['prezzi'] = array_replace_recursive(
                $p['prezzi'],
                $prezzi
            );

        } else {

            $p['prezzi'] = $prezzi;

        }

#        }

}

