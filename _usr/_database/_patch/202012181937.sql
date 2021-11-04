INSERT INTO `tipologie_orari_inps` (id, nome) VALUES 
('F', 'Full-time'),
('P', 'Part-time')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome )
;