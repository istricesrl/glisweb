
    // rimuove le lettere accentate
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

    function ciEquals(a, b) {
        return typeof a === 'string' && typeof b === 'string'
            ? a.localeCompare(b, undefined, { sensitivity: 'accent' }) === 0
            : a === b;
    }

	// verifica se esiste un attributo
	$.fn.hasAttr = function( name ) {  
		var attr = this.attr( name );
		if (typeof attr !== typeof undefined && attr !== false) {
			console.log( name + ' presente' );
			return true;
		}
		return false;
	};

	// abilita un attributo se assente e lo disabilita se presente
	// TODO adesso funziona solo col disabled, farlo per tutti
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

	    // console.log( el );
		// console.log( e );
	    // console.log( this );
	    // console.log( $(this) );

	}

	// abilita un attributo
	// TODO adesso funziona solo col disabled, farlo per tutti
	$.fn.setAttribute = function( a ) {

		var el = $(this).get(0);
	    var e = this;

		$( e ).find(':input').each( function( i, obj ) {
			console.log( $( obj ) );
			console.log( 'aggiungo disabled ' + $( obj ).attr( 'id' ) );
			$( obj ).attr( "disabled", true );
		});

	    // console.log( el );
		// console.log( e );
	    // console.log( this );
	    // console.log( $(this) );

	}

	// restituisce un nome di file al netto del path
	function basename(path) {
		return path.split(/[\\/]/).pop();
	}

    // prende un parametro dall'URL
	function getUrlParam( paramName ) {
	    var reParam = new RegExp( '(?:[\?&]|&)' + paramName + '=([^&]+)', 'i' );
	    var match = window.location.search.match( reParam );
	    return ( match && match.length > 1 ) ? match[1] : null;
	}

	// ...
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

	// ...
	function checkAndSubmit( form ) {

		// var f = document.getElementById( form );
		// console.log( form );

		if( $( form )[0].checkValidity() ) {
			form.submit();
		} else {
//			alert('form non compilato correttamente');
			$( form )[0].reportValidity();
		}
	
	}

    // riceve un oggetto form e una funzione da eseguire dopo aver validato il form
    function checkAndDo( form, action ) {

        console.log( form );
        console.log( action );

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

    // ...
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

	// operazioni da eseguire al caricamento della pagina
	$( document ).ready( function() {

	    // mostro l'overlay dei cookie
		$('#cookie').fadeIn();

	    // apro i modal con classe popup-open
		$('.popup-open').modal();

		// focus su un elemento
		$('.focus-on-load').focus();

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
//				url: '/mod/3400.popup/src/api/task/popup.dismiss.php',
				url: '/task/3400.popup/popup.dismiss',
				data: {idPopup:id},
				success: function(data) {
				}
			  });
		});

		// ???
		$('.in').modal('show');

	    // aggiungo la capacità di fare slideToggle() agli oggetti con classe toggler
		$('.toggler').click( function() {
		    $('#'+$(this).attr('toggle')).slideToggle();
		    $(this).find('.fa').toggle();
		});

	    // faccio il bind della funzione tooltip() ai campi con l'attributo data-toggle impostato a tooltip
		if( $('[data-toggle="tooltip"]').length ) {
		    $('[data-toggle="tooltip"]').tooltip();
		}

	    // ???
		$('[img-hover]').on('mouseover mouseout', function() {
		    var src = $(this).attr('src');
		    var hover = $(this).attr('img-hover');
		    $(this).attr('src', hover );
		    $(this).attr('img-hover', src );
		});

	    // collego il campo hidden per le checkbox
		// NOTA prima per la checkbox vuota settavamo zero, ma incasina i filtri delle viste
		$('input[type=checkbox]').click( function() {
		    if( this.checked ) {
			$(this).prev().val('1');
		    } else {
			$(this).prev().val('');
		    }
		});

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

	    // faccio il bind della funzione draggable agli oggetti con classe draggable-item
		if( $('.draggable-item').length ) {
		    $('.draggable-item').draggable({ containment: "main" });
		}

	    // ???
		$('.hint-toggle').change( function () {
		    $( '.' + $(this).attr('hint-toggle') ).hide();
		    $( '#' + $(this).attr('hint-toggle') + '-' + $(this).val() ).show();
		});

	    // ???
		$('.hint-toggle').change();

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
