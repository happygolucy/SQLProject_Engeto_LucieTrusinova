--podhled pro ukol 5 (Meziroční změna HDP)

CREATE VIEW Question5dataLucieTrusinovaFinal00 AS
SELECT
	country,
	year,
	gdp AS gdp_current_year,
	LAG(gdp) OVER (PARTITION BY country ORDER BY year) AS gdp_previous_year,
	gdp - LAG(gdp) OVER (PARTITION BY country ORDER BY year) AS yoy_gdp_change,
	ROUND(((gdp - LAG(gdp) OVER (PARTITION BY country ORDER BY year)) * 100.0 / LAG(gdp) OVER (PARTITION BY country ORDER BY year)), 2) AS yoy_percent_gdp_change
FROM
	t_lucie_trusinova_project_sql_secondary_final
WHERE
	country = 'Czech Republic'
ORDER BY
	year;


--select pro odpověď na otázku 5 (Porovnání HDP s cenami potravin a mzdami)
SELECT
	a.country,
	a.year,
	a.yoy_percent_gdp_change,
	b.yoy_percent_change_price,
	b.yoy_percent_change_wages
FROM
	Question5dataLucieTrusinovaFinal00 a
JOIN Question4DataFinalLucieTrusinova2 b
    ON a.year = b.year
ORDER BY a.year;

