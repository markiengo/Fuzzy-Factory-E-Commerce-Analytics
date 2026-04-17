# Fuzzy Factory — Decision-Ready E-Commerce Analytics

<p align="center">
  <strong>A Power BI case study that turns raw e-commerce data into a growth thesis, quantified upside, and an operator-level action plan.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/SQL_Server-Data%20Modeling%20%7C%20Views%20%7C%20QA-0F6CBD?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Power_BI-DAX%20%7C%20Semantic%20Model%20%7C%20Dashboard-F2C811?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Analytics-Growth%20Strategy%20%7C%20Funnel%20%7C%20Unit%20Economics-1F7A5C?style=for-the-badge" />
</p>

> **Big Idea:** Fuzzy Factory does not have a traffic problem. It has a conversion, merchandising, and product-mix problem. The business is already attracting enough demand to unlock roughly **$800K+ in additional annual revenue** before spending another dollar on acquisition.

This project analyzes four years of sessions, pageviews, orders, order items, and refunds for a plush toy e-commerce business. The goal was not to build a dashboard for its own sake, but to answer the question that matters to operators: **where is revenue being left on the table, and what should the business do next?**

**Start here:** [Executive report](REPORT.md)<br>
**Interactive dashboard:** `powerbi/Fuzzy Dashy.pbix`<br>
**Static preview:** `powerbi/Fuzzy Static Dashboard.pdf`

---

## Executive Snapshot

| Metric | Value |
| --- | ---: |
| Gross revenue | **$1.93M** |
| Net revenue | **$1.85M** |
| Profit | **$1.13M** |
| Net margin | **61.03%** |
| Orders | **32,182** |
| Revenue upside from funnel fixes | **~$800K+** |

---

## Why This Analysis Is Different

- It starts with a business constraint, not a chart gallery.
- It distinguishes **volume** from **quality** using conversion rate, revenue per session, margin, refund rate, and basket size.
- It combines **data modeling**, **measure design**, **dashboarding**, and **executive communication** in one deliverable.
- It ends with recommendations by function: CEO, marketing, UX, product, finance, and operations.

In other words, this is not a dashboard-first project. It is a business-first analysis supported by a semantic model, a reporting layer, and a clear operating point of view.

---

## What I Found

### 1. The biggest growth lever is inside the funnel

Fuzzy Factory converts traffic into orders reasonably well overall, but two steps leak the most value:

- **Product Page -> Cart:** 45%
- **Checkout -> Purchase:** 62%

These are high-intent users. Improving these steps creates more value than buying more top-of-funnel traffic.

### 2. The acquisition engine works, but channel quality is uneven

- **Brand search** is the most efficient channel: high CVR, high RPS, limited scale.
- **Nonbrand search** is the growth engine: highest volume and strongest paid-channel revenue contribution.
- **Paid social** underperforms on both conversion and revenue per session.

The implication is straightforward: protect brand, scale nonbrand more intelligently, and force social to justify its budget.

### 3. Merchandising is leaving money on the table

Average basket size is only **1.24 items per order**. That is the clearest sign that cross-sell, bundling, and cart merchandising are underdeveloped.

Moving from **1.24 -> 1.50 items per order** implies roughly a **22% lift in average order value**.

### 4. Product portfolio risk is real

- **Mr. Fuzzy** drives the business, but concentration risk is high.
- **Hudson Mini** has the best unit economics and appears under-promoted.
- **Sugar Panda** shows the highest refund pressure and needs closer merchandising or product QA review.

This is exactly the kind of problem a good analyst should surface: not just what sells, but what creates risk.

---

## Dashboard Preview

| Executive performance | Channel and funnel performance |
| --- | --- |
| ![Executive performance dashboard](assets/finance_report.png) | ![Channel and funnel performance dashboard](assets/marketing_report.png) |

| Product performance | Semantic model |
| --- | --- |
| ![Product performance dashboard](assets/product_report.png) | ![Transformed semantic model](assets/transformed_model.png) |

---

## What This Demonstrates

- Building a decision-ready semantic model from raw transactional data
- Designing business-facing DAX measures instead of relying on implicit aggregations
- Framing findings in terms of **tradeoffs**, **upside**, and **next actions**
- Translating analysis into a language executives, growth teams, and product teams can all use

The strongest analytics work does not stop at "here is the data." It answers:

1. What is happening?
2. Why is it happening?
3. What matters most?
4. What should the business do next?

This project is built around those four questions.

---

## Repository Guide

| Path | What it contains | Why it matters |
| --- | --- | --- |
| [REPORT.md](REPORT.md) | Executive-grade written analysis | Fastest way to understand the thesis and recommendations |
| `powerbi/Fuzzy Dashy.pbix` | Interactive Power BI dashboard | Primary presentation artifact |
| `powerbi/Fuzzy Static Dashboard.pdf` | Static dashboard export | Quick visual review without opening Power BI |
| [docs/dax.md](docs/dax.md) | Measure dictionary | Shows how the model was translated into business KPIs |
| `sql/` | Data model and supporting SQL | Documents the warehouse-style structure behind the analysis |
| `csv/` | Raw source data | Demonstrates source coverage and reproducibility |

---

## Business Questions Answered

- Where is the company profitable, and where is it leaking profit?
- Which acquisition channels deserve more budget, and which deserve less?
- Which funnel steps carry the highest leverage?
- Which products create concentration risk or refund drag?
- How much upside exists before increasing spend?

---

## Review Path

For the fastest path through the work, review the repo in this order:

1. Read [REPORT.md](REPORT.md) for the business thesis and action plan.
2. Open `powerbi/Fuzzy Dashy.pbix` or `powerbi/Fuzzy Static Dashboard.pdf` to inspect the visuals.
3. Review [docs/dax.md](docs/dax.md) for the metric layer.
4. Scan `sql/` if you want the underlying model structure.

---

## Closing Takeaway

The point of this project is not the dashboard alone. The point is the ability to identify economic bottlenecks, size the opportunity, and turn analysis into decisions a business can actually act on.
