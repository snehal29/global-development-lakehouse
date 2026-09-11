SELECT 
        decade,
        ROUND(AVG(gdp_growth_pct), 2) AS avg_gdp_growth,
        ROUND(AVG(population_growth_rate), 2) AS avg_population_growth,
        ROUND(AVG(education_expenditure_pct_gdp), 2) AS avg_education_spend,
        COUNT(DISTINCT Country_Code) AS countries_reporting
    FROM workspace.global_development.gold_country_development_metrics
    WHERE decade IS NOT NULL
    GROUP BY decade
    ORDER BY decade
