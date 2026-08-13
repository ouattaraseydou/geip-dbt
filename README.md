# ⚡ GEIP — Energy Data Platform

<p align="center">
  <img src="https://img.shields.io/badge/AWS-S3-orange?style=for-the-badge&logo=amazonaws" alt="AWS S3">
  <img src="https://img.shields.io/badge/Snowflake-Data%20Warehouse-29B5E8?style=for-the-badge&logo=snowflake" alt="Snowflake">
  <img src="https://img.shields.io/badge/dbt-Analytics%20Engineering-FF694B?style=for-the-badge&logo=dbt" alt="dbt">
  <img src="https://img.shields.io/badge/Power%20BI-Business%20Intelligence-F2C811?style=for-the-badge&logo=powerbi" alt="Power BI">
  <img src="https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?style=for-the-badge&logo=githubactions" alt="GitHub Actions">
</p>

<p align="center">
  <strong>End-to-End Data Engineering & Business Intelligence Platform</strong>
</p>

<p align="center">
  AWS S3 • Snowflake • dbt • SQL • Python • GitHub Actions • Power BI
</p>

<p align="center">
  <a href="https://github.com/ouattaraseydou/geip-dbt">
    <img src="https://img.shields.io/badge/GitHub-View%20Repository-181717?style=flat-square&logo=github" alt="GitHub Repository">
  </a>
</p>

---

# 🧭 Navigation

- [📌 Présentation](#-présentation)
- [⭐ Key Features](#-key-features)
- [🎯 Objectifs](#-objectifs)
- [🏢 Contexte métier](#-contexte-métier)
- [🏗️ Architecture globale](#️-architecture-globale)

### ☁️ Data Platform

- [☁️ AWS S3 — Data Lake](#️-1-aws-s3--data-lake)
- [❄️ Snowflake — Data Warehouse](#️-2-snowflake--data-warehouse)

### 🔧 Transformation & Modélisation

- [🔧 dbt — Transformation](#-3-dbt--transformation--analytics-engineering)
- [🥉 Staging Layer](#-4-staging-layer)
- [🥈 Intermediate Layer](#-5-intermediate-layer)
- [🥇 Gold Layer](#-6-gold-layer)
- [📐 Dimensions](#-7-dimensions)
- [📊 Facts](#-8-facts--tables-de-faits)
- [📈 Reporting Layer](#-9-reporting-layer)
- [🧩 Macros dbt](#-10-macros-dbt)
- [🔄 Modèles incrémentaux](#-11-modèles-incrémentaux)
- [📸 Snapshots](#-12-snapshots--historisation)
- [🧪 Data Quality](#-13-data-quality)

### 📊 Business Intelligence

- [📊 Power BI](#-14-power-bi--business-intelligence)

### ⚙️ Industrialisation

- [⚙️ CI/CD — GitHub Actions](#️-15-cicd--github-actions)
- [🕐 Automatisation](#-16-automatisation)
- [🔐 Gestion des secrets](#-17-gestion-des-secrets)
- [📧 Monitoring & Email Reporting](#-18-monitoring--email-reporting)

### 📚 Documentation

- [📁 Structure du projet](#-19-structure-du-projet)
- [🛠️ Technologies utilisées](#️-20-technologies-utilisées)
- [🚀 Commandes principales](#-21-commandes-principales)
- [📊 Résultats du pipeline](#-22-résultats-du-pipeline)
- [🗺️ Roadmap](#️-23-roadmap)
- [🧠 Compétences démontrées](#-24-compétences-démontrées)
- [👨‍💻 Auteur](#-25-auteur)

---

# 📌 Présentation

**GEIP — Energy Data Platform** est un projet **End-to-End Data Engineering & Business Intelligence** conçu pour transformer des données énergétiques brutes en données fiables, structurées et exploitables pour l'analyse métier et le reporting.

Le projet met en œuvre une architecture moderne combinant :

> **AWS S3 → Snowflake → dbt → Data Warehouse → Power BI**

L'ensemble de la plateforme est versionné et industrialisé avec **GitHub** et **GitHub Actions**.

### 💡 Le projet en une phrase

> **Construire une plateforme Data complète permettant de transformer des données énergétiques brutes en données fiables, modélisées et prêtes pour l'analyse métier et la Business Intelligence.**

---

# ⭐ Key Features

| Fonctionnalité | Mise en œuvre |
|---|---|
| ☁️ Data Lake | AWS S3 |
| ❄️ Cloud Data Warehouse | Snowflake |
| 🔧 Transformation | dbt |
| 🧱 Data Modeling | Staging / Intermediate / Gold |
| 🧩 Réutilisation SQL | dbt Macros |
| 🔄 Incremental Processing | Modèles incrémentaux |
| 📸 Historisation | dbt Snapshots |
| 🧪 Data Quality | Tests dbt |
| 📊 Business Intelligence | Power BI |
| ⚙️ CI/CD | GitHub Actions |
| 🔐 Sécurité | GitHub Secrets |
| 📧 Monitoring | Rapport automatique par e-mail |
| 🐍 Data Preparation | Python |
| 🧮 Transformation | SQL |

---

# 🎯 Objectifs

Le projet GEIP vise à :

- ☁️ centraliser les données énergétiques ;
- 🗂️ stocker les données sources dans un Data Lake ;
- ❄️ intégrer les données dans Snowflake ;
- 🧹 nettoyer et standardiser les données ;
- 🏗️ construire un Data Warehouse analytique ;
- 📐 mettre en place une architecture **Staging / Intermediate / Gold** ;
- 📊 développer des dimensions et tables de faits ;
- 🧩 factoriser les traitements SQL avec des macros ;
- 🔄 traiter les données de manière incrémentale ;
- 📸 historiser les changements métier ;
- 🧪 automatiser les contrôles de qualité ;
- 📊 préparer les données pour Power BI ;
- ⚙️ industrialiser les exécutions avec GitHub Actions ;
- 📧 superviser automatiquement les exécutions.

---

# 🏢 Contexte métier

GEIP est conçu comme une plateforme analytique permettant de centraliser différentes données liées à l'activité énergétique.

## 📚 Principales entités

| Domaine | Données |
|---|---|
| 👤 Clients | Informations clients |
| 📄 Contrats | Contrats et statuts |
| ⚡ Compteurs | Équipements et compteurs |
| 🔋 Consommation | Consommation énergétique |
| 🧾 Factures | Données de facturation |
| 💳 Paiements | Paiements et règlements |
| 🚨 Incidents | Coupures et événements |
| 🔧 Maintenance | Opérations de maintenance |

## 📈 Analyses métier

### 👥 Clients

- portefeuille client ;
- segmentation ;
- évolution du nombre de clients ;
- analyse des caractéristiques clients.

### 📄 Contrats

- contrats actifs ;
- contrats terminés ;
- évolution des contrats ;
- relation client / contrat.

### ⚡ Énergie

- consommation ;
- évolution temporelle ;
- consommation par compteur ;
- analyse par période.

### 💰 Finance

- facturation ;
- paiements ;
- montants dus ;
- suivi des règlements.

### 🚨 Opérations

- incidents ;
- coupures ;
- maintenance ;
- événements opérationnels.

---

# 🏗️ Architecture globale

```text
                              DATA SOURCES
                                   │
                                   ▼
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
                       │     DATA WAREHOUSE   │
                       │                      │
                       │   LANDING / RAW      │
                       └──────────┬───────────┘
                                  │
                                  ▼
                    ┌─────────────────────────────┐
                    │             dbt             │
                    │      TRANSFORMATION ELT     │
                    └─────────────┬───────────────┘
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
                    ▼             ▼             ▼
              ┌──────────┐ ┌────────────┐ ┌────────────┐
              │ STAGING  │ │INTERMEDIATE│ │    GOLD    │
              │          │ │            │ │            │
              │ Cleaning │ │ Business   │ │ Dimensions │
              │ Standard │ │ Logic      │ │ Facts      │
              │ Typing   │ │ Joins      │ │ Reporting  │
              └────┬─────┘ └─────┬──────┘ └─────┬──────┘
                   │              │              │
                   └──────────────┴──────────────┘
                                                 │
                                                 ▼
                                      ┌────────────────────┐
                                      │      POWER BI      │
                                      │                    │
                                      │ Dashboards / KPI   │
                                      └────────────────────┘


                  ┌────────────────────────────────────┐
                  │          GITHUB ACTIONS             │
                  │              CI / CD                │
                  │                                    │
                  │ dbt debug → dbt deps → dbt build  │
                  │ Tests → Monitoring → Email         │
                  └────────────────────────────────────┘
```

---

# ☁️ 1. AWS S3 — Data Lake

**Amazon S3** constitue la couche de stockage des données sources.

L'objectif est de centraliser les données brutes dans un environnement **Data Lake** avant leur intégration dans Snowflake.

## 📂 Organisation

```text
AWS S3
│
├── customers/
├── contracts/
├── meters/
├── invoices/
├── payments/
├── energy_consumption/
├── outages/
└── maintenance/
```

## 🎯 Rôle

AWS S3 permet de :

- 📦 stocker les données sources ;
- 🗂️ organiser les données par domaine métier ;
- 🔄 conserver les données brutes ;
- ☁️ bénéficier d'un stockage cloud scalable ;
- 🔗 préparer l'alimentation du pipeline Data.

> 🚧 **Statut :** l'intégration complète **AWS S3 → Snowflake** constitue une étape d'évolution du projet.

---

# ❄️ 2. Snowflake — Data Warehouse

**Snowflake** constitue le Cloud Data Warehouse du projet GEIP.

Il centralise les données et héberge les différentes couches du modèle analytique.

## 🏗️ Organisation

```text
GEIP_PROD
│
├── LANDING
│   └── Données sources brutes
│
├── STAGING
│   └── Nettoyage & standardisation
│
├── INTERMEDIATE
│   └── Transformations métier
│
└── GOLD
    │
    ├── DIMENSIONS
    │   └── Données descriptives
    │
    ├── FACTS
    │   └── Mesures & événements
    │
    └── REPORTING
        └── Modèles Power BI
```

## 🔄 Flux de transformation

```text
LANDING
   │
   ▼
STAGING
   │
   ├── Nettoyage
   ├── Standardisation
   └── Typage
   │
   ▼
INTERMEDIATE
   │
   ├── Jointures
   ├── Enrichissement
   └── Règles métier
   │
   ▼
GOLD
   │
   ├── DIMENSIONS
   ├── FACTS
   └── REPORTING
```

---

# 🔧 3. dbt — Transformation & Analytics Engineering

**dbt (Data Build Tool)** constitue le moteur de transformation du projet.

Il permet de transformer les données directement dans Snowflake selon une approche **ELT**.

## 🎯 Rôle de dbt

- transformer les données ;
- gérer les dépendances entre modèles ;
- construire le Data Warehouse ;
- créer des modèles incrémentaux ;
- historiser les données ;
- automatiser les tests ;
- factoriser le SQL avec des macros ;
- documenter et industrialiser les transformations.

## 🔄 Pipeline dbt

```text
LANDING
   │
   ▼
STAGING
   │
   ▼
INTERMEDIATE
   │
   ▼
GOLD
   │
   ├── Dimensions
   ├── Facts
   └── Reporting
```

---

# 🥉 4. Staging Layer

La couche **Staging** constitue la première étape de transformation.

## 🎯 Responsabilités

- 🧹 nettoyage ;
- 🔤 standardisation ;
- 🔢 conversion des types ;
- 🧼 normalisation ;
- 📋 préparation des données.

## 📂 Modèles

```text
models/
└── staging/
    └── landing/
        ├── stg_landing_customers.sql
        ├── stg_landing_contracts.sql
        ├── stg_landing_meters.sql
        ├── stg_landing_invoices.sql
        ├── stg_landing_payments.sql
        ├── stg_landing_energy_consumption.sql
        ├── stg_landing_outages.sql
        ├── stg_landing_maintenance.sql
        └── stg_landing_customer_service.sql
```

### 🔑 Principe

> **Nettoyer → Standardiser → Typer → Préparer**

---

# 🥈 5. Intermediate Layer

La couche **Intermediate** centralise les transformations métier nécessaires avant la couche Gold.

## 🔗 Principales opérations

- jointures ;
- enrichissement ;
- règles métier ;
- calculs intermédiaires ;
- préparation des relations entre entités.

## 📂 Modèles

```text
models/
└── intermediate/
    ├── int_customer_contracts.sql
    ├── int_contract_meters.sql
    ├── int_customer_service.sql
    ├── int_invoice_payments.sql
    ├── int_meter_consumption.sql
    ├── int_outages.sql
    └── int_maintenance.sql
```

### Exemple

```text
Customers ───────┐
                 │
Contracts ───────┼──► int_customer_contracts
                 │
Meters ──────────┘
```

---

# 🥇 6. Gold Layer

La couche **Gold** contient les données finales destinées à l'analyse.

```text
GOLD
│
├── 📐 DIMENSIONS
│
├── 📊 FACTS
│
└── 📈 REPORTING
```

Elle constitue la couche analytique du Data Warehouse.

---

# 📐 7. Dimensions

Les dimensions fournissent le contexte descriptif nécessaire à l'analyse.

| Dimension | Rôle |
|---|---|
| 👤 `dim_customers` | Informations clients |
| 📄 `dim_contracts` | Informations contrats |
| ⚡ `dim_meters` | Informations compteurs |
| 📅 `dim_date` | Analyse temporelle |

### 👤 `dim_customers`

Analyse des clients, profils et relations contractuelles.

### 📄 `dim_contracts`

Analyse des contrats, statuts et périodes contractuelles.

### ⚡ `dim_meters`

Analyse des compteurs et équipements.

### 📅 `dim_date`

Dimension calendrier pour les analyses par :

- année ;
- trimestre ;
- mois ;
- semaine ;
- jour.

---

# 📊 8. Facts — Tables de faits

Les tables de faits contiennent les événements et mesures métier.

```text
models/
└── marts/
    └── facts/
        ├── fact_energy_consumption.sql
        ├── fact_invoices.sql
        ├── fact_outages.sql
        └── fact_payments.sql
```

| Table | Analyse |
|---|---|
| ⚡ `fact_energy_consumption` | Consommation énergétique |
| 🧾 `fact_invoices` | Facturation |
| 🚨 `fact_outages` | Incidents et coupures |
| 💳 `fact_payments` | Paiements |

---

# 📈 9. Reporting Layer

La couche **Reporting** fournit des modèles prêts à être consommés par les outils BI.

```text
models/
└── marts/
    └── reporting/
        ├── rpt_contract_dashboard.sql
        ├── rpt_customer_overview.sql
        ├── rpt_energy_dashboard.sql
        ├── rpt_finance_dashboard.sql
        ├── rpt_maintenance_dashboard.sql
        └── rpt_outage_dashboard.sql
```

## 📊 Reporting disponible

| Dashboard | Domaine |
|---|---|
| 👥 Customer Overview | Clients |
| 📄 Contract Dashboard | Contrats |
| ⚡ Energy Dashboard | Consommation |
| 💰 Finance Dashboard | Finance |
| 🔧 Maintenance Dashboard | Maintenance |
| 🚨 Outage Dashboard | Incidents |

---

# 🧩 10. Macros dbt

Les **macros dbt** permettent de factoriser les traitements SQL et d'éviter la duplication de code.

Elles centralisent les fonctions réutilisables utilisées dans les différents modèles.

## 📂 Organisation

```text
macros/
│
├── audit/
│   ├── audit_columns.sql
│   ├── audit_created_updated.sql
│   └── incremental_filter.sql
│
├── business/
│   ├── amount_after_tax.sql
│   ├── bool_from_status.sql
│   ├── calculate_delay.sql
│   ├── current_load_timestamp.sql
│   ├── date_key.sql
│   ├── default_unknown.sql
│   ├── invoice_flags.sql
│   ├── payment_flags.sql
│   ├── payment_terms.sql
│   ├── percentage.sql
│   ├── positive_amount.sql
│   ├── safe_divide.sql
│   └── surrogate_key.sql
│
├── casting/
│   ├── clean_numeric.sql
│   ├── to_boolean.sql
│   ├── to_date.sql
│   └── to_timestamp.sql
│
├── cleaning/
│   ├── clean_column.sql
│   ├── clean_email.sql
│   ├── clean_lower.sql
│   ├── clean_lower_column.sql
│   ├── clean_text.sql
│   ├── clean_upper.sql
│   └── clean_upper_column.sql
│
└── joins/
    ├── join_dim_contract.sql
    ├── join_dim_date.sql
    ├── join_dim_meter.sql
    └── join_fact_invoice.sql
```

## 🎯 Catégories de macros

| Catégorie | Rôle |
|---|---|
| 🔍 Audit | Colonnes et informations techniques |
| 💼 Business | Règles métier |
| 🔢 Casting | Conversion des types |
| 🧹 Cleaning | Nettoyage des données |
| 🔗 Joins | Réutilisation des jointures |

## ♻️ Avantages

- réutilisation du code ;
- standardisation ;
- maintenabilité ;
- lisibilité ;
- réduction de la duplication ;
- centralisation de la logique métier.

---

# 🔄 11. Modèles incrémentaux

Le projet utilise des **modèles incrémentaux dbt** afin d'éviter de retraiter inutilement l'ensemble des données.

```text
Nouvelles données
       +
Données modifiées
       │
       ▼
Filtre incrémental
       │
       ▼
Transformation dbt
       │
       ▼
Table cible
```

## 🧩 Macro `incremental_filter`

```text
macros/
└── audit/
    └── incremental_filter.sql
```

### Exemple

```sql
{% macro incremental_filter(source_column, target_column) %}

    {% if is_incremental() %}

        WHERE {{ source_column }} >
        (
            SELECT COALESCE(
                MAX({{ target_column }}),
                '1900-01-01'
            )
            FROM {{ this }}
        )

    {% endif %}

{% endmacro %}
```

Cette macro permet de centraliser la logique de filtrage incrémental et de réduire les volumes retraités.

---

# 📸 12. Snapshots — Historisation

Les **snapshots dbt** permettent de conserver l'historique des changements.

```text
snapshots/
├── snapshot_customers.sql
├── snapshot_contracts.sql
├── snapshot_meters.sql
└── snapshot_customers_check.sql
```

## 🎯 Objectifs

- 🕐 conserver l'historique ;
- 🔄 suivre les modifications ;
- 📊 analyser l'évolution ;
- 🔍 retrouver l'état historique d'un enregistrement.

---

# 🧪 13. Data Quality

La qualité des données est contrôlée automatiquement avec **dbt**.

## ✅ Tests génériques

```text
not_null
unique
relationships
accepted_values
```

## 🧪 Tests métier

```text
tests/
├── test_contract_end_after_start.sql
├── test_customer_birth_date.sql
├── test_customer_registration.sql
├── test_energy_split.sql
├── test_invoice_amount_positive.sql
├── test_invoice_due_date.sql
├── test_paid_invoice_has_payment_date.sql
├── test_payment_amount.sql
├── test_payment_not_greater_than_invoice.sql
└── test_positive_energy_consumption.sql
```

## 🔍 Contrôles métier

| Test | Contrôle |
|---|---|
| `contract_end_after_start` | Cohérence des dates |
| `customer_birth_date` | Cohérence date de naissance |
| `invoice_amount_positive` | Montant facture positif |
| `invoice_due_date` | Date d'échéance |
| `payment_amount` | Montant paiement |
| `payment_not_greater_than_invoice` | Paiement ≤ facture |
| `positive_energy_consumption` | Consommation positive |

---

# 📊 14. Power BI — Business Intelligence

Une fois les données nettoyées, transformées, testées et préparées dans la couche **Gold / Reporting**, elles peuvent être exploitées dans **Power BI**.

## 🔗 Flux BI

```text
AWS S3
   │
   ▼
Snowflake
   │
   ▼
dbt
   │
   ▼
STAGING
   │
   ▼
INTERMEDIATE
   │
   ▼
GOLD
   │
   ▼
REPORTING
   │
   ▼
POWER BI
```

## 📈 Axes d'analyse

### 👥 Customer Analytics

- nombre de clients ;
- évolution du portefeuille ;
- contrats ;
- segmentation.

### ⚡ Energy Analytics

- consommation ;
- évolution ;
- consommation par période ;
- consommation par compteur.

### 💰 Finance Analytics

- facturation ;
- paiements ;
- montants facturés ;
- montants payés ;
- montants dus.

### 🚨 Operations Analytics

- incidents ;
- coupures ;
- maintenance ;
- événements opérationnels.

---

# ⚙️ 15. CI/CD — GitHub Actions

Le projet est industrialisé avec **GitHub Actions**.

Le workflow est défini dans :

```text
.github/
└── workflows/
    └── dbt.yml
```

## 🔄 Pipeline CI/CD

```text
┌─────────────────────────┐
│     GitHub Repository   │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│     Checkout Code       │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│      Setup Python       │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│   Install dbt Snowflake │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│       dbt debug         │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│       dbt deps          │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│       dbt build         │
│     --full-refresh      │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│      Data Tests         │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│      Email Report       │
└─────────────────────────┘
```

---

# 🕐 16. Automatisation

Le workflow peut être déclenché de trois manières.

## 🚀 Push sur `main`

```yaml
push:
  branches:
    - main
```

Chaque modification poussée sur la branche `main` peut déclencher le pipeline.

## ▶️ Exécution manuelle

Le workflow peut également être lancé directement depuis **GitHub Actions**.

## 📅 Exécution quotidienne

```yaml
schedule:
  - cron: "0 6 * * *"
```

Le pipeline est donc exécuté automatiquement chaque jour.

> 💡 L'exécution est effectuée par les serveurs GitHub Actions : le PC local n'a pas besoin d'être allumé.

---

# 🔐 17. Gestion des secrets

Les informations sensibles ne sont pas stockées directement dans le repository.

Elles sont gérées avec **GitHub Secrets**.

## ❄️ Snowflake

```text
SNOWFLAKE_ACCOUNT
SNOWFLAKE_USER
SNOWFLAKE_PASSWORD
SNOWFLAKE_ROLE
SNOWFLAKE_WAREHOUSE
SNOWFLAKE_DATABASE
SNOWFLAKE_SCHEMA
```

## 📧 Email

```text
MAIL_USERNAME
MAIL_PASSWORD
```

## 🔒 Principe

```text
┌──────────────────────┐
│   GitHub Repository  │
│                      │
│        CODE          │
└──────────┬───────────┘
           │
           │ utilise
           ▼
┌──────────────────────┐
│    GitHub Secrets    │
│                      │
│ Credentials / Keys   │
└──────────────────────┘
```

---

# 📧 18. Monitoring & Email Reporting

Après l'exécution du pipeline, un rapport automatique est envoyé par e-mail.

## 🟢 Succès

Une notification est envoyée lorsque le pipeline se termine correctement.

## 🔴 Échec

Une notification est également envoyée lorsqu'une étape rencontre une erreur.

## 📩 Informations transmises

| Information | Exemple |
|---|---|
| Projet | `ouattaraseydou/geip-dbt` |
| Branche | `main` |
| Déclenchement | `push` / `schedule` |
| Commit | SHA du commit |
| Commande | `dbt build --target dev --full-refresh` |
| Statut | `success` / `failure` |
| Logs | GitHub Actions |

### Exemple de rapport

```text
GEIP DBT — Rapport quotidien

STATUT
success

PROJET
ouattaraseydou/geip-dbt

BRANCHE
main

COMMANDE
dbt build --target dev --full-refresh

RESULTAT
Le pipeline dbt s'est terminé correctement.

LOGS
GitHub Actions
```

---

# 📁 19. Structure du projet

```text
geip-dbt/
│
├── .github/
│   └── workflows/
│       └── dbt.yml
│
├── analyses/
│
├── macros/
│   ├── audit/
│   ├── business/
│   ├── casting/
│   ├── cleaning/
│   └── joins/
│
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
│       ├── dimensions/
│       ├── facts/
│       └── reporting/
│
├── seeds/
├── snapshots/
├── tests/
│
├── .gitignore
├── README.md
├── dbt_project.yml
├── packages.yml
└── package-lock.yml
```

---

# 🛠️ 20. Technologies utilisées

| Technologie | Rôle |
|---|---|
| ☁️ **AWS S3** | Data Lake / stockage source |
| ❄️ **Snowflake** | Cloud Data Warehouse |
| 🔧 **dbt** | Transformation & Analytics Engineering |
| 🧮 **SQL** | Transformation des données |
| 🐍 **Python** | Préparation / génération de données |
| 🐙 **GitHub** | Versioning |
| ⚙️ **GitHub Actions** | CI/CD & automatisation |
| 📊 **Power BI** | Business Intelligence & Data Visualization |

---

# 🚀 21. Commandes principales

## 🔍 Vérifier la configuration

```bash
dbt debug
```

## 📦 Installer les packages

```bash
dbt deps
```

## 🧩 Parser le projet

```bash
dbt parse
```

## 🏗️ Construire le projet

```bash
dbt build
```

## 🔄 Full Refresh

```bash
dbt build --full-refresh
```

## 🎯 Construire un modèle spécifique

```bash
dbt build --select dim_customers
```

---

# 📊 22. Résultats du pipeline

Le pipeline permet d'exécuter automatiquement :

- 🏗️ les modèles dbt ;
- 🔄 les modèles incrémentaux ;
- 📸 les snapshots ;
- 🧪 les tests de qualité ;
- 📊 les modèles de reporting ;
- 🔍 les contrôles métier.

## ✅ Dernière exécution validée

```text
Completed successfully

PASS=224
WARN=0
ERROR=0
SKIP=0
NO-OP=0
REUSED=0
TOTAL=224
```

## 🟢 Résultat

| Indicateur | Résultat |
|---|---:|
| ✅ PASS | **224** |
| ⚠️ WARN | **0** |
| ❌ ERROR | **0** |
| ⏭️ SKIP | **0** |
| 🔁 REUSED | **0** |
| 📊 TOTAL | **224** |

### 🎯 Statut

> 🟢 **PIPELINE SUCCESS — 224/224 éléments exécutés avec succès**

---

# 🗺️ 23. Roadmap

## 🚧 Évolutions prévues

- [ ] ☁️ Finaliser l'intégration **AWS S3 → Snowflake**
- [ ] 🔄 Automatiser l'ingestion depuis S3
- [ ] ❄️ Optimiser les traitements Snowflake
- [ ] 🧪 Enrichir la Data Quality
- [ ] 📚 Générer la documentation dbt
- [ ] 📊 Finaliser les dashboards Power BI
- [ ] 📈 Améliorer le monitoring
- [ ] 🌍 Mettre en place les environnements `dev`, `staging` et `prod`

---

# 🧠 24. Compétences démontrées

## 🏗️ Data Engineering

`Data Lake` · `Data Warehouse` · `ETL / ELT` · `Data Modeling` · `Incremental Processing` · `Data Quality`

## ☁️ Cloud

`AWS S3` · `Snowflake`

## 🔧 Analytics Engineering

`dbt` · `SQL` · `Jinja` · `Macros` · `Tests` · `Snapshots`

## 📊 Business Intelligence

`Power BI` · `Data Visualization` · `KPI` · `Reporting`

## ⚙️ DevOps / CI-CD

`Git` · `GitHub` · `GitHub Actions` · `CI/CD` · `Secrets Management` · `Automated Monitoring`

---

# 👨‍💻 25. Auteur

## Ouattara Seydou

**Data Analyst | Data Engineer | Business Intelligence**

### 🛠️ Stack

```text
SQL
Python
Power BI
Snowflake
dbt
AWS S3
Talend
Git
GitHub Actions
Data Engineering
Business Intelligence
ETL / ELT
```

---

# 🔗 Projet GitHub

<p align="center">

<a href="https://github.com/ouattaraseydou/geip-dbt">
<img src="https://img.shields.io/badge/VIEW%20ON%20GITHUB-181717?style=for-the-badge&logo=github&logoColor=white" alt="View on GitHub">
</a>

</p>

<p align="center">

👉 <strong>
<a href="https://github.com/ouattaraseydou/geip-dbt">
github.com/ouattaraseydou/geip-dbt
</a>
</strong>

</p>

---

<p align="center">

### ⚡ GEIP — Energy Data Platform

<strong>Data Engineering • Analytics Engineering • Business Intelligence</strong>

<br><br>

AWS S3 • Snowflake • dbt • SQL • Python • GitHub Actions • Power BI

</p>
