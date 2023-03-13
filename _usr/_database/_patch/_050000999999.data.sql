--
-- DATI
-- questo file contiene le query per l'inserimento dei dati standard nelle tabelle
--

--| 050000002800

-- caratteristiche_immobili
-- tipologia: tabella gestita
-- verifica: 2022-05-02 17:22 Chiara GDL
INSERT INTO `caratteristiche_immobili` (`id`, `nome`, `font_awesome`, `html_entity`, `se_indirizzo`, `se_edificio`, `se_immobile`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	'balcone',	'fa-picture-o',	'&#xf03e;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(2,	'giardino',	'fa-tree',	'&#xf1bb;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(3,	'cantina',	'fa-key',	'&#xf084;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(4,	'tavernetta',	'fa-key',	'&#xf084;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(5,	'ascensore',	'fa-sort',	'&#xf0dc;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(6,	'giardino privato',	'fa-tree',	'&#xf1bb;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(7,	'posto auto',	'fa-car',	'&#xf1b9;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(8,	'garage',	'fa-car',	'&#xf1b9;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(9,	'riscaldamento autonomo',	'fa-thermometer-full',	'&#xf2c7;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(10,	'riscaldamento centralizzato',	'fa-thermometer-half',	'&#xf2c9;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(11,	'arredato',	'fa-check',	'&#xf00c;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(12,	'non arredato',	'fa-times',	'&#xf00d;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(13,	'parzialmente arredato',	'fa-minus',	'&#xf068;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(14,	'terrazza abitabile',	'fa-picture-o',	'&#xf03e;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(15,	'senza riscaldamento',	'fa-thermometer-empty',	'&#xf2cb;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(16,	'volendo arredato',	'fa-truck',	'&#xf0d1;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(17,	'arredato solo cucina',	'fa-coffee',	'&#xf0f4;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(18,	'garage doppio',	'fa-car',	'&#xf1b9;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(19,	'posto auto coperto',	'fa-car',	'&#xf1b9;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(20,	'nessun posto auto',	'fa-road',	'&#xf018;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(21,	'posto auto condominiale',	'fa-car',	'&#xf1b9;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(22,	'cucina abitabile',	'fa-coffee',	'&#xf0f4;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(23,	'mansarda',	'fa-angle-up',	'&#xf106;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(24,	'camino',	'fa-fire',	'&#xf06d;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(25,	'angolo cottura',	'fa-coffee',	'&#xf0f4;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(26,	'giardino condominiale',	'fa-tree',	'&#xf1bb;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(27,	'aria condizionata',	'fa-snowflake-o',	'&#xf2dc;',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(28,	'portineria',	'fa-user',	'&#xf007;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(29,	'mezzi pubblici',	'fa-bus',	'&#xf207;',	1,	1,	1,	NULL,	NULL,	NULL,	NULL),
(30,	'palazzo storico',	'fa-university',	'&#xf19c;',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(31,	'stile Liberty',	'fa-building',	'&#xf1ad;',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(32,	'pietra vista',	'fa-cubes',	'&#xf1b3;',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(33,	'intonaco',	'fa-clone',	'&#xf24d;',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ), font_awesome = VALUES( font_awesome ), html_entity = VALUES( html_entity ), se_edificio = VALUES(se_edificio), se_immobile = VALUES( se_immobile), se_indirizzo = VALUES( se_indirizzo ) 
;

--| 050000003100

-- categorie_anagrafica
-- tipologia: tabella assistita
-- verifica: 2021-05-28 19:56 Fabio Mosti
REPLACE INTO `categorie_anagrafica` (`id`, `id_genitore`, `ordine`, `nome`, `note`, `se_lead`, `se_prospect`, `se_cliente`, `se_fornitore`, `se_produttore`, `se_collaboratore`, `se_interno`, `se_esterno`, `se_concorrente`, `se_gestita`, `se_amministrazione`, `se_produzione`, `se_commerciale`, `se_notizie`, `se_corriere`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'contatti',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'collaboratori',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	2,	NULL,	'agenti',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'fornitori',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'aziende gestite',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	'rivenditori',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	1,	NULL,	'lead',	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	1,	NULL,	'prospect',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	1,	NULL,	'clienti',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	'corrieri',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(11,	2,	NULL,	'istruttori',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000004300

-- categorie_progetti
-- tipologia: tabella gestita
-- verifica: 2021-06-02 19:40 Fabio Mosti
INSERT INTO `categorie_progetti` (`id`, `id_genitore`, `ordine`, `nome`, `se_ordinario`, `se_straordinario`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'ordinario',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'straordinario',	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| 050000004700

-- certificazioni
-- tipologia: tabella assistita
-- verifica: 2022-02-03 11:12 Chiara GDL
INSERT INTO `certificazioni` (`id`, `nome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	"carta d\'identità",	NULL,	NULL,	NULL,	NULL),
(2,	'passaporto',	NULL,	NULL,	NULL,	NULL),
(3,	'patente di guida',	NULL,	NULL,	NULL,	NULL),
(4,	'certificato medico agonistico',	NULL,	NULL,	NULL,	NULL),
(5,	'certificato medico sportivo',	NULL,	NULL,	NULL,	NULL),
(6,	'tessera sanitaria',	NULL,	NULL,	NULL,	NULL),
(7,	'certificazione energetica',	NULL,	NULL,	NULL,	NULL);

--| 050000005000

-- classi_energetiche
-- tipologia: tabella standard
-- verifica: 2022-04-28 22:22 Chiara GDL
INSERT INTO `classi_energetiche` (`id`, `nome`, `ep_min`, `ep_max`, `rgb`) VALUES
(1, 'G', NULL, NULL, 'ff2a1a'),
(2, 'F', NULL, NULL, 'c0504d'),
(3, 'E', NULL, NULL, 'e46c1c'),
(4, 'D', NULL, NULL, 'ffc02b'),
(5, 'C', NULL, NULL, 'fef934'),
(6, 'B', NULL, NULL, '99cc26'),
(7, 'A1', NULL, NULL, '00cc22'),
(8, 'A2', NULL, NULL, '009917'),
(9, 'A3', NULL, NULL, '00660c'),
(10, 'A4', NULL, NULL, '33660d')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	ep_min = VALUES( ep_min ),
	ep_max = VALUES( ep_max ),
	rgb = VALUES( rgb );

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

--| 050000006000

-- condizioni
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
INSERT INTO `condizioni` (`id`, `nome`, `se_catalogo`, `se_immobili`) VALUES
(1,	'nuovo',	1,	1),
(2,	'usato',	1,	NULL),
(3,	'da ristrutturare',	NULL,	1);

--| 050000006200

-- condizioni_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-17 16:12 Chiara GDL
REPLACE INTO `condizioni_pagamento` (`id`, `codice`, `nome`) VALUES
(1,	    'TP01',	'pagamento a rate'),
(2,	    'TP02',	'pagamento completo'),
(3,	    'TP03',	    'anticipo');

--| 050000006400

-- consensi
-- tipologia: tabella standard
-- verifica: 2022-08-23 11:12 Chiara GDL
REPLACE INTO `consensi` (`id`, `nome`, `note`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
('PRIVACY_POLICY',	'la privacy e cookie policy del sito',	NULL,	NULL,	NULL,	NULL,	NULL),
('EVASIONE_ORDINE',	"evasione dell\'ordine",	NULL,	NULL,	NULL,	NULL,	NULL),
('INVIO_COMUNICAZIONI_MARKETING',	'invio di comunicazioni commerciali',	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000006500

-- consensi_moduli
-- tipologia: tabella assistita
-- verifica: 2022-08-23 11:12 Chiara GDL
REPLACE INTO `consensi_moduli` (`id`, `id_lingua`, `id_consenso`, `modulo`, `ordine`, `azione`, `nome`, `informativa`, `note`, `pagina`, `se_richiesto`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	1,	'PRIVACY_POLICY',	'ecommerce',	10,	'letto_e_accetto',	'la privacy e cookie policy del sito',	NULL,	NULL,	'privacy',	1,	NULL,	NULL,	NULL,	NULL),
(2,	1,	'EVASIONE_ORDINE',	'ecommerce',	20,	'autorizzo',	"il trattamento dei miei dati per l\'evasione del mio ordine",	"evasione dell\'ordine",	NULL,	'',	1,	NULL,	NULL,	NULL,	NULL),
(3,	1,	'INVIO_COMUNICAZIONI_MARKETING',	'ecommerce',	30,	'autorizzo',	"il trattamento dei miei dati per l\'invio di comunicazioni commerciali",	'invio di comunicazioni commerciali',	NULL,	'',	NULL,	NULL,	NULL,	NULL,	NULL);

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

--| 050000009000

-- disponibilita
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
INSERT INTO `disponibilita` (`id`, `nome`, `se_catalogo`, `se_immobili`) VALUES
(1,	'disponibile',	1,	1),
(2,	'in riassortimento',	1,	NULL),
(3,	'nuda proprietà',	NULL,	1),
(4,	'occupato',	NULL,	1);

--| 050000010000

-- embed
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

-- iva
REPLACE INTO `iva` (`id`, `aliquota`, `nome`, `descrizione`, `codice`, `timestamp_archiviazione`) VALUES
(1,	22.00,	'IVA 22%',	'IVA 22%',	NULL,	NULL),
(2,	10.00,	'IVA agevolata 10%',	'IVA agevolata 10%',	NULL,	NULL),
(3,	4.00,	'IVA agevolata 4%',	'IVA agevolata 4%',	NULL,	NULL),
(4,	0.00,	'escluso ex art. 15 d.P.R. n. 633/1972',	'operazione esclusa ex art. 15 del d.P.R. n. 633/1972',	'N1',	NULL),
(5,	0.00,	'non soggetto ex art.7 bis d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 7 bis del d.P.R. 633/1972 (cessione di beni extra UE)',	'N2.1',	NULL),
(6,	0.00,	'non imponibile ex art. 8 c. 1 lett. a d.P.R. 633/1972',	'operazione non imponibile ex art. 8 comma 1 lettera a del d.P.R. 633/1972',	'N3.1',	NULL),
(7,	0.00,	'fuori campo IVA ex art. 2 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 2 del d.P.R. 633/1972',	'N2.2',	NULL),
(8,	0.00,	'non soggetto ex art. 1 cc. 54-89 l. 190/2014 e succ. mod.',	'operazione non soggetta a IVA ai sensi ex art. 1 legge 190/2014 commi 54-89 e successive modificazioni (regime forfettario)',	'N2.2',	NULL),
(9,	0.00,	'fuori campo IVA ex art. 3 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 3 del d.P.R. 633/1972',	'N2.2',	NULL),
(10,	0.00,	'fuori campo IVA ex art. 4 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 4 del d.P.R. 633/1972',	'N2.2',	NULL),
(11,	0.00,	'fuori campo IVA ex art. 5 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 5 del d.P.R. 633/1972',	'N2.2',	NULL),
(12,	0.00,	'non soggetto ex art.7 ter d.P.R. 633/1972 (servizi UE)',	'operazione non soggetta a IVA ex art. 7 ter del d.P.R. 633/1972 (prestazione di servizi UE)',	'N2.1',	NULL),
(13,	0.00,	'non soggetto ex art.7 ter d.P.R. 633/1972 (servizi extra UE)',	'operazione non soggetta a IVA ex art. 7 ter del d.P.R. 633/1972 (prestazione di servizi extra UE)',	'N2.1',	NULL),
(14,	0.00,	'non soggetto ex art.7 quater d.P.R. 633/1972 (servizi UE)',	'operazione non soggetta a IVA ex art. 7 quater del d.P.R. 633/1972 (prestazione di servizi UE)',	'N2.1',	NULL),
(15,	0.00,	'non soggetto ex art.7 quater d.P.R. 633/1972 (servizi extra UE)',	'operazione non soggetta a IVA ex art. 7 quater del d.P.R. 633/1972 (prestazione di servizi extra UE)',	'N2.1',	NULL),
(16,	0.00,	'non soggetto ex art.7 quinquies d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 7 quinquies del d.P.R. 633/1972 (prestazione di servizi)',	'N2.1',	NULL),
(17,	0.00,	'non soggetto ex art.7 sexies, septies d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 7 sexies, septies del d.P.R. 633/1972 (prestazione di servizi)',	'N2.1',	NULL),
(18,	0.00,	'non soggetto ex art. 38 c. 5 d.l. 331/1993',	'operazione non soggetta a IVA ex art. 38 comma 5 d.l. 331/1993',	'N2.2',	NULL),
(19,	0.00,	'non soggetto ex art. 50 bis c. 4 d.l. 331/1993',	'operazione non soggetta a IVA ex art. 50 bis comma 4 d.l. 331/1993',	'N2.2',	NULL),
(20,	0.00,	'non soggetto ex art. 17 c. 3 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 17 comma 3 del d.P.R. 633/1972',	'N2.2',	NULL),
(21,	0.00,	'non soggetto ex art. 19 c. 3 lett. b d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 19 comma 3 lettera b del d.P.R. 633/1972',	'N2.2',	NULL),
(22,	0.00,	'non soggetto ex art. 74 cc. 1 e 2 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 74 commi 1 e 2 del d.P.R. 633/1972',	'N2.2',	NULL),
(23,	0.00,	'non soggetto ex art. 19 c. 3 lett. e d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 19 comma 3 lettera e del d.P.R. 633/1972',	'N2.2',	NULL),
(24,	0.00,	'non soggetto ex art. 13 d.l. 331/1993',	'operazione non soggetta a IVA ex art. 13 d.l. 331/1993',	'N2.2',	NULL),
(25,	0.00,	'non soggetto ex art. 27 cc. 1 e 2 d.l. 98/2011 (contrib. minimi)',	'operazione non soggetta a IVA ex art. 27 commi 1 e 2 del d.l. 98/2011 (contribuenti minimi)',	'N2.2',	NULL),
(26,	0.00,	'non soggetto ex art. 26 c. 3 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 26 comma 3 del d.P.R. 633/1972',	'N2.2',	NULL),
(27,	0.00,	'non soggetto ex d.m. 9/4/1993',	'operazione non soggetta a IVA ex d.m. 9/4/1993',	'N2.2',	NULL),
(28,	0.00,	'non soggetto ex art. 26 bis l. 196/1997',	'operazione non soggetta a IVA ex art. 26 bis l. 196/1997',	'N2.2',	NULL),
(29,	0.00,	'non soggetto ex art. 8 c. 35 l. 671/1988',	'operazione non soggetta a IVA ex art. 8 comma 35 l. 671/1988',	'N2.2',	NULL),
(30,	0.00,	'non imponibile ex art. 8 c. 1 lett. b d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 8 comma 1 lettera b del d.P.R. 633/1972',	'N3.1',	NULL),
(31,	0.00,	'non imponibile ex art. 2 c. 2 n. 4 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 2 comma 2 numero 4 del d.P.R. 633/1972',	'N3.6',	NULL),
(32,	0.00,	'non imponibile ex art. 8 bis d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 8 bis del d.P.R. 633/1972',	'N3.4',	NULL),
(33,	0.00,	'non imponibile ex art. 9 c. 1 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 9 comma 1 del d.P.R. 633/1972',	'N3.6',	NULL),
(34,	0.00,	'non imponibile ex art. 72 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 72 del d.P.R. 633/1972',	'N3.6',	NULL),
(35,	0.00,	'non imponibile ex art. 71 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 71 del d.P.R. 633/1972',	'N3.6',	NULL),
(36,	0.00,	'non imponibile ex art. 8 c. 1 lett. b bis d.P.R. 633/1972',	'operazione non imponibile ex art. 8 comma 1 lettera b bis del d.P.R. 633/1972',	'N3.1',	NULL),
(37,	0.00,	'non imponibile ex art. 8 c. 1 lett. c d.P.R. 633/1972',	'operazione non imponibile ex art. 8 comma 1 lettera c del d.P.R. 633/1972',	'N3.5',	NULL),
(38,	0.00,	'non imponibile ex art. 8 bis c. 2 d.P.R. 633/1972',	'operazione non imponibile ex art. 8 bis comma 2 del d.P.R. 633/1972',	'N3.4',	NULL),
(39,	0.00,	'non imponibile ex art. 9 c. 2 d.P.R. 633/1972',	'operazione non imponibile ex art. 9 comma 2 del d.P.R. 633/1972',	'N3.1',	NULL),
(40,	0.00,	'non imponibile ex art. 72 c. 1 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 72 comma 1 del d.P.R. 633/1972',	'N3.1',	NULL),
(41,	0.00,	'non imponibile ex art. 50 bis c. 4 lett. g d.l. 331/93',	'operazione non soggetta a IVA ex art. 50 comma 4 lettera g del d.l. 331/93',	'N3.1',	NULL),
(42,	0.00,	'non imponibile ex art. 50 bis c. 4 lett. f d.l. 331/93',	'operazione non soggetta a IVA ex art. 50 comma 4 lettera f del d.l. 331/93',	'N3.2',	NULL),
(43,	0.00,	'non imponibile ex art. 41 d.l. 331/93',	'operazione non soggetta a IVA ex art. 41 del d.l. 331/93',	'N3.2',	NULL),
(44,	0.00,	'non imponibile ex art. 58 c. 1 d.l. 331/93',	'operazione non soggetta a IVA ex art. 58 comma 1 del d.l. 331/93',	'N3.2',	NULL),
(45,	0.00,	'non imponibile ex art. 38 quater c. 1 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 38 quater comma 1 del d.P.R. 633/1972',	'N3.6',	NULL),
(46,	0.00,	'non imponibile ex art. 14 l. 49/1987',	'operazione non soggetta a IVA ex art. 14 l. 49/1987',	'N3.1',	NULL),
(47,	0.00,	'esente ex art. 10 d.P.R. 633/1972',	'operazione esente IVA ex art. 10 del d.P.R. 633/1972',	'N4',	NULL),
(48,	0.00,	'esente ex art. 19 c. 3 lett. a bis d.P.R. 633/1972',	'operazione esente IVA ex art. 19 comma 3 lettera a bis del d.P.R. 633/1972',	'N4',	NULL),
(49,	0.00,	'esente ex art. 10 n. 27 quinquies d.P.R. 633/1972',	'operazione esente IVA ex art. 10 num. 27 quinquies del d.P.R. 633/1972',	'N4',	NULL),
(50,	0.00,	'esente ex art. 10 n. 18 d.P.R. 633/1972',	'operazione esente IVA ex art. 10 num. 18 del d.P.R. 633/1972',	'N4',	NULL),
(51,	0.00,	'esente ex art. 10 n. 19 d.P.R. 633/1972',	'operazione esente IVA ex art. 10 num. 19 del d.P.R. 633/1972',	'N4',	NULL),
(52,	0.00,	'regime ex art. 36 d.l. 41/1995',	'operazione soggetta a regime del margine IVA non esposta in fattura ex art. 36 d.l. 41/1995',	'N5',	NULL),
(53,	0.00,	'regime ex art. 36 c. 1 d.l. 41/1995',	'operazione soggetta a regime del margine IVA non esposta in fattura ex art. 36 comma 1 d.l. 41/1995',	'N5',	NULL),
(54,	0.00,	'regime ex art. 36 c. 5 d.l. 41/1995',	'operazione soggetta a regime del margine IVA non esposta in fattura ex art. 36 comma 5 d.l. 41/1995',	'N5',	NULL),
(55,	0.00,	'regime ex art. 36 c. 6 d.l. 41/1995',	'operazione soggetta a regime del margine IVA non esposta in fattura ex art. 36 comma 6 d.l. 41/1995',	'N5',	NULL),
(56,	0.00,	'regime ex art. 74 ter d.P.R. 633/1972 (ag. di viaggio)',	'operazione soggetta a regime del margine IVA non esposta in fattura ex art. 74 ter del d.P.R. 633/1972 (regime speciale agenzie di viaggio)',	'N5',	NULL),
(57,	0.00,	'regime ex art. 17 c. 6 d.P.R. 633/1972 (rev. charge)',	'operazione soggetta a inversione contabile (reverse charge) ex art. 17 comma 6 del d.P.R. 633/1972',	'N6',	NULL),
(58,	0.00,	'regime ex art. 17 cc. 7 e 8 d.P.R. 633/1972 (rev. charge)',	'operazione soggetta a inversione contabile (reverse charge) ex art. 17 commi 7 e 8 del d.P.R. 633/1972',	'N6',	NULL);

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

--| 010000022000

-- tipologie_notizie
INSERT INTO `tipologie_notizie` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'notizia',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

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
(60,	11,	'Grosseto',	                        'GR',	'053'),
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
REPLACE INTO `ranking` (`id`, `nome`, `note`, `ordine`, `se_cliente`, `se_fornitore`, `se_progetti`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	'PLATINUM',	NULL,	100,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	'GOLD',	NULL,	200,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	'SILVER',	NULL,	300,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	'BRONZE',	NULL,	400,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL);

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
(1,	1,	NULL,	'VENDITA IVA 22%',	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	9,	NULL,	'LOCAZIONE IVA 0%',	'fuori campo IVA ex art. 3 d.P.R. 633/1972',	NULL,	NULL,	NULL,	NULL);

--| 050000034000

-- ruoli_anagrafica
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:11 Fabio Mosti
INSERT INTO `ruoli_anagrafica` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_produzione`, `se_didattica`, `se_organizzazioni`, `se_relazioni`, `se_risorse`, `se_progetti`, `se_immobili`, `se_contratti`) VALUES
(1,	NULL,	'titolare',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	'amministratore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'socio',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'dipendente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'direttore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	'presidente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	'tesoriere',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	'coordinatore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL),
(9,	NULL,	'vicepresidente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	'vicedirettore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	'segretario',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	'responsabile amministrativo',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	'responsabile acquisti',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	'responsabile operativo',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	'operatore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(16,	NULL,	'responsabile',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL),
(17,	NULL,	'assistente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL),
(18,	NULL,	'autore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(19,	NULL,	'genitore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(20,	NULL,	'fratello',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(21,	NULL,	'tutore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(22,	NULL,	'coniuge',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(23,	NULL,	'collega',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(24,	NULL,	'docente',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(25,	NULL,	'istruttore',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(26,	NULL,	'proprietario',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(27,	NULL,	'locatore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(28,	NULL,	'conduttore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(29,	NULL,	'iscritto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(30,	NULL,	'istituto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL)
ON DUPLICATE KEY UPDATE
	id_genitore = VALUES( id_genitore ),
	nome = VALUES(nome),
	html_entity = VALUES(html_entity),
	font_awesome = VALUES(font_awesome),
	se_organizzazioni = VALUES(se_organizzazioni),
	se_relazioni = VALUES(se_relazioni),
	se_risorse = VALUES(se_risorse),
	se_progetti = VALUES(se_progetti),
	se_didattica = VALUES(se_didattica),
	se_immobili = VALUES(se_immobili),
	se_contratti = VALUES(se_contratti);

--| 050000034200

-- ruoli_audio
-- tipologia: tabella standard
-- verifica: 2021-10-09 18:28 Fabio Mosti
INSERT INTO `ruoli_audio` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_immobili`) VALUES
(1,	NULL,	'audio',	NULL,	NULL,	1,	1,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	1),
(2,	NULL,	'commento',	NULL,	NULL,	NULL,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

--| 050000034300

-- ruoli_documenti
-- tipologia: tabella di supporto
-- verifica: 2022-06-09 16:21 Chiara GDL
REPLACE INTO `ruoli_documenti` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_xml`, `se_documenti`, `se_documenti_articoli`, `se_conferma`, `se_consuntivo`, `se_evasione`) VALUES
(1,	NULL,	'conferma',	NULL,	NULL,	NULL,	1,	1,	1,	NULL,	NULL),
(2,	NULL,	'consuntivo',	NULL,	NULL,	NULL,	1,	1,	NULL,	1,	NULL),
(3,	NULL,	'evasione',	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	1);

--| 050000034400

-- ruoli_file
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:14 Fabio Mosti
REPLACE INTO `ruoli_file` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_template`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_mail`, `se_immobili`, `se_documenti`) VALUES
(1,	NULL,	'allegato',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1),
(2,	NULL,	'brochure',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'documentazione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(4,	NULL,	'driver',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'manualistica',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(6,	NULL,	'press kit',	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	'schede tecniche',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	'software',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	'contratto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(10,	NULL,	'utenze',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(11,	NULL,	'condominio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(12,	NULL,	'scansione',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

--| 050000034600

-- ruoli_immagini
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:47 Fabio Mosti
INSERT INTO `ruoli_immagini` (`id`, `id_genitore`, `ordine_scalamento`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_immobili`) VALUES
(1,		NULL,	900,	'immagine',		NULL,	NULL,	1,		1,		1,		1,		1,		1,		1,		1,		1,		1),
(2,		NULL,	600,	'gallery',		NULL,	NULL,	1,		1,		1,		1,		1,		1,		1,		1,		1,		1),
(3,		NULL,	200,	'carousel',		NULL,	NULL,	1,		1,		1,		1,		1,		1,		1,		1,		1,		NULL),
(4,		NULL,	200,	'card',			NULL,	NULL,	1,		1,		1,		1,		1,		1,		1,		1,		1,		NULL),
(5,		NULL,	200,	'copertina',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,		1,		1,		1,		NULL),
(6,		NULL,	600,	'jumbotron',	NULL,	NULL,	NULL,	1,		1,		1,		1,		1,		1,		1,		1,		NULL),
(7,		NULL,	300,	'intestazione',	NULL,	NULL,	NULL,	1,		1,		1,		1,		1,		1,		1,		1,		NULL),
(8,		NULL,	900,	'sfondo',		NULL,	NULL,	NULL,	1,		1,		1,		1,		1,		1,		1,		1,		NULL),
(9,		NULL,	200,	'dettaglio',	NULL,	NULL,	NULL,	NULL,	1,		1,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	100,	'avatar',		NULL,	NULL,	1,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	300,	'logo',			NULL,	NULL,	1,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	NULL,	'contratto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(13,	NULL,	NULL,	'utenze',		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(14,	NULL,	NULL,	'condominio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(15,	NULL,	NULL,	'anteprima',	NULL,	NULL,	NULL,	NULL,	1,		1,		1,		NULL,	NULL,	NULL,	NULL,	NULL),
(16,	NULL,	NULL,	'applicazioni',	NULL,	NULL,	NULL,	NULL,	1,		1,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

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

--| 050000034850

-- ruoli_mail
-- tipologia: tabella standard
INSERT INTO `ruoli_mail` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_xml`, `se_commerciale`, `se_produzione`, `se_amministrazione`, `se_acquisti`, `se_ordini`, `se_helpdesk`) VALUES
(1,	NULL,	'generica',	NULL,	NULL,	NULL,	1,	1,	1,	1,	1,	1),
(2,	NULL,	'commerciale',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'produzione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'amministrazione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(5,	NULL,	'acquisti',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(6,	NULL,	'ordini',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(7,	NULL,	'helpdesk',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

--| 050000034900

-- ruoli_matricole
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:45 Fabio Mosti
REPLACE INTO `ruoli_matricole` (`id`, `nome`, `html_entity`, `font_awesome`) VALUES
(1,	'attrezzatura',	    '',	    ''),
(2,	'prodotto',	    '',	    '');

--| 050000035000

-- ruoli_prodotti
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:46 Fabio Mosti
REPLACE INTO `ruoli_prodotti` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`) VALUES
(1,	    NULL,	'prodotto',	    NULL,	NULL),
(2,	    NULL,	'principale',	NULL,	NULL),
(3,	    NULL,	'suggerito',	NULL,	NULL);

--| 050000035100

-- ruoli_progetti
-- tipologia: tabella di supporto
-- verifica: 2022-04-20 10:45 chiara GDL
INSERT INTO `ruoli_progetti` (`id`, `nome`, `html_entity`, `font_awesome`, `se_sottoprogetto`, `se_proseguimento`, `se_sostituto`, `se_attesa`) VALUES
(1,	'proseguimento',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(2,	'bundle',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(3,	'attesa',	NULL,	NULL,	NULL,	NULL,	NULL,	1);


--| 050000035200

-- ruoli_video
-- tipologia: tabella standard
-- verifica: 2021-10-11 18:47 Fabio Mosti
REPLACE INTO `ruoli_video` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_immobili`) VALUES
(1,	NULL,	'video',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1),
(2,	NULL,	'gallery',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1),
(3,	NULL,	'carousel',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(4,	NULL,	'card',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(5,	NULL,	'copertina',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	1,	1,	NULL),
(6,	NULL,	'jumbotron',	NULL,	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(7,	NULL,	'intestazione',	NULL,	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(8,	NULL,	'sfondo',	NULL,	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(9,	NULL,	'dettaglio',	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(10,	NULL,	'lezione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(11,	NULL,	'episodio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(12,	NULL,	'condominio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(13,	NULL,	'utenze',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1);
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
(1,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_images.resize.php',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_mail.queue.send.php',	20,	2,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_sms.queue.send.php',	3,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_indirizzi.geocode.php',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,		6,		2,		6,		2,		NULL,	NULL,	'_src/_api/_task/_comuni.importazione.start.php',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,		6,		6,		6,		6,		NULL,	NULL,	'_src/_api/_task/_settori.importazione.start.php',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,		6,		5,		NULL,	NULL,	NULL,	NULL,	'_mod/_0400.documenti/_src/_api/_task/_download.fe.passive.start.php',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,		7,		5,		NULL,	NULL,	NULL,	NULL,	'_mod/_0400.documenti/_src/_api/_task/_download.note.attive.start.php',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_mod/_7000.mailing/_src/_api/_task/_genera.mail.php',	20,	2,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_mod/_0200.attivita/_src/_api/_task/_autotask.php',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_mod/_0100.pianificazioni/_src/_api/_task/_pianificazioni.populate.php',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000050000

-- tipologie_anagrafica
-- tipologia: tabella standard
-- verifica: 2021-10-15 16:15 Fabio Mosti
REPLACE INTO `tipologie_anagrafica` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_persona_fisica`, `se_persona_giuridica`, `se_pubblica_amministrazione`, `se_ecommerce`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	10,	'persone fisiche',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	20,	'persone giuridiche',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	7,	10,	'sig.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	8,	20,	'sig.ra',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	2,	10,	'spett.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	20,	'pubblica amministrazione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	1,	NULL,	'gent.mo',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	1,	NULL,	'gent.ma',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000050400

-- tipologie_attivita
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
REPLACE INTO `tipologie_attivita` (`id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_agenda`, `se_sistema`, `se_cartellini`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	NULL,	'lavoro',	NULL,	NULL,	1,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	NULL,	'ferie',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	NULL,	'permessi',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	NULL,	'malattie',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	NULL,	'SDI',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	5,	NULL,	'RC',	'ricevuta di consegna',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	5,	NULL,	'MC',	'mancata consegna',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	5,	NULL,	'NS',	'notifica di scarto',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	5,	NULL,	'AT',	'presa in carico con impossibilità di recapito',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	5,	NULL,	'DT',	'decorrenza termini',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	5,	NULL,	'EC',	'esito committente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	5,	NULL,	'NE',	'notifica di esito',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	5,	NULL,	'MT',	'notifica di metadati per fattura passiva',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	1,	NULL,	NULL,	'produzione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(15,	18,	NULL,	NULL,	'frequenza',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(16,	1,	NULL,	NULL,	'commerciale',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(17,	1,	NULL,	NULL,	'amministrazione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(18,	NULL,	NULL,	NULL,	'didattica',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(19,	18,	NULL,	NULL,	'assenza',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(20,	17,	NULL,	NULL,	'carico ore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(21,	17,	NULL,	NULL,	'promemoria scadenze',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000050450

-- tipologie_badge
-- TODO

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

--| 050000050900

-- tipologie_contratti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT INTO `tipologie_contratti` (`id`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_tesseramento`, `se_abbonamento`, `se_iscrizione`, `se_affiliazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	'vendita',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	'locazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'tesseramento',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'abbonamento',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'iscrizione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	'affiliazione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	'servizi',		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000052600

-- tipologie_documenti
-- tipologia: tabella di supporto
-- verifica: 2021-12-07 17:00 Chiara GDL
REPLACE INTO `tipologie_documenti` (`id`, `id_genitore`, `ordine`, `codice`, `numerazione`, `nome`, `sigla`, `html_entity`, `font_awesome`, `se_fattura`, `se_nota_credito`, `se_nota_debito`, `se_trasporto`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_ricevuta`, `se_ecommerce`, `stampa_xml`, `stampa_pdf`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'TD01',	'F',	'fattura',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	1,	NULL,	'TD01',	'F',	'fattura accompagnatoria',	'fatt. acc.',	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'TD04',	'F',	'nota di credito',	'n. di credito',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	NULL,	'T',	'documento di trasporto',	'DDT',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	NULL,	'P',	'pro forma',	'profroma',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	NULL,	'O',	'offerta',	'off.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	NULL,	NULL,	'E',	'ordine',	'ord.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	NULL,	NULL,	'R',	'ricevuta',	'ric.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	NULL,	NULL,	'S',	'scontrino',	'scontr.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	NULL,	'G',	'documento di ritiro',	'doc. di ritiro',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	NULL,	NULL,	'H',	'documento di consegna',	'doc. di consegna',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	NULL,	NULL,	'I',	'documento di reso',	'doc. di reso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	NULL,	'TD02',	'F',	'acconto/anticipo su fattura',	'acc.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	NULL,	'TD03',	'F',	'acconto/anticipo su parcella',	'acc.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	NULL,	'TD05',	'F',	'nota di debito',	'n. di debito',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(16,	NULL,	NULL,	'TD06',	'F',	'parcella',	'parcella',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(17,	1,	NULL,	'TD16',	'F',	'integrazione fattura reverse charge interno',	'integr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(18,	1,	NULL,	'TD17',	'F',	'integrazione autofattura acquisto servizi dall\'estero',	'integr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(19,	1,	NULL,	'TD18',	'F',	'integrazione per acquisto beni intracomunitari',	'integr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(20,	1,	NULL,	'TD19',	'F',	'integrazione/autofattura per acquisto beni',	'integr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(21,	1,	NULL,	'TD20',	'F',	'autofattura per regolarizzazione e integrazione fatture',	'autofatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(22,	1,	NULL,	'TD21',	'F',	'autofattura per splafonamento',	'autofatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(23,	1,	NULL,	'TD22',	'F',	'estrazione beni da deposito IVA',	'estr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(24,	1,	NULL,	'TD23',	'F',	'estrazione beni da deposito IVA con versamento dell\'IVA',	'estr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(25,	1,	NULL,	'TD24',	'F',	'fattura differita ex art. 21 c. 4 terzo per. lett. a d.P.R. 633/1972',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(26,	1,	NULL,	'TD25',	'F',	'fattura differita ex art. 21 c. 4 terzo per. lett. b d.P.R. 633/1972',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(27,	1,	NULL,	'TD26',	'F',	'cessione beni ammortizzabili e per passaggi interni',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(28,	1,	NULL,	'TD27',	'F',	'fattura per autoconsumo o cessioni gratuite senza rivalsa',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000052800

-- tipologie_edifici
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
INSERT INTO `tipologie_edifici` (`id`, `id_genitore`, `nome`) VALUES
(1, NULL, 'palazzo'),
(2, NULL, 'palazzo storico'),
(3, NULL, 'palazzina'),
(4, NULL, 'complesso'),
(5, NULL, 'residence'),
(6, NULL, 'edificio indipendente');

--| 050000052900

-- tipologie_immobili
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
INSERT INTO `tipologie_immobili` (`id`, `nome`, `se_residenziale`, `se_industriale`) VALUES
(1, 'appartamento', 1, NULL),
(3, 'abitazione', 1, NULL),
(6, 'garage', 1, NULL),
(7, 'magazzino', 1, 1),
(8, 'ufficio', NULL, 1),
(9, 'negozio', NULL, 1);

--| 050000053000

-- tipologie_indirizzi
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT INTO `tipologie_indirizzi` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'calle',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'campiello',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'campo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'carraia',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'carrarone',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	'chiasso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	NULL,	'circondario',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	NULL,	'circonvallazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	NULL,	'contrà',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	'contrada',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	NULL,	'corso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	NULL,	'diga',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	NULL,	'discesa',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	NULL,	'frazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	NULL,	'giardino',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(16,	NULL,	NULL,	'largo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(17,	NULL,	NULL,	'località',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(18,	NULL,	NULL,	'lungoargine',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(19,	NULL,	NULL,	'lungolago',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(20,	NULL,	NULL,	'lungomare',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(21,	NULL,	NULL,	'maso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(22,	NULL,	NULL,	'parallela',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(23,	NULL,	NULL,	'passeggiata',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(24,	NULL,	NULL,	'piazza',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(25,	NULL,	NULL,	'piazzale',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(26,	NULL,	NULL,	'piazzetta',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(27,	NULL,	NULL,	'rotonda',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(28,	NULL,	NULL,	'salita',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(29,	NULL,	NULL,	'strada',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(30,	NULL,	NULL,	'stradella',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(31,	NULL,	NULL,	'stradello',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(32,	NULL,	NULL,	'traversa',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(33,	NULL,	NULL,	'via',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(34,	NULL,	NULL,	'viale',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(35,	NULL,	NULL,	'vico',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(36,	NULL,	NULL,	'vicoletto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(37,	NULL,	NULL,	'vicolo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(38,	NULL,	NULL,	'vietta',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(39,	NULL,	NULL,	'viottolo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(40,	NULL,	NULL,	'viuzza',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(41,	NULL,	NULL,	'viuzzo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000053300

-- tipologie_luoghi
-- tipologia: tabella gestita
-- verifica: 2022-02-21 15:30 Chiara GDL
INSERT INTO `tipologie_luoghi` (`id`, `nome`) VALUES
(1, 'teatro'),
(2, 'palestra'),
(3, 'piscina'),
(4, 'sala'),
(5, 'aula'),
(6, 'online');

--| 050000053400

-- tipologie_mastri
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT INTO `tipologie_mastri` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_magazzino`, `se_conto`, `se_registro`, `se_credito`,`id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'magazzino',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'conto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'registro ore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'crediti',	NULL,	NULL,	NULL,	NULL,	NULL,	1, NULL,	NULL,	NULL,	NULL);

--| 050000053800

-- tipologie_notizie
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti

--| 050000054100

-- tipologie_periodi
-- tipologia: tabella gestita
-- verifica: 2022-05-24 11:00 Chiara GDL
REPLACE INTO `tipologie_periodi` (`id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	NULL,	'feste',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	NULL,	'ferie',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	NULL,	'lavoro',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000054200

-- tipologie_popup
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti

--| 050000054600

-- tipologie_prodotti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT INTO `tipologie_prodotti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_colori`, `se_taglie`, `se_dimensioni`, `se_volume`, `se_capacita`, `se_massa`, `se_imballo`, `se_spedizione`, `se_trasporto`, `se_prodotto`, `se_servizio`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'prodotto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'servizio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	2,	NULL,	NULL,	NULL,	NULL),
(3,	1,	NULL,	'alimentare (peso)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	1,	NULL,	'alimentare (volume)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	1,	NULL,	'alimentare (pezzo)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000055000

-- tipologie_progetti
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT INTO `tipologie_progetti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_produzione`, `se_contratto`, `se_pacchetto`, `se_progetto`, `se_consuntivo`, `se_forfait`, `se_didattica`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'contratto',	'',	'',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'pacchetto',	'',	'',	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'progetto',	'',	'',	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'consuntivo',	'',	'',	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'forfait',	'',	'',	1,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	'corso',	'',	'',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| 050000055400

-- tipologie_pubblicazioni
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT IGNORE INTO `tipologie_pubblicazioni` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_bozza`, `se_pubblicato`, `se_evidenza`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'bozza',	    NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'pubblicato',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'in evidenza',	    NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| 050000055700

-- tipologie_rinnovi
-- tipologia: tabella di supporto
-- verifica: 2022-04-29 17:45 Chiara GDL
INSERT IGNORE INTO `tipologie_rinnovi` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_tesseramenti`, `se_iscrizioni`, `se_abbonamenti`, `se_licenze`, `se_contratti`, `se_progetti`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'ordinario',		NULL,	NULL,	1,	1,	1,	1,		1,		1,		NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'straordinario',	NULL,	NULL,	1,	1,	1,	1,		1,		1,		NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'ridotto',			NULL,	NULL,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000055800

-- tipologie_risorse
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT INTO `tipologie_risorse` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'corso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

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
REPLACE INTO `tipologie_todo` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_agenda`, `se_ticket`, `se_commerciale`, `se_produzione`, `se_amministrazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'produzione',	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'commerciale',	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'amministrazione',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(4,	1,	NULL,	'sviluppo',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	1,	NULL,	'assistenza',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	1,	NULL,	'formazione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	1,	NULL,	'consulenza',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	1,	NULL,	'fornitura',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	1,	NULL,	'ticket',	NULL,	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	2,	NULL,	'ricerca clienti',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	2,	NULL,	'customer care',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	2,	NULL,	'preventivazione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

--| 050000056800

-- tipologie_url
-- tipologia: tabella assistita
-- verifica: 2021-11-09 12:45 Chiara GDL

--| 050000062000

-- udm
-- tipologia: tabella standard
-- verifica: 2021-10-19 13:02 Fabio Mosti
REPLACE INTO `udm` (`id`, `id_base`, `conversione`, `nome`, `sigla`, `note`, `se_lunghezza`, `se_volume`, `se_massa`, `se_tempo`, `se_quantita`, `se_area`) VALUES
(1,	NULL,	NULL,	'pezzi',	'pz.',	'unità di misura usata genericamente per misurare le quantità',	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(2,	NULL,	1,	'millimetro',	'mm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	2,	10,	'centimetro',	'cm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	2,	100,	'decimetro',	'dm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	2,	1000,	'metro',	'm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	2,	10000,	'decametro',	'dam',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	2,	100000,	'ettometro',	'hm',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	2,	1000000,	'kilometro',	'km',	'https://it.wikipedia.org/wiki/Metro',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	1,	'milligrammo',	'mg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(10,	9,	10,	'centigrammo',	'cg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(11,	9,	100,	'decigrammo',	'dg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(12,	9,	1000,	'grammo',	'gr',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(13,	9,	10000,	'decagrammo',	'dag',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(14,	9,	100000,	'ettogrammo',	'hg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(15,	9,	1000000,	'kilogrammo',	'kg',	'https://it.wikipedia.org/wiki/Chilogrammo',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(16,	NULL,	1,	'millilitro',	'ml',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(17,	16,	10,	'centilitro',	'cl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(18,	16,	100,	'decilitro',	'dl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(19,	16,	1000,	'litro',	'l',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(20,	16,	10000,	'decalitro',	'dal',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(21,	16,	100000,	'ettolitro',	'hl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(22,	16,	1000000,	'kilolitro',	'kl',	'https://it.wikipedia.org/wiki/Litro',	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(23,	NULL,	1,	'secondo',	's',	'https://it.wikipedia.org/wiki/Secondo',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(24,	23,	60,	'minuto',	'min',	'https://it.wikipedia.org/wiki/Minuto',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(25,	23,	3600,	'ora',	'h',	'https://it.wikipedia.org/wiki/Ora',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(26,	23,	86400,	'giorno',	'd',	'https://it.wikipedia.org/wiki/Giorno',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(27,	9,	100000000,	'quintale',	'q',	'https://it.wikipedia.org/wiki/Quintale',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(28,	9,	1000000000,	'tonnellata',	't',	'https://it.wikipedia.org/wiki/Tonnellata',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(29,	NULL,	1,	'millimetro quadrato',	'mm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(30,	29,	100,	'centimetro quadrato',	'cm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(31,	29,	10000,	'decimetro quadrato',	'dm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(32,	29,	1000000,	'metro quadrato',	'm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(33,	29,	100000000,	'decametro quadrato',	'dam²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(34,	29,	10000000000,	'ettometro quadrato',	'hm²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(35,	29,	1000000000000,	'kilometro quadrato',	'km²',	'https://it.wikipedia.org/wiki/Metro_quadrato',	1,	NULL,	NULL,	NULL,	NULL,	1),
(36,	29,	1000000,	'centiara',	'ca',	'https://it.wikipedia.org/wiki/Centiara',	1,	NULL,	NULL,	NULL,	NULL,	1),
(37,	29,	100000000,	'ara',	'a',	'https://it.wikipedia.org/wiki/Ara_(unità_di_misura)',	1,	NULL,	NULL,	NULL,	NULL,	1),
(38,	29,	10000000000,	'ettaro',	'ha',	'https://it.wikipedia.org/wiki/Ettaro',	1,	NULL,	NULL,	NULL,	NULL,	1);

--| 050000063000

-- valute
-- tipologia: tabella standard
-- verifica: 2021-10-19 13:21 Fabio Mosti
REPLACE INTO `valute` (`id`, `iso4217`, `html_entity`, `utf8`) VALUES
(1,	'EUR',	'&#8634;',	'€');

--| FINE FILE
