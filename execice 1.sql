CREATE DATABASE universite CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE universite;
CREATE TABLE ETUDIANT (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE PROFESSEUR (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    departement VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE COURS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    credits INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE ENSEIGNEMENT (
    cours_id INT,
    professeur_id INT,
    semestre VARCHAR(20),
    PRIMARY KEY (cours_id, professeur_id, semestre),
    FOREIGN KEY (cours_id) REFERENCES COURS(id) ON DELETE CASCADE,
    FOREIGN KEY (professeur_id) REFERENCES PROFESSEUR(id) ON DELETE SET NULL -- (Réponse B.1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE INSCRIPTION (
    etudiant_id INT,
    enseignement_id_ref_cours INT, -- Note: simplification pour la FK composée si besoin
    enseignement_id_ref_prof INT,
    enseignement_semestre VARCHAR(20),
    date_inscription DATE NOT NULL,
    PRIMARY KEY (etudiant_id, enseignement_id_ref_cours, enseignement_id_ref_prof, enseignement_semestre),
    FOREIGN KEY (etudiant_id) REFERENCES ETUDIANT(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE EXAMEN (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inscription_etudiant_id INT,
    date_examen DATE NOT NULL,
    score DECIMAL(4,2),
    CONSTRAINT chk_score CHECK (score BETWEEN 0 AND 20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO PROFESSEUR (nom, email, departement) VALUES 
('Jean Dupont', 'j.dupont@univ.fr', 'Informatique'),
('Marie Curie', 'm.curie@univ.fr', 'Physique');
INSERT INTO COURS (titre, code, credits) VALUES 
('Intro SQL', 'CS101', 6),
('Algorithmique', 'CS102', 4),
('Physique Quantique', 'PH201', 8);
INSERT INTO ETUDIANT (nom, email) VALUES 
('Alice', 'alice@student.fr'),
('Bob', 'bob@student.fr');
INSERT INTO EXAMEN (score, date_examen) VALUES (25, '2025-06-18');
SELECT e.nom 
FROM ETUDIANT e
JOIN INSCRIPTION i ON e.id = i.etudiant_id
JOIN COURS c ON i.enseignement_id_ref_cours = c.id
WHERE c.code = 'CS101';
SELECT nom, email FROM PROFESSEUR WHERE departement = 'Informatique';
SELECT * FROM INSCRIPTION i
JOIN ETUDIANT e ON i.etudiant_id = e.id
WHERE e.nom = 'Alice'
ORDER BY date_inscription DESC;
SELECT et.nom, c.titre, ens.semestre, i.date_inscription
FROM INSCRIPTION i
JOIN ETUDIANT et ON i.etudiant_id = et.id
JOIN COURS c ON i.enseignement_id_ref_cours = c.id;
SELECT nom, 
  (SELECT COUNT(*) FROM INSCRIPTION i WHERE i.etudiant_id = e.id) AS nb_inscriptions
FROM ETUDIANT e;
CREATE VIEW vue_etudiant_charges AS
SELECT e.nom, COUNT(i.etudiant_id) as nb_inscr, SUM(c.credits) as total_credits
FROM ETUDIANT e
LEFT JOIN INSCRIPTION i ON e.id = i.etudiant_id
LEFT JOIN COURS c ON i.enseignement_id_ref_cours = c.id
GROUP BY e.id, e.nom;
SELECT c.titre, COUNT(i.etudiant_id) 
FROM COURS c
LEFT JOIN INSCRIPTION i ON c.id = i.enseignement_id_ref_cours
GROUP BY c.id;
SELECT enseignement_semestre, ROUND(AVG(score), 2) as moyenne
FROM EXAMEN
GROUP BY enseignement_semestre;
ALTER TABLE EXAMEN ADD COLUMN commentaire TEXT;