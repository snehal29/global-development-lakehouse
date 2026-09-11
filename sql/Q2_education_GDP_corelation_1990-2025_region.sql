 SELECT 
        COALESCE(Region, 'ALL REGIONS (Overall)') AS Region,
        ROUND(corr(education_expenditure_pct_gdp, gdp_growth_pct), 3) AS correlation,
        COUNT(*) AS num_records
    FROM workspace.global_development.gold_country_development_metrics 
    WHERE education_expenditure_pct_gdp IS NOT NULL 
      AND gdp_growth_pct IS NOT NULL
      AND year BETWEEN 1990 AND 2025
      AND Region IS NOT NULL
    GROUP BY GROUPING SETS ( (Region), () )
    ORDER BY correlation DESC
