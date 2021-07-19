INSERT INTO type_game_status (label)
VALUES 
('Non démarré'),
('En cours - temps réel'),
('En cours - partagé')
('Abandonné'),
('Clôturé');

INSERT INTO type_player (label)
VALUES 
('Créateur'),
('Joueur - via lien partagé'),
('Joueur - nouvelle tentative'),
('Joueur libre');

INSERT INTO type_user (label)
VALUES 
('Administrateur'),
('Développeur'),
('Joueur');

INSERT INTO users VALUES (1, 'Admin', 'Admin', '', 1, 0, NULL);
