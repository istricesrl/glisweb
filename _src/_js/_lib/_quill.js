	// operazioni da eseguire al caricamento della pagina
	$( document ).ready( function() {
		/*
				var pellEditors = [];
		
				$('.pellEditor').each( function( i, obj ) {
		
					console.log(obj);
		
					editor = document.getElementById( obj.attributes['id'].value );
					editorId = obj.attributes['id'].value;
		
					var quill = new Quill( "#" + editorId, {
						theme: "snow",
					});
		
				});
		
		*/
				$('.quillEditor').each(function(i, el) {
		
					var el = $(this), id = 'quilleditor-' + i, val = el.val(), editor_height = 200;
					var div = $('<div/>').attr('id', id).css('height', editor_height + 'px').html(val);
		
					el.addClass('d-none');
					el.parent().append(div);
				
					const toolbarOptions = [
						['bold', 'italic', 'underline', 'strike'],        // toggled buttons
						['link'],
						['blockquote', 'code-block'],
		
						// ancora
						// tabella
						// linea orizzontale
						// inserisci simboli
		
						[{ 'list': 'ordered'}, { 'list': 'bullet' }, { 'list': 'check' }],
						[{ 'script': 'sub'}, { 'script': 'super' }],      // superscript/subscript
		
						[{ 'header': [1, 2, 3, 4, 5, 6, false] }],
		
						[{ 'color': [] }],          // dropdown with defaults from theme
						[{ 'font': [] }],
						[{ 'align': [] }],
		
						['clean']                                         // remove formatting button
					];
		
					var quill = new Quill('#' + id, {
						modules: { toolbar: toolbarOptions },
						theme: 'snow'
					});
		
					quill.on('text-change', function() {
						console.log('updating...');
						console.log(quill.getContents());
						contents = quill.getContents();
						console.log(contents.ops[0].insert);
						console.log(quill.root.innerHTML);
						el.html(quill.root.innerHTML);
					});
		
				});
		
			});
		