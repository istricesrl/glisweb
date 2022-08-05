--
-- PATCH
--

--| 202208050010
ALTER TABLE `carrelli_articoli` DROP INDEX `id_carrello_id_articolo`, 
ADD UNIQUE `id_carrello_id_articolo_destinatario` (`id_carrello`, `id_articolo`, `destinatario_id_anagrafica`);

--| FINE