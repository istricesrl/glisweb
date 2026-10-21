/**
 * libreria Javascript del template Lydia
 *
 * Questo file contiene il codice Javascript specifico del template Lydia; le funzioni comuni a tutti i
 * template stanno in _src/_js/_main.js. Il file è caricato con defer dopo jQuery e Colorbox ( vedi
 * etc/template.yaml ), quindi quando viene eseguito il DOM è già costruito.
 *
 */

/**
 * GALLERIA DELLE IMMAGINI
 */

// le miniature disegnate da inc/gallery.twig si aprono ingrandite con Colorbox, una alla volta
// ( rel le raggruppa, per scorrerle con le frecce ); la galleria nasce nascosta e compare solo
// dopo il bind, così non si vede prima che il clic funzioni
if( typeof $.fn.colorbox === 'function' ) {

    $('.g2cb-gallery').colorbox({
        width: "90%",
        height: "90%",
        rel: "g2cb-gallery",
        transition: "elastic"
    });

}

$('.g2cb').fadeIn();
