--Q1: Does government education investment correlate with GDP growth in the same year?
SELECT ROUND(corr(education_expenditure_pct_gdp, gdp_growth_pct), 3) AS correlation
    FROM workspace.global_development.gold_country_development_metrics
    WHERE education_expenditure_pct_gdp IS NOT NULL 
      AND gdp_growth_pct IS NOT NULL
