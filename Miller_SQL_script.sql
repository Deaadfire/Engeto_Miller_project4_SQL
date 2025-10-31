-- Skript na vytvoření tabulky č. 1 obsahující data ohledně mezd a cen pro vybrané časové období
CREATE TABLE t_Jakub_Miller_project_SQL_primary_final AS
WITH payroll_agg AS (
  SELECT
    p.industry_branch_code,
    p.payroll_year,
    AVG(p.value) AS avg_salary
  FROM czechia_payroll p
  WHERE p.value_type_code = 5958      
  GROUP BY p.industry_branch_code, p.payroll_year
),
price_agg AS (
  SELECT
    r.category_code,
    EXTRACT(YEAR FROM r.date_from)::int AS price_year,
    AVG(r.value) AS avg_price
  FROM czechia_price r
  GROUP BY r.category_code, EXTRACT(YEAR FROM r.date_from)
)
SELECT
  cpib.name AS industry_name,
  p.payroll_year,
  p.avg_salary,
  cpc.name AS product_name,
  r.avg_price
FROM payroll_agg p
LEFT JOIN price_agg r
       	ON r.price_year = p.payroll_year
LEFT JOIN czechia_payroll_industry_branch cpib
       	ON cpib.code = p.industry_branch_code
LEFT JOIN czechia_price_category cpc
       	ON cpc.code = r.category_code
       	
       	
-- Skript na vytvoření tabulky č. 2 obashující data ohledně dostupných Evropských zemí pro shodné časové období jako tabulka č. 1       	
CREATE TABLE t_Jakub_Miller_project_SQL_secondary_final as
SELECT 
	e.country,
	e.YEAR,
	e.gdp::numeric,
	e.gini::numeric,
	e.population::numeric
FROM economies e
JOIN countries c ON e.country = c.country
WHERE continent = 'Europe' AND YEAR BETWEEN 2000 AND 2021       	