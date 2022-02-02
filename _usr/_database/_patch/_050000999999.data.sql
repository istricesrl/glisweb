--
-- DATI
-- questo file contiene le query per l'inserimento dei dati standard nelle tabelle
--

--| 050000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-05-28 19:56 Fabio Mosti
REPLACE INTO `categorie_anagrafica` (`id`, `id_genitore`, `ordine`, `nome`, `note`, `se_lead`, `se_prospect`, `se_cliente`, `se_fornitore`, `se_produttore`, `se_collaboratore`, `se_interno`, `se_esterno`, `se_commerciale`, `se_concorrente`, `se_gestita`, `se_amministrazione`, `se_produzione`, `se_notizie`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'contatti',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'collaboratori',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	2,	NULL,	'agenti',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'fornitori',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'aziende gestite',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	'rivenditori',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	1,	NULL,	'lead',	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	1,	NULL,	'clienti',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000004300

-- categorie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-06-02 19:40 Fabio Mosti
INSERT INTO `categorie_progetti` (`id`, `id_genitore`, `ordine`, `nome`, `se_ordinario`, `se_straordinario`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'ordinario',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'straordinario',	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| 050000005100

-- colori
-- tipologia: tabella standard
-- verifica: 2021-06-02 22:27 Fabio Mosti
REPLACE INTO `colori` (`id`, `nome`, `hex`, `r`, `g`, `b`) VALUES
(1,	    'rosso',	'ff0000',	255,	0,	    0),
(3,	    'bianco',	'ffffff',	255,	255,	255),
(4,	    'nero',	    '000000',	0,	    0,	    0),
(5,	    'blu',	    '0000ff',	0,	    0,	    255),
(6,	    'verde',	'00ff00',	0,	    255,	0);

--| 050000005300

-- comuni
-- tipologia: tabella standard
-- verifica: 2021-06-03 19:58 Fabio Mosti
REPLACE INTO `comuni` (`id`, `id_provincia`, `nome`, `codice_istat`, `codice_catasto`) VALUES
(1,	    1,	'Bologna',	                        '037006',	'A944'),
(2,	    1,	'Casalecchio di Reno',	            '037011',	'B880'),
(3,	    1,	'San Giovanni in Persiceto',	    '037053',	'G467'),
(4,	    1,	'Crevalcore',	                    '037024',	'D166'),
(8,	    1,	'Monte San Pietro',	                '037042',	'F627'),
(9,	    1,	'San Lazzaro di Savena',	        '037054',	'H945'),
(10,	1,	'Castel Maggiore',	                '037019',	'C204'),
(13,	1,	'Zola Predosa',	                    '037060',	'M185'),
(16,	1,	'Anzola dell\'Emilia',	            '037001',	'A324'),
(3980,	1,	'Argelato',	                        '037002',	'A392'),
(3981,	1,	'Baricella',	                    '037003',	'A665'),
(3983,	1,	'Bentivoglio',	                    '037005',	'A785'),
(3984,	1,	'Borgo Tossignano',	                '037007',	'B044'),
(3985,	1,	'Budrio',	                        '037008',	'B249'),
(3986,	1,	'Calderara di Reno',	            '037009',	'B399'),
(3987,	1,	'Camugnano',	                    '037010',	'B572'),
(3988,	1,	'Casalfiumanese',	                '037012',	'B892'),
(3989,	1,	'Castel d\'Aiano',	                '037013',	'C075'),
(3990,	1,	'Castel del Rio',	                '037014',	'C086'),
(3991,	1,	'Castel di Casio',	                '037015',	'B969'),
(3992,	1,	'Castel Guelfo di Bologna',	        '037016',	'C121'),
(3993,	1,	'Castello d\'Argile',	            '037017',	'C185'),
(3995,	1,	'Castel San Pietro Terme',	        '037020',	'C265'),
(3996,	1,	'Castenaso',	                    '037021',	'C292'),
(3997,	1,	'Castiglione dei Pepoli',	        '037022',	'C296'),
(3999,	1,	'Dozza',	                        '037025',	'D360'),
(4000,	1,	'Fontanelice',	                    '037026',	'D668'),
(4001,	1,	'Gaggio Montano',	                '037027',	'D847'),
(4002,	1,	'Galliera',	                        '037028',	'D878'),
(4004,	1,	'Granarolo dell\'Emilia',	        '037030',	'E136'),
(4005,	1,	'Grizzana Morandi',	                '037031',	'E187'),
(4006,	1,	'Imola',	                        '037032',	'E289'),
(4007,	1,	'Lizzano in Belvedere',	            '037033',	'A771'),
(4008,	1,	'Loiano',	                        '037034',	'E655'),
(4009,	1,	'Malalbergo',	                    '037035',	'E844'),
(4010,	1,	'Marzabotto',	                    '037036',	'B689'),
(4011,	1,	'Medicina',	                        '037037',	'F083'),
(4012,	1,	'Minerbio',	                        '037038',	'F219'),
(4013,	1,	'Molinella',	                    '037039',	'F288'),
(4014,	1,	'Monghidoro',	                    '037040',	'F363'),
(4015,	1,	'Monterenzio',	                    '037041',	'F597'),
(4017,	1,	'Monzuno',	                        '037044',	'F706'),
(4018,	1,	'Mordano',	                        '037045',	'F718'),
(4019,	1,	'Ozzano dell\'Emilia',	            '037046',	'G205'),
(4020,	1,	'Pianoro',	                        '037047',	'G570'),
(4021,	1,	'Pieve di Cento',	                '037048',	'G643'),
(4023,	1,	'Sala Bolognese',	                '037050',	'H678'),
(4024,	1,	'San Benedetto Val di Sambro',      '037051',	'G566'),
(4025,	1,	'San Giorgio di Piano',	            '037052',	'H896'),
(4026,	1,	'San Pietro in Casale',	            '037055',	'I110'),
(4027,	1,	'Sant\'Agata Bolognese',	        '037056',	'I191'),
(4028,	1,	'Sasso Marconi',	                '037057',	'G972'),
(4030,	1,	'Vergato',	                        '037059',	'L762'),
(12594,	1,	'Valsamoggia',	                    '037061',	'M320'),
(12595,	1,	'Alto Reno Terme',	                '037062',	'M369');

--| 050000006200

-- condizioni_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-17 16:12 Chiara GDL
REPLACE INTO `condizioni_pagamento` (`id`, `codice`, `nome`) VALUES
(1,	    'TP01',	'pagamento a rate'),
(2,	    'TP02',	'pagamento completo'),
(3,	    'TP03',	    'anticipo');

--| 050000007100

-- continenti
-- tipologia: tabella standard
-- verifica: 2021-06-09 11:26 Fabio Mosti
REPLACE INTO `continenti` (`id`, `codice`, `nome`) VALUES
(1,	'EU',	'Europa'),
(2,	'AF',	'Africa'),
(3,	'AS',	'Asia'),
(4,	'NA',	'Nord America'),
(5,	'AU',	'Oceania'),
(6,	'LA',	'America Latina'),
(7,	'AN',	'Antartide');

--| 050000007100

-- tipologia: tabella standard
-- verifica: 2021-06-29 16:56 Fabio Mosti
REPLACE INTO `embed` (`id`, `nome`, `se_video`, `se_audio`) VALUES
(1, 'HTML5', 1, 1),
(2, 'Vimeo', 1, NULL),
(3, 'YouTube', 1, NULL);

--| 050000015200

-- gruppi
-- tipologia: tabella gestita
-- verifica: 2021-09-10 17:58 Fabio Mosti
REPLACE INTO `gruppi` (`id`, `id_genitore`, `id_organizzazione`, `nome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'roots',	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'staff',	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'users',	NULL,	NULL,	NULL,	NULL);

--| 050000016000

REPLACE INTO `iva` (`id`, `aliquota`, `nome`, `descrizione`, `codice`) VALUES
(1,	22.00,	'IVA 22%',                                                          'IVA 22%',	                                                                                                                                NULL),
(2,	10.00,	'IVA agevolata 10%',	                                            'IVA agevolata 10%',	                                                                                                                    NULL),
(3,	4.00,	'IVA agevolata 4%',	                                                'IVA agevolata 4%',	                                                                                                                        NULL),
(4,	0.00,	'escluso ex art. 15 d.P.R. n. 633/1972',	                        'operazione esclusa ex art. 15 del d.P.R. n. 633/1972',	                                                                                    'N1'),
(5,	0.00,	'non soggetto ex art.7 d.P.R. 633/1972',	                        'operazione non soggetta a IVA ex art. 7 del d.P.R. 633/1972',	                                                                            'N2'),
(6,	0.00,	'non imponibile ex art. 8 d.P.R. 633/1972',	                        'operazione non imponibile ex art. 8 del d.P.R. 633/1972',	                                                                                'N3'),
(7,	0.00,	'fuori campo IVA ex art. 2 d.P.R. 633/1972',	                    'operazione non imponibile ex art. 2 del d.P.R. 633/1972',	                                                                                'N2'),
(8,	0.00,	'non soggetto ex art. 1 ll. nn. 190/2014, 208/2015 e 145/2018',     'operazione non soggetta a IVA ai sensi ex art. 1 legge 190/2014 come modificato dalla legge n. 208/2015 e dalla legge n. 145/2018',	    'N2');

--| 050000016800

-- lingue
-- tipologia: tabella standard
-- verifica: 2021-06-09 11:26 Fabio Mosti
REPLACE INTO `lingue` (`id`, `nome`, `note`, `iso6391alpha2`, `iso6393alpha3`, `ietf`) VALUES
(1,     'italiano',     'italiano (Italia)',	    'it',	'ita',	'it-IT'),
(2,     'ceco',         'ceco (Repubblica Ceca)',	'cs',	'ces',	'cs-CZ'),
(3,     'inglese',	    'inglese (Regno Unito)',	'en',	'eng',	'en-GB'),
(4,     'francese',	    'francese (Francia)',	    'fr',	'fra',	'fr-FR'),
(5,     'tedesco',	    'tedesco (Germania)',	    'de',	'deu',	'de-DE'),
(6,     'ungherese',	'ungherese (Ungheria)',	    'hu',	'hun',	'hu-HU'),
(7,     'giapponese',	'giapponese (Giappone)',	'ja',	'jpn',	'ja-JP'),
(8,     'polacco',	    'polacco (Polonia)',	    'pl',	'pol',	'pl-PL'),
(9,     'portoghese',	'portoghese (Portogallo)',	'pt',	'por',	'pt-PT'),
(10,	'russo',	    'russo (Russia)',	        'ru',	'rus',	'ru-RU'),
(11,	'spagnolo',	    'spagnolo (Spagna)',	    'es',	'spa',	'es-ES'),
(12,	'svedese',	    'svedese (Svezia)',	        'sv',	'swe',	'sv-SE'),
(13,	'americano',	'inglese (Stati Uniti)',	NULL,	NULL,	'en-US'),
(14,	'croato',	    'croato (Croazia)',	        'hr',	'hrv',	'hr-HR'),
(15,	'rumeno',	    'rumeno (Romania)',	        'ro',	'ron',	'ro-RO');

--| 050000017200

-- listini
-- tipologia: tabella assistita
-- verifica: 2021-09-24 17:49 Fabio Mosti
REPLACE INTO `listini` (`id`, `id_valuta`, `nome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,     1,	            'DEFAULT',	                NULL,	NULL,	NULL,	NULL);

--| 050000021900

-- modalita_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-18 12:06 Chiara GDL
REPLACE INTO `modalita_pagamento` (`id`, `codice`, `nome`) VALUES
(1,	    'MP01',	'contanti'),
(2,	    'MP02',	'assegno'),
(3,	    'MP03',	    'assegno circolare'),
(4,	    'MP04',	    'contanti presso tesoreria'),
(5,	    'MP05',	'bonifico'),
(6,	    'MP06',	'vaglia cambiario'),
(7,	    'MP07',	'bollettino bancario'),
(8,	    'MP08',	'carta di credito'),
(9,	    'MP09',	'RID'),
(10,	    'MP10',	'RID utenze'),
(11,	    'MP11',	'RID veloce'),
(12,	    'MP12',	'RIBA'),
(13,	    'MP13',	'MAV'),
(14,	    'MP14',	'quietanza erario stato'),
(15,	    'MP15',	'giroconto su conti di contabilità speciale'),
(16,	    'MP16',	'domiciliazione bancaria'),
(17,	    'MP17',	'domiciliazione postale'),
(18,	    'MP18', 'bollettino di c/c postale'),
(19, 'MP19', 'SEPA Direct Debit' ),
(20, 'MP20', 'SEPA Direct Debit CORE' ),
(21, 'MP21', 'SEPA Direct Debit B2B' ),
(22, 'MP22', 'Trattenuta su somme già riscosse' ),
(23,  'MP08', 'bancomat' ),
(24, 'MP08', 'paypal' );

--| 050000023600

-- periodicita
-- tipologia: tabella standard
-- verifica: 2021-10-05 17:57 Fabio Mosti
REPLACE INTO `periodicita` (`id`, `nome`) VALUES
(1,	'giornaliera'),
(2,	'settimanale'),
(3,	'mensile'),
(4,	'annuale');

--| 050000028000

-- provincie
-- tipologia: tabella standard
-- verifica: 2021-10-08 16:20 Fabio Mosti
REPLACE INTO `provincie` (`id`, `id_regione`, `nome`, `sigla`, `codice_istat`) VALUES
(1,	    1,	'Bologna',	                        'BO',	'237'),
(2,	    1,	'Modena',	                        'MO',	'036'),
(3,	    1,	'Forlì-Cesena',	                    'FC',	'040'),
(4,	    1,	'Ravenna',	                        'RA',	'039'),
(5,	    2,	'Ancona',	                        'AN',	'042'),
(6,	    2,	'Ascoli Piceno',	                'AP',	'044'),
(7,	    20,	'Palermo',	                        'PA',	'282'),
(8,	    4,	'Brescia',	                        'BS',	'017'),
(9,	    5,	'Torino',	                        'TO',	'201'),
(10,	5,	'Vercelli',	                        'VC',	'002'),
(11,	5,	'Novara',	                        'NO',	'003'),
(12,	5,	'Cuneo',	                        'CN',	'004'),
(13,	5,	'Asti',	                            'AT',	'005'),
(14,	5,	'Alessandria',	                    'AL',	'006'),
(15,	5,	'Biella',	                        'BI',	'096'),
(16,	5,	'Verbano-Cusio-Ossola',	            'VB',	'103'),
(17,	6,	'Valle d\'Aosta/Vallée d\'Aoste',	'AO',	'007'),
(18,	4,	'Varese',	                        'VA',	'012'),
(19,	4,	'Como',	                            'CO',	'013'),
(20,	4,	'Sondrio',	                        'SO',	'014'),
(21,	4,	'Milano',	                        'MI',	'215'),
(22,	4,	'Bergamo',	                        'BG',	'016'),
(23,	4,	'Pavia',	                        'PV',	'018'),
(24,	4,	'Cremona',	                        'CR',	'019'),
(25,	4,	'Mantova',	                        'MN',	'020'),
(26,	4,	'Lecco',	                        'LC',	'097'),
(27,	4,	'Lodi',	                            'LO',	'098'),
(28,	4,	'Monza e della Brianza',	        'MB',	'108'),
(29,	7,	'Bolzano/Bozen',	                'BZ',	'021'),
(30,	7,	'Trento',	                        'TN',	'022'),
(31,	8,	'Verona',	                        'VR',	'023'),
(32,	8,	'Vicenza',	                        'VI',	'024'),
(33,	8,	'Belluno',	                        'BL',	'025'),
(34,	8,	'Treviso',	                        'TV',	'026'),
(35,	8,	'Venezia',	                        'VE',	'227'),
(36,	8,	'Padova',	                        'PD',	'028'),
(37,	8,	'Rovigo',	                        'RO',	'029'),
(38,	9,	'Udine',	                        'UD',	'030'),
(39,	9,	'Gorizia',	                        'GO',	'031'),
(40,	9,	'Trieste',	                        'TS',	'032'),
(41,	9,	'Pordenone',	                    'PN',	'093'),
(42,	10,	'Imperia',	                        'IM',	'008'),
(43,	10,	'Savona',	                        'SV',	'009'),
(44,	10,	'Genova',	                        'GE',	'210'),
(45,	10,	'La Spezia',	                    'SP',	'011'),
(46,	1,	'Piacenza',	                        'PC',	'033'),
(47,	1,	'Parma',	                        'PR',	'034'),
(48,	1,	'Reggio nell\'Emilia',	            'RE',	'035'),
(49,	1,	'Ferrara',	                        'FE',	'038'),
(51,	1,	'Rimini',	                        'RN',	'099'),
(52,	11,	'Massa-Carrara',	                'MS',	'045'),
(53,	11,	'Lucca',	                        'LU',	'046'),
(54,	11,	'Pistoia',	                        'PT',	'047'),
(55,	11,	'Firenze',	                        'FI',	'248'),
(56,	11,	'Livorno',	                        'LI',	'049'),
(57,	11,	'Pisa',	                            'PI',	'050'),
(58,	11,	'Arezzo',	                        'AR',	'051'),
(59,	11,	'Siena',    	                    'SI',	'052'),
(60,	11,	'Grosseto',	                        'GR',	'053');
(61,	11,	'Prato',	                        'PO',	'100'),
(62,	12,	'Perugia',	                        'PG',	'054'),
(63,	12,	'Terni',	                        'TR',	'055'),
(64,	2,	'Pesaro e Urbino',	                'PU',	'041'),
(65,	2,	'Macerata',	                        'MC',	'043'),
(66,	2,	'Fermo',	                        'FM',	'109'),
(67,	13,	'Viterbo',	                        'VT',	'056'),
(68,	13,	'Rieti',	                        'RI',	'057'),
(69,	13,	'Roma',	                            'RM',	'258'),
(70,	13,	'Latina',	                        'LT',	'059'),
(71,	13,	'Frosinone',	                    'FR',	'060'),
(72,	14,	'L\'Aquila',	                    'AQ',	'066'),
(73,	14,	'Teramo',	                        'TE',	'067'),
(74,	14,	'Pescara',	                        'PE',	'068'),
(75,	14,	'Chieti',	                        'CH',	'069'),
(76,	15,	'Campobasso',	                    'CB',	'070'),
(77,	15,	'Isernia',  	                    'IS',	'094'),
(78,	16,	'Caserta',	                        'CE',	'061'),
(79,	16,	'Benevento',	                    'BN',	'062'),
(80,	16,	'Napoli',	                        'NA',	'263'),
(81,	16,	'Avellino',	                        'AV',	'064'),
(82,	16,	'Salerno',	                        'SA',	'065'),
(83,	17,	'Foggia',	                        'FG',	'071'),
(84,	17,	'Bari', 	                        'BA',	'272'),
(85,	17,	'Taranto',	                        'TA',	'073'),
(86,	17,	'Brindisi',	                        'BR',	'074'),
(87,	17,	'Lecce',	                        'LE',	'075'),
(88,	17,	'Barletta-Andria-Trani',	        'BT',	'110'),
(89,	18,	'Potenza',	                        'PZ',	'076'),
(90,	18,	'Matera',	                        'MT',	'077'),
(91,	19,	'Cosenza',	                        'CS',	'078'),
(92,	19,	'Catanzaro',	                    'CZ',	'079'),
(93,	19,	'Reggio Calabria',	                'RC',	'280'),
(94,	19,	'Crotone',	                        'KR',	'101'),
(95,	19,	'Vibo Valentia',	                'VV',	'102'),
(96,	20,	'Trapani',	                        'TP',	'081'),
(98,	20,	'Messina',	                        'ME',	'283'),
(99,	20,	'Agrigento',	                    'AG',	'084'),
(100,	20,	'Caltanissetta',	                'CL',	'085'),
(101,	20,	'Enna',	                            'EN',	'086'),
(102,	20,	'Catania',	                        'CT',	'287'),
(103,	20,	'Ragusa',	                        'RG',	'088'),
(104,	20,	'Siracusa',	                        'SR',	'089'),
(105,	21,	'Sassari',	                        'SS',	'090'),
(106,	21,	'Nuoro',	                        'NU',	'091'),
(107,	21,	'Cagliari',	                        'CA',	'292'),
(108,	21,	'Oristano',	                        'OR',	'095'),
(109,	21,	'Olbia-Tempio',	                    'OT',	NULL),
(110,	21,	'Ogliastra',	                    'OG',	NULL),
(111,	21,	'Sud Sardegna',	                    'SU',	'111');

--| 050000028600

-- ranking
-- tipologia: tabella assistita
-- verifica: 2021-10-11 17:48 Fabio Mosti
REPLACE INTO `ranking` (`id`, `nome`, `ordine`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	'GOLD',	    100,	NULL,	NULL,	NULL,	NULL),
(2,	'SILVER',	200,	NULL,	NULL,	NULL,	NULL),
(3,	'BRONZE',	300,	NULL,	NULL,	NULL,	NULL);

--| 050000029800

-- regimi
-- tipologia: tabella standard
-- verifica: 2021-10-09 15:02 Fabio Mosti
REPLACE INTO `regimi` (`id`, `nome`, `codice`) VALUES
(1,     'privato',                      NULL),
(2,     'ordinario',                    'RF01'),
(3,     'minimi',                       'RF02'),
(4,     'agricoltura e pesca',          'RF04'),
(5,     'sali e tabacchi',              'RF05'),
(6,     'editoria',                     'RF07'),
(7,     'intrattenimento',              'RF10'),
(8,     'viaggi e turismo',             'RF11'),
(9,     'agriturismo',                  'RF12'),
(10,    'vendite a domicilio',          'RF13'),
(11,    'beni usati e collezionismo',   'RF14'),
(12,    'IVA per cassa P.A.',           'RF16'),
(13,    'IVA per cassa',                'RF17'),
(14,    'altro',                        'RF18'),
(15,    'forfettario',                  'RF19');

-- Contribuenti minimi (art. 1, commi 96-117, legge n. 244/2007)	RF2
-- Agricoltura e attività connesse e pesca (articoli 34 e 34-bis, D.P.R. n. 633/1972);	RF04
-- Vendita sali e tabacchi (art. 74, comma 1, D.P.R. n. 633/1972)	RF05
-- Commercio dei fiammiferi (art. 74, comma 1, D.P.R. n. 633/1972)	RF06
-- Editoria (art. 74, comma 1, D.P.R. n. 633/1972)	RF07
-- Gestione di servizi di telefonia pubblica (art. 74, comma 1, D.P.R. n. 633/1972)	RF08
-- Rivendita di documenti di trasporto pubblico e di sosta (art. 74, comma 1, D.P.R. n. 633/1972)	RF09
-- Intrattenimenti, giochi e altre attività di cui alla tariffa allegata al D.P.R. n. 640/1972 (art. 74, comma 6, D.P.R. n. 633/1972)	RF10
-- Agenzie di viaggi e turismo (art. 74-ter, D.P.R. n. 633/1972)	RF11
-- Agriturismo (art. 5, comma 2, legge n. 413/1991)	FR12
-- Vendite a domicilio (art. 25-bis, comma 6, D.P.R. n. 600/1973)	RF13
-- Rivendita di beni usati, di oggetti d’arte, d’antiquariato o da collezione (art. 36, D.L. n. 41/1995)	RF14
-- Agenzie di vendite all’asta di oggetti d’arte, antiquariato o da collezione (art. 40-bis, D.L. n. 41/1995)	RF15
-- IVA per cassa P.A. (art. 6, comma 5, D.P.R. n. 633/1972)	RF16
-- IVA per cassa (art. 32-bis, D.L. n. 83/2012)	RF17
-- Altro	RF18
-- Forfettario (art.1, commi 54-89, legge n. 190/2014)	RF19

--| 050000030200

-- regioni
-- tipologia: tabella standard
-- verifica: 2021-10-09 15:22 Fabio Mosti
REPLACE INTO `regioni` (`id`, `id_stato`, `nome`, `codice_istat`) VALUES
(1,	    1,	'Emilia-Romagna',	                '08'),
(2,	    1,	'Marche',	                        '11'),
(4,	    1,	'Lombardia',	                    '03'),
(5,	    1,	'Piemonte',	                        '01'),
(6,	    1,	'Valle d\'Aosta/Vallée d\'Aoste',	'02'),
(7,	    1,	'Trentino-Alto Adige/Südtirol',	    '04'),
(8,	    1,	'Veneto',	                        '05'),
(9,	    1,	'Friuli-Venezia Giulia',	        '06'),
(10,	1,	'Liguria',	                        '07'),
(11,	1,	'Toscana',	                        '09'),
(12,	1,	'Umbria',	                        '10'),
(13,	1,	'Lazio',	                        '12'),
(14,	1,	'Abruzzo',	                        '13'),
(15,	1,	'Molise',	                        '14'),
(16,	1,	'Campania',	                        '15'),
(17,	1,	'Puglia',	                        '16'),
(18,	1,	'Basilicata',	                    '17'),
(19,	1,	'Calabria',	                        '18'),
(20,	1,	'Sicilia',	                        '19'),
(21,	1,	'Sardegna',	                        '20');

--| 050000030800

-- reparti
-- tipologia: tabella assistita
-- verifica: 2021-10-09 15:34 Fabio Mosti
INSERT INTO `reparti` (`id`, `id_iva`, `id_settore`, `nome`, `note`, `timestamp_inserimento`, `id_account_inserimento`, `timestamp_aggiornamento`, `id_account_aggiornamento`) VALUES
(1,	1,	NULL,	'VENDITA IVA 22%',	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000034000

-- ruoli_anagrafica
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:11 Fabio Mosti
REPLACE INTO `ruoli_anagrafica` (`id`, `id_genitore`, `nome`, `se_organizzazioni`, `se_risorse`, `se_progetti`) VALUES
(1,	    NULL,	'titolare',	                    1,	    NULL,	NULL),
(2,	    NULL,	'amministratore',	            1,	    NULL,	NULL),
(3,	    NULL,	'socio',	                    1,	    NULL,	NULL),
(4,	    NULL,	'dipendente',	                1,	    NULL,	NULL),
(5,	    NULL,	'direttore',	                1,	    NULL,	NULL),
(6,	    NULL,	'presidente',	                1,	    NULL,	NULL),
(7,	    NULL,	'tesoriere',	                1,	    NULL,	NULL),
(8,	    NULL,	'coordinatore',	                1,	    NULL,	1),
(9,	    NULL,	'vicepresidente',	            1,	    NULL,	NULL),
(10,	NULL,	'vicedirettore',	            1,	    NULL,	NULL),
(11,	NULL,	'segretario',	                1,	    NULL,	NULL),
(12,	NULL,	'responsabile amministrativo',	1,	    NULL,	NULL),
(13,	NULL,	'responsabile acquisti',	    1,	    NULL,	NULL),
(14,	NULL,	'responsabile operativo',	    1,	    NULL,	NULL),
(15,	NULL,	'operatore',	                NULL,	NULL,	1),
(16,	NULL,	'responsabile',	                NULL,	NULL,	1),
(17,	NULL,	'assistente',	                1,	    NULL,	1),
(18,	NULL,	'autore',	                    NULL,	1,	    NULL);

--| 050000034200

-- ruoli_audio
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:28 Fabio Mosti
REPLACE INTO `ruoli_audio` (`id`, `nome`, `se_anagrafica`, `se_pagine`, `se_categorie_prodotti`, `se_prodotti`, `se_articoli`) VALUES
(1,	    'audio',	    1,	    1,	    1,	    1,	    1),
(2,	    'commento',	    NULL,	1,	    NULL,	1,	    1);

--| 050000034400

-- ruoli_file
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:14 Fabio Mosti
REPLACE INTO `ruoli_file` (`id`, `nome`, `se_anagrafica`, `se_pagine`, `se_categorie_prodotti`, `se_template`, `se_prodotti`, `se_articoli`, `se_categorie_risorse`, `se_mail`) VALUES
(1,	    'allegato',	        1,	    1,	    1,	    1,	    1,	    1,	    NULL,	    1),
(2,	    'brochure',	        NULL,	NULL,	NULL,	NULL,	1,	    1,	    NULL,	    NULL),
(3,	    'documentazione',	NULL,	NULL,	NULL,	NULL,	1,	    1,	    NULL,	    NULL),
(4,	    'driver',	        NULL,	NULL,	NULL,	NULL,	1,	    1,	    NULL,	    NULL),
(5,	    'manualistica',	    NULL,	NULL,	NULL,	NULL,	1,	    1,	    NULL,	    NULL),
(6,	    'press kit',	    1,	    NULL,	NULL,	NULL,	1,	    NULL,	NULL,	    NULL),
(7,	    'schede tecniche',	NULL,	NULL,	NULL,	NULL,	1,	    1,	    NULL,	    NULL),
(8,	    'software',	        NULL,	NULL,	NULL,	NULL,	1,	    1,	    NULL,	    NULL);

--| 050000034600

-- ruoli_immagini
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:47 Fabio Mosti
REPLACE INTO `ruoli_immagini` (`id`, `id_genitore`, `ordine_scalamento`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`) VALUES
(1,	NULL,	900,	'immagine',	    NULL,	NULL,	1,	    1,	    1,	    1,	    1,	    1,	    1,	    1,	    1),
(2,	NULL,	300,	'intestazione',	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	900,	'sfondo',	    NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	600,	'gallery',	    NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	600,	'jumbotron',	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	1,      NULL,	1,      NULL,	1),
(6,	NULL,	100,	'avatar',	    NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	300,	'logo',	        NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	200,	'carousel',     NULL,	NULL,	NULL,	1,	    NULL,	NULL,	1,      NULL,	1,      NULL,	1);

--| 050000034800

-- ruoli_indirizzi
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:45 Fabio Mosti
REPLACE INTO `ruoli_indirizzi` (`id`, `nome`, `html_entity`, `font_awesome`, `se_sede_legale`, `se_sede_operativa`, `se_residenza`, `se_domicilio`) VALUES
(1,	'sede legale',	    '&#xf1ad;',	    '',     1,	    NULL,	NULL,	NULL),
(2,	'sede operativa',	'&#xf275;',     '',     NULL,	1,	    NULL,	NULL),
(3,	'casa',             '&#xf015;',     '',     NULL,	NULL,	1,	    NULL),
(4,	'residenza',	    '&#xf015;',	    '',     NULL,	NULL,	1,	    NULL),
(5,	'domicilio',	    '&#xf015;',	    '',     NULL,	NULL,	1,	    1);

--| 050000035000

-- ruoli_prodotti
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:46 Fabio Mosti
REPLACE INTO `ruoli_prodotti` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`) VALUES
(1,	    NULL,	'prodotto',	    NULL,	NULL),
(2,	    NULL,	'principale',	NULL,	NULL),
(3,	    NULL,	'suggerito',	NULL,	NULL);

--| 050000035200

-- ruoli_video
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:47 Fabio Mosti
REPLACE INTO `ruoli_video` (`id`, `nome`, `se_anagrafica`, `se_pagine`, `se_categorie_prodotti`, `se_prodotti`, `se_articoli`) VALUES
(1,	    'intestazione',	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	    'sfondo',	    NULL,	NULL,	NULL,	NULL,	NULL),
(4,	    'card',	        NULL,	NULL,	NULL,	NULL,	NULL),
(5,	    'media',	    NULL,	NULL,	NULL,	NULL,	NULL),
(7,	    'gallery',	    NULL,	NULL,	NULL,	1,	    1),
(8,	    'footer',	    NULL,	NULL,	NULL,	NULL,	NULL),
(9,	    'contenuto',	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	'copertina',	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	'principale',	NULL,	1,	    1,	    1,	    1),
(12,	'carousel',	    NULL,	NULL,	NULL,	NULL,	NULL),
(13,	'video',	    1,	    1,	    1,	    1,	    1),
(14,	'jumbotron',	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	'dettaglio',	NULL,	NULL,	NULL,	NULL,	NULL),
(16,	'anteprima',	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000037000

-- settori
-- tipologia: tabella standard
-- verifica: 2021-10-11 10:53 Fabio Mosti
REPLACE INTO `settori` (`id`, `id_genitore`, `ateco`, `nome`, `soprannome`) VALUES
(1,     NULL,   'A',          'AGRICOLTURA, SILVICOLTURA E PESCA',                                                    'agricoltura, silvicoltura e pesca'),
(2,     1,      '01',         'COLTIVAZIONI AGRICOLE E PRODUZIONE DI PRODOTTI ANIMALI, CACCIA E SERVIZI CONNESSI',    'coltivazioni, prodotti animali e caccia'),
(3,     2,      '01.1',       'COLTIVAZIONE DI COLTURE AGRICOLE NON PERMANENTI',                                      'colture non permanenti'),
(4,     2,      '01.11',      'Coltivazione di cereali (escluso il riso), legumi da granella e semi oleosi',          'coltivazione di cereali, legumi e semi'),
(5,     4,      '01.11.1',    'Coltivazione di cereali (escluso il riso)',                                            'coltivazione di cereali');

--| 050000042000

-- stati
-- tipologia: tabella standard
-- verifica: 2021-10-12 15:06 Fabio Mosti
REPLACE INTO `stati` (`id`, `id_continente`, `iso31661alpha2`, `iso31661alpha3`, `nome`, `note`, `codice_istat`, `data_archiviazione`) VALUES
(1,	    1,	'IT',	'ITA',	'Italia',	'Repubblica Italiana',	NULL,	NULL),
(2,	    1,	'CZ',	'CZE',	'Repubblica Ceca',	NULL,	NULL,	NULL),
(3,	    1,	'HU',	'HUN',	'Ungheria',	NULL,	NULL,	NULL),
(4,	    3,	'JP',	'JP',	'Giappone',	NULL,	NULL,	NULL),
(5,	    1,	'PL',	'POL',	'Polonia',	'Repubblica di Polonia',	NULL,	NULL),
(6,	    1,	'PT',	'PRT',	'Portogallo',	'Repubblica Portoghese',	NULL,	NULL),
(7,	    1,	'RU',	'RUS',	'Russia',	'Federazione Russa',	NULL,	NULL),
(8,	    1,	'DE',	'DEU',	'Germania',	'Repubblica Federale di Germania',	NULL,	NULL),
(9,	    1,	'GB',	'GBR',	'Regno Unito',	'Regno Unito di Gran Bretagna e Irlanda del Nord',	NULL,	NULL),
(10,	4,	'US',	'USA',	'Stati Uniti d\'America',	NULL,	NULL,	NULL),
(11,	1,	'ES',	'ESP',	'Spagna',	'Regno di Spagna',	NULL,	NULL),
(12,	1,	'FR',	'FRA',	'Francia',	'Repubblica Francese',	NULL,	NULL),
(13,	1,	'SE',	'SWE',	'Svezia',	'Regno di Svezia',	NULL,	NULL),
(14,	1,	'HR',	'HRV',	'Croazia',	'Repubblica di Croazia',	NULL,	NULL),
(15,	1,	'AL',	'ALB',	'Albania',	'Repubblica d\'Albania',	NULL,	NULL),
(16,	2,	'AO',	'AGO',	'Angola',	'Repubblica dell\'Angola',	NULL,	NULL),
(17,	4,	'AG',	'ATG',	'Antigua e Barbuda',	'Antigua e Barbuda',	NULL,	NULL),
(18,	3,	'SA',	'SAU',	'Arabia Saudita',	'Regno dell\'Arabia Saudita',	NULL,	NULL),
(19,	3,	'AM',	'ARM',	'Armenia',	'Repubblica di Armenia',	NULL,	NULL),
(20,	5,	'AU',	'AUS',	'Australia',	'Australia',	NULL,	NULL),
(21,	1,	'AT',	'AUT',	'Austria',	'Repubblica d\'Austria',	NULL,	NULL),
(22,	3,	'AZ',	'AZE',	'Azerbaigian',	'Repubblica dell\'Azerbaigian',	NULL,	NULL),
(23,	6,	'BS',	'BHS',	'Bahamas',	'Commonwealth delle Bahamas',	NULL,	NULL),
(24,	3,	'BH',	'BHR',	'Bahrein',	'Regno del Bahrein',	NULL,	NULL),
(25,	1,	'IB',	'',	    'Baleari (isole)',	'isole Baleari',	NULL,	NULL),
(26,	3,	'BD',	'BGD',	'Bangladesh',	'Repubblica Popolare del Bangladesh',	NULL,	NULL),
(27,	4,	'BB',	'BRB',	'Barbados',	'Barbados',	NULL,	NULL),
(28,	1,	'BE',	'BEL',	'Belgio',	'Regno del Belgio',	NULL,	NULL),
(29,	4,	'BZ',	'BLZ',	'Belize',	'Belize',	NULL,	NULL),
(30,	2,	'BJ',	'BEN',	'Benin',	'Repubblica del Benin',	NULL,	NULL),
(31,	4,	'BM',	'BMU',	'Bermuda',	'Bermuda',	NULL,	NULL),
(32,	1,	'BY',	'BLR',	'Bielorussia',	'Repubblica di Bielorussia',	NULL,	NULL),
(33,	1,	'BA',	'BIH',	'Bosnia ed Erzegovina',	'Bosnia ed Erzegovina',	NULL,	NULL),
(34,	3,	'BN',	'BRN',	'Brunei',	'Stato del Brunei',	NULL,	NULL),
(35,	1,	'BG',	'BG3',	'Bulgaria',	'Repubblica di Bulgaria',	NULL,	NULL),
(36,	2,	'BF',	'BFA',	'Burkina Faso',	'Burkina Faso',	NULL,	NULL),
(37,	2,	'BI',	'BDI',	'Burundi',	'Repubblica del Burundi',	NULL,	NULL),
(38,	3,	'KH',	'KHM',	'Cambogia',	'Regno di Cambogia',	NULL,	NULL),
(39,	4,	'CA',	'CAN',	'Canada',	'Canada',	NULL,	NULL),
(40,	1,	'ES',	'CN',	'Canarie (isole)',	'Isole Canarie',	NULL,	NULL),
(41,	2,	'CV',	'CPV',	'Capo Verde',	'Repubblica di Capo Verde',	NULL,	NULL),
(42,	2,	'TD',	'TCD',	'Ciad',	'Repubblica del Ciad',	NULL,	NULL),
(43,	3,	'CN',	'CHN',	'Cina',	'Repubblica Popolare Cinese',	NULL,	NULL),
(44,	3,	'CY',	'CYP',	'Cipro',	'Repubblica di Cipro',	NULL,	NULL),
(45,	2,	'KM',	'COM',	'Comore',	'Unione delle Comore',	NULL,	NULL),
(46,	3,	'KP',	'PRK',	'Corea del Nord',	'Repubblica Popolare Democratica di Corea',	NULL,	NULL),
(47,	3,	'KR',	'KOR',	'Corea del Sud',	'Repubblica di Corea',	NULL,	NULL),
(48,	2,	'CI',	'CIV',	'Costa d\'Avorio',	'Repubblica della Costa d\'Avorio',	NULL,	NULL),
(49,	1,	'HR',	'HRV',	'Croazia',	'Repubblica di Croazia',	NULL,	NULL),
(50,	1,	'DK',	'DNK',	'Danimarca',	'Regno di Danimarca',	NULL,	NULL),
(51,	2,	'EG',	'EGY',	'Egitto',	'Repubblica Araba d\'Egitto',	NULL,	NULL),
(52,	3,	'AE',	'ARE',	'Emirati Arabi Uniti',	'Stato degli Emirati Arabi Uniti',	NULL,	NULL),
(53,	1,	'EE',	'EST',	'Estonia',	'Repubblica d\'Estonia',	NULL,	NULL),
(54,	3,	'PH',	'PHL',	'Filippine',	'Repubblica delle Filippine',	NULL,	NULL),
(55,	1,	'FI',	'FIN',	'Finlandia',	'Repubblica di Finlandia',	NULL,	NULL),
(56,	2,	'GA',	'GAB',	'Gabon',	'Repubblica Gabonese',	NULL,	NULL),
(57,	2,	'GM',	'GMB',	'Gambia',	'Repubblica del Gambia',	NULL,	NULL),
(58,	4,	'JM',	'JAM',	'Giamaica',	'Giamaica',	NULL,	NULL),
(59,	2,	'DJ',	'DJI',	'Gibuti',	'Repubblica di Gibuti',	NULL,	NULL),
(60,	3,	'JO',	'JOR',	'Giordania',	'Regno Hascemita di Giordania',	NULL,	NULL),
(61,	1,	'GR',	'GRC',	'Grecia',	'Repubblica Ellenica',	NULL,	NULL),
(62,	4,	'GD',	'GRD',	'Grenada',	'Grenada',	NULL,	NULL),
(63,	2,	'GW',	'GNB',	'Guinea-Bissau',	'Repubblica di Guinea-Bissau',	NULL,	NULL),
(64,	4,	'HT',	'HTI',	'Haiti',	'Repubblica di Haiti',	NULL,	NULL),
(65,	3,	'HK',	'HKG',	'Hong Kong',	'Regione amministrativa speciale di Hong Kong della Repubblica Popolare Cinese',	NULL,	NULL),
(66,	3,	'IN',	'IND',	'India',	'Repubblica dell\'India',	NULL,	NULL),
(67,	3,	'ID',	'IDN',	'Indonesia',	'Repubblica d\'Indonesia',	NULL,	NULL),
(68,	1,	'IE',	'IRL',	'Irlanda',	'Repubblica d\'Irlanda',	NULL,	NULL),
(69,	1,	'IS',	'ISL',	'Islanda',	'Repubblica d\'Islanda',	NULL,	NULL),
(70,	4,	'KY',	'CYM',	'Isole Cayman',	'Isole Cayman',	NULL,	NULL),
(71,	3,	'IL',	'ISR',	'Israele',	'Stato d\'Israele',	NULL,	NULL),
(72,	3,	'KZ',	'KAZ',	'Kazakistan',	'Repubblica del Kazakistan',	NULL,	NULL),
(73,	3,	'KG',	'KGZ',	'Kirghizistan',	'Repubblica del Kirghizistan',	NULL,	NULL),
(74,	5,	'KI',	'KIR',	'Kiribati',	'Repubblica delle Kiribati',	NULL,	NULL),
(75,	3,	'KW',	'KWT',	'Stato del Kuwait',	'Stato del Kuwait',	NULL,	NULL),
(76,	3,	'LA',	'LAO',	'Laos',	'Repubblica Popolare Democratica del Laos',	NULL,	NULL),
(77,	4,	'LS',	'LSO',	'Lesotho',	'Regno del Lesotho',	NULL,	NULL),
(78,	1,	'LV',	'LVA',	'Lettonia',	'Repubblica di Lettonia',	NULL,	NULL),
(79,	2,	'LR',	'LBR',	'Liberia',	'Repubblica della Liberia',	NULL,	NULL),
(80,	1,	'LI',	'LIE',	'Liechtenstein',	'Principato del Liechtenstein',	NULL,	NULL),
(81,	1,	'LT',	'LTU',	'Lituania',	'Repubblica di Lituania',	NULL,	NULL),
(82,	1,	'LU',	'LUX',	'Lussemburgo',	'Granducato di Lussemburgo',	NULL,	NULL),
(83,	3,	'MO',	'MAC',	'Macao',	'Regione Amministrativa Speciale di Macao della Repubblica Popolare Cinese',	NULL,	NULL),
(84,	1,	'MK',	'MKD',	'Macedonia del Nord',	'Repubblica della Macedonia del Nord[',	NULL,	NULL),
(85,	4,	'MG',	'MDG',	'Madagascar',	'Repubblica del Madagascar',	NULL,	NULL),
(86,	4,	'MW',	'MWI',	'Malawi',	'Repubblica di Malawi',	NULL,	NULL),
(87,	3,	'MV',	'MDV',	'Maldive',	'Repubblica delle Maldive',	NULL,	NULL),
(88,	3,	'MY',	'MYS',	'Malaysia',	'Malaysia',	NULL,	NULL),
(89,	2,	'ML',	'MLI',	'Mali',	'Repubblica del Mali',	NULL,	NULL),
(90,	1,	'MT',	'MLT',	'Malta',	'Repubblica di Malta',	NULL,	NULL),
(91,	2,	'MR',	'MRT',	'Mauritania',	'Repubblica Islamica della Mauritania',	NULL,	NULL),
(92,	2,	'MU',	'MUS',	'Mauritius',	'Repubblica di Mauritius',	NULL,	NULL),
(93,	4,	'MX',	'MEX',	'Messico',	'Stati Uniti Messicani',	NULL,	NULL),
(94,	1,	'MD',	'MDA',	'Moldavia',	'Repubblica di Moldavia',	NULL,	NULL),
(95,	1,	'MC',	'MCO',	'Monaco',	'Principato di Monaco',	NULL,	NULL),
(96,	3,	'MN',	'MNG',	'Mongolia',	'Mongolia',	NULL,	NULL),
(97,	2,	'NA',	'NAM',	'Namibia',	'Repubblica della Namibia',	NULL,	NULL),
(98,	1,	'NO',	'NOR',	'Norvegia',	'Regno di Norvegia',	NULL,	NULL),
(99,	5,	'NZ',	'NZL',	'Nuova Zelanda',	'Nuova Zelanda',	NULL,	NULL),
(101,	1,	'NL',	'NLD',	'Paesi Bassi',	'Paesi Bassi',	NULL,	NULL),
(102,	3,	'PK',	'PAK',	'Pakistan',	'Repubblica Islamica del Pakistan',	NULL,	NULL),
(103,	3,	'PS',	'PSE',	'Palestina',	'Palestina',	NULL,	NULL),
(104,	4,	'PA',	'PAN',	'Panama',	'Repubblica di Panama',	NULL,	NULL),
(105,	5,	'PG',	'PNG',	'Papua Nuova Guinea',	'Stato Indipendente della Papua Nuova Guinea',	NULL,	NULL),
(106,	1,	'PL',	'POL',	'Polonia',	'Repubblica di Polonia',	NULL,	NULL),
(107,	4,	'PR',	'PRI',	'Porto Rico',	'Stato libero associato di Porto Rico',	NULL,	NULL),
(108,	3,	'QA',	'QAT',	'Qatar',	'Stato del Qatar',	NULL,	NULL),
(109,	2,	'ZA',	'ZAF',	'Repubblica del Sudafrica',	'Repubblica del Sudafrica',	NULL,	NULL),
(110,	1,	'RO',	'ROU',	'Romania',	'Romania',	NULL,	NULL),
(111,	4,	'KN',	'KNA',	'Saint Kitts e Nevis',	'Federazione di Saint Kitts e Nevis',	NULL,	NULL),
(112,	4,	'LC',	'LCA',	'Saint Lucia',	'Saint Lucia',	NULL,	NULL),
(113,	4,	'VC',	'VCT',	'Saint Vincent e Grenadine',	'Saint Vincent e Grenadine',	NULL,	NULL),
(114,	2,	'ST',	'STP',	'São Tomé e Príncipe',	'Repubblica Democratica di São Tomé e Príncipe',	NULL,	NULL),
(115,	2,	'SC',	'SYC',	'Seychelles',	'Repubblica delle Seychelles',	NULL,	NULL),
(116,	2,	'MA',	'MAR',	'Marocco',	NULL,	NULL,	NULL),
(117,	3,	'AF',	'AFG',	'Afghanistan',	'Repubblica Islamica dell\'Afghanistan',	NULL,	NULL),
(118,	2,	'DZ',	'DZA',	'Algeria',	'Repubblica Popolare Democratica Algerina',	NULL,	NULL),
(119,	1,	'AD',	'AND',	'Andorra',	'Principato di Andorra',	NULL,	NULL),
(120,	6,	'AR',	'ARG',	'Argentina',	'Repubblica Argentina',	NULL,	NULL),
(121,	2,	'BT',	'BTN',	'Bhutan',	'Regno del Bhutan',	NULL,	NULL),
(122,	3,	'MM',	'MMR',	'Birmania',	'Unione di Myanmar',	NULL,	NULL),
(123,	4,	'BO',	'BOL',	'Bolivia',	'Stato Plurinazionale di Bolivia',	NULL,	NULL),
(124,	2,	'BW',	'BWA',	'Botswana',	'Repubblica del Botswana',	NULL,	NULL),
(125,	6,	'BR',	'BRA',	'Brasile',	'Repubblica Federale del Brasile',	NULL,	NULL),
(126,	2,	'CM',	'CMR',	'Camerun',	'Repubblica del Camerun',	NULL,	NULL),
(127,	6,	'CL',	'CHL',	'Cile',	'Repubblica del Cile',	NULL,	NULL),
(128,	6,	'CO',	'COL',	'Colombia',	'Repubblica di Colombia',	NULL,	NULL),
(129,	6,	'CR',	'CRI',	'Costa Rica',	'Repubblica di Costa Rica',	NULL,	NULL),
(130,	6,	'CU',	'CUB',	'Cuba',	'Repubblica di Cuba',	NULL,	NULL),
(131,	6,	'DM',	'DMA',	'Dominica',	'Commonwealth di Dominica',	NULL,	NULL),
(132,	6,	'EC',	'ECU',	'Ecuador',	'Repubblica dell\'Ecuador',	NULL,	NULL),
(133,	6,	'SV',	'SLV',	'El Salvador',	'Repubblica di El Salvador',	NULL,	NULL),
(134,	2,	'ER',	'ERI',	'Eritrea',	'',	NULL,	NULL),
(135,	2,	'ET',	'ETH',	'Etiopia',	'Repubblica Democratica Federale d\'Etiopia',	NULL,	NULL),
(136,	5,	'FJ',	'FJI',	'Figi',	'Repubblica delle Isole Figi',	NULL,	NULL),
(137,	1,	'GE',	'GEO',	'Georgia',	'',	NULL,	NULL),
(138,	2,	'GH',	'GHA',	'Ghana',	'Repubblica del Ghana',	NULL,	NULL),
(139,	4,	'GT',	'GTM',	'Guatemala',	'Repubblica del Guatemala',	NULL,	NULL),
(140,	2,	'GN',	'GIN',	'Guinea',	'Repubblica di Guinea',	NULL,	NULL),
(141,	2,	'GQ',	'GNQ',	'Guinea Equatoriale',	'Repubblica della Guinea Equatoriale',	NULL,	NULL),
(142,	6,	'GY',	'GUY',	'Guyana',	'Repubblica Cooperativa della Guyana',	NULL,	NULL),
(143,	4,	'HN',	'HND',	'Honduras',	'Repubblica dell\'Honduras',	NULL,	NULL),
(144,	3,	'IR',	'IRN',	'Iran',	'Repubblica Islamica dell\'Iran',	NULL,	NULL),
(145,	3,	'IQ',	'IRQ',	'Iraq',	'Repubblica dell\'Iraq',	NULL,	NULL),
(146,	5,	'MH',	'MHL',	'Isole Marshall',	'Repubblica delle Isole Marshall',	NULL,	NULL),
(147,	5,	'SB',	'SLB',	'Isole Salomone',	'',	NULL,	NULL),
(148,	2,	'KE',	'KEN',	'Kenya',	'Repubblica del Kenya',	NULL,	NULL),
(149,	3,	'KW',	'KWT',	'Kuwait',	'Stato del Kuwait',	NULL,	NULL),
(150,	2,	'LB',	'LBN',	'Libano',	'Repubblica Libanese',	NULL,	NULL),
(151,	2,	'LY',	'LBY',	'Libia',	'Stato della Libia',	NULL,	NULL),
(152,	5,	'FM',	'FSM',	'Micronesia',	'Stati Federati di Micronesia',	NULL,	NULL),
(153,	1,	'ME',	'MNE',	'Montenegro',	'Repubblica del Montenegro',	NULL,	NULL),
(154,	2,	'MZ',	'MOZ',	'Mozambico',	'Repubblica del Mozambico',	NULL,	NULL),
(155,	5,	'NR',	'NRU',	'Nauru',	'Repubblica di Nauru',	NULL,	NULL),
(156,	3,	'NP',	'NPL',	'Nepal',	'Repubblica Federale Democratica del Nepal',	NULL,	NULL),
(157,	4,	'NI',	'NIC',	'Nicaragua',	'Repubblica del Nicaragua',	NULL,	NULL),
(158,	2,	'NE',	'NER',	'Niger',	'Repubblica del Niger',	NULL,	NULL),
(159,	2,	'NG',	'NGA',	'Nigeria',	'Repubblica Federale della Nigeria',	NULL,	NULL),
(160,	3,	'OM',	'OMN',	'Oman',	'Sultanato di Oman',	NULL,	NULL),
(161,	5,	'PW',	'PLW',	'Palau',	'Repubblica di Palau',	NULL,	NULL),
(162,	6,	'PY',	'PRY',	'Paraguay',	'Repubblica del Paraguay',	NULL,	NULL),
(163,	6,	'PE',	'PER',	'Perù',	'Repubblica del Perù',	NULL,	NULL),
(164,	2,	'CF',	'CAF',	'Repubblica Centroafricana',	'Repubblica Centrafricana',	NULL,	NULL),
(165,	2,	'CG',	'COG',	'Repubblica del Congo',	'',	NULL,	NULL),
(166,	2,	'CD',	'COD',	'Repubblica Democratica del Congo',	'',	NULL,	NULL),
(167,	4,	'DO',	'DOM',	'Repubblica Dominicana',	'',	NULL,	NULL),
(168,	2,	'RW',	'RWA',	'Ruanda',	'Repubblica del Ruanda',	NULL,	NULL),
(169,	4,	'VC',	'VCT',	'Saint Vincent e Grenadine',	'',	NULL,	NULL),
(170,	5,	'WS',	'WSM',	'Samoa',	'Stato Indipendente di Samoa',	NULL,	NULL),
(171,	1,	'SM',	'SMR',	'San Marino',	'Serenissima Repubblica di San Marino',	NULL,	NULL),
(172,	2,	'SN',	'SEN',	'Senegal',	'Repubblica del Senegal',	NULL,	NULL),
(173,	1,	'RS',	'SRB',	'Serbia',	'Repubblica di Serbia',	NULL,	NULL),
(174,	2,	'SL',	'SLE',	'Sierra Leone',	'Repubblica della Sierra Leone',	NULL,	NULL),
(175,	3,	'SG',	'SGP',	'Singapore',	'Repubblica di Singapore',	NULL,	NULL),
(176,	3,	'SY',	'SYR',	'Siria',	'Repubblica Araba di Siria',	NULL,	NULL),
(177,	1,	'SK',	'SVK',	'Slovacchia',	'Repubblica Slovacca',	NULL,	NULL),
(178,	1,	'SI',	'SVN',	'Slovenia',	'Repubblica di Slovenia',	NULL,	NULL),
(179,	2,	'SO',	'SOM',	'Somalia',	'Repubblica Federale di Somalia',	NULL,	NULL),
(180,	1,	'ES',	'ESP',	'Spagna',	'Regno di Spagna',	NULL,	NULL),
(181,	3,	'LK',	'LKA',	'Sri Lanka',	'Repubblica Democratica Socialista dello Sri Lanka',	NULL,	NULL),
(182,	2,	'ZA',	'ZAF',	'Sudafrica',	'Repubblica del Sudafrica',	NULL,	NULL),
(183,	2,	'SD',	'SDN',	'Sudan',	'Repubblica del Sudan',	NULL,	NULL),
(184,	2,	'SS',	'SSD',	'Sudan del Sud',	'Repubblica del Sudan del Sud',	NULL,	NULL),
(185,	6,	'SR',	'SUR',	'Suriname',	'Repubblica del Suriname',	NULL,	NULL),
(186,	1,	'CH',	'CHE',	'Svizzera',	'Confederazione Svizzera',	NULL,	NULL),
(187,	2,	'SZ',	'SWZ',	'Swaziland',	'Regno dello Swaziland',	NULL,	NULL),
(188,	3,	'TJ',	'TJK',	'Tagikistan',	'Repubblica del Tagikistan',	NULL,	NULL),
(189,	3,	'TH',	'THA',	'Thailandia',	'Regno di Thailandia',	NULL,	NULL),
(190,	3,	'TW',	'TWN',	'Taiwan',	'Repubblica di Cin',	NULL,	NULL),
(191,	5,	'TZ',	'TZA',	'Tanzania',	'Repubblica Unita di Tanzania',	NULL,	NULL),
(192,	3,	'TL',	'TLS',	'Timor Est',	'Repubblica Democratica di Timor Est',	NULL,	NULL),
(193,	2,	'TG',	'TGO',	'Togo',	'Repubblica Togolese',	NULL,	NULL),
(194,	5,	'TO',	'TON',	'Tonga',	'Regno di Tonga',	NULL,	NULL),
(195,	6,	'TT',	'TTO',	'Trinidad e Tobago',	'Repubblica di Trinidad e Tobago',	NULL,	NULL),
(196,	2,	'TN',	'TUN',	'Tunisia',	'Repubblica Tunisina',	NULL,	NULL),
(197,	1,	'TR',	'TUR',	'Turchia',	'Repubblica di Turchia',	NULL,	NULL),
(198,	3,	'TM',	'TKM',	'Turkmenistan',	'',	NULL,	NULL),
(199,	5,	'TV',	'TUV',	'Tuvalu',	'',	NULL,	NULL),
(200,	1,	'UA',	'UKR',	'Ucraina',	'',	NULL,	NULL),
(201,	2,	'UG',	'UGA',	'Uganda',	'Repubblica dell\'Uganda',	NULL,	NULL),
(202,	6,	'UY',	'URY',	'Uruguay',	'Repubblica Orientale dell\'Uruguay',	NULL,	NULL),
(203,	3,	'UZ',	'UZB',	'Uzbekistan',	'Repubblica dell\'Uzbekistan',	NULL,	NULL),
(204,	5,	'VU',	'VUT',	'Vanuatu',	'Repubblica di Vanuatu',	NULL,	NULL),
(205,	6,	'VE',	'VEN',	'Venezuela',	'Repubblica Bolivariana del Venezuela',	NULL,	NULL),
(206,	3,	'VN',	'VNM',	'Vietnam',	'Repubblica Socialista del Vietnam',	NULL,	NULL),
(207,	3,	'YE',	'YEM',	'Yemen',	'Repubblica dello Yemen',	NULL,	NULL),
(208,	2,	'ZM',	'ZMB',	'Zambia',	'Repubblica dello Zambia',	NULL,	NULL),
(209,	2,	'ZW',	'ZWE',	'Zimbabwe',	'Repubblica dello Zimbabwe',	NULL,	NULL),
(210,	2,	NULL,	NULL,	'Zaire',	'Cambio denominazione della Repubblica dello Zaire in Repubblica democratica del Congo',	'463',	'1997-05-17'),
(211,	2,	NULL,	NULL,	'Swaziland',	'Cambio denominazione del Regno dello Swaziland in Regno di Eswatini',	'456',	'2018-04-19'),
(212,	1,	NULL,	NULL,	'Ex Repubblica Jugoslava di Macedonia',	'Cambio denominazione della Ex Repubblica Jugoslava di Macedonia in Repubblica della Macedonia del Nord (denominazione breve Mace',	'253',	'2019-02-14'),
(213,	4,	NULL,	NULL,	'Anguilla',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'917',	'2017-04-13'),
(214,	1,	NULL,	NULL,	'Antille olandesi, isole',	'Territorio soppresso e passato a costituire i nuovi territori di Curaçao e Sint Maarten (NL)',	'907',	'2015-01-01'),
(215,	4,	NULL,	NULL,	'Aruba',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'926',	'2017-04-13'),
(216,	4,	NULL,	NULL,	'Bermuda',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'908',	'2017-04-13'),
(217,	1,	NULL,	NULL,	'Cecoslovacchia',	'Costituite le nazioni della Repubblica ceca e della Slovacchia a seguito del distacco dei territori dal soppresso Stato della Ce',	'801',	'1992-12-31'),
(218,	1,	NULL,	NULL,	'Gibilterra',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'910',	'2017-04-13'),
(219,	4,	NULL,	NULL,	'Groenlandia',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'934',	'2017-04-13'),
(220,	1,	NULL,	NULL,	'Guernsey',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'940',	'2017-04-13'),
(221,	1,	NULL,	NULL,	'Isola di Man',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'959',	NULL),
(222,	4,	NULL,	NULL,	'Isole Cayman',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'911',	'2017-04-13'),
(223,	5,	NULL,	NULL,	'Isole Cook (NZ)',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'909',	'2017-04-13'),
(224,	1,	NULL,	NULL,	'Isole Fær Øer',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'924',	'2017-04-13'),
(225,	4,	NULL,	NULL,	'Isole Falkland (Malvine)',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'958',	'2017-04-13'),
(226,	1,	NULL,	NULL,	'Isole Jersey',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'925',	'2014-01-01'),
(227,	1,	NULL,	NULL,	'Repubblica Socialista Federale di Jugoslavia',	'Soppressa la Repubblica Socialista Federale della Jugoslavia in luogo del nuovo Stato di Serbia e Montenegro',	'820',	'2003-02-04'),
(228,	1,	NULL,	NULL,	'Kosovo',	'Nuovo Stato del Kosovo costituito a seguito del distacco dal territorio dalla Serbia',	'272',	'2008-02-17'),
(229,	4,	NULL,	NULL,	'Montserrat',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'964',	'2017-04-13'),
(230,	5,	NULL,	NULL,	'Nuova Caledonia',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'902',	'2017-04-13'),
(231,	5,	NULL,	NULL,	'Polinesia francese',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'920',	'2017-04-13'),
(232,	2,	NULL,	NULL,	'Sahara occidentale',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'905',	'2017-04-13'),
(233,	4,	NULL,	NULL,	'Saint-Barthélemy',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'906',	'2017-04-13'),
(234,	4,	NULL,	NULL,	'Saint-Martin (FR)',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'904',	'2017-04-13'),
(235,	1,	NULL,	NULL,	'Sark',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'939',	'2017-04-13'),
(236,	1,	NULL,	NULL,	'Serbia e Montenegro',	'Costituite le nazioni indipendenti della Serbia e del Montenegro a seguito del distacco del Montenegro dal soppresso Stato della',	'224',	'2006-06-03'),
(237,	4,	NULL,	NULL,	'Sint Maarten (NL)',	'Territorio incluso nella classificazione in adeguamento alle direttive di Eurostat',	'928',	'2017-04-13');

--| 050000042200

-- stati_lingue
-- tipologia: tabella standard
-- verifica: 2021-10-12 15:42 Fabio Mosti
REPLACE INTO `stati_lingue` (`id`, `id_stato`, `id_lingua`) VALUES
(1,     1,	    1);

--| 050000043000

-- task
-- tipologia: tabella assistita
-- verifica: 2021-10-12 15:42 Fabio Mosti
REPLACE INTO `task` (`id`, `minuto`, `ora`, `giorno_del_mese`, `mese`, `giorno_della_settimana`, `settimana`, `task`, `iterazioni`, `delay`, `token`, `timestamp_esecuzione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_images.resize.php',	                                    1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_mail.queue.send.php',	                                    3,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_sms.queue.send.php',	                                    3,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_indirizzi.geocode.php',	                                1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	6,	    2,	    6,	    2,	    NULL,	NULL,	'_src/_api/_task/_comuni.importazione.start.php',	                        1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	6,	    6,	    6,	    6,	    NULL,	NULL,	'_src/_api/_task/_settori.importazione.start.php',	                        1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	6,	    5,	    NULL,	NULL,	NULL,	NULL,	'_mod/_6200.documenti/_src/_api/_task/_download.fe.passive.start.php',	    1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000050000

-- tipologie_anagrafica
-- tipologia: tabella standard
-- verifica: 2021-10-15 16:15 Fabio Mosti
REPLACE INTO `tipologie_anagrafica` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_persona_fisica`) VALUES
(1,	NULL,	10,	'persone fisiche',	    NULL,	NULL,	1),
(2,	NULL,	20,	'persone giuridiche',	NULL,	NULL,	NULL),
(3,	1,	    10,	'sig.',	                NULL,	NULL,	1),
(4,	1,	    20,	'sig.ra',	            NULL,	NULL,	1),
(5,	2,	    10,	'spett.',	            NULL,	NULL,	NULL);

--| 050000050400

-- tipologie_attivita
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
REPLACE INTO `tipologie_attivita` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_agenda`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'lavoro',	NULL,	NULL,	1,	    1,	    NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'ferie',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'permessi',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'malattie',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000050800

-- tipologie_contatti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
REPLACE INTO `tipologie_contatti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'di persona',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'telefono',	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'mail',	        NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'form web',	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'chat',	        NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000052600

-- tipologie_documenti
-- tipologia: tabella di supporto
-- verifica: 2021-12-07 17:00 Chiara GDL
REPLACE INTO `tipologie_documenti` (`id`, `nome`, `codice`, `se_fattura`, `se_nota_credito`, `se_trasporto`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_ricevuta`, `stampa_xml`, `stampa_pdf`) VALUES
(1,	'fattura',	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	'fattura accompagnatoria',	'TD01',	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	'nota di credito',	'TD04',	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	'documento di trasporto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	'pro forma',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	'offerta',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(7,	'ordine',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	'ricevuta',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	'scontrino',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10, 'documento di ritiro',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(11, 'consegna',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12, 'documento di reso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000053000

-- tipologie_indirizzi
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT INTO `tipologie_indirizzi` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'via',	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'viale',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'piazza',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000053400

-- tipologie_mastri
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT INTO `tipologie_mastri` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_magazzino`, `se_conto`, `se_registro`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'magazzino',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'conto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'registro ore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| 050000053800

-- tipologie_notizie
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti

--| 050000054200

-- tipologie_popup
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti

--| 050000054600

-- tipologie_prodotti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT IGNORE INTO `tipologie_prodotti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_colori`, `se_taglie`, `se_dimensioni`, `se_imballo`, `se_spedizione`, `se_trasporto`, `se_prodotto`, `se_servizio`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'prodotto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'servizio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	2,	NULL,	NULL,	NULL,	NULL);

--| 050000055000

-- tipologie_progetti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT IGNORE INTO `tipologie_progetti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_contratto`, `se_pacchetto`, `se_progetto`, `se_consuntivo`, `se_forfait`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'contratto',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'pacchetto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'progetto',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'consuntivo',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'forfait',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| 050000055400

-- tipologie_pubblicazioni
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT IGNORE INTO `tipologie_pubblicazioni` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_bozza`, `se_pubblicato`, `se_evidenza`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'bozza',	    NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'pubblicato',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000055800

-- tipologie_risorse
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti

--| 050000056200

-- tipologie_telefoni
-- tipologia: tabella standard
-- verifica: 2021-10-15 17:46 Fabio Mosti
REPLACE INTO `tipologie_telefoni` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`) VALUES
(1,	NULL,   10,     'telefono',	    '&#xf095;',     ''),
(2,	NULL,   20,     'mobile',	    '&#xf10b;',     ''),
(3,	NULL,   30,     'fax',	        '&#xf02f;',     ''),
(4,	NULL,   40,     'telefono/fax',	'&#xf1ac;',     '');

--| 050000056600

-- tipologie_todo
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
REPLACE INTO `tipologie_todo` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'produzione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'commerciale',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'amministrazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000056800

-- tipologie_url
-- tipologia: tabella assistita
-- verifica: 2021-11-09 12:45 Chiara GDL

--| 050000062000

-- udm
-- tipologia: tabella standard
-- verifica: 2021-10-19 13:02 Fabio Mosti
REPLACE INTO `udm` (`id`, `id_genitore`, `conversione`, `nome`, `sigla`, `note`, `se_lunghezza`, `se_peso`, `se_quantita`) VALUES
(1, NULL,	NULL,	'pezzi',	'pz.',	'unità di misura usata genericamente per misurare le quantità',	NULL,	NULL,	1);

--| 050000063000

-- valute
-- tipologia: tabella standard
-- verifica: 2021-10-19 13:21 Fabio Mosti
REPLACE INTO `valute` (`id`, `iso4217`, `html_entity`, `utf8`) VALUES
(1,	'EUR',	'&#8634;',	'€');

--| FINE FILE
