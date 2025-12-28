SELECT 
    et.nom AS nom_etudiant, 
    c.titre AS titre_cours, 
    ex.date_examen, 
    ex.score
FROM EXAMEN ex
INNER JOIN INSCRIPTION i ON ex.inscription_id = i.id
INNER JOIN ETUDIANT et ON i.etudiant_id = et.id
INNER JOIN ENSEIGNEMENT ens ON i.enseignement_id = ens.id
INNER JOIN COURS c ON ens.cours_id = c.id;
SELECT 
    et.nom, 
    COUNT(ex.id) AS total_examens
FROM ETUDIANT et
LEFT JOIN INSCRIPTION i ON et.id = i.etudiant_id
LEFT JOIN EXAMEN ex ON i.id = ex.inscription_id
GROUP BY et.id, et.nom;
SELECT 
    c.titre, 
    COUNT(i.etudiant_id) AS nb_etudiants_inscrits
FROM INSCRIPTION i
RIGHT JOIN ENSEIGNEMENT ens ON i.enseignement_id = ens.id
RIGHT JOIN COURS c ON ens.cours_id = c.id
GROUP BY c.id, c.titre;
SELECT 
    et.nom AS etudiant, 
    p.nom AS professeur
FROM ETUDIANT et
CROSS JOIN PROFESSEUR p
LIMIT 20;
CREATE VIEW vue_performances AS
SELECT 
    et.id AS etudiant_id, 
    et.nom, 
    AVG(ex.score) AS moyenne_score
FROM ETUDIANT et
LEFT JOIN INSCRIPTION i ON et.id = i.etudiant_id
LEFT JOIN EXAMEN ex ON i.id = ex.inscription_id
GROUP BY et.id, et.nom;
WITH top_cours AS (
    SELECT 
        c.id AS cours_id,
        c.titre,
        c.credits,
        AVG(ex.score) AS moyenne_globale
    FROM COURS c
    JOIN ENSEIGNEMENT ens ON c.id = ens.cours_id
    JOIN INSCRIPTION i ON ens.id = i.enseignement_id
    JOIN EXAMEN ex ON i.id = ex.inscription_id
    GROUP BY c.id, c.titre, c.credits
    ORDER BY moyenne_globale DESC
    LIMIT 3
)
SELECT titre, credits, moyenne_globale
FROM top_cours;