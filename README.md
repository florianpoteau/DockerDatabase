# DockerDatabase

L'objectif du projet étant d'utiliser Docker pour l'initialisation d'une base de donnée.
Dans ce Read-me, il y aura la façon dont j'ai utiliser Docker, la base de donnée exportée, ainsi que quelques requêtes SQL demandées lors de cet exercice.
Dans ce repositorie, il y aura:

<ul>
<li>Le dictionnaire de donnée</li>
<li>Le MCD (Modèle conceptuel de donnée)</li>
<li>Le MLD (Modèle logique de donnée)</li>
<li>Le MPD (Modèle physique de donnée)</li>
<li>Un fichier permettant de générer la base de données(incluant quelques données)</li>
<li>L'environnement Docker</li>
<li>Le jeu de requetes (a la fin de ce read-me)</li>
<li>Un aperçu de la <a href= "https://docs.google.com/spreadsheets/d/1QPXHUMma6DOoxAY7KJPicHG-ojIo9UPbejr1yqDDCjo/edit#gid=0">grille d'évaluation</a></li>
</ul>

## Initialisation

Pour tester le projet, il vous faut télécharger le fichier docker-compose.yml ainsi que backup.sql.
Puis tapez en ligne de commande:

```bash
docker compose up
```

## Requêtes SQL

Les titres et dates de sortie des films du plus récent au moins récent:

```sql
SELECT titre, annee
FROM "Movie"
ORDER BY annee DESC
LIMIT 100;
```

Les noms, prénoms et âges des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique:

```sql
SELECT nom, prenom, age
FROM "Actor"
WHERE age > 30
ORDER BY nom
LIMIT 100;
```

La liste des acteurs/actrices principaux pour un film donné:

```sql
SELECT "Actor".nom, "Actor".prenom
FROM "Actor"
INNER JOIN "RoleActorMovie" ON "Actor".id = "RoleActorMovie".id_actor
WHERE "RoleActorMovie".id_actor = 2 AND "RoleActorMovie".id_movie = 3
LIMIT 100;
```

La liste des films pour un acteur/actrice donné:

```sql
SELECT "Movie".id, "Movie".titre, "Movie".duree, "Movie".annee, "Movie".director_id
FROM "Movie"
INNER JOIN "RoleActorMovie" ON "Movie".id = "RoleActorMovie".id_movie
WHERE "RoleActorMovie".id_actor = 2 AND "RoleActorMovie".id_movie = 3
LIMIT 100;
```

Ajouter un film:

```sql
INSERT INTO "Movie" ("titre", "duree", "annee", "director_id")
VALUES ('Titre1', '02:23:00', '2020-06-22', 1);
```

Ajouter un acteur/actrice:

```sql
INSERT INTO "Actor" ("nom", "prenom", "role", "birth", "age")
VALUES ('Dampierre', 'Gerard', 'cascadeur', '2002-12-03', 21);
```

Modifier un film:

```sql
UPDATE "Movie"
SET titre = 'Concepteur développeur dapplications', duree = '01:50:43', annee = '1992-03-20'
WHERE "Movie".id = 6
```

Supprimer un acteur/actrice:

```sql
DELETE FROM "RoleActorMovie"
WHERE id_actor = 5;
DELETE FROM "Actor"
WHERE id = 5
```

Afficher les 3 derniers acteurs/actrices ajouté(e)s:

```sql
SELECT nom, prenom
FROM "Actor"
ORDER BY id DESC
LIMIT 3;
```
