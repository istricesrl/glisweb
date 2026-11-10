-- 2026-11-10 — valute: nome, decimali e le valute correnti ISO 4217
--
-- Schema canonico, punto 6, riga 234, decisione di Fabio del 10/11/2026 ( opzione B ): valute e' una tabella standard
-- completa, come lingue e stati, con tutte le valute correnti dello standard ISO 4217 a id fissi ( l'euro e' 1, le altre
-- seguono in ordine di codice ), e si aggiorna col dataserver come tutte le tabelle standard. Nomi e simboli da CLDR,
-- codici e decimali dall'elenco ufficiale ISO 4217 ( pubblicato il 2026-09-17 ).
--
-- Cosa fa: aggiunge nome e decimali, allarga html_entity e utf8 ( i simboli di piu' caratteri, p.es. zł o R$ ), corregge
-- l'entita' dell'euro ( era &#8634;, cioe' una freccia circolare ), inserisce le valute che mancano, rende nome e iso4217
-- NOT NULL, aggiunge la UNIQUE sul nome e la KEY indice, ricrea la vista. Non cambia il significato di nessuna colonna:
-- utf8 e html_entity restano il simbolo, solo piu' larghe.
--
-- Cosa NON fa: non toglie la coda di audit ( punto 12 del canone, tabelle standard ), non tocca le FK in ingresso.
--
-- IDEMPOTENTE.

-- | 202611102000

-- valute: nome, decimali, simboli piu' larghi
ALTER TABLE `valute`
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL AFTER `id`,
	ADD COLUMN IF NOT EXISTS `decimali` int(1) DEFAULT NULL AFTER `iso4217`,
	MODIFY `html_entity` char(16) DEFAULT NULL AFTER `decimali`,
	MODIFY `utf8` char(8) DEFAULT NULL AFTER `html_entity`;

-- | 202611102001

-- valute: l'euro, con l'entita' corretta
UPDATE `valute` SET `nome` = 'euro', `decimali` = 2, `html_entity` = '&#8364;', `utf8` = '€' WHERE `iso4217` = 'EUR';

-- | 202611102002

-- valute: le valute correnti ISO 4217, a id fissi
INSERT IGNORE INTO `valute` (`id`, `nome`, `iso4217`, `decimali`, `html_entity`, `utf8`) VALUES
(1,	'euro',	'EUR',	2,	'&#8364;',	'€'),
(2,	'dirham degli Emirati Arabi Uniti',	'AED',	2,	NULL,	NULL),
(3,	'afghani',	'AFN',	2,	'&#1547;',	'؋'),
(4,	'lek albanese',	'ALL',	2,	NULL,	NULL),
(5,	'dram armeno',	'AMD',	2,	'&#1423;',	'֏'),
(6,	'kwanza angolano',	'AOA',	2,	'Kz',	'Kz'),
(7,	'peso argentino',	'ARS',	2,	'$',	'$'),
(8,	'dollaro australiano',	'AUD',	2,	'$',	'$'),
(9,	'fiorino di Aruba',	'AWG',	2,	NULL,	NULL),
(10,	'manat azero',	'AZN',	2,	'&#8380;',	'₼'),
(11,	'marco convertibile della Bosnia-Herzegovina',	'BAM',	2,	'KM',	'KM'),
(12,	'dollaro di Barbados',	'BBD',	2,	'$',	'$'),
(13,	'taka bangladese',	'BDT',	2,	'&#2547;',	'৳'),
(14,	'dinaro del Bahrein',	'BHD',	3,	NULL,	NULL),
(15,	'franco del Burundi',	'BIF',	0,	NULL,	NULL),
(16,	'dollaro delle Bermuda',	'BMD',	2,	'$',	'$'),
(17,	'dollaro del Brunei',	'BND',	2,	'$',	'$'),
(18,	'boliviano',	'BOB',	2,	'Bs',	'Bs'),
(19,	'real brasiliano',	'BRL',	2,	'R$',	'R$'),
(20,	'dollaro delle Bahamas',	'BSD',	2,	'$',	'$'),
(21,	'ngultrum bhutanese',	'BTN',	2,	NULL,	NULL),
(22,	'pula del Botswana',	'BWP',	2,	'P',	'P'),
(23,	'rublo bielorusso',	'BYN',	2,	'Br',	'Br'),
(24,	'dollaro del Belize',	'BZD',	2,	'$',	'$'),
(25,	'dollaro canadese',	'CAD',	2,	'$',	'$'),
(26,	'franco congolese',	'CDF',	2,	NULL,	NULL),
(27,	'franco svizzero',	'CHF',	2,	NULL,	NULL),
(28,	'peso cileno',	'CLP',	0,	'$',	'$'),
(29,	'yuan cinese',	'CNY',	2,	'&#165;',	'¥'),
(30,	'peso colombiano',	'COP',	2,	'$',	'$'),
(31,	'colón costaricano',	'CRC',	2,	'&#8353;',	'₡'),
(32,	'peso cubano',	'CUP',	2,	'$',	'$'),
(33,	'escudo capoverdiano',	'CVE',	2,	NULL,	NULL),
(34,	'corona ceca',	'CZK',	2,	'K&#269;',	'Kč'),
(35,	'franco di Gibuti',	'DJF',	0,	NULL,	NULL),
(36,	'corona danese',	'DKK',	2,	'kr',	'kr'),
(37,	'peso dominicano',	'DOP',	2,	'$',	'$'),
(38,	'dinaro algerino',	'DZD',	2,	NULL,	NULL),
(39,	'sterlina egiziana',	'EGP',	2,	'&#163;E',	'£E'),
(40,	'nakfa eritreo',	'ERN',	2,	NULL,	NULL),
(41,	'birr etiope',	'ETB',	2,	NULL,	NULL),
(42,	'dollaro delle Figi',	'FJD',	2,	'$',	'$'),
(43,	'sterlina delle Falkland',	'FKP',	2,	'&#163;',	'£'),
(44,	'sterlina britannica',	'GBP',	2,	'&#163;',	'£'),
(45,	'lari georgiano',	'GEL',	2,	'&#8382;',	'₾'),
(46,	'cedi ghanese',	'GHS',	2,	'GH&#8373;',	'GH₵'),
(47,	'sterlina di Gibilterra',	'GIP',	2,	'&#163;',	'£'),
(48,	'dalasi gambiano',	'GMD',	2,	NULL,	NULL),
(49,	'franco della Guinea',	'GNF',	0,	'FG',	'FG'),
(50,	'quetzal guatemalteco',	'GTQ',	2,	'Q',	'Q'),
(51,	'dollaro della Guyana',	'GYD',	2,	'$',	'$'),
(52,	'dollaro di Hong Kong',	'HKD',	2,	'$',	'$'),
(53,	'lempira honduregna',	'HNL',	2,	'L',	'L'),
(54,	'gourde haitiano',	'HTG',	2,	NULL,	NULL),
(55,	'fiorino ungherese',	'HUF',	2,	'Ft',	'Ft'),
(56,	'rupia indonesiana',	'IDR',	2,	'Rp',	'Rp'),
(57,	'nuovo siclo israeliano',	'ILS',	2,	'&#8362;',	'₪'),
(58,	'rupia indiana',	'INR',	2,	'&#8377;',	'₹'),
(59,	'dinaro iracheno',	'IQD',	3,	NULL,	NULL),
(60,	'rial iraniano',	'IRR',	2,	NULL,	NULL),
(61,	'corona islandese',	'ISK',	0,	'kr',	'kr'),
(62,	'dollaro giamaicano',	'JMD',	2,	'$',	'$'),
(63,	'dinaro giordano',	'JOD',	3,	NULL,	NULL),
(64,	'yen giapponese',	'JPY',	0,	'&#165;',	'¥'),
(65,	'scellino keniota',	'KES',	2,	NULL,	NULL),
(66,	'som kirghiso',	'KGS',	2,	'&#8384;',	'⃀'),
(67,	'riel cambogiano',	'KHR',	2,	'&#6107;',	'៛'),
(68,	'franco comoriano',	'KMF',	0,	'CF',	'CF'),
(69,	'won nordcoreano',	'KPW',	2,	'&#8361;',	'₩'),
(70,	'won sudcoreano',	'KRW',	0,	'&#8361;',	'₩'),
(71,	'dinaro kuwaitiano',	'KWD',	3,	NULL,	NULL),
(72,	'dollaro delle Isole Cayman',	'KYD',	2,	'$',	'$'),
(73,	'tenge kazako',	'KZT',	2,	'&#8376;',	'₸'),
(74,	'kip laotiano',	'LAK',	2,	'&#8365;',	'₭'),
(75,	'lira libanese',	'LBP',	2,	'L&#163;',	'L£'),
(76,	'rupia di Sri Lanka',	'LKR',	2,	'Rs',	'Rs'),
(77,	'dollaro liberiano',	'LRD',	2,	'$',	'$'),
(78,	'loti del Lesotho',	'LSL',	2,	NULL,	NULL),
(79,	'dinaro libico',	'LYD',	3,	NULL,	NULL),
(80,	'dirham marocchino',	'MAD',	2,	NULL,	NULL),
(81,	'leu moldavo',	'MDL',	2,	NULL,	NULL),
(82,	'ariary malgascio',	'MGA',	2,	'Ar',	'Ar'),
(83,	'dinaro macedone',	'MKD',	2,	NULL,	NULL),
(84,	'kyat di Myanmar',	'MMK',	2,	'K',	'K'),
(85,	'tugrik mongolo',	'MNT',	2,	'&#8366;',	'₮'),
(86,	'pataca di Macao',	'MOP',	2,	NULL,	NULL),
(87,	'ouguiya della Mauritania',	'MRU',	2,	NULL,	NULL),
(88,	'rupia mauriziana',	'MUR',	2,	'Rs',	'Rs'),
(89,	'rufiyaa delle Maldive',	'MVR',	2,	NULL,	NULL),
(90,	'kwacha malawiano',	'MWK',	2,	NULL,	NULL),
(91,	'peso messicano',	'MXN',	2,	'$',	'$'),
(92,	'ringgit malese',	'MYR',	2,	'RM',	'RM'),
(93,	'metical mozambicano',	'MZN',	2,	NULL,	NULL),
(94,	'dollaro namibiano',	'NAD',	2,	'$',	'$'),
(95,	'naira nigeriana',	'NGN',	2,	'&#8358;',	'₦'),
(96,	'córdoba nicaraguense',	'NIO',	2,	'C$',	'C$'),
(97,	'corona norvegese',	'NOK',	2,	'NKr',	'NKr'),
(98,	'rupia nepalese',	'NPR',	2,	'Rs',	'Rs'),
(99,	'dollaro neozelandese',	'NZD',	2,	'$',	'$'),
(100,	'rial omanita',	'OMR',	3,	NULL,	NULL),
(101,	'balboa panamense',	'PAB',	2,	NULL,	NULL),
(102,	'sol peruviano',	'PEN',	2,	NULL,	NULL),
(103,	'kina papuana',	'PGK',	2,	NULL,	NULL),
(104,	'peso filippino',	'PHP',	2,	'&#8369;',	'₱'),
(105,	'rupia pakistana',	'PKR',	2,	'Rs',	'Rs'),
(106,	'zloty polacco',	'PLN',	2,	'z&#322;',	'zł'),
(107,	'guaraní paraguayano',	'PYG',	0,	'&#8370;',	'₲'),
(108,	'rial qatariano',	'QAR',	2,	NULL,	NULL),
(109,	'leu rumeno',	'RON',	2,	'lei',	'lei'),
(110,	'dinaro serbo',	'RSD',	2,	NULL,	NULL),
(111,	'rublo russo',	'RUB',	2,	'&#8381;',	'₽'),
(112,	'franco ruandese',	'RWF',	0,	'RF',	'RF'),
(113,	'riyal saudita',	'SAR',	2,	NULL,	NULL),
(114,	'dollaro delle Isole Salomone',	'SBD',	2,	'$',	'$'),
(115,	'rupia delle Seychelles',	'SCR',	2,	NULL,	NULL),
(116,	'sterlina sudanese',	'SDG',	2,	NULL,	NULL),
(117,	'corona svedese',	'SEK',	2,	'kr',	'kr'),
(118,	'dollaro di Singapore',	'SGD',	2,	'$',	'$'),
(119,	'sterlina di Sant’Elena',	'SHP',	2,	'&#163;',	'£'),
(120,	'leone della Sierra Leone',	'SLE',	2,	NULL,	NULL),
(121,	'scellino somalo',	'SOS',	2,	NULL,	NULL),
(122,	'dollaro del Suriname',	'SRD',	2,	'$',	'$'),
(123,	'sterlina sud-sudanese',	'SSP',	2,	'&#163;',	'£'),
(124,	'dobra di Sao Tomé e Príncipe',	'STN',	2,	'Db',	'Db'),
(125,	'colón salvadoregno',	'SVC',	2,	NULL,	NULL),
(126,	'lira siriana',	'SYP',	2,	'&#163;',	'£'),
(127,	'lilangeni',	'SZL',	2,	NULL,	NULL),
(128,	'baht thailandese',	'THB',	2,	'&#3647;',	'฿'),
(129,	'somoni tagiko',	'TJS',	2,	NULL,	NULL),
(130,	'manat turkmeno',	'TMT',	2,	NULL,	NULL),
(131,	'dinaro tunisino',	'TND',	3,	NULL,	NULL),
(132,	'paʻanga tongano',	'TOP',	2,	'T$',	'T$'),
(133,	'lira turca',	'TRY',	2,	'&#8378;',	'₺'),
(134,	'dollaro di Trinidad e Tobago',	'TTD',	2,	'$',	'$'),
(135,	'nuovo dollaro taiwanese',	'TWD',	2,	'NT$',	'NT$'),
(136,	'scellino della Tanzania',	'TZS',	2,	NULL,	NULL),
(137,	'grivnia ucraina',	'UAH',	2,	'&#8372;',	'₴'),
(138,	'scellino ugandese',	'UGX',	0,	NULL,	NULL),
(139,	'dollaro statunitense',	'USD',	2,	'$',	'$'),
(140,	'peso uruguayano',	'UYU',	2,	'$',	'$'),
(141,	'sum uzbeco',	'UZS',	2,	NULL,	NULL),
(142,	'bolívar digitale venezuelano',	'VED',	2,	NULL,	NULL),
(143,	'bolívar venezuelano',	'VES',	2,	NULL,	NULL),
(144,	'dong vietnamita',	'VND',	0,	'&#8363;',	'₫'),
(145,	'vatu di Vanuatu',	'VUV',	0,	NULL,	NULL),
(146,	'tala samoano',	'WST',	2,	NULL,	NULL),
(147,	'franco CFA BEAC',	'XAF',	0,	'FCFA',	'FCFA'),
(148,	'dollaro dei Caraibi orientali',	'XCD',	2,	'$',	'$'),
(149,	'fiorino caraibico',	'XCG',	2,	NULL,	NULL),
(150,	'franco CFA BCEAO',	'XOF',	0,	'F&#8239;CFA',	'F CFA'),
(151,	'franco CFP',	'XPF',	0,	'CFPF',	'CFPF'),
(152,	'riyal yemenita',	'YER',	2,	NULL,	NULL),
(153,	'rand sudafricano',	'ZAR',	2,	'R',	'R'),
(154,	'kwacha zambiano',	'ZMW',	2,	'ZK',	'ZK'),
(155,	'oro dello Zimbabwe',	'ZWG',	2,	NULL,	NULL);

-- | 202611102003

-- valute: righe fuori dall'elenco senza nome ( non ce ne sono sui database letti il 10/11, ma NOT NULL non deve fallire )
UPDATE `valute` SET `nome` = `iso4217` WHERE `nome` IS NULL;

-- | 202611102004

-- valute: nome e codice obbligatori
ALTER TABLE `valute`
	MODIFY `nome` char(255) NOT NULL,
	MODIFY `iso4217` char(3) NOT NULL;

-- | 202611102005

-- valute: chiavi
ALTER TABLE `valute`
	DROP INDEX IF EXISTS `unica_nome`,
	DROP INDEX IF EXISTS `indice`,
	ADD UNIQUE KEY `unica_nome` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`iso4217`,`decimali`);

-- | 202611102006

-- valute_view
CREATE OR REPLACE VIEW `valute_view` AS
	SELECT
		valute.id,
		valute.nome,
		valute.iso4217,
		valute.decimali,
		valute.html_entity,
		valute.utf8,
		valute.iso4217 AS __label__
	FROM valute
;

-- | FINE
