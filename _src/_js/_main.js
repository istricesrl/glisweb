
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

	// restituisce un oggetto con longitudine e latitudine 
	/*function getCoords(){
		var startPos;
		var lo;
		var la;
		var geoSuccess = function(position) {
			startPos = position;
			lo = startPos.coords.longitude;
			la = startPos.coords.latitude;
			console.log(lo+","+la );
			return( lo+","+la );
		};
  		navigator.geolocation.getCurrentPosition(geoSuccess);
		//return( lo+","+la );
	}*/

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
				url: '/_mod/_3400.popup/_src/_api/_task/_popup.dismiss.php',
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
		$('input[type=checkbox]').click( function() {
		    if( this.checked ) {
			$(this).prev().val('1');
		    } else {
			$(this).prev().val('0');
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

	    // attivo l'hover per gli elementi li delle navbar con classe navbar-slider
		$('nav.navbar-slider ul li').hover(
		    function() {
			$(this).children('ul').slideDown( 200 );
		    },
		    function() {
			$(this).find('ul').hide();
		    }
		);

	    // attivo l'hover per gli elementi ul.nav delle navbar con classe navbar-slider-mega
		$('nav.navbar-slider-mega ul.nav').children('li').hover(
		    function() {
			$(this).children('ul').slideDown( 200 );
		    },
		    function() {
			$(this).children('ul').hide();
		    }
		);

	});
