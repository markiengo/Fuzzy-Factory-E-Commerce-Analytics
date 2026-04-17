# Power BI Measure Dictionary

The Power BI model in `powerbi/Fuzzy Dashy.pbix` is the primary reporting artifact for this project. This file documents the core measures used to evaluate revenue quality, conversion efficiency, and product performance.

For readability, the semantic model is referenced with business-facing table names:

- `fact_sales`: item-level revenue, cost, refund, and profit measures
- `fact_funnel`: session-level funnel behavior

The point of these measures is not just aggregation. They are designed to answer the operating question behind the dashboard: **where is the business creating value, and where is it leaking it?**

---

## Base Measures

These are the foundation measures used throughout the report and dashboard.

```dax
Total Orders = DISTINCTCOUNT(fact_sales[order_id])

Total Sessions = DISTINCTCOUNT(fact_funnel[website_session_id])

Units Sold = COUNT(fact_sales[order_item_id])

Total Refund Amount = SUM(fact_sales[refund_amount])
```

---

## Revenue and Profitability

### Gross Revenue

Total item revenue before refunds.

```dax
Gross Revenue = SUM(fact_sales[gross_revenue])
```

### Net Revenue

Revenue after refund impact.

```dax
Net Revenue = SUM(fact_sales[net_revenue])
```

### Profit

Net profit after cost of goods and refunds.

```dax
Profit = SUM(fact_sales[net_profit])
```

### Total Cost

Cost of goods sold at the item level.

```dax
Total Cost = SUM(fact_sales[cost_of_goods])
```

### Net Margin %

Profitability as a share of net revenue.

```dax
Net Margin % = DIVIDE([Profit], [Net Revenue], 0)
```

### Average Order Value (AOV)

How much revenue the business generates per completed order.

```dax
AOV = DIVIDE([Net Revenue], [Total Orders], 0)
```

### Average Selling Price (ASP)

Average revenue per item sold.

```dax
ASP = DIVIDE([Net Revenue], [Units Sold], 0)
```

### Refund Rate %

Share of sold items that were refunded.

```dax
Refund Rate % =
DIVIDE(
    CALCULATE(COUNT(fact_sales[order_item_id]), fact_sales[is_refunded] = 1),
    COUNT(fact_sales[order_item_id]),
    0
)
```

---

## Traffic and Conversion

### Conversion Rate (CVR)

Orders as a share of sessions.

```dax
CVR = DIVIDE([Total Orders], [Total Sessions], 0)
```

### Revenue per Session (RPS)

The most useful paid-channel efficiency metric in this project because it combines conversion and order value into one number.

```dax
RPS = DIVIDE([Net Revenue], [Total Sessions], 0)
```

### Landing Page -> Catalog %

How many sessions progress from landing to product discovery.

```dax
Landing to Catalog % =
DIVIDE(
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_products_page] = 1),
    [Total Sessions],
    0
)
```

### Catalog -> Product %

How many product-discovery sessions move deeper into an individual product page.

```dax
Catalog to Product % =
DIVIDE(
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_individual_product] = 1),
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_products_page] = 1),
    0
)
```

### Product -> Cart %

The most important funnel measure in the analysis because it captures product-page selling power.

```dax
Product to Cart % =
DIVIDE(
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_cart] = 1),
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_individual_product] = 1),
    0
)
```

### Cart -> Shipping %

Shows how often cart intent survives the first transaction step.

```dax
Cart to Shipping % =
DIVIDE(
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_shipping] = 1),
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_cart] = 1),
    0
)
```

### Shipping -> Checkout %

Measures how often users continue once shipping is introduced.

```dax
Shipping to Checkout % =
DIVIDE(
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_billing] = 1),
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_shipping] = 1),
    0
)
```

### Checkout -> Purchase %

Captures final-stage friction among users who already showed strong intent.

```dax
Checkout to Purchase % =
DIVIDE(
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_thank_you] = 1),
    CALCULATE(COUNTROWS(fact_funnel), fact_funnel[saw_billing] = 1),
    0
)
```

---

## Product and Portfolio Metrics

### Product Margin %

Profitability by product or any other selected slice.

```dax
Product Margin % = DIVIDE([Profit], [Net Revenue], 0)
```

### Product Refund Rate

Refund intensity at the SKU level.

```dax
Product Refund Rate =
DIVIDE(
    CALCULATE(COUNT(fact_sales[order_item_id]), fact_sales[is_refunded] = 1),
    COUNT(fact_sales[order_item_id]),
    0
)
```

### Basket Size

Average number of items purchased per order.

```dax
Basket Size = DIVIDE([Units Sold], [Total Orders], 0)
```

---

## Why These Measures Matter

This measure layer is designed to do three things well:

1. Separate **scale** from **efficiency**
2. Show where the company is winning or leaking value
3. Translate model logic into language a business stakeholder can act on

That is the standard I aim for in analytics work: metrics should not just calculate correctly, they should make better decisions easier.
