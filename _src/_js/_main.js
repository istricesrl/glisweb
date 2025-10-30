/**
 * libreria Javascript standard del framework
 * 
 * TODO documentare
 * 
 */

/**
 * FUNZIONI PER LA GESTIONE DELLE STRINGHE
 */

/**
 * rimuove le lettere accentate
 * 
 * Questa funzione rimuove le lettere accentate da una stringa
 * sostituendole con le corrispondenti lettere non accentate.
 * 
 * @param       string      st      la stringa da "ripulire"
 * 
 * @return      string              la stringa ripulita
 * 
 */
function strClean( st ) {

    var st = st.split('');
    var stOut = new Array();
    var stLen = st.length;

    var accents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var accentsOut = "AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz";

    for( var y = 0; y < stLen; y++ ) {
        if( accents.indexOf( st[y] ) != -1 ) {
            stOut[y] = accentsOut.substr( accents.indexOf( st[y] ), 1 );
        } else {
            stOut[y] = st[y];
        }
    }

    stOut = stOut.join('');

    return stOut;

}

/**
 * effettua un confronto case insensitive tra due stringhe
 * 
 * Questa funzione confronta due stringhe senza tenere conto
 * delle differenze tra maiuscole e minuscole.
 * 
 * @param       string      a       la prima stringa
 * @param       string      b       la seconda stringa
 * 
 * @return      boolean             true se le stringhe sono uguali, false altrimenti
 * 
 */
function ciEquals(a, b) {
    return typeof a === 'string' && typeof b === 'string'
        ? a.localeCompare(b, undefined, { sensitivity: 'accent' }) === 0
        : a === b;
}

/**
 * restituisce un nome di file al netto del path
 * 
 * Questa funzione restituisce il nome di un file senza il path.
 * 
 * @param       string      path        il path completo del file
 * 
 * @return      string                  il nome del file
 * 
 */
function basename(path) {
    return path.split(/[\\/]/).pop();
}

/**
 * restituisce un parametro dall'URL
 * 
 * Questa funzione restituisce il valore di un parametro presente nella query string.
 * 
 * @param       string      paramName   il nome del parametro da cercare
 * 
 * @return      string                  il valore del parametro, null se non presente
 * 
 */
function getUrlParam( paramName ) {
    var reParam = new RegExp( '(?:[\?&]|&)' + paramName + '=([^&]+)', 'i' );
    var match = window.location.search.match( reParam );
    return ( match && match.length > 1 ) ? match[1] : null;
}

/**
 * FUNZIONI PER LA GESTIONE DEGLI ELEMENTI HTML
 */

/**
 * verifica se un elemento ha un certo attributo
 * 
 * Questa funzione verifica se un elemento ha un certo attributo.
 * 
 * @param       string      name        il nome dell'attributo da cercare
 * 
 * @return      boolean                 true se l'attributo è presente, false altrimenti
 * 
 */
$.fn.hasAttr = function( name ) {  
    var attr = this.attr( name );
    if (typeof attr !== typeof undefined && attr !== false) {
        console.log( name + ' presente' );
        return true;
    }
    return false;
};

/**
 * abilita o disabilita un attributo
 * 
 * Questa funzione abilita un attributo se assente e lo disabilita se presente.
 * 
 * @param       string      a       il nome dell'attributo da abilitare/disabilitare
 * 
 * @return      void
 * 
 * @todo l'implementazione attuale funziona solo col disabled, farla per tutti gli attributi
 * 
 */
$.fn.toggleAttribute = function( a ) {

    var el = $(this).get(0);
    var e = this;

    $( e ).find(':input').each( function( i, obj ) {
        console.log( $( obj ) );
        if( $( obj ).hasAttr('disabled') ) {
            console.log( 'rimuovo disabled ' + $( obj ).attr( 'id' ) );
            $( obj ).removeAttr( "disabled" );
        } else {
            console.log( 'aggiungo disabled ' + $( obj ).attr( 'id' ) );
            $( obj ).attr( "disabled", true );
        }
    });

}

/**
 * abilita un attributo
 * 
 * Questa funzione abilita un attributo se assente.
 * 
 * @param       string      a       il nome dell'attributo da abilitare
 * 
 * @return      void
 * 
 * @todo l'implementazione attuale funziona solo col disabled, farlo per tutti
 * 
 */
$.fn.setAttribute = function( a ) {

    var el = $(this).get(0);
    var e = this;

    $( e ).find(':input').each( function( i, obj ) {
        console.log( $( obj ) );
        console.log( 'aggiungo disabled ' + $( obj ).attr( 'id' ) );
        $( obj ).attr( "disabled", true );
    });

}

/**
 * disabilita un attributo
 * 
 * Questa funzione disabilita un attributo se presente.
 * 
 * @param       string      a       il nome dell'attributo da disabilitare
 * 
 * @return      void
 * 
 * @todo l'implementazione attuale funziona solo col disabled, farlo per tutti
 * 
 */
$.fn.unsetAttribute = function( a ) {

    var el = $(this).get(0);
    var e = this;

    $( e ).find(':input').each( function( i, obj ) {
        console.log( $( obj ) );
        if( $( obj ).hasAttr('disabled') ) {
            console.log( 'rimuovo disabled ' + $( obj ).attr( 'id' ) );
            $( obj ).removeAttr( "disabled" );
        }
    });

}

/**
 * FUNZIONI PER DATA E ORA
 */

/**
 * aggiunge giorni ad una data
 * 
 * Questa funzione aggiunge un certo numero di giorni ad una data.
 * Se il parametro working è true, vengono contati solo i giorni lavorativi.
 * Se il parametro days è '-', la data non viene modificata.
 * 
 * @param       date        date        la data di partenza
 * @param       int         days        il numero di giorni da aggiungere (o '-' per non modificare la data)
 * @param       boolean     working     true per contare solo i giorni lavorativi, false per contare tutti i giorni (default: true)
 * 
 * @return      date                    la data risultante nel formato 'YYYY-MM-DD'
 * 
 */
function addDays( date, days, working = true ) {
    var result = new Date( date );
    console.log( result );
    if( days != '-' ) {
        if( working == true ) {
            var day = result.getDay();
            result.setDate( result.getDate() + parseInt( days ) + ( day === 6 ? 2 : + ! day ) + ( Math.floor( ( parseInt( days ) - 1 + ( day % 6 || 1 ) ) / 5 ) * 2 ) );
        } else {
            result.setDate( result.getDate() + parseInt( days ) );
        }
    }
    console.log( result );
    return formatDate( result );
}

/**
 * formatta una data
 * 
 * Questa funzione formatta una data nel formato 'YYYY-MM-DD'.
 * 
 * @param       date        date        la data da formattare
 * 
 * @return      string                  la data formattata
 * 
 */
function formatDate( date ) {

    var d = new Date( date ),
        month = '' + ( d.getMonth() + 1 ),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if( month.length < 2 ) 
        month = '0' + month;
    if( day.length < 2 ) 
        day = '0' + day;

    return[ year, month, day ].join( '-' );

}

/**
 * FUNZIONI PER LA GESTIONE DEI FORM
 */

/**
 * invia un form dopo averne verificato la validità
 * 
 * Questa funzione verifica la validità di un form HTML5 e lo invia
 * se è valido, altrimenti mostra i messaggi di errore.
 * 
 * @param       object      form        l'oggetto form da verificare e inviare
 * 
 * @return      void
 * 
 */
function checkAndSubmit( form ) {

    if( $( form )[0].checkValidity() ) {
        form.submit();
    } else {
        $( form )[0].reportValidity();
    }

}

/**
 * esegue una funzione dopo aver verificato la validità di un form
 * 
 * Questa funzione verifica la validità di un form HTML5 e, se è valido,
 * esegue una funzione passata come parametro, altrimenti mostra i messaggi di errore.
 * Se la funzione non è valida, invia il form.
 * 
 * @param       object      form        l'oggetto form da verificare
 * @param       function    action      la funzione da eseguire se il form è valido (default: invia il form)
 * 
 * @return      void
 * 
 */
function checkAndDo( form, action ) {

    if( form.checkValidity() ) {
        if( typeof action === 'function' ) {
            action();
        } else {
            form.submit();
        }
    } else {
        form.reportValidity();
    }

}

/**
 * OPERAZIONI DA ESEGUIRE AL CARICAMENTO DELLA PAGINA
 */

// quando il DOM è pronto...
$( document ).ready( function() {

    /* sezione cookie */

    // mostro l'overlay dei cookie
    $('#cookie').fadeIn();

    /* sezione autofocus */

    // metto il focus sull'elemento con classe focus-on-load
    $('.focus-on-load').focus();

    /* sezione modal e popup */

    // apro i modal con classe in
    $('.in').modal('show');

    // apro i modal con classe popup-open
    $('.popup-open').modal();

    // apro in ritardo i modal con classe popup-delay in base al valore dell'attributo popup-delay
    $('.popup-delay').each( function() {
        var modal = $( this );
        var delay = $( modal ).attr('popup-delay') * 1000;
        setTimeout( function() {
        $( modal ).modal();
        }, delay );
    });

    // apro allo scroll i modal con classe popup-scroll, in base al valore dell'attributo popup-scroll
    $('.popup-scroll').each( function() {
        var modal = $( this );
        var scroll = $( modal ).attr('popup-scroll');
        console.log( 'appare al ' + scroll + '%' );
        window.addEventListener( 'scroll', function() {
        var used = $( modal ).attr('popup-used');
        var progress = Math.round( 100 * $( window ).scrollTop() / ( $( document ).height() - $( window ).height() ) );
        if( progress == scroll && used == '' ) {
            $( modal ).modal();
            $( modal ).attr( 'popup-used', 1 );
        }
        console.log( 'stato del popup: ' + used );
        console.log( progress );
        });
    });

    // gestione popup che devono apparire su tutte le pagine
    $('.popup-modal').on('hidden.bs.modal', function () {
        var id = $(this).attr('id');
        $.ajax({
            type: "POST",
            url: '/task/3400.popup/popup.dismiss',
            data: {idPopup:id},
            success: function(data) {
            }
            });
    });

    /* sezione toggle e switch */

    // aggiungo la capacità di fare slideToggle() agli oggetti con classe toggler
    $('.toggler').click( function() {
        $('#'+$(this).attr('toggle')).slideToggle();
        $(this).find('.fa').toggle();
    });

    // ???
    $('[img-hover]').on('mouseover mouseout', function() {
        var src = $(this).attr('src');
        var hover = $(this).attr('img-hover');
        $(this).attr('src', hover );
        $(this).attr('img-hover', src );
    });

    /* sezione tooltip e hint */

    /*
    // faccio il bind della funzione tooltip() ai campi con l'attributo data-toggle impostato a tooltip
    if( $('[data-toggle="tooltip"]').length ) {
        $('[data-toggle="tooltip"]').tooltip();
    }
    */

    /*
    // ???
    $('.hint-toggle').change( function () {
        $( '.' + $(this).attr('hint-toggle') ).hide();
        $( '#' + $(this).attr('hint-toggle') + '-' + $(this).val() ).show();
    });

    // ???
    $('.hint-toggle').change();
    */

    /* sezione form */

    // collego il campo hidden per le checkbox
    // NOTA prima per la checkbox vuota settavamo zero, ma incasina i filtri delle viste
    $('input[type=checkbox]').click( function() {
        console.log( 'checkbox clicked' );
        if( this.checked ) {
            console.log( 'checked' );
            $(this).prev().val('1');
        } else {
            console.log( 'unchecked' );
            $(this).prev().val('');
        }
    });

    /* sezione back to top */

    // ???
    $( window ).scroll( function() {
        $('.hide-on-scroll').hide();
        if( $(this).scrollTop() > 50 ) {
        $('#back-to-top').fadeIn();
        } else {
        $('#back-to-top').fadeOut();
        }
    });

    // ???
    $('.back-to-top').click( function () {
        $('#back-to-top').tooltip('hide');
        $('body,html').animate({ scrollTop: 0 }, 800);
        return false;
    });

    /* sezione drag & drop */

    // faccio il bind della funzione draggable agli oggetti con classe draggable-item
    if( $('.draggable-item').length ) {
        $('.draggable-item').draggable({ containment: "main" });
    }

    /* sezione menu di navigazione */

    // attivo l'hover per gli elementi li delle navbar con classe navbar-slider per il menu a tendina
    $('nav.navbar-slider ul li').hover(
        function() {
            $(this).children('ul').slideDown( 200 );
        },
        function() {
            $(this).find('ul').hide();
        }
    );

    // la nav.navbar-megamenu contiene gli elementi che attivano il megamenu
    // mentre invece .megamenu è il contenitore del megamenu vero e proprio
    $('nav.navbar-megamenu ul.navbar-nav').children('li').hover(
        function() {
            var id = $(this).attr('data-page-id');
            console.log('megamenu on ' + id);
            // $(this).children('ul').slideDown( 200 );
            // megamenu = 1;
            $('.megamenu li').not('.child-of-' + id).hide();
            $('.megamenu .child-of-' + id ).parents().show();
            $('.megamenu .child-of-' + id ).show();
        },
        function() {
            // var id = $(this).attr('data-page-id');
            // console.log('megamenu off ' + id);
            // $(this).children('ul').hide();
            // if( megamenu == 0 ) {
            //	$('.child-of-' + id ).hide();
            // }
            // $('.megamenu li').hide();
        }
    );

    // il .container-megamenu è l'elemento che contiene sia il megamenu sia
    // il menu che lo attiva, e uscirne comporta la chiusura del megamenu
    $('.container-megamenu').hover(
        function() {
            // 
        },
        function() {
            $('.megamenu li').hide();
        }
    );

});
