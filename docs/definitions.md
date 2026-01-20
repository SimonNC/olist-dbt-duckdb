{% docs col_order_id %}
Unique identifier of an order.
This column defines the **grain** of the `fct_orders` fact table.
{% enddocs %}

{% docs col_customer_id %}
Technical identifier of a customer.
Used for joins with operational source systems.
{% enddocs %}

{% docs col_customer_unique_id %}
Business-level customer identifier.
Allows tracking the same customer across multiple orders.
{% enddocs %}

{% docs col_revenue_total %}
Total revenue generated, expressed in BRL.
Computed as the sum of all payment events.
{% enddocs %}
