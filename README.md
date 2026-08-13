# ⚡ GEIP — Energy Data Platform

<p align="center">

**End-to-End Data Engineering & Business Intelligence Platform**

</p>

<p align="center">

☁️ AWS S3 • ❄️ Snowflake • 🔧 dbt • 🧮 SQL • 🐍 Python • ⚙️ GitHub Actions • 📊 Power BI

</p>

---

## 📌 Présentation du projet

**GEIP** est un projet **End-to-End Data Engineering & Business Intelligence** visant à concevoir une plateforme de données dédiée à l'analyse d'un environnement énergétique.

L'objectif est de transformer des données brutes en données **fiables, structurées, contrôlées et exploitables** pour les analyses métier, le reporting et la visualisation des indicateurs.

### Architecture cible

**AWS S3 → Snowflake → dbt → Data Warehouse → Power BI**

Le projet intègre également une démarche d'industrialisation avec **GitHub Actions** permettant d'automatiser l'exécution du pipeline, les contrôles de qualité et le monitoring.

---

# 🎯 Objectifs du projet

Le projet GEIP a pour objectifs de :

- ☁️ Centraliser les données sources dans un Data Lake ;
- ❄️ Intégrer les données dans Snowflake ;
- 🧹 Nettoyer et standardiser les données ;
- 🔧 Transformer les données avec dbt ;
- 🏗️ Construire un Data Warehouse analytique ;
- 📐 Mettre en place une architecture **Staging / Intermediate / Gold** ;
- 📊 Construire des dimensions et des tables de faits ;
- 🔄 Mettre en place des modèles incrémentaux ;
- 📸 Historiser les changements avec les snapshots dbt ;
- 🧪 Automatiser les contrôles de qualité des données ;
- ⚙️ Industrialiser le pipeline avec GitHub Actions ;
- 📧 Mettre en place un système de notification automatique ;
- 📊 Préparer les données pour Power BI.

---

# 🏢 Contexte métier

La plateforme GEIP centralise différentes données liées à l'activité énergétique.

## Principales entités métier

| Domaine | Description |
|---|---|
| 👤 Customers | Informations clients |
| 📄 Contracts | Contrats clients |
| ⚡ Meters | Compteurs électriques |
| 🔋 Energy Consumption | Consommation énergétique |
| 🧾 Invoices | Facturation |
| 💳 Payments | Paiements |
| 🚨 Outages | Incidents et coupures |
| 🔧 Maintenance | Opérations de maintenance |

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
                         │    LANDING / RAW     │
                         └──────────┬───────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │              dbt               │
                    │       TRANSFORMATION ELT       │
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
