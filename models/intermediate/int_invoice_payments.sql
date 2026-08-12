/*
==============================================================================
MODEL : int_invoice_payments

DESCRIPTION :
Association des factures et des paiements.

BUSINESS PURPOSE :
Permet d'analyser les paiements, les impayés et les délais de règlement.

LAYER :
SILVER

AUTHOR :
Ouattara Seydou
==============================================================================
*/

WITH invoices AS (

    SELECT

        INVOICE_SK,
        INVOICE_ID,
        CONTRACT_ID,
        METER_ID,
        INVOICE_DATE,
        BILLING_PERIOD_START,
        BILLING_PERIOD_END,
        DUE_DATE,
        PAYMENT_DATE,
        TOTAL_KWH,
        ENERGY_AMOUNT,
        FIXED_CHARGE,
        TAX_AMOUNT,
        TOTAL_AMOUNT,
        INVOICE_STATUS,
        IS_PAID,
        PAYMENT_TERMS_DAYS,
        PAYMENT_DELAY_DAYS,
        CREATED_AT

    FROM {{ ref('stg_landing_invoices') }}

),

payments AS (

    SELECT

        PAYMENT_SK,
        PAYMENT_ID,
        INVOICE_ID,
        PAYMENT_DATE,
        AMOUNT_PAID,
        PAYMENT_METHOD,
        PAYMENT_STATUS,
        TRANSACTION_REFERENCE,
        BANK_NAME,
        CURRENCY,
        IS_SUCCESSFUL_PAYMENT,
        IS_PENDING_PAYMENT,
        IS_FAILED_PAYMENT,
        CREATED_AT

    FROM {{ ref('stg_landing_payments') }}

)

SELECT

    i.INVOICE_SK,
    i.INVOICE_ID,
    i.CONTRACT_ID,
    i.METER_ID,

    i.INVOICE_DATE,
    i.BILLING_PERIOD_START,
    i.BILLING_PERIOD_END,
    i.DUE_DATE,

    i.TOTAL_KWH,
    i.ENERGY_AMOUNT,
    i.FIXED_CHARGE,
    i.TAX_AMOUNT,
    i.TOTAL_AMOUNT,

    i.INVOICE_STATUS,
    i.IS_PAID,
    i.PAYMENT_TERMS_DAYS,
    i.PAYMENT_DELAY_DAYS,

    p.PAYMENT_SK,
    p.PAYMENT_ID,
    i.payment_date ,
    p.AMOUNT_PAID,
    p.PAYMENT_METHOD,
    p.PAYMENT_STATUS,
    p.TRANSACTION_REFERENCE,
    p.BANK_NAME,
    p.CURRENCY,
    p.IS_SUCCESSFUL_PAYMENT,
    p.IS_PENDING_PAYMENT,
    p.IS_FAILED_PAYMENT,

    i.CREATED_AT AS INVOICE_CREATED_AT,
    p.CREATED_AT AS PAYMENT_CREATED_AT

FROM invoices i

LEFT JOIN payments p
       ON i.INVOICE_ID = p.INVOICE_ID