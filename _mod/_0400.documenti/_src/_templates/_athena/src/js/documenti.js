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
