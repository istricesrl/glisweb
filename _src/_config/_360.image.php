<?php

    /**
     * immagini
     *
     *
     *
     *
     *
     *
     *
     *
     * @file
     *
     */

    // definisco i formati delle immagini
	$cf['image']['size']['l'] = array(
	    160, 320, 640, 720, 1024, 1280, 1680, 1920, 2048
	);

	$cf['image']['size']['p'] = array(
	    80, 240, 480, 640, 720, 960, 1024, 1280, 2048
	);

	$cf['image']['formats']['l'] = array(
	    160 => 80,
	    320 => 240,
	    480 => 320,
	    640 => 480,
	    960 => 640,
	    1024 => 768,
	    1280 => 1024,
	    1600 => 1200,
	    1920 => 1280,
	    2048 => 1152
	);

	$cf['image']['formats']['p'] = array(
	    240 => 320,
	    320 => 480,
	    768 => 1024,
	    1024 => 1200
	);

    // definisco le tabelle in cui cercare le immagini e i relativi formati
#	$cf['image']['resize'] = array();

    // collego l'array $ct
	$ct['image'] = &$cf['image'];

/*
Common Aspect Ratios
Aspect Ratio	Decimal	Description
1:1	1.0	Square
5:4	1.25	
4:3	1.333	
8:5	1.6	
16:9	1.777	

Computer Screens
Dimensions (width x height)	Aspect Ratio	Description
320 x 200	1.6	CGA (color)
640 x 200	3.2	CGA (monochrome)
640 x 350	1.83	EGA
640 x 480	1.333	VGA
720 x 348	2.07	Hercules
1024 x 768	1.333	XGA
1280 x 1024	1.25	
1366 x 768	1.78	widescreen
1600 x 1200	1.333	
1680 x 1050	1.6	widescreen
1920 x 1200	1.6	widescreen

Tablet Screens
Dimensions (width x height)	DPI	Description
1024 x 600	169	Amazon Kindle
1024 x 768	132	Apple iPad, iPad 2
2048 x 1536	264	Apple iPad ("new" 2012)

PDA and Phone Screens
Dimensions (width x height)	DPI	Description
160 x 160		Palm (original)
176 x 208		Nokia Series 60 (original)
240 x 320		Nokia Series 60 (series 2)
320 x 240		Nokia Series 60 (series 3, landscape mode)
320 x 320		Palm (Tungsten and Zire)
352 x 416		Nokia Series 60 (series 2, feature pack 3)
416 x 352		Nokia Series 60 (series 3, landscape mode)
320 x 480		iPhone/iPod Touch - Portrait
480 x 320		iPhone/iPod Touch - Landscape
320 x 416		iPhone/iPod Touch - Safari content area - Portrait
480 x 268		iPhone/iPod Touch - Safari content area - Landscape
320 x 480		Android (HVGA)
960 x 640	326	Apple iPhone 4/4S
1136 x 640		iPhone 5

*/

    // debug
    // echo 'OUTPUT';
