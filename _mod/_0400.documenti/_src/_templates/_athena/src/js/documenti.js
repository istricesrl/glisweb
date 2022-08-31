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

function getNumeroDocumento( id, ida, sez, idt ) {

    getws(
        '/task/0400.documenti/documenti.genera.numero?idAzienda='+ida+'&sezionale='+sez+'&idTipologia='+idt,
        null,
        function( data ) {
            console.log( data );
            $( '#'+id ).val( data.new );
            if( data.err ) { alert( data.err ); }
        }
    );


}
