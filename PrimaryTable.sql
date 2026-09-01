--tvorba primární tabulky:

CREATE TABLE t_lucie_trusinova_project_sql_primary_final
(id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   year INT NOT NULL,   
	food_type TEXT,
   price_level NUMERIC(12, 2),
   price_value_per_unit TEXT,
   industry_branch TEXT,
   wages NUMERIC(12, 2),
   source_type TEXT NOT NULL);


--insert do primary tabulky

WITH combined AS
(
SELECT
	cpay.payroll_year AS year,
	cpc.name AS food_type,
	NULL::text AS industry_branch,
	AVG(cp.value) AS price_level,
	cpc.price_value || ' ' || cpc.price_unit AS price_value_per_unit,
	NULL::NUMERIC AS wages,
	'food_type' AS source_type
FROM
	czechia_payroll cpay
JOIN czechia_price cp
       ON
	cpay.payroll_year = DATE_PART('year', cp.date_from)
	AND cpay.value_type_code = '5958'
	AND cp.region_code IS NULL
JOIN czechia_price_category cpc
       ON
	cp.category_code = cpc.code
GROUP BY
	cpay.payroll_year,
	cpc.name,
	cpc.price_value,
	cpc.price_unit
UNION ALL
SELECT
	cpay.payroll_year AS year,
	NULL::text AS food_type,
	cpib.name AS industry_branch,
	NULL::NUMERIC AS price_level,
	NULL AS price_value_per_unit,
	AVG(cpay.value) AS wages,
	'industry_branch' AS source_type
FROM
	czechia_payroll cpay
JOIN czechia_payroll_industry_branch cpib
       ON
	cpay.industry_branch_code = cpib.code
WHERE
	cpay.value_type_code = '5958'
GROUP BY
	cpay.payroll_year,
	cpib.name)
INSERT
	INTO
	t_lucie_trusinova_project_sql_primary_final
	(year,
	food_type,
	price_level,
	price_value_per_unit,
	industry_branch,
	wages,
	source_type)
SELECT
   year,
	food_type,
	price_level,
	price_value_per_unit,
	industry_branch,
	wages,
	source_type
FROM
	combined
WHERE
	year IN (
	SELECT
		year
	FROM
		combined
	GROUP BY year
	HAVING COUNT(DISTINCT source_type) = 2)
ORDER BY source_type, year, food_type, industry_branch;
