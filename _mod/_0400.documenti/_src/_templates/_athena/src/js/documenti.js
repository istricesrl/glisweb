function getProgressivoInvioFattura( id, ida ) {

    getws(
        '/task/0400.documenti/fatture.genera.progressivo.invio?idAzienda='+ida,
        null,
        function( data ) {

            console.log( data );
            $( '#'+id ).val( data.new );

        }
    );


}

/**
 * salva il form che contiene il campo indicato, come il pulsante "salva e rimani"
 *
 * Serve a OTTIENI NUMERO: il numero ottenuto e' il prossimo libero solo finche' nessun altro salva
 * un documento con lo stesso sezionale, quindi va scritto subito. Due operatori che chiedevano il
 * numero e salvavano piu' tardi prendevano lo stesso numero ( collisioni segnalate da Lughese, 30/10/2026 ).
 *
 * requestSubmit() fa scattare la validazione del browser: se manca un campo obbligatorio il form non
 * parte, il browser indica il campo e il numero resta scritto, da salvare a mano.
 *
 * @param       string      id      l'id del campo che sta nel form da salvare
 *
 */
function salvaFormDelCampo( id ) {

    var form = $( '#'+id ).closest( 'form' ).get( 0 );

    if( ! form ) { return; }

    submitFormOkay = true;

    if( typeof form.requestSubmit === 'function' ) {
        form.requestSubmit();
    } else if( form.reportValidity() ) {
        $( form ).submit();
    }

}

function getNumeroDocumento( id, ida, sez, idt ) {

    getws(
        '/task/0400.documenti/documenti.genera.numero?idAzienda='+ida+'&sezionale='+sez+'&idTipologia='+idt,
        null,
        function( data ) {
            console.log( data );
            $( '#'+id ).val( data.new );
            if( data.err ) { alert( data.err ); }
            else if( data.new ) { salvaFormDelCampo( id ); }
        }
    );


}
