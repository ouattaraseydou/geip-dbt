# ⚡ GEIP — Energy Data Platform

<p align="center">

  <img src="https://img.shields.io/badge/AWS%20S3-Data%20Lake-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS S3"/>

  <img src="https://img.shields.io/badge/Snowflake-Data%20Warehouse-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white" alt="Snowflake"/>

  <img src="https://img.shields.io/badge/dbt-Analytics%20Engineering-FF694B?style=for-the-badge&logo=dbt&logoColor=white" alt="dbt"/>

  <img src="https://img.shields.io/badge/Power%20BI-Business%20Intelligence-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" alt="Power BI"/>

  <img src="https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?style=for-the-badge&logo=githubactions&logoColor=white" alt="GitHub Actions"/>

</p>

<p align="center">

**End-to-End Data Engineering & Business Intelligence Platform**

</p>

---

## 📌 Présentation du projet

**GEIP** est un projet **End-to-End Data Engineering & Business Intelligence** visant à construire une plateforme de données dédiée à l'analyse d'un environnement énergétique.

Le projet couvre l'ensemble de la chaîne de traitement de la donnée :

**AWS S3 → Snowflake → dbt → Data Warehouse → Power BI**

L'objectif est de transformer des données brutes en données fiables, structurées et exploitables pour les analyses métier et la visualisation des indicateurs.

Le projet met également en œuvre une véritable démarche d'industrialisation avec :

- transformation des données avec **dbt** ;
- modélisation en couches **Staging / Intermediate / Gold** ;
- modèles incrémentaux ;
- snapshots pour l'historisation ;
- tests automatisés de qualité des données ;
- CI/CD avec **GitHub Actions** ;
- exécution automatique quotidienne ;
- gestion sécurisée des credentials avec **GitHub Secrets** ;
- génération automatique d'un rapport par e-mail ;
- préparation des données pour **Power BI**.

---

# 🎯 Objectifs métier

La plateforme permet de centraliser et d'analyser différentes données liées à l'activité énergétique.

Les principales entités métier sont :

- 👤 Clients
- 📄 Contrats
- ⚡ Compteurs
- 🔋 Consommation énergétique
- 🧾 Factures
- 💳 Paiements
- 🚨 Incidents / coupures
- 🔧 Maintenance

Ces données permettent notamment de produire des analyses concernant :

- les clients ;
- les contrats ;
- la consommation énergétique ;
- les factures ;
- les paiements ;
- les incidents ;
- la maintenance ;
- les indicateurs financiers ;
- les indicateurs opérationnels.

---

# 🏗️ Architecture globale

```text
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
                    │      Transformation ELT        │
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
                         │ Data Tests            │
                         │ Full Refresh         │
                         │ Email Reporting      │
                         └──────────────────────┘


