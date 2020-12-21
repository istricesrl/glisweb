INSERT INTO `tipologie_qualifiche_inps` (id, nome) VALUES 
('1', 'Operaio'),
('O', 'Operaio part-time'),
('2', 'Impiegato'),
('5', 'Apprendista')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome )
;