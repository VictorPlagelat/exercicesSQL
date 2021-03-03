 -- exemple
SELECT nom , titre_representation , tarif
FROM musicien, representation, programmer
WHERE musicien.numero_representation = representation.numero_representation
AND programmer.numero_representation = representation.numero_representation

-- exercice 1

-- a) Donner la liste des titres des représentations
SELECT titre_representation
FROM representation



-- b) Donner la liste des titres des représentations ayant lieu à l'opéra Bastille
SELECT titre_representation
FROM representation r -- "r" est un "alias" et permet d'identifier une table de manière plus courte uniquement dans la requête dans laquelle on travaille
WHERE r.Lieu = 'opéra Bastille'


-- c) Donner la liste des noms des musiciens et des titres des représentations auxquelles ils participent


SELECT nom, titre_representation
FROM musicien, representation
WHERE musicien.numero_representation = representation.numero_representation



-- d) Donner la liste des titres des représentations, les lieux et les tarifs pour la journée du 21/05/2021.

SELECT titre_representation, lieu, tarif, DATE
FROM representation, programmer
WHERE representation.numero_representation = programmer.numero_representation
AND programmer.date = '2021-05-21'





-- Exercice 2

-- a) Quel est le nombre total d'étudiants ?

SELECT COUNT(numero_etudiant)
FROM etudiant


-- b) Quelles sont, parmi l'ensemble des notes, la note la plus haute et la note la plus basse ?
SELECT MIN(note), MAX(note)
FROM evaluation


-- c) Quelles sont les moyennes de chaque étudiant dans chacune des matières ? (utilisez
-- CREATE VIEW)
-- sans create view
CREATE VIEW moyenne AS
SELECT AVG(note), numero_etudiant, codemat
FROM evaluation
GROUP BY numero_etudiant, codemat

SELECT CONCAT(nom, " ", prenom) AS identite, libellemat, ROUND(moy_etu_mat,2) AS moy
FROM moyenne m, matiere ma, etudiant e
WHERE m.idEtu = e.numero_etudiant
AND ma.codemat = m.mat
ORDER BY identite ASC, ma.libellemat

-- d) Quelles sont les moyennes par matière ? (cf. question c)



SELECT libellemat, ROUND (AVG(moy_etu_mat),2) AS moy
FROM matiere ma, moyenne m
WHERE ma.codemat = m.mat
GROUP BY m.mat

SELECT AVG(note), codemat
FROM evaluation
GROUP BY codemat

-- e) Quelle est la moyenne générale de chaque étudiant ? (utilisez CREATE VIEW + cf. question
-- 3)

CREATE VIEW moygen AS
SELECT CONCAT (nom, " ", prenom) AS identite, ROUND(SUM(m.moy_etu_mat * ma.coeffmat)/ SUM(ma.coeffmat),2) AS moy_gen_etu
FROM moyenne m, matiere ma, etudiant e
WHERE m.mat = ma.codemat
AND e.numero_etudiant = m.idEtu
GROUP BY identite
ORDER BY moy_gen_etu desc

SELECT identite, moy_gen_etu
FROM moygen
ORDER BY moy_gen_etu desc

-- f) Quelle est la moyenne générale de la promotion ? (cf. question e)

SELECT AVG(moy_gen_etu)
FROM moygen


-- g) Quels sont les étudiants qui ont une moyenne générale supérieure ou égale à la moyenne
-- générale de la promotion ? (cf. question e)

SELECT identite, moy_gen_etu
FROM moygen
WHERE moy_gen_etu >= (SELECT AVG(moy_gen_etu)
					  FROM moygen)



-- Exercice 3
-- a) Numéros et libellés des articles dont le stock est inférieur à 10 ?

SELECT libelle, stock
FROM article
WHERE article.stock < 10




-- b) Liste des articles dont le prix d'inventaire est compris entre 100 et 300 ?

SELECT libelle, prixInvent
FROM article
WHERE article.prixInvent 100 AND 300




-- c) Liste des fournisseurs dont on ne connaît pas l'adresse ?


SELECT *
FROM fournisseur
WHERE adrFour IS NULL






-- d) Liste des fournisseurs dont le nom commence par "IKE" ?


SELECT *
FROM fournisseur
WHERE nomFour LIKE 'IKE%' -- '%EA'    '%KE%'



-- e) Noms et adresses des fournisseurs qui proposent des articles pour lesquels le délai
-- d'approvisionnement est supérieur à 20 jours ?

SELECT nomFour, adrFour
FROM acheter, fournisseur
WHERE acheter.delai > 20
AND acheter.noFour = fournisseur.noFour



-- f) Nombre d'articles référencés ?

SELECT count(noArt)
FROM article

SELECT COUNT(*) AS nbArt
FROM article

-- g) Valeur du stock ?


SELECT SUM(prixInvent*stock) AS valeurStock
FROM article



-- h) Numéros et libellés des articles triés dans l'ordre décroissant des stocks ?


SELECT noArt, libelle, stock
FROM article
ORDER  BY stock DESC




-- i) Liste pour chaque article (numéro et libellé) du prix d'achat maximum, minimum et moyen
-- ?

SELECT a.noArt, libelle, MAX(prixAchat) AS prixMax, MIN(prixAchat) AS prixMin, AVG(prixAchat) AS prixMoyen
FROM article a, acheter ac
WHERE a.noArt = ac.noArt
GROUP BY libelle, a.noArt


-- j) Délai moyen pour chaque fournisseur proposant au moins 2 articles ?

SELECT AVG(delai), nomFour
FROM acheter a, fournisseur f
WHERE a.noFour = f.noFour 
GROUP BY nomFour
HAVING COUNT(a.noFour) > 1


-- exercice 4



-- a) Liste de tous les étudiants

SELECT *
FROM etudiant


-- b) Liste de tous les étudiants, classée par ordre alphabétique inverse

SELECT *
FROM etudiant
ORDER BY nom DESC


-- c) Libellé et coefficient (exprimé en pourcentage) de chaque matière

SELECT libelle, ROUND(coef*100/17, 2)

FROM matiere


-- d) Nom et prénom de chaque étudiant


SELECT nom, prenom
FROM etudiant




-- e) Nom et prénom des étudiants domiciliés à Colmar


SELECT nom, prenom
FROM etudiant
WHERE ville = 'Colmar'





-- f) Liste des notes supérieures ou égales à 10

SELECT note
FROM notation
WHERE note >= 10


-- g) Liste des épreuves dont la date se situe entre le 1er janvier et le 30 juin 2020

SELECT *
FROM epreuve e
WHERE datepreuve BETWEEN '2020/01/01' AND '2020/06/30'


-- h) Nom, prénom et ville des étudiants dont la ville contient la chaîne "Cha" (Cha)

SELECT nom, prenom, ville
FROM etudiant e
WHERE e.ville LIKE '%Cha%'




-- i) Prénoms des étudiants de nom Aldrine, Mozby ou Stimson

SELECT prenom
FROM etudiant e
WHERE e.nom IN ('Aldrine', 'Mozby', 'Stimson')



-- j) Somme des coefficients de toutes les matières

SELECT SUM(coef)
FROM matiere 

-- k) Nombre total d'épreuves

SELECT COUNT(*)
FROM epreuve

-- l) Nombre de notes indéterminées (NULL)

SELECT count(*)
FROM notation
WHERE note IS NULL





-- m) Liste des épreuves (numéro, date et lieu) incluant le libellé de la matière

SELECT CONCAT ( numepreuve, "    ", datepreuve, "    ", lieu) AS idEpreuve, libelle
FROM epreuve e, matiere m
WHERE e.codemat = m.codemat




-- n) Liste des notes en précisant pour chacune le nom et le prénom de l'étudiant qui l'a
-- obtenue

SELECT nom, prenom, note
FROM etudiant e, notation n
WHERE e.numetu = n.numetu


-- o) Liste des notes en précisant pour chacune le nom et le prénom de l'étudiant qui l'a
-- obtenue et le libellé de la matière concernée

SELECT nom, prenom, note, libelle
FROM etudiant e, notation n, matiere m, epreuve v
WHERE e.numetu = n.numetu
AND n.numepreuve = v.numepreuve
AND m.codemat = v.codemat

-- p) Nom et prénom des étudiants qui ont obtenu au moins une note égale à 20

SELECT nom, prenom
FROM etudiant e, notation n
WHERE e.numetu = n.numetu
AND note = 20

-- q) Moyennes des notes de chaque étudiant (indiquer le nom et le prénom)

SELECT nom, prenom, AVG(note)
FROM etudiant e, notation n
WHERE e.numetu = n.numetu
GROUP BY nom, prenom

-- r) Moyennes des notes de chaque étudiant (indiquer le nom et le prénom), classées de la
-- meilleure à la moins bonne

SELECT nom, prenom, AVG(note)
FROM etudiant e, notation n
WHERE e.numetu = n.numetu
GROUP BY nom, prenom
ORDER BY AVG(note) desc

-- s) Moyennes des notes pour les matières (indiquer le libellé) comportant plus d'une épreuve


SELECT ROUND(AVG(note),2), libelle
FROM notation n, matiere m, epreuve e
WHERE m.codemat = e.codemat 
AND e.numepreuve = n.numepreuve
GROUP BY libelle
HAVING COUNT(DISTINCT e.numepreuve) > 1  -- DISTINCT évite les doublons 




-- t) Moyennes des notes obtenues aux épreuves (indiquer le numéro d'épreuve) où moins de 6
-- étudiants ont été notés

SELECT ROUND(AVG(note),2), numepreuve
FROM notation n
WHERE note IS NOT NULL -- nécessaire pour ne pas fausser l'avg
GROUP BY numepreuve  -- ET pour ne pas quelles comptent dans le having count
HAVING COUNT(*)<6

	-- exercice 5	
-- a) Ajouter un nouveau fournisseur avec les attributs de votre choix

INSERT INTO fournisseur
VALUES ('4', 'Fourni4', 'sous-traitant', 'Orléans')


-- b) Supprimer tous les produits de couleur noire et de numéros compris entre 1 et 3

DELETE FROM produit p

WHERE Couleur = 'noir'
AND p.NumP BETWEEN 1 AND 3




-- c) Changer la ville du fournisseur 3 par Mulhouse

UPDATE fournisseur
SET VilleF = 'Mulhouse'
WHERE NomF = 'Fourni3'