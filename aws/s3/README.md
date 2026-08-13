# ☁️ AWS S3 — Data Lake

## 📌 Présentation

AWS S3 constitue la couche **Data Lake** du projet **GEIP — Energy Data Platform**.

Il est utilisé pour stocker les données sources avant leur intégration dans **Snowflake** et leur transformation avec **dbt**.

---

## 🏗️ Architecture

```text
                    ☁️ AWS S3
                   DATA LAKE
                       │
                       │ Raw Data
                       ▼
                ❄️ Snowflake
                   LANDING
                       │
                       ▼
                     dbt
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
      STAGING     INTERMEDIATE     GOLD
                                      │
                                      ▼
                                  📊 Power BI
