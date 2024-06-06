# Reconii
<p align="center">
  <img src="https://github.com/pwnwithlove/Reconii/assets/91483937/fb28f740-2832-457e-9fc0-2dbe11224e5e" alt="Thon Mayo Logo" width="150"/>
</p>

Reconii est un outil développé en Flask (Python) et utilisant une base de données SQLite. Ce projet a été réalisé dans le cadre de mon BTS SIO, pour l'examen de l'épreuve E5.

<p align="center">
  <img src="https://github.com/pwnwithlove/Reconii/assets/91483937/cf4676b2-8bfc-43ba-8ff4-b36c02f52ce1" alt="Thon Mayo Logo" width="500"/>
</p>

## Description

Reconii vise à automatiser la reconnaissance et la recherche de vulnérabilités sur des endpoints spécifiques, afin de faciliter les futurs travaux relatifs aux tests d'intrusion. L'outil permet une collecte efficace des informations et l'identification des vulnérabilités potentielles, simplifiant ainsi le processus de reconnaissance pour les professionnels de la sécurité.

Ce projet ne comporte que quelques tests, puisque ceux-ci sont de base très long, il a été choisit de les raccourcir. 

Vous trouverez une documentation sur ces outils ici: https://hackmd.io/5JSt9sLCRxCf-exd5ZCpkA

## Fonctionnalités

- Collecte automatique des informations sur les endpoints spécifiés.
- Analyse des vulnérabilités potentielles.
- Interface utilisateur développée en Flask.
- Stockage des données en utilisant SQLite.

## Prérequis

Avant de lancer le projet, assurez-vous d'avoir les éléments suivants installés :

- Docker
- Docker Compose

## Installation et Utilisation

1. Clonez ce dépôt sur votre machine locale :

```bash
git clone https://github.com/pwnwithlove/Reconii.git
cd Reconii
```

2. Construisez et lancez les conteneurs Docker :

```bash
docker-compose up --build
```
![image](https://github.com/pwnwithlove/Reconii/assets/91483937/6ee4947f-3d1c-4983-8a1b-c880c1259ade)


3. Accédez à l'application via votre navigateur à l'adresse suivante :

```
http://127.0.0.1:5000
```
![image](https://github.com/pwnwithlove/Reconii/assets/91483937/fad5f9a1-d977-4099-b572-05428a73bde2)
![image](https://github.com/pwnwithlove/Reconii/assets/91483937/d8eda33b-126f-4250-8d74-13fb60f2276f)


