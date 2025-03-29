# Demo WordPress Project

Projet Bedrock Wordpress avec Thème et Plugin dockerisé.

## Liens

Le projet est accessible ici : [http://wp-basket.localhost](http://wp-basket.localhost)

Traefik disponible ici : [http://traefik.localhost/dashboard/](http://traefik.localhost/dashboard/)

Monitoring NetData disponible ici : [http://localhost:19999/](http://localhost:19999/)

## Dépôts associés

Ce projet est divisé en plusieurs dépôts :

1.  **`demo-wordpress`** : Le dépôt principal qui contient l'instance de WordPress basée sur **Bedrock**.
2.  **`demo-theme`** : Le dépôt contenant le thème personnalisé basé sur **Timber**.
3.  **`demo-plugin`** : Le dépôt contenant un plugin WordPress personnalisé.
4.  **`demo-infrastructure`** : Contient les fichiers de configuration Docker, NGINX, et autres configurations nécessaires à l'infrastructure du projet.

## Prérequis

-   [Docker](https://www.docker.com/get-started)
-   [Docker Compose](https://docs.docker.com/compose/)

## Installation

### 1 : Cloner le projet

Clonez ce dépôt principal, `make init` se chargera de cloner les autres :

```bash
git clone git@github.com:tderambure/demo-infrastructure.git
cd demo
```

### 2 : Lancer l'environnement avec Make

Pour cloner les autres dépôts et démarrer l'ensemble du projet avec tous les services nécessaires (NGINX, PHP-FPM, MySQL, etc.), il vous suffit d'exécuter la commande suivante :

```bash
make init
```

### 3 : Accéder au projet

Une fois tout en place, vous pouvez accéder à votre site WordPress localement à l'adresse suivante :

[http://wp-basket.localhost/](http://wp-basket.localhost/)

### 4 : Make

D'autres commandes make sont disponibles :

```bash
make help
```
