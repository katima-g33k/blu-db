-- Use InnoDB engine
ALTER TABLE auteurs ENGINE=InnoDB;
ALTER TABLE caisses ENGINE=InnoDB;
ALTER TABLE commentaires ENGINE=InnoDB;
ALTER TABLE editeurs ENGINE=InnoDB;
ALTER TABLE etudiants ENGINE=InnoDB;
ALTER TABLE livres ENGINE=InnoDB;
ALTER TABLE matieres ENGINE=InnoDB;
ALTER TABLE ouvrages ENGINE=InnoDB;
ALTER TABLE ouvrages_auteurs ENGINE=InnoDB;
ALTER TABLE villes ENGINE=InnoDB;

-- Create new tables
CREATE TABLE IF NOT EXISTS employee (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(100) NOT NULL,
  password TEXT NOT NULL,
  admin BOOLEAN,
  active BOOLEAN
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS error (
  id INT PRIMARY KEY AUTO_INCREMENT,
  member INT NOT NULL,
  item INT NOT NULL,
  description TEXT NOT NULL,
  date DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS item_feed (
  member INT NOT NULL,
  item INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS news (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(140) NOT NULL,
  message TEXT NOT NULL,
  start_date DATETIME NOT NULL,
  end_date DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS phone (
  id INT PRIMARY KEY AUTO_INCREMENT,
  member INT NOT NULL,
  number VARCHAR(10) NOT NULL,
  note VARCHAR(140)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS reservation (
  id INT PRIMARY KEY AUTO_INCREMENT,
  member INT NOT NULL,
  item INT NOT NULL,
  date DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS status (
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL,
  INDEX(code(50))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS status_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  item INT NOT NULL,
  status INT NOT NULL,
  date DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS transaction (
  id INT PRIMARY KEY AUTO_INCREMENT,
  member INT NOT NULL,
  copy INT NOT NULL,
  type INT NOT NULL,
  date DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS transaction_type (
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL,
  INDEX(code(50))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS state (
  code CHAR(2) PRIMARY KEY,
  name VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

-- Add reference data
INSERT INTO transaction_type (code) VALUES
  ('ADD'),
  ('RESERVE'),
  ('SELL'),
  ('SELL_PARENT'),
  ('PAY'),
  ('DONATE'),
  ('AJUST_INVENTORY');

INSERT INTO state (code, name) VALUES
  ('AB', 'Alberta'),
  ('BC', 'Colombie Britannique'),
  ('MB', 'Manitoba'),
  ('NB', 'Nouveau-Brunswick'),
  ('NL', 'Terres Neuves et Labrador'),
  ('NS', 'Nouvelle-Écosse'),
  ('NT', 'Territoires du Nord-Ouest'),
  ('NU', 'Nunavut'),
  ('ON', 'Ontario'),
  ('PE', 'Ile du Prince Édouard'),
  ('QC', 'Québec'),
  ('SK', 'Saskatchewan'),
  ('YT', 'Yukon');

INSERT INTO status (code) VALUES
  ('VALID'),
  ('OUTDATED'),
  ('REMOVED');

INSERT INTO employee (username, password, admin, active) VALUES
  ('admin', 'blublublu', true, true);

-- Rename tables
RENAME TABLE villes TO city;
RENAME TABLE commentaires TO comment;
RENAME TABLE etudiants TO member;
RENAME TABLE livres TO copy;
RENAME TABLE matieres TO subject;
RENAME TABLE ouvrages TO item;
RENAME TABLE categories TO category;
RENAME TABLE caisses TO storage;
RENAME TABLE auteurs TO author;
RENAME TABLE ouvrages_auteurs TO item_author;

-- Atler Comment table
ALTER TABLE comment
  CHANGE idCommentaire id INT AUTO_INCREMENT,
  CHANGE idEtudiant member INT NOT NULL,
  CHANGE commentaire comment TEXT NOT NULL,
  CHANGE dateDerniereEdition updated_at DATETIME NOT NULL,
  ADD COLUMN updated_by INT DEFAULT 1 NOT NULL;

-- Alter city table
ALTER TABLE city
  CHANGE idVille id INT AUTO_INCREMENT,
  CHANGE ville name VARCHAR(100) NOT NULL,
  ADD COLUMN state CHAR(2);

-- Alter copy table
ALTER TABLE copy
  CHANGE idLivre id INT AUTO_INCREMENT,
  CHANGE idEtudiant member INT NOT NULL,
  CHANGE idOuvrage item INT NOT NULL,
  CHANGE prix price DOUBLE NOT NULL;

-- Update member data
UPDATE comment c, member m SET c.member = m.numeroDA WHERE c.member = m.idEtudiant;
UPDATE copy c, member m SET c.member = m.numeroDA WHERE c.member = m.idEtudiant;
INSERT INTO phone (member, number, note) SELECT numeroDA, numeroTelephone1, noteTelephone1
                                         FROM member
                                         WHERE numeroTelephone1 IS NOT NULL
                                         AND numeroDA IS NOT NULL;
INSERT INTO phone (member, number, note) SELECT numeroDA, numeroTelephone2, noteTelephone2
                                         FROM member
                                         WHERE numeroTelephone2 IS NOT NULL
                                         AND numeroDA IS NOT NULL;

UPDATE city SET state='AB' WHERE id IN(SELECT idVille FROM member WHERE province='Alberta');
UPDATE city SET state='BC' WHERE id IN(SELECT idVille FROM member WHERE province='Colombie-Britannique');
UPDATE city SET state='MB' WHERE id IN(SELECT idVille FROM member WHERE province='Manitoba');
UPDATE city SET state='NB' WHERE id IN(SELECT idVille FROM member WHERE province='Nouveau-Brunswick');
UPDATE city SET state='NS' WHERE id IN(SELECT idVille FROM member WHERE province='Nouvelle-Écosse');
UPDATE city SET state='ON' WHERE id IN(SELECT idVille FROM member WHERE province='Ontario');
UPDATE city SET state='QC' WHERE id IN(SELECT idVille FROM member WHERE province='Québec');
UPDATE city SET state='YT' WHERE id IN(SELECT idVille FROM member WHERE province='Yukon');

ALTER TABLE member CHANGE adressePostaleNo address VARCHAR(100);
UPDATE member SET address='' WHERE address IS NULL;
UPDATE member SET adressePostaleRue='' WHERE adressePostaleRue IS NULL;
UPDATE member SET adressePostaleApp='' WHERE adressePostaleApp IS NULL;
UPDATE member m SET address = (CONCAT(m.address, ' ',m.adressePostaleRue, ' ', m.adressePostaleApp));
UPDATE member m SET m.numeroDA=m.idEtudiant WHERE m.numeroDA IS NULL;
UPDATE member SET adresseCourriel='N/A' WHERE adresseCourriel IS NULL;

ALTER TABLE member
  CHANGE numeroDA no INT,
  CHANGE prenom first_name VARCHAR(75) NOT NULL,
  CHANGE nom last_name VARCHAR(75) NOT NULL,
  CHANGE adresseCourriel email VARCHAR(140) NOT NULL,
  CHANGE idVille city INT,
  CHANGE codePostal zip CHAR(6),
  CHANGE dateInscriptionBLU registration DATETIME NOT NULL,
  CHANGE dateDerniereActivite last_activity DATETIME NOT NULL,
  DROP COLUMN idEtudiant,
  DROP COLUMN adressePostaleRue,
  DROP COLUMN adressePostaleApp,
  DROP COLUMN province,
  DROP COLUMN numeroTelephone1,
  DROP COLUMN numeroTelephone2,
  DROP COLUMN noteTelephone1,
  DROP COLUMN noteTelephone2,
  ADD COLUMN is_parent BOOLEAN DEFAULT false;

SELECT @add := id FROM transaction_type WHERE code='ADD';
SELECT @sell := id FROM transaction_type WHERE code='SELL';
SELECT @pay := id FROM transaction_type WHERE code='PAY';

-- Copy and Transaction table
INSERT INTO transaction (member, copy, date, type) SELECT member, id, dateAjout, @add
                                                   FROM copy;
INSERT INTO transaction (member, copy, date, type) SELECT member, id, dateVente, @sell
                                                   FROM copy
                                                   WHERE dateVente IS NOT NULL;
INSERT INTO transaction (member, copy, date, type) SELECT member, id, dateRemiseArgent, @pay
                                                   FROM copy
                                                   WHERE dateRemiseArgent IS NOT NULL;

ALTER TABLE copy
  DROP COLUMN member,
  DROP COLUMN dateAjout,
  DROP COLUMN dateVente,
  DROP COLUMN dateRemiseArgent,
  DROP COLUMN estEnReservation;


-- Item table
ALTER TABLE item
  ADD COLUMN status INT NOT NULL DEFAULT 1,
  ADD COLUMN is_book BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN comment TEXT;

SELECT @valid := id FROM status WHERE code='VALID';
SELECT @outdated := id FROM status WHERE code='OUTDATED';
SELECT @removed := id FROM status WHERE code='REMOVED';

UPDATE item SET status=@removed WHERE dateRetrait IS NOT NULL;
UPDATE item SET status=@outdated WHERE dateDesuet IS NOT NULL AND dateRetrait IS NULL;
UPDATE item SET is_book=false WHERE titre='Objet générique (caculatrice, lunettes protectrices, sarau, etc.)';

INSERT INTO status_history (item, status, date) SELECT idOuvrage, status, dateAjout
                                                FROM item
                                                WHERE status=@valid;
INSERT INTO status_history (item, status, date) SELECT idOuvrage, status, dateDesuet
                                                FROM item
                                                WHERE status=@outdated;
INSERT INTO status_history (item, status, date) SELECT idOuvrage, status, dateRetrait
                                                FROM item
                                                WHERE status=@removed;

ALTER TABLE item
  CHANGE COLUMN idOuvrage id INT AUTO_INCREMENT,
  CHANGE COLUMN titre name VARCHAR(75) NOT NULL,
  CHANGE COLUMN idMatiere subject INT,
  CHANGE COLUMN anneeParution publication YEAR(4),
  CHANGE COLUMN noEdition edition TINYINT(3),
  CHANGE COLUMN idEditeur editor VARCHAR(75),
  CHANGE COLUMN EAN13 ean13 CHAR(13) UNIQUE,
  DROP COLUMN dateValidation,
  DROP COLUMN dateAjout,
  DROP COLUMN dateDesuet,
  DROP COLUMN dateRetrait,
  ADD INDEX (ean13(13));

UPDATE item i, editeurs e SET i.editor = e.nomEditeur WHERE i.editor = e.idEditeur;

-- Rename table fields
ALTER TABLE storage
  CHANGE COLUMN numeroCaisse no INT NOT NULL,
  CHANGE COLUMN idOuvrage item INT NOT NULL;

ALTER TABLE subject
  CHANGE COLUMN idMatiere id INT AUTO_INCREMENT,
  CHANGE COLUMN nomMatiere name VARCHAR(250) NOT NULL,
  CHANGE COLUMN idCategorie category INT NOT NULL;

ALTER TABLE category
  CHANGE COLUMN idCategorie id INT AUTO_INCREMENT,
  CHANGE COLUMN nomCategorie name VARCHAR(100) NOT NULL;

ALTER TABLE item_author
  CHANGE COLUMN idOuvrage item INT,
  CHANGE COLUMN idAuteur author INT,
  DROP COLUMN ordre;

ALTER TABLE author
  CHANGE COLUMN idAuteur id INT AUTO_INCREMENT,
  CHANGE COLUMN prenom first_name VARCHAR(75),
  CHANGE COLUMN nom last_name VARCHAR(75);

DELETE FROM comment WHERE member NOT IN(SELECT no FROM member);
DELETE FROM item_author WHERE item NOT IN (SELECT id FROM item);

-- Add foreign keys
ALTER TABLE city
  ADD FOREIGN KEY (state) REFERENCES state(code) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE member
  ADD FOREIGN KEY (city) REFERENCES city(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE comment
  ADD FOREIGN KEY (member) REFERENCES member(no) ON UPDATE CASCADE ON DELETE RESTRICT,
  ADD FOREIGN KEY (updated_by) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE phone
  ADD FOREIGN KEY (member) REFERENCES member(no) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE subject
  ADD FOREIGN KEY (category) REFERENCES category(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE item
  ADD FOREIGN KEY (subject) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  ADD FOREIGN KEY (status) REFERENCES status(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE status_history
  ADD FOREIGN KEY (item) REFERENCES item(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  ADD FOREIGN KEY (status) REFERENCES status(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE item_author
  ADD FOREIGN KEY (item) REFERENCES item(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  ADD FOREIGN KEY (author) REFERENCES author(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE storage
  ADD FOREIGN KEY (item) REFERENCES item(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE copy
  ADD FOREIGN KEY (item) REFERENCES item(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE transaction
  ADD FOREIGN KEY (member) REFERENCES member(no) ON UPDATE CASCADE ON DELETE RESTRICT,
  ADD FOREIGN KEY (copy) REFERENCES copy(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  ADD FOREIGN KEY (type) REFERENCES transaction_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE error
  ADD FOREIGN KEY (item) REFERENCES item(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  ADD FOREIGN KEY (member) REFERENCES member(no) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE reservation
  ADD FOREIGN KEY (item) REFERENCES item(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  ADD FOREIGN KEY (member) REFERENCES member(no) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE item_feed
  ADD FOREIGN KEY (item) REFERENCES item(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  ADD FOREIGN KEY (member) REFERENCES member(no) ON UPDATE CASCADE ON DELETE RESTRICT;

-- Delete useless tables
DROP TABLE IF EXISTS code_postaux_qc_2009;
DROP TABLE IF EXISTS securite;
DROP TABLE IF EXISTS reservations;
DROP TABLE editeurs
