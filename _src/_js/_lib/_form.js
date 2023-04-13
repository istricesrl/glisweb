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
        }

        // se il campo è un'email ed è valorizzato controllo la sintassi
        if( $(this).attr('type') == 'email' && $(this).val() ){
            ck += checkEmail( $(this) );
        }

        // se il campo è un telefono ed è valorizzato controllo la sintassi
        if( $(this).attr('type') == 'tel' && $(this).val() ){
            ck += checkTelefono( $(this) );
        }
    });

    if( ck.indexOf('0') >= 0 ){
        return false;
    }
    else{
        return true;
    }
    
}
