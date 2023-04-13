    // scambio due div con effetto cross fade
	function crossFade( show, hide ) {

	    if( $('#'+show).is(':visible') ) {
		[show,hide] = [hide,show];
	    }

//	    console.log( show + '|' + hide );

	    // $('#'+hide).fadeOut().promise().done( $('#'+show).fadeIn() );

//	    console.log( 'hide: ' + hide );
	    $('#'+hide).fadeOut();

//	    console.log( 'show: ' + show );
	    $('#'+show).fadeIn();

//	    console.log( 'done' );

	}

    // fa apparire un div in un insieme e nasconde gli altri con effetto show hide
	function crossShow( show, hide, obj ) {

	    $( obj ).addClass('active').parent().siblings().children().removeClass('active');

	    $('.'+hide).hide();
	    $('#'+show).show();

	}

