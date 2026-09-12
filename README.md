# Global Development Lakehouse

An end-to-end data lakehouse pipeline built on Databricks, analyzing the 
relationship between education investment, population trends, and GDP 
growth across 217 countries (1960–2025), using World Bank Open Data.

## Problem Statement

World Bank publishes GDP, population, and education indicators as separate, messy, wide-format CSV files that aren't directly comparable or 
joinable. This project transforms them into a unified, analysis-ready dataset to answer: 
**does government investment in education correlate with GDP growth, and how does population growth interact with that relationship?**

## Architecture

Raw CSV → **Bronze** (raw ingestion) → **Silver** (cleaned, unpivoted, validated) → **Gold** (joined, business-ready) → **Dashboard**

Built using the **medallion architecture** pattern on Databricks Unity 
Catalog, orchestrated via Databricks Workflows.

[Flowchart see here](https://github.com/snehal29/global-development-lakehouse/blob/main/doc/architecture_flowchart.png)


## Tech Stack

- **Platform:** Databricks Free Edition (Unity Catalog, Serverless Compute)
- **Languages:** PySpark (DataFrame API), SQL, Python
- **Storage format:** Delta Lake
- **Orchestration:** Databricks Workflows (Jobs, task dependencies, 
  notifications)
- **Visualization:** Databricks AI/BI Dashboards
- **Data source:** World Bank Open Data (GDP growth, population, education expenditure indicators) 

## Project Structure
notebooks/
     01_bronze_ingestion.ipynb #Raw CSV ingestion, explicit schema handling\ 
     02_silver_transformation.ipynb #Unpivoting, cleaning, null-handling, outlier flagging
     03_gold_aggregation.ipynb #Joins, derived metrics, window functions
     04_dashboard_queries.ipynb #Analytical SQL queries powering the dashboard


## Key Engineering Decisions

- **Explicit schema over `inferSchema`** — avoided type-drift bugs on 
  repeated pipeline runs by defining schemas upfront rather than relying 
  on Spark's inference, which behaved inconsistently depending on null 
  patterns in year columns.
- **Dual Silver datasets** — maintained both an analysis-ready (nulls 
  dropped) and a completeness-preserving (nulls retained) version of each 
  dataset, since blindly imputing missing values with 0 would have 
  fabricated false data points and distorted correlation analysis.
- **Reference-data-driven filtering** — used World Bank's own country 
  metadata (Region field) to distinguish real countries from aggregate 
  regions (e.g., "World", "Arab World"), instead of a hardcoded, brittle 
  list of codes.
- **Non-destructive outlier flagging** — flagged statistical outliers via 
  a boolean column rather than dropping them, since extreme values often 
  reflect genuine economic events rather than data errors.
- **Reusable, DRY transformation functions** — built shared functions 
  (`load_worldbank_csv`, `unpivot_worldbank_df`, `filter_valid_countries`) 
  applied consistently across all three source datasets.

## Key Findings

- Same-year correlation between education spending and GDP growth is 
  weak (-0.09), and remains weak even with a 5–10 year lag — suggesting 
  the relationship isn't simply time-delayed, but likely shaped by 
  regional economic structure and spending effectiveness rather than 
  spending levels alone.
- The relationship varies significantly by region — North America 
  (+0.28) and MENA (+0.19) show a positive relationship, while Europe & 
  Central Asia (-0.18) and East Asia & Pacific (-0.18) show a negative 
  one — a pattern hidden entirely by the global aggregate figure.
- Population growth has declined consistently every decade since the 
  1960s (2.35% → 1.02%), while education spending has gradually risen 
  (4.1% → 4.4% of GDP) — with a consistent negative correlation between 
  the two, supporting the "quantity-quality tradeoff" theory in 
  development economics.
- World Bank education expenditure data has substantial reporting gaps 
  globally (58–71% missing by region), an important caveat on the 
  reliability of any correlation analysis using this indicator.

## Orchestration

A Databricks Job [global_development_pipeline_job](https://github.com/snehal29/global-development-lakehouse/blob/main/doc/workflow_screenshot.png) chains all stages 
with explicit task dependencies:                                                                                                                                           *bronze_ingestion → silver_transformation → gold_aggregation → dashboard_refresh*

Configured with failure notifications to alert on pipeline breakage.

## Dashboard

Published as an interactive Databricks AI/BI Dashboard with 8+ 
visualizations covering correlation analysis, regional comparisons, 
decade-over-decade trends, top-country rankings, and data coverage gaps.

[Dashboard see here](https://github.com/snehal29/global-development-lakehouse/blob/main/doc/Dashboard-Global-Development-Insights.pdf)

## Author

**Snehal Londhe** — Transitioning into Data Engineering from an Ab Initio background, building hands-on expertise in Databricks, PySpark, and lakehouse architecture.
