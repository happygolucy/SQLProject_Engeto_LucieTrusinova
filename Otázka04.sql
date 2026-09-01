
--podhled 1 pro ukol 4 (Průměrná cena a mzda za jednotlivé roky)

CREATE VIEW question4answerdata_Lucie_Trusinova1 AS
SELECT
    YEAR,
    ROUND(AVG(price_level), 2) AS avg_price,
    ROUND(AVG(wages), 2) AS avg_wages
FROM t_lucie_trusinova_project_sql_primary_final
GROUP BY YEAR
ORDER BY YEAR;

--podhled 2 pro ukol 4 (Meziroční vývoj):

CREATE VIEW Question4DataFinalLucieTrusinova2 AS
SELECT
	YEAR,
	avg_price AS current_year_price,
	LAG(avg_price) OVER (ORDER BY YEAR) AS previous_year_price,
	avg_price - LAG(avg_price) OVER (ORDER BY YEAR) AS yoy_price_change,
	ROUND(((avg_price - LAG(avg_price) OVER (ORDER BY YEAR)) * 100.0 / LAG(avg_price) OVER (ORDER BY YEAR)), 2) AS yoy_percent_change_price,
	avg_wages AS current_year_wages,
	LAG(avg_wages) OVER (ORDER BY YEAR) AS previous_year_wages, 
	avg_wages - LAG(avg_wages) OVER (ORDER BY YEAR) AS yoy_wages_change,
	ROUND(((avg_wages - LAG(avg_wages) OVER (ORDER BY YEAR)) * 100.0 / LAG(avg_wages) OVER (ORDER BY YEAR)), 2) AS yoy_percent_change_wages,
	ROUND((((avg_price - LAG(avg_price) OVER (ORDER BY YEAR)) * 100.0 / LAG(avg_price) OVER ( ORDER BY YEAR)) - ((avg_wages - LAG(avg_wages) OVER (ORDER BY YEAR)) * 100.0 / LAG(avg_wages) OVER (ORDER BY YEAR))), 2) AS percent_growth_difference
FROM
	question4answerdata_Lucie_Trusinova
ORDER BY
	YEAR;


--Select pro odpověď na otázku 4:
SELECT
    YEAR,
    yoy_percent_change_price,
    yoy_percent_change_wages,
    percent_growth_difference
FROM Question4DataFinalLucieTrusinova2;
