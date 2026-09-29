-- 2026-09-29 — i codici della fattura elettronica che il database non aveva
--
-- Contesto: _mod/_0400.documenti/_src/_api/_print/_fattura.xml.php scrive nella fattura elettronica i codici
-- cosi' come li trova nel database ( tipologie_documenti.codice, regimi.codice, iva.codice,
-- modalita_pagamento.codice ), e le tendine dei form li leggono dalle stesse tabelle. Confrontati il
-- 2026-09-29 con lo schema Schema_VFPR12_v1.2.3.xsd delle specifiche tecniche 1.9 ( le 1.9.1, in vigore
-- dal 15 maggio 2026, non cambiano lo schema ), ai dati di base mancavano:
--  - i tipi documento TD28 ( acquisti da San Marino con IVA, specifiche 1.7 ) e TD29 ( comunicazione per
--    omessa o irregolare fatturazione, specifiche 1.9 );
--  - i regimi fiscali RF06, RF08, RF09, RF15 e RF20 ( regime transfrontaliero di franchigia IVA, specifiche 1.9 );
--  - la modalita' di pagamento MP23 ( PagoPA, specifiche 1.7 );
--  - le nature di dettaglio N3.3, da N6.1 a N6.9 e N7: le due righe di reverse charge dei dati di base ( 57
--    e 58 ) hanno la natura generica N6, che lo SDI scarta dal 2021.
--
-- COME SONO FATTE. iva, regimi e modalita_pagamento sono tabelle standard con l'id scritto nei dati di base,
-- e le righe nuove proseguono la numerazione con INSERT IGNORE, come i dati di base. tipologie_documenti e'
-- invece una tabella di supporto, in cui un deploy puo' avere tipologie proprie con gli id successivi a
-- quelli di base: le due righe si inseriscono senza id, con l'AUTO_INCREMENT, e solo se il codice non c'e'
-- gia'. Come TD16-TD27 sono figlie della fattura ( id_genitore 1 ). Le descrizioni delle aliquote stanno nei
-- 100 caratteri che lo schema ammette per RiferimentoNormativo.
--
-- NON TOCCA le righe 57 e 58 della tabella iva: con la natura N6 non si possono piu' usare, ma i documenti gia'
-- emessi le citano, e scegliere a quale N6.x corrispondono ( la 57 copre piu' lettere dell'art. 17 c. 6 ) e'
-- una decisione fiscale; lo stesso vale per la 35 ( art. 71, San Marino ), che ha N3.6 invece di N3.3.
--
-- IDEMPOTENZA. INSERT IGNORE sugli id per le tabelle standard, NOT EXISTS sul codice per tipologie_documenti.

-- | 202609291300

-- tipologie_documenti
INSERT INTO `tipologie_documenti` ( `id_genitore`, `codice`, `numerazione`, `nome`, `sigla`, `se_fattura` )
	SELECT 1, 'TD28', 'F', 'acquisti da San Marino con IVA (fattura cartacea)', 'integr.', 1 FROM DUAL
	WHERE NOT EXISTS ( SELECT 1 FROM `tipologie_documenti` WHERE `codice` = 'TD28' );

-- | 202609291301

-- tipologie_documenti
INSERT INTO `tipologie_documenti` ( `id_genitore`, `codice`, `numerazione`, `nome`, `sigla`, `se_fattura` )
	SELECT 1, 'TD29', 'F', 'comunicazione per omessa o irregolare fatturazione', 'comunic.', 1 FROM DUAL
	WHERE NOT EXISTS ( SELECT 1 FROM `tipologie_documenti` WHERE `codice` = 'TD29' );

-- | 202609291310

-- regimi
INSERT IGNORE INTO `regimi` (`id`, `nome`, `codice`) VALUES
(16,    'fiammiferi',                   'RF06'),
(17,    'telefonia pubblica',           'RF08'),
(18,    'documenti di trasporto',       'RF09'),
(19,    'vendite all\'asta',            'RF15'),
(20,    'franchigia transfrontaliera',  'RF20');

-- | 202609291320

-- modalita_pagamento
INSERT IGNORE INTO `modalita_pagamento` (`id`, `codice`, `nome`) VALUES
(25,        'MP23',         'PagoPA' );

-- | 202609291330

-- iva
INSERT IGNORE INTO `iva` (`id`, `aliquota`, `nome`, `descrizione`, `codice`, `timestamp_archiviazione`) VALUES
(60,	0.00,	'non imponibile ex art. 71 d.P.R. 633/1972 (San Marino)',	'operazione non imponibile ex art. 71 del d.P.R. 633/1972 (cessione verso San Marino)',	'N3.3',	NULL),
(61,	0.00,	'rev. charge ex art. 74 cc. 7 e 8 d.P.R. 633/1972 (rottami)',	'inversione contabile ex art. 74 commi 7 e 8 del d.P.R. 633/1972 (rottami e materiali di recupero)',	'N6.1',	NULL),
(62,	0.00,	'rev. charge ex art. 17 c. 5 d.P.R. 633/1972 (oro e argento)',	'inversione contabile ex art. 17 comma 5 del d.P.R. 633/1972 (oro e argento)',	'N6.2',	NULL),
(63,	0.00,	'rev. charge ex art. 17 c. 6 lett. a d.P.R. 633/1972',	'inversione contabile ex art. 17 comma 6 lettera a del d.P.R. 633/1972 (subappalto nel settore edile)',	'N6.3',	NULL),
(64,	0.00,	'rev. charge ex art. 17 c. 6 lett. a bis d.P.R. 633/1972',	'inversione contabile ex art. 17 comma 6 lettera a bis del d.P.R. 633/1972 (cessione di fabbricati)',	'N6.4',	NULL),
(65,	0.00,	'rev. charge ex art. 17 c. 6 lett. b d.P.R. 633/1972',	'inversione contabile ex art. 17 comma 6 lettera b del d.P.R. 633/1972 (telefoni cellulari)',	'N6.5',	NULL),
(66,	0.00,	'rev. charge ex art. 17 c. 6 lett. c d.P.R. 633/1972',	'inversione contabile ex art. 17 comma 6 lettera c del d.P.R. 633/1972 (prodotti elettronici)',	'N6.6',	NULL),
(67,	0.00,	'rev. charge ex art. 17 c. 6 lett. a ter d.P.R. 633/1972',	'inversione contabile ex art. 17 comma 6 lettera a ter del d.P.R. 633/1972 (comparto edile)',	'N6.7',	NULL),
(68,	0.00,	'rev. charge ex art. 17 c. 6 lett. d bis-quater d.P.R. 633/1972',	'inversione contabile ex art. 17 comma 6 lettere d bis, d ter e d quater del d.P.R. 633/1972',	'N6.8',	NULL),
(69,	0.00,	'rev. charge, altri casi',	'operazione soggetta a inversione contabile (reverse charge), altri casi',	'N6.9',	NULL),
(70,	0.00,	'IVA assolta in altro stato UE',	'IVA assolta in altro stato UE ex art. 7 octies e art. 74 sexies del d.P.R. 633/1972',	'N7',	NULL);

-- | FINE FILE
