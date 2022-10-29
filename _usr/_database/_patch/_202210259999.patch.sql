--
-- PATCH
--

--| 202210250010
ALTER TABLE `metadati`
    ADD COLUMN `id_tipologia_contratti` int(11) DEFAULT NULL AFTER `id_pianificazione`,
    ADD UNIQUE KEY `unica_tipologia_contratti` (`id_lingua`,`id_tipologia_contratti`,`nome`),
    ADD KEY `id_tipologia_contratti` (`id_tipologia_contratti`);

--| 202210250020
ALTER TABLE `metadati`
    ADD CONSTRAINT `metadati_ibfk_28` FOREIGN KEY (`id_tipologia_contratti`) REFERENCES `tipologie_contratti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202210250030
CREATE OR REPLACE VIEW `metadati_view` AS
	SELECT
		metadati.id,
		metadati.id_lingua,
		lingue.ietf,
		metadati.id_anagrafica,
		metadati.id_account,
		metadati.id_pagina,
		metadati.id_prodotto,
		metadati.id_articolo,
		metadati.id_categoria_prodotti,
		metadati.id_notizia,
		metadati.id_categoria_notizie,
		metadati.id_risorsa,
		metadati.id_categoria_risorse,
		metadati.id_immagine,
		metadati.id_video,
		metadati.id_audio,
		metadati.id_file,
		metadati.id_progetto,
		metadati.id_categoria_progetti,
		metadati.id_indirizzo,
		metadati.id_edificio,
		metadati.id_immobile,
		metadati.id_contratto,
        metadati.id_valutazione,
        metadati.id_rinnovo,
        metadati.id_tipologia_attivita,
		metadati.id_banner,
		metadati.id_pianificazione,
		metadati.id_tipologia_todo,
		metadati.id_tipologia_contratti,
		metadati.id_account_inserimento,
		metadati.id_account_aggiornamento,
		concat(
			metadati.nome,
			':',
			metadati.testo
		) AS __label__
	FROM metadati
		LEFT JOIN lingue ON lingue.id = metadati.id_lingua
;

--| FINE