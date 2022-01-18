function getProgressivoInvioFattura( id ) {

    getws(
        '/task/6200.documenti/fatture.genera.progressivo.invio',
        null,
        function( data ) {

            console.log( data );
            $( '#'+id ).val( data.new );

        }
    );


}