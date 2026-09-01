
--select pro 2. otazku:

WITH avg_wages AS (
    SELECT
        YEAR,
        ROUND(AVG(wages), 2) AS avg_wage
    FROM t_lucie_trusinova_project_sql_primary_final
    WHERE wages IS NOT NULL
    GROUP BY YEAR
)
SELECT
    p.YEAR,
    p.food_type,
    p.price_level,
    w.avg_wage,
    ROUND(w.avg_wage / p.price_level, 0) AS quantity_can_buy
FROM t_lucie_trusinova_project_sql_primary_final p
JOIN avg_wages w
    ON p.YEAR = w.YEAR
WHERE p.food_type IN (
        'Mléko polotučné pasterované',
        'Chléb konzumní kmínový'
    )
    AND p.YEAR IN (2006, 2018)
ORDER BY
    p.food_type,
    p.YEAR;

