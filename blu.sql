CREATE DATABASE IF NOT EXISTS blu DEFAULT CHARACTER SET utf8;
USE blu;

CREATE TABLE IF NOT EXISTS article (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
--

CREATE TABLE IF NOT EXISTS article_suivi (
  no_membre INT(9) NOT NULL,
  no_article INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS commentaire_membre (
  id INT PRIMARY KEY AUTO_INCREMENT,
  commentaire TEXT NOT NULL,
  no_membre INT(9) NOT NULL,
  date_modification DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS erreur (
  id INT PRIMARY KEY AUTO_INCREMENT,
  description TEXT NOT NULL,
  no_membre INT(9) NOT NULL,
  id_article INT NOT NULL,
  `date` DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS exemplaire (
  id INT PRIMARY KEY AUTO_INCREMENT,
  id_article INT NOT NULL,
  prix DOUBLE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS login (
id INT PRIMARY KEY AUTO_INCREMENT,
  user VARCHAR(50) NOT NULL,
  password VARCHAR(250) NOT NULL,
  key VARCHAR(250) NOT NULL,
  admin BOOLEAN DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS membre (
  no INT(9) PRIMARY KEY,
  prenom VARCHAR(75) NOT NULL,
  nom VARCHAR(75) NOT NULL,
  courriel VARCHAR(100) NOT NULL,
  inscription TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  derniere_activite TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  parent BOOLEAN DEFAULT NULL,
  no_civic INT DEFAULT NULL,
  rue VARCHAR(75) DEFAULT NULL,
  app CHAR(5) DEFAULT NULL,
  code_postal CHAR(6) DEFAULT NULL,
  id_ville INT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS nouvelle (
  id INT PRIMARY KEY AUTO_INCREMENT,
  titre VARCHAR(255) NOT NULL,
  message TEXT,
  debut DATE NOT NULL,
  fin DATE DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS propriete (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(250) NOT NULL,
  commentaire VARCHAR(140) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS propriete_article (
  id_propriete_valeur INT NOT NULL,
  id_article INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS propriete_valeur (
  id INT PRIMARY KEY AUTO_INCREMENT,
  id_propriete INT NOT NULL,
  valeur VARCHAR(140) DEFAULT NULL,
  id_association INT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS province (
  code CHAR(2) NOT NULL,
  nom VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS reservation (
  id INT PRIMARY KEY AUTO_INCREMENT,
  no_membre INT(9) NOT NULL,
  id_article INT NOT NULL,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS telephone (
  id INT PRIMARY KEY AUTO_INCREMENT,
  no_membre INT(9) DEFAULT NULL,
  numero VARCHAR(10) NOT NULL,
  note VARCHAR(140) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS transaction (
  id INT PRIMARY KEY AUTO_INCREMENT,
  id_type INT NOT NULL,
  no_membre INT(9) NOT NULL,
  id_exemplaire INT NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS type_transaction (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS ville (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(100) NOT NULL,
  code_province CHAR(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE ville
  ADD KEY code_province (code_province),
  ADD CONSTRAINT ville_fk_1 FOREIGN KEY (code_province) REFERENCES province (code);

ALTER TABLE membre
  ADD KEY id_ville (id_ville),
  ADD CONSTRAINT membre_fk_1 FOREIGN KEY (id_ville) REFERENCES ville (id);

ALTER TABLE telephone
  ADD KEY no_membre (no_membre),
  ADD CONSTRAINT telephone_fk_1 FOREIGN KEY (no_membre) REFERENCES membre (no);

ALTER TABLE commentaire_membre
  ADD KEY no_membre (no_membre),
  ADD CONSTRAINT commentaire_membre_fk_1 FOREIGN KEY (no_membre) REFERENCES membre (no);

ALTER TABLE propriete_valeur
  ADD KEY id_propriete (id_propriete),
  ADD CONSTRAINT propriete_valeur_fk_1 FOREIGN KEY (id_propriete) REFERENCES propriete (id);

ALTER TABLE propriete_article
  ADD KEY id_propriete_valeur (id_propriete_valeur),
  ADD KEY id_article (id_article),
  ADD CONSTRAINT propriete_article_fk_1 FOREIGN KEY (id_propriete_valeur) REFERENCES propriete_valeur (id),
  ADD CONSTRAINT propriete_article_fk_2 FOREIGN KEY (id_article) REFERENCES article (id);

ALTER TABLE exemplaire
  ADD KEY id_article (id_article),
  ADD CONSTRAINT exemplaire_fk_1 FOREIGN KEY (id_article) REFERENCES article (id);

ALTER TABLE transaction
  ADD KEY id_type (id_type),
  ADD KEY no_membre (no_membre),
  ADD KEY id_exemplaire (id_exemplaire),
  ADD CONSTRAINT transaction_fk_1 FOREIGN KEY (id_type) REFERENCES type_transaction (id),
  ADD CONSTRAINT transaction_fk_2 FOREIGN KEY (no_membre) REFERENCES membre (no),
  ADD CONSTRAINT transaction_fk_3 FOREIGN KEY (id_exemplaire) REFERENCES exemplaire (id);

ALTER TABLE erreur
  ADD KEY no_membre (no_membre),
  ADD KEY id_article (id_article),
  ADD CONSTRAINT erreur_ibfk_1 FOREIGN KEY (no_membre) REFERENCES membre (no),
  ADD CONSTRAINT erreur_ibfk_2 FOREIGN KEY (id_article) REFERENCES article (id);

ALTER TABLE reservation
  ADD KEY no_membre (no_membre),
  ADD KEY id_article (id_article),
  ADD CONSTRAINT reservation_ibfk_1 FOREIGN KEY (no_membre) REFERENCES membre (no),
  ADD CONSTRAINT reservation_ibfk_2 FOREIGN KEY (id_article) REFERENCES article (id);

INSERT INTO propriete (id, nom, commentaire) VALUES
  (1, 'auteur_prenom', 'Le prénom de l''auteur d''un ouvrage'),
  (2, 'auteur_nom', 'le nom de l''auteur d''un ouvrage'),
  (3, 'categorie', 'La catégorie d''un ouvrage'),
  (4, 'editeur', 'Le nom de l''éditeur d''un livre'),
  (5, 'titre', 'Le titre d''un ouvrage'),
  (6, 'parution', 'La date de parution d''un ouvrage (année ex: 2000)'),
  (7, 'no_edition', 'Le numéro d''édition d''un ouvrage'),
  (8, 'ean13', 'Le code bar d''un livre'),
  (9, 'date_ajout', 'La date d''ajout d''un ouvrage (format: aaaa-mm-jj)'),
  (10, 'date_desuet', 'La date à laquelle un ouvrage tombe désuet'),
  (11, 'date_retrait', 'La date à laquelle un ou un ouvrage est retiré');

INSERT INTO type_transaction (id, nom) VALUES
  (1, 'depot'),
  (2, 'reprise'),
  (3, 'vente'),
  (4, 'remboursement'),
  (5, 'remiseArgent'),
  (6, 'reservation'),
  (7, 'annulationReservation');
