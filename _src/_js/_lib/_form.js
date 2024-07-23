/*
 * libreria di funzioni per il check dei form, utili anche se attivo Google reCaptcha
 *
 */

/**
 * funzione che controlla la validità di un indirizzo mail e inserisce un messaggio di errore se errato
 * 
 * @param {*} obj   oggetto su cui effettuare il controllo
 * @returns         ritorna 1 o 0 a seconda dell'esito del controllo
 */
function checkEmail( obj ) {
	// valore valido
	if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test( obj.val() ) ) {
		return 1;
	} 
	// valore NON valido
	else {
        obj.after('<div class="label-err"><label>inserire un indirizzo email valido</label></div>');
		return 0;
	}
}

/**
 * funzione che controlla la validità di un numero di telefono
 * 
 * @param {*} obj   oggetto su cui effettuare il controllo
 * @returns         ritorna 1 o 0 a seconda dell'esito del controllo
 */
function checkTelefono( obj ) {
    // valore valido
    if ( /^.{8,}[0-9 -()+]+$/.test( obj.val() ) ) {
        return 1;
    } 
    // valore NON valido
    else {
        obj.after('<div class="label-err"><label>inserire un numero di telefono valido</label></div>');
        return 0;
    }
}

/**
 * funzione che controlla se un campo required è compilato
 * @param {*} obj   oggetto su cui effettuare il controllo
 * @returns         ritorna 1 o 0 a seconda dell'esito del controllo
 */
 function checkRequired( obj ){

    if( obj.attr('type') == 'checkbox' ){
        if( obj.is(':checked') ){
            return 1;
        }
        else{
            // leggo le classi del padre per associarle alla div di errore
            var c =  obj.parent().attr('class');
            obj.parent().after('<div class="label-err ' + c + '"><label>campo obbligatorio</label></div>');
            return 0;
        }
    }
    else{
        if( obj.val() ){
            return 1;
        }
        else{
            obj.after('<div class="label-err"><label>campo obbligatorio</label></div>');
            return 0;
        }  
    }
    
}

/**
 * funzione che controlla la validità dei dati inseriti in un form
 * @param {*} f     id del form
 * @returns         ritorna true o false a seconda dell'esito del controllo
 */
function checkForm( f ){

    // rimozione degli eventuali messaggi di errore
    $( '#'+f ).find('.label-err').remove();

    var ck = '';

    $( '#'+f ).find(':input').each( function() {
        
        
        // verifico se il campo è required
        if( $(this).prop('required') ){
            ck += checkRequired( $(this) );   
            if( checkRequired( $(this) ) == 0 ){
                console.log('errore mancata compilazione campo required ' + $(this).prop('name') );
            }
            
        }

        // se il campo è un'email ed è valorizzato controllo la sintassi
        if( $(this).attr('type') == 'email' && $(this).val() ){
            ck += checkEmail( $(this) );
            if( checkEmail( $(this) ) == 0 ){
                console.log('errore formato email campo ' + $(this).prop('name') );
            }
            
        }

        // se il campo è un telefono ed è valorizzato controllo la sintassi
        if( $(this).attr('type') == 'tel' && $(this).val() ){
            ck += checkTelefono( $(this) );
            if( checkTelefono( $(this) ) == 0 ){
                console.log('errore formato telefono campo ' + $(this).prop('name') );
            }
        }
    });

    console.log('check: ' + ck );

    if( ck.indexOf('0') >= 0 ){
        return false;
    }
    else{
        return true;
    }
    
}

// operazioni da eseguire al caricamento della pagina
$( document ).ready( function() {

    // debug
    console.log( 'form.js' );

    // campi che se valorizzati ne rendono altri required
    $('input[also-required]').each( function() {

        // console.log( this );

        $( this ).keyup( function() {

            // console.log( 'changed' );
            // console.log( $( this ).val().length );

            if( $( this ).val().length > 0 ) {

                // console.log( 'required: ' + $( this ).attr( 'also-required' ) );

                var campi = $( this ).attr( 'also-required' ).split( ',' );

                $.each( campi, function( i ) {

                    // console.log( campi[ i ] );
                    // console.log( '#' + campi[ i ] );

                    $( '#' + $.trim( campi[ i ] ) ).attr( 'disabled', false );
                    $( '#' + $.trim( campi[ i ] ) ).attr( 'required', true );

                });

            } else {

                var campi = $( this ).attr( 'also-required' ).split( ',' );

                $.each( campi, function( i ) {

                    // console.log( campi[ i ] );

                    $( '#' + $.trim( campi[ i ] ) ).attr( 'disabled', true );
                    $( '#' + $.trim( campi[ i ] ) ).attr( 'required', false );

                });

            }

        });

    });

    // campi che devono essere uguali
    $('input[required-equals]').each( function() {

        $( this ).keyup( function() {

            var campi = $( this ).attr( 'required-equals' ).split( ',' );

            $.each( campi, function( i ) {

                var campo = $( '#' + campi[ i ] )[0];
                var value = $( '#' + campi[ i ] ).val();

                campo.setCustomValidity( '' );

                for( var n = 0; n < campi.length; n++ ) {

                    if( value != $( '#' + campi[ n ] ).val() ) {

                        console.log( 'not match' );
                        console.log( value + ' != ' + $( '#' + campi[ n ] ).val() );
                        campo.setCustomValidity( 'i campi non corrispondono' );
                        
                    } else {

                        console.log( 'match' );
                        console.log( value + ' == ' + $( '#' + campi[ n ] ).val() );
                        
                    }

                }

            });

        });

    });

});
