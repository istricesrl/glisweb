-- 2026-10-09 — documenti_articoli_ibfk_02_nofollow punta sulle tipologie delle righe
--
-- documenti_articoli.id_tipologia e' la tipologia della RIGA ( tipologie_documenti_articoli: raggruppamento,
-- opzione... ), come dice la colonna in _010000999999.tables.sql dal 15/09/2026, quando la tipologia del documento e'
-- passata a id_tipologia_documento. Il vincolo nei file di base era rimasto quello di prima e la mandava su
-- tipologie_documenti: una riga si poteva marcare solo con un id che esistesse ANCHE fra le tipologie dei documenti,
-- e con un id sbagliato. Visto su utensilerialughese il 05/10/2026 aggiungendo le tipologie di riga 3 e 4, passate
-- solo perche' 3 e 4 sono anche nota di credito e documento di trasporto.
--
-- Prima si svuotano i valori che fra le tipologie delle righe non esistono, che altrimenti farebbero fallire il
-- vincolo: in quella colonna non vogliono dire niente. Poi si toglie il vincolo e si rimette giusto, in due passi
-- perche' MariaDB non toglie e rimette un vincolo con lo stesso nome nella stessa ALTER ( errore 1826 ).
--
-- IDEMPOTENTE.

-- | 202610091200

UPDATE `documenti_articoli`
	LEFT JOIN `tipologie_documenti_articoli` ON `tipologie_documenti_articoli`.`id` = `documenti_articoli`.`id_tipologia`
	SET `documenti_articoli`.`id_tipologia` = NULL
	WHERE `documenti_articoli`.`id_tipologia` IS NOT NULL AND `tipologie_documenti_articoli`.`id` IS NULL;

-- | 202610091201

ALTER TABLE `documenti_articoli` DROP FOREIGN KEY IF EXISTS `documenti_articoli_ibfk_02_nofollow`;

-- | 202610091202

ALTER TABLE `documenti_articoli`
	ADD CONSTRAINT `documenti_articoli_ibfk_02_nofollow` FOREIGN KEY ( `id_tipologia` ) REFERENCES `tipologie_documenti_articoli` ( `id` ) ON DELETE NO ACTION ON UPDATE CASCADE;

-- | FINE
