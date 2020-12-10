
    /*
     * tendina intelligente
     *
     *
     *
     */

    // tendina intelligente
	$.fn.selectBox = function() {

	    // definisco la select
	    var select = $(this);

	    var base_id = $(this).attr( 'id' );

	    // log
	    // console.log( select );
	     console.log( base_id );

	    // lunghezza minima del filtro
	    if( $.isNumeric( select.attr( 'min-filter' ) ) ) {
		var min = select.attr( 'min-filter' );
	    } else {
		var min = 0;
	    }

	    // nascondo la select
	    $( select ).hide();

	    // creo il campo input
	    var box = $('<input type="text" class="form-control form-control-sm selectbox-base-background selectbox-input remove-on-duplicate" id="' + base_id + '_inputbox" autocomplete="' + ( Math.floor(Math.random() * 10 * 100 * 1000 ) ) + '">');

	    // aggiungo l'attributo required
	    if( $( select ).attr( 'data-required' ) == 'true' ) {
		$( box ).prop( 'required', true );
	    }

	    // prelevo il valore corrente
	    var current = $( select ).find( 'option:selected' ).text();
		var currvalue = $( select ).val();

	    // imposto il valore corrente
	    box.val( current );

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
		console.log( d );

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

		    // svuoto la lista
		    $( lista ).empty();

		    // resetto la select
		    // $( select ).val([]);

		    // log
		     console.log( 'filtro -> ' + filtro );

		    // TODO appendo alla lista un <li> per ogni <option> della select
		    select.find('option').each( function( idx, el ) {
			var opzione = $( el ).html();
			var valore = $( el ).attr( 'value' );
			// $( el ).prop( 'selected', false );
			// console.log( opzione + ' -> ' + valore );
			// TODO filtro le opzioni in base al opzione del campo input
			if( opzione.toLowerCase().indexOf( filtro.toLowerCase() ) >= 0 ) {
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
			    $( box ).val( opzione );
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
//		$(this).val('');
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
