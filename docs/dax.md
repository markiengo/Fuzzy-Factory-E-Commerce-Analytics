## Key DAX Formulas

<details>
  <summary>Financial Metrics</summary>
  <br>

**Gross Revenue**: Total ticket price before refunds
```dax
Gross Revenue = SUM(fact_sales[price])
```

**Net Revenue**: Actual revenue after refunds
```dax
Net Revenue = 
CALCULATE(
    SUM(fact_sales[price]),
    fact_sales[refund_flag] = 0
)
```

**Profit**: Net revenue minus cost
```dax
Profit = [Net Revenue] - [Total Cost]
```

**Net Margin %**: Profit as percentage of net revenue
```dax
Net Margin % = 
DIVIDE(
    [Profit],
    [Net Revenue],
    0
)
```

**Refund Rate %**: Percentage of orders that were refunded
```dax
Refund Rate % = 
DIVIDE(
    CALCULATE(COUNT(fact_sales[order_item_id]), fact_sales[refund_flag] = 1),
    COUNT(fact_sales[order_item_id]),
    0
)
```

**Average Order Value (AOV)**: Average revenue per order
```dax
AOV = 
DIVIDE(
    [Net Revenue],
    [Total Orders],
    0
)
```

**Average Selling Price (ASP)**: Average price per item sold
```dax
ASP = 
DIVIDE(
    [Net Revenue],
    COUNT(fact_sales[order_item_id]),
    0
)
```

</details>

<details>
  <summary>Marketing & Funnel Metrics</summary>
  <br>

**Total Sessions**: Count of unique web sessions
```dax
Total Sessions = DISTINCTCOUNT(fact_funnel[session_id])
```

**Conversion Rate (CVR)**: Percentage of sessions that result in purchase
```dax
CVR = 
DIVIDE(
    [Total Orders],
    [Total Sessions],
    0
)
```

**Revenue per Session (RPS)**: Average revenue generated per session
```dax
RPS = 
DIVIDE(
    [Net Revenue],
    [Total Sessions],
    0
)
```

**Funnel Step Conversion Rates**:
```dax
Landing to Catalog % = 
DIVIDE(
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[viewed_catalog] = 1),
    [Total Sessions],
    0
)

Catalog to Product % = 
DIVIDE(
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[viewed_product] = 1),
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[viewed_catalog] = 1),
    0
)

Product to Cart % = 
DIVIDE(
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[added_to_cart] = 1),
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[viewed_product] = 1),
    0
)
```

</details>

<details>
  <summary>Product Metrics</summary>
  <br>

**Units Sold**: Total quantity of items sold
```dax
Units Sold = COUNT(fact_sales[order_item_id])
```

**Product Profit**: Profit contribution by product
```dax
Product Profit = CALCULATE([Profit])
```

**Product Margin %**: Margin percentage by product
```dax
Product Margin % = 
DIVIDE(
    [Product Profit],
    CALCULATE([Net Revenue]),
    0
)
```

**Product Refund Rate**: Refund rate by product
```dax
Product Refund Rate = 
DIVIDE(
    CALCULATE(COUNT(fact_sales[order_item_id]), fact_sales[refund_flag] = 1),
    COUNT(fact_sales[order_item_id]),
    0
)
```

</details>
