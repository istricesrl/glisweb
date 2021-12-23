--
-- PATCH
--

--| 202112140000

ALTER TABLE `ruoli_file`  ADD `se_mail` INT NULL DEFAULT NULL ;

--| 202112140010

INSERT INTO `ruoli_file` (`id`, `nome`, `se_anagrafica`, `se_pagine`, `se_categorie_prodotti`, `se_template`, `se_prodotti`, `se_articoli`, `se_categorie_risorse`, `se_mail`) VALUES (1,	    'allegato',	        1,	    1,	    1,	    1,	    1,	    1,	    NULL,	    1)
ON DUPLICATE KEY UPDATE	nome = VALUES( nome ),
	se_anagrafica = VALUES( se_anagrafica ),
	se_pagine = VALUES( se_pagine ),
	se_categorie_prodotti = VALUES( se_categorie_prodotti ),
	se_template = VALUES( se_template ),
	se_mail = VALUES( se_mail ),
	se_prodotti = VALUES( se_prodotti ),
	se_articoli = VALUES( se_articoli ),
	se_categorie_risorse = VALUES( se_categorie_risorse )
;
--| 202112140020

CREATE OR REPLACE VIEW ruoli_file_view AS
	SELECT
		ruoli_file.id,
		ruoli_file.id_genitore,
		ruoli_file.nome,
		ruoli_file.html_entity,
		ruoli_file.font_awesome,
		ruoli_file.se_anagrafica,
		ruoli_file.se_pagine,
		ruoli_file.se_prodotti,
		ruoli_file.se_articoli,
		ruoli_file.se_categorie_prodotti,
		ruoli_file.se_notizie,
		ruoli_file.se_categorie_notizie,
		ruoli_file.se_risorse,
		ruoli_file.se_categorie_risorse,
		ruoli_file.se_mail,
	 	ruoli_file_path( ruoli_file.id ) AS __label__
	FROM ruoli_file
;

--| 202112140030

ALTER TABLE `file`  ADD `id_mail_out` INT NULL DEFAULT NULL AFTER `id_lingua` ;

--| 202112140040

ALTER TABLE `file`  ADD `id_mail_sent` INT NULL DEFAULT NULL AFTER `id_lingua`;

--| 202112140050

ALTER TABLE `file`
	ADD KEY `id_mail_out` (`id_mail_out`), 
	ADD KEY `id_mail_sent` (`id_mail_sent`);

--| 202112140060

ALTER TABLE `file`
    ADD CONSTRAINT `file_ibfk_14`           FOREIGN KEY (`id_mail_out`) REFERENCES `mail_out` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_15`           FOREIGN KEY (`id_mail_sent`) REFERENCES `mail_sent` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202112140070

CREATE OR REPLACE VIEW `file_view` AS
	SELECT
		file.id,
		file.ordine,
		file.id_ruolo,
		ruoli_file.nome AS ruolo,
		file.id_anagrafica,
		file.id_prodotto,
		file.id_articolo,
		file.id_categoria_prodotti,
		file.id_todo,
		file.id_pagina,
		file.id_template,
		file.id_notizia,
		file.id_categoria_notizie,
		file.id_risorsa,
		file.id_categoria_risorse,
		file.id_mail_out,                    
		file.id_mail_sent, 
		file.id_lingua,
		lingue.iso6393alpha3 AS lingua,
		file.path,
		file.url,
		file.nome,
		file.id_account_inserimento,
		file.id_account_aggiornamento,
		concat(
			ruoli_file.nome,
			' # ',
			file.ordine,
			' / ',
			file.nome,
			' / ',
			coalesce(
				file.path,
				file.url
			)
		) AS __label__
	FROM file
		LEFT JOIN ruoli_file ON ruoli_file.id = file.id_ruolo
		LEFT JOIN lingue ON lingue.id = file.id_lingua
;

--| FINE FILE
