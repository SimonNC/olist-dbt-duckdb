{% docs __overview__ %}

# Olist Analytics (dbt + DuckDB)

This project builds an **analytics-ready warehouse** from the Olist e-commerce dataset, using:
- **DuckDB** as local warehouse
- **dbt** for modeling & testing
- **GitHub Pages** for hosted dbt Docs

## Quick links
- 📚 dbt Docs: https://simonnc.github.io/olist-dbt-duckdb
- 💾 Repo: https://github.com/SimonNC/olist-dbt-duckdb
- 🧱 Architecture: see `screenshots/architecture_schema.png`

## What you’ll find
- **staging**: cleaned & typed sources
- **intermediate**: order-level rollups
- **marts.core**: `fct_orders`, customer dimensions
- **marts.kpis**: daily KPIs for BI (orders, revenue, retention)

## Key outputs
- `fct_orders` (grain: 1 row per order)
- `dim_customers_unique` (business customer grain)
- `mrt_kpi_*` (daily KPI marts)

{% enddocs %}
