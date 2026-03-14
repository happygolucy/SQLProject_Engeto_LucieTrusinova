--Tabulka 1:  porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.


select
	*
from
	t_lucie_trusinova_project_sql_primary_final;

begin;
rollback;
commit;


create table t_lucie_trusinova_project_sql_primary_final
(id BIGINT generated always as identity primary key,
    year INT not null,    
food_type TEXT,
    price_level numeric(12, 2) ,
  price_value_per_unit TEXT,
    industry_branch TEXT,
    wages numeric(12, 2),
    source_type TEXT not null);

with combined as 
(
select
	cpay.payroll_year as year,
	cpc.name as food_type,
	null::text as industry_branch,
	AVG(cp.value) as price_level,
	cpc.price_value || ' ' || cpc.price_unit as price_value_per_unit,
	null::numeric as wages,
	'food_type' as source_type
from
	czechia_payroll cpay
join czechia_price cp
        on
	cpay.payroll_year = DATE_PART('year', cp.date_from)
	and cpay.value_type_code = '5958'
	and cp.region_code is null
join czechia_price_category cpc
        on
	cp.category_code = cpc.code
group by
	cpay.payroll_year,
	cpc.name,
	cpc.price_value,
	cpc.price_unit
union all
select
	cpay.payroll_year as year,
	null::text as food_type,
	cpib.name as industry_branch,
	null::numeric as price_level,
	null as price_value_per_unit,
	AVG(cpay.value) as wages,
	'industry_branch' as source_type
from
	czechia_payroll cpay
join czechia_payroll_industry_branch cpib
        on
	cpay.industry_branch_code = cpib.code
where
	cpay.value_type_code = '5958'
group by
	cpay.payroll_year,
	cpib.name)
insert
	into
	t_lucie_trusinova_project_sql_primary_final
(year,
	food_type,
	price_level,
	price_value_per_unit,
	industry_branch,
	wages,
	source_type)
select
	--   ROW_NUMBER() OVER (ORDER BY year, source, food_type, industry_branch) AS id,
    year,
	food_type,
	price_level,
	price_value_per_unit,
	industry_branch ,
	wages ,
	source_type
from
	combined
where
	year in (
	select
		year
	from
		combined
	group by
		year
	having
		COUNT(distinct source_type) = 2)
order by
	source_type,
	year,
	food_type,
	industry_branch;



---Tabulka 2: tabulka s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.


select
	*
from
	t_lucie_trusinova_project_sql_secondary_final;

begin;
rollback;
commit;

create table t_lucie_trusinova_project_sql_secondary_final
(id BIGINT generated always as identity primary key,
    country text not null,    
    year INT not null,    
    gdp numeric(15, 2),
  gini numeric (12,
2),
  population numeric (12,
2));

insert
	into
	t_lucie_trusinova_project_sql_secondary_final
(country,
	year,
	gdp,
	gini,
	population);

select
	c.country,
	e.year,
	e. gdp,
	e.gini,
	e.population
from
	countries c
join economies e on
	c.country = e.country
where
	c.continent = 'Europe'
	and e.year between 2006 and 2018
order by
	country,
	year
;

select
	*
from
	t_lucie_trusinova_project_sql_primary_final;

select
	*
from
	t_lucie_trusinova_project_sql_secondary_final;





--Otazka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají ?
--view1, se kterym budeme pracovat v ramci otazky 1
create view data_q1 as
select
	year,
	industry_branch,
	wages
from
	t_lucie_trusinova_project_sql_primary_final
where
	wages is not null
order by
	industry_branch,
	year ;

--mezirocni zmena
select
	a.year,
	a.industry_branch,
	a.wages as wages_current_year,
	b.wages as wages_previous_year,
	a.wages - b.wages as yoy_change
from
	data_q1 a
join data_q1 b
    on
	a.industry_branch = b.industry_branch
	and a.year = b.year + 1
order by
	a.industry_branch,
	a.year;

--Mezirocni procentualni rust/pokles mzdy (pridanim 'where' filtruju pouze pokles), muzeme take pouzit order by yoy_growth_percent desc, pro sledovani nejvetsiho rustu.
select
	a.year,
	a.industry_branch,
	round((a.wages - b.wages) * 100.0 / b.wages, 2) as yoy_growth_percent
from
	data_q1 a
join data_q1 b
    on
	a.industry_branch = b.industry_branch
	and a.year = b.year + 1
	--where a.wages < b.wages
	--order by a.industry_branch, a.year;
	--order by yoy_growth_percent desc;
	;
	

	--Celkovy rust napric odvetvimi 
select
	industry_branch,
	ROUND(
        (MAX(wages) - MIN(wages)) * 100.0 / MIN(wages),
        2
    ) as total_growth_percent
from
	data_q1
group by
	industry_branch
order by
	total_growth_percent desc;
	
	
	
--Otazka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
--Presne ceny, prumerne mzdy a kolik je clovek celkem schopen nakoupit:
select
	ogdata.year,
	ogdata.food_type,
	ogdata.price_level,
	wagecalc.avg_wage,
	ROUND( wagecalc.avg_wage / ogdata.price_level, 0) as quantity_can_buy
from
	(
	select
		year,
		food_type,
		price_level
	from
		t_lucie_trusinova_project_sql_primary_final
	where
		food_type in ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
			and year in (2006, 2018)
) ogdata
join (
	select
		year,
		round(AVG(wages), 2) as avg_wage
	from
		t_lucie_trusinova_project_sql_primary_final
	where
		wages is not null
	group by
		year
) wagecalc
on
	ogdata.year = wagecalc.year;


--Otazka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 


--Ceny v porovnani s predchozim rokem napric kategoriemi
---pridavam moznost prohodit order by funkci, kdy mohu sledovat, budto vyvoj ceny pro kategorii potravin napric roky NEBO pri vyuziti 'order by yoy_percent_change asc' uvidim nejvetsi snizeni ceny z roku na rok

select
	a.food_type,
	a.year,
	a.price_level as price_current_year,
	b.price_level as price_previous_year,
	a.price_level - b.price_level as yoy_price_change,
	ROUND((a.price_level - b.price_level) * 100.0 / b.price_level, 2) as yoy_percent_change
from
	t_lucie_trusinova_project_sql_primary_final a
join t_lucie_trusinova_project_sql_primary_final b
    on
	a.food_type = b.food_type
	and a.year = b.year + 1
where
	a.price_level is not null
order by
	yoy_percent_change asc
--	a.food_type, a.year
;



--query vybere nejnizsi procentualni narust (v nasem pripade i snizeni) ceny; limit muzeme upravit dle potreby, abychom videli pouze nejaky pocet nejnizsich hodnot procentualnich zmen ceny
select
	a.food_type,
	ROUND(AVG((a.price_level - b.price_level) * 100.0 / b.price_level), 2) as avg_yoy_growth
from
	t_lucie_trusinova_project_sql_primary_final a
join t_lucie_trusinova_project_sql_primary_final b
    on
	a.food_type = b.food_type
	and a.year = b.year + 1
group by
	a.food_type
order by
	avg_yoy_growth
limit 3;



--Otazka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
--vytvorim view pro naslednou praci s daty o prumerne cene a mzde
create view question4answerdata_Lucie_Trusinova as     
           select
	a.year,
	round(AVG(a.price_level), 2) as avg_price,
	round(AVG(b.wages), 2) as avg_wages
from
	t_lucie_trusinova_project_sql_primary_final a
join t_lucie_trusinova_project_sql_primary_final b
    on
	a.year = b.year
group by
	a.year
order by
	year;


--view pro year over year ukazka vyvoje cen i mezd, vcetne procentualniho vyvoje
create view Question4DataFinalLucieTrusinova as
select
	a.year,
	a.avg_price as current_year_price,
	b.avg_price as previous_year_price,
	a.avg_price - b.avg_price as yoy_price_change,
	ROUND((a.avg_price - b.avg_price) * 100.0 / b.avg_price, 2) as yoy_percent_change_price,
	a.avg_wages as current_year_wages,
	b.avg_wages as previous_year_wages,
	a.avg_wages - b.avg_wages as yoy_wages_change,
	ROUND((a.avg_wages - b.avg_wages) * 100.0 / b.avg_wages, 2) as yoy_percent_change_wages,
	( ROUND((a.avg_price - b.avg_price) * 100.0 / b.avg_price, 2)) - (ROUND((a.avg_wages - b.avg_wages) * 100.0 / b.avg_wages, 2)) as percent_growth_difference
from
	question4answerdata_Lucie_Trusinova a
join question4answerdata_Lucie_Trusinova b
on
	a.year = b.year + 1;


--finalni srovnani zde:

select
	year,
	yoy_percent_change_price,
	yoy_percent_change_wages,
	percent_growth_difference
from
	Question4DataFinalLucieTrusinova;




--Otazka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
create view Question5dataLucieTrusinovaFinal as  
 select
	a.country,
	a.year,
	a.gdp as gdp_current_year,
	b.gdp as gdp_previous_year,
	a.gdp - b.gdp as yoy_gdp_change,
	ROUND((a.gdp - b.gdp) * 100.0 / b.gdp , 2) as yoy_percent_gdp_change
from
	(
	select
		*
	from
		t_lucie_trusinova_project_sql_secondary_final
	where
		country = 'Czech Republic') a
join (
	select
		*
	from
		t_lucie_trusinova_project_sql_secondary_final
	where
		country = 'Czech Republic') b
       on
	a.year = b.year + 1;

select
	a.country,
	a.year,
	a.yoy_percent_gdp_change,
	b.yoy_percent_change_price,
	b.yoy_percent_change_wages
from
	Question5dataLucieTrusinovaFinal a
join Question4DataFinalLucieTrusinova b
 on
	a.year = b.year;
