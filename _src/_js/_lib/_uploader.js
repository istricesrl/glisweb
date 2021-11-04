
    // carica un file in maniera asincrona
	$.fn.uploader = function() {

	    if( !! window.FileReader ) {

		var e = $( this ).get( 0 );
		var input = e.attributes['name'].value;
		var folder = e.attributes['uploader-folder'].value;
		var field = e.attributes['uploader-field'].value;
		var file = e.files[0];
		var reader = new FileReader();
		var size = 1024 * 1024 * 1;
		var start = 0;
		var end = size;

		window.uploadcounter = 0;
		window.uploadfilearray = [];

		$(this).next('button').fadeOut().promise().done( function() {
//		    $(this).parent().append('<img src="/_src/_img/_icons/_spinner.gif" style="height: 22px;">');
//		    $(this).parent().append('<i class="fa fa-spinner fa-spin fa-fw"></i>');
//		    $(this).html('<i class="fa fa-spinner fa-spin fa-fw"></i>');
//		    $(this).parent().append('<button class="btn btn-sm btn-secondary btn-sqr btn-spin remove-on-duplicate" disabled><i class="fa fa-circle-o-notch fa-spin fa-fw"></i></button>');
		    $(this).parent().find('.btn-spin').show();

//		$(this).next('button').html('<i class="fa fa-circle-o-notch fa-spin fa-fw"></i>');

		while( start < file.size ) {

		    try {
			var chunk = file.mozSlice( start , end );
		    } catch( err1 ) {
			try {
			    var chunk = file.webkitSlice( start , end );
			} catch( err2 ) {
			    try {
				var chunk = file.slice( start , end );
			    } catch( err3 ) {
				return false;
			    }
			}
		    }

		    window.uploadfilearray[ window.uploadcounter ] = chunk;
		    window.uploadcounter = window.uploadcounter + 1;

		    start = end;
		    end = start + size;

		}

		window.uploadcounter = 0;

		upload( file, folder, window.uploadfilearray[ window.uploadcounter ], $(this).parent(), field, function() {
//		    alert( 'finito' );
		} );

		});

	    } else {

		alert('attenzione, il tuo browser non supporta il caricamento di files con HTML5, per favore utilizza Firefox o Chrome');
		return false;

	    }

	}

    // carica in maniera asincrona un segmento di file
	function upload( file, folder, data, parent, field, callback ) {

	    var xhr = new XMLHttpRequest();
	    var event = xhr.upload || xhr;
	    var progress = 0;

	    // xhr.open('post', siteRoot + '_src/_api/_file.php', true );
	    xhr.open('post', siteRoot + 'api/upload', true );
	    xhr.setRequestHeader( "Content-Type", "application/octet-stream");
	    xhr.setRequestHeader( "X-File-Name", strClean( file.name ) );
	    xhr.setRequestHeader( "X-File-Type", file.type );
	    xhr.setRequestHeader( "X-File-Size", data.size );
	    xhr.setRequestHeader( "X-Chunk-Number", window.uploadcounter );
	    xhr.setRequestHeader( "X-Chunk-Total", window.uploadfilearray.length - 1 );
	    xhr.setRequestHeader( "X-Target-Folder", folder );

	    xhr.onreadystatechange = function() {
		if(xhr.readyState == 4) {
		    if(xhr.status == 200) {
			obj = JSON.parse( xhr.responseText );
			window.uploadcounter = window.uploadcounter + 1;
			if( window.uploadcounter < window.uploadfilearray.length ) {
			    upload( file, folder, window.uploadfilearray[ window.uploadcounter ], parent, field );
			    progress = Math.round( ( window.uploadcounter / window.uploadfilearray.length ) * 100 );
//			    console.log('progresso: ' + progress );
			} else {
			    //console.log('path: ' + obj.filePath );
			    $( '#' + field ).val( obj.filePath );
			    // parent.addClass('col-form-label');
			    // TODO sarebbe bello poter usare questo anziché html() in modo da
			    // salvare il campo input e poterlo mostrare di nuovo almomento del duplicate()
			    // però non sono riuscito a rimuovere l'img dello spinner dai child del parent
			    // parent.append('<span class="remove-on-duplicate">finito</span>');
			    // parent.html('<span class="remove-on-duplicate"><img src="/_src/_img/_icons/_check.gif" style="height: 31px;"></span>');
//			    parent.html('<img class="remove-on-duplicate" src="/_src/_img/_icons/_check.gif" style="height: 31px;">');
//			    parent.html('<button title="fai clic qui per visualizzare il file in una nuova scheda" class="btn btn-sm btn-secondary remove-on-duplicate" onclick="window.open(\'' + siteRoot + obj.filePath + '\',\'_blank\');"><i class="fa fa-check" aria-hidden="true"></i><span class="hide-text" > file caricato: '+ obj.filePath.slice(14) +' </span> </button>');
//			    alert( 'finito' );
			    $('.btn-spin').remove();
//			    console.log( parent );
//			    console.log( parent.children() );
			    parent.append('<button class="btn btn-sm btn-secondary btn-sqr remove-on-duplicate" onclick="window.open(\'' + siteRoot + obj.filePath + '\',\'_blank\');"><i class="fa fa-check" aria-hidden="true"></i></button>');

//			    parent.next('button').html('<i class="fa fa-check fa-fw"></i>');
			}
		    } else {
			console.log('errore: ' + xhr.status);
		    }
		}
	    };

	    if( 'getAsBinary' in file ) {
		xhr.sendAsBinary( data.getAsBinary() );
	    } else {
		xhr.send( data );
	    }

	    if( typeof( callback ) == 'function' ) {
		callback();
	    }

	}

    // operazioni da eseguire al caricamento della pagina
	$( document ).ready( function() {

	    $('.ajax-uploader').change( function() {
            $(this).uploader();
        });
    
	});
