# Olist – dbt + DuckDB (SQL-only)

This project demonstrates an end-to-end **analytics engineering workflow**
using **dbt** and **DuckDB**, applied to the Olist e-commerce dataset.

## Objectives
- Build a clean analytics layer (facts & dimensions)
- Expose business KPIs via SQL-only marts
- Apply data quality tests and documentation with dbt
- Publish dbt docs on GitHub Pages

## Tech stack
- DuckDB (local data warehouse)
- dbt
- SQL (100%)

## Project structure
- `models/` : dbt models (staging → intermediate → marts)
- `scripts/` : data loading helpers
- `data_sample/` : small CSV sample for CI & reproducibility

## Status
Project setup – models to be implemented.
