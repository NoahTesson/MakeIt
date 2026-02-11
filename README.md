1. Introduction au projet MakeIt
MakeIt est une application iOS développée en SwiftUI conçue pour centraliser vos routines d'exercices. L'application permet d'organiser vos activités par groupes ou individuellement, avec trois modes de fonctionnement :

SmartTimer : Un système intelligent alternant temps d'effort et de récupération (Tabata/HIIT).

Timer : Un compte à rebours classique.

None : Une simple note de suivi.

L'application intègre également un système de strikes pour les exercices quotidiens.

2. Ouverture du projet dans Xcode
Si vous n'êtes pas familier avec le développement iOS, voici comment ouvrir le projet :

Assurez-vous d'avoir installé Xcode depuis l'App Store.

Localisez le dossier racine de votre projet nommé MakeIt.

Cherchez le fichier se terminant par .xcodeproj ou .xcworkspace.

Double-cliquez sur ce fichier pour lancer l'environnement de développement.

3. Configuration de l'API (Swift)
Une fois Xcode ouvert, vous devez configurer les URLs de connexion aux serveurs.

Dans le navigateur de fichiers (à gauche), allez dans le dossier API/api.

Ouvrez le fichier Swift concerné.

À la ligne 13, remplacez la variable baseURL par vos adresses :

Swift
// Remplacez par vos URLs réelles
static let baseURL = URL(string: false ? "replace it (local server if false)" : "replace it (cloudfloud server if false)")!
Note : Mettre le booléen à false utilisera l'URL locale, tandis que true activera l'URL Cloudflare.

4. Configuration des serveurs Cloudflare (TypeScript)
Le projet utilise deux serveurs (Workers) pour la gestion des données et des tâches automatisées. Avant de continuer, créez un fichier nommé wrangler.jsonc à la racine de chaque dossier de serveur respectif.

Serveur Principal (Actions Base de Données)
Dans le dossier du serveur normal, insérez ce contenu dans wrangler.jsonc :

JSON
{
	"$schema": "node_modules/wrangler/config-schema.json",
	"name": "server-dailytasks",
	"main": "src/index.ts",
	"compatibility_date": "2025-06-14",
	"observability": {
		"enabled": true
	},
	"d1_databases": [
		{
		  "binding": "DB",
		  "database_name": "NOM_DE_VOTRE_DB",
		  "database_id": "VOTRE_DATABASE_ID",
		  "migrations_dir": "migrations/"
		}
	]
}
Serveur Cronjobs (Tâches automatisées)
Dans le dossier du serveur cronjobs, insérez ce contenu dans wrangler.jsonc :

JSON
{
	"$schema": "node_modules/wrangler/config-schema.json",
	"name": "server-cronjobs",
	"main": "src/index.ts",
	"compatibility_date": "2025-06-18",
	"observability": {
		"enabled": true
	},
	"d1_databases": [
		{
		  "binding": "DB",
		  "database_name": "NOM_DE_VOTRE_DB",
		  "database_id": "VOTRE_DATABASE_ID",
		  "migrations_dir": "migrations/"
		}
	],
	"triggers": {
		"crons": [
			"23 0 * * *"
		]
	}
}
5. Installation et Lancement
Pour chaque serveur, ouvrez un terminal et suivez ces étapes :

Installation des dépendances :

Bash
npm i
Cette commande va créer le dossier node_modules.

Lancement en local :

Bash
npm start
Le serveur sera alors accessible localement pour vos tests avec l'application.

Souhaitez-vous que je vous aide à rédiger la documentation des routes API pour ces serveurs ?