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

```
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
```

🎯 Rôle de S3

AWS S3 permet de :

📦 stocker les données sources ;
🗂️ organiser les données par domaine métier ;
🔄 conserver les données brutes avant transformation ;
☁️ fournir une couche de stockage scalable ;
🔗 alimenter le pipeline Data Engineering.

🚧 Statut : l'intégration complète AWS S3 → Snowflake constitue une étape d'évolution du projet.

---

# ❄️ Snowflake — Data Warehouse

Snowflake constitue le Data Warehouse Cloud du projet GEIP.

Il permet de centraliser les données et de stocker les différentes couches du modèle analytique.

## ❄️ Organisation du Data Warehouse

La base **GEIP_PROD** est organisée en plusieurs couches afin de séparer les données selon leur niveau de transformation.

```text
GEIP_PROD
│
├── 📁 LANDING
│   └── Données sources brutes
│
├── 📁 STAGING
│   └── Nettoyage et standardisation
│
├── 📁 INTERMEDIATE
│   └── Transformations et jointures métier
│
└── 📁 GOLD
    │
    ├── 📁 DIMENSIONS
    │   └── Données descriptives
    │
    ├── 📁 FACTS
    │   └── Données transactionnelles et mesures
    │
    └── 📁 REPORTING
        └── Modèles destinés à Power BI
```

### 🔄 Flux de transformation

```text
┌──────────────┐
│   LANDING    │
│  Données RAW │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   STAGING    │
│ Nettoyage    │
│ Standardisation│
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ INTERMEDIATE │
│ Jointures    │
│ Logique métier│
└──────┬───────┘
       │
       ▼
┌────────────────────────────┐
│            GOLD            │
│                            │
│  DIMENSIONS │ FACTS │ RPT  │
└─────────────┬──────────────┘
              │
              ▼
       ┌──────────────┐
       │   POWER BI   │
       │  Dashboards  │
       └──────────────┘
```

### 📌 Rôle des différentes couches

| Couche | Rôle |
|---|---|
| 🟤 **LANDING** | Stockage des données sources brutes |
| 🥉 **STAGING** | Nettoyage, typage et standardisation |
| 🥈 **INTERMEDIATE** | Jointures et transformations métier |
| 🥇 **GOLD** | Données analytiques finales |
| 📐 **DIMENSIONS** | Contexte descriptif |
| 📊 **FACTS** | Mesures et événements métier |
| 📈 **REPORTING** | Données préparées pour Power BI |


---

# 🔧 dbt — Transformation & Analytics Engineering

**dbt (Data Build Tool)** est le moteur de transformation et de modélisation utilisé dans le projet GEIP.

Il permet de transformer les données dans **Snowflake**, de gérer les dépendances entre modèles et d'automatiser les contrôles de qualité.

## 🔄 Architecture dbt

```text
┌─────────────────────┐
│       LANDING       │
│    Données brutes   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│       STAGING       │
│ Nettoyage / Typage  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│    INTERMEDIATE     │
│ Jointures / Métier  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│        GOLD         │
│ Dimensions / Facts  │
│     / Reporting     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      POWER BI       │
│ Dashboards / KPI    │
└─────────────────────┘
```

---

# 🥉 Staging Layer

La couche **Staging** constitue la première étape de transformation des données.

Elle permet de préparer les données sources avant leur utilisation dans les transformations métier.

### 🎯 Principales responsabilités

- 🧹 Nettoyage des données
- 🔤 Standardisation des noms de colonnes
- 🔢 Conversion des types
- 🧼 Normalisation des valeurs
- 📋 Préparation des données pour les couches suivantes

### 📂 Modèles Staging

```text
models/
└── staging/
    └── landing/
        │
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

### 📌 Principe

Les modèles Staging restent volontairement proches des données sources.

Ils servent principalement à :

> **Nettoyer → Standardiser → TypER → Préparer**

---

# 🥈 Intermediate Layer

La couche **Intermediate** contient les transformations nécessaires avant la construction des modèles analytiques finaux.

Elle permet de centraliser les traitements métier complexes afin d'éviter de les dupliquer dans les modèles Gold.

### 🔗 Principales transformations

- Jointures entre les différentes sources
- Enrichissement des données
- Application des règles métier
- Préparation des relations entre les entités
- Calcul de données intermédiaires

### 📂 Modèles Intermediate

```text
models/
└── intermediate/
    │
    ├── int_customer_contracts.sql
    ├── int_contract_meters.sql
    ├── int_customer_service.sql
    ├── int_invoice_payments.sql
    ├── int_meter_consumption.sql
    ├── int_outages.sql
    └── int_maintenance.sql
```

### 🔄 Exemple de flux

```text
Customers ─────────┐
                   │
Contracts ─────────┼──────► int_customer_contracts
                   │
                   │
Meters ────────────┘
```

La couche Intermediate joue donc le rôle de **zone de préparation métier** avant la couche Gold.

---

# 🥇 Gold Layer

La couche **Gold** contient les données finales destinées aux analyses et au reporting.

Elle est organisée en trois grandes catégories :

```text
GOLD
│
├── 📐 DIMENSIONS
│
├── 📊 FACTS
│
└── 📈 REPORTING
```

Cette couche constitue le **Data Warehouse analytique** utilisé par les outils de Business Intelligence.

---

# 📐 Dimensions

Les dimensions contiennent les informations descriptives utilisées pour analyser les données.

## 👤 `dim_customers`

Dimension contenant les informations relatives aux clients.

Elle permet notamment d'analyser :

- les clients ;
- leur profil ;
- leur situation ;
- leur rattachement aux contrats.

---

## 📄 `dim_contracts`

Dimension contenant les informations relatives aux contrats.

Elle permet d'analyser :

- les contrats actifs ;
- les contrats terminés ;
- les dates de début ;
- les dates de fin ;
- les relations avec les clients.

---

## ⚡ `dim_meters`

Dimension contenant les informations relatives aux compteurs.

Elle permet notamment d'analyser les équipements et leur relation avec les contrats.

---

## 📅 `dim_date`

Dimension calendrier utilisée pour les analyses temporelles.

Elle permet de faciliter les analyses par :

- année ;
- trimestre ;
- mois ;
- semaine ;
- jour.

---

# 📊 Facts — Tables de faits

Les tables de faits contiennent les événements et les mesures métier.

### Principales tables

```text
models/
└── marts/
    └── facts/
        │
        ├── fact_energy_consumption.sql
        ├── fact_invoices.sql
        ├── fact_outages.sql
        └── fact_payments.sql
```

### ⚡ `fact_energy_consumption`

Permet d'analyser la consommation énergétique.

### 🧾 `fact_invoices`

Permet d'analyser la facturation.

### 🚨 `fact_outages`

Permet d'analyser les incidents et les coupures.

### 💳 `fact_payments`

Permet d'analyser les paiements associés aux factures.

---

# 📈 Reporting Layer

La couche Reporting fournit des modèles directement exploitables par les outils de Business Intelligence.

```text
models/
└── marts/
    └── reporting/
        │
        ├── rpt_contract_dashboard.sql
        ├── rpt_customer_overview.sql
        ├── rpt_energy_dashboard.sql
        ├── rpt_finance_dashboard.sql
        ├── rpt_maintenance_dashboard.sql
        └── rpt_outage_dashboard.sql
```

## 📊 Principaux domaines de reporting

| Reporting | Domaine |
|---|---|
| 👥 Customer Overview | Analyse clients |
| 📄 Contract Dashboard | Analyse contrats |
| ⚡ Energy Dashboard | Consommation énergétique |
| 💰 Finance Dashboard | Facturation et paiements |
| 🔧 Maintenance Dashboard | Maintenance |
| 🚨 Outage Dashboard | Incidents et coupures |

---

# 🔄 Modèles incrémentaux

Le projet utilise des **modèles incrémentaux dbt** pour optimiser certains traitements.

L'objectif est de ne pas reconstruire inutilement l'ensemble des données à chaque exécution.

```text
Nouvelle exécution
       │
       ▼
Nouvelles données
       │
       +
Données modifiées
       │
       ▼
Traitement incrémental
       │
       ▼
Table cible
```

## 🧩 Macro `incremental_filter`

Une macro dédiée est utilisée pour appliquer automatiquement le filtre incrémental.

```text
macros/
└── audit/
    └── incremental_filter.sql
```

La macro compare la colonne source avec la dernière valeur présente dans la table cible.

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

Cette approche permet de limiter les volumes retraités et d'améliorer les performances du pipeline.

---

# 📸 Snapshots — Historisation

Les **snapshots dbt** permettent de conserver l'historique des changements sur certaines données.

```text
snapshots/
│
├── snapshot_customers.sql
├── snapshot_contracts.sql
├── snapshot_meters.sql
└── snapshot_customers_check.sql
```

### 🎯 Objectif

Les snapshots permettent notamment de :

- 🕐 conserver l'historique ;
- 🔄 suivre les modifications ;
- 📊 analyser l'évolution des données ;
- 🔍 retrouver l'état historique d'un enregistrement.

---

# 🧪 Data Quality

La qualité des données est contrôlée automatiquement avec **dbt**.

Le projet contient des tests génériques et des tests métier personnalisés.

## ✅ Tests génériques

- `not_null`
- `unique`
- `relationships`
- `accepted_values`

## 🧪 Tests métier

```text
tests/
│
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

### 🔍 Exemples de contrôles

| Test | Contrôle |
|---|---|
| `test_contract_end_after_start` | Cohérence des dates de contrat |
| `test_customer_birth_date` | Cohérence des dates de naissance |
| `test_customer_registration` | Cohérence des inscriptions |
| `test_invoice_amount_positive` | Montant de facture positif |
| `test_invoice_due_date` | Cohérence de la date d'échéance |
| `test_payment_amount` | Contrôle du montant des paiements |
| `test_payment_not_greater_than_invoice` | Paiement ≤ montant facture |
| `test_positive_energy_consumption` | Consommation positive |

---

# ⚙️ CI/CD — GitHub Actions

Le projet est automatisé avec **GitHub Actions**.

Le workflow est situé dans :

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
│   GitHub Actions        │
│                         │
│   Checkout Repository   │
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
│      dbt debug          │
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

# 🕐 Automatisation

Le pipeline peut être déclenché de plusieurs façons.

### 🚀 1. Après un `push`

```yaml
push:
  branches:
    - main
```

Toute modification envoyée sur `main` peut donc déclencher automatiquement le pipeline.

### ▶️ 2. Manuellement

Le workflow peut être lancé directement depuis l'interface **GitHub Actions**.

### 📅 3. Chaque jour

Une exécution planifiée est configurée avec :

```yaml
schedule:
  - cron: "0 6 * * *"
```

Le pipeline est alors exécuté automatiquement par **GitHub Actions**, même lorsque le PC local est éteint.

---

# 🔄 Full Refresh

Le pipeline utilise actuellement :

```bash
dbt build --target dev --full-refresh
```

Le `--full-refresh` permet de reconstruire complètement les modèles incrémentaux.

Cette commande est notamment utile pour :

- 🔄 reconstruire les modèles ;
- 🧹 repartir d'un état propre ;
- 🧪 valider l'ensemble du pipeline ;
- 🔧 appliquer une modification importante de logique.

---

# 📧 Email Reporting

Après chaque exécution du pipeline, un rapport automatique est envoyé par e-mail.

Le système permet de recevoir une notification :

- 🟢 lorsque le pipeline réussit ;
- 🔴 lorsqu'une erreur survient.

## 📩 Informations envoyées

Le rapport contient :

| Information | Exemple |
|---|---|
| 📌 Projet | `ouattaraseydou/geip-dbt` |
| 🌿 Branche | `main` |
| 🚀 Déclenchement | `push` / `schedule` |
| 🔢 Commit | SHA du commit |
| 🔧 Commande | `dbt build --target dev --full-refresh` |
| 📊 Statut | `success` / `failure` |
| 🔗 Logs | GitHub Actions |

### Exemple de notification

```text
GEIP DBT - Rapport quotidien

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

# 🔐 Gestion des secrets

Les informations sensibles ne sont jamais stockées directement dans le code source.

Elles sont stockées dans **GitHub Secrets**.

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

Cette approche permet de séparer :

**Code source**

```text
GitHub Repository
```

et

**Credentials**

```text
GitHub Secrets
```

---

# 📊 Power BI — Business Intelligence

La couche **Gold** constitue la source analytique destinée à **Power BI**.

Power BI permet de construire des dashboards interactifs à partir des modèles de reporting.

## 📈 Domaines d'analyse

### 👥 Customer Analytics

- nombre de clients ;
- évolution du portefeuille ;
- analyse des contrats ;
- segmentation.

### ⚡ Energy Analytics

- consommation énergétique ;
- évolution de la consommation ;
- consommation par période ;
- consommation par compteur.

### 💰 Finance Analytics

- facturation ;
- paiements ;
- montants facturés ;
- montants payés ;
- montants restant dus.

### 🚨 Operations Analytics

- incidents ;
- coupures ;
- maintenance ;
- suivi opérationnel.

---

# 🧩 Macros dbt

Le projet utilise des macros réutilisables afin de centraliser les traitements SQL.

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

### 🎯 Pourquoi utiliser des macros ?

- ♻️ Réutilisation du code
- 🧹 Standardisation
- 🔧 Maintenabilité
- 📖 Lisibilité
- 🚫 Réduction de la duplication

---

# 📁 Structure du projet

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

# 🛠️ Technologies utilisées

| Technologie | Utilisation |
|---|---|
| ☁️ **AWS S3** | Data Lake et stockage des données sources |
| ❄️ **Snowflake** | Data Warehouse Cloud |
| 🔧 **dbt** | Transformation et modélisation |
| 🧮 **SQL** | Transformation et analyse |
| 🐍 **Python** | Préparation et génération de données |
| 🐙 **GitHub** | Versioning et gestion du projet |
| ⚙️ **GitHub Actions** | CI/CD et automatisation |
| 📊 **Power BI** | Business Intelligence et Data Visualization |

---

# 🚀 Commandes principales

### 🔍 Vérifier la configuration

```bash
dbt debug
```

### 📦 Installer les packages

```bash
dbt deps
```

### 🧩 Parser le projet

```bash
dbt parse
```

### 🏗️ Construire le projet

```bash
dbt build
```

### 🔄 Reconstruction complète

```bash
dbt build --full-refresh
```

### 🎯 Construire un modèle spécifique

```bash
dbt build --select dim_customers
```

---

# 📊 Résultats du pipeline

Le pipeline GEIP permet d'exécuter automatiquement :

- 🏗️ les modèles dbt ;
- 🔄 les modèles incrémentaux ;
- 📸 les snapshots ;
- 🧪 les tests de qualité ;
- 📊 les modèles de reporting ;
- 🔍 les contrôles métier.

### ✅ Exemple d'exécution réussie

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

Cette exécution démontre que l'ensemble des composants du pipeline peut être validé automatiquement.

---

# 🔭 Roadmap

Les prochaines étapes du projet sont :

- [ ] ☁️ Finaliser l'intégration **AWS S3 → Snowflake**
- [ ] 🔄 Automatiser l'ingestion des données depuis S3
- [ ] ❄️ Optimiser les traitements Snowflake
- [ ] 🧪 Enrichir les tests de Data Quality
- [ ] 📚 Générer la documentation dbt
- [ ] 📊 Finaliser les dashboards Power BI
- [ ] 📈 Améliorer le monitoring
- [ ] 🌍 Mettre en place les environnements `dev`, `staging` et `prod`

---

# 🧠 Compétences démontrées

### 🏗️ Data Engineering

- Data Lake
- Data Warehouse
- ETL / ELT
- Data Modeling
- Incremental Processing
- Data Quality
- Data Transformation

### ☁️ Cloud

- AWS S3
- Snowflake

### 🔧 Analytics Engineering

- dbt
- SQL
- Jinja
- Macros
- Tests
- Snapshots

### 📊 Business Intelligence

- Power BI
- Data Visualization
- KPI
- Reporting

### ⚙️ DevOps / CI-CD

- Git
- GitHub
- GitHub Actions
- CI/CD
- Secrets Management
- Automated Monitoring

---

# 👨‍💻 Auteur

## Ouattara Seydou

**Data Analyst | Data Engineer | Business Intelligence**

### 🛠️ Stack technique

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
<img src="https://img.shields.io/badge/GitHub-GEIP--DBT-181717?style=for-the-badge&logo=github" alt="GitHub GEIP DBT">
</a>

</p>

👉 **[Accéder au repository GEIP DBT](https://github.com/ouattaraseydou/geip-dbt)**

---

<p align="center">

⭐ **GEIP — Energy Data Platform**

**Data Engineering • Analytics Engineering • Business Intelligence**

</p>
