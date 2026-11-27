--
-- 2026-11-10 — colori: tabella assistita, precompilata coi colori con nome di CSS Color 4 e organizzata per famiglie
--
-- Schema canonico, punto 6g, decisione di Fabio del 10/11/2026 ( opzione A ): colori passa da standard ad assistita ( i
-- colori della variante di un articolo sono dell'utente ) e si precompila coi 148 colori con nome di CSS Color 4 ( W3C ),
-- il cui hex è normativo, sotto undici famiglie radice. I nomi sono in italiano, la parola chiave CSS sta in codice_css.
--
-- Cosa fa:
-- - aggiunge codice_css e la coda di audit, con le loro chiavi e le FK 98/99; ricrea indice con codice_css;
-- - aggiunge le radici 2 ( giallo ), 10 ( effetto carbonio ) e 11-15 ( arancione, viola, rosa, marrone, grigio );
-- - sulle righe 1-10 del framework, riconosciute da id e nome, scrive codice_css e famiglia: verde passa a 008000 ( il
--   verde CSS; 00ff00 è verde lime ), i tre RAL prendono il nome italiano ufficiale, carbon look diventa effetto carbonio;
-- - aggiunge i RAL 7-9 e i colori 16-145, e le dichiarazioni CSS dell'effetto carbonio dove la riga 10 è nuova.
-- Le righe si aggiungono solo dove c'è già la riga 1 del framework: un deploy con la tabella vuota resta vuoto. La vista
-- sta nel file base.
--
-- Cosa NON fa: non tocca le righe aggiunte dall'utente ( le INSERT sono IGNORE ), non riempie c, m, y, k.
--
-- IDEMPOTENTE.
--

-- | 202611102200

-- colori: codice_css e coda di audit
ALTER TABLE `colori`
	ADD COLUMN IF NOT EXISTS `codice_css` char(32) DEFAULT NULL AFTER `nome`,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL AFTER `css`,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL AFTER `timestamp_inserimento`,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`;

-- | 202611102201

-- colori: indice tolto, si ricrea con codice_css
ALTER TABLE `colori`
	DROP INDEX IF EXISTS `indice`;

-- | 202611102202

-- colori: chiavi del canone
ALTER TABLE `colori`
	ADD UNIQUE KEY IF NOT EXISTS `unica_css` (`codice_css`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`nome`,`codice_css`,`hex`);

-- | 202611102203

-- colori: account della coda di audit
ALTER TABLE `colori`
	ADD CONSTRAINT `colori_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `colori_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611102204

-- colori: le radici nuove, dove ci sono già le righe del framework
INSERT IGNORE INTO `colori` ( `id`, `id_genitore`, `nome`, `codice_css`, `hex`, `r`, `g`, `b`, `ral` )
	SELECT s.* FROM (
		SELECT 2 AS id, NULL AS id_genitore, 'giallo' AS nome, 'yellow' AS codice_css, 'ffff00' AS hex, 255 AS r, 255 AS g, 0 AS b, NULL AS ral
		UNION ALL SELECT 10, NULL, 'effetto carbonio', NULL, NULL, NULL, NULL, NULL, NULL
		UNION ALL SELECT 11, NULL, 'arancione', 'orange', 'ffa500', 255, 165, 0, NULL
		UNION ALL SELECT 12, NULL, 'viola', 'purple', '800080', 128, 0, 128, NULL
		UNION ALL SELECT 13, NULL, 'rosa', 'pink', 'ffc0cb', 255, 192, 203, NULL
		UNION ALL SELECT 14, NULL, 'marrone', 'brown', 'a52a2a', 165, 42, 42, NULL
		UNION ALL SELECT 15, NULL, 'grigio', 'gray', '808080', 128, 128, 128, NULL
	) s
	WHERE EXISTS ( SELECT 1 FROM `colori` f WHERE f.id = 1 AND f.nome = 'rosso' );

-- | 202611102205

-- colori: le dichiarazioni CSS dell'effetto carbonio, se la riga 10 è appena nata
UPDATE `colori` SET `css` = 'background-color: rgb(32, 32, 32); background-image: linear-gradient( 45deg, black 25%, transparent 25%, transparent 75%, black 75%, black), linear-gradient(45deg, black 25%, transparent 25%, transparent 75%, black 75%, black), linear-gradient(to bottom, rgb(8, 8, 8), rgb(32, 32, 32) ); background-size: 10px 10px, 10px 10px, 10px 5px; background-position: 0px 0px, 5px 5px, 0px 0px;'
	WHERE `id` = 10 AND `nome` = 'effetto carbonio' AND `css` IS NULL;

-- | 202611102206

-- colori: codice_css e famiglia delle righe 1-10 del framework
UPDATE `colori` t
	INNER JOIN (
		SELECT 1 AS id, 'rosso' AS vecchio, NULL AS id_genitore, 'rosso' AS nome, 'red' AS codice_css, 'ff0000' AS hex
		UNION ALL SELECT 3, 'bianco', NULL, 'bianco', 'white', 'ffffff'
		UNION ALL SELECT 4, 'nero', NULL, 'nero', 'black', '000000'
		UNION ALL SELECT 5, 'blu', NULL, 'blu', 'blue', '0000ff'
		UNION ALL SELECT 6, 'verde', NULL, 'verde', 'green', '008000'
		UNION ALL SELECT 7, 'traffic white', 3, 'bianco traffico', NULL, 'edede6'
		UNION ALL SELECT 8, 'signal red', 1, 'rosso segnale', NULL, '9a2926'
		UNION ALL SELECT 9, 'luminous yellow', 2, 'giallo brillante', NULL, 'ffff00'
		UNION ALL SELECT 10, 'carbon look', NULL, 'effetto carbonio', NULL, NULL
	) s ON s.id = t.id AND s.vecchio = t.nome
	SET t.id_genitore = s.id_genitore, t.nome = s.nome, t.codice_css = s.codice_css, t.hex = s.hex,
		t.r = IF( s.hex IS NULL, t.r, CONV( SUBSTRING( s.hex, 1, 2 ), 16, 10 ) ),
		t.g = IF( s.hex IS NULL, t.g, CONV( SUBSTRING( s.hex, 3, 2 ), 16, 10 ) ),
		t.b = IF( s.hex IS NULL, t.b, CONV( SUBSTRING( s.hex, 5, 2 ), 16, 10 ) );

-- | 202611102207

-- colori: i RAL e i colori di CSS Color 4, dove ci sono già le righe del framework
INSERT IGNORE INTO `colori` ( `id`, `id_genitore`, `nome`, `codice_css`, `hex`, `r`, `g`, `b`, `ral` )
	SELECT s.* FROM (
		SELECT 7 AS id, 3 AS id_genitore, 'bianco traffico' AS nome, NULL AS codice_css, 'edede6' AS hex, 237 AS r, 237 AS g, 230 AS b, '9016' AS ral
		UNION ALL SELECT 8, 1, 'rosso segnale', NULL, '9a2926', 154, 41, 38, '3001'
		UNION ALL SELECT 9, 2, 'giallo brillante', NULL, 'ffff00', 255, 255, 0, '1026'
		UNION ALL SELECT 16, 1, 'rosso indiano', 'indianred', 'cd5c5c', 205, 92, 92, NULL
		UNION ALL SELECT 17, 1, 'corallo chiaro', 'lightcoral', 'f08080', 240, 128, 128, NULL
		UNION ALL SELECT 18, 1, 'salmone', 'salmon', 'fa8072', 250, 128, 114, NULL
		UNION ALL SELECT 19, 1, 'salmone scuro', 'darksalmon', 'e9967a', 233, 150, 122, NULL
		UNION ALL SELECT 20, 1, 'cremisi', 'crimson', 'dc143c', 220, 20, 60, NULL
		UNION ALL SELECT 21, 1, 'mattone', 'firebrick', 'b22222', 178, 34, 34, NULL
		UNION ALL SELECT 22, 1, 'rosso scuro', 'darkred', '8b0000', 139, 0, 0, NULL
		UNION ALL SELECT 23, 1, 'bordeaux', 'maroon', '800000', 128, 0, 0, NULL
		UNION ALL SELECT 24, 2, 'oro', 'gold', 'ffd700', 255, 215, 0, NULL
		UNION ALL SELECT 25, 2, 'giallo chiaro', 'lightyellow', 'ffffe0', 255, 255, 224, NULL
		UNION ALL SELECT 26, 2, 'crema di limone', 'lemonchiffon', 'fffacd', 255, 250, 205, NULL
		UNION ALL SELECT 27, 2, 'giallo verga d\'oro chiaro', 'lightgoldenrodyellow', 'fafad2', 250, 250, 210, NULL
		UNION ALL SELECT 28, 2, 'crema di papaia', 'papayawhip', 'ffefd5', 255, 239, 213, NULL
		UNION ALL SELECT 29, 2, 'mocassino', 'moccasin', 'ffe4b5', 255, 228, 181, NULL
		UNION ALL SELECT 30, 2, 'pesca', 'peachpuff', 'ffdab9', 255, 218, 185, NULL
		UNION ALL SELECT 31, 2, 'verga d\'oro pallido', 'palegoldenrod', 'eee8aa', 238, 232, 170, NULL
		UNION ALL SELECT 32, 2, 'cachi', 'khaki', 'f0e68c', 240, 230, 140, NULL
		UNION ALL SELECT 33, 2, 'cachi scuro', 'darkkhaki', 'bdb76b', 189, 183, 107, NULL
		UNION ALL SELECT 34, 3, 'neve', 'snow', 'fffafa', 255, 250, 250, NULL
		UNION ALL SELECT 35, 3, 'melata', 'honeydew', 'f0fff0', 240, 255, 240, NULL
		UNION ALL SELECT 36, 3, 'crema di menta', 'mintcream', 'f5fffa', 245, 255, 250, NULL
		UNION ALL SELECT 37, 3, 'bianco azzurrato', 'azure', 'f0ffff', 240, 255, 255, NULL
		UNION ALL SELECT 38, 3, 'bianco alice', 'aliceblue', 'f0f8ff', 240, 248, 255, NULL
		UNION ALL SELECT 39, 3, 'bianco fantasma', 'ghostwhite', 'f8f8ff', 248, 248, 255, NULL
		UNION ALL SELECT 40, 3, 'bianco fumo', 'whitesmoke', 'f5f5f5', 245, 245, 245, NULL
		UNION ALL SELECT 41, 3, 'conchiglia', 'seashell', 'fff5ee', 255, 245, 238, NULL
		UNION ALL SELECT 42, 3, 'beige', 'beige', 'f5f5dc', 245, 245, 220, NULL
		UNION ALL SELECT 43, 3, 'pizzo antico', 'oldlace', 'fdf5e6', 253, 245, 230, NULL
		UNION ALL SELECT 44, 3, 'bianco floreale', 'floralwhite', 'fffaf0', 255, 250, 240, NULL
		UNION ALL SELECT 45, 3, 'avorio', 'ivory', 'fffff0', 255, 255, 240, NULL
		UNION ALL SELECT 46, 3, 'bianco antico', 'antiquewhite', 'faebd7', 250, 235, 215, NULL
		UNION ALL SELECT 47, 3, 'lino', 'linen', 'faf0e6', 250, 240, 230, NULL
		UNION ALL SELECT 48, 3, 'rosa lavanda', 'lavenderblush', 'fff0f5', 255, 240, 245, NULL
		UNION ALL SELECT 49, 3, 'rosa nebbia', 'mistyrose', 'ffe4e1', 255, 228, 225, NULL
		UNION ALL SELECT 50, 5, 'acqua', 'aqua', '00ffff', 0, 255, 255, NULL
		UNION ALL SELECT 51, 5, 'ciano', 'cyan', '00ffff', 0, 255, 255, NULL
		UNION ALL SELECT 52, 5, 'ciano chiaro', 'lightcyan', 'e0ffff', 224, 255, 255, NULL
		UNION ALL SELECT 53, 5, 'turchese pallido', 'paleturquoise', 'afeeee', 175, 238, 238, NULL
		UNION ALL SELECT 54, 5, 'acquamarina', 'aquamarine', '7fffd4', 127, 255, 212, NULL
		UNION ALL SELECT 55, 5, 'turchese', 'turquoise', '40e0d0', 64, 224, 208, NULL
		UNION ALL SELECT 56, 5, 'turchese medio', 'mediumturquoise', '48d1cc', 72, 209, 204, NULL
		UNION ALL SELECT 57, 5, 'turchese scuro', 'darkturquoise', '00ced1', 0, 206, 209, NULL
		UNION ALL SELECT 58, 5, 'blu cadetto', 'cadetblue', '5f9ea0', 95, 158, 160, NULL
		UNION ALL SELECT 59, 5, 'blu acciaio', 'steelblue', '4682b4', 70, 130, 180, NULL
		UNION ALL SELECT 60, 5, 'blu acciaio chiaro', 'lightsteelblue', 'b0c4de', 176, 196, 222, NULL
		UNION ALL SELECT 61, 5, 'blu polvere', 'powderblue', 'b0e0e6', 176, 224, 230, NULL
		UNION ALL SELECT 62, 5, 'azzurro', 'lightblue', 'add8e6', 173, 216, 230, NULL
		UNION ALL SELECT 63, 5, 'azzurro cielo', 'skyblue', '87ceeb', 135, 206, 235, NULL
		UNION ALL SELECT 64, 5, 'azzurro cielo chiaro', 'lightskyblue', '87cefa', 135, 206, 250, NULL
		UNION ALL SELECT 65, 5, 'azzurro cielo intenso', 'deepskyblue', '00bfff', 0, 191, 255, NULL
		UNION ALL SELECT 66, 5, 'blu dodger', 'dodgerblue', '1e90ff', 30, 144, 255, NULL
		UNION ALL SELECT 67, 5, 'blu fiordaliso', 'cornflowerblue', '6495ed', 100, 149, 237, NULL
		UNION ALL SELECT 68, 5, 'blu reale', 'royalblue', '4169e1', 65, 105, 225, NULL
		UNION ALL SELECT 69, 5, 'blu medio', 'mediumblue', '0000cd', 0, 0, 205, NULL
		UNION ALL SELECT 70, 5, 'blu scuro', 'darkblue', '00008b', 0, 0, 139, NULL
		UNION ALL SELECT 71, 5, 'blu marina', 'navy', '000080', 0, 0, 128, NULL
		UNION ALL SELECT 72, 5, 'blu notte', 'midnightblue', '191970', 25, 25, 112, NULL
		UNION ALL SELECT 73, 6, 'verde giallo', 'greenyellow', 'adff2f', 173, 255, 47, NULL
		UNION ALL SELECT 74, 6, 'verde chartreuse', 'chartreuse', '7fff00', 127, 255, 0, NULL
		UNION ALL SELECT 75, 6, 'verde prato', 'lawngreen', '7cfc00', 124, 252, 0, NULL
		UNION ALL SELECT 76, 6, 'verde lime', 'lime', '00ff00', 0, 255, 0, NULL
		UNION ALL SELECT 77, 6, 'verde limetta', 'limegreen', '32cd32', 50, 205, 50, NULL
		UNION ALL SELECT 78, 6, 'verde pallido', 'palegreen', '98fb98', 152, 251, 152, NULL
		UNION ALL SELECT 79, 6, 'verde chiaro', 'lightgreen', '90ee90', 144, 238, 144, NULL
		UNION ALL SELECT 80, 6, 'verde primavera medio', 'mediumspringgreen', '00fa9a', 0, 250, 154, NULL
		UNION ALL SELECT 81, 6, 'verde primavera', 'springgreen', '00ff7f', 0, 255, 127, NULL
		UNION ALL SELECT 82, 6, 'verde mare medio', 'mediumseagreen', '3cb371', 60, 179, 113, NULL
		UNION ALL SELECT 83, 6, 'verde mare', 'seagreen', '2e8b57', 46, 139, 87, NULL
		UNION ALL SELECT 84, 6, 'verde foresta', 'forestgreen', '228b22', 34, 139, 34, NULL
		UNION ALL SELECT 85, 6, 'verde scuro', 'darkgreen', '006400', 0, 100, 0, NULL
		UNION ALL SELECT 86, 6, 'giallo verde', 'yellowgreen', '9acd32', 154, 205, 50, NULL
		UNION ALL SELECT 87, 6, 'verde oliva opaco', 'olivedrab', '6b8e23', 107, 142, 35, NULL
		UNION ALL SELECT 88, 6, 'oliva', 'olive', '808000', 128, 128, 0, NULL
		UNION ALL SELECT 89, 6, 'verde oliva scuro', 'darkolivegreen', '556b2f', 85, 107, 47, NULL
		UNION ALL SELECT 90, 6, 'acquamarina medio', 'mediumaquamarine', '66cdaa', 102, 205, 170, NULL
		UNION ALL SELECT 91, 6, 'verde mare scuro', 'darkseagreen', '8fbc8f', 143, 188, 143, NULL
		UNION ALL SELECT 92, 6, 'verde mare chiaro', 'lightseagreen', '20b2aa', 32, 178, 170, NULL
		UNION ALL SELECT 93, 6, 'ciano scuro', 'darkcyan', '008b8b', 0, 139, 139, NULL
		UNION ALL SELECT 94, 6, 'verde acqua', 'teal', '008080', 0, 128, 128, NULL
		UNION ALL SELECT 95, 11, 'salmone chiaro', 'lightsalmon', 'ffa07a', 255, 160, 122, NULL
		UNION ALL SELECT 96, 11, 'corallo', 'coral', 'ff7f50', 255, 127, 80, NULL
		UNION ALL SELECT 97, 11, 'pomodoro', 'tomato', 'ff6347', 255, 99, 71, NULL
		UNION ALL SELECT 98, 11, 'rosso arancio', 'orangered', 'ff4500', 255, 69, 0, NULL
		UNION ALL SELECT 99, 11, 'arancione scuro', 'darkorange', 'ff8c00', 255, 140, 0, NULL
		UNION ALL SELECT 100, 12, 'lavanda', 'lavender', 'e6e6fa', 230, 230, 250, NULL
		UNION ALL SELECT 101, 12, 'cardo', 'thistle', 'd8bfd8', 216, 191, 216, NULL
		UNION ALL SELECT 102, 12, 'prugna', 'plum', 'dda0dd', 221, 160, 221, NULL
		UNION ALL SELECT 103, 12, 'violetto', 'violet', 'ee82ee', 238, 130, 238, NULL
		UNION ALL SELECT 104, 12, 'orchidea', 'orchid', 'da70d6', 218, 112, 214, NULL
		UNION ALL SELECT 105, 12, 'fucsia', 'fuchsia', 'ff00ff', 255, 0, 255, NULL
		UNION ALL SELECT 106, 12, 'magenta', 'magenta', 'ff00ff', 255, 0, 255, NULL
		UNION ALL SELECT 107, 12, 'orchidea medio', 'mediumorchid', 'ba55d3', 186, 85, 211, NULL
		UNION ALL SELECT 108, 12, 'viola medio', 'mediumpurple', '9370db', 147, 112, 219, NULL
		UNION ALL SELECT 109, 12, 'viola rebecca', 'rebeccapurple', '663399', 102, 51, 153, NULL
		UNION ALL SELECT 110, 12, 'blu violetto', 'blueviolet', '8a2be2', 138, 43, 226, NULL
		UNION ALL SELECT 111, 12, 'violetto scuro', 'darkviolet', '9400d3', 148, 0, 211, NULL
		UNION ALL SELECT 112, 12, 'orchidea scuro', 'darkorchid', '9932cc', 153, 50, 204, NULL
		UNION ALL SELECT 113, 12, 'magenta scuro', 'darkmagenta', '8b008b', 139, 0, 139, NULL
		UNION ALL SELECT 114, 12, 'indaco', 'indigo', '4b0082', 75, 0, 130, NULL
		UNION ALL SELECT 115, 12, 'blu ardesia', 'slateblue', '6a5acd', 106, 90, 205, NULL
		UNION ALL SELECT 116, 12, 'blu ardesia scuro', 'darkslateblue', '483d8b', 72, 61, 139, NULL
		UNION ALL SELECT 117, 12, 'blu ardesia medio', 'mediumslateblue', '7b68ee', 123, 104, 238, NULL
		UNION ALL SELECT 118, 13, 'rosa chiaro', 'lightpink', 'ffb6c1', 255, 182, 193, NULL
		UNION ALL SELECT 119, 13, 'rosa acceso', 'hotpink', 'ff69b4', 255, 105, 180, NULL
		UNION ALL SELECT 120, 13, 'rosa intenso', 'deeppink', 'ff1493', 255, 20, 147, NULL
		UNION ALL SELECT 121, 13, 'rosso violetto medio', 'mediumvioletred', 'c71585', 199, 21, 133, NULL
		UNION ALL SELECT 122, 13, 'rosso violetto pallido', 'palevioletred', 'db7093', 219, 112, 147, NULL
		UNION ALL SELECT 123, 14, 'seta di mais', 'cornsilk', 'fff8dc', 255, 248, 220, NULL
		UNION ALL SELECT 124, 14, 'mandorla sbiancata', 'blanchedalmond', 'ffebcd', 255, 235, 205, NULL
		UNION ALL SELECT 125, 14, 'biscotto', 'bisque', 'ffe4c4', 255, 228, 196, NULL
		UNION ALL SELECT 126, 14, 'bianco navajo', 'navajowhite', 'ffdead', 255, 222, 173, NULL
		UNION ALL SELECT 127, 14, 'grano', 'wheat', 'f5deb3', 245, 222, 179, NULL
		UNION ALL SELECT 128, 14, 'legno grezzo', 'burlywood', 'deb887', 222, 184, 135, NULL
		UNION ALL SELECT 129, 14, 'cuoio chiaro', 'tan', 'd2b48c', 210, 180, 140, NULL
		UNION ALL SELECT 130, 14, 'marrone rosato', 'rosybrown', 'bc8f8f', 188, 143, 143, NULL
		UNION ALL SELECT 131, 14, 'marrone sabbia', 'sandybrown', 'f4a460', 244, 164, 96, NULL
		UNION ALL SELECT 132, 14, 'verga d\'oro', 'goldenrod', 'daa520', 218, 165, 32, NULL
		UNION ALL SELECT 133, 14, 'verga d\'oro scuro', 'darkgoldenrod', 'b8860b', 184, 134, 11, NULL
		UNION ALL SELECT 134, 14, 'perù', 'peru', 'cd853f', 205, 133, 63, NULL
		UNION ALL SELECT 135, 14, 'cioccolato', 'chocolate', 'd2691e', 210, 105, 30, NULL
		UNION ALL SELECT 136, 14, 'cuoio', 'saddlebrown', '8b4513', 139, 69, 19, NULL
		UNION ALL SELECT 137, 14, 'terra di Siena', 'sienna', 'a0522d', 160, 82, 45, NULL
		UNION ALL SELECT 138, 15, 'grigio gainsboro', 'gainsboro', 'dcdcdc', 220, 220, 220, NULL
		UNION ALL SELECT 139, 15, 'grigio chiaro', 'lightgray', 'd3d3d3', 211, 211, 211, NULL
		UNION ALL SELECT 140, 15, 'argento', 'silver', 'c0c0c0', 192, 192, 192, NULL
		UNION ALL SELECT 141, 15, 'grigio scuro', 'darkgray', 'a9a9a9', 169, 169, 169, NULL
		UNION ALL SELECT 142, 15, 'grigio tenue', 'dimgray', '696969', 105, 105, 105, NULL
		UNION ALL SELECT 143, 15, 'grigio ardesia chiaro', 'lightslategray', '778899', 119, 136, 153, NULL
		UNION ALL SELECT 144, 15, 'grigio ardesia', 'slategray', '708090', 112, 128, 144, NULL
		UNION ALL SELECT 145, 15, 'grigio ardesia scuro', 'darkslategray', '2f4f4f', 47, 79, 79, NULL
	) s
	WHERE EXISTS ( SELECT 1 FROM `colori` f WHERE f.id = 1 AND f.nome = 'rosso' );

-- | FINE
