# ⚡ GEIP — Energy Data Platform

<p align="center">

**End-to-End Data Engineering & Business Intelligence Platform**

</p>

<p align="center">

AWS S3 • Snowflake • dbt • SQL • Python • GitHub Actions • Power BI

</p>

---

## 📌 Présentation du projet

**GEIP** est un projet **End-to-End Data Engineering & Business Intelligence** visant à concevoir une plateforme de données dédiée à l'analyse d'un environnement énergétique.

L'objectif du projet est de transformer des données brutes en données fiables, structurées et exploitables pour les analyses métier, le reporting et la visualisation des indicateurs.

L'architecture du projet s'appuie sur plusieurs technologies Cloud et Data :

**AWS S3 → Snowflake → dbt → Data Warehouse → Power BI**

Le projet intègre également une démarche d'industrialisation et d'automatisation avec **GitHub Actions**.

---

# 🎯 Objectifs du projet

Le projet GEIP a pour objectifs de :

- centraliser les données énergétiques ;
- stocker les données sources dans un environnement Data Lake ;
- intégrer les données dans Snowflake ;
- nettoyer et standardiser les données ;
- construire un Data Warehouse analytique ;
- mettre en place une architecture **Staging / Intermediate / Gold** ;
- développer des dimensions et des tables de faits ;
- historiser certaines données métier ;
- mettre en place des modèles incrémentaux ;
- automatiser les contrôles de qualité des données ;
- industrialiser les transformations avec dbt ;
- automatiser l'exécution du pipeline avec GitHub Actions ;
- préparer les données pour Power BI ;
- produire des tableaux de bord et indicateurs métier.

---

# 🏢 Contexte métier

GEIP est conçu comme une plateforme analytique permettant de centraliser différentes données liées à l'activité énergétique.

Les principales entités métier du projet sont :

- 👤 **Clients**
- 📄 **Contrats**
- ⚡ **Compteurs**
- 🔋 **Consommation énergétique**
- 🧾 **Factures**
- 💳 **Paiements**
- 🚨 **Incidents / Coupures**
- 🔧 **Maintenance**

Ces données permettent de produire différents types d'analyses :

### 👥 Analyse clients

- nombre de clients ;
- segmentation ;
- évolution du portefeuille client ;
- analyse des caractéristiques clients.

### 📄 Analyse contrats

- nombre de contrats ;
- statut des contrats ;
- évolution des contrats ;
- analyse de la relation client / contrat.

### ⚡ Analyse énergétique

- consommation énergétique ;
- évolution de la consommation ;
- analyse par compteur ;
- analyse temporelle.

### 💰 Analyse financière

- facturation ;
- paiements ;
- montants dus ;
- suivi des règlements ;
- indicateurs financiers.

### 🚨 Analyse opérationnelle

- incidents ;
- coupures ;
- maintenance ;
- suivi des événements opérationnels.

---

# 🏗️ Architecture globale

                         ┌──────────────────────┐
                         │        AWS S3        │
                         │      DATA LAKE       │
                         │                      │
                         │    Données brutes    │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │      SNOWFLAKE       │
                         │     DATA PLATFORM    │
                         │                      │
                         │   Landing / Raw      │
                         └──────────┬───────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │              dbt               │
                    │       Transformation ELT       │
                    └──────────────┬────────────────┘
                                   │
                 ┌─────────────────┼─────────────────┐
                 │                 │                 │
                 ▼                 ▼                 ▼
        ┌────────────────┐ ┌────────────────┐ ┌────────────────┐
        │    STAGING     │ │  INTERMEDIATE  │ │      GOLD      │
        │                │ │                │ │                │
        │ stg_landing_*  │ │     int_*      │ │ Dimensions     │
        │                │ │                │ │ Facts          │
        │ Nettoyage      │ │ Jointures      │ │ Reporting      │
        │ Standardisation│ │ Préparation    │ │                │
        └────────────────┘ └────────────────┘ └───────┬────────┘
                                                      │
                                                      ▼
                                             ┌─────────────────┐
                                             │     POWER BI    │
                                             │                 │
                                             │   Dashboards    │
                                             │   KPI / BI      │
                                             └─────────────────┘


                         ┌──────────────────────┐
                         │    GITHUB ACTIONS    │
                         │        CI / CD       │
                         │                      │
                         │ dbt debug            │
                         │ dbt deps             │
                         │ dbt build            │
                         │ Data Tests           │
                         │ Full Refresh         │
                         │ Email Reporting      │
                         └──────────────────────┘


---
# ☁️ AWS S3 — Data Lake

**Amazon S3** constitue la couche de stockage des données sources du projet.

L'objectif est de centraliser les données brutes dans un environnement **Data Lake** avant leur intégration dans **Snowflake**.

## 📂 Organisation des données

```text
AWS S3
│
├── 📁 customers/
├── 📁 contracts/
├── 📁 meters/
├── 📁 invoices/
├── 📁 payments/
├── 📁 energy_consumption/
├── 📁 outages/
└── 📁 maintenance/
```text
