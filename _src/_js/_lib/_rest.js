
    /*
     * libreria di funzioni utili per le chiamate REST
     *
     *
     *
     */

    // interrogo un webservice
	function getws( url, params, callback, fail ) {

		//	    console.log( params );
		
				$.ajax({
				async: true,
				url: url,
				method: 'GET',
				data: params,
				processData: false,
		//		contentType: 'application/json',
		//		dataType: 'application/json'
				headers: {
					accept: 'application/json'
		//		    contentType: 'application/json'
				}
				}).done( function( data ) {
		//		console.log( data );
				if( typeof callback === "function" ) {
					callback( data );
				} else {
					return data;
				}
				}).fail( function( data, jqxhr, status, thrown ) {
		//		console.log( "error: " + status );
		//		console.log( "exception: " + thrown );
		//		console.log( "message: " + jqxhr.responseText );
				if( typeof fail === "function" ) {
					fail( data, jqxhr, status, thrown );
				} else {
					return false;
				}
				});
		
			}
		
			function postws( url, params, callback ) {
		
				//	    console.log( params );
				
						$.ajax({
						async: true,
						url: url,
						method: 'POST',
						data: params,
						processData: false,
				//		contentType: 'application/json',
				//		dataType: 'application/json'
						headers: {
							accept: 'application/json'
				//		    contentType: 'application/json'
						}
						}).done( function( data ) {
				//		console.log( data );
						if( typeof callback === "function" ) {
							callback( data );
						} else {
							return data;
						}
						}).fail( function( jqxhr, status, thrown ) {
				//		console.log( "error: " + status );
				//		console.log( "exception: " + thrown );
				//		console.log( "message: " + jqxhr.responseText );
						return false;
						});
				
			}
		
			// tool per chiamare un webservice da un bottone dell'interfaccia metro
			$.fn.metroWs = function( ws, callback, method, data ) {
		
                var el = $( this ).get( 0 );
				var e = this;

                if( typeof callback !== "function" ) {
                    callback = function( data ) {
                        console.log( data );
                    }
                }

                // se method non è valorizzato
				if( method == null ) {
					method = 'GET';
				}
		
				console.log( e.find('.media-left').first().html() );
		
				if( e.find('.media-left').first().html() == '<i class="fa fa-bookmark"></i>' ) {
					var icon = '<i class="fa fa-bookmark-o"></i>';
				} else if( e.find('.media-left').first().html() == '<i class="fa fa-bookmark-o"></i>' ) {
					var icon = '<i class="fa fa-bookmark"></i>';
				} else {
					var icon = '<i class="fa fa-check"></i>';
				}
		
				// console.log( el );
				// console.log( this );
				// console.log( $(this) );
		
				// $(el).children('.media-left').first().html('<i class="fa fa-circle-o-notch fa-spin fa-fw">');
				// el.children('.media-left').first().html('<i class="fa fa-circle-o-notch fa-spin fa-fw">');
		
				e.find('.media-left').first().html('<i class="fa fa-circle-o-notch fa-spin">');
		
				// getws( ws, null, function( d, el ) { console.log( d ); console.log( el ); } );
		
				// console.log( getws( ws ) );
		
				// $.when( getws( ws ) ).done( function( el ) { console.log( 'done' ); console.log( el ); } );
		
				$.ajax({
					async: true,
					url: ws,
					// method: 'GET',
					method: method,
					data: data,
					contentType: 'application/json',
					headers: { accept: 'application/json' }
					}).done( function( data ) {
			//		console.log( e );
					console.log(data);
					// TODO se data è vuoto o se contiene errori, mostrare un'icona di avvertimento o una x
					console.log( icon );
					e.find('.media-left').first().html( icon );
					callback( data );
				});
		
			}
		
			$.fn.metroLoopWs = function( ws, callback = null, icon = null, el = null, count = 0 ) {
				if( el == null ) {
					el = this;
					var icon = el.find('.media-left').first().html();
					el.find('.media-left').first().html('<i class="fa fa-circle-o-notch fa-spin">');
				}
				var request = new XMLHttpRequest();
				request.open( 'GET', ws, true );
				request.onload = function () {
				  var data = JSON.parse( this.response );
				  console.log( data );
				  if( data.aggiornare.id ) {
					$.fn.metroLoopWs( ws, callback, icon, el, count+1 );
				  } else {
					el.find('.media-left').first().html( icon );
					if( callback != null ) {
						callback();
					}
				  }
				}
				request.send();
			}
			