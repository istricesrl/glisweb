--
-- PATCH
--

--| 202210270010
ALTER TABLE `tipologie_contratti`
    ADD COLUMN `id_prodotto` char(32) DEFAULT NULL AFTER `nome`,
    ADD COLUMN `id_progetto` char(32) DEFAULT NULL AFTER `id_prodotto`,
    ADD COLUMN `id_categoria_progetti` int(11) DEFAULT NULL AFTER `id_progetto`,
    ADD KEY `id_prodotto` (`id_prodotto`),
    ADD KEY `id_progetto` (`id_progetto`),
    ADD KEY `id_categoria_progetti` (`id_categoria_progetti`);

--| 202210250020
ALTER TABLE `tipologie_contratti`
    ADD CONSTRAINT `tipologie_contratti_ibfk_02_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL.
    ADD CONSTRAINT `tipologie_contratti_ibfk_03_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `tipologie_contratti_ibfk_04_nofollow` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202210250030
CREATE OR REPLACE VIEW `tipologie_contratti_view` AS
	SELECT
		tipologie_contratti.id,
		tipologie_contratti.id_genitore,
		tipologie_contratti.ordine,
		tipologie_contratti.nome,
		tipologie_contratti.id_prodotto,
		tipologie_contratti.id_progetto,
		tipologie_contratti.id_categoria_progetti,
		tipologie_contratti.html_entity,
		tipologie_contratti.font_awesome,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		tipologie_contratti.se_libero,
		tipologie_contratti.se_prenotazione,
		tipologie_contratti.se_scalare,
		tipologie_contratti.se_affiliazione,
		tipologie_contratti.id_account_inserimento,
		tipologie_contratti.id_account_aggiornamento,
		tipologie_contratti_path( tipologie_contratti.id ) AS __label__
	FROM tipologie_contratti
;

--| FINE