USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;

-- Dimensions
!source customers.sql
!source contracts.sql
!source meters.sql

-- Tables de faits
!source energy_consumption.sql
!source invoices.sql
!source payments.sql
!source customer_service.sql
!source maintenance.sql
!source outages.sql