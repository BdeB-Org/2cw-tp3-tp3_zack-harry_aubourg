-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom:  Zack-Harry Aubourg                      Votre DA:  2144434
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_OUTIL;
desc outils_emprunt;
desc outils_usager;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
select Prenom ||' '|| nom_famille AS "nom_usagers"
from outils_usager;


-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT DISTINCT (ville)
FROM outils_usager
ORDER BY 1;
-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
select * 
from outils_outil
order by 2,1;
-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
select num_emprunt AS Emprunt_non_retourne 
from outils_emprunt
where date_retour IS NULL;
-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
select num_emprunt AS Emprunt_fait_avant_2014 
from outils_emprunt
where EXTRACT (Year from TO_DATE(Date_emprunt,'yy-mm-dd')) < 2014;
-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
select nom AS nom , code_outil  AS code
from outils_outil
where caracteristiques LIKE '%j%';
-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
select nom AS nom , code_outil  AS code
from outils_outil
where Fabricant ='Stanley' ;
-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
select  nom AS nom, fabricant  AS fabricant
from outils_outil
where annee BETWEEN 2006 AND 2008;
-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3
select code_outil  AS code,nom AS nom
from outils_outil
where caracteristiques not like '%20 volt%';
-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
select count (*)AS "Nombre outils"
from outils_outil
where fabricant != 'Makita';
-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5

select us.Prenom ||' '|| us.nom_famille AS "Nom usager complet",
em.num_emprunt AS "Numero Emprunt" ,
case when ( em.date_retour IS NOT NULL) THEN em.date_retour - em.date_emprunt end AS "Duree emprunt",
ou.prix AS "Prix"
from outils_usager us
join outils_emprunt em on us.num_usager = em.num_usager
join outils_outil ou on em.code_outil = ou.code_outil
where us.ville IN ('Vancouver','Regina') and
      em.date_retour IS NOT NULL and
      ou.prix IS NOT NULL
      ;

      
-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
select ou.nom AS "nom outils", em.code_outil AS "code outils emprunt?"
from outils_emprunt em,outils_outil ou
where em.code_outil = ou.code_outil   and
date_retour is null;


-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
select us.Prenom ||' '|| us.nom_famille AS "Nom usager complet", courriel AS "code outils emprunts"
from outils_usager us
where  us.num_usager NOT IN (select num_usager
                             from outils_emprunt);
-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
select ou.code_outil AS "Code outil", prix AS "valeur"
from outils_outil ou
Left join outils_emprunt em
on em.code_outil = ou.code_outil 
WHERE prix is not null;


-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
select nom AS "nom outils", prix AS "prix outils"
from outils_outil 
where fabricant = 'Makita' and
prix >( select ROUND (AVG(prix)) from outils_outil where prix is not null );

-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
select us.nom_famille ||' '|| us.Prenom  AS "Nom usager complet",
       us.adresse AS "Adresse usager", 
       ou.nom AS "Nom outil", 
       ou.code_outil AS "Code outil"
from outils_usager us, 
     outils_emprunt em, 
     outils_outil ou
where us.num_usager = em.num_usager   and
      em.code_outil = ou.code_outil   and
      EXTRACT (Year from TO_DATE(Date_emprunt,'yy-mm-dd')) > 2014
      order by 1 ;
-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4

Select ou.nom AS "Nom", ou.prix AS "Prix"
from outils_outil ou
join outils_emprunt em on ou.code_outil = em.code_outil
group by ou.nom, ou.prix
having count(em.code_emprunt) > 1 ;

-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure

Select us.nom_famille   AS "Nom usager",
       us.adresse AS "Adresse usager", 
       us.ville AS "Ville"

from outils_usager us

join outils_emprunt em on us.num_usager = em.num_usager;
--  IN

select us.nom_famille   AS "Nom usager",
       us.adresse AS "Adresse usager", 
       us.ville AS "Ville"
       
from outils_usager us
     
where us.num_usager IN (select num_usager from outils_emprunt);

--  EXISTS

select us.nom_famille   AS "Nom usager",
       us.adresse AS "Adresse usager", 
       us.ville AS "Ville"
       
from outils_usager us
         
where EXISTS (select em.num_usagerfrom outils_emprunt em where us.num_usager = em.num_usager );

-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3

select fabricant AS "Marque", AVG (prix) AS " Prix moyen" 
from outils_outil
group by fabricant;

-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4

select us.ville AS "Ville", SUM (ou.prix) AS "Somme prix"
from outils_usager us 
join outils_emprunt em on us.num_usager = em.nom_usagers
join outils_outil ou on em.code_outil = ou.code_outil
group by us.ville 
ORDER by SUM(ou.prix)DESC;

-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2

insert into outils_outil
(code_outil,nom,fabricant,caracteristiques,annee,prix)
values('zack999','couteau','Zack','puissant',2004,350);

-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2

insert into outils_outil
(code_outil,nom,fabricant,caracteristiques,annee,prix)
values('aubz1234','ciseaux',null,null,2004,null);

-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2

delete from outils_outil
where code_outil in('zack999','aubz1234');

-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2

update outils_usager
set nom_famille = upper(nom_famille);
