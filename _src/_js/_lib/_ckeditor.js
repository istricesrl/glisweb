	// operazioni da eseguire al caricamento della pagina
	$( document ).ready( function() {

		window.name = 'cms';

	    var ckEditors = [];
	    $('.ckEditor').each( function( i, obj ) {
//		$(obj).attr('height',$(obj).parent().height());
		if( obj.hasAttribute('height') ) { var hg = obj.attributes['height'].value; } else { var hg = 390; }
		var editor = CKEDITOR.replace( obj.attributes['id'].value, {
		    height: hg,
		    allowedContent: true,
		    entities: false,
		    toolbarGroups: [
			{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
			{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
			{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
			{ name: 'forms', groups: [ 'forms' ] },
			{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
			{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
			{ name: 'links', groups: [ 'links' ] },
			{ name: 'insert', groups: [ 'insert' ] },
			{ name: 'styles', groups: [ 'styles' ] },
			{ name: 'colors', groups: [ 'colors' ] },
			{ name: 'tools', groups: [ 'tools' ] },
			{ name: 'others', groups: [ 'others' ] },
			{ name: 'about', groups: [ 'about' ] }
		    ],
		    removeButtons: 'Save,Undo,Redo,NewPage,Preview,Print,Templates,Find,Replace,SelectAll,Scayt,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,CopyFormatting,RemoveFormat,Outdent,Indent,Blockquote,CreateDiv,BidiLtr,BidiRtl,Language,Flash,Smiley,PageBreak,Iframe,ShowBlocks,About,Styles,Cut,Copy,Paste,PasteText,PasteFromWord',
		    extraPlugins: 'colorbutton,font,colordialog,ckawesome,autogrow',
		    extraAllowedContent: 'img',
		    filebrowserBrowseUrl: siteRoot + 'file-browser?type=Files'
		});
		ckEditors.push( editor );
		// CKEDITOR.config.protectedSource.push( /\{\%[\s\S]*?%\}/g );
/*
		CKEDITOR.config.protectedSource = [
			/\{\{[\s\S]*?\}\}/g,
			/\{\%[\s\S]*?%\}/g,
			/\{\#[\s\S]*?#\}/g,
		];
*/
        CKEDITOR.config.shiftEnterMode = CKEDITOR.ENTER_DIV;
        CKEDITOR.config.enterMode = CKEDITOR.ENTER_P;
        // CKEDITOR.config.autoParagraph = false;
		CKEDITOR.dtd.$removeEmpty["i"] = false;
		CKEDITOR.dtd.$removeEmpty["span"] = false;
		CKEDITOR.plugins.basePath = siteRoot + '_src/_js/_lib/_external/ckeditor/plugins/';
/*
		CKEDITOR.on('instanceLoaded', function(e) {
			var wt = $(obj).parent().width();
			var hg = $(obj).parent().height();
			console.log(wt+' '+hg);
			e.editor.resize(wt, hg, false);
		});
	*/
	    });
	});
