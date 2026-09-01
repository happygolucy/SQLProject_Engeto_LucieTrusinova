--vytvoření podhledu:

CREATE VIEW data_q1 AS
SELECT
	year,
	industry_branch,
	wages
FROM
	t_lucie_trusinova_project_sql_primary_final
WHERE
	wages IS NOT NULL
ORDER BY
	industry_branch,
	year ;


--Select pro meziroční procentuální růst/pokles mezd:

SELECT
    year,
    industry_branch,
    ROUND((wages - LAG(wages) OVER (PARTITION BY industry_branch ORDER BY year)) * 100.0 / LAG(wages) OVER (PARTITION BY industry_branch ORDER BY year),2) AS yoy_growth_percent
FROM data_q1
ORDER BY
    industry_branch,
    year;
 

--Select pro celkový růst napříč jednotlivými odvětvími: 

SELECT
	industry_branch,
	ROUND((MAX(wages) - MIN(wages)) * 100.0 / MIN(wages), 2) AS total_growth_percent
FROM
	data_q1
GROUP BY
	industry_branch
ORDER BY
	total_growth_percent DESC;

