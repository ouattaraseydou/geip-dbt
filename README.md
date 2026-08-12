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


☁️ AWS S3 — Data Lake

Amazon S3 est prévu comme couche de stockage des données sources du projet.

Le Data Lake a pour objectif de centraliser les données brutes avant leur exploitation dans Snowflake.

L'organisation cible des données est la suivante :

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

Cette organisation permet de séparer les différentes sources métier et de faciliter leur intégration dans la plateforme analytique.

🚧 Statut : l'intégration AWS S3 → Snowflake sera documentée et finalisée dans une prochaine étape du projet.

❄️ Snowflake — Data Warehouse

Snowflake constitue la plateforme Data Warehouse du projet.

Il est utilisé pour centraliser les données et héberger les différentes couches du modèle analytique.

L'organisation cible est :

GEIP_PROD
│
├── LANDING
│
├── BRONZE
│
├── SILVER
│
├── GOLD
│
└── UTILS

Les transformations et la modélisation sont ensuite réalisées avec dbt.

🔧 dbt — Transformation & Analytics Engineering

dbt (Data Build Tool) constitue le moteur de transformation et de modélisation du projet.

dbt permet de transformer les données directement dans Snowflake à travers une architecture organisée en plusieurs couches.

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

Les modèles dbt sont organisés selon leur rôle dans le Data Warehouse.

🥉 Staging

La couche Staging constitue la première couche de transformation.

Elle permet notamment :

de nettoyer les données ;
de standardiser les colonnes ;
de convertir les types de données ;
de normaliser certaines valeurs ;
de préparer les données pour les transformations intermédiaires.

Exemples :

stg_landing_customers
stg_landing_contracts
stg_landing_meters
stg_landing_invoices
stg_landing_payments
stg_landing_energy_consumption
stg_landing_outages
stg_landing_maintenance
stg_landing_customer_service
🥈 Intermediate

La couche Intermediate contient les transformations intermédiaires nécessaires à la construction du modèle analytique.

Elle permet notamment de gérer :

les jointures entre les différentes entités ;
les enrichissements ;
les transformations métier ;
la préparation des données pour les dimensions et les tables de faits.

Exemples :

int_customer_contracts
int_contract_meters
int_customer_service
int_invoice_payments
int_meter_consumption
int_outages
int_maintenance
🥇 Gold — Data Warehouse analytique

La couche Gold contient les données finales destinées à l'analyse et au reporting.

Elle est organisée autour de :

GOLD
│
├── Dimensions
│
├── Facts
│
└── Reporting
📐 Dimensions

Les principales dimensions sont :

dim_date

Dimension calendrier utilisée pour les analyses temporelles.

dim_customers

Dimension contenant les informations descriptives des clients.

dim_contracts

Dimension contenant les informations relatives aux contrats.

dim_meters

Dimension contenant les caractéristiques techniques des compteurs.

📊 Tables de faits

Les principales tables de faits sont :

fact_invoices
fact_payments
fact_energy_consumption
fact_outages

Elles permettent de construire les indicateurs analytiques et les tableaux de bord.

📈 Reporting

Des modèles dédiés au reporting sont également construits dans la couche Gold :

rpt_customer_overview
rpt_contract_dashboard
rpt_energy_dashboard
rpt_finance_dashboard
rpt_maintenance_dashboard
rpt_outage_dashboard

Ces modèles sont destinés à être exploités par les outils de Business Intelligence, notamment Power BI.

🔄 Incremental Models

Le projet utilise des modèles incrémentaux dbt afin d'optimiser le traitement des données.

Le principe consiste à charger uniquement les nouvelles données ou les données modifiées au lieu de reconstruire systématiquement l'ensemble de la table.

Une macro dédiée est utilisée pour gérer cette logique :

macros/
└── audit/
    └── incremental_filter.sql

La macro permet notamment de comparer les données sources avec la dernière valeur chargée dans la table cible.

📸 Snapshots — Historisation

Le projet utilise également les snapshots dbt pour conserver l'historique des changements.

Les snapshots permettent de suivre l'évolution des données métier dans le temps.

snapshots/
│
├── snapshot_customers.sql
├── snapshot_contracts.sql
├── snapshot_meters.sql
└── snapshot_customers_check.sql
🧪 Data Quality

La qualité des données constitue une composante essentielle du projet.

Des tests automatisés sont exécutés avec dbt afin de contrôler la cohérence et la fiabilité des données.

Les contrôles comprennent notamment :

not_null
unique
accepted_values
tests de relations ;
tests métier personnalisés ;
contrôles de dates ;
contrôles financiers ;
contrôles énergétiques ;
contrôles de cohérence.

Exemples de tests métier :

test_customer_birth_date
test_customer_registration
test_contract_end_after_start
test_energy_split
test_invoice_amount_positive
test_invoice_due_date
test_paid_invoice_has_payment_date
test_payment_amount
test_payment_not_greater_than_invoice
test_positive_energy_consumption
⚙️ CI/CD — GitHub Actions

Le projet est industrialisé avec GitHub Actions.

Le workflow principal est :

.github/
└── workflows/
    └── dbt.yml

Le pipeline réalise automatiquement les étapes suivantes :

Checkout repository
        │
        ▼
Setup Python
        │
        ▼
Install dbt-snowflake
        │
        ▼
Create dbt profile
        │
        ▼
dbt debug
        │
        ▼
dbt deps
        │
        ▼
dbt build
        │
        ▼
Data Tests
        │
        ▼
Email Report
🕐 Automatisation

Le workflow GitHub Actions peut être déclenché :

À chaque push sur main
push:
  branches:
    - main
Manuellement

Le workflow peut être lancé directement depuis l'interface GitHub Actions.

Automatiquement chaque jour

Une exécution planifiée est configurée avec :

schedule:
  - cron: "0 6 * * *"

L'exécution est réalisée par GitHub Actions et ne dépend donc pas du fonctionnement du poste local.

🔄 Full Refresh

Le pipeline peut reconstruire complètement les modèles incrémentaux avec :

dbt build --target dev --full-refresh

Cette commande permet notamment de reconstruire intégralement les modèles concernés lorsque cela est nécessaire.

📧 Monitoring & Email Reporting

Un système de notification automatique par e-mail est intégré au workflow GitHub Actions.

Après l'exécution du pipeline, un rapport est envoyé avec notamment :

le statut du workflow ;
le repository ;
la branche ;
le commit ;
le type de déclenchement ;
la commande dbt exécutée ;
le lien vers les logs GitHub Actions.

Le système permet également de recevoir une notification lorsque le workflow rencontre une erreur.

🔐 Gestion des secrets

Les informations sensibles ne sont pas stockées directement dans le repository.

Les credentials sont gérés avec GitHub Secrets.

Exemples :

SNOWFLAKE_ACCOUNT
SNOWFLAKE_USER
SNOWFLAKE_PASSWORD
SNOWFLAKE_ROLE
SNOWFLAKE_WAREHOUSE
SNOWFLAKE_DATABASE
SNOWFLAKE_SCHEMA

MAIL_USERNAME
MAIL_PASSWORD

Le fichier profiles.yml est également exclu du repository via .gitignore.

📊 Power BI — Business Intelligence

Les données de la couche Gold sont destinées à être exploitées dans Power BI.

Power BI permet de construire des tableaux de bord et des indicateurs autour de plusieurs domaines :

👥 Customer Analytics
évolution du nombre de clients ;
segmentation ;
analyse des contrats ;
analyse du portefeuille client.
⚡ Energy Analytics
consommation énergétique ;
évolution de la consommation ;
analyse par compteur ;
analyse temporelle.
💰 Finance Analytics
facturation ;
paiements ;
montants dus ;
suivi des règlements ;
indicateurs financiers.
🚨 Operations
incidents ;
coupures ;
maintenance ;
suivi opérationnel.
🧩 Macros dbt

Le projet contient plusieurs macros réutilisables permettant de centraliser les traitements.

Organisation :

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

Ces macros permettent notamment de favoriser :

la réutilisation du code ;
la standardisation ;
la maintenabilité ;
la lisibilité ;
la réduction de la duplication SQL.
📁 Structure du projet
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
│   │   └── landing/
│   │
│   ├── intermediate/
│   │
│   ├── marts/
│   │   ├── dimensions/
│   │   ├── facts/
│   │   └── reporting/
│   │
│   └── sources/
│
├── snapshots/
│
├── seeds/
│
├── tests/
│
├── .gitignore
├── dbt_project.yml
├── packages.yml
├── package-lock.yml
└── README.md
🛠️ Technologies utilisées
Technologie	Utilisation
☁️ AWS S3	Data Lake / stockage des données sources
❄️ Snowflake	Data Warehouse Cloud
🔧 dbt	Transformation, modélisation et Data Quality
🧮 SQL	Transformation et analyse des données
🐍 Python	Préparation et génération de données
📦 Git	Versioning
🐙 GitHub	Gestion du code source
⚙️ GitHub Actions	CI/CD et automatisation
📊 Power BI	Business Intelligence et Data Visualization
🚀 Commandes principales
Installer les packages
dbt deps
Vérifier la connexion
dbt debug
Parser le projet
dbt parse
Construire le projet
dbt build
Reconstruction complète
dbt build --full-refresh
Construire un modèle spécifique
dbt build --select dim_customers
📈 Résultats

Le projet permet de construire automatiquement :

les modèles Staging ;
les modèles Intermediate ;
les dimensions ;
les tables de faits ;
les modèles de reporting ;
les snapshots ;
les tests de qualité ;
les contrôles métier.

Une exécution complète récente du pipeline a produit :

PASS  = 224
WARN  = 0
ERROR = 0
SKIP  = 0
TOTAL = 224

Le pipeline est donc capable d'automatiser la transformation, la validation et la publication des données analytiques.

🔭 Évolutions prévues

Les prochaines évolutions du projet comprennent notamment :

finalisation de l'intégration AWS S3 → Snowflake ;
automatisation de l'ingestion des données ;
optimisation des performances Snowflake ;
amélioration des contrôles de Data Quality ;
génération de la documentation dbt ;
développement des dashboards Power BI ;
amélioration du monitoring ;
mise en place d'environnements dev, staging et prod.
🧠 Compétences démontrées
Data Engineering
Data Lake
Data Warehouse
ETL / ELT
Data Modeling
Incremental Processing
Data Quality
Data Transformation
Cloud
AWS S3
Snowflake
Analytics Engineering
dbt
SQL
Jinja
Macros
Tests
Snapshots
Business Intelligence
Power BI
Data Visualization
KPI
Reporting
DevOps / CI-CD
Git
GitHub
GitHub Actions
CI/CD
Secrets Management
Automated Monitoring
👨‍💻 Auteur
Ouattara Seydou

Data Analyst | Data Engineer | Business Intelligence

Compétences principales :

SQL
Python
Power BI
Snowflake
dbt
AWS
Talend
Data Engineering
Business Intelligence
Data Visualization
ETL / ELT
🔗 Projet GitHub

👉 Voir le projet GEIP sur GitHub
