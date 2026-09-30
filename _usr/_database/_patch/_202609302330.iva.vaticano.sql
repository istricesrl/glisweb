-- 2026-09-30 — aliquota per le cessioni verso la Città del Vaticano ( art. 71 d.P.R. 633/1972 )
--
-- COSA SI VEDEVA. La riga 35 ( art. 71 con natura N3.6 ) e' stata archiviata dalla patch _202609301800 e sostituita dalla
-- riga 60, che pero' e' solo per San Marino ( N3.3 ): per le cessioni verso il Vaticano, che l'art. 71 copre insieme a San
-- Marino, non restava nessuna aliquota proponibile.
--
-- COSA FA. Aggiunge la riga 71, art. 71 verso il Vaticano con natura N3.6 ( non imponibili, altre operazioni che non
-- concorrono al plafond ).
--
-- IDEMPOTENTE. INSERT IGNORE: alla seconda esecuzione la riga c'e' gia'. Se su un deploy l'id 71 e' gia' occupato da
-- un'aliquota di progetto la riga non viene inserita, e la SELECT finale lo dice.

-- | 202609302330

INSERT IGNORE INTO `iva` (`id`, `aliquota`, `nome`, `descrizione`, `codice`, `timestamp_archiviazione`) VALUES
(71,	0.00,	'non imponibile ex art. 71 d.P.R. 633/1972 (Vaticano)',	'operazione non imponibile ex art. 71 del d.P.R. 633/1972 (cessione verso la Città del Vaticano)',	'N3.6',	NULL);

-- | 202609302331

-- controllo: se l'id 71 era gia' usato da un'altra aliquota lo segnala
SELECT IF( `codice` = 'N3.6' AND `nome` LIKE '%art. 71%Vaticano%', 'ok', concat( 'ATTENZIONE: l\'id 71 e\' gia\' usato da "', `nome`, '": aggiungere a mano l\'aliquota art. 71 Vaticano con natura N3.6' ) ) AS nota
	FROM `iva` WHERE `id` = 71;

-- | FINE FILE
