-- 1) Nombre de gaulois par lieu (trié par nombre de gaulois décroissant)

SELECT COUNT(ID_VILLAGEOIS), NOM_LIEU
FROM villageois v, lieu l
WHERE v.ID_LIEU = l.ID_LIEU
GROUP BY NOM_LIEU
ORDER BY COUNT(ID_VILLAGEOIS) DESC

-- 2) Nom des gaulois + spécialité + village

SELECT NOM, NOM_SPECIALITE, NOM_LIEU
FROM lieu l, villageois v, specialite s
WHERE v.ID_LIEU = l.ID_LIEU
AND v.ID_SPECIALITE = s.ID_SPECIALITE



-- 3) Nom des spécialités avec nombre de gaulois par spécialité (trié par nombre de gaulois
-- décroissant)

SELECT COUNT(s.ID_SPECIALITE), NOM_SPECIALITE
FROM villageois v, specialite s
WHERE v.ID_SPECIALITE = s.ID_SPECIALITE
GROUP BY  NOM_SPECIALITE
ORDER BY COUNT(s.ID_SPECIALITE) DESC



-- 4) Nom des batailles + lieu de la plus récente à la plus ancienne (dates au format jj/mm/aaaa)

SELECT NOM_BATAILLE, NOM_LIEU, DATE_FORMAT(DATE_BATAILLE, "%d/%m/%Y")
FROM bataille b, lieu l
WHERE b.ID_LIEU = l.ID_LIEU
ORDER BY DATE_BATAILLE DESC


-- 5) Nom des potions + coût de réalisation de la potion (trié par coût décroissant)

SELECT NOM_POTION, SUM(ID_INGREDIENT*QTE)
FROM compose c, potion p
WHERE c.ID_POTION = p.ID_POTION
GROUP BY NOM_POTION


-- 6) Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Potion V'

SELECT NOM_INGREDIENT, COUT_INGREDIENT, QTE, (COUT_INGREDIENT*QTE) AS Totale, NOM_POTION
FROM compose c, ingredient i, potion p
WHERE c.ID_INGREDIENT = i.ID_INGREDIENT
AND p.ID_POTION = c.ID_POTION
AND NOM_POTION = 'Potion V'





-- 7) Nom du ou des villageois qui ont pris le plus de casques dans la bataille 'Babaorum'


SELECT NOM, MAX(QTE)
FROM villageois v, prise_casque pc
WHERE v.ID_VILLAGEOIS =pc.ID_VILLAGEOIS



-- 8) Nom des villageois et la quantité de potion bue (en les classant du plus grand buveur au plus
-- petit)

SELECT NOM, DOSE
FROM boit b, villageois v
WHERE b.ID_VILLAGEOIS = v.ID_VILLAGEOIS
ORDER BY DOSE DESC


-- 9) Nom de la bataille où le nombre de casques pris a été le plus important

CREATE VIEW totalcasque AS
SELECT NOM_BATAILLE, SUM(QTE) AS totale
FROM prise_casque pc, bataille b
WHERE b.ID_BATAILLE = pc.ID_BATAILLE
GROUP BY NOM_BATAILLE

SELECT NOM_BATAILLE,MAX(totale)
FROM totalcasque


-- 10) Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre
-- décroissant)

SELECT NOM_TYPE_CASQUE, COUNT(c.ID_TYPE_CASQUE), SUM(COUT_CASQUE)
FROM type_casque tc, casque c
WHERE c.ID_TYPE_CASQUE = tc.ID_TYPE_CASQUE
GROUP BY NOM_TYPE_CASQUE




-- 11) Noms des potions dont un des ingrédients est la cerise

SELECT NOM_POTION
FROM potion p, ingredient i, compose c
WHERE p.ID_POTION = c.ID_POTION
AND c.ID_INGREDIENT = i.ID_INGREDIENT
AND NOM_INGREDIENT = 'cerise'


-- 12) Nom du / des village(s) possédant le plus d'habitants

CREATE VIEW Population AS
SELECT NOM_LIEU, COUNT(ID_VILLAGEOIS) AS TOTAL_HABITANT
FROM lieu l, villageois v
WHERE l.ID_LIEU=v.ID_LIEU
GROUP BY NOM_LIEU

SELECT NOM_LIEU, MAX(TOTAL_HABITANT)
FROM population
-- M'affiche "3e chene a droite de la carriere" au lieu du village.... alors que quand je
--trie mon TOTAL-HABITANT en DESC, la première valeur est bien le " Village gaulois"....



-- 13) Noms des villageois qui n'ont jamais bu de potion

SELECT DISTINCT ID_VILLAGEOIS, NOM
FROM villageois 
LEFT JOIN boit b USING(ID_VILLAGEOIS)
WHERE b.ID_VILLAGEOIS IS NULL


-- SELECT DISTINCT v.ID_VILLAGEOIS, NOM
-- FROM villageois v
-- WHERE v.ID_VILLAGEOIS IN (
-- 	SELECT DISTINCT b.ID_VILLAGEOIS
-- 	FROM boit b)

-- affiche liste des villageois ayant bu de la potion


-- pas moyen de faire une sous requête ? vu que "except" et "minus" marchent pas


-- 14) Noms des villages qui contiennent la particule 'um'

SELECT NOM
FROM villageois 
WHERE NOM LIKE '%um%'




-- 15) Nom du / des villageois qui n'ont pas le droit de boire la potion 'Rajeunissement II


SELECT NOM
FROM potion p, peut pe, villageois v
WHERE v.ID_VILLAGEOIS=pe.ID_VILLAGEOIS
AND pe.ID_POTION=p.ID_POTION
AND NOM_POTION= 'Rajeunissement II'
AND A_LE_DROIT = 0