--
-- DATI
-- ====
-- questo file contiene le query per l'inserimento dei dati standard nelle tabelle
-- 
-- TODO documentare
--

-- | 050000002900

-- caratteristiche
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `caratteristiche` (`id`, `nome`, `font_awesome`, `html_entity`, `se_prodotti`, `se_articoli`, `se_immobili`, `se_categorie_prodotti`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	'peso indicativo',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	'standard tecnici',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	'unità di vendita',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	'normativa FSC',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000003080

-- casse_previdenziali
-- i codici TipoCassa delle specifiche tecniche 1.9 della fattura elettronica, con le descrizioni della rappresentazione tabellare
INSERT IGNORE INTO `casse_previdenziali` (`id`, `codice`, `nome`) VALUES
(1,		'TC01',		'Cassa nazionale previdenza e assistenza avvocati e procuratori legali'),
(2,		'TC02',		'Cassa previdenza dottori commercialisti'),
(3,		'TC03',		'Cassa previdenza e assistenza geometri'),
(4,		'TC04',		'Cassa nazionale previdenza e assistenza ingegneri e architetti liberi professionisti'),
(5,		'TC05',		'Cassa nazionale del notariato'),
(6,		'TC06',		'Cassa nazionale previdenza e assistenza ragionieri e periti commerciali'),
(7,		'TC07',		'Ente nazionale assistenza agenti e rappresentanti di commercio (ENASARCO)'),
(8,		'TC08',		'Ente nazionale previdenza e assistenza consulenti del lavoro (ENPACL)'),
(9,		'TC09',		'Ente nazionale previdenza e assistenza medici (ENPAM)'),
(10,	'TC10',		'Ente nazionale previdenza e assistenza farmacisti (ENPAF)'),
(11,	'TC11',		'Ente nazionale previdenza e assistenza veterinari (ENPAV)'),
(12,	'TC12',		'Ente nazionale previdenza e assistenza impiegati dell\'agricoltura (ENPAIA)'),
(13,	'TC13',		'Fondo previdenza impiegati imprese di spedizione e agenzie marittime'),
(14,	'TC14',		'Istituto nazionale previdenza giornalisti italiani (INPGI)'),
(15,	'TC15',		'Opera nazionale assistenza orfani sanitari italiani (ONAOSI)'),
(16,	'TC16',		'Cassa autonoma assistenza integrativa giornalisti italiani (CASAGIT)'),
(17,	'TC17',		'Ente previdenza periti industriali e periti industriali laureati (EPPI)'),
(18,	'TC18',		'Ente previdenza e assistenza pluricategoriale (EPAP)'),
(19,	'TC19',		'Ente nazionale previdenza e assistenza biologi (ENPAB)'),
(20,	'TC20',		'Ente nazionale previdenza e assistenza professione infermieristica (ENPAPI)'),
(21,	'TC21',		'Ente nazionale previdenza e assistenza psicologi (ENPAP)'),
(22,	'TC22',		'INPS');

-- | 050000003100

-- categorie_anagrafica
INSERT IGNORE INTO `categorie_anagrafica` (`id`, `id_genitore`, `ordine`, `codice`, `nome`, `note`, `se_lead`, `se_prospect`, `se_cliente`, `se_fornitore`, `se_produttore`, `se_collaboratore`, `se_interno`, `se_esterno`, `se_concorrente`, `se_gestita`, `se_amministrazione`, `se_produzione`, `se_commerciale`, `se_notizie`, `se_corriere`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	NULL,	'contatti',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	NULL,	'collaboratori',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	2,	NULL,	NULL,	'agenti',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	1760456720),
(4,	NULL,	NULL,	NULL,	'fornitori',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	NULL,	'aziende gestite',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1760456633),
(6,	NULL,	NULL,	NULL,	'rivenditori',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	1,	NULL,	NULL,	'lead',	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	1,	NULL,	NULL,	'prospect',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	1,	NULL,	NULL,	'clienti',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	NULL,	'corrieri',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(11,	2,	NULL,	NULL,	'istruttori',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	NULL,	NULL,	'produttori',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000004300

-- categorie_progetti
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `categorie_progetti` (`id`, `id_genitore`, `ordine`, `nome`, `se_ordinario`, `se_straordinario`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'ordinario',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'straordinario',	NULL,	1,	NULL,	NULL,	NULL,	NULL);

-- | 050000004700

-- certificazioni
-- tipologia: tabella assistita
-- verifica: 2022-02-03 11:12 Chiara GDL
INSERT IGNORE INTO `certificazioni` (`id`, `nome`, `se_identificazione`, `se_medico`, `se_sportivo`, `se_agonistico`, `se_immobili`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	'carta di identità',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	'passaporto',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	'patente di guida',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	'certificato medico agonistico',	NULL,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	'certificato medico sportivo',	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	'tessera sanitaria',	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	'certificazione energetica',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

-- | 050000005000

-- classi_energetiche
-- tipologia: tabella standard
-- verifica: 2022-04-28 22:22 Chiara GDL
INSERT IGNORE INTO `classi_energetiche` (`id`, `nome`, `ep_min`, `ep_max`, `rgb`) VALUES
(1, 'G', NULL, NULL, 'ff2a1a'),
(2, 'F', NULL, NULL, 'c0504d'),
(3, 'E', NULL, NULL, 'e46c1c'),
(4, 'D', NULL, NULL, 'ffc02b'),
(5, 'C', NULL, NULL, 'fef934'),
(6, 'B', NULL, NULL, '99cc26'),
(7, 'A1', NULL, NULL, '00cc22'),
(8, 'A2', NULL, NULL, '009917'),
(9, 'A3', NULL, NULL, '00660c'),
(10, 'A4', NULL, NULL, '33660d');

-- | 050000005100

-- colori
-- tipologia: tabella standard
-- verifica: 2021-06-02 22:27 Fabio Mosti
INSERT INTO `colori` (`id`, `id_genitore`, `nome`, `hex`, `r`, `g`, `b`, `ral`, `pantone`, `c`, `m`, `y`, `k`, `css`) VALUES
(1,	NULL,	'rosso',	'ff0000',	255,	0,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'bianco',	'ffffff',	255,	255,	255,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'nero',	'000000',	0,	0,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'blu',	'0000ff',	0,	0,	255,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	'verde',	'00ff00',	0,	255,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	'traffic white',	'edede6',	237,	237,	230,	'9016',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	'signal red',	'9a2926',	154,	41,	38,	'3001',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	'luminous yellow',	'ffff00',	255,	255,	0,	'1026',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	'carbon look',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'background-color: rgb(32, 32, 32); background-image: linear-gradient( 45deg, black 25%, transparent 25%, transparent 75%, black 75%, black), linear-gradient(45deg, black 25%, transparent 25%, transparent 75%, black 75%, black), linear-gradient(to bottom, rgb(8, 8, 8), rgb(32, 32, 32) ); background-size: 10px 10px, 10px 10px, 10px 5px; background-position: 0px 0px, 5px 5px, 0px 0px;');

-- | 050000006000

-- condizioni_pagamento
-- tipologia: tabella standard
-- verifica: 2022-01-17 16:12 Chiara GDL
INSERT IGNORE INTO `condizioni_pagamento` (`id`, `codice`, `nome`) VALUES
(1,	    'TP01',	'pagamento a rate'),
(2,	    'TP02',	'pagamento completo'),
(3,	    'TP03',	    'anticipo');

-- | 050000006050

-- condizioni
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
INSERT IGNORE INTO `condizioni` (`id`, `nome`, `se_catalogo`, `se_immobili`) VALUES
(1,	'nuovo',	1,	1),
(2,	'usato',	1,	NULL),
(3,	'da ristrutturare',	NULL,	1);

-- | 050000006200

-- consensi
INSERT IGNORE INTO `consensi` (`id`, `codice`, `nome`, `note`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,   'PRIVACY_POLICY',                  'la privacy e cookie policy del sito',      NULL,   NULL,   NULL,   NULL,   NULL),
(2,   'EVASIONE_ORDINE',                 "evasione dell\'ordine",                    NULL,   NULL,   NULL,   NULL,   NULL),
(3,   'INVIO_COMUNICAZIONI_MARKETING',   'invio di comunicazioni commerciali',       NULL,   NULL,   NULL,   NULL,   NULL);

-- | 050000006500

-- consensi_moduli
INSERT IGNORE INTO `consensi_moduli` (`id`, `id_lingua`, `id_consenso`, `modulo`, `ordine`, `azione`, `nome`, `informativa`, `note`, `pagina`, `se_richiesto`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1, 1,    1,                                'ecommerce',    10,    'letto_e_accetto',  'la privacy e cookie policy del sito',                                       NULL,                                   NULL,    'privacy', 1,      NULL,   NULL,   NULL,   NULL),
(2, 1,    2,                                'ecommerce',    20,    'autorizzo',        "il trattamento dei miei dati per l\'evasione del mio ordine",               "evasione dell\'ordine",                NULL,    '',        1,      NULL,   NULL,   NULL,   NULL),
(3, 1,    3,                                'ecommerce',    30,    'autorizzo',        "il trattamento dei miei dati per l\'invio di comunicazioni commerciali",    'invio di comunicazioni commerciali',   NULL,    '',        NULL,   NULL,   NULL,   NULL,   NULL);

-- | 050000007100

-- continenti
INSERT IGNORE INTO `continenti` (`id`, `codice`, `nome`) VALUES
(1,	'EU',	'Europa'),
(2,	'AF',	'Africa'),
(3,	'AS',	'Asia'),
(4,	'NA',	'Nord America'),
(5,	'AU',	'Oceania'),
(6,	'LA',	'America Latina'),
(7,	'AN',	'Antartide');

-- | 050000009000

-- disponibilita
-- tipologia: tabella standard
-- verifica: 2022-04-28 16:12 Chiara GDL
INSERT IGNORE INTO `disponibilita` (`id`, `nome`, `se_catalogo`, `se_immobili`) VALUES
(1,	'disponibile',	1,	1),
(2,	'in riassortimento',	1,	NULL),
(3,	'nuda proprietà',	NULL,	1),
(4,	'occupato',	NULL,	1);

-- | 050000015150

-- giorni
INSERT IGNORE INTO `giorni` (`id`, `nome`) VALUES
(1,	'lunedì'),
(2,	'martedì'),
(3,	'mercoledì'),
(4,	'giovedì'),
(5,	'venerdì'),
(6,	'sabato'),
(7,	'domenica');

-- | 050000015200

-- gruppi
INSERT IGNORE INTO `gruppi` (`id`, `id_genitore`, `id_organizzazione`, `nome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'roots',	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'staff',	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'users',	NULL,	NULL,	NULL,	NULL);

-- | 050000016000

-- iva
-- le righe 35, 57 e 58 sono archiviate dal 2026-09-30: la natura generica N6 lo SDI la scarta dal 2021 ( errore 00445 ), e
-- l'art. 71 ha la natura N3.3 verso San Marino ( riga 60 ) e N3.6 verso il Vaticano ( riga 71 ); restano per i documenti gia' emessi che le citano, ma le
-- tendine dei documenti non le propongono; le righe da 60 a 70 sono i codici delle specifiche 1.9
INSERT IGNORE INTO `iva` (`id`, `aliquota`, `nome`, `descrizione`, `codice`, `timestamp_archiviazione`) VALUES
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
(35,	0.00,	'non imponibile ex art. 71 d.P.R. 633/1972',	'operazione non soggetta a IVA ex art. 71 del d.P.R. 633/1972',	'N3.6',	1790726400),
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
(57,	0.00,	'regime ex art. 17 c. 6 d.P.R. 633/1972 (rev. charge)',	'operazione soggetta a inversione contabile (reverse charge) ex art. 17 comma 6 del d.P.R. 633/1972',	'N6',	1790726400),
(58,	0.00,	'regime ex art. 17 cc. 7 e 8 d.P.R. 633/1972 (rev. charge)',	'operazione soggetta a inversione contabile (reverse charge) ex art. 17 commi 7 e 8 del d.P.R. 633/1972',	'N6',	1790726400),
(59,	0.00,	'esente ex art. 36 bis l. 112/2023',	'operazione esente IVA ex art. 36 bis legge 112/2023',	'N4',	NULL),
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
(70,	0.00,	'IVA assolta in altro stato UE',	'IVA assolta in altro stato UE ex art. 7 octies e art. 74 sexies del d.P.R. 633/1972',	'N7',	NULL),
(71,	0.00,	'non imponibile ex art. 71 d.P.R. 633/1972 (Vaticano)',	'operazione non imponibile ex art. 71 del d.P.R. 633/1972 (cessione verso la Città del Vaticano)',	'N3.6',	NULL);

-- | 050000016800

-- lingue
INSERT IGNORE INTO `lingue` (`id`, `nome`, `note`, `iso6391alpha2`, `iso6393alpha3`, `ietf`) VALUES
(1,     'italiano',     'italiano (Italia)',        'it',    'ita',    'it-IT'),
(2,     'ceco',         'ceco (Repubblica Ceca)',   'cs',    'ces',    'cs-CZ'),
(3,     'inglese',      'inglese (Regno Unito)',    'en',    'eng',    'en-GB'),
(4,     'francese',     'francese (Francia)',       'fr',    'fra',    'fr-FR'),
(5,     'tedesco',      'tedesco (Germania)',       'de',    'deu',    'de-DE'),
(6,     'ungherese',    'ungherese (Ungheria)',     'hu',    'hun',    'hu-HU'),
(7,     'giapponese',   'giapponese (Giappone)',    'ja',    'jpn',    'ja-JP'),
(8,     'polacco',      'polacco (Polonia)',        'pl',    'pol',    'pl-PL'),
(9,     'portoghese',   'portoghese (Portogallo)',  'pt',    'por',    'pt-PT'),
(10,    'russo',        'russo (Russia)',           'ru',    'rus',    'ru-RU'),
(11,    'spagnolo',     'spagnolo (Spagna)',        'es',    'spa',    'es-ES'),
(12,    'svedese',      'svedese (Svezia)',         'sv',    'swe',    'sv-SE'),
(13,    'americano',    'inglese (Stati Uniti)',    'en',    'eng',    'en-US'),
(14,    'croato',       'croato (Croazia)',         'hr',    'hrv',    'hr-HR'),
(15,    'rumeno',       'rumeno (Romania)',         'ro',    'ron',    'ro-RO');

-- | 050000017200

-- listini
INSERT INTO `listini` (`id`, `id_genitore`, `id_tipologia`, `id_valuta`, `codice`, `sconto_su_genitore`, `se_default_su_genitore`, `nome`, `note`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	1,	1,	NULL,	NULL,	NULL,	'DEFAULT',	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000021900

-- modalita_pagamento
INSERT IGNORE INTO `modalita_pagamento` (`id`, `codice`, `nome`) VALUES
(1,	        'MP01',	        'contanti'),
(2,	        'MP02',	        'assegno'),
(3,	        'MP03',	        'assegno circolare'),
(4,	        'MP04',	        'contanti presso tesoreria'),
(5,	        'MP05',	        'bonifico'),
(6,	        'MP06',	        'vaglia cambiario'),
(7,	        'MP07',	        'bollettino bancario'),
(8,	        'MP08',	        'carta di credito'),
(9,	        'MP09',	        'RID'),
(10,	    'MP10',	        'RID utenze'),
(11,	    'MP11',	        'RID veloce'),
(12,	    'MP12',	        'RIBA'),
(13,	    'MP13',	        'MAV'),
(14,	    'MP14',	        'quietanza erario stato'),
(15,	    'MP15',	        'giroconto su conti di contabilità speciale'),
(16,	    'MP16',	        'domiciliazione bancaria'),
(17,	    'MP17',	        'domiciliazione postale'),
(18,	    'MP18',         'bollettino di c/c postale'),
(19,        'MP19',         'SEPA Direct Debit' ),
(20,        'MP20',         'SEPA Direct Debit CORE' ),
(21,        'MP21',         'SEPA Direct Debit B2B' ),
(22,        'MP22',         'Trattenuta su somme già riscosse' ),
(23,        'MP08',         'bancomat' ),
(24,        'MP08',         'paypal' );

-- | 050000023600

-- periodicita
INSERT IGNORE INTO `periodicita` (`id`, `nome`, `giorni`) VALUES
(1,	'giornaliera',	1),
(2,	'settimanale',	7),
(3,	'mensile',	30),
(4,	'bimestrale',	60),
(5,	'trimestrale',	90),
(6,	'quadrimestrale',	120),
(7,	'semestrale',	180),
(8,	'annuale',	365);

-- | 050000023700

-- pesi_tipologie_corrispondenza
INSERT IGNORE INTO `pesi_tipologie_corrispondenza` (`id`, `id_tipologia`, `nome`, `grammi_min`, `grammi_max`) VALUES
(1,	1,	'PP fino a 20g',	0.00,	20.00),
(2,	1,	'PP da 21g a 50g',	20.00,	50.00),
(5,	1,	'PP da 51g a 100g',	50.00,	100.00),
(6,	1,	'PP da 101g a 250g',	100.00,	250.00),
(9,	1,	'PP da 251g a 350g',	250.00,	350.00),
(10,	1,	'PP da 351g a 1000g',	350.00,	1000.00),
(11,	1,	'PP da 1001g a 2000g',	1000.00,	2000.00),
(12,	2,	'RA fino a 20 g',	0.00,	20.00),
(13,	2,	'RA da 21g a 50g',	20.00,	50.00),
(14,	2,	'RA da 51g a 100g',	51.00,	100.00),
(15,	2,	'RA da 101g a 250g',	101.00,	250.00),
(16,	2,	'RA da 251g a 350g',	251.00,	350.00),
(17,	2,	'RA da 351g a 1000g',	350.00,	1000.00),
(18,	2,	'RA da 1001g a 2000g',	1000.00,	2000.00),
(19,	2,	'RA oltre 2kg',	2000.00,	0.00),
(20,	3,	'AG fino 20g',	0.00,	20.00),
(21,	3,	'AG da 21g a 50g',	20.00,	50.00),
(22,	3,	'AG da 51g a 100g',	50.00,	100.00),
(23,	3,	'AG da 101g a 250g',	100.00,	250.00),
(24,	3,	'AG da 251g a 350g',	250.00,	350.00),
(25,	3,	'AG da 351g a 1000g',	351.00,	1000.00),
(27,	3,	'AG da 1001g a 2000g',	1000.00,	2000.00),
(28,	4,	'AR fino a 20g',	0.00,	20.00),
(29,	4,	'AR fino a 20g non standard',	0.00,	20.00),
(30,	4,	'AR da 21g a 50g',	20.00,	50.00),
(31,	4,	'AR da 51g a 100g',	50.00,	100.00),
(32,	4,	'AR da 101g a 250g',	100.00,	250.00),
(33,	4,	'AR da 251g a 350g',	250.00,	350.00),
(34,	4,	'AR da 351g a 1000g',	350.00,	1000.00),
(35,	4,	'AR da 1001g a 2000g',	1000.00,	2000.00),
(36,	4,	'AR oltre 2kg',	2000.00,	0.00),
(37,	6,	'PDL da 0 a 2Kg',	0.00,	2000.00),
(38,	6,	'PDL da 2Kg a 5Kg',	2000.00,	5000.00),
(39,	5,	'PDL MAAF fino a 2Kg',	0.00,	2000.00),
(40,	5,	'PDL MAAF fino a 5Kg',	2001.00,	5000.00),
(41,	7,	'RA fino a 20 g',	0.00,	20.00),
(42,	7,	'RA da 21g a 50g',	20.00,	50.00),
(43,	7,	'RA da 51g a 100g',	51.00,	100.00),
(44,	7,	'RA da 101g a 250g',	101.00,	250.00),
(45,	7,	'RA da 251g a 350g',	251.00,	350.00),
(46,	7,	'RA da 351g a 1000g',	350.00,	1000.00),
(47,	7,	'RA da 1001g a 2000g',	1000.00,	2000.00),
(48,	7,	'RA oltre 2kg',	2000.00,	0.00),
(56,	7,	'PDL da 0 a 2Kg',	0.00,	2000.00),
(57,	7,	'PDL da 2Kg a 5Kg',	2000.00,	5000.00),
(58,	8,	'CE normalizzato fino a 20g',	0.00,	20.00),
(59,	8,	'CE compatto da 21g a 50g',	20.00,	50.00),
(60,	8,	'CE compatto da 51g a 100g',	50.00,	100.00),
(61,	8,	'CE compatto da 101g a 250g',	100.00,	250.00),
(62,	8,	'CE compatto da 251g a 350g',	250.00,	350.00),
(63,	8,	'CE voluminoso fino 350g',	0.00,	350.00),
(64,	8,	'CE voluminoso da 351g a 1000g',	350.00,	1000.00),
(65,	8,	'CE voluminoso da 1000g a 2000g',	1000.00,	2000.00),
(66,	9,	'AE fino a 20g',	0.00,	20.00),
(67,	9,	'AE da 21g a 50g',	20.00,	50.00),
(68,	9,	'AE da 51g a 100g',	50.00,	100.00),
(69,	9,	'AE da 101g a 250g',	100.00,	250.00),
(70,	9,	'AE da 251g a 350g',	251.00,	350.00),
(71,	9,	'AE da 351g a 1000g',	350.00,	1000.00),
(72,	9,	'AE da 1000g a 2000g',	1000.00,	2000.00),
(73,	10,	'RE fino 20g',	0.00,	20.00),
(74,	10,	'RE da 21g a 50g',	20.00,	50.00),
(75,	10,	'RE da 51g a 100g',	50.00,	100.00),
(76,	10,	'RE da 101g a 250g',	100.00,	250.00),
(77,	10,	'RE da 251g a 350g',	250.00,	350.00),
(78,	10,	'RE da 351g a 1000g',	350.00,	1000.00),
(79,	10,	'RE da 1001g a 2000g',	1000.00,	2000.00),
(80,	2,	'PDL da 0 a 2Kg',	0.00,	2000.00),
(81,	2,	'PDL da 2Kg a 5Kg',	2000.00,	5000.00),
(82,	12,	'PP fino a 20g',	0.00,	20.00),
(83,	12,	'PP da 21g a 50g',	20.00,	50.00),
(84,	12,	'PP da 51g a 100g',	50.00,	100.00),
(85,	12,	'PP da 101g a 250g',	100.00,	250.00),
(86,	12,	'PP da 251g a 350g',	250.00,	350.00),
(87,	12,	'PP da 351g a 1000g',	350.00,	1000.00),
(88,	12,	'PP da 1001g a 2000g',	1000.00,	2000.00),
(89,	11,	'fino a 100g',	0.00,	100.00),
(90,	11,	'da 101g a 500g',	101.00,	500.00),
(91,	11,	'da 501g a 2000g',	501.00,	2000.00),
(92,	13,	'fino a 50g',	0.00,	50.00),
(93,	13,	'da 51g a 100g',	51.00,	100.00),
(94,	13,	'da 101g a 250g',	101.00,	250.00),
(95,	13,	'da 251g fino a 350g',	251.00,	350.00),
(96,	13,	'fino a 350g',	0.00,	350.00),
(97,	13,	'da 351g a 1000g',	351.00,	1000.00),
(98,	13,	'da 1001g a 2000g',	1001.00,	2000.00),
(99,	14,	'fino a 20g',	0.00,	20.00),
(100,	14,	'fino a 50g',	0.00,	50.00),
(101,	14,	'da 51g a 100g',	51.00,	100.00),
(102,	14,	'da 101g a 250g',	101.00,	250.00),
(103,	14,	'da 251g fino a 350g',	251.00,	350.00),
(104,	14,	'fino a 350g',	0.00,	350.00),
(105,	14,	'da 351g a 1000g',	351.00,	1000.00),
(106,	14,	'da 1001g a 2000g',	1001.00,	2000.00),
(107,	15,	'RE fino 20g',	0.00,	20.00),
(108,	15,	'RE da 21g a 50g',	20.00,	50.00),
(109,	15,	'RE da 51g a 100g',	50.00,	100.00),
(110,	15,	'RE da 101g a 250g',	100.00,	250.00),
(111,	15,	'RE da 251g a 350g',	250.00,	350.00),
(112,	15,	'RE da 351g a 1000g',	350.00,	1000.00),
(113,	15,	'RE da 1001g a 2000g',	1000.00,	2000.00);

-- | 050000028600

-- ranking
INSERT IGNORE INTO `ranking` (`id`, `nome`, `note`, `ordine`, `se_cliente`, `se_fornitore`, `se_progetti`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	'PLATINUM',	NULL,	100,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	'GOLD',	NULL,	200,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	'SILVER',	NULL,	300,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	'BRONZE',	NULL,	400,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000029800

-- regimi
INSERT IGNORE INTO `regimi` (`id`, `nome`, `codice`) VALUES
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

-- NOTE
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

-- | 050000030800

-- reparti
INSERT INTO `reparti` (`id`, `id_iva`, `id_settore`, `nome`, `note`, `timestamp_inserimento`, `id_account_inserimento`, `timestamp_aggiornamento`, `id_account_aggiornamento`) VALUES
(1,	1,	NULL,	'VENDITA IVA 22%',	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	59,	NULL,	'DIDATTICA ASD 0%',	'operazione esente IVA ex art. 36 bis legge 112/2023',	NULL,	NULL,	NULL,	NULL),
(9,	9,	NULL,	'LOCAZIONE IVA 0%',	'fuori campo IVA ex art. 3 d.P.R. 633/1972',	NULL,	NULL,	NULL,	NULL);

-- | 050000033000

-- ritenute
-- i codici TipoRitenuta delle specifiche tecniche 1.9 della fattura elettronica, con le descrizioni della rappresentazione tabellare
INSERT IGNORE INTO `ritenute` (`id`, `codice`, `nome`) VALUES
(1,		'RT01',		'ritenuta persone fisiche'),
(2,		'RT02',		'ritenuta persone giuridiche'),
(3,		'RT03',		'contributo INPS'),
(4,		'RT04',		'contributo ENASARCO'),
(5,		'RT05',		'contributo ENPAM'),
(6,		'RT06',		'altro contributo previdenziale');

-- | 050000034000

-- ruoli_anagrafica
INSERT INTO `ruoli_anagrafica` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_produzione`, `se_didattica`, `se_organizzazioni`, `se_relazioni`, `se_notizie`, `se_risorse`, `se_progetti`, `se_immobili`, `se_contratti`, `se_proponente`, `se_contraente`) VALUES
(1,	    NULL,	'titolare',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	    NULL,	'amministratore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	    NULL,	'socio',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	    NULL,	'dipendente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	    NULL,	'direttore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	    NULL,	'presidente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	    NULL,	'tesoriere',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	    NULL,	'coordinatore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(9,	    NULL,	'vicepresidente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	'vicedirettore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	'segretario',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	'responsabile amministrativo',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	'responsabile acquisti',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	'responsabile operativo',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	'operatore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(16,	NULL,	'responsabile',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(17,	NULL,	'assistente',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(18,	NULL,	'autore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(19,	NULL,	'genitore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(20,	NULL,	'fratello',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(21,	NULL,	'tutore',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(22,	NULL,	'coniuge',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(23,	NULL,	'collega',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(24,	NULL,	'docente',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(25,	NULL,	'istruttore',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(26,	NULL,	'proprietario',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(27,	NULL,	'locatore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(28,	NULL,	'conduttore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(29,	NULL,	'iscritto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(30,	NULL,	'istituto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(31,	NULL,	'professionista',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(32,	NULL,	'cliente',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	1),
(33,	NULL,	'tesserato',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(34,	NULL,	'abbonato',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(35,	NULL,	'proponente',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL),
(36,	NULL,	'referente fatturazione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(37,	NULL,	'referente tecnico',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(38,	NULL,	'supervisore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(40,	NULL,	'coautore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(41,	NULL,	'traduttore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(42,	NULL,	'revisore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(43,	NULL,	'editore',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000034100

-- ruoli_articoli
INSERT INTO `ruoli_articoli` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_progetti`, `se_risorse`, `se_acquisto`, `se_rinnovo`) VALUES
(1,	NULL,	'prodotto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	'principale',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'suggerito',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'accessorio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'consumabile',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	'bundle',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000034200

-- ruoli_audio
INSERT IGNORE INTO `ruoli_audio` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_annunci`, `se_categorie_annunci`, `se_risorse`, `se_categorie_risorse`, `se_immobili`) VALUES
(1,	NULL,	'audio',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	NULL,	NULL,	1),
(2,	NULL,	'commento',	NULL,	NULL,	NULL,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

-- | 050000034300

-- ruoli_documenti
INSERT INTO `ruoli_documenti` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_xml`, `se_documenti`, `se_documenti_articoli`, `se_relazioni`, `se_conferma`, `se_consuntivo`, `se_evasione`) VALUES
(1,	NULL,	'conferma',	NULL,	NULL,	NULL,	1,	1,	NULL,	1,	NULL,	NULL),
(2,	NULL,	'consuntivo',	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	1,	NULL),
(3,	NULL,	'evasione',	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	1),
(4,	NULL,	'missione',	NULL,	NULL,	NULL,	1,	1,	1,	NULL,	NULL,	1),
(5,	NULL,	'fattura collegata',	NULL,	NULL,	1,	1,	1,	1,	NULL,	NULL,	NULL),
(6,	NULL,	'DDT collegato',	NULL,	NULL,	1,	1,	1,	1,	NULL,	NULL,	NULL);

-- | 050000034400

-- ruoli_file
INSERT IGNORE INTO `ruoli_file` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_template`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_mail`, `se_immobili`, `se_documenti`) VALUES
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

-- | 050000034600

-- ruoli_immagini
-- tipologia: tabella standard
INSERT IGNORE INTO `ruoli_immagini` (`id`, `id_genitore`, `ordine_scalamento`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_risorse`, `se_categorie_risorse`, `se_immobili`) VALUES
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
(16,	NULL,	NULL,	'applicazioni',	NULL,	NULL,	NULL,	NULL,	1,		1,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(17,	NULL,	NULL,	'etichetta',	NULL,	NULL,	NULL,	NULL,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(18,	NULL,	NULL,	'miniatura',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1);

-- | 050000034800

-- ruoli_indirizzi
INSERT IGNORE INTO `ruoli_indirizzi` (`id`, `nome`, `html_entity`, `font_awesome`, `se_sede_legale`, `se_sede_operativa`, `se_residenza`, `se_domicilio`) VALUES
(1,	'sede legale',	    '&#xf1ad;',	    '',     1,	    NULL,	NULL,	NULL),
(2,	'sede operativa',	'&#xf275;',     '',     NULL,	1,	    NULL,	NULL),
(3,	'casa',             '&#xf015;',     '',     NULL,	NULL,	1,	    NULL),
(4,	'residenza',	    '&#xf015;',	    '',     NULL,	NULL,	1,	    NULL),
(5,	'domicilio',	    '&#xf015;',	    '',     NULL,	NULL,	1,	    1);

-- | 050000034850

-- ruoli_mail
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `ruoli_mail` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_xml`, `se_commerciale`, `se_produzione`, `se_amministrazione`, `se_acquisti`, `se_ordini`, `se_helpdesk`) VALUES
(1,	NULL,	'generica',	NULL,	NULL,	NULL,	1,	1,	1,	1,	1,	1),
(2,	NULL,	'commerciale',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'produzione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'amministrazione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(5,	NULL,	'acquisti',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(6,	NULL,	'ordini',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL),
(7,	NULL,	'helpdesk',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

-- | 050000034900

-- ruoli_matricole
-- tipologia: tabella standard
-- verifica: 2021-10-12 10:45 Fabio Mosti
INSERT IGNORE INTO `ruoli_matricole` (`id`, `nome`, `html_entity`, `font_awesome`) VALUES
(1,	'attrezzatura',	    '',	    ''),
(2,	'prodotto',	    '',	    '');

-- | 050000035000

-- ruoli_prodotti
INSERT INTO `ruoli_prodotti` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`) VALUES
(1,	NULL,	'prodotto',	NULL,	NULL),
(2,	NULL,	'principale',	NULL,	NULL),
(3,	NULL,	'suggerito',	NULL,	NULL),
(4,	NULL,	'accessorio',	NULL,	NULL),
(5,	NULL,	'consumabile',	NULL,	NULL),
(6,	NULL,	'bundle',	NULL,	NULL);

-- | 050000035100

-- ruoli_progetti
-- tipologia: tabella di supporto
-- verifica: 2022-04-20 10:45 chiara GDL
INSERT IGNORE INTO `ruoli_progetti` (`id`, `nome`, `html_entity`, `font_awesome`, `se_sottoprogetto`, `se_proseguimento`, `se_sostituto`, `se_attesa`) VALUES
(1,	'proseguimento',	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(2,	'bundle',	NULL,	NULL,	1,	NULL,	NULL,	NULL),
(3,	'attesa',	NULL,	NULL,	NULL,	NULL,	NULL,	1);

-- | 050000035200

-- ruoli_video
INSERT IGNORE INTO `ruoli_video` (`id`, `id_genitore`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_pagine`, `se_prodotti`, `se_articoli`, `se_categorie_prodotti`, `se_notizie`, `se_categorie_notizie`, `se_annunci`, `se_categorie_annunci`, `se_risorse`, `se_categorie_risorse`, `se_immobili`) VALUES
(1,	NULL,	'video',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1),
(2,	NULL,	'gallery',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1),
(3,	NULL,	'carousel',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(4,	NULL,	'card',	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(5,	NULL,	'copertina',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	1,	1,	1,	1,	NULL),
(6,	NULL,	'jumbotron',	NULL,	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(7,	NULL,	'intestazione',	NULL,	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(8,	NULL,	'sfondo',	NULL,	NULL,	NULL,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	NULL),
(9,	NULL,	'dettaglio',	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1),
(10,	NULL,	'lezione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(11,	NULL,	'episodio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL),
(12,	NULL,	'condominio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1);

-- | 050000037000

-- settori
INSERT IGNORE INTO `settori` (`id`, `id_genitore`, `ateco`, `nome`, `soprannome`) VALUES
(1,     NULL,   'A',          'AGRICOLTURA, SILVICOLTURA E PESCA',                                                    'agricoltura, silvicoltura e pesca'),
(2,     1,      '01',         'COLTIVAZIONI AGRICOLE E PRODUZIONE DI PRODOTTI ANIMALI, CACCIA E SERVIZI CONNESSI',    'coltivazioni, prodotti animali e caccia'),
(3,     2,      '01.1',       'COLTIVAZIONE DI COLTURE AGRICOLE NON PERMANENTI',                                      'colture non permanenti'),
(4,     2,      '01.11',      'Coltivazione di cereali (escluso il riso), legumi da granella e semi oleosi',          'coltivazione di cereali, legumi e semi'),
(5,     4,      '01.11.1',    'Coltivazione di cereali (escluso il riso)',                                            'coltivazione di cereali');

-- | 050000042200

-- stati_lingue
-- tipologia: tabella standard
-- verifica: 2021-10-12 15:42 Fabio Mosti
INSERT IGNORE INTO `stati_lingue` (`id`, `id_stato`, `id_lingua`, `ordine`) VALUES
(1,	1,	1,	1),
(2,	12,	4,	1);

-- | 050000042500

-- step
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `step` (`id`, `id_funnel`, `ordine`, `nome`, `note`) VALUES
(1,	NULL,	NULL,	'apertura',	NULL),
(2,	NULL,	NULL,	'in corso',	NULL),
(3,	NULL,	NULL,	'esito positivo',	NULL),
(4,	NULL,	NULL,	'esito negativo',	NULL);

-- | 050000042700

-- taglie
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `taglie` (`id`, `id_tipologia_prodotti`, `nome`, `sesso`, `taglia_internazionale`, `circonferenza_testa_min`, `circonferenza_testa_max`) VALUES
(1,	12,	'abbigliamento XXXS uomo',	'M',	'XXXS',	NULL,	NULL),
(2,	12,	'abbigliamento XXS uomo',	'M',	'XXS',	NULL,	NULL),
(3,	12,	'abbigliamento XS uomo',	'M',	'XS',	NULL,	NULL),
(4,	12,	'abbigliamento S uomo',	'M',	'S',	NULL,	NULL),
(5,	12,	'abbigliamento M uomo',	'M',	'M',	NULL,	NULL),
(6,	12,	'abbigliamento L uomo',	'M',	'L',	NULL,	NULL),
(7,	12,	'abbigliamento XL uomo',	'M',	'XL',	NULL,	NULL),
(8,	12,	'abbigliamento XXL uomo',	'M',	'XXL',	NULL,	NULL),
(9,	12,	'abbigliamento XXXL uomo',	'M',	'XXXL',	NULL,	NULL),
(10,	12,	'abbigliamento 4XL uomo',	'M',	'4XL',	NULL,	NULL),
(11,	12,	'abbigliamento XXS donna',	'F',	'XXXS',	NULL,	NULL),
(12,	12,	'abbigliamento XS donna',	'F',	'XXS',	NULL,	NULL),
(13,	12,	'abbigliamento S donna',	'F',	'XS',	NULL,	NULL),
(14,	12,	'abbigliamento M donna',	'F',	'S',	NULL,	NULL),
(15,	12,	'abbigliamento L donna',	'F',	'M',	NULL,	NULL),
(16,	12,	'abbigliamento XL donna',	'F',	'L',	NULL,	NULL),
(17,	12,	'abbigliamento XXL donna',	'F',	'XL',	NULL,	NULL),
(18,	12,	'abbigliamento XXXL donna',	'F',	'XXL',	NULL,	NULL),
(19,	13,	'caschi XXS',	NULL,	'XXS',	510,	529),
(20,	13,	'caschi XS',	NULL,	'XS',	530,	549),
(21,	13,	'caschi S',	NULL,	'S',	550,	569),
(22,	13,	'caschi M',	NULL,	'M',	570,	589),
(23,	13,	'caschi L',	NULL,	'L',	590,	609),
(24,	13,	'caschi XL',	NULL,	'XL',	610,	629),
(25,	13,	'caschi XXL',	NULL,	'XXL',	630,	649),
(26,	13,	'caschi taglia unica',	NULL,	'UNICA',	NULL,	NULL);

-- | 050000043000

-- task
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `task` (`id`, `minuto`, `ora`, `giorno_del_mese`, `mese`, `giorno_della_settimana`, `settimana`, `task`, `iterazioni`, `delay`, `token`, `timestamp_esecuzione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_images.resize.php',	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_mail.queue.send.php',	20,	2,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'_src/_api/_task/_sms.queue.send.php',	3,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000050000

-- tipologie_anagrafica
INSERT INTO `tipologie_anagrafica` (`id`, `id_genitore`, `ordine`, `nome`, `sigla`, `html_entity`, `font_awesome`, `se_persona_fisica`, `se_persona_giuridica`, `se_pubblica_amministrazione`, `se_ecommerce`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	10,	'persone fisiche',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	20,	'persone giuridiche',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	7,	10,	'signor',	'sig.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	8,	20,	'signora',	'sig.ra',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	2,	10,	'spettabile',	'spett.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	20,	'pubblica amministrazione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	1,	NULL,	'gentilissimo',	'gent.mo',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	1,	NULL,	'gentilissima',	'gent.ma',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	6,	NULL,	'spettabile',	'spett.',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000050400

-- tipologie_attivita
INSERT INTO `tipologie_attivita` (`id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `se_anagrafica`, `se_agenda`, `se_sistema`, `se_stampa`, `se_cartellini`, `se_corsi`, `se_accesso`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	    NULL,	NULL,	NULL,	'lavoro',	                                    NULL,	NULL,	1,	    NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	    NULL,	NULL,	NULL,	'ferie',	                                    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	    NULL,	NULL,	NULL,	'permessi',	                                    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	    NULL,	NULL,	NULL,	'malattie',	                                    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	    NULL,	NULL,	NULL,	'SDI',	                                        NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	    5,	    NULL,	'RC',	'ricevuta di consegna',	                        NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	    5,	    NULL,	'MC',	'mancata consegna',	                            NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	    5,	    NULL,	'NS',	'notifica di scarto',	                        NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	    5,	    NULL,	'AT',	'presa in carico con impossibilità di recapito',NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,    5,	    NULL,	'DT',	'decorrenza termini',	                        NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	5,	    NULL,	'EC',	'esito committente',	                        NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	5,	    NULL,	'NE',	'notifica di esito',	                        NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	5,	    NULL,	'MT',	'notifica di metadati per fattura passiva',	    NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	1,	    NULL,	NULL,	'produzione',	                                NULL,	NULL,	NULL,	1,	    NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	18,	    NULL,	NULL,	'frequenza',	                                NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(16,	1,	    NULL,	NULL,	'commerciale',	                                NULL,	NULL,	NULL,	1,	    NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(17,	1,	    NULL,	NULL,	'amministrazione',	                            NULL,	NULL,	NULL,	1,	    NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(18,	NULL,	NULL,	NULL,	'didattica',	                                NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(19,	18,	    NULL,	NULL,	'assenza',	                                    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(20,	17,	    NULL,	NULL,	'carico ore',	                                NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(21,	17,	    NULL,	NULL,	'promemoria scadenze',	                        NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(22,	NULL,	NULL,	NULL,	'stampe',	                                    NULL,	NULL,	NULL,	NULL,	1,	    1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(23,	22,	    NULL,	NULL,	'stampa PDF',	                                NULL,	NULL,	NULL,	NULL,	1,	    1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(24,	22,	    NULL,	NULL,	'stampa XML',	                                NULL,	NULL,	NULL,	NULL,	1,	    1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(25,	17,	    NULL,	NULL,	'sollecito insoluti',	                        NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(26,	16,	    NULL,	NULL,	'invio proposta commerciale',	                NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(27,	NULL,	NULL,	NULL,	'invio',	                                    NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(28,	27,	    NULL,	NULL,	'invio via e-mail',	                            NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(29,	27,	    NULL,	NULL,	'invio via PEC',	                            NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(30,	18,	    NULL,	NULL,	'docenza',	                                    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(31,	18,	    NULL,	NULL,	'co-docenza',	                                NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(32,	18,	    NULL,	NULL,	'recupero frequenza',	                        NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(33,	18,	    NULL,	NULL,	'frequenza di prova',	                        NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(34,	NULL,	NULL,	NULL,	'mailing',	                                    NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(35,	34,	    NULL,	NULL,	'apertura mail',	                            NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(36,	NULL,	NULL,	NULL,	'invio report',	                                NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(37,	NULL,	NULL,	NULL,	'accesso',	                                    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(38,	37,	    NULL,	NULL,	'riuscito',	                                    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL),
(39,	37,	    NULL,	NULL,	'fallito',	                                    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(40,	18,	    NULL,	NULL,	'lista di attesa',	                            NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(41,    NULL,	NULL,	NULL,	'chat',	                                        NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(42,	41,	    NULL,	NULL,	'lettura',	                                    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,   NULL),
(43,	NULL,	NULL,	NULL,	'download file',	                            NULL,	NULL,	NULL,	NULL,	1,	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000050450

-- tipologie_badge
INSERT IGNORE INTO `tipologie_badge` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'tesserini',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'token di accesso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000050700

-- tipologie_colli
INSERT INTO `tipologie_colli` (`id`, `id_genitore`, `ordine`, `nome`, `sigla`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'container',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'pallet',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'scatola',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000050800

-- tipologie_contatti
INSERT IGNORE INTO `tipologie_contatti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'di persona',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'telefono',	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'mail',	        NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'form web',	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'chat',	        NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000050900

-- tipologie_contratti
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `tipologie_contratti` (`id`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_tesseramento`, `se_abbonamento`, `se_iscrizione`, `se_affiliazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	'vendita',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	'locazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'tesseramento',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'abbonamento',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'iscrizione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	'affiliazione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	'servizi',		NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000051000

-- tipologie_corrispondenza
INSERT INTO `tipologie_corrispondenza` (`id`, `id_genitore`, `nome`, `se_massivo`, `se_corrispondenza`, `se_pesata`, `se_atto`, `se_ricevuta_ritorno`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	'Posta Prioritaria PRO',	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	'Raccomandate PRO / RACCOMANDATA MARKET - NO ATT.',	0,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	'Atti giudiziari',	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	'Assicurate retail / ASSICURATA MARKET',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	'Pieghi di libri MAAF',	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	'Pieghi di libri',	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	NULL,	'Raccomandate A/R / RACCOMANDATA MARKET CON ATTESTAZIONE DI CONSEGNA',	0,	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(8,	NULL,	'Corrispondenza estera',	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	NULL,	'Assicurate estere',	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	'Raccomandate estere',	0,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	'Posta 1 PRO',	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	'Posta 4 PRO / POSTA CONTEST 4 (ORDINARIA)',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	'Posta Priority Internazionale',	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	'Posta Mail Internazionale',	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	'Posta Raccomandata internazionale',	0,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(16,	NULL,	'MINI BOX (ORDINARIA ESTERO) ZONA 1',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(17,	NULL,	'MINI BOX (ORDINARIA ESTERO) ZONA 2',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(18,	NULL,	'MINI BOX (ORDINARIA ESTERO) ZONA 3',	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(52,	NULL,	'accesso atti',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(53,	NULL,	'accesso atti - contratto cimiteriale',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(54,	NULL,	'accesso atti - edilizia',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(55,	NULL,	'accesso atti - polizia',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(56,	NULL,	'atto Corte d\'Appello',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(57,	NULL,	'autorizzazione',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(58,	NULL,	'autorizzazione - ambiente',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(59,	NULL,	'autorizzazione - edilizia',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(60,	NULL,	'attestazione - idoneità dell\'alloggio',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(61,	NULL,	'autorizzazione - occupazione suolo',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(62,	NULL,	'assenti (Art. 140) - cartelle esattoriali',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(63,	NULL,	'irreperibili (Art. 60) - EQUITALIA (vecchi)',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(64,	NULL,	'certificato destinazione urbanistica',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(65,	NULL,	'atti notificati (Art. 140)',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(66,	NULL,	'ATTI SPORTELLO EDILIZIA',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(67,	NULL,	'Irreperibili (Art.143) - atti amministrativi',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(68,	NULL,	'irreperibili (Art. 60) - AGENZIA ENTRATE',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(69,	NULL,	'attestazione - regolarità soggiorno',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(70,	NULL,	'assenti (Art. 140) - AGENZIA ENTRATE',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(71,	NULL,	'irreperibili (Art. 60) - cartelle esattoriali',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000052600

-- tipologie_documenti
INSERT INTO `tipologie_documenti` (`id`, `id_genitore`, `ordine`, `codice`, `numerazione`, `nome`, `sigla`, `html_entity`, `font_awesome`, `se_fattura`, `se_nota_credito`, `se_nota_debito`, `se_trasporto`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_missione`, `se_ricevuta`, `se_ecommerce`, `stampa_xml`, `stampa_pdf`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(29,	NULL,	NULL,	NULL,	'D',	'distinta',	'dist.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(30,	29,	    NULL,	NULL,	'D',	'distinta analitica',	'dist. anal.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(31,	29,	    NULL,	NULL,	'D',	'distinta easy',	'dist. easy',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(32,	29,	    NULL,	NULL,	'D',	'distinta Italia / estero contest, racc. market, ass. market',	'dist. Ita / est',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	    NULL,	NULL,	NULL,	'E',	'ordine',	'ord.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(1,	    NULL,	NULL,	'TD01',	'F',	'fattura',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	    1,	    NULL,	'TD01',	'F',	'fattura accompagnatoria',	'fatt. acc.',	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	    NULL,	NULL,	'TD04',	'F',	'nota di credito',	'n. di credito',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	NULL,	NULL,	'TD02',	'F',	'acconto/anticipo su fattura',	'acc.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	NULL,	NULL,	'TD03',	'F',	'acconto/anticipo su parcella',	'acc.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	NULL,	NULL,	'TD05',	'F',	'nota di debito',	'n. di debito',	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(16,	NULL,	NULL,	'TD06',	'F',	'parcella',	'parcella',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(17,	1,	    NULL,	'TD16',	'F',	'integrazione fattura reverse charge interno',	'integr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(18,	1,	    NULL,	'TD17',	'F',	'integrazione autofattura acquisto servizi dall\'estero',	'integr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(19,	1,	    NULL,	'TD18',	'F',	'integrazione per acquisto beni intracomunitari',	'integr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(20,	1,	    NULL,	'TD19',	'F',	'integrazione/autofattura per acquisto beni',	'integr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(21,	1,	    NULL,	'TD20',	'F',	'autofattura per regolarizzazione e integrazione fatture',	'autofatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(22,	1,	    NULL,	'TD21',	'F',	'autofattura per splafonamento',	'autofatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(23,	1,	    NULL,	'TD22',	'F',	'estrazione beni da deposito IVA',	'estr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(24,	1,	    NULL,	'TD23',	'F',	'estrazione beni da deposito IVA con versamento dell\'IVA',	'estr.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(25,	1,	    NULL,	'TD24',	'F',	'fattura differita ex art. 21 c. 4 terzo per. lett. a d.P.R. 633/1972',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(26,	1,	    NULL,	'TD25',	'F',	'fattura differita ex art. 21 c. 4 terzo per. lett. b d.P.R. 633/1972',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(27,	1,	    NULL,	'TD26',	'F',	'cessione beni ammortizzabili e per passaggi interni',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(28,	1,	    NULL,	'TD27',	'F',	'fattura per autoconsumo o cessioni gratuite senza rivalsa',	'fatt.',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	NULL,	NULL,	NULL,	'G',	'documento di ritiro',	'doc. di ritiro',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	NULL,	NULL,	NULL,	'H',	'documento di consegna',	'doc. di consegna',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	NULL,	NULL,	NULL,	'I',	'documento di reso',	'doc. di reso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(34,	NULL,	NULL,	NULL,	'M',	'missione di prelievo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	    NULL,	NULL,	NULL,	'O',	'offerta',	'off.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	    NULL,	NULL,	NULL,	'P',	'pro forma',	'profroma',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(33,	29,	    NULL,	NULL,	'P',	'ordine di produzione',	'ordine di prod.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	    NULL,	NULL,	NULL,	'R',	'ricevuta',	'ric.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	    NULL,	NULL,	NULL,	'S',	'scontrino',	'scontr.',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	    NULL,	NULL,	NULL,	'T',	'documento di trasporto',	'DDT',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000052700

-- tipologie_documenti_articoli
-- le due righe che il framework usa da se' per raggruppare le righe di un documento; INSERT
-- IGNORE perche' un deploy puo' averne gia' di proprie con gli stessi id
INSERT IGNORE INTO `tipologie_documenti_articoli` (`id`, `id_genitore`, `ordine`, `nome`, `sigla`, `html_entity`, `font_awesome`, `se_raggruppamento`, `se_somma`, `se_alternativa`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	1,	'raggruppamento a sommare',	'somma',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	2,	'raggruppamento in alternativa',	'alt.',	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

-- | 050000052800

-- tipologie_edifici
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
INSERT IGNORE INTO `tipologie_edifici` (`id`, `id_genitore`, `nome`) VALUES
(1, NULL, 'palazzo'),
(2, NULL, 'palazzo storico'),
(3, NULL, 'palazzina'),
(4, NULL, 'complesso'),
(5, NULL, 'residence'),
(6, NULL, 'edificio indipendente');

-- | 050000052900

-- tipologie_immobili
-- tipologia: tabella di supporto
-- verifica: 2022-04-27 17:00 Chiara GDL
INSERT IGNORE INTO `tipologie_immobili` (`id`, `nome`, `se_residenziale`, `se_industriale`) VALUES
(1, 'appartamento', 1, NULL),
(3, 'abitazione', 1, NULL),
(6, 'garage', 1, NULL),
(7, 'magazzino', 1, 1),
(8, 'ufficio', NULL, 1),
(9, 'negozio', NULL, 1);

-- | 050000053000

-- tipologie_indirizzi
INSERT IGNORE INTO `tipologie_indirizzi` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	    NULL,	NULL,	'calle',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	    NULL,	NULL,	'campiello',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	    NULL,	NULL,	'campo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	    NULL,	NULL,	'carraia',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	    NULL,	NULL,	'carrarone',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	    NULL,	NULL,	'chiasso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	    NULL,	NULL,	'circondario',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	    NULL,	NULL,	'circonvallazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	    NULL,	NULL,	'contrà',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
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

-- | 050000053300

-- tipologie_luoghi
-- tipologia: tabella gestita
-- verifica: 2022-02-21 15:30 Chiara GDL
INSERT IGNORE INTO `tipologie_luoghi` (`id`, `nome`) VALUES
(1, 'teatro'),
(2, 'palestra'),
(3, 'piscina'),
(4, 'sala'),
(5, 'aula'),
(6, 'online');

-- | 050000053400

-- tipologie_mastri
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT IGNORE INTO `tipologie_mastri` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_magazzino`, `se_conto`, `se_registro`, `se_credito`,`id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'magazzino',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'conto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'registro ore',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'crediti',	NULL,	NULL,	NULL,	NULL,	NULL,	1, NULL,	NULL,	NULL,	NULL);

-- | 050000053700

-- tipologie_mail_status
INSERT IGNORE INTO `tipologie_mail_status` (`id`, `ordine`, `codice`, `nome`, `note`, `se_recapitabile`, `se_sistema`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	1,	'Rating A+',	'Deliverable +',	'Engagement Activity These emails are deliverable and have a history of clicks or opens. These addresses are always safe to send to!',	1,	1,	NULL,	NULL,	NULL,	NULL),
(2,	2,	'Rating A',	'Deliverable',	'These emails are deliverable. These addresses are always safe to send to!',	1,	1,	NULL,	NULL,	NULL,	NULL),
(3,	3,	'Rating B',	'Accepts All',	'These emails have been deemed as "Accepts All", meaning the server will accept all mail and may bounce it back to sender. We do not recommend sending to the "Accept All" category. All emails with a grade of B should be segmented (until later confirmed valid).',	1,	1,	NULL,	NULL,	NULL,	NULL),
(4,	4,	'Rating D',	'Indeterminate',	'In checking for an email, we were not able to do anything. We do not recommend sending to the "Indeterminate" category. All emails with a grade of D should be segmented off your list.',	1,	1,	NULL,	NULL,	NULL,	NULL),
(5,	5,	'Rating F',	'Undeliverable',	'The emails given a grade of F have been deemed as undeliverable and invalid. Do not send mail to these addresses.',	0,	1,	NULL,	NULL,	NULL,	NULL),
(8,	6,	'Cleaned',	'Puliti da MailChimp / Hard Bounce',	'-',	0,	1,	NULL,	NULL,	NULL,	NULL),
(9,	7,	'Blacklisted',	'Cancellati su MChimp / Blacklisted',	'-',	0,	1,	NULL,	NULL,	NULL,	NULL),
(10,	8,	'Non importabile',	'-',	'-',	0,	1,	NULL,	NULL,	NULL,	NULL),
(20,	9,	'OK',	'-',	'-',	1,	1,	NULL,	NULL,	NULL,	NULL);

-- | 050000053800

-- tipologie_notizie
INSERT IGNORE INTO `tipologie_notizie` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'notizia',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'blog post',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'articolo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000054000

-- tipologie_pagamenti
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `tipologie_pagamenti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'acconto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'saldo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'soluzione unica',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000054100

-- tipologie_periodi
-- tipologia: tabella gestita
-- verifica: 2022-05-24 11:00 Chiara GDL
INSERT INTO `tipologie_periodi` (`id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `se_corsi`, `se_tesseramenti`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	NULL,	'feste',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	NULL,	'ferie',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	NULL,	'lavoro',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	NULL,	'anno sportivo',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	NULL,	'sospensione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000054600

-- tipologie_listini
INSERT INTO `tipologie_listini` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'STANDARD',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000054601

-- tipologie_prodotti
INSERT IGNORE INTO `tipologie_prodotti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_colori`, `se_taglie`, `se_periodicita`, `se_tipologia_rinnovo`, `se_dimensioni`, `se_volume`, `se_capacita`, `se_peso`, `se_imballo`, `se_spedizione`, `se_trasporto`, `se_prodotto`, `se_servizio`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'prodotto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'servizio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	2,	NULL,	NULL,	NULL,	NULL),
(3,	1,	NULL,	'alimentare (peso)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	1,	NULL,	'alimentare (volume)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	1,	NULL,	'alimentare (pezzo)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	2,	NULL,	'didattica',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	6,	NULL,	'iscrizione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	2,	NULL,	'contratto',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(9,	8,	NULL,	'tesseramento',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(10,	8,	NULL,	'abbonamento',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	1,	NULL,	'abbigliamento',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	11,	NULL,	'maglieria',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	11,	NULL,	'caschi',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	11,	NULL,	'intimo',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	11,	NULL,	'calzature',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(16,	1,	NULL,	'meccanica (dimensioni e peso)',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000055000

-- tipologie_progetti
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `tipologie_progetti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_produzione`, `se_contratto`, `se_pacchetto`, `se_progetto`, `se_consuntivo`, `se_forfait`, `se_didattica`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'contratto',	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'pacchetto',	NULL,	NULL,	1,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'progetto',	    NULL,	NULL,	1,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'consuntivo',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'forfait',	    NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	NULL,	NULL,	'corso',	    NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

-- | 050000055400

-- tipologie_pubblicazioni
INSERT IGNORE INTO `tipologie_pubblicazioni` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_bozza`, `se_pubblicato`, `se_evidenza`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'bozza',	    NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'pubblicato',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'in evidenza',	    NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

-- | 050000055700

-- tipologie_rinnovi
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `tipologie_rinnovi` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_tesseramenti`, `se_iscrizioni`, `se_abbonamenti`, `se_licenze`, `se_contratti`, `se_progetti`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'ordinario',		NULL,	NULL,	1,	1,	1,	1,		1,		1,		NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'straordinario',	NULL,	NULL,	1,	1,	1,	1,		1,		1,		NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'ridotto',			NULL,	NULL,	1,	1,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000055800

-- tipologie_risorse
-- tipologia: tabella assistita
-- verifica: 2021-10-15 16:17 Fabio Mosti
INSERT IGNORE INTO `tipologie_risorse` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'corso',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000056200

-- tipologie_telefoni
INSERT IGNORE INTO `tipologie_telefoni` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`) VALUES
(1,	NULL,   10,     'telefono',	    '&#xf095;',     ''),
(2,	NULL,   20,     'mobile',	    '&#xf10b;',     ''),
(3,	NULL,   30,     'fax',	        '&#xf02f;',     ''),
(4,	NULL,   40,     'telefono/fax',	'&#xf1ac;',     '');

-- | 050000056600

-- tipologie_todo
-- ripristinati il 2026-09-30 dai file di base di prima del 02/03/2026
INSERT IGNORE INTO `tipologie_todo` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_agenda`, `se_ticket`, `se_ordinaria`, `se_straordinaria`, `se_commerciale`, `se_produzione`, `se_amministrazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'produzione',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'commerciale',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'amministrazione',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(4,	1,	NULL,	'sviluppo',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	1,	NULL,	'assistenza',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	1,	NULL,	'formazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	1,	NULL,	'consulenza',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	1,	NULL,	'fornitura',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	1,	NULL,	'ticket',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	2,	NULL,	'ricerca clienti',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	2,	NULL,	'customer care',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	2,	NULL,	'preventivazione',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	6,	NULL,	'recupero lezione',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	6,	NULL,	'lezione',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(16,	NULL,	NULL,	'risorse umane',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(17,	6,	NULL,	'lezione annullata',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(18,	6,	NULL,	'lezione di prova',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(19,	6,	NULL,	'open day',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(20,	NULL,	NULL,	'logistica',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000056800

-- tipologie_url
INSERT INTO `tipologie_url` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'web',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'social',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'servizi',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	1,	NULL,	'sito',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	1,	NULL,	'portale',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(6,	1,	NULL,	'e-commerce',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(7,	1,	NULL,	'blog',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(8,	1,	NULL,	'landing page',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(9,	2,	NULL,	'LinkedIn',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(10,	2,	NULL,	'Facebook',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(11,	2,	NULL,	'Twitter / X',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(12,	2,	NULL,	'Instagram',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(13,	2,	NULL,	'YouTube',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(14,	2,	NULL,	'TikTok',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(15,	3,	NULL,	'FTP',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | 050000056950

-- tipologie_zone
-- tipologia: tabella assistita
INSERT INTO `tipologie_zone` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_ecommerce`, `se_commerciale`, `se_immobiliare`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'e-commerce',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'commerciale',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'immobiliare',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

-- | 050000062000

-- udm
INSERT IGNORE INTO `udm` (`id`, `id_base`, `conversione`, `nome`, `sigla`, `note`, `se_lunghezza`, `se_volume`, `se_peso`, `se_tempo`, `se_quantita`, `se_area`) VALUES
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

-- | 050000063000

-- valute
INSERT IGNORE INTO `valute` (`id`, `iso4217`, `html_entity`, `utf8`) VALUES
(1,	'EUR',	'&#8634;',	'€');

-- | 050000100000

-- zone
INSERT INTO `zone` (`id`, `id_genitore`, `id_tipologia`, `nome`, `note`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	1,	'DEFAULT',	NULL,	NULL,	NULL,	NULL,	NULL);

-- | FINE FILE
