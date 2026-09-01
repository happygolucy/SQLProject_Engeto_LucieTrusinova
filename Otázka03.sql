--select pro ukázku všech meziročních změn cen 

SELECT
    food_type,
    year,
    price_level AS price_current_year,
    LAG(price_level) OVER (PARTITION BY food_type ORDER BY year) AS price_previous_year,
    price_level - LAG(price_level) OVER (PARTITION BY food_type ORDER BY year) AS yoy_price_change,
    ROUND((price_level - LAG(price_level) OVER (PARTITION BY food_type ORDER BY year)) * 100.0 / LAG(price_level) OVER (PARTITION BY food_type ORDER BY year),2) AS yoy_percent_change
FROM t_lucie_trusinova_project_sql_primary_final
WHERE price_level IS NOT NULL
ORDER BY yoy_percent_change ASC;


--select pro nejnižší procentuální cenový růst (zlevnění)

WITH food_prices AS (
    SELECT
        food_type,
        year,
        price_level,
        LAG(price_level) OVER (PARTITION BY food_type ORDER BY year) AS previous_price
    FROM t_lucie_trusinova_project_sql_primary_final
    WHERE price_level IS NOT NULL
),
food_price_growth AS (
    SELECT
        food_type,
        year,
        ROUND(((price_level - previous_price)* 100.0 / previous_price), 2) AS yoy_percent_change
    FROM food_prices
    WHERE previous_price IS NOT NULL
)
SELECT
    food_type,
    ROUND(AVG(yoy_percent_change), 2) AS avg_yoy_growth
FROM food_price_growth
GROUP BY food_type
ORDER BY avg_yoy_growth
LIMIT 3;
