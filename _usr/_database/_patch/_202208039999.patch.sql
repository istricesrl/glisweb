--
-- PATCH
--

--| 202208030010
ALTER TABLE `carrelli_articoli` 
    ADD `destinatario_id_anagrafica` int(11) DEFAULT NULL AFTER `id_iva`,
	ADD KEY `destinatario_id_anagrafica` (`destinatario_id_anagrafica`),
	ADD KEY `id_iva` (`id_iva`),
    ADD CONSTRAINT `carrelli_articoli_ibfk_04_nofollow`    FOREIGN KEY (`destinatario_id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202208030020
CREATE OR REPLACE VIEW carrelli_articoli_view AS
	SELECT
		carrelli_articoli.id,
		carrelli_articoli.id_carrello,
		carrelli_articoli.id_articolo,
		carrelli_articoli.id_iva,
		carrelli_articoli.destinatario_id_anagrafica,
		carrelli_articoli.prezzo_netto_unitario,
		carrelli_articoli.prezzo_lordo_unitario,
		carrelli_articoli.quantita,
		carrelli_articoli.prezzo_netto_totale,
		carrelli_articoli.prezzo_lordo_totale,
		carrelli_articoli.sconto_percentuale,
		carrelli_articoli.sconto_valore,
		carrelli_articoli.prezzo_netto_finale,
		carrelli_articoli.prezzo_lordo_finale,
		carrelli_articoli.id_account_inserimento,
		carrelli_articoli.id_account_aggiornamento
	FROM carrelli_articoli;

--| FINE