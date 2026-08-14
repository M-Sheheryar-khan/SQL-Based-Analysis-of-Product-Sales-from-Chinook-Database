# 🎵 SQL-Based Analysis of Product Sales — Chinook Database

![SQL](https://img.shields.io/badge/SQL-SQLite-blue) ![Python](https://img.shields.io/badge/Python-3.10+-blue) ![Pandas](https://img.shields.io/badge/Pandas-Analysis-orange) ![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

## 📖 Project Overview

An analytical deep-dive into the Chinook digital music store database — an 11-table relational dataset modeling a real music retailer's customers, invoices, tracks, genres, and sales reps. Using SQL (window functions, CTEs, multi-table joins) and Python for visualization, this project moves beyond basic aggregation to answer the kind of questions a business would actually ask: who are our best customers, which markets and genres drive revenue, and where is the catalog underperforming.

The focus isn't just running queries — it's demonstrating the SQL techniques (window functions, CTEs, customer segmentation, multi-hop joins) that separate a basic reporting query from real analytical work.

## 🎯 Key Highlights

- **8 business questions answered**, each framed and interpreted, not just queried.
- **RFM customer segmentation** built from scratch using `NTILE()` quartile scoring across Recency, Frequency, and Monetary value — surfacing a clear top-tier customer segment.
- **Window functions used purposefully**: `RANK()` for partitioned regional rankings, `LAG()` for month-over-month growth, running `SUM() OVER()` for cumulative revenue trend.
- **Catalog gap analysis** via `LEFT JOIN` — identified 1,519 tracks that have never sold, a real inventory/promotion insight.
- **CTEs (`WITH` clauses)** used to structure multi-step logic cleanly instead of deeply nested subqueries.

## 🛠️ Technologies Used

- **SQLite** — Chinook sample database (Customer, Invoice, InvoiceLine, Track, Genre, Employee tables)
- **DBeaver** — query development and schema exploration
- **Python** — Pandas for data handling, Seaborn/Matplotlib for visualization, run in Jupyter Notebook

## 📊 Approach

1. **Schema exploration** — reviewed table relationships in DBeaver before writing queries, tracing how Customer, Invoice, InvoiceLine, Track, Genre, and Employee connect.
2. **Query development** — wrote and debugged each query directly against the database, iterating from simple aggregates to multi-table joins with window functions.
3. **CTE refactoring** — restructured multi-step logic (e.g. genre ranking) using `WITH` clauses for readability and to set up patterns reused across later queries.
4. **Customer segmentation** — built an RFM model from Invoice/InvoiceLine data, using `julianday()` for recency and `NTILE(4)` for quartile scoring.
5. **Visualization** — every query pulled into Pandas and visualized where a chart adds insight beyond a table.

## 📈 Business Questions & Findings

### 1. Which tracks sell the most units overall?
"The Trooper" leads with 5 units sold; a cluster of tracks (including "Untitled," "The Number of the Beast," and "Eruption") tie at 4 units each — sales at the individual track level are thin and spread across many titles rather than concentrated in a few hits.

![Top Selling Tracks](images/01_top_selling_tracks.png)

### 2. Which countries generate the most revenue?
**USA leads by a wide margin** at $523.06, nearly 1.7x Canada ($303.96), the next-highest country. France ($195.10) and Brazil ($190.10) round out the top 4, with revenue dropping off steeply after the top 5 markets.

![Revenue per Region](images/02_revenue_per_region.png)

### 3. Which genres are most popular in each country?
Rock and Alternative & Punk dominate across most markets. In the USA specifically, Rock leads clearly, with Latin and Metal following. Several countries show close ties between their top 1–2 genres rather than one runaway favorite — regional taste is more competitive than a single global ranking would suggest.

![Genre Popularity by Country (USA)](images/03_genre_by_country_usa.png)

### 4. Is revenue trending up or down month to month?
Revenue is largely flat month to month (many months repeat ~$37.62), punctuated by sharp swings — a +39.87% jump in Jan 2010 and a -25.68% drop in Jul 2011 stand out. This pattern suggests revenue is driven by a small number of invoices per month rather than steady transaction volume.

![Month-over-Month Growth](images/04_mom_revenue_growth.png)

### 5. How has revenue accumulated over time?
Cumulative revenue grew steadily and predictably across the ~5-year dataset, reaching roughly **$2,328 by December 2013**, with no plateaus or declines in the running total — consistent, if modest, month-over-month contribution throughout.

![Cumulative Revenue](images/05_cumulative_revenue.png)

### 6. Which customers are most valuable, and which are at risk of churning?
RFM segmentation surfaced a top tier of repeat customers who all placed exactly 7 orders — e.g. Helena Holý ($49.62 spent, last purchase 48 days before the analysis cutoff). Notably, recency varies widely even among top spenders (from 17 to 443 days), showing frequency and monetary value don't always move together with recency — some high-value customers may already be going quiet.

![RFM Segmentation](images/06_rfm_segmentation.png)

### 7. Which tracks have never sold?
**1,519 tracks** — a substantial share of the total catalog — have zero recorded sales. This is a clear signal for bundling, promotion, or catalog trimming rather than treating all inventory as equally viable.

### 8. Which sales reps drive the most revenue?
**Jane Peacock** leads at $833.04 across 146 orders, followed by Margaret Park ($775.40 / 140 orders) and Steve Johnson ($720.16 / 126 orders) — a relatively tight spread across the top 3 reps.

| Rep | Orders | Revenue | Rank |
|---|---|---|---|
| Jane Peacock | 146 | $833.04 | 1 |
| Margaret Park | 140 | $775.40 | 2 |
| Steve Johnson | 126 | $720.16 | 3 |

## ⚠️ Limitations

- Chinook's transaction data spans 2009–2013; "recency" in the RFM analysis is calculated against the dataset's last recorded date (Dec 31, 2013), not the present day.
- The dataset is a small, synthetic sample (not live production data) — some monthly revenue patterns (repeated flat totals) reflect the dataset's generation rather than real-world sales behavior.
- No forecasting or predictive modeling included — this project focuses on descriptive and diagnostic analysis.

## 🚀 Running This Project

```bash
git clone https://github.com/M-Sheheryar-khan/SQL-Based-Analysis-of-Product-Sales-from-Chinook-Database.git
cd SQL-Based-Analysis-of-Product-Sales-from-Chinook-Database

pip install pandas seaborn matplotlib
```

Ensure `Chinook_Sqlite.sqlite` is in the same directory, then open `SQL-Based Analysis of Product Sales.ipynb` in Jupyter and run all cells top to bottom.

## 📄 Files

- `Chinook_Analysis.sql` — standalone SQL queries
- `SQL-Based Analysis of Product Sales.ipynb` — full analysis with visualizations
- `Chinook_Sqlite.sqlite` — source database
- `images/` — exported chart visualizations
