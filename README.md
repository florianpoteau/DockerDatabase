# DockerDatabase

L'objectif du projet étant d'utiliser Docker pour l'initialisation d'une base de donnée.
Dans ce Read-me, il y aura la façon dont j'ai utiliser Docker, le jeu de requête, ainsi que quelques requêtes SQL demandées lors de cet exercice.
Dans ce repositorie, il y aura:

<ul>Le dictionnaire de donnée</ul>
<ul>Le MCD (Modèle conceptuel de donnée)</ul>
<ul>Le MLD (Modèle logique de donnée)</ul>
<ul>Le MPD (Modèle physique de donnée)</ul>
<ul>Un fichier permettant de générer la base de données(incluant quelques données)
<ul>L'environnement Docker</ul>
<ul>Le jeu de requetes</ul>

## Docker

Tout d'abord, j'ai créé un fichier 'docker-compose.yml', j'y ai ajouté les informations de la base de données, et j'ai sécurisé les informations confidentiels de la base de données en créant un fichier .env.

Bien entendu, il ne figure pas dans ce repositories, mais si vous souhaitez utiliser, et tester mon projet, il vous faudra <strong>créer un fichier .env</strong> dans lequel sera inclue 3 variables: <strong>POSTGRES_USER</strong>, <strong>POSTGRES_PASSWORD</strong> et <strong>POSTGRES_DB</strong>.

Pour créer mon conteneur Docker j'ai fait en ligne de commande:

```bash
docker compose up
```

Ensuite avec pgadmin j'ai créer un serveur qui contenait les informations de mon fichier docker-compose.yml et du .env.

## Requêtes SQL

Les titres et dates de sortie des films du plus récent au moins récent
