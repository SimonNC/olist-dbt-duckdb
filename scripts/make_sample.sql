-- Génère un sample reproductible dans data_sample/ à partir de data/
-- Ajuste la taille en changeant LIMIT.
-- On fait un sample par LIMIT pour garder simple et rapide.

copy (
  select * from read_csv_auto('data/olist_orders_dataset.csv') limit 20000
) to 'data_sample/olist_orders_dataset.csv' (header, delimiter ',');

copy (
  select * from read_csv_auto('data/olist_order_items_dataset.csv') limit 40000
) to 'data_sample/olist_order_items_dataset.csv' (header, delimiter ',');

copy (
  select * from read_csv_auto('data/olist_order_payments_dataset.csv') limit 30000
) to 'data_sample/olist_order_payments_dataset.csv' (header, delimiter ',');

copy (
  select * from read_csv_auto('data/olist_customers_dataset.csv') limit 20000
) to 'data_sample/olist_customers_dataset.csv' (header, delimiter ',');

copy (
  select * from read_csv_auto('data/olist_sellers_dataset.csv') limit 10000
) to 'data_sample/olist_sellers_dataset.csv' (header, delimiter ',');

copy (
  select * from read_csv_auto('data/olist_products_dataset.csv') limit 20000
) to 'data_sample/olist_products_dataset.csv' (header, delimiter ',');

copy (
  select * from read_csv_auto('data/olist_order_reviews_dataset.csv') limit 20000
) to 'data_sample/olist_order_reviews_dataset.csv' (header, delimiter ',');

copy (
  select * from read_csv_auto('data/olist_geolocation_dataset.csv') limit 50000
) to 'data_sample/olist_geolocation_dataset.csv' (header, delimiter ',');
