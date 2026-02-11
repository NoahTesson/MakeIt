# MakeIt - Application de suivi d'exercices

MakeIt est une application mobile pour iPhone développée en **SwiftUI**. Elle a pour but de permettre de créer des exercices (sportifs ou autres) pour en garder une trace et les centraliser au même endroit.

## 📱 Fonctionnalités

- **Organisation** : Possibilité de créer des groupes pour organiser les exercices, ou de créer des exercices isolés.
- **Types d'exercices** :
  - **SmartTimer** : Décompte de 5s au démarrage, puis alternance entre temps d'effort et temps de récupération (selon les répétitions et séries définies).
  - **Timer** : Compte à rebours classique depuis une durée définie jusqu'à zéro.
  - **None** : Mode texte uniquement pour noter l'exercice sans chronomètre.
- **Suivi de Strike** : Suivi quotidien pour les exercices marqués comme récurrents lors de leur création.

---

## 🛠 Configuration iOS (Xcode)

### 1. Ouverture du projet

Si vous ne connaissez pas Xcode :
1. Installez **Xcode** via l'App Store de votre Mac.
2. Localisez le dossier racine du projet `MakeIt`.
3. Double-cliquez sur le fichier `.xcodeproj` (ou `.xcworkspace`) pour ouvrir le projet.

### 2. Configuration de l'URL API

1. Dans Xcode, naviguez dans le dossier `API/api`.
2. Ouvrez le fichier de configuration et allez à la **ligne 13**.
3. Remplacez le texte par vos URLs respectives :
```swift
static let baseURL = URL(string: false ? "VOTRE_URL_LOCAL" : "VOTRE_URL_CLOUDFLARE")!
```

**Note :** L'application utilisera l'URL locale si la condition est `false` et l'URL Cloudflare si elle est `true`.

---

## ☁️ Configuration des Serveurs (Cloudflare Workers)

Le backend repose sur deux serveurs en TypeScript. Vous devez ajouter un fichier nommé `wrangler.jsonc` à la racine de chaque dossier de serveur avant de lancer l'installation.

### 1. Serveur API (server-dailytasks)

Ce serveur gère les actions sur la base de données D1 lors de l'utilisation de l'application.

**Fichier :** `wrangler.jsonc`
```json
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
      "database_id": "DATABASE_ID",
      "migrations_dir": "migrations/"
    }
  ]
}
```

### 2. Serveur Cronjobs (server-cronjobs)

Ce serveur gère les tâches automatisées (Cronjobs) programmées à 00:23 chaque jour.

**Fichier :** `wrangler.jsonc`
```json
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
      "database_id": "DATABASE_ID",
      "migrations_dir": "migrations/"
    }
  ],
  "triggers": {
    "crons": [
      "23 0 * * *"
    ]
  }
}
```

---

## 🚀 Installation et Lancement

Pour chaque dossier de serveur (`server-dailytasks` et `server-cronjobs`), ouvrez un terminal et exécutez les commandes suivantes :

**1. Installer les dépendances :**
```bash
npm i
```

Cela créera le dossier `node_modules` nécessaire au projet.

**2. Lancer le serveur en local :**
```bash
npm start
```