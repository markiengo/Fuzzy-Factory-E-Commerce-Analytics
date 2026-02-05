# Fuzzy Factory E-Commerce Analytics

> **Revenue, Funnel & Marketing Performance Analysis**

[![SQL Server](https://img.shields.io/badge/SQL-Server-CC2927?logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/sql-server)
[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?logo=power-bi&logoColor=black)](https://powerbi.microsoft.com/)
[![Excel](https://img.shields.io/badge/Excel-217346?logo=microsoft-excel&logoColor=white)](https://www.microsoft.com/microsoft-365/excel)

**Author:** Markie Ngo — Data Analyst  
**Tools:** SQL Server, Power BI (DAX, data modeling), Excel  
**Project Type:** End-to-End Business Intelligence System  
**Dataset:** E-commerce behavioural and transactional data (sessions, pageviews, orders, order items, refunds, products)

---

## 📋 Table of Contents

- [Executive Summary](#executive-summary)
- [Business Context & Objectives](#business-context--objectives)
- [Dataset Overview](#dataset-overview)
- [Data Modeling (Star Schema)](#data-modeling-star-schema)
- [Data Processing & Validation](#data-processing--validation)
- [KPI Framework](#kpi-framework)
- [Dashboard Structure](#dashboard-structure)
- [Business Insights by Stakeholder](#business-insights-by-stakeholder)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)

---

## 🎯 Executive Summary

This project develops a comprehensive Business Intelligence (BI) system for the **Fuzzy Factory** e-commerce shop. Using raw behavioural data from web sessions and pageviews alongside transactional order data, the system provides a complete view of how visitors arrive on the site, progress through the purchase funnel and generate revenue.

### Project Goals

- ✅ Evaluate financial performance and profitability over time
- ✅ Identify which marketing channels drive high-quality traffic
- ✅ Diagnose where customers drop off in the conversion funnel
- ✅ Understand product profitability and refund risk

The result is a **multi-page Power BI dashboard** built on a star schema data model. It enables executives, marketing and product teams to make data-driven decisions about marketing spend, funnel improvements and product strategy.

---

## 🏢 Business Context & Objectives

Fuzzy Factory is growing its online business by investing in digital marketing. Leadership wants to ensure that growth is efficient, profitable and sustainable. To do this, the company needs to look beyond top-line revenue and understand the quality of traffic and the efficiency of each funnel step.

### Core Business Questions

| Question | Focus Area |
|----------|------------|
| **Channel efficiency** | Which marketing channels generate the highest-quality traffic? |
| **Funnel performance** | Where are the largest drop-offs in the web purchase funnel? |
| **Product profitability** | Which products drive profit versus refund risk? |
| **Conversion efficiency** | How efficiently does traffic convert into revenue and margin? |
| **Action prioritisation** | Which actions would most improve profitability? |

---

## 📊 Dataset Overview

The analysis uses six raw tables that capture both customer behaviour and financial transactions. The original CSV files are included in the repository.

| Table | Description | Grain |
|-------|-------------|-------|
| `website_sessions.csv` | Each row records a unique user session on the site, including device and traffic source | Session |
| `website_pageviews.csv` | All pageviews within each session, showing how users move through the funnel | Pageview |
| `orders.csv` | Completed orders with order-level detail (customer, timestamp, status) | Order |
| `order_items.csv` | Items within each order; contains price, cost and product information | Order item |
| `order_item_refunds.csv` | Refund transactions linked to order items | Refund transaction |
| `products.csv` | Product catalogue with names, categories and costs | Product |

> **Note:** These datasets span several years of operations and include over one million records. Behavioural data is at the session and pageview level; financial data is captured at the order and order-item level.

---

## 🗂️ Data Modeling (Star Schema)

The project follows best practices in analytics engineering by building a **star schema**. This separates dimensions (descriptive attributes) from facts (numeric measures) and avoids fact-to-fact joins, ensuring scalable analysis.

### Dimensions

- **`dim_date`** – Calendar table for date hierarchies and time-based analysis
- **`dim_products`** – Product attributes (name, category, cost)
- **`dim_sessions`** – Bridge dimension capturing session attributes (device, channel, landing page)

### Facts

- **`fact_sales`** – Order-item grain with net revenue, cost and profit; handles refunds correctly
- **`fact_funnel_performance`** – Session grain with flags for each funnel step (landing, product view, cart, checkout, purchase)

With this model the dashboard can slice sales or funnel metrics by product, channel, device and time without complex joins.

![Star Schema](assets/star_schema_after.png)

---

## 🔧 Data Processing & Validation

The raw CSV files are loaded and transformed using SQL. Major steps include:

1. **Data cleaning** – Standardising data types, handling nulls and invalid values
2. **Channel grouping** – Grouping marketing sources into meaningful channels (e.g., paid search, brand, non-brand, organic, social, email)
3. **Refund aggregation** – Calculating net revenue by adjusting for refunds at the correct grain
4. **View creation** – Building analytical views for each fact and dimension table
5. **Metric validation** – Reconciling revenue, orders and refunds between the SQL layer and Power BI measures to ensure accuracy

> SQL scripts for schema creation, views, exploratory analysis and validation are included in the `/sql` directory.

---

## 📈 KPI Framework

To focus stakeholders on business outcomes, the dashboard uses the following key performance indicators:

| Category | Key Metrics |
|----------|-------------|
| **Financial** | Revenue, Profit, Margin, Average Order Value (AOV) |
| **Marketing** | Sessions, Conversion Rate (CVR), Revenue per Session (RPS) |
| **Funnel** | Step conversion rates, Drop-off analysis from session to purchase |
| **Product** | Units sold, Net margin, Refund rate |
| **Retention** | Repeat session percentage |
| **Quality** | Bounce rate (contextual; used carefully to avoid misinterpretation) |

> Metric definitions (DAX formulas) are documented in [`docs/dax_measures.md`](docs/dax_measures.md). The dashboard reconciles these measures back to the SQL layer to ensure trust.

---

## 📱 Dashboard Structure

The Power BI dashboard is designed for executives and functional teams. It consists of four pages:

### 1️⃣ Executive Overview
Summarises financial health, revenue growth, profit and margin trends.

![Executive Overview](assets/dashboard_page1.png)

### 2️⃣ Marketing & Funnel Performance
Highlights channel efficiency (CVR, RPS), session volumes, and step-by-step funnel drop-offs.

![Marketing & Funnel Performance](assets/dashboard_page2.png)

### 3️⃣ Product Analysis
Shows product-level profitability, margin, refund rates and concentration of revenue.

![Product Analysis](assets/dashboard_page3.png)

### 4️⃣ Recommendations *(in progress)*
Will provide actionable insights drawn from the analysis.

> **Note:** Screenshots of each dashboard page and the PBIX file are included in the repository.

---

## 💡 Business Insights by Stakeholder

Different teams at Fuzzy Factory can use the dashboard to answer their specific questions. The table below summarises key insights for each stakeholder and the corresponding business impact.

| Stakeholder | Key Insights | Business Impact |
|-------------|--------------|-----------------|
| **Executive Team** | Growth varies significantly by channel; some sources drive revenue but erode margin. Overall profitability depends more on channel mix and refund rates than on raw sales volume. | Enables leadership to prioritise profitable growth, adjust budgets away from low-quality channels and monitor net margin alongside revenue. |
| **Marketing Team** | Paid search performance differs between brand and non-brand keywords; non-brand generates most sessions but lower RPS and CVR. Organic and referral traffic show high engagement and conversion. | Guides budget reallocation towards high-quality traffic sources and optimisation of paid campaigns (improve landing pages, bidding strategies). |
| **Growth & UX Team** | Major drop-offs occur between product detail and cart, and between checkout and purchase. Device differences reveal that mobile users abandon at higher rates. | Highlights areas to improve user experience, such as simplifying product pages, speeding checkout, and tailoring UX for mobile devices to recover lost conversions. |
| **Product Team** | A small number of SKUs drive most profit, but some top sellers have elevated refund rates, threatening margin. Cross-selling impacts items per order and AOV. | Informs product decisions: improve quality for high-refund products, adjust pricing or bundles to increase items per order, and focus on profitable SKUs. |
| **Operations Team** | Refund patterns reveal issues in fulfillment or customer expectations; certain products and time periods correlate with higher refunds. | Allows operations to investigate root causes (packaging, shipping, QC) and reduce refunds, thereby protecting profit and customer satisfaction. |

---

## 📁 Repository Structure

```
fuzzy-factory-analytics/
├── csv/
│   ├── website_sessions.csv
│   ├── website_pageviews.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── order_item_refunds.csv
│   └── products.csv
├── sql/
│   ├── Schema DDL final.sql
│   ├── Views (newest).sql
│   ├── Data Validation.sql
│   └── Exploratory Data Analysis.sql
├── assets/
│   ├── star_schema_before.png
│   ├── star_schema_after.png
│   ├── dashboard_page1.png
│   ├── dashboard_page2.png
│   ├── dashboard_page3.png
│   └── dashboard_page4.png (placeholder)
├── powerbi/
│   └── fuzzy_factory_dashboard.pbix
├── docs/
│   └── dax_measures.md
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- SQL Server (or compatible SQL database)
- Power BI Desktop
- Basic understanding of SQL and data visualization

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/fuzzy-factory-analytics.git
   cd fuzzy-factory-analytics
   ```

2. **Load the data**
   - Import CSV files from the `/csv` directory into your SQL Server database

3. **Run SQL scripts**
   ```sql
   -- Execute in order:
   -- 1. Schema DDL final.sql
   -- 2. Views (newest).sql
   -- 3. Data Validation.sql (optional, for testing)
   ```

4. **Open Power BI**
   - Open `fuzzy_factory_dashboard.pbix` from the `/powerbi` directory
   - Update data source connections to point to your SQL Server
   - Refresh the data model

5. **Explore the dashboard**
   - Navigate through the four dashboard pages
   - Apply filters and drill down into specific metrics

---

## 📧 Contact

**Markie Ngo** - Data Analyst

- LinkedIn: [your-linkedin-profile](#)
- Email: your.email@example.com
- Portfolio: [your-portfolio-site](#)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Dataset inspired by real e-commerce analytics challenges
- Built as a comprehensive portfolio project demonstrating end-to-end BI capabilities
- Special thanks to the data analytics community for best practices and guidance

---

⭐ **If you found this project helpful, please consider giving it a star!**
