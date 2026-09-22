
    /*
     * tendina intelligente
     *
     * TODO documentare
     *
     */

    // tendina intelligente
    $.fn.selectBox = function() {

        // definisco la select
        var select = $(this);

        var base_id = $(this).attr( 'id' );

        var wscall = null;

        var disabled = null;

        // log
        // console.log( select );
        // console.log( base_id );

        // lunghezza minima del filtro
        if( $.isNumeric( select.attr( 'min-filter' ) ) ) {
            var min = select.attr( 'min-filter' );
        } else {
            var min = 0;
        }

        // se la select è disabilitata
        if( select.attr( 'disabled' ) == 'disabled' ) {
            console.log( select.attr( 'disabled' ) );
            disabled = 'disabled';
        }

        // nascondo la select
        $( select ).hide();

        // creo il campo input
        // var box = $('<input type="text" class="form-control form-control-sm selectbox-base-background selectbox-input remove-on-duplicate" id="' + base_id + '_inputbox" autocomplete="' + ( Math.floor(Math.random() * 10 * 100 * 1000 ) ) + '">');
        var box = $('<input type="text" ' + disabled + ' class="form-control form-control-sm selectbox-base-background selectbox-input remove-on-duplicate" id="' + base_id + '_inputbox" autocomplete="' + ( Math.floor(Math.random() * 30 * 100 * 1000 ) ) + '-' + ( Math.floor(Math.random() * 10 * 100 * 1000 ) ) + '-' + ( Math.floor(Math.random() * 50 * 100 * 1000 ) ) + '"><div class="spinner-border" role="status"></div>');

        // aggiungo l'attributo required
        if( $( select ).attr( 'data-required' ) == 'true' ) {
            $( box ).prop( 'required', true );
        }

        // prelevo il valore corrente
        // NOTA perché .text() e non .html()?
        var current = $( select ).find( 'option:selected' ).text().trim();
        var currvalue = $( select ).val();

        if( current == '' ) {
            current = currvalue;
        }

         console.log( 'valore corrente (' + base_id + '): ' + current + '/' + currvalue );
        // alert( 'valore corrente: ' + current + '/' + currvalue );

        // imposto il valore corrente
        // aggiungo l'attributo required
        if( $( select ).attr( 'placeholder-api' ) ) {
            $( box ).val( $( select ).attr( 'placeholder-api' ) );
            // se, cliccando sulla selectbox per scrivere, non scompare il placeholder, decommentare questo codice
        /* da qui... */
            $( box ).on( "click", function() {
                if( $( box ).val() == $( select ).attr( 'placeholder-api' ) ){
                    $( box ).val('');
                }
              });
            $( box ).on( "focusout", function() {
                if( $( box ).val() == ''){
                    $( box ).val( $( select ).attr( 'placeholder-api' ) );
                }
              });
        /* ...fin qui era commentato, perché? */
        } else {
            box.val( current );
        }

        /*
         * SENZA API NON C'E' NIENTE DA RIPESCARE
         *
         * Una tendina statica ha gia' le sue <option> in pagina e il box e' gia' valorizzato con
         * l'etichetta giusta: la chiamata non servirebbe a niente. Ma la macro Twig emette
         * populate-api anche quando e' vuoto, quindi senza questa guardia partiva una
         * GET /api/?__id__=<etichetta> per OGNI select con un valore selezionato - 58 richieste
         * in due giorni su un solo deploy, tutte 404, e ciascuna col suo bootstrap del framework.
         */
        var api = $( select ).attr( 'populate-api' );

        if( current != '' && typeof api !== 'undefined' && api != '' ) {
            // alert( 'prelevo #' + current + ' da ' + api );
            console.log( 'prelevo #' + current + ' da ' + api );
            /*
             * L'ID VA PASSATO COME PARAMETRO, NON COME PEZZO DI PERCORSO
             *
             * Questa chiamata serve a ripescare l'etichetta leggibile di un valore gia' scelto,
             * quando la tendina non ha la lista statica in pagina. Se fallisce, il campo resta
             * con i tre trattini che _form.html mette come segnaposto: e' il difetto segnalato
             * il 14/09/2026 su Lughese ( "a volte la tendina degli articoli non si popola" ).
             *
             * Non era "a volte": la regola di riscrittura dell'API REST accetta come id solo
             * [a-zA-Z0-9.-] ( .htaccess, "gestione delle API REST generiche" ), e gli id
             * naturali delle tabelle di catalogo non stanno in quell'alfabeto - su quel deploy
             * 1.119 articoli su 2.455 e 621 prodotti hanno uno spazio, un underscore, una barra,
             * un piu' o una virgola dentro l'id. Per tutti quelli la richiesta non trovava
             * nessuna regola e tornava 404, sempre.
             *
             * Allargare l'alfabeto della regola non basterebbe comunque: un id che contiene una
             * barra non puo' stare in un segmento di percorso, e ce ne sono. Il parametro
             * __id__ invece lo legge _src/_api/_rest.php ( riga 84 ) esattamente come quello
             * estratto dal percorso, e regge qualunque carattere.
             */
            /*
             * IL FALLIMENTO NON DEVE ESSERE SILENZIOSO
             *
             * Se la chiamata non torna un'etichetta si rimette nel campo il VALORE, che e'
             * l'unica cosa vera che si ha in mano. Fino al 22/09/2026 qui non si faceva niente:
             * il campo restava col segnaposto di _src/_html/_bin/_form.html, che erano tre
             * trattini, e all'operatore sembrava vuoto un campo che invece era valorizzato -
             * l'hidden ha sempre avuto il suo id, e il salvataggio infatti non perdeva niente.
             *
             * Il caso piu' comune non e' un guasto ma un permesso: un'entita' che non sta in
             * $cf['auth']['permissions'] fa rispondere 401 all'API REST, e ogni tendina che la
             * interroga resta indietro. Perche' si veda senza doverlo cercare, l'errore va in
             * console.error con dentro il campo, l'entita' e il codice HTTP.
             */
            getws(
                '/api/' + api + '?__id__=' + encodeURIComponent( current ),
                null,
                function( data ) {
                    // alert( 'prelevato ' + data.__label__ + ' da ' + api );
                    console.log( 'prelevo i dati' );
                    if( data && data.hasOwnProperty( '__label__' ) ) {
                        console.log( 'prelevato ' + data.__label__ + ' da ' + api );
                        console.log( data );
                        box.val( data.__label__ );
                        $( select ).val( current );
                    } else {
                        box.val( current );
                        console.error( 'selectbox ' + base_id + ': /api/' + api + ' non ha restituito __label__ per ' + current + ', resta il valore' );
                    }
                },
                function( jqxhr ) {
                    box.val( current );
                    console.error( 'selectbox ' + base_id + ': /api/' + api + ' ha risposto ' + ( ( jqxhr && jqxhr.status ) ? jqxhr.status : 'errore' ) + ' per ' + current + ', resta il valore' );
                }
            );
        }

        // TODO creo la <ul> con le opzioni
        var lista = $('<ul class="combobox-dropdown remove-on-duplicate" id="' + base_id + '_list"> </ul>');

        // evento custom per mostrare l'intera lista
        box.on( "all", function( e ) {
            // alert('custom');
            if( $( lista ).is(":visible") ) {
                $( lista ).hide();
                $( box ).addClass( 'combobox-base-background' );
                $( box ).removeClass( 'combobox-active-background' );
                // $( box ).css( 'background-color', '#ffffff' );
            } else {
                box.trigger("keyup",{"val":""});
            }
        });

        // faccio il bind della funzione principale di ricerca
        box.keyup( function( e, d ) {

        // debug
        // console.log( d );

        // filtro
        if( typeof d !== 'undefined' && typeof d.val !== 'undefined' ) {
            var filtro = d.val;
            var force = true;
        } else {
            var filtro = $(this).val();
            var force = false;
            $( select ).val( '' );
        }

        // debug
        console.log( 'valore della select al click -> ' + $( select ).val() );

        // ...
        $( box ).addClass( 'combobox-active-background' );
        $( box ).removeClass( 'combobox-base-background' );
        // $( box ).css( 'background-color', '#eeeeee' );

        // se è stato inserito un filtro di lunghezza minima
        if( filtro.length > min || force == true ) {

            // resetto la select
            // $( select ).val([]);

            // log
             console.log( 'filtro: ' + filtro );
             console.log( 'api: ' + $( select ).attr( 'populate-api' ) );

            // tendina dinamica o statica
            if( $( select ).attr( 'populate-api' ) != '' ) {

                $( box ).closest( '.spinner-border' ).show();

                if( wscall != null ) {
                    clearTimeout( wscall );
                }

                wscall = setTimeout( function() {

                // il filtro si codifica: e' testo digitato dall'utente e finisce in una query string,
                // quindi una & o un # dentro la ricerca troncherebbero la chiamata. Fino al 14/09/2026
                // qui c'era scritto "boh sembra funzionare comunque", ed e' la stessa famiglia del
                // difetto corretto qui sopra sull'id
                var call = '/api/' + $( select ).attr( 'populate-api' ) + '?__info__[' + $( select ).attr( 'populate-api' ) + '][__search__]=' + encodeURIComponent( filtro ) + '&__info__[' + $( select ).attr( 'populate-api' ) + '][__fields__][]=id&__info__[' + $( select ).attr( 'populate-api' ) + '][__fields__][]=__label__';

                // OK rendere dinamico call = call + '&__info__[' + $( select ).attr( 'populate-api' ) + '][__restrict__][id_tipologia][IN]=12';

                // recupero il valore di tutti gli attributi di $( select ) che iniziano con restrict-
                // console.log( '-----' );
                // console.log( $(select) );
                $.each($(select)[0].attributes, function(index, attr) {
                    var key = attr.name;
                    var value = attr.value;
                    // console.log('restrict: ' + key + ' -> ' + value);
                    if (key.indexOf('restrict-') === 0) {
                        var tk = value.split(':');
                        // anche il valore del vincolo si codifica: puo' contenere id con spazi
                        // ( 'id_prodotto': { 'IN': 'GOOD GS3300MY|OPZIONI' } ). La barra verticale che
                        // separa i valori dell'operatore IN sopravvive, perche' viene decodificata
                        // prima che _src/_lib/_controller.tools.php la usi per lo split
                        call += '&__info__[' + $(select).attr('populate-api') + '][__restrict__][' + key.replace('restrict-', '') + '][' + tk[0] + ']=' + encodeURIComponent( tk[1] );
                    }
                });
                // console.log( '-----' );

                console.log( 'chiamata API ' + call );

                getws(
                    call,
                    null,
                    function( data ) {

                        // svuoto la lista
                        $( lista ).empty();

                        console.log( data );

                        data.forEach( function( el ) {

                                console.log( el.id + '/' + el.__label__ );

                                if( el.id == currvalue ) {
                                    var classe = ' class="selected"';
                                } else {
                                    var classe = '';
                                }
            
                                var li = '<li value="' + el.id + '"' + classe + '>' + el.__label__ + '</li>';

                
                                lista.append( li );

                                
                                lista.find('li').each( function( idxl, li ) {
                                    var opzione = $( li ).html();
                                    var valore = $( li ).attr( 'value' );
                                    $( li ).bind( 'click', function() {
                                        $( select ).val( valore );
                                        $( box ).val( $.parseHTML( opzione )[0].nodeValue );
                                        $( box ).addClass( 'combobox-base-background' );
                                        $( box ).removeClass( 'combobox-active-background' );
                                        // $( box ).css( 'background-color', '#ffffff' );
                                        $( lista ).hide();
                                        // console.log( 'valore della select al click -> ' + $( select ).val() );
                                    });
                                });
    

                            });

                            $( lista ).show();
                            $( box ).closest( '.spinner-border' ).hide();

                    }
                );

                }, 1000 );

            } else {

                // svuoto la lista
                $( lista ).empty();

                // TODO appendo alla lista un <li> per ogni <option> della select
                select.find('option').each( function( idx, el ) {
                var opzione = $( el ).html().trim();
                var valore = $( el ).attr( 'value' );
                // $( el ).prop( 'selected', false );
                // console.log( opzione + ' -> ' + valore );
                // TODO filtro le opzioni in base al opzione del campo input

                // tokenizzo il filtro per spazio
                var filtro_tokenized = filtro.split( ' ' );
                var match = 0;
                filtro_tokenized.forEach( function( token ) {
                    if( opzione.toLowerCase().indexOf( token.toLowerCase() ) >= 0 ) {
                        match++;
                    }
                });

                // se tutti i token sono stati trovati
                if( match == filtro_tokenized.length ) {
                    // console.log( opzione + ' -> ' + filtro );
                    if( valore == currvalue ) {
                        var classe = ' class="selected"';
                    } else {
                        var classe = '';
                    }
                    var li = '<li value="' + valore + '"' + classe + '>' + opzione + '</li>';
                    lista.append( li );
                }

                });

                // TODO bind dell'evento click sulle opzioni per il cambio del valore della select
                lista.find('li').each( function( idxl, li ) {
                var opzione = $( li ).html();
                var valore = $( li ).attr( 'value' );
                $( li ).bind( 'click', function() {
                    $( select ).val( valore );
                    $( select ).change();
                    $( box ).val( $.parseHTML( opzione )[0].nodeValue );
                    $( box ).addClass( 'combobox-base-background' );
                    $( box ).removeClass( 'combobox-active-background' );
                    // $( box ).css( 'background-color', '#ffffff' );
                    $( lista ).hide();
                    // console.log( 'valore della select al click -> ' + $( select ).val() );
                });
                // console.log( 'bind a ' + valore + ' di ' + opzione );
                });

    /*
            // segnalazione visiva trovato o non trovato
            if( found == false ) {
                $( box ).css( 'background-color', '#eeeeee' );
            } else {
                $( box ).css( 'background-color', '#ffffff' );
            }
    */

                // mostro la lista
                // select.parent().append( lista );
                $( lista ).show();

            }


        } else {

            // nascondo la lista
            // lista.remove();
            $( lista ).hide();

        }

        // log
        // console.log( 'valore della select -> ' + select.val() );
        // console.log( 'valore della select -> ' + $( select ).val() );

/*

        // segnalazione visiva trovato o non trovato
        if( $( select ).val() == '' ) {
        $( box ).css( 'background-color', '#eeeeee' );
        } else {
        $( box ).css( 'background-color', '#ffffff' );
        }

        // segnalazione visiva trovato o non trovato
        if( $( select ).val() == '' ) {
        $( box ).css( 'background-color', '#eeeeee' );
        } else {
        $( box ).css( 'background-color', '#ffffff' );
        }
*/

        });

/*
    // faccio il bind della funzione che verifica se è stata inserita un'opzione valida
    box.blur( function() {

        $( lista ).hide();
        console.log( 'uscita dal campo di ricerca' );
        console.log( 'valore della select al blur -> ' + select.val() );

        if( select.val() == '' ) {
        console.log( 'valore non presente fra le opzioni -> ' + $( box ).val('') );
//        $(this).val('');
        }

    });
*/

        // trovo il tasto per aprire la lista
        // shower = $( this ).parents().eq(2).find('.combobox-shower');

/*
    // faccio il bind del lista.append()
    $( shower ).on( 'click', function() {
        $( lista ).toggle();
    });
*/

        // mostro il campo input
        select.parent().prepend( box );

        // mostro la lista
        select.parent().append( lista );

        // nascondo la lista
        $( lista ).hide();

    }

    // operazioni da eseguire al caricamento della pagina
    $( document ).ready( function() {

        $('.selectbox').each( function() {
            $(this).selectBox();
        });

    });
