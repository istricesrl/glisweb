-- DATI DELLO STANDARD GLISWEB
--
-- ordine di importazione
-- 1) tabelle.sql
-- 2) placeholder.sql
-- 3) indici.sql
-- 4) dati.sql
-- 5) limiti.sql
-- 6) procedure.sql
-- 7) viste.sql
-- 8) report.sql
--

-- NOTA
-- per l'aggiornamento dei dati di comuni, provincie (unità territoriali) e regioni italiane
-- si faccia riferimento al sito dell'ISTAT e in particolare:
-- https://www.istat.it/storage/codici-unita-amministrative/Elenco-comuni-italiani.csv
-- https://www.istat.it/storage/codici-unita-amministrative/Elenco-comuni-italiani.xls

-- account
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- account_gruppi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- account_gruppi_attribuzione
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- anagrafica
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- anagrafica_categorie
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- anagrafica_ruoli
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- anagrafica_settori
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- articoli
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- assicurazioni_montaggio
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- assicurazioni_montaggio_prezzi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- assicurazioni_trasporto
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- assicurazioni_trasporto_prezzi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- attivita
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- audio
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- campagne
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- caratteristiche_immobili
-- tipologia: tabella di supporto
INSERT INTO `caratteristiche_immobili` (`id`, `nome`, `font_awesome`, `html`, `se_immobile`, `se_indirizzo`) VALUES
(1, 'balcone', 'fa-picture-o', '&#xf03e;', 1, NULL),
(2, 'giardino', 'fa-tree', '&#xf1bb;', 1, NULL),
(3, 'cantina', 'fa-key', '&#xf084;', 1, 1),
(4, 'tavernetta', 'fa-key', '&#xf084;', 1, NULL),
(5, 'ascensore', 'fa-sort', '&#xf0dc;', 1, 1),
(6, 'giardino privato', 'fa-tree', '&#xf1bb;', 1, 1),
(7, 'posto auto', 'fa-car', '&#xf1b9;', 1, 1),
(8, 'garage', 'fa-car', '&#xf1b9;', 1, 1),
(9, 'riscaldamento autonomo', 'fa-thermometer-full', '&#xf2c7;', 1, 1),
(10, 'riscaldamento centralizzato', 'fa-thermometer-half', '&#xf2c9;', 1, 1),
(11, 'arredato', 'fa-check', '&#xf00c;', 1, NULL),
(12, 'non arredato', 'fa-times', '&#xf00d;', 1, NULL),
(13, 'parzialmente arredato', 'fa-minus', '&#xf068;', 1, NULL),
(14, 'terrazza abitabile', 'fa-picture-o', '&#xf03e;', 1, NULL),
(15, 'senza riscaldamento', 'fa-thermometer-empty', '&#xf2cb;', 1, NULL),
(16, 'volendo arredato', 'fa-truck', '&#xf0d1;', 1, NULL),
(17, 'arredato solo cucina', 'fa-coffee', '&#xf0f4;', 1, NULL),
(18, 'garage doppio', 'fa-car', '&#xf1b9;', 1, 1),
(19, 'posto auto coperto', 'fa-car', '&#xf1b9;', 1, 1),
(20, 'nessun posto auto', 'fa-road', '&#xf018;', 1, 1),
(21, 'posto auto condominiale', 'fa-car', '&#xf1b9;', 1, 1),
(22, 'cucina abitabile', 'fa-coffee', '&#xf0f4;', 1, NULL),
(23, 'mansarda', 'fa-angle-up', '&#xf106;', 1, NULL),
(24, 'camino', 'fa-fire', '&#xf06d;', 1, NULL),
(25, 'angolo cottura', 'fa-coffee', '&#xf0f4;', 1, NULL),
(26, 'giardino condominiale', 'fa-tree', '&#xf1bb;', 1, 1),
(27, 'aria condizionata', 'fa-snowflake-o', '&#xf2dc;', 1, NULL),
(28, 'portineria', 'fa-user', '&#xf007;', 1, 1),
(29, 'mezzi pubblici', 'fa-bus', '&#xf207;', 1, 1),
(30, 'palazzo storico', 'fa-university', '&#xf19c;', NULL, 1),
(31, 'stile Liberty', 'fa-building', '&#xf1ad;', NULL, 1),
(32, 'pietra vista', 'fa-cubes', '&#xf1b3;', NULL, 1),
(33, 'intonaco', 'fa-clone', '&#xf24d;', NULL, 1)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ), font_awesome = VALUES( font_awesome ), html = VALUES( html ), se_immobile = VALUES( se_immobile), se_indirizzo = VALUES( se_indirizzo ) 
;

-- carrelli
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- carrelli_articoli
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- categorie_anagrafica
-- tipologia: tabella assistita
INSERT IGNORE INTO `categorie_anagrafica` (`id`, `id_genitore`, `nome`, `se_lead`, `se_prospect`, `se_cliente`, `se_fornitore`, `se_collaboratore`, `se_interno`, `se_esterno`, `se_concorrente`, `se_rassegna_stampa`, `se_azienda_gestita`, `se_produttore`, `se_dipendente`, `se_interinale`, `se_agenzia_interinale`, `se_referente` ) VALUES 
(1, NULL, 'collaboratori',      	NULL,   NULL,   NULL,   NULL,      1,      1,  NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL ),
(2, NULL, 'contatti',           	NULL,   NULL,      1,   NULL,   NULL,   NULL,     1,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL ),
(3,    2, 'clienti',            	NULL,   NULL,      1,   NULL,   NULL,   NULL,     1,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL ),
(4,    2, 'lead',                  	   1,   NULL,   NULL,   NULL,   NULL,   NULL,  NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL ),
(5,    2, 'prospect',          		NULL,      1,   NULL,   NULL,   NULL,   NULL,  NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL ),
(6, NULL, 'fornitori',          	NULL,   NULL,   NULL,      1,   NULL,   NULL,     1,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL ),
(7, NULL, 'concorrenti',        	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,  NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL ),
(8, 6, 'produttori',         		NULL,   NULL,   NULL,   NULL,   NULL,   NULL,  NULL,   NULL,   NULL,   NULL,      1,   NULL,   NULL,   NULL,   NULL ),
(9, 1, 'dipendenti',         		NULL,   NULL,   NULL,   NULL,      1,   NULL,  NULL,   NULL,   NULL,   NULL,      1,      1,   NULL,   NULL,   NULL ),
(10, 1, 'interinali',         		NULL,   NULL,   NULL,   NULL,      1,   NULL,  NULL,   NULL,   NULL,   NULL,      1,   NULL,      1,   NULL,   NULL ),
(11, 6, 'agenzie interinali',		NULL,   NULL,   NULL,   NULL,   NULL,   NULL,  NULL,   NULL,   NULL,   NULL,      1,   NULL,   NULL,   	  1,   NULL ),
(12, NULL, 'referenti',				NULL,   NULL,   NULL,   NULL,   NULL,   NULL,  NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   	  1 );

-- categorie_diritto
-- tipologia: tabella assistita
INSERT INTO `categorie_diritto` (`id`, `nome`, `id_genitore`) VALUES
(1, 'civile', NULL),
(2, 'penale', NULL),
(3, 'amministrativo', NULL),
(4, 'tributario', NULL),
(5, 'immigrazione', NULL),
(6, 'discriminazione', NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	id_genitore = VALUES( id_genitore );

-- categorie_eventi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- categorie_prodotti
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- classi_energetiche_immobili
-- tipologia: tabella di supporto
INSERT INTO `classi_energetiche_immobili` (`id`, `nome`, `ep_min`, `ep_max`, `rgb`) VALUES
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

-- colori
-- tipologia: tabella di supporto
INSERT INTO `colori` (`id`, `nome`, `hex`, `r`, `g`, `b`) VALUES
(1, 'rosso', 'ff0000', 255, 0, 0),
(3, 'bianco', 'ffffff', 255, 255, 255),
(4, 'nero', '000000', 0, 0, 0),
(5, 'blu', '0000ff', 0, 0, 255),
(6, 'verde', '00ff00', 0, 255, 0)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	r = VALUES( r ),
	g = VALUES( g ),
	b = VALUES( b ),
	hex = VALUES( hex );



-- comuni
-- tipologia: tabella di supporto
-- NOTE questa tabella va aggiornata dal sito ISTAT

-- condizioni_immobili
-- tipologia: tabella di supporto
INSERT INTO `condizioni_immobili` (`id`, `nome`) VALUES
(6, 'abitabile'),
(4, 'buono stato'),
(7, 'da ristrutturare'),
(1, 'in costruzione'),
(2, 'nuovo'),
(3, 'ottimo stato'),
(5, 'ristrutturato')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome );

-- contatti
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- contenuti
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- continenti
-- tipologia: tabella di supporto
INSERT INTO `continenti` (`id`, `codice`, `nome`) VALUES
(1, 'EU', 'Europa'),
(2, 'AF', 'Africa'),
(3, 'AS', 'Asia'),
(4, 'NA', 'Nord America'),
(5, 'AU', 'Oceania'),
(6, 'LA', 'America Latina'),
(7, 'AN', 'Antartide')
ON DUPLICATE KEY UPDATE
	codice = VALUES( codice ),
	nome = VALUES( nome );

-- cron
-- tipologia: tabella assistita
INSERT IGNORE INTO `cron` (`id`, `minuto`, `ora`, `giorno_del_mese`, `mese`, `giorno_della_settimana`, `settimana`, `task`, `iterazioni`, `timestamp_esecuzione`) VALUES
(1, NULL, NULL, NULL, NULL, NULL, NULL, '_src/_api/_task/_images.resize.php', 1, NULL),
(2, NULL, NULL, NULL, NULL, NULL, NULL, '_src/_api/_task/_mail.queue.send.php', 1, NULL),
(3, NULL, NULL, NULL, NULL, NULL, NULL, '_src/_api/_task/_sms.queue.send.php', 1, NULL),
(4,    6,    2,   26, NULL, NULL, NULL, '_src/_api/_task/_comuni.importazione.php', 1, NULL),
(5, NULL, NULL, NULL, NULL, NULL, NULL, '_src/_api/_task/_indirizzi.geocode.php', 1, NULL);

-- cron_log
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- date
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- disponibilita_immobili
-- tipologia: tabella di supporto
INSERT INTO `disponibilita_immobili` (`id`, `nome`, `se_disponibile`) VALUES
(1, 'libero', 1),
(2, 'libero alla firma', 1),
(3, 'libero al rogito', 1),
(4, 'libero entro termine', NULL),
(5, 'affittato', NULL),
(6, 'occupato', NULL),
(7, 'nuda proprietà', NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_disponibile = VALUES( se_disponibile )
;

-- documenti_amministrativi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- esigibilita_iva
-- tipologia: tabella di supporto
INSERT IGNORE INTO `esigibilita_iva` (`id`, `nome`, `codice`) VALUES
(1, 'immediata', 'I'),
(2, 'differita', 'D'),
(3, 'scissione dei pagamenti', 'S');

-- esiti_attivita
-- tipologia: tabella di supporto
INSERT INTO `esiti_attivita` (`id`, `nome`, `se_positivo`, `se_richiede_azione`) VALUES
(1, 'interessato', 1, NULL),
(2, 'non interessato', NULL, NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_positivo = VALUES( se_positivo ),
	se_richiede_azione = VALUES( se_richiede_azione )
;

-- esiti_incarichi_immobili
-- tipologia: tabella di supporto
INSERT INTO `esiti_incarichi_immobili` (`id`, `nome`, `se_positivo`) VALUES
(1, 'concluso', 1),
(2, 'scaduto', NULL),
(5, 'revocato', NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_positivo = VALUES( se_positivo )
;

-- esiti_incroci_immobili
-- tipologia: tabella di supporto
INSERT INTO `esiti_incroci_immobili` (`id`, `nome`, `se_positivo`) VALUES
(1, 'interessato', 1),
(2, 'non interessato', NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_positivo = VALUES( se_positivo )
;

-- esiti_notizie_immobili
-- tipologia: tabella di supporto
INSERT INTO `esiti_notizie_immobili` (`id`, `nome`, `se_positivo`) VALUES
(1, 'avvio trattativa', NULL),
(2, 'non interessato', NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_positivo = VALUES( se_positivo )
;

-- esiti_pratiche
-- tipologia: tabella di supporto
INSERT INTO `esiti_pratiche` (`id`, `nome`, `se_positivo`) VALUES
(1, 'archiviazione', NULL),
(2, 'conclusa', NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_positivo = VALUES( se_positivo )
;

-- esiti_richieste_immobili
-- tipologia: tabella di supporto
INSERT INTO `esiti_richieste_immobili` (`id`, `nome`, `se_positivo`) VALUES
(1, 'soddisfatta', 1),
(2, 'scaduta', NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_positivo = VALUES( se_positivo )
;

-- eventi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- eventi_anagrafica
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- eventi_categorie
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- fatturati
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- file
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- garanzie_carrelli
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- garanzie_carrelli_prezzi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- gruppi
-- tipologia: tabella assistita
INSERT IGNORE INTO `gruppi` (`id`, `nome`) VALUES
(1, 'roots'),
(2, 'staff'),
(3, 'users');

-- immagini
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- immagini_anagrafica
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- immagini_ruoli
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- immobili
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- immobili_caratteristiche
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- incarichi_immobili
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- indirizzi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- ingombri
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- iva
-- tipologia: tabella di supporto
INSERT INTO `iva` (`id`, `aliquota`, `nome`, `descrizione`, `codice`) VALUES
(1, 22.00, 'IVA 22%', 'IVA 22%', NULL),
(2, 10.00, 'IVA agevolata 10%', 'IVA agevolata 10%', NULL),
(3, 4.00, 'IVA agevolata 4%', 'IVA agevolata 4%', NULL),
(4, 0.00, 'escluso ex art. 15 d.P.R. n. 633/1972', 'operazione esclusa ai sensi dell’articolo 15 del d.P.R. n. 633/1972', 'N1'),
(5, 0.00, 'non soggetto ex art.7 d.P.R. 633/1972', 'operazione non soggetta a IVA ai sensi dell''art.7 del d.P.R. 633/1972', 'N2'),
(6, 0.00, 'non imponibile ex art. 8 d.P.R. 633/1972', 'operazione non imponibile ai sensi dell''art.8 del d.P.R. 633/1972', 'N3'),
(7, 0.00, 'fuori campo IVA ex art. 2 d.P.R. 633/1972', 'operazione non imponibile ai sensi dell''art.2 del d.P.R. 633/1972', 'N2'),
(8, 0.00, 'non soggetto ex art. 1 ll. nn. 190/2014, 208/2015 e 145/2018', 'operazione non soggetta a IVA ai sensi dell''art.1 legge 190/2014 come modificato dalla legge n. 208/2015 e dalla legge n. 145/2018', 'N2')
ON DUPLICATE KEY UPDATE
	aliquota = VALUES( aliquota ),
	nome = VALUES( nome ),
	descrizione = VALUES( descrizione ),
	codice = VALUES( codice );

-- job
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- lingue
-- tipologia: tabella di supporto
INSERT INTO `lingue` (`id`, `nome`, `note`, `iso6391alpha2`, `iso6393alpha3`, `ietf`) VALUES
(1, 'italiano', 'italiano (Italia)', 'it', 'ita', 'it-IT'),
(2, 'ceco', 'ceco (Repubblica Ceca)', 'cs', 'ces', 'cs-CZ'),
(3, 'inglese', 'inglese (Regno Unito)', 'en', 'eng', 'en-GB'),
(4, 'francese', 'francese (Francia)', 'fr', 'fra', 'fr-FR'),
(5, 'tedesco', 'tedesco (Germania)', 'de', 'deu', 'de-DE'),
(6, 'ungherese', 'ungherese (Ungheria)', 'hu', 'hun', 'hu-HU'),
(7, 'giapponese', 'giapponese (Giappone)', 'ja', 'jpn', 'ja-JP'),
(8, 'polacco', 'polacco (Polonia)', 'pl', 'pol', 'pl-PL'),
(9, 'portoghese', 'portoghese (Portogallo)', 'pt', 'por', 'pt-PT'),
(10, 'russo', 'russo (Russia)', 'ru', 'rus', 'ru-RU'),
(11, 'spagnolo', 'spagnolo (Spagna)', 'es', 'spa', 'es-ES'),
(12, 'svedese', 'svedese (Svezia)', 'sv', 'swe', 'sv-SE'),
(13, 'americano', 'inglese (Stati Uniti)', NULL, NULL, 'en-US'),
(14, 'croato', 'croato (Croazia)', 'hr', 'hrv', 'hr-HR'),
(17, 'rumeno', 'rumeno (Romania)', 'ro', 'ron', 'ro-RO')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	note = VALUES( note ),
	iso6391alpha2 = VALUES( iso6391alpha2 ),
	iso6393alpha3 = VALUES( iso6393alpha3 ),
	ietf = VALUES( ietf );
-- NOTE
-- ogni volta che si inserisce una lingua in questa tabella, vanno aggiunte:
-- - il dizionario, se manca, in /_etc/_dictionaries/
-- - la bandiera dello stato, se manca, in /_src/_img/_flags/
-- - lo stato, se manca, nella tabella stati
-- - l'associazione della lingua con lo stato nella tabella stati_lingue

-- liste_mailing
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- listini
-- tipologia: tabella assistita
INSERT IGNORE INTO `listini` (`id`, `nome`, `id_valuta`) VALUES
(1, 'STANDARD / EUR', 1);

-- listini_clienti
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- luoghi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- mail
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- mail_liste_mailing
-- tipolgia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- mail_out
-- tipolgia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- mail_sent
-- tipolgia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- mailing
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- mailing_liste
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- mailing_mail
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- marchi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- matricole
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- metadati
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- modalita_consegna
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- modalita_consegna_prezzi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- modalita_pagamento
-- tipologia: tabella assistita
INSERT INTO `modalita_pagamento` (`id`, `nome`, `suggerimento`, `importo_min`, `importo_max`, `se_contanti`, `provider`, `codice`) VALUES
(1, 'contanti', NULL, NULL, NULL, NULL, NULL, 'MP01'),
(2, 'assegno', NULL, NULL, NULL, NULL, NULL, 'MP02'),
(3, 'bonifico', NULL, NULL, NULL, NULL, NULL, 'MP05'),
(4, 'assegno circolare', NULL, NULL, NULL, NULL, NULL, 'MP03'),
(5, 'carta di credito', NULL, NULL, NULL, NULL, NULL, 'MP08'),
(6, 'ri.ba.', NULL, NULL, NULL, NULL, NULL, 'MP12'),
(7, 'bancomat', NULL, NULL, NULL, NULL, NULL, 'MP08'),
(8, 'paypal', NULL, NULL, NULL, NULL, 'paypal', 'MP08')
ON DUPLICATE KEY UPDATE nome = VALUES( nome ), suggerimento = VALUES( suggerimento ), importo_min = VALUES( importo_min ), importo_max = VALUES( importo_max ), se_contanti = VALUES( se_contanti ), provider = VALUES( provider ), codice = VALUES( codice );

-- modalita_pagamento_prezzi
-- tipologia: tabella assistita
INSERT IGNORE INTO `modalita_pagamento_prezzi` (`id`, `id_modalita`, `id_zona`, `id_categoria_prodotti`, `prezzo`, `prezzo_relativo`, `id_listino`, `id_valuta`, `id_iva`) VALUES
(1, 1, NULL, NULL, 0.00000, 0.00000, 1, 1, 1),
(2, 2, NULL, NULL, 0.00000, 0.00000, 1, 1, 1),
(3, 3, NULL, NULL, 0.00000, 0.00000, 1, 1, 1),
(4, 4, NULL, NULL, 0.00000, 0.00000, 1, 1, 1),
(5, 5, NULL, NULL, 0.00000, 0.00000, 1, 1, 1),
(5, 6, NULL, NULL, 0.00000, 0.00000, 1, 1, 1),
(6, 7, NULL, NULL, 0.00000, 0.00000, 1, 1, 1),
(7, 8, NULL, NULL, 0.00000, 0.00000, 1, 1, 1);

-- modalita_spedizione
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- modalita_spedizione_prezzi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- motivazioni_tari_anagrafica
-- tipologia: tabella di supporto
-- NOTE
-- questa tabella non ha dati standard

-- orientamenti_sessuali
-- tipologia: tabella di supporto
INSERT INTO `orientamenti_sessuali` (`id`, `nome`) VALUES
(4, 'asessuato'),
(3, 'bisessuale'),
(1, 'eterosessuale'),
(2, 'omosessuale'),
(5, 'pansessuale'),
(6, 'polisessuale')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome )
;

-- pagine
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- pagine_macro
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- pagine_menu
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- pratiche
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- pratiche_assistiti
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- pratiche_avvocati
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- prezzi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- priorita
-- tipologia: tabella assistita
INSERT IGNORE INTO `priorita` (`id`, `nome`,`ordine`) VALUES
(1, 'non urgente né importante', 100),
(2, 'non urgente importante',    200),
(3, 'urgente non importante',    300),
(4, 'urgente importante',        400);

-- prodotti
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- prodotti_categorie
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- prodotti_modalita_spedizione
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- prodotti_caratteristiche
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- prodotti_stagioni
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- progetti
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- provincie
-- tipologia: tabella di supporto
-- NOTE
-- questa tabella va aggiornata dal sito dell'ISTAT

-- rassegna_stampa
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- rassegna_stampa_anagrafica
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- rassegna_stampa_eventi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- recensioni
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- regimi_fiscali
-- tipologia: tabella gestita
INSERT INTO `regimi_fiscali` (`id`, `nome`, `codice`) VALUES
(1, 'ordinario', 'RF01')
ON DUPLICATE KEY UPDATE nome = VALUES( nome ), codice = VALUES( codice);

-- regioni
-- tipologia: tabella di supporto
-- NOTE
-- questa tabella va aggiornata dal sito dell'ISTAT

-- righe_documenti_amministrativi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- righe_fatturati
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- ruoli_anagrafica
-- tipologia: tabella di supporto
INSERT INTO `ruoli_anagrafica` (`id`, `nome`) VALUES
(1,  'titolare'),
(2,  'amministratore'),
(3,  'socio'),
(4,  'dipendente'),
(5,  'direttore'),
(6,  'presidente'),
(7,  'responsabile'),
(8,  'coordinatore'),
(9,  'vicepresidente'),
(10, 'vicedirettore')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );

-- ruoli_audio
-- tipologia: tabella di supporto
INSERT INTO `ruoli_audio` (`id`, `nome`) VALUES
(1, 'audio'),
(2, 'commento')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );

-- ruoli_eventi
-- tipologia: tabella di supporto
INSERT INTO `ruoli_eventi` (`id`, `nome`) VALUES
(1,  'ideatore'),
(2,  'autore'),
(3,  'regista'),
(4,  'attore'),
(5,  'compositore'),
(6,  'musicista'),
(7,  'scenografo'),
(8,  'montatore'),
(9,  'costumista'),
(10, 'sarto'),
(11, 'tecnico video'),
(12, 'tecnico audio'),
(13, 'tecnico'),
(14, 'direttore tecnico'),
(15, 'montatore audio'),
(16, 'montatore video'),
(17, 'tecnico luci'),
(18, 'fotografo'),
(19, 'promotore'),
(20, 'ufficio stampa'),
(21, 'produttore'),
(22, 'coproduttore'),
(23, 'traduttore'),
(24, 'regista del suono'),
(25, 'adattatore'),
(26, 'regista delle luci'),
(27, 'squadra tecnica'),
(28, 'consulente'),
(29, 'assistente'),
(30, 'altro'),
(31, 'organizzatore'),
(32, 'collaboratore produzione'),
(33, 'curatore'),
(34, 'direttore artistico')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );

-- ruoli_file
-- tipologia: tabella di supporto
INSERT INTO `ruoli_file` (`id`, `nome`) VALUES
(1, 'allegato'),
(2, 'brochure'),
(3, 'documentazione'),
(4, 'driver'),
(5, 'manualistica'),
(6, 'press kit'),
(7, 'schede tecniche'),
(8, 'software')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );

-- ruoli_immagini
-- tipologia: tabella di supporto
INSERT INTO `ruoli_immagini` (`id`, `nome`, `se_contenuti`, `se_anagrafica`, `se_immobili`, `se_catalogo`, `se_prodotti`, `ordine_scalamento`) VALUES
(1, 'intestazione'       ,    1, NULL, NULL,    1,    1,  300),
(2, 'sfondo'             ,    1, NULL, NULL, NULL, NULL,  900),
(3, 'thumbnail'          ,    1, NULL, NULL,    1,    1,  900),
(4, 'card'               ,    1, NULL, NULL,    1,    1,  200),
(5, 'media'              , NULL, NULL, NULL,    1,    1,  900),
(6, 'icona'              ,    1, NULL, NULL, NULL, NULL,  900),
(7, 'gallery'            ,    1, NULL, NULL,    1,    1,  700),
(8, 'footer'             ,    1, NULL, NULL, NULL, NULL,  900),
(9, 'contenuto'          ,    1, NULL, NULL,    1,    1,  900),
(10, 'copertina'         ,    1, NULL, NULL,    1,    1,  900),
(11, 'principale'        ,    1, NULL,    1,    1,    1,  600),
(12, 'carousel'          ,    1, NULL, NULL,    1,    1,  100),
(13, 'immagine'          ,    1,    1,    1,    1,    1,  900),
(14, 'jumbotron'         ,    1, NULL, NULL,    1,    1,  900),
(15, 'dettaglio'         , NULL, NULL, NULL,    1,    1,  900),
(16, 'anteprima'         ,    1, NULL, NULL,    1,    1,  900),
(17, 'avatar'            , NULL,    1, NULL, NULL, NULL,  900),
(18, 'logo'              , NULL,    1, NULL, NULL, NULL,  100),
(19, 'applicazione'      , NULL, NULL, NULL, NULL, NULL,  500),
(20, 'interno'           , NULL, NULL,    1, NULL, NULL,  900),
(21, 'esterno'           , NULL, NULL,    1, NULL, NULL,  900),
(25, 'campanelli'        , NULL, NULL,    1, NULL, NULL,  900),
(26, 'concorrenza'       , NULL, NULL,    1, NULL, NULL,  900),
(27, 'mappa'             , NULL, NULL,    1, NULL, NULL, NULL),
(28, 'planimetria'       , NULL, NULL,    1, NULL, NULL, NULL),
(29, 'ambientato'        , NULL, NULL,    1, NULL,    1,  400)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_contenuti = VALUES( se_contenuti ),
	se_anagrafica = VALUES( se_anagrafica ),
	se_immobili = VALUES( se_immobili ),
	se_catalogo = VALUES( se_catalogo ),
	se_prodotti = VALUES( se_prodotti ),
	ordine_scalamento = VALUES( ordine_scalamento )
;

-- ruoli_immagini_anagrafica
-- tipologia: tabella di supporto
INSERT INTO `ruoli_immagini_anagrafica` (`id`, `nome`) VALUES
(1, 'autore'),
(2, 'soggetto')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );

-- ruoli_immobili_anagrafica
-- tipologia: tabella di supporto
INSERT INTO `ruoli_immobili_anagrafica` (`id`, `nome`) VALUES
(1, 'proprietario'),
(2, 'inquilino')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );

-- ruoli_video
-- tipologia: tabella di supporto
INSERT INTO `ruoli_video` (`id`, `nome`) VALUES
(4,  'card'),
(12, 'carousel'),
(9,  'contenuto'),
(10, 'copertina'),
(8,  'footer'),
(7,  'gallery'),
(13, 'video'),
(1,  'intestazione'),
(5,  'media'),
(11, 'principale'),
(2,  'sfondo'),
(14, 'jumbotron'),
(15, 'dettaglio'),
(16, 'anteprima')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );

-- ruoli_rassegna_stampa
-- tipologia: tabella di supporto
INSERT INTO `ruoli_rassegna_stampa` (`id`, `nome`) VALUES
(1, 'autore'),
(2, 'coautore'),
(3, 'curatore'),
(4, 'intervistatore'),
(5, 'intervistato')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );

-- settori
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- caratteristiche_prodotti
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- stagioni_prodotti
-- tipologia: tabella di supporto
INSERT INTO `stagioni_prodotti` (`id`, `nome`) VALUES
(4, 'autunno'),
(2, 'estate'),
(3, 'inverno'),
(1, 'primavera')
ON DUPLICATE KEY UPDATE	nome = VALUES( nome );

-- stati
-- tipologia: tabella di supporto
INSERT INTO `stati` (`id`, `id_continente`, `iso31661alpha2`, `iso31661alpha3`, `nome`, `note`, `codice_istat`) VALUES
(1,  1, 'IT', 'ITA', 'Italia', 'Repubblica Italiana', NULL),
(2,  1, 'CZ', 'CZE', 'Repubblica Ceca', NULL, NULL),
(3,  1, 'HU', 'HUN', 'Ungheria', NULL, NULL),
(4,  3, 'JP', 'JP', 'Giappone', NULL, NULL),
(5,  1, 'PL', 'POL', 'Polonia', 'Repubblica di Polonia', NULL),
(6,  1, 'PT', 'PRT', 'Portogallo', 'Repubblica Portoghese', NULL),
(7,  1, 'RU', 'RUS', 'Russia', 'Federazione Russa', NULL),
(8,  1, 'DE', 'DEU', 'Germania', 'Repubblica Federale di Germania', NULL),
(9,  1, 'GB', 'GBR', 'Regno Unito', 'Regno Unito di Gran Bretagna e Irlanda del Nord', NULL),
(10, 4, 'US', 'USA', 'Stati Uniti d\'America', NULL, NULL),
(11, 1, 'ES', 'ESP', 'Spagna', 'Regno di Spagna', NULL),
(12, 1, 'FR', 'FRA', 'Francia', 'Repubblica Francese', NULL),
(13, 1, 'SE', 'SWE', 'Svezia', 'Regno di Svezia', NULL),
(14, 1, 'HR', 'HRV', 'Croazia', 'Repubblica di Croazia', NULL),
(15, 1, 'AL', 'ALB', 'Albania', 'Repubblica d\'Albania', NULL),
(16, 2, 'AO', 'AGO', 'Angola', 'Repubblica dell\'Angola', NULL),
(17, 4, 'AG', 'ATG', 'Antigua e Barbuda', 'Antigua e Barbuda', NULL),
(18, 3, 'SA', 'SAU', 'Arabia Saudita', 'Regno dell\'Arabia Saudita', NULL),
(19, 3, 'AM', 'ARM', 'Armenia', 'Repubblica di Armenia', NULL),
(20, 5, 'AU', 'AUS', 'Australia', 'Australia', NULL),
(21, 1, 'AT', 'AUT', 'Austria', 'Repubblica d\'Austria', NULL),
(22, 3, 'AZ', 'AZE', 'Azerbaigian', 'Repubblica dell\'Azerbaigian', NULL),
(23, 6, 'BS', 'BHS', 'Bahamas ', 'Commonwealth delle Bahamas', NULL),
(24, 3, 'BH', 'BHR', 'Bahrein', 'Regno del Bahrein', NULL),
(25, 1, 'IB', '', 'Baleari (isole)', 'isole Baleari', NULL),
(26, 3, 'BD', 'BGD', 'Bangladesh', 'Repubblica Popolare del Bangladesh', NULL),
(27, 4, 'BB', 'BRB', 'Barbados', 'Barbados', NULL),
(28, 1, 'BE', 'BEL', 'Belgio', 'Regno del Belgio', NULL),
(29, 4, 'BZ', 'BLZ', 'Belize', 'Belize', NULL),
(30, 2, 'BJ', 'BEN', 'Benin', 'Repubblica del Benin', NULL),
(31, 4, 'BM', 'BMU', 'Bermuda', 'Bermuda', NULL),
(32, 1, 'BY', 'BLR', 'Bielorussia', 'Repubblica di Bielorussia', NULL),
(33, 1, 'BA', 'BIH', 'Bosnia ed Erzegovina', 'Bosnia ed Erzegovina', NULL),
(34, 3, 'BN', 'BRN', 'Brunei', 'Stato del Brunei', NULL),
(35, 1, 'BG', 'BG3', 'Bulgaria', 'Repubblica di Bulgaria', NULL),
(36, 2, 'BF', 'BFA', 'Burkina Faso', 'Burkina Faso', NULL),
(37, 2, 'BI', 'BDI', 'Burundi', 'Repubblica del Burundi', NULL),
(38, 3, 'KH', 'KHM', 'Cambogia', 'Regno di Cambogia', NULL),
(39, 4, 'CA', 'CAN', 'Canada', 'Canada', NULL),
(40, 1, 'ES', 'CN', 'Canarie (isole)', 'Isole Canarie', NULL),
(41, 2, 'CV', 'CPV', 'Capo Verde', 'Repubblica di Capo Verde', NULL),
(42, 2, 'TD', 'TCD', 'Ciad', 'Repubblica del Ciad', NULL),
(43, 3, 'CN', 'CHN', 'Cina', 'Repubblica Popolare Cinese', NULL),
(44, 3, 'CY', 'CYP', 'Cipro', 'Repubblica di Cipro', NULL),
(45, 2, 'KM', 'COM', 'Comore', 'Unione delle Comore', NULL),
(46, 3, 'KP', 'PRK', 'Corea del Nord', 'Repubblica Popolare Democratica di Corea', NULL),
(47, 3, 'KR', 'KOR', 'Corea del Sud', 'Repubblica di Corea', NULL),
(48, 2, 'CI', 'CIV', 'Costa d\'Avorio', 'Repubblica della Costa d\'Avorio', NULL),
(49, 1, 'HR', 'HRV', 'Croazia', 'Repubblica di Croazia', NULL),
(50, 1, 'DK', 'DNK', 'Danimarca', 'Regno di Danimarca', NULL),
(51, 2, 'EG', 'EGY', 'Egitto', 'Repubblica Araba d\'Egitto', NULL),
(52, 3, 'AE', 'ARE', 'Emirati Arabi Uniti', 'Stato degli Emirati Arabi Uniti', NULL),
(53, 1, 'EE', 'EST', 'Estonia', 'Repubblica d\'Estonia', NULL),
(54, 3, 'PH', 'PHL', 'Filippine', 'Repubblica delle Filippine', NULL),
(55, 1, 'FI', 'FIN', 'Finlandia', 'Repubblica di Finlandia', NULL),
(56, 2, 'GA', 'GAB', 'Gabon', 'Repubblica Gabonese', NULL),
(57, 2, 'GM', 'GMB', 'Gambia', 'Repubblica del Gambia', NULL),
(58, 4, 'JM', 'JAM', 'Giamaica', 'Giamaica', NULL),
(59, 2, 'DJ', 'DJI', 'Gibuti', 'Repubblica di Gibuti', NULL),
(60, 3, 'JO', 'JOR', 'Giordania', 'Regno Hascemita di Giordania', NULL),
(61, 1, 'GR', 'GRC', 'Grecia', 'Repubblica Ellenica', NULL),
(62, 4, 'GD', 'GRD', 'Grenada', 'Grenada', NULL),
(63, 2, 'GW', 'GNB', 'Guinea-Bissau', 'Repubblica di Guinea-Bissau', NULL),
(64, 4, 'HT', 'HTI', 'Haiti', 'Repubblica di Haiti', NULL),
(65, 3, 'HK', 'HKG', 'Hong Kong', 'Regione amministrativa speciale di Hong Kong della Repubblica Popolare Cinese', NULL),
(66, 3, 'IN', 'IND', 'India', 'Repubblica dell\'India', NULL),
(67, 3, 'ID', 'IDN', 'Indonesia', 'Repubblica d\'Indonesia', NULL),
(68, 1, 'IE', 'IRL', 'Irlanda ', 'Repubblica d\'Irlanda', NULL),
(69, 1, 'IS', 'ISL', 'Islanda', 'Repubblica d\'Islanda', NULL),
(70, 4, 'KY', 'CYM', 'Isole Cayman', 'Isole Cayman', NULL),
(71, 3, 'IL', 'ISR', 'Israele', 'Stato d\'Israele', NULL),
(72, 3, 'KZ', 'KAZ', 'Kazakistan', 'Repubblica del Kazakistan', NULL),
(73, 3, 'KG', 'KGZ', 'Kirghizistan', 'Repubblica del Kirghizistan', NULL),
(74, 5, 'KI', 'KIR', 'Kiribati', 'Repubblica delle Kiribati', NULL),
(75, 3, 'KW', 'KWT', 'Stato del Kuwait', 'Stato del Kuwait', NULL),
(76, 3, 'LA', 'LAO', 'Laos', 'Repubblica Popolare Democratica del Laos', NULL),
(77, 4, 'LS', 'LSO', 'Lesotho', 'Regno del Lesotho', NULL),
(78, 1, 'LV', 'LVA', 'Lettonia', 'Repubblica di Lettonia', NULL),
(79, 2, 'LR', 'LBR', 'Liberia', 'Repubblica della Liberia', NULL),
(80, 1, 'LI', 'LIE', 'Liechtenstein', 'Principato del Liechtenstein', NULL),
(81, 1, 'LT', 'LTU', 'Lituania', 'Repubblica di Lituania', NULL),
(82, 1, 'LU', 'LUX', 'Lussemburgo', 'Granducato di Lussemburgo', NULL),
(83, 3, 'MO', 'MAC', 'Macao', 'Regione Amministrativa Speciale di Macao della Repubblica Popolare Cinese', NULL),
(84, 1, 'MK', 'MKD', 'Macedonia del Nord', 'Repubblica della Macedonia del Nord[', NULL),
(85, 4, 'MG', 'MDG', 'Madagascar', 'Repubblica del Madagascar', NULL),
(86, 4, 'MW', 'MWI', 'Malawi', 'Repubblica di Malawi', NULL),
(87, 3, 'MV', 'MDV', 'Maldive', 'Repubblica delle Maldive', NULL),
(88, 3, 'MY', 'MYS', 'Malaysia', 'Malaysia', NULL),
(89, 2, 'ML', 'MLI', 'Mali', 'Repubblica del Mali', NULL),
(90, 1, 'MT', 'MLT', 'Malta', 'Repubblica di Malta', NULL),
(91, 2, 'MR', 'MRT', 'Mauritania', 'Repubblica Islamica della Mauritania', NULL),
(92, 2, 'MU', 'MUS', 'Mauritius', 'Repubblica di Mauritius', NULL),
(93, 4, 'MX', 'MEX', 'Messico', 'Stati Uniti Messicani', NULL),
(94, 1,'MD', 'MDA', 'Moldavia', 'Repubblica di Moldavia', NULL),
(95, 1, 'MC', 'MCO', 'Monaco', 'Principato di Monaco', NULL),
(96, 3, 'MN', 'MNG', 'Mongolia', 'Mongolia', NULL),
(97, 2, 'NA', 'NAM', 'Namibia', 'Repubblica della Namibia', NULL),
(98, 3, 'NP', 'NPL', 'Nepal', 'Repubblica federale democratica del Nepal', NULL),
(98, 1, 'NO', 'NOR', 'Norvegia', 'Regno di Norvegia', NULL),
(99, 5, 'NZ', 'NZL', 'Nuova Zelanda', 'Nuova Zelanda', NULL),
(101, 1, 'NL', 'NLD', 'Paesi Bassi', 'Paesi Bassi', NULL),
(102, 3, 'PK', 'PAK', 'Pakistan', 'Repubblica Islamica del Pakistan', NULL),
(103, 3, 'PS', 'PSE', 'Palestina', 'Palestina', NULL),
(104, 4, 'PA', 'PAN', 'Panama', 'Repubblica di Panama', NULL),
(105, 5, 'PG', 'PNG', 'Papua Nuova Guinea', 'Stato Indipendente della Papua Nuova Guinea', NULL),
(106, 1, 'PL', 'POL', 'Polonia', 'Repubblica di Polonia', NULL),
(107, 4, 'PR', 'PRI', 'Porto Rico', 'Stato libero associato di Porto Rico', NULL),
(108, 3, 'QA', 'QAT', 'Qatar', 'Stato del Qatar', NULL),
(109, 2, 'ZA', 'ZAF', 'Repubblica del Sudafrica', 'Repubblica del Sudafrica', NULL),
(110, 1, 'RO', 'ROU', 'Romania', 'Romania', NULL),
(111, 4, 'KN', 'KNA', 'Saint Kitts e Nevis', 'Federazione di Saint Kitts e Nevis', NULL),
(112, 4, 'LC', 'LCA', 'Saint Lucia', 'Saint Lucia', NULL),
(113, 4, 'VC', 'VCT', 'Saint Vincent e Grenadine', 'Saint Vincent e Grenadine', NULL),
(114, 2, 'ST', 'STP', 'São Tomé e Príncipe', 'Repubblica Democratica di São Tomé e Príncipe', NULL),
(115, 2, 'SC', 'SYC', 'Seicelle', 'Repubblica delle Seychelles', NULL)
ON DUPLICATE KEY UPDATE id_continente = VALUES( id_continente ), iso31661alpha2 = VALUES( iso31661alpha2 ), iso31661alpha3 = VALUES( iso31661alpha3 ), nome = VALUES( nome ), note = VALUES( note ), codice_istat = VALUES( codice_istat );
-- NOTE
-- ogni volta che si inserisce una lingua in questa tabella, vanno aggiunte:
-- - la bandiera dello stato, se manca, in /_src/_img/_flags/
-- - l'associazione delle lingue con lo stato nella tabella stati_lingue

-- stati_lingue
-- tipologia: tabella di supporto
REPLACE INTO `stati_lingue` (`id_stato`, `id_lingua`) VALUES
(1,   1),
(2,   2),
(9,   3),
(12,  4),
(8,   5),
(3,   6),
(4,   7),
(5,   8),
(6,   9),
(7,  10),
(11, 11),
(13, 12),
(10, 13),
(14, 14);

-- tipologie_popup
-- tipologia: tabella di supporto
INSERT INTO `tipologie_popup` (`id`, `nome`) VALUES
(1, 'all''apertura della pagina'),
(2, 'alla chiusura della pagina'),
(3, 'dopo secondi'),
(4, 'dopo scroll')
ON DUPLICATE KEY UPDATE	nome = VALUES( nome );

-- tipologie_taglie
-- tipologia: tabella di gestita
INSERT INTO `tipologie_taglie` (`id`, `nome`) VALUES
(8, 'abbigliamento donna'),
(7, 'abbigliamento uomo'),
(6, 'cinture donna'),
(5, 'cinture uomo'),
(4, 'pantaloni donna'),
(3, 'pantaloni uomo'),
(2, 'scarpe donna'),
(1, 'scarpe uomo')
ON DUPLICATE KEY UPDATE	nome = VALUES( nome );

-- taglie
-- tipologia: tabella di supporto
INSERT INTO `taglie` (`id`, `it`, `eu`, `us`, `uk`, `fr`, `international`, `jeans`, `id_tipologia`, `cm`) VALUES
(1, '35', NULL, '5', '2', '36', NULL, NULL, 2, NULL),
(2, '35.5', NULL, '5.5', '2.5', '36.5', NULL, NULL, 2, NULL),
(3, '36', NULL, '6', '3', '37', NULL, NULL, 2, NULL),
(4, '36.5', NULL, '6.5', '4', '37.5', NULL, NULL, 2, NULL),
(5, '37', NULL, '7', '4', '38', NULL, NULL, 2, NULL),
(6, '37.5', NULL, '7.5', '4.5', '38.5', NULL, NULL, 2, NULL),
(7, '38', NULL, '8', '5', '39', NULL, NULL, 2, NULL),
(8, '38.5', NULL, '8.5', '5.5', '39.5', NULL, NULL, 2, NULL),
(9, '39', NULL, '9', '6', '40', NULL, NULL, 2, NULL),
(10, '39.5', NULL, '9.5', '6.5', '40.5', NULL, NULL, 2, NULL),
(11, '40', NULL, '10', '7', '41', NULL, NULL, 2, NULL),
(12, '40.5', NULL, '10.5', '7.5', '41.5', NULL, NULL, 2, NULL),
(13, '41', NULL, '11', '8', '42', NULL, NULL, 2, NULL),
(14, '41.5', NULL, '11.5', '8.5', '42.5', NULL, NULL, 2, NULL),
(15, '42', NULL, '12', '9', '43', NULL, NULL, 2, NULL),
(16, '39', NULL, '5.5', '5', '39', NULL, NULL, 1, NULL),
(17, '39.5', NULL, '6', '5.5', '39.5', NULL, NULL, 1, NULL),
(18, '40', NULL, '6.5', '6', '40', NULL, NULL, 1, NULL),
(19, '40.5', NULL, '7', '7.5', '40.5', NULL, NULL, 1, NULL),
(20, '41', NULL, '7.5', '8', '41', NULL, NULL, 1, NULL),
(21, '41.5', NULL, '8', '8.5', '42.5', NULL, NULL, 1, NULL),
(22, '42', NULL, '8.5', '9', '42', NULL, NULL, 1, NULL),
(23, '42.5', NULL, '9', '8', '42.5', NULL, NULL, 1, NULL),
(24, '43', NULL, '9.5', '8.5', '43', NULL, NULL, 1, NULL),
(25, '43.5', NULL, '10', '9', '43.5', NULL, NULL, 1, NULL),
(26, '44', NULL, '10.5', '9.5', '44', NULL, NULL, 1, NULL),
(27, '44.5', NULL, '11', '10', '44.5', NULL, NULL, 1, NULL),
(28, '45', NULL, '11.5', '10.5', '45', NULL, NULL, 1, NULL),
(29, '45.5', NULL, '12', '11', '45.5', NULL, NULL, 1, NULL),
(30, '46', NULL, '12.5', '11.5', '46', NULL, NULL, 1, NULL),
(31, '42', NULL, NULL, NULL, NULL, 'S', '75', 5, '90'),
(32, '44', NULL, NULL, NULL, NULL, 'S', '80', 5, '95'),
(33, '46', NULL, NULL, NULL, NULL, 'M', '85', 5, '100'),
(34, '48', NULL, NULL, NULL, NULL, 'M', '90', 5, '105'),
(35, '50', NULL, NULL, NULL, NULL, 'M', '95', 5, '110'),
(36, '52', NULL, NULL, NULL, NULL, 'M', '100', 5, '115'),
(37, '54', NULL, NULL, NULL, NULL, 'L', '105', 5, '120'),
(38, '56', NULL, NULL, NULL, NULL, 'L', '110', 5, '125'),
(39, '58', NULL, NULL, NULL, NULL, 'XXL', '115', 5, '130'),
(40, '60', NULL, NULL, NULL, NULL, 'XXL', '120', 5, '135'),
(41, '36', NULL, NULL, NULL, NULL, 'XS', '60', 6, '75'),
(42, '38', NULL, NULL, NULL, NULL, 'XS', '65', 6, '80'),
(43, '40', NULL, NULL, NULL, NULL, 'XS', '70', 6, '85'),
(44, '42', NULL, NULL, NULL, NULL, 'S', '75', 6, '90'),
(45, '44', NULL, NULL, NULL, NULL, 'S', '80', 6, '95'),
(46, '46', NULL, NULL, NULL, NULL, 'M', '85', 6, '100'),
(47, '48', NULL, NULL, NULL, NULL, 'M', '90', 6, '105'),
(48, '50', NULL, NULL, NULL, NULL, 'M', '95', 6, '110'),
(49, '52', NULL, NULL, NULL, NULL, 'M', '100', 6, '115'),
(50, '54', NULL, NULL, NULL, NULL, 'L', '105', 6, '120'),
(51, '56', NULL, NULL, NULL, NULL, 'L', '110', 6, '125'),
(52, '58', NULL, NULL, NULL, NULL, 'XXL', '115', 6, '130'),
(53, '60', NULL, NULL, NULL, NULL, 'XXL', '120', 6, '135'),
(69, '36', '30', NULL, '2', '32', 'XS', '23', 4, NULL),
(70, '38', '32', NULL, '4', '34', 'XS', '24', 4, NULL),
(71, '38', '32', NULL, '4', '34', 'XS', '25', 4, NULL),
(72, '40', '34', NULL, '6', '36', 'S', '26', 4, NULL),
(73, '40', '34', NULL, '6', '36', 'S', '27', 4, NULL),
(74, '42', '36', NULL, '8', '38', 'S', '28', 4, NULL),
(75, '42', '36', NULL, '8', '38', 'M', '29', 4, NULL),
(91, '44', '38', NULL, '10', '40', 'M', '30', 4, NULL),
(93, '44', '38', NULL, '10', '40', 'M', '31', 4, NULL),
(94, '46', '40', NULL, '12', '42', 'L', '32', 4, NULL),
(95, '46', '40', NULL, '12', '42', 'L', '33', 4, NULL),
(96, '48', '42', NULL, '14', '44', 'L', '34', 4, NULL),
(97, '50', '44', NULL, '14', '46', 'XL', '36', 4, NULL),
(98, '52', '46', NULL, '16', '48', 'XXL', '38', 4, NULL),
(99, '54', '48', NULL, '18', '50', 'XXL', '40', 4, NULL),
(100, '56', '50', NULL, '20', '52', '3XL', '42', 4, NULL),
(101, '58', '52', NULL, '22', '54', '4XL', '44', 4, NULL),
(102, '60', '54', NULL, '24', '56', '4XL', '46', 4, NULL),
(103, '62', '56', NULL, '26', '58', '5XL', '48', 4, NULL),
(104, '64', '58', NULL, '28', '60', '6XL', '50', 4, NULL),
(105, '66', '60', NULL, '30', '62', '6XL', '52', 4, NULL),
(106, '68', '62', NULL, '32', '64', '7XL', '54', 4, NULL),
(107, '70', '64', NULL, '34', '66', '8XL', '56', 4, NULL),
(108, '72', '64', NULL, '36', '68', '8XL', '58', 4, NULL),
(109, '32', '40', NULL, '30', '32', 'XXS', '23', 3, NULL),
(110, '34', '40', NULL, '30', '34', 'XXS', '24', 3, NULL),
(111, '34', '42', NULL, '32', '34', 'XS', '25', 3, NULL),
(112, '36', '42', NULL, '32', '36', 'XS', '26', 3, NULL),
(113, '36', '44', NULL, '34', '36', 'S', '27', 3, NULL),
(114, '38', '44', NULL, '34', '38', 'S', '28', 3, NULL),
(115, '38', '46', NULL, '36', '38', 'S', '29', 3, NULL),
(116, '40', '46', NULL, '36', '40', 'M', '30', 3, NULL),
(117, '40', '48', NULL, '38', '40', 'M', '31', 3, NULL),
(118, '42', '48', NULL, '38', '42', 'M', '32', 3, NULL),
(119, '42', '50', NULL, '40', '42', 'L', '33', 3, NULL),
(120, '44', NULL, '50', '40', '44', 'L', '34', 3, NULL),
(121, '46', '52', NULL, '42', '46', 'XL', '36', 3, NULL),
(122, '48', '54', NULL, '44', '48', 'XL', '38', 3, NULL),
(123, '50', '56', NULL, '46', '50', 'XXL', '40', 3, NULL),
(124, '52', '58', NULL, '48', '52', '3XL', '42', 3, NULL),
(125, '54', '60', NULL, '50', '54', '3XL', '44', 3, NULL),
(126, '56', '62', NULL, '52', '56', '4XL', '46', 3, NULL),
(127, '58', '64', NULL, '54', '58', '5XL', '48', 3, NULL),
(128, '60', '66', NULL, '56', '60', '5XL', '50', 3, NULL),
(135, '38', '32', NULL, '4', '34', 'XXS', NULL, 8, NULL),
(136, '40', '34', NULL, '6', '36', 'XS', NULL, 8, NULL),
(137, '42', '36', NULL, '8', '38', 'S', '', 8, NULL),
(138, '44', '38', NULL, '10', '40', 'M', NULL, 8, NULL),
(139, '46', '40', NULL, '12', '42', 'L', NULL, 8, NULL),
(140, '48', '42', NULL, '14', '44', 'XL', NULL, 8, NULL),
(141, '50', '44', NULL, '16', '46', 'XXL', NULL, 8, NULL),
(142, '52', '46', NULL, '18', '48', '3XL', NULL, 8, NULL),
(143, '54', '48', NULL, '20', '50', '4XL', NULL, 8, NULL),
(144, '56', '50', NULL, '22', '52', '5XL', NULL, 8, NULL),
(145, '58', '52', NULL, '24', '54', '6XL', NULL, 8, NULL),
(146, '60', '54', NULL, '26', '56', '7XL', NULL, 8, NULL),
(147, '62', '56', NULL, '28', '58', '8XL', NULL, 8, NULL),
(148, '42', '42', NULL, '32', '42', NULL, NULL, 7, NULL),
(149, '44', '44', NULL, '34', '44', NULL, NULL, 7, NULL),
(150, '46', '46', NULL, '36', '46', NULL, NULL, 7, NULL),
(151, '48', '48', NULL, '38', '48', NULL, NULL, 7, NULL),
(152, '50', '50', NULL, '40', '50', NULL, NULL, 7, NULL),
(153, '52', '52', NULL, '42', '52', NULL, NULL, 7, NULL),
(154, '54', '54', NULL, '44', '54', NULL, NULL, 7, NULL),
(155, '56', '56', NULL, '46', '56', NULL, NULL, 7, NULL),
(156, '58', '58', NULL, '48', '58', NULL, NULL, 7, NULL),
(157, '60', '60', NULL, '50', '60', NULL, NULL, 7, NULL),
(158, '62', '62', NULL, '52', '62', NULL, NULL, 7, NULL),
(159, '64', '64', NULL, '54', '64', NULL, NULL, 7, NULL),
(160, '66', '66', NULL, '56', '66', NULL, NULL, 7, NULL),
(161, '68', '68', NULL, '58', '68', NULL, NULL, 7, NULL),
(162, '70', '70', NULL, '60', '70', NULL, NULL, 7, NULL),
(163, '72', '72', NULL, '62', '72', NULL, NULL, 7, NULL),
(164, '74', '74', NULL, '64', '74', NULL, NULL, 7, NULL),
(165, '90', '90', NULL, '80', '90', NULL, NULL, 7, NULL),
(166, '94', '94', NULL, '84', '94', NULL, NULL, 7, NULL),
(167, '98', '98', NULL, '88', '98', NULL, NULL, 7, NULL),
(168, '102', '102', NULL, '92', '102', NULL, NULL, 7, NULL),
(169, '106', '106', NULL, '96', '106', NULL, NULL, 7, NULL),
(170, '110', '110', NULL, '100', '110', NULL, NULL, 7, NULL),
(171, '114', '114', NULL, '104', '114', NULL, NULL, 7, NULL)
ON DUPLICATE KEY UPDATE	it = VALUES( it ), eu = VALUES( eu ), us = VALUES( us ), uk = VALUES( uk ), fr = VALUES( fr ), cm = VALUES( cm ), international = VALUES( international ), 
id_tipologia = VALUES( id_tipologia ), jeans = VALUES( jeans );

-- tari_anagrafica
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- task
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- telefoni
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- testate
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- tipologie_anagrafica
-- tipologia: tabella assistita
INSERT INTO `tipologie_anagrafica` (`id`, `id_genitore`, `nome`) VALUES
(1, NULL, 'sig.'),
(2, NULL, 'sig.ra');

-- tipologie_attivita
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- tipologie_crm
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- tipologie_contatti
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- tipologie_contratti
-- tipologia: tabella assistita
INSERT IGNORE INTO `tipologie_contratti` (`id`, `nome`) VALUES
(1, 'dipendente'),
(2, 'collaboratore');

-- tipologie_attivta_inps
-- tipologia: tabella di supporto
INSERT IGNORE INTO `tipologie_attivita_inps` (`id`, `id_genitore`,`nome`) VALUES
(1, NULL, 'ordinario'),
(2, NULL, 'straordinario'),
(3, NULL, 'notturno');

-- tipologie_date
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- tipologie_documenti_amministrativi
-- tipologia: tabella di supporto
INSERT INTO `tipologie_documenti_amministrativi` (`id`, `nome`, `codice`, `se_fattura`, `se_nota_credito`, `se_trasporto`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_ricevuta`) VALUES
(1, 'fattura', 'TD01', 1, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'fattura accompagnatoria', 'TD01', 1, NULL, 1, NULL, NULL, NULL, NULL),
(3, 'nota di credito', 'TD04', NULL, 1, NULL, NULL, NULL, NULL, NULL),
(4, 'documento di trasporto', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL),
(5, 'nota pro forma', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL),
(6, 'offerta', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL),
(7, 'ordine', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
(8, 'ricevuta', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	codice = VALUES( codice ),
	se_fattura = VALUES( se_fattura ),
	se_nota_credito = VALUES( se_nota_credito ),
	se_trasporto = VALUES( se_trasporto ),
	se_pro_forma = VALUES( se_pro_forma ),
	se_offerta = VALUES( se_offerta );

-- tipologie_edifici
-- tipologia: tabella di supporto
INSERT INTO `tipologie_edifici` (`id`, `nome`) VALUES
(4, 'complesso'),
(6, 'edificio indipendente'),
(3, 'palazzina'),
(1, 'palazzo'),
(2, 'palazzo storico'),
(5, 'residence')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome );

-- tipologie_embed
-- tipologia: tabella di supporto
INSERT INTO `tipologie_embed` (`id`, `nome`) VALUES
(1, 'HTML5'),
(3, 'YouTube'),
(2, 'Vimeo')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome );

-- tipologie_eventi
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- tipologie_founding
-- tipologia: tabella di supporto
INSERT INTO `tipologie_founding` (`id`, `nome`) VALUES
(1, 'mutuo'),
(2, 'fondi propri')
ON DUPLICATE KEY UPDATE	nome = VALUES( nome );

-- tipologie_immobili
-- tipologia: tabella di supporto
INSERT INTO `tipologie_immobili` (`id`, `nome`, `se_residenziale`, `se_industriale`) VALUES
(1,  'appartamento', 1, NULL),
(2,  'villa', 1, NULL),
(3,  'fabbricato indipendente', 1, NULL),
(4,  'rustico', 1, NULL),
(5,  'villa a schiera', 1, NULL),
(6,  'garage', 1, NULL),
(7,  'magazzino', 1, 1),
(8,  'ufficio', NULL, 1),
(9,  'negozio', NULL, 1),
(10, 'capannone', NULL, 1),
(11, 'terreno', 1, 1)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_residenziale = VALUES( se_residenziale ),
	se_industriale = VALUES( se_industriale );

-- tipologie_incarichi_immobili
-- tipologia: tabella di supporto
INSERT INTO `tipologie_incarichi_immobili` (`id`, `nome`) VALUES
(1, 'vendita'),
(2, 'affitto')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome );

-- tipologie_indirizzi
-- tipologia: tabella di supporto
INSERT INTO `tipologie_indirizzi` (`id`, `nome`, `se_sede`, `se_operativa`, `se_abitazione`, `html`) VALUES
(1, 'sede legale', 1, NULL, NULL, '&#xf1ad;'),
(2, 'sede operativa', NULL, 1, NULL, '&#xf275;'),
(3, 'casa', NULL, NULL, 1, '&#xf015;')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_sede = VALUES( se_sede ),
	se_operativa = VALUES( se_operativa ),
	se_abitazione = VALUES( se_abitazione ),
	html = VALUES( html );

	-- tipologie_interesse
-- tipologia: tabella di supporto
INSERT INTO `tipologie_interesse` (`id`, `nome`) VALUES
(1, 'interessato'),
(2, 'non interessato') 
ON DUPLICATE KEY UPDATE	nome = VALUES( nome );

-- tipologie_motivazioni_tari
-- tipologia: tabella di supporto
INSERT INTO `tipologie_motivazioni_tari` (`id`, `nome`, `soprannome`) VALUES
(1, 'importazione ruolo TARI', 'ruolo TARI'),
(2, 'importazione dati utenze elettriche', 'utenze elettriche'),
(3, 'importazione dati utenze idriche', 'utenze idriche'),
(4, 'importazione dati utenze gas', 'utenze gas'),
(5, 'importazione dati locazioni', 'locazioni'),
(6, 'importazione studi di settore', 'studi di settore'),
(7, 'importazione dati camera di commercio', 'camera di commercio')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	soprannome = VALUES( soprannome )
;

-- tipologie_notizie
-- tipologia: tabella di supporto
INSERT INTO `tipologie_notizie` (`id`, `nome`) VALUES
(1, 'articolo'),
(2, 'blog'),
(3, 'news')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome )
;

-- tipologie_pratiche
-- tipologia: tabella di supporto
INSERT INTO `tipologie_pratiche` (`id`, `nome`) VALUES
(1, 'consulenza')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome )
;

-- tipologie_prodotti
-- tipologia: tabella di supporto
INSERT INTO `tipologie_prodotti` (`id`, `nome`, `se_colori`, `se_taglie`, `se_dimensioni`, `se_imballo`, `se_stagioni`) VALUES
(1, 'prodotti generici', NULL, NULL, NULL, NULL, NULL),
(2, 'servizi generici', NULL, NULL, NULL, NULL, NULL),
(3, 'macchine', NULL, NULL, NULL, NULL, NULL),
(4, 'servizi di traduzione', NULL, NULL, NULL, NULL, NULL),
(5, 'servizi informatici', NULL, NULL, NULL, NULL, NULL),
(6, 'lavorazioni agricole', NULL, NULL, NULL, NULL, NULL)
ON DUPLICATE KEY UPDATE nome = VALUES( nome ), se_colori = VALUES( se_colori ), se_taglie = VALUES( se_taglie ), se_dimensioni = VALUES( se_dimensioni ), se_imballo = VALUES( se_imballo ), se_stagioni = VALUES( se_stagioni );
-- NOTA ci sono righe che non hanno ragione di esistere in quanto hanno le colonne dei flag uguali
-- NOTA manca l'abbigliamento

-- tipologie_progetti
-- tipologia: tabella assistita
INSERT IGNORE INTO `tipologie_progetti` (`id`, `nome`, `se_scalare`, `se_commessa`) VALUES
(1, 'commessa', NULL, 1),
(2, 'pacchetto', 1, NULL),
(3, 'contratto', NULL, NULL),
(4, 'on demand', NULL, NULL);

-- tipologie_pubblicazione
-- tipologia: tabella di supporto
INSERT INTO `tipologie_pubblicazione` (`id`, `nome`, `ordine`, `se_bozza`, `se_pubblicato`, `se_evidenza`, `se_newsletter`, `se_secondario`, `se_incroci`, `se_suggerito`) VALUES
(1, 'bozza',         100,    1, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'pubblicato',    200, NULL,    1, NULL, NULL, NULL,    1, NULL),
(3, 'in evidenza',   300, NULL,    1,    1, NULL, NULL,    1, NULL),
(4, 'privato',       400, NULL,    1, NULL, NULL, NULL, NULL, NULL),
(5, 'suggerito',     300, NULL,    1,    1, NULL, NULL,    1,    1),
(9, 'archiviato',    900, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	ordine = VALUES( ordine ),
	se_bozza = VALUES( se_bozza ),
	se_pubblicato = VALUES( se_pubblicato ),
	se_evidenza = VALUES( se_evidenza ),
	se_newsletter = VALUES( se_newsletter ),
	se_secondario = VALUES( se_secondario ),
	se_incroci = VALUES( se_incroci ),
	se_suggerito = VALUES( se_suggerito )
;

-- tipologie_rassegna_stampa
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- tipologie_righe_documenti_amministrativi
-- tipologia: tabella di supporto
INSERT INTO `tipologie_righe_documenti_amministrativi` (`id`, `nome`, `se_fattura`, `se_pro_forma`, `se_pratica`) VALUES
(1, 'riga fattura', 1, NULL, NULL),
(2, 'riga nota pro forma', NULL, 1, NULL),
(3, 'riga pratica', NULL, NULL, 1)
ON DUPLICATE KEY UPDATE	nome = VALUES( nome ),	se_fattura = VALUES( se_fattura ), se_pro_forma = VALUES( se_pro_forma ), se_pratica = VALUES( se_pratica );

-- tipologie_soddisfazione
-- tipologia: tabella di supporto
INSERT INTO `tipologie_soddisfazione` (`id`, `nome`) VALUES
(3, 'molto soddisfatto'),
(1, 'non soddisfatto'),
(2, 'soddisfatto')
ON DUPLICATE KEY UPDATE	nome = VALUES( nome );

-- tipologie_task
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- tipologie_telefoni
-- tipologia: tabella di supporto
INSERT INTO `tipologie_telefoni` (`id`, `nome`, `html`) VALUES
(1, 'telefono', '&#xf095;'),
(2, 'mobile', '&#xf10b;'),
(3, 'fax', '&#xf02f;'),
(4, 'telefono/fax', '&#xf1ac;')
ON DUPLICATE KEY UPDATE nome = VALUES( nome ), html = VALUES( html );

-- tipologie_udm
-- tipologia: tabella di supporto
INSERT INTO `tipologie_udm` (`id`, `nome`) VALUES
(10, 'area'),
(5, 'intensità elettrica'),
(6, 'intensità luminosa'),
(1, 'lunghezza'),
(2, 'massa'),
(8, 'quantità'),
(3, 'temperatura'),
(4, 'tempo'),
(9, 'testo'),
(7, 'volume')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );

-- tipologie_vani
-- tipologia: tabella di supporto
INSERT INTO `tipologie_vani` (`id`, `nome`, `se_cucina`, `se_bagno`, `se_commerciale`, `percentuale_commerciale`) VALUES
(1, 'camera', NULL, NULL, NULL, 100.00),
(3, 'cucina', 1, NULL, NULL, 100.00),
(4, 'bagno', NULL, 1, NULL, 100.00),
(5, 'terrazzo', NULL, NULL, NULL, 35.00),
(6, 'muri', NULL, NULL, 1, 100.00),
(7, 'locale accessorio', NULL, NULL, NULL, 35.00),
(8, 'negozio', NULL, NULL, NULL, 100.00),
(9, 'laboratorio', NULL, NULL, NULL, 100.00),
(10, 'magazzino', NULL, NULL, NULL, 20.00),
(11, 'soppalco abitabile', NULL, NULL, NULL, 80.00),
(12, 'studio', NULL, NULL, NULL, 80.00),
(13, 'antibagno', NULL, NULL, NULL, 80.00),
(14, 'dispensa', NULL, NULL, NULL, 80.00)
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_cucina = VALUES( se_cucina ),
	se_bagno = VALUES( se_bagno ),
	se_commerciale = VALUES( se_commerciale ),
	percentuale_commerciale = VALUES( percentuale_commerciale )
;
-- NOTA a cosa serve il flag se_commerciale?

-- todo
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- udm
-- tipologia: tabella di supporto
INSERT INTO `udm` (`id`, `id_udm`, `id_tipologia`, `conversione`, `nome`, `soprannone`, `sigla`) VALUES
(1, NULL, 8, NULL, 'pezzi', NULL, 'pz.'),
(2, NULL, 1, NULL, 'metro', NULL, 'm'),
(3, NULL, 10, NULL, 'ettaro', NULL, 'ha'),
(4, NULL, 4, NULL, 'ora', NULL, 'h'),
(5, NULL, 2, NULL, 'quintale', NULL, 'q')
ON DUPLICATE KEY UPDATE id_udm = VALUES( id_udm ), id_tipologia = VALUES( id_tipologia ), conversione = VALUES( conversione ), nome = VALUES( nome ), sigla = VALUES( sigla );

-- valute
-- tipologia: tabella di supporto
INSERT INTO `valute` (`id`, `iso4217`, `html`, `utf8`) VALUES
(1, 'EUR', '&#8634;', '€')
ON DUPLICATE KEY UPDATE iso4217 = VALUES( iso4217 ), html = VALUES( html ), utf8 = VALUES( utf8 );

-- video
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- zone
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- zone_cap
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- zone_caratteristiche
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- zone_listini
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- zone_prezzi_spedizione
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- zone_provincie
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard

-- zone_stati
-- tipologia: tabella gestita
-- NOTE
-- questa tabella non ha dati standard
