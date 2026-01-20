from pathlib import Path
import pandas as pd

BASE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = BASE_DIR / "data"
OUT_DIR = BASE_DIR / "data_sample"
OUT_DIR.mkdir(parents=True, exist_ok=True)

# fichiers Kaggle Olist (noms attendus)
FILES = {
    "olist_orders_dataset.csv": 20000,
    "olist_order_items_dataset.csv": 40000,
    "olist_order_payments_dataset.csv": 30000,
    "olist_customers_dataset.csv": 20000,
    "olist_sellers_dataset.csv": 10000,
    "olist_products_dataset.csv": 20000,
    "olist_order_reviews_dataset.csv": 20000,
    "olist_geolocation_dataset.csv": 50000,
}

def main():
    missing = [f for f in FILES if not (DATA_DIR / f).exists()]
    if missing:
        raise FileNotFoundError(
            "Fichiers manquants dans data/: " + ", ".join(missing)
        )

    for filename, nrows in FILES.items():
        src = DATA_DIR / filename
        dst = OUT_DIR / filename
        print(f"Sampling {src.name} -> {dst.name} (n={nrows})")

        # lecture partielle (rapide) + write csv
        df = pd.read_csv(src, nrows=nrows)
        df.to_csv(dst, index=False)

    print(f"\nOK: data_sample generated in {OUT_DIR}")

if __name__ == "__main__":
    main()
