{{ config(
    materialized='table'
) }}

-- ============================================================================
-- MODEL       : dim_date
-- LAYER       : GOLD
--
-- OBJECTIF
-- --------
-- Construire la dimension calendrier utilisée par l'ensemble du Data Warehouse.
--
-- GRANULARITE
-- -----------
-- 1 ligne = 1 date.
--
-- PERIODE
-- -------
-- 2015-01-01 à 2035-12-31.
-- ============================================================================

WITH dates AS (

    SELECT

        DATEADD(
            DAY,
            ROW_NUMBER() OVER (ORDER BY seq4()) - 1,
            TO_DATE('2015-01-01')
        ) AS FULL_DATE

    FROM TABLE(GENERATOR(ROWCOUNT => 8000))

),

calendar AS (

    SELECT

        ----------------------------------------------------------------------
        -- Clé
        ----------------------------------------------------------------------

        TO_NUMBER(TO_CHAR(FULL_DATE,'YYYYMMDD')) AS DATE_SK,

        FULL_DATE,

        ----------------------------------------------------------------------
        -- Jour
        ----------------------------------------------------------------------

        DAY(FULL_DATE) AS DAY,

        DAYNAME(FULL_DATE) AS DAY_NAME,

        DAYOFWEEK(FULL_DATE) AS DAY_OF_WEEK,

        DAYOFYEAR(FULL_DATE) AS DAY_OF_YEAR,

        WEEK(FULL_DATE) AS WEEK_OF_YEAR,

        ----------------------------------------------------------------------
        -- Mois
        ----------------------------------------------------------------------

        MONTH(FULL_DATE) AS MONTH,

        MONTHNAME(FULL_DATE) AS MONTH_NAME,

        LEFT(MONTHNAME(FULL_DATE),3) AS MONTH_SHORT,

        ----------------------------------------------------------------------
        -- Trimestre
        ----------------------------------------------------------------------

        QUARTER(FULL_DATE) AS QUARTER,

        CASE

            WHEN QUARTER(FULL_DATE) IN (1,2)

            THEN 1

            ELSE 2

        END AS SEMESTER,

        ----------------------------------------------------------------------
        -- Année
        ----------------------------------------------------------------------

        YEAR(FULL_DATE) AS YEAR,

        ----------------------------------------------------------------------
        -- Drapeaux calendrier
        ----------------------------------------------------------------------

        CASE
            WHEN DAYOFWEEK(FULL_DATE) IN (0,6)
            THEN TRUE
            ELSE FALSE
        END AS IS_WEEKEND,

        CASE
            WHEN FULL_DATE = DATE_TRUNC('MONTH',FULL_DATE)
            THEN TRUE
            ELSE FALSE
        END AS IS_MONTH_START,

        CASE
            WHEN FULL_DATE = LAST_DAY(FULL_DATE)
            THEN TRUE
            ELSE FALSE
        END AS IS_MONTH_END,

        CASE
            WHEN MONTH(FULL_DATE) IN (1,4,7,10)
             AND DAY(FULL_DATE)=1
            THEN TRUE
            ELSE FALSE
        END AS IS_QUARTER_START,

        CASE
            WHEN FULL_DATE IN (

                LAST_DAY(DATE_FROM_PARTS(YEAR(FULL_DATE),3,1)),
                LAST_DAY(DATE_FROM_PARTS(YEAR(FULL_DATE),6,1)),
                LAST_DAY(DATE_FROM_PARTS(YEAR(FULL_DATE),9,1)),
                LAST_DAY(DATE_FROM_PARTS(YEAR(FULL_DATE),12,1))

            )

            THEN TRUE

            ELSE FALSE

        END AS IS_QUARTER_END,

        CASE
            WHEN MONTH(FULL_DATE)=1
             AND DAY(FULL_DATE)=1
            THEN TRUE
            ELSE FALSE
        END AS IS_YEAR_START,

        CASE
            WHEN MONTH(FULL_DATE)=12
             AND DAY(FULL_DATE)=31
            THEN TRUE
            ELSE FALSE
        END AS IS_YEAR_END,

        ----------------------------------------------------------------------
        -- Saison
        ----------------------------------------------------------------------

        CASE

            WHEN MONTH(FULL_DATE) IN (12,1,2)
                THEN 'Winter'

            WHEN MONTH(FULL_DATE) IN (3,4,5)
                THEN 'Spring'

            WHEN MONTH(FULL_DATE) IN (6,7,8)
                THEN 'Summer'

            ELSE 'Autumn'

        END AS SEASON

    FROM dates

)

SELECT *

FROM calendar

WHERE FULL_DATE <= '2035-12-31'