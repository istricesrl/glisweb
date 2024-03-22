
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

        // console.log( 'valore corrente: ' + current + '/' + currvalue );

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

				// perché non usiamo encodeURIComponent( filtro ) per normalizzare i caratteri strani tipo & eccetera? boh sembra funzionare comunque
				var call = '/api/' + $( select ).attr( 'populate-api' ) + '?__info__[' + $( select ).attr( 'populate-api' ) + '][__search__]=' + filtro + '&__info__[' + $( select ).attr( 'populate-api' ) + '][__fields__][]=id&__info__[' + $( select ).attr( 'populate-api' ) + '][__fields__][]=__label__';

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
