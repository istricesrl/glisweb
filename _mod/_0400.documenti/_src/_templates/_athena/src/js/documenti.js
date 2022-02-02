function getProgressivoInvioFattura( id, ida ) {

    getws(
        '/task/6200.documenti/fatture.genera.progressivo.invio?idAzienda='+ida,
        null,
        function( data ) {

            console.log( data );
            $( '#'+id ).val( data.new );

        }
    );


}
