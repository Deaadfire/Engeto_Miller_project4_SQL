-- Otázky č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- Otázka č. 1, skript č. 1
WITH salary_trend AS (
	SELECT
		industry_name,
		payroll_year,
		round(avg_salary, 0) AS avg_salary,
		round(
			avg_salary - lag(avg_salary) OVER (PARTITION BY industry_name ORDER BY payroll_year),
			0
		) AS diff_from_prev_year
	FROM t_Jakub_Miller_project_SQL_primary_final
	WHERE industry_name IS NOT null
	GROUP BY industry_name, payroll_year, avg_salary
)
SELECT
    industry_name,
    SUM(CASE WHEN diff_from_prev_year > 0 THEN 1 ELSE 0 END) AS years_up,
    SUM(CASE WHEN diff_from_prev_year < 0 THEN 1 ELSE 0 END) AS years_down,
    SUM(CASE WHEN diff_from_prev_year = 0 THEN 1 ELSE 0 END) AS years_flat,   
    COUNT(diff_from_prev_year) AS compared_years                              
FROM salary_trend
GROUP BY industry_name
ORDER BY years_down desc;


-- Otázka č. 1, skript č. 2
WITH salary_trend AS (
	SELECT
		industry_name,
		payroll_year,
		round(avg_salary, 0) AS avg_salary,
		round(
			avg_salary - lag(avg_salary) OVER (PARTITION BY industry_name ORDER BY payroll_year),
			0
		) AS diff_from_prev_year
	FROM t_Jakub_Miller_project_SQL_primary_final
	WHERE industry_name IS NOT null
	GROUP BY industry_name, payroll_year, avg_salary
)
SELECT DISTINCT *
FROM salary_trend
WHERE diff_from_prev_year < 0
ORDER BY payroll_year;




-- Otázka č. 2, skript č. 1
SELECT
    payroll_year,
    product_name,
    ROUND(AVG(avg_salary)::numeric, 0) AS avg_salary_all_industries,
    ROUND(AVG(avg_price)::numeric, 2) AS avg_price_year_product,
    ROUND((AVG(avg_salary) / NULLIF(AVG(avg_price), 0))::numeric, 2) AS number_of_product_per_salary
FROM t_Jakub_Miller_project_SQL_primary_final
WHERE product_name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
  AND industry_name IS NOT NULL
  AND payroll_year IN (2006, 2018)
GROUP BY payroll_year, product_name
ORDER BY payroll_year DESC, product_name;





-- Otázka č. 3, skript č. 1
WITH price_yearly_change AS ( 
SELECT
    product_name,
    payroll_year,
    100.0 * (
      AVG(avg_price)
      - LAG(AVG(avg_price)) OVER (PARTITION BY product_name ORDER BY payroll_year)
    ) / NULLIF(LAG(AVG(avg_price)) OVER (PARTITION BY product_name ORDER BY payroll_year), 0) AS yearly_change
  FROM t_Jakub_Miller_project_SQL_primary_final
  WHERE product_name IS NOT null
  GROUP BY product_name, payroll_year
)
SELECT
  product_name,
  ROUND(AVG(yearly_change)::numeric, 2) AS avg_yearly_change_percent,
  COUNT(*) AS years_counted
FROM price_yearly_change
WHERE yearly_change IS NOT NULL
GROUP BY product_name
ORDER BY avg_yearly_change_percent ASC


-- Otázka č. 3, skript č. 2
SELECT
    payroll_year,
    product_name,
    ROUND(AVG(avg_price)::numeric, 2) AS avg_price_year
FROM t_Jakub_Miller_project_SQL_primary_final
WHERE product_name IS NOT null
GROUP BY payroll_year, product_name
ORDER BY product_name, payroll_year;




-- Otázka č. 4, skript č. 1
WITH avg_yearly_values AS (
	  SELECT
	  	payroll_year,
	  	round(avg(avg_salary), 0) AS avg_wages,
	  	round(avg(avg_price)::numeric, 2) AS avg_product_price
	  FROM t_Jakub_Miller_project_SQL_primary_final
	  WHERE industry_name IS NOT NULL AND product_name IS NOT NULL
	  GROUP BY payroll_year 
), 
avg_yearly_differences AS (
	Select
    payroll_year,
    avg_wages,
    avg_product_price,
    ROUND(
        100.0 * (
            avg_wages
            - LAG(avg_wages) OVER (ORDER BY payroll_year)
        ) / NULLIF(LAG(avg_wages) OVER (ORDER BY payroll_year), 0)
    , 2) AS avg_yearly_wage_change_percent,
    ROUND(
        100.0 * (
            avg_product_price
            - LAG(avg_product_price) OVER (ORDER BY payroll_year)
        ) / NULLIF(LAG(avg_product_price) OVER (ORDER BY payroll_year), 0)
    , 2) AS avg_yearly_pprice_change_percent,
    ROUND(
        (
            100.0 * (
                avg_product_price
                - LAG(avg_product_price) OVER (ORDER BY payroll_year)
            ) / NULLIF(LAG(avg_product_price) OVER (ORDER BY payroll_year), 0)
            -
            100.0 * (
                avg_wages
                - LAG(avg_wages) OVER (ORDER BY payroll_year)
            ) / NULLIF(LAG(avg_wages) OVER (ORDER BY payroll_year), 0)
        )
    , 2) AS pprice_vs_wages_difference
FROM avg_yearly_values
)
SELECT * FROM avg_yearly_differences
WHERE pprice_vs_wages_difference IS NOT NULL
ORDER BY pprice_vs_wages_difference DESC;




-- Otázka č. 5, skript č. 1
WITH avg_yearly_values AS (
	  SELECT
	  	payroll_year,
	  	round(avg(avg_salary)::numeric, 0) AS avg_wages,
	  	round(avg(avg_price)::numeric, 2) AS avg_product_price
	  FROM t_Jakub_Miller_project_SQL_primary_final
	  WHERE industry_name IS NOT NULL AND product_name IS NOT NULL
	  GROUP BY payroll_year 
),
yearly_gdp AS (
	SELECT
		YEAR,
		gdp,
		round(100 * (gdp - lag(gdp) OVER (ORDER BY year)) / lag(gdp) OVER (ORDER BY year), 2)  AS gdp_change_percent
	FROM t_Jakub_Miller_project_SQL_secondary_final
	WHERE country = 'Czech Republic' 
),	
avg_yearly_differences AS (
	Select
    payroll_year,
    ROUND(
        100.0 * (
            avg_wages
            - LAG(avg_wages) OVER (ORDER BY payroll_year)
        ) / NULLIF(LAG(avg_wages) OVER (ORDER BY payroll_year), 0)
    , 2) AS avg_yearly_wage_change_percent,
    ROUND(
        100.0 * (
            avg_product_price
            - LAG(avg_product_price) OVER (ORDER BY payroll_year)
        ) / NULLIF(LAG(avg_product_price) OVER (ORDER BY payroll_year), 0)
    , 2) AS avg_yearly_pprice_change_percent
FROM avg_yearly_values
),
same_year_data AS (
	SELECT 
		ayd.*,
		yg.gdp_change_percent
	FROM avg_yearly_differences AS ayd
	JOIN yearly_gdp AS yg ON yg.YEAR = ayd.payroll_year
	ORDER BY ayd.payroll_year
),
delayed_data AS (
	SELECT
	    payroll_year,
	    gdp_change_percent,
	    avg_yearly_wage_change_percent,
	    avg_yearly_pprice_change_percent,
	    LEAD(avg_yearly_wage_change_percent, 1) OVER (ORDER BY payroll_year)  AS wage_next_year,
	    LEAD(avg_yearly_pprice_change_percent, 1) OVER (ORDER BY payroll_year) AS price_next_year
	FROM same_year_data
)
SELECT
  round(CORR(gdp_change_percent, avg_yearly_wage_change_percent)::NUMERIC, 5)  AS correlation_gdp_wages,
  round(CORR(gdp_change_percent, avg_yearly_pprice_change_percent)::NUMERIC, 5) AS correlation_gdp_prices,
  round(CORR(gdp_change_percent, wage_next_year)::NUMERIC, 5)  AS corr_gdp_to_next_wages,
  round(CORR(gdp_change_percent, price_next_year)::NUMERIC, 5) AS corr_gdp_to_next_prices
FROM delayed_data;


-- Otázka č. 5, skript č. 2
WITH avg_yearly_values AS (
	  SELECT
	  	payroll_year,
	  	round(avg(avg_salary)::numeric, 0) AS avg_wages,
	  	round(avg(avg_price)::numeric, 2) AS avg_product_price
	  FROM t_Jakub_Miller_project_SQL_primary_final
	  WHERE industry_name IS NOT NULL AND product_name IS NOT NULL
	  GROUP BY payroll_year 
),
yearly_gdp AS (
	SELECT
		YEAR,
		gdp,
		round(100 * (gdp - lag(gdp) OVER (ORDER BY year)) / lag(gdp) OVER (ORDER BY year), 2)  AS gdp_change_percent
	FROM t_Jakub_Miller_project_SQL_secondary_final
	WHERE country = 'Czech Republic' 
),	
avg_yearly_differences AS (
	Select
    payroll_year,
    ROUND(
        100.0 * (
            avg_wages
            - LAG(avg_wages) OVER (ORDER BY payroll_year)
        ) / NULLIF(LAG(avg_wages) OVER (ORDER BY payroll_year), 0)
    , 2) AS avg_yearly_wage_change_percent,
    ROUND(
        100.0 * (
            avg_product_price
            - LAG(avg_product_price) OVER (ORDER BY payroll_year)
        ) / NULLIF(LAG(avg_product_price) OVER (ORDER BY payroll_year), 0)
    , 2) AS avg_yearly_pprice_change_percent
FROM avg_yearly_values
),
final_data AS (
	SELECT 
		ayd.*,
		yg.gdp_change_percent
	FROM avg_yearly_differences AS ayd
	JOIN yearly_gdp AS yg ON yg.YEAR = ayd.payroll_year
)
SELECT *
FROM final_data
ORDER BY payroll_year asc;