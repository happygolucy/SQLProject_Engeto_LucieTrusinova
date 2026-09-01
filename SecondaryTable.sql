--tvorba sekundarní tabulky


CREATE TABLE t_lucie_trusinova_project_sql_secondary_final
	(id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 	country text NOT NULL,    
    YEAR INT NOT NULL,    
    gdp NUMERIC(15, 2),
 	  gini NUMERIC (12, 2),
  	population NUMERIC (12, 2));

--insert do sekundární tabulky

INSERT
	INTO
	t_lucie_trusinova_project_sql_secondary_final
	(country, YEAR,	gdp, gini, population)

SELECT
	c.country,
	e.year,
	e. gdp,
	e.gini,
	e.population
FROM
	countries c
JOIN economies e ON
	c.country = e.country
WHERE
	c.continent = 'Europe'
	AND e.year BETWEEN 2006 AND 2018
ORDER BY country, YEAR;
