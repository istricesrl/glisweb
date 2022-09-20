--
-- PATCH
--

--| 202209190010
ALTER TABLE `file` DROP KEY `indice`;

--| 202209190020
ALTER TABLE `file`
    ADD COLUMN `id_attivita` int(11) DEFAULT NULL AFTER `id_licenza`, 
    ADD KEY `id_attivita` (`id_attivita`);

--| 202209190030
ALTER TABLE `attivita`
    ADD CONSTRAINT `file_ibfk_28` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
    
--| 202209190040
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
		file.id_progetto,
		file.id_categoria_progetti,
		file.id_indirizzo,
		file.id_edificio,
		file.id_immobile,
		file.id_contratto,
        file.id_valutazione,
        file.id_rinnovo,
		file.id_anagrafica_certificazioni,
		file.id_valutazione_certificazioni,
		file.id_licenza,
		file.id_lingua,
		lingue.iso6393alpha3 AS lingua,
		file.id_attivita,
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

--| FINE