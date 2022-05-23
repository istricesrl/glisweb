--
-- PATCH
--

--| 202205230010
ALTER TABLE `metadati`
    ADD COLUMN   `id_tipologia_attivita` int(11) DEFAULT NULL    AFTER `id_rinnovo`,
    ADD KEY `id_tipologia_attivita` (`id_tipologia_attivita`), 
 	ADD UNIQUE KEY `unica_progetto` (`id_lingua`,`id_progetto`,`nome`), 
 	ADD UNIQUE KEY `unica_categoria_progetto` (`id_lingua`,`id_categoria_progetti`,`nome`), 
 	ADD UNIQUE KEY `unica_indirizzo` (`id_lingua`,`id_indirizzo`,`nome`), 
 	ADD UNIQUE KEY `unica_edificio` (`id_lingua`,`id_edificio`,`nome`), 
 	ADD UNIQUE KEY `unica_immobile` (`id_lingua`,`id_immobile`,`nome`), 
 	ADD UNIQUE KEY `unica_contratto` (`id_lingua`,`id_contratto`,`nome`), 
 	ADD UNIQUE KEY `unica_valutazione` (`id_lingua`,`id_valutazione`,`nome`), 
 	ADD UNIQUE KEY `unica_rinnovo` (`id_lingua`,`id_rinnovo`,`nome`), 
 	ADD UNIQUE KEY `unica_tipologia_attivita` (`id_lingua`,`id_tipologia_attivita`,`nome`), 
ADD CONSTRAINT `metadati_ibfk_23` FOREIGN KEY (`id_tipologia_attivita`) REFERENCES `tipologie_attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202205230020
CREATE OR REPLACE VIEW `metadati_view` AS
	SELECT
		metadati.id,
		metadati.id_lingua,
		lingue.ietf,
		metadati.id_anagrafica,
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