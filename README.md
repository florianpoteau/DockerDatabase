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
</ul>

## Initialisation

Pour tester le projet,

<ul>
<li>initialiser docker avec docker-compose.yml</li>
<li>importer la base de donnée dans le fichier database.json</li>
<li>Créer un fichier .env comme ci dessous: et remplacer les valeurs par vos informations de base de données</li>
</ul>

```env
POSTGRES_USER=username
POSTGRES_PASSWORD=psw
POSTGRES_DB=db
```

Si vous modifier votre variable POSTGRES_USER, vous devrez modifier aussi le fichier database.json pour le username comme ci-dessous, n'oubliez pas de changer "username" par votre nom d'utilisateur du .env.

```json
{
  "Username": "username"
}
```

## Docker

Tout d'abord, j'ai créé un fichier 'docker-compose.yml', j'y ai ajouté les informations de la base de données, et j'ai sécurisé les informations confidentiels de la base de données en créant un fichier .env.

Bien entendu, il ne figure pas dans ce repositories, mais si vous souhaitez utiliser, et tester mon projet, il vous faudra <strong>créer un fichier .env</strong> dans lequel sera inclue 3 variables: <strong>POSTGRES_USER</strong>, <strong>POSTGRES_PASSWORD</strong> et <strong>POSTGRES_DB</strong>.

Pour créer mon conteneur Docker j'ai fait en ligne de commande:

```bash
docker compose up
```

Ensuite avec pgadmin j'ai créer un serveur qui contenait les informations de mon fichier docker-compose.yml et du .env.

## Base de données

Vous trouverez via ce repo. Un fichier database.json de ma base de donnée exporté, il vous suffit d'importer ma base de donnée <strong>Postgresql</strong>.

Si vous souhaiter importer la base de données, vous aurez un nouvel utilisateur qui aura pour role le role "admin" lui permettant de selectionner, modifier, supprimer ou créer une table.

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

## Information complémentaire

Voici mon trigger qui m'a permis de faire une insertion dans la table 'userarchive' après mise a jour d'un utilisateur de la table 'User'.

```sql
CREATE OR REPLACE FUNCTION user_update_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
IF TG_TABLE_NAME = 'User' THEN
INSERT INTO UserArchive (user_id, operation_type, old_data, new_data, datecreation)
VALUES (NEW.id, 'update', row_to_json(OLD), row_to_json(NEW), OLD.datecreation);
END IF;

    RETURN NEW;

END;

$$
LANGUAGE plpgsql;

CREATE TRIGGER user_update_trigger
BEFORE UPDATE ON "User"
FOR EACH ROW
EXECUTE FUNCTION user_update_trigger_function();
```
