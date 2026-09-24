<?php

    /**
     * gruppi di bookmarks della logistica
     *
     * I bookmarks sono la memoria di lavoro volatile del framework ( $_SESSION['__work__'],
     * API /api/bookmarks, task bookmark.add / bookmark.del / bookmark.toggle ): servono a
     * "portarsi dietro" degli oggetti da una schermata all'altra e a ritrovarseli dove poi
     * servono davvero. Vedi _src/_config/_770.bookmarks.php per il meccanismo.
     *
     * Qui si dichiara il gruppo del RIASSORTIMENTO: dalla scheda sottoscorta si segnano le
     * ubicazioni che si vogliono rifornire e ce le si porta dietro fino alla generazione della
     * missione. E' il motivo per cui la selezione non sta in una struttura inventata apposta:
     * questa c'e' gia', la mostra il widget in testa a ogni pagina di athena, si svuota da sola
     * a fine sessione e si toglie un elemento risegnandolo.
     *
     * L'azione che consuma il gruppo non c'e' ancora: quando ci sara' la pagina che genera la
     * missione dalle ubicazioni segnate, va aggiunta qui sotto una voce 'actions', sul modello
     * di _mod/_0920.corsi/_src/_config/_770.bookmarks.php. Dichiararne una che punta a una
     * pagina inesistente farebbe comparire nel widget un collegamento che non porta da nessuna
     * parte, quindi si aggiunge insieme alla pagina, non prima.
     *
     * @file
     *
     */

    // gruppi funzionali della logistica
    $cf['bookmarks'] = array_replace_recursive(
        $cf['bookmarks'],
        array(
            'riassortimento' => array(
                'label' => 'da riassortire'
            )
        )
    );
