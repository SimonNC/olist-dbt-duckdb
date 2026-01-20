from pathlib import Path
import pandas as pd

BASE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = BASE_DIR / "data"
OUT_DIR = BASE_DIR / "data_sample"
OUT_DIR.mkdir(parents=True, exist_ok=True)

# Input files (full dataset)
F_ORDERS = "olist_orders_dataset.csv"
F_ORDER_ITEMS = "olist_order_items_dataset.csv"
F_PAYMENTS = "olist_order_payments_dataset.csv"
F_CUSTOMERS = "olist_customers_dataset.csv"
F_SELLERS = "olist_sellers_dataset.csv"
F_PRODUCTS = "olist_products_dataset.csv"
F_REVIEWS = "olist_order_reviews_dataset.csv"
F_GEO = "olist_geolocation_dataset.csv"

# Output files (sample)
OUT_ORDERS = F_ORDERS
OUT_ORDER_ITEMS = F_ORDER_ITEMS
OUT_PAYMENTS = F_PAYMENTS
OUT_CUSTOMERS = F_CUSTOMERS
OUT_SELLERS = F_SELLERS
OUT_PRODUCTS = F_PRODUCTS
OUT_REVIEWS = F_REVIEWS
OUT_GEO = F_GEO

# Sample sizes (tune if needed)
N_ORDERS = 20000
N_GEO = 50000  # geo is independent (no FK constraints in your current tests)

def ensure_files_exist():
    required = [F_ORDERS, F_ORDER_ITEMS, F_PAYMENTS, F_CUSTOMERS, F_SELLERS, F_PRODUCTS, F_REVIEWS, F_GEO]
    missing = [f for f in required if not (DATA_DIR / f).exists()]
    if missing:
        raise FileNotFoundError("Missing files in 'data/':\n- " + "\n- ".join(missing))

def main():
    print("Generating REFERENTIALLY-CONSISTENT Olist sample...\n")
    ensure_files_exist()

    # 1) Orders sample (this defines the universe)
    orders = pd.read_csv(DATA_DIR / F_ORDERS)
    orders_sample = orders.head(N_ORDERS).copy()
    order_ids = set(orders_sample["order_id"].astype(str))

    print(f"Orders: selected {len(orders_sample):,} orders")

    # 2) Order items filtered by sampled orders
    order_items = pd.read_csv(DATA_DIR / F_ORDER_ITEMS)
    order_items["order_id"] = order_items["order_id"].astype(str)
    order_items_sample = order_items[order_items["order_id"].isin(order_ids)].copy()
    print(f"Order items: kept {len(order_items_sample):,} rows (filtered by orders)")

    # Collect seller/product ids from items
    seller_ids = set(order_items_sample["seller_id"].astype(str))
    product_ids = set(order_items_sample["product_id"].astype(str))

    # 3) Payments filtered by sampled orders
    payments = pd.read_csv(DATA_DIR / F_PAYMENTS)
    payments["order_id"] = payments["order_id"].astype(str)
    payments_sample = payments[payments["order_id"].isin(order_ids)].copy()
    print(f"Payments: kept {len(payments_sample):,} rows (filtered by orders)")

    # 4) Reviews filtered by sampled orders
    reviews = pd.read_csv(DATA_DIR / F_REVIEWS)
    reviews["order_id"] = reviews["order_id"].astype(str)
    reviews_sample = reviews[reviews["order_id"].isin(order_ids)].copy()
    print(f"Reviews: kept {len(reviews_sample):,} rows (filtered by orders)")

    # 5) Customers filtered by customer_ids present in sampled orders
    customer_ids = set(orders_sample["customer_id"].astype(str))
    customers = pd.read_csv(DATA_DIR / F_CUSTOMERS)
    customers["customer_id"] = customers["customer_id"].astype(str)
    customers_sample = customers[customers["customer_id"].isin(customer_ids)].copy()
    print(f"Customers: kept {len(customers_sample):,} rows (filtered by orders.customer_id)")

    # 6) Sellers filtered by seller_ids present in sampled items
    sellers = pd.read_csv(DATA_DIR / F_SELLERS)
    sellers["seller_id"] = sellers["seller_id"].astype(str)
    sellers_sample = sellers[sellers["seller_id"].isin(seller_ids)].copy()
    print(f"Sellers: kept {len(sellers_sample):,} rows (filtered by items.seller_id)")

    # 7) Products filtered by product_ids present in sampled items
    products = pd.read_csv(DATA_DIR / F_PRODUCTS)
    products["product_id"] = products["product_id"].astype(str)
    products_sample = products[products["product_id"].isin(product_ids)].copy()
    print(f"Products: kept {len(products_sample):,} rows (filtered by items.product_id)")

    # 8) Geolocation: independent sample (keep first N rows)
    geo = pd.read_csv(DATA_DIR / F_GEO)
    geo_sample = geo.head(N_GEO).copy()
    print(f"Geolocation: selected {len(geo_sample):,} rows (head)")

    # Write outputs
    orders_sample.to_csv(OUT_DIR / OUT_ORDERS, index=False)
    order_items_sample.to_csv(OUT_DIR / OUT_ORDER_ITEMS, index=False)
    payments_sample.to_csv(OUT_DIR / OUT_PAYMENTS, index=False)
    customers_sample.to_csv(OUT_DIR / OUT_CUSTOMERS, index=False)
    sellers_sample.to_csv(OUT_DIR / OUT_SELLERS, index=False)
    products_sample.to_csv(OUT_DIR / OUT_PRODUCTS, index=False)
    reviews_sample.to_csv(OUT_DIR / OUT_REVIEWS, index=False)
    geo_sample.to_csv(OUT_DIR / OUT_GEO, index=False)

    print("\nSUCCESS ✅")
    print(f"Sample dataset generated in: {OUT_DIR.resolve()}")

if __name__ == "__main__":
    main()
