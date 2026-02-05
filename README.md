🛒 Fuzzy Factory E-Commerce Analytics: Revenue, Funnel & Marketing Performance (SQL + Power BI)

Author: Markie Ngo — Data Analyst
Tools Used: SQL Server, Power BI (DAX, data modeling), Excel
Project Type: End-to-End Business Intelligence System
Dataset Size: ~1M+ e-commerce records across 4 years

📑 Table of Contents

Executive Summary

Business Context & Objectives

Dataset Overview

Data Modeling (Star Schema Design)

Data Processing & Validation (SQL)

KPI Framework

Dashboard Pages

Key Insights

Business Recommendations

Repository Structure

🚀 Executive Summary

This project builds a full Business Intelligence system for Fuzzy Factory, an online retailer, to evaluate:

Financial performance

Marketing acquisition quality

Website funnel effectiveness

Product profitability and refund impact

Using session-level behavioral data and order-item level sales data, this system helps stakeholders understand:

Which marketing channels drive profitable growth

Where customers drop off in the conversion funnel

Which products generate margin vs. refund risk

How efficiently traffic converts into revenue

The result is a decision-support dashboard for executives, marketing, and product teams.

📌 Business Context & Objectives

Scenario:
Fuzzy Factory is an e-commerce company investing in digital marketing to scale growth. Leadership needs clarity on whether growth is efficient, profitable, and operationally sustainable.

Core Business Questions

Which marketing channels generate the highest-quality traffic?

Where are the largest drop-offs in the website conversion funnel?

Which products drive profit vs. refund risk?

How efficiently does traffic convert into revenue and margin?

What operational or marketing improvements could increase profitability?

📂 Dataset Overview

Raw Tables Used

website_sessions

website_pageviews

orders

order_items

order_item_refunds

products

Data Grain

Session-level behavioral tracking

Order-item level financial tracking

🏗 Data Modeling (Star Schema Design)

This project follows proper BI modeling principles.

Dimension Tables

dim_date

dim_products

dim_sessions (bridge dimension)

Fact Tables

fact_sales (order-item grain, includes net revenue & profit)

fact_funnel_performance (session grain, includes funnel flags)

This design avoids fact-to-fact joins and enables scalable slicing across channels, devices, products, and time.

🔧 Data Processing & Validation (SQL)

Key engineering steps:

Cleaned nulls and standardized data types

Built channel grouping logic

Aggregated refunds at correct grain

Created analytical views for facts and dimensions

Validated KPI totals using SQL reconciliation queries

📊 KPI Framework

Metrics are designed to reflect business performance, not vanity metrics.

Category	KPIs
Financial	Revenue, Profit, Margin, AOV
Marketing	Sessions, Conversion Rate (CVR), Revenue per Session (RPS)
Funnel	Step conversion rates, Drop-off analysis
Product	Units sold, Refund rate, Product margin
Retention	Repeat session %
Quality	Bounce rate
📈 Dashboard Pages
Page 1 — Executive Overview

High-level financial health, order volume, margin trends.

Page 2 — Marketing & Funnel Performance

Channel efficiency, CVR, RPS, and funnel drop-off analysis.

Page 3 — Product Analysis

Product-level profitability, refund risk, and margin structure.

Page 4 — Recommendations (In Progress)

Synthesis of insights into prioritized business actions.

🔍 Key Insights
Marketing Quality > Traffic Volume

Some channels drive large traffic but low efficiency, while brand search channels produce high CVR and RPS.

Funnel Drop-Off Concentration

The largest performance losses occur between Product Detail → Cart and Checkout → Purchase stages.

Product Profitability Imbalance

A small number of products drive most profit, but some show elevated refund risk that threatens margin.

Growth Efficiency Risk

High revenue growth does not always correspond to high profitability — channel mix and refund rates matter.

💡 Business Recommendations

Reallocate marketing budget toward high-RPS channels

Optimize product pages to improve cart conversion

Reduce checkout friction

Address refund drivers for high-volume products

Use RPS and margin — not just traffic — as core growth metrics

📁 Repository Structure
/sql
  - schema_ddl.sql
  - views.sql
  - data_validation.sql
  - exploratory_analysis.sql

/assets
  - star_schema_before.png
  - star_schema_after.png
  - dashboard_page1.png
  - dashboard_page2.png

/powerbi
  - dashboard.pbix

/docs
  - dax_measures.md
