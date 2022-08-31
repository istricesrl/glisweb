--
-- PATCH
--

--| 202208290010
ALTER TABLE `banner` DROP KEY `indice`;

--| 202208290020
ALTER TABLE `banner`
    ADD COLUMN `token` char(128) DEFAULT NULL AFTER `larghezza_modulo`, 
    ADD KEY `token` (`token`),
	ADD KEY `indice` (`id`, `id_tipologia`, `id_sito`, `ordine`,`nome`, `id_inserzionista`,`altezza_modulo`,`larghezza_modulo`, `token`);

--| 202208290030
CREATE OR REPLACE VIEW `banner_view` AS
	SELECT
		banner.id,
		banner.id_tipologia,
		tipologie_banner_path( banner.id_tipologia ) AS tipologia,
		banner.id_sito,
		banner.ordine,
		banner.nome,
		banner.id_inserzionista,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS inserzionista,
		banner.altezza_modulo,
		banner.larghezza_modulo,
		banner.token,
		banner.id_account_inserimento,
		banner.id_account_aggiornamento,
		concat( banner.nome, ' ', banner.altezza_modulo, 'x', banner.larghezza_modulo ) AS __label__
	FROM banner
		LEFT JOIN anagrafica ON anagrafica.id = banner.id_inserzionista
	;

--| 202208290040
ALTER TABLE `contenuti`
    ADD COLUMN `id_banner` int(11) DEFAULT NULL AFTER `id_categoria_progetti`,
    ADD UNIQUE KEY `unica_banner` (`id_lingua`,`id_banner`),
    ADD KEY `id_banner` (`id_banner`),
    ADD CONSTRAINT `contenuti_ibfk_27` FOREIGN KEY (`id_banner`) REFERENCES `banner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202208290050
CREATE OR REPLACE VIEW contenuti_view AS
	SELECT
		contenuti.id,
		contenuti.id_lingua,
		contenuti.id_anagrafica,
		contenuti.id_prodotto,
		contenuti.id_articolo,
		contenuti.id_categoria_prodotti,
		contenuti.id_caratteristica_prodotti,
		contenuti.id_marchio,
		contenuti.id_file,
		contenuti.id_immagine,
		contenuti.id_video,
		contenuti.id_audio,
		contenuti.id_risorsa,
		contenuti.id_categoria_risorse,
		contenuti.id_pagina,
		contenuti.id_popup,
		contenuti.id_indirizzo,
		contenuti.id_edificio,
		contenuti.id_immobile,
		contenuti.id_notizia,
		contenuti.id_categoria_notizie,
		contenuti.id_template,
		contenuti.id_colore,
		contenuti.id_progetto,
		contenuti.id_categoria_progetti,
		contenuti.id_banner,
		contenuti.title,
		contenuti.h1,
		contenuti.id_account_inserimento,
		contenuti.id_account_aggiornamento,
		concat(
			contenuti.h1,
			' / ',
			lingue.nome
		) AS __label__
	FROM contenuti
		INNER JOIN lingue ON lingue.id = contenuti.id_lingua
;
--| FINE