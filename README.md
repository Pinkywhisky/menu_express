# Menu Express

> **Application Symfony pour gérer un menu (plats, catégories, i18n, vues Twig).**

![badge-build](https://img.shields.io/badge/build-local-green)
![badge-php](https://img.shields.io/badge/PHP-%E2%89%A58.1-777bb3)
![badge-symfony](https://img.shields.io/badge/Symfony-6/7-black)
![badge-license](https://img.shields.io/badge/license-MIT-lightgrey)

---

## 🧭 Sommaire

* [Aperçu](#aperçu)
* [Architecture](#architecture)
* [Prérequis](#prérequis)
* [Installation](#installation)
* [Configuration](#configuration)
* [Lancement](#lancement)
* [Utilisation](#utilisation)
* [API (si applicable)](#api-si-applicable)
* [Qualité & Tests](#qualité--tests)
* [CI/CD & Déploiement](#cicd--déploiement)
* [Arborescence](#arborescence)
* [Dépannage](#dépannage)
* [Feuille de route](#feuille-de-route)
* [Auteurs & Licence](#auteurs--licence)

---

## 📌 Aperçu

**Contexte** : Prototype d’application web pour gérer un *menu* (ex. restaurant, cantine). Back-end en PHP/Symfony, vues en Twig, assets publics dans `public/`, configuration via `.env`.

**Fonctionnalités clés (observées dans le dépôt)** :

* Structure Symfony standard (`src/`, `config/`, `templates/`, `public/`, `translations/`).
* Migrations présentes (`migrations/`) → utilisation de Doctrine ORM.
* Internationalisation possible (`translations/`).
* Pipeline de tests unitaire avec PHPUnit (`phpunit.xml.dist`, dossier `tests/`).
* Dockerfile pour exécuter l’appli en conteneur.

**Captures d’écran / GIF** : mets-les dans `./docs/screenshots/` et référence-les ici.

---

## 🏗️ Architecture

**Langages / Frameworks / Outils** :

* Back : PHP (≥ 8.1), **Symfony** (squelette web), **Doctrine ORM**
* Vue : **Twig** + **Bootstrap** (si inclus dans templates)
* Tests : **PHPUnit**
* Conteneurisation : **Dockerfile** (runtime PHP + serveur web)

**Diagramme simplifié** :

```mermaid
graph TD
  Browser -->|HTTP| App[Symfony HTTP Kernel]
  App --> C[Controllers]
  C --> S[Services]
  S --> R[(Doctrine Repositories)]
  R --> DB[(Database)]
  C --> V[Twig Templates]
```

---

## ✅ Prérequis

* PHP ≥ 8.1 (extensions usuelles : `ctype`, `intl`, `pdo`, `pdo_sqlite`/`pdo_mysql`/`pdo_pgsql`, `openssl`)
* **Composer** ≥ 2.6
* **Symfony CLI** (confortable mais optionnel)
* **Docker** (optionnel, un `Dockerfile` est fourni)

---

## 📦 Installation

```bash
# Cloner
git clone https://github.com/Pinkywhisky/menu_express.git
cd menu_express

# Installer les dépendances PHP
composer install --no-interaction

# Créer les clés APP_SECRET si non définies (facultatif)
# symfony console secrets:generate-keys  # si vous utilisez le vault
```

---

## ⚙️ Configuration

Copier le fichier d’exemple et adapter vos variables :

```bash
cp .env.dist .env
```

Variables usuelles (extrait) :

```ini
# .env
APP_ENV=dev
APP_DEBUG=1
APP_SECRET=change-me
# Choisir votre SGBD : SQLite (dev), MySQL ou PostgreSQL
# Exemples :
# SQLite (dev rapide)
DATABASE_URL="sqlite:///%kernel.project_dir%/var/data.db"
# MySQL
# DATABASE_URL="mysql://user:pass@127.0.0.1:3306/dbname?serverVersion=8.0&charset=utf8mb4"
# PostgreSQL
# DATABASE_URL="postgresql://user:pass@127.0.0.1:5432/dbname?serverVersion=16&charset=utf8"
```

> Le dépôt contient `migrations/` → exécutez-les après avoir configuré `DATABASE_URL`.

---

## 🚀 Lancement

### Avec le serveur de dev Symfony

```bash
# Créer le schéma si nécessaire
php bin/console doctrine:database:create --if-not-exists
php bin/console doctrine:migrations:migrate -n

# Démarrer le serveur
symfony serve -d         # ou: php -S localhost:8000 -t public
```

Accès :

* App : [http://127.0.0.1:8000](http://127.0.0.1:8000)

### Avec Docker (basique)

Un `Dockerfile` est fourni. Exemple minimal :

```bash
docker build -t menu-express .
docker run --rm -p 8000:8000 --env-file .env menu-express
```

> Si une base externe est utilisée, exposez-la et pointez `DATABASE_URL` en conséquence.

---

## 🧪 Utilisation

Routes typiques (à adapter à vos contrôleurs) :

* `/` : page d’accueil
* `/menu` : liste des plats
* `/admin` : gestion (si bundle/admin présent)

Pour l’i18n, placez vos fichiers YAML/XLIF dans `translations/` et activez le *locale* par défaut dans `config/packages/translation.yaml`.

---

## 🧰 API (si applicable)

Le projet semble plutôt *server-rendered* via Twig. Si vous exposez une API, documentez vos endpoints ici et ajoutez `nelmio/api-doc-bundle` si souhaité.

---

## 🧹 Qualité & Tests

Lancer la suite de tests :

```bash
./vendor/bin/phpunit -c phpunit.xml.dist
```

Conseils qualité :

* Lint PHP : `php -l` sur les fichiers
* Style : `friendsofphp/php-cs-fixer` (optionnel)
* Sécurité : `symfony audit:security` ou `roave/security-advisories`

---

## 🔁 CI/CD & Déploiement

* **CI GitHub Actions** : le dépôt contient `.github/workflows/` → ajoutez des jobs `composer install`, `cache`, `phpunit`.
* **Build** : image Docker à partir du `Dockerfile` fourni.
* **Déploiement** :

  * Hébergeur PHP (SymfonyCloud, Clever Cloud, Render) ou
  * Conteneur (Kubernetes/Swarm) derrière un reverse proxy (Traefik, Nginx).
* **Secrets** : via variables d’environnement (`APP_SECRET`, `DATABASE_URL`).

---

## 🌳 Arborescence

Structure observée (niveau 1) :

```
.
├── .github/workflows/
├── bin/
├── config/
├── migrations/
├── public/
├── src/
├── templates/
├── tests/
├── translations/
├── Dockerfile
├── composer.json
├── phpunit.xml.dist
└── .env(.dist)
```

> Pour un aperçu plus fin, exécute : `tree -L 3 -I "vendor|var|node_modules|.git"`.

\---|---|
\| `run` | Lance l’app |
\| `dev` | Hot reload |
\| `test` | Tests |
\| `fmt` | Formatage |
\| `lint` | Lint |

---

## 🛠️ Dépannage

* **Erreur DB/connexion** : vérifiez `DATABASE_URL`, droits réseau, port. En dev, partez sur SQLite pour simplifier.
* **404 sur actifs** : servez via `public/` (DocumentRoot) ; en prod, configurez le vhost Nginx/Apache.
* **Cache/config** : `php bin/console cache:clear` et `cache:warmup`.
* **Migrations** : si désynchronisées, `doctrine:migrations:diff` puis `migrate`.

---

## 🗺️ Feuille de route

* [ ] CRUD complet pour *plats*, *catégories*, *allergènes*
* [ ] Auth & rôles (admin)
* [ ] Import/Export CSV
* [ ] API publique (optionnel)

---

## 👤 Auteurs & Licence

* Auteur : Pinkywhisky
* Licence : MIT (à confirmer dans `composer.json`)

---

### ℹ️ Notes d’implémentation

* Le dépôt montre une base **Symfony + Doctrine + Twig** avec tests et i18n. Sans accès aux fichiers internes (GitHub limite l’affichage via JS côté navigateur ici), ce README renseigne les **commandes standard**. Si tu veux, copie/colle les contenus de `composer.json` et des contrôleurs pour que j’ajoute **les vraies commandes, bundles et routes**.
