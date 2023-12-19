# DockerDatabase

L'objectif du projet étant d'utiliser Docker pour l'initialisation d'une base de donnée.
Dans ce Read-me, il y aura la façon dont j'ai utiliser Docker, le jeu de requête, ainsi que quelques requêtes SQL demandées lors de cet exercice.
Dans ce repositorie, il y aura:

<ul>Le dictionnaire de donnée</ul>
<ul>Le MCD (Modèle conceptuel de donnée)</ul>
<ul>Le MLD (Modèle logique de donnée)</ul>
<ul>Le MPD (Modèle physique de donnée)</ul>
<ul>Un fichier permettant de générer la base de données(incluant quelques données)</ul>
<ul>L'environnement Docker</ul>
<ul>Le jeu de requetes</ul>

## Initialisation

Pour tester le projet,

<li>initialiser docker avec docker-compose.yml</li>
<li>importer la base de donnée dans le fichier database.json</li>
<li>Créer un fichier .env comme ci dessous: et remplacer les valeurs par vos informations de base de données</li>

```env
POSTGRES_USER=user
POSTGRES_PASSWORD=psw
POSTGRES_DB=db
```

Si vous modifier votre variable POSTGRES_USER, vous devrez modifier aussi le fichier database.json pour le username comme ci-dessous, n'oubliez pas de changer "user" par votre nom d'utilisateur du .env.

```json
{
  "Username": "user"
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

Les titres et dates de sortie des films du plus récent au moins récent
