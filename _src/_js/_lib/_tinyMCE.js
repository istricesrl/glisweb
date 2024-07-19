	// operazioni da eseguire al caricamento della pagina
	$( document ).ready( function() {

		tinymce.init({
			selector: '.tinyMCE',
			menubar: false,
			plugins: 'advlist autolink lists link image charmap preview anchor pagebreak code table',
			toolbar: "styles | undo redo | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist | code styleselect table",

		});

	});
