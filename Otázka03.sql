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

SELECT
	a.food_type,
	ROUND(AVG((a.price_level - b.price_level) * 100.0 / b.price_level), 2) AS avg_yoy_growth
FROM
	t_lucie_trusinova_project_sql_primary_final a
JOIN t_lucie_trusinova_project_sql_primary_final b
    ON a.food_type = b.food_type
	AND a.year = b.year + 1
GROUP BY
	a.food_type
ORDER BY
	avg_yoy_growth
LIMIT 3;
