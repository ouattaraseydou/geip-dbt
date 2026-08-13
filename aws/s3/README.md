# ☁️ AWS S3 — GEIP Data Lake

## 📌 Présentation

**AWS S3** constitue la couche **Data Lake** du projet **GEIP — Energy Data Platform**.

Le bucket S3 est utilisé comme zone de stockage des données sources avant leur intégration dans **Snowflake**, leur transformation avec **dbt** et leur exploitation dans **Power BI**.

---

# 🏗️ Architecture S3

Le Data Lake GEIP est organisé autour du bucket :

```text
geip-data-lake-ouattara
```

Les données sont regroupées dans une zone `landing/` selon leur domaine métier.

```text
geip-data-lake-ouattara/
│
└── landing/
    │
    ├── 📁 contracts/
    │   └── contracts.csv
    │
    ├── 📁 customer_service/
    │
    ├── 📁 customers/
    │
    ├── 📁 energy_consumption/
    │
    ├── 📁 invoices/
    │
    ├── 📁 maintenance/
    │
    ├── 📁 meters/
    │
    ├── 📁 outages/
    │
    └── 📁 payments/
```

---

# 📊 Données sources

| Domaine | Description |
|---|---|
| 👤 `customers/` | Données clients |
| 📄 `contracts/` | Données contrats |
| 🎧 `customer_service/` | Données liées au service client |
| ⚡ `energy_consumption/` | Données de consommation énergétique |
| 🧾 `invoices/` | Données de facturation |
| 🔧 `maintenance/` | Données de maintenance |
| ⚙️ `meters/` | Données des compteurs |
| 🚨 `outages/` | Incidents et coupures |
| 💳 `payments/` | Données de paiement |

---

# 📦 Exemple de fichier source

Le domaine `contracts` contient notamment :

```text
landing/
└── contracts/
    └── contracts.csv
```

Le fichier source observé dans S3 est au format **CSV**.

```text
File       : contracts.csv
Format     : CSV
Size       : 134.8 MB
Storage    : S3 Standard
Location   : landing/contracts/
```

---

# 🔄 Pipeline d'ingestion

Le processus d'ingestion des données suit les étapes suivantes :

```text
┌─────────────────────┐
│   Fichiers sources  │
│       CSV           │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      AWS S3         │
│     Data Lake       │
│                     │
│      landing/       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      Snowflake      │
│      LANDING        │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│        dbt          │
│                     │
│ STAGING             │
│ INTERMEDIATE        │
│ GOLD                │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      Power BI       │
│                     │
│ Dashboards / KPI    │
└─────────────────────┘
```

---

# 🚀 Chargement des fichiers dans S3

Les fichiers sources peuvent être chargés dans S3 à l'aide de l'interface AWS ou de la CLI AWS.

## 1️⃣ Installation AWS CLI

Vérifier que AWS CLI est disponible :

```bash
aws --version
```

---

## 2️⃣ Configuration AWS CLI

Configurer les credentials AWS :

```bash
aws configure
```

Les informations demandées sont :

```text
AWS Access Key ID
AWS Secret Access Key
Default region name
Default output format
```

> ⚠️ Les credentials AWS ne doivent jamais être commités dans GitHub.

---

# 3️⃣ Vérification du bucket

Lister les buckets accessibles :

```bash
aws s3 ls
```

Vérifier le bucket GEIP :

```bash
aws s3 ls s3://geip-data-lake-ouattara/
```

---

# 4️⃣ Création de la structure Landing

Créer les différents préfixes du Data Lake :

```bash
aws s3api put-object \
    --bucket geip-data-lake-ouattara \
    --key landing/customers/
```

```bash
aws s3api put-object \
    --bucket geip-data-lake-ouattara \
    --key landing/contracts/
```

```bash
aws s3api put-object \
    --bucket geip-data-lake-ouattara \
    --key landing/customer_service/
```

```bash
aws s3api put-object \
    --bucket geip-data-lake-ouattara \
    --key landing/energy_consumption/
```

```bash
aws s3api put-object \
    --bucket geip-data-lake-ouattara \
    --key landing/invoices/
```

```bash
aws s3api put-object \
    --bucket geip-data-lake-ouattara \
    --key landing/maintenance/
```

```bash
aws s3api put-object \
    --bucket geip-data-lake-ouattara \
    --key landing/meters/
```

```bash
aws s3api put-object \
    --bucket geip-data-lake-ouattara \
    --key landing/outages/
```

```bash
aws s3api put-object \
    --bucket geip-data-lake-ouattara \
    --key landing/payments/
```

---

# 5️⃣ Chargement d'un fichier

Exemple avec le fichier `contracts.csv` :

```bash
aws s3 cp contracts.csv \
s3://geip-data-lake-ouattara/landing/contracts/contracts.csv
```

Le fichier est alors disponible dans :

```text
s3://geip-data-lake-ouattara/landing/contracts/contracts.csv
```

---

# 6️⃣ Chargement de plusieurs fichiers

Pour charger plusieurs fichiers d'un dossier local :

```bash
aws s3 cp ./data/ \
s3://geip-data-lake-ouattara/landing/ \
--recursive
```

Cette commande permet de transférer automatiquement les fichiers présents dans le dossier local vers S3.

---

# 7️⃣ Vérification des fichiers

Lister les objets présents dans `landing/` :

```bash
aws s3 ls \
s3://geip-data-lake-ouattara/landing/ \
--recursive
```

Exemple :

```text
landing/contracts/contracts.csv
landing/customers/customers.csv
landing/invoices/invoices.csv
landing/payments/payments.csv
...
```

---

# 📊 Vérification de la taille des fichiers

Pour afficher la taille des objets :

```bash
aws s3 ls \
s3://geip-data-lake-ouattara/landing/ \
--recursive \
--human-readable \
--summarize
```

Cela permet notamment de contrôler que les fichiers ont bien été transférés.

---

# 🔍 Contrôle après ingestion

Après chaque chargement, plusieurs contrôles peuvent être effectués :

```text
             UPLOAD
                │
                ▼
        ┌───────────────┐
        │ Fichier S3    │
        └───────┬───────┘
                │
                ▼
        Vérification
                │
        ┌───────┴───────┐
        │               │
        ▼               ▼
      Existe         Taille
        │               │
        └───────┬───────┘
                ▼
          Validation
```

---

# 🔐 Sécurité

Les informations sensibles AWS ne sont jamais stockées dans ce repository.

Les éléments suivants doivent rester secrets :

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```

Ils doivent être gérés via :

- AWS IAM ;
- variables d'environnement ;
- GitHub Secrets pour la CI/CD.

> ⚠️ Ne jamais publier une clé AWS dans le README, le code ou une capture d'écran.

---

# 🧩 Intégration avec Snowflake

Une fois les données disponibles dans S3, elles peuvent être exposées à Snowflake via un **External Stage**.

```text
AWS S3
   │
   │
   ▼
External Stage
   │
   ▼
Snowflake LANDING
   │
   ▼
dbt
```

La configuration Snowflake sera documentée dans :

```text
snowflake/
```

---

# ⚙️ Industrialisation

L'objectif final est d'automatiser le processus :

```text
        AWS S3
           │
           ▼
      Snowflake
           │
           ▼
          dbt
           │
           ├── Data Tests
           ├── Incremental Models
           ├── Snapshots
           └── Data Quality
           │
           ▼
        Power BI
```

Le pipeline est ensuite exécuté automatiquement avec **GitHub Actions**.

---

# 📸 Infrastructure AWS

Les captures d'écran présentent l'environnement S3 utilisé pour le projet.

### Bucket GEIP

Le bucket contient une zone `landing/` organisée par domaine métier.

### Domaine Contracts

Le dossier `contracts/` contient notamment le fichier :

```text
contracts.csv
```

Ces captures permettent de visualiser concrètement la structure du Data Lake.

---

# 🧰 Compétences démontrées

- ☁️ AWS S3
- 🗃️ Data Lake
- 📦 Object Storage
- 🗂️ Organisation des données
- 🖥️ AWS CLI
- 🔄 Data Ingestion
- 🔐 AWS IAM / Security
- ❄️ Snowflake
- 🔧 dbt
- 📊 Power BI
- ⚙️ GitHub Actions
- 🚀 Data Engineering

---

# 🗺️ Architecture globale GEIP

```text
                    ☁️ AWS S3
                    DATA LAKE
                        │
                        ▼
                 ❄️ SNOWFLAKE
                    LANDING
                        │
                        ▼
                     🔧 dbt
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
      STAGING      INTERMEDIATE      GOLD
                                      │
                                      ▼
                                  📊 POWER BI

                        +
                        
                 ⚙️ GITHUB ACTIONS
                        │
              ┌─────────┼─────────┐
              ▼         ▼         ▼
           CI/CD     dbt build   Email
```

---

## 📚 Documentation

| Document | Description |
|---|---|
| [`01_create_bucket.md`](./01_create_bucket.md) | Création et configuration du bucket |
| [`02_prepare_data.md`](./02_prepare_data.md) | Préparation des fichiers sources |
| [`03_upload_to_s3.md`](./03_upload_to_s3.md) | Chargement des fichiers |
| [`04_validate_upload.md`](./04_validate_upload.md) | Contrôles après ingestion |

---

<p align="center">

### ☁️ GEIP — AWS S3 Data Lake

**AWS S3 → Snowflake → dbt → Power BI**

</p>
