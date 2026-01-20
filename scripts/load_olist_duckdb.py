from pathlib import Path
import duckdb

BASE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = BASE_DIR / "data"
SAMPLE_DIR = BASE_DIR / "data_sample"
WAREHOUSE_DIR = BASE_DIR / "warehouse"
DB_PATH = WAREHOUSE_DIR / "olist.duckdb"

TABLES = {
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "order_payments": "olist_order_payments_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "products": "olist_products_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
    "geolocation": "olist_geolocation_dataset.csv",
}

def pick_base_path() -> Path:
    """
    CI-first strategy:
    - use data_sample/ if present
    - fallback to data/ for local runs
    """
    sample_orders = SAMPLE_DIR / TABLES["orders"]
    full_orders = DATA_DIR / TABLES["orders"]

    if sample_orders.exists():
        print("Using data_sample/ as data source")
        return SAMPLE_DIR

    if full_orders.exists():
        print("Using data/ as data source")
        return DATA_DIR

    raise FileNotFoundError(
        "No Olist CSV files found. "
        "Expected files in 'data_sample/' or 'data/'."
    )

def main():
    base_path = pick_base_path()

    WAREHOUSE_DIR.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(DB_PATH))
    con.execute("create schema if not exists raw;")

    for table, filename in TABLES.items():
        csv_path = base_path / filename
        print(f"Loading {csv_path}")

        if not csv_path.exists():
            raise FileNotFoundError(f"Missing CSV file: {csv_path}")

        con.execute(f"""
            create or replace table raw.{table} as
            select * from read_csv_auto('{csv_path.as_posix()}');
        """)

        count = con.execute(f"select count(*) from raw.{table}").fetchone()[0]
        print(f"Loaded raw.{table} -> {count} rows")

    con.close()
    print(f"DuckDB database ready at {DB_PATH}")

if __name__ == "__main__":
    main()
