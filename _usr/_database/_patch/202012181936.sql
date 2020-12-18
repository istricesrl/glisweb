INSERT INTO `tipologie_durate_inps` (id, nome) VALUES 
('D', 'Tempo determinato'),
('I', 'Tempo indeterminato'),
('S', 'Stagionale')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome )
;