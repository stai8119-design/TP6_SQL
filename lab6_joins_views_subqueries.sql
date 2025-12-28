USE bibliotheque;
SELECT e.id, a.nom, e.date_debut
FROM emprunt e
INNER JOIN abonne a 
  ON e.abonne_id = a.id;
SELECT o.titre, MAX(e.date_debut) AS dernier_emprunt
FROM ouvrage o
LEFT JOIN emprunt e 
  ON e.ouvrage_id = o.id
GROUP BY o.id, o.titre;
SELECT a.nom AS abonne, au.nom AS auteur
FROM abonne a
CROSS JOIN auteur au;
CREATE VIEW vue_emprunts_par_abonne AS
SELECT a.id, a.nom, COUNT(e.id) AS total_emprunts
FROM abonne a
LEFT JOIN emprunt e 
  ON e.abonne_id = a.id
GROUP BY a.id, a.nom;
SELECT * 
FROM vue_emprunts_par_abonne
WHERE total_emprunts > 5;
DROP VIEW vue_emprunts_par_abonne;
SELECT 
  titre,
  (SELECT COUNT(*) 
   FROM emprunt e 
   WHERE e.ouvrage_id = o.id
  ) AS nb_emprunts
FROM ouvrage o;
SELECT nom, email
FROM abonne
WHERE id IN (
  SELECT abonne_id
  FROM emprunt
  GROUP BY abonne_id
  HAVING COUNT(*) > 3
);
SELECT a.nom,
  (SELECT o.titre 
   FROM emprunt e2 
   JOIN ouvrage o ON e2.ouvrage_id = o.id
   WHERE e2.abonne_id = a.id
   ORDER BY e2.date_debut
   LIMIT 1
  ) AS premier_titre
FROM abonne a;
CREATE VIEW vue_emprunts_mensuels AS
SELECT 
  YEAR(date_debut) AS annee,
  MONTH(date_debut) AS mois,
  COUNT(*) AS total_emprunts
FROM emprunt
GROUP BY annee, mois;
SELECT v.annee, v.mois, v.total_emprunts
FROM vue_emprunts_mensuels v
WHERE v.total_emprunts = (
  SELECT MAX(total_emprunts)
  FROM vue_emprunts_mensuels
  WHERE annee = v.annee
);
-- ... (vos requêtes précédentes) ...

-- ==========================================================
-- EXERCICE 1 : Auteurs sans ouvrage (LEFT JOIN + IS NULL)
-- ==========================================================
-- On joint les auteurs aux ouvrages ; si un auteur n'a pas d'ouvrage, 
-- la colonne liée à l'ouvrage sera NULL.

SELECT au.nom, au.prenom
FROM auteur au
LEFT JOIN ouvrage o ON au.id = o.auteur_id
WHERE o.id IS NULL;


-- ==========================================================
-- EXERCICE 2 : Vue - Nombre d'abonnés uniques par mois
-- ==========================================================
-- On utilise COUNT(DISTINCT ...) pour compter les abonnés sans doublons 
-- même s'ils ont fait plusieurs emprunts dans le même mois.

CREATE VIEW vue_abonne_actifs_mensuels AS
SELECT 
    YEAR(date_debut) AS annee,
    MONTH(date_debut) AS mois,
    COUNT(DISTINCT abonne_id) AS nb_abonnes_actifs
FROM emprunt
GROUP BY annee, mois;
SELECT * FROM vue_abonne_actifs_mensuels;
SELECT 
    o.titre,
    (SELECT a.nom 
     FROM emprunt e 
     JOIN abonne a ON e.abonne_id = a.id
     WHERE e.ouvrage_id = o.id 
     ORDER BY e.date_debut DESC 
     LIMIT 1
    ) AS dernier_emprunteur
FROM ouvrage o;