
    // trigger per controllo modifica form
	var formChanged = false;
	var submitFormOkay = false;

    // duplica un subform
	function duplicate( f ) {

	    formChanged = true;

	    var parent = $( '#' + f );
		// var counter = parent.children().length - 2;
		var counter = Date.now();
	    var old = parent.children('div').first();
	    var base = old.clone().get(0);
	    var empty = null;
	    var max = parent.attr('max');

	    // NOTA - per le righe che partono invisibili fare un IF c'è una riga invisibile la mostro ELSE la duplico
	    $( base ).show();

	    if( typeof( max ) == 'undefined' || counter < max ) {

		base.attributes['id'].value = base.attributes['id'].value.replace( /_[\-0-9]+/i, '_' + counter );
		
		var focus = $( base ).find('.focus').first().get(0);

		if( typeof( focus ) !== 'undefined' ) {
		    focus.focus();
		    // console.log( $( base ).find('.focus').first().get(0) );
		    // console.log( focus );
		}

		$( base ).find('.remove-on-duplicate').each( function( i, obj ) {
		    obj.remove();
		});

		$( old ).find('.remove-after-duplicate').each( function( i, obj ) {
		    obj.remove();
		});

		$( base ).find(':disabled').each( function( i, obj ) {
		    $( obj ).removeAttr('disabled');
		});

		$( base ).find('.show-on-duplicate').each( function( i, obj ) {
		    $( obj ).show();
		    $( obj ).removeClass('hidden');
		});

		$( base ).show();
		$( base ).removeClass('hidden');

		$( base ).find( 'input, textarea, select, button' ).each( function( i, obj ) {
		    if( typeof( obj.attributes['default'] ) !== 'undefined' ) {
			empty = obj.attributes['default'].value;
		    } else {
			empty = null;
		    }
		    if( typeof( obj.attributes['id'] ) !== 'undefined' ) {
			obj.attributes['id'].value = obj.attributes['id'].value.replace( /_[\-0-9]+_/i, '_' + counter + '_' );
		    }
		    if( typeof( obj.attributes['uploader-field'] ) !== 'undefined' ) {
			obj.attributes['uploader-field'].value = obj.attributes['uploader-field'].value.replace( /_[\-0-9]+_/i, '_' + counter + '_' );
		    }
      if( typeof( obj.attributes['selectbox-field'] ) !== 'undefined' ) {
          obj.attributes['selectbox-field'].value = obj.attributes['selectbox-field'].value.replace( /_[\-0-9]+_/i, '_' + counter + '_' );
      }
      if( typeof( obj.attributes['name'] ) !== 'undefined' ) {
          obj.attributes['name'].value = obj.attributes['name'].value.replace( /\[[\-0-9]+\]/i, '[' + counter + ']' );
          obj.attributes['name'].value = obj.attributes['name'].value.replace( /_[\-0-9]+_/i, '_' + counter + '_' );
		    }
		    if( typeof( obj.attributes['type'] ) !== 'undefined' ) {
			if( obj.attributes['type'].value == 'checkbox' ) {
			    obj.checked = false;
			}
		    }
		    if( typeof( obj.attributes['value'] ) !== 'undefined' ) {
			if(
			    obj.attributes['value'].value !== '__parent_id__'
			    &&
			    ! $( obj ).hasClass( 'protect-value-on-duplicate' )
			) {
			    if( $( obj ).hasClass( 'current-date-on-duplicate' ) ) {
				$( obj ).val( moment().format('YYYY-MM-DD') );
			    } else if( $( obj ).hasClass( 'current-datetime-on-duplicate' ) ) {
				$( obj ).val( moment().format('YYYY-MM-DD[T]HH:mm') );
			    } else if( $( obj ).hasClass( 'default-value-on-duplicate' ) ) {
				$( obj ).val( obj.attributes["default"].value );
			    } else {
				$( obj ).val( empty );
			    }
			}
		    } else if( $( obj ).is( 'select' ) ) {
			$( obj ).val( empty ).prop( 'selected', true );
		    }
		});

		$( base ).find('.ajax-uploader').change( function() {
		    $(this).uploader();
		});

        
	//	$( base ).find('.selectbox').selectBox();
		$( base ).find('.selectbox').each( function() {
			$(this).selectBox();
		});


// SDF questa è la parte aggiunta ma c'è ancora qualco sa che non funziona
// creando una nuova riga di orario al check non applica correttamente i value...
		$( base ).find('input[type=checkbox]').click( function() {
		    if( this.checked ) {
			$(this).prev().val('1');
		    } else {
			$(this).prev().val('0');
			}
		});

		
		$( base ).find('input[type=checkbox]').each( function() {	
			if( $(this).prev().val() == '1' ){
				$(this).prop('checked', true);
			}
			else{
				$(this).prop('checked', false);
			}		
		});
		
// fine SDF

		old.before( base );

	    }

	}

    // operazioni da eseguire al caricamento della pagina
	$( document ).ready( function() {

	    // attivo le verifiche per le modifiche ai form
		window.addEventListener("beforeunload", function(e) {
		    if( formChanged == true && ! submitFormOkay ) {
			var confirmationMessage = 'sei sicuro di voler abbandonare la pagina?';
			( e || window.event ).returnValue = confirmationMessage;
		    }
		});

		$('.warning-if-changed').on( 'keyup change', function() { formChanged = true; } );

		if( typeof CKEDITOR !== 'undefined' && CKEDITOR != null ) {
		    for( var i in CKEDITOR.instances) {
			CKEDITOR.instances[i].on('change', function() { formChanged = true; } );
		    }
		}

		// controllo in background dello status della sessione
		setInterval( function() {
			getws( '/report/session.status', null, function( obj ){
//				var obj = JSON.parse( d );
				if( obj.time > ( obj.expires - ( obj.lifetime / 100 ) ) ) {
					$('#widget-session').fadeIn();
				}
//				console.log( obj );
			});
		}, 60000 );

	    // SDF funzione che mostra e nasconde i figli nella struttura dell'anagrafica
		$('ul.browsing-tree i').click(function() {

		    // nascondo i figli
		    $(this).siblings('ul').toggle();

		    // leggo la classe dell'elemento icon
		    var miaClasse= $(this).attr('class');

		    // console.log(miaClasse);

		    // modifico la classe dell'element icon per cambiare l'icona
		    if(miaClasse == 'fa fa-chevron-circle-up'){
			$(this).removeClass('fa fa-chevron-circle-up');
			$(this).addClass('fa fa-chevron-circle-down');
		    } else if(miaClasse == 'fa fa-chevron-circle-down'){
			$(this).removeClass('fa fa-chevron-circle-down');
			$(this).addClass('fa fa-chevron-circle-up');
		    }

		});

		// attivazione dei job in foreground
		$('.foreground-job-slider').each( function() {

			// console.log( $( this ) );
			// console.log( $( this ).attr('job-id') );

			var jobId = $( this ).attr('job-id');
			var pgBar = $( this );

			setInterval( function() {

				getws( '/job/' + jobId, null, function( d ) {

					// console.log( jobId );
					// console.log( d );

//					var obj = JSON.parse( d );

					// console.log( obj );

					console.log( pgBar.attr('aria-valuenow') );

					pgBar.attr( 'aria-valuenow', d.corrente );
					pgBar.attr( 'aria-valuemax', d.totale );

					var percentuale = Math.round( percentuale = d.corrente / d.totale * 100 );

					pgBar.width( percentuale + '%' );

				});
	
			}, 3000 );

		});

	});
