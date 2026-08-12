-- TEST VOLONTAIREMENT EN ECHEC
-- Ce test retourne une ligne, donc dbt considère le test comme FAILED.

select
    1 as intentional_failure