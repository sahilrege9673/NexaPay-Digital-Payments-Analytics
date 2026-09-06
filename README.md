# NexaPay — Digital Payments Analytics

### End-to-End Fintech Analytics | PostgreSQL · SQL · Python · Power BI

**Turning payment data into executive decisions across growth, transaction performance, fraud, chargebacks, merchants, and customer support.**

[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Python](https://img.shields.io/badge/Analysis-Python-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![Power BI](https://img.shields.io/badge/BI-Power%20BI-F2C811?style=flat-square&logo=powerbi&logoColor=111111)](https://powerbi.microsoft.com/)
[![GitHub](https://img.shields.io/badge/Portfolio-GitHub-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/)

---

## Table of contents

- Executive summary
- Quick navigation
- Business questions
- Analytical workflow
- Tech stack
- Dataset & data period
- Data quality & validation
- SQL, Python, and Power BI analysis
- Key findings & recommendations
- How to explore / Quick start
- Repository structure
- Author & license

---

## Executive summary

NexaPay is a synthetic digital-payments analytics project that demonstrates an end-to-end analytical workflow and the type of work expected of a Data Analyst / BI Analyst in a fintech environment.

Objective: show how to move from raw operational data to decision-ready business insight — not just a dashboard.

Executive highlights (dataset):

- ~120K customers, ~2M transactions, ~35K merchants
- ₹4.74B total transaction value
- 81.39% transaction success rate
- 77.68% customer activity rate (~93K active customers)
- ₹57.0M fraud exposure (1.17% fraud rate)
- ₹47.82M chargeback exposure (1.60% chargeback rate)
- ~90K support tickets; 45.87% resolution rate
- 3.95 / 5 average satisfaction; 10.49 hrs avg resolution time

> Important: this dataset is synthetic and for portfolio/demo purposes only.

---

## Quick navigation

- [Executive Summary](#executive-summary)
- [Business Questions](#business-questions)
- [Analytical Workflow](#analytical-workflow)
- [SQL Analysis](#sql-analysis)
- [Python Analysis](#python-analysis)
- [Power BI Dashboard](#power-bi-dashboard)
- [Key Findings](#executive-findings)
- [Recommendations](#business-recommendations)
- [Repository Structure](#repository-structure)

---

## Business questions

The project is organized around common fintech analytics questions across these domains:

- Customer & growth (segments, channels, activity)
- Transactions & merchants (volume, payment rails, merchant mix)
- Fraud & risk (exposure, payment-method risk, concentration)
- Chargebacks (loss, recovery, reasons)
- Customer support (issue drivers, backlog, SLA)

See the repository's SQL and Python notebooks for queries and analyses that answer these questions.

---

## Analytical workflow

Raw CSV data → PostgreSQL → Data Quality & Validation → SQL Business Analysis → Python Analysis → Power BI Modeling & DAX → Executive Insights → Recommendations

This repo separates data preparation, analysis, visualization, and decision-making so each stage can be reviewed independently.

---

## Tech stack

- Database: PostgreSQL
- SQL: PostgreSQL SQL for cleaning, validation, and core KPIs
- Python: Pandas, NumPy, Matplotlib, Seaborn (validation & EDA)
- BI: Power BI Desktop (modeling, DAX, dashboard)
- Notebooks: Jupyter for reproducible narrative

---

## Dataset

Files (synthetic):

- `customers.csv` — customer master
- `accounts.csv` — accounts per customer
- `transactions.csv` (zipped) — payment activity, outcomes, fraud flags
- `merchants.csv` — merchant master, category, tier
- `chargebacks.csv` — disputes, reasons, recovery
- `support_tickets.csv` — tickets, status, priority, satisfaction

Data period: 2022–2026 (2026 may be partial).

Data disclaimer: This dataset is synthetic and intended for portfolio demonstration only.

---

## Data quality & validation

The repo includes validation checks for:

- row counts and completeness
- missing values and duplicates
- categorical distributions
- primary/foreign-key consistency
- orphan-record checks
- transaction status and risk-field validation
- chargeback amount / recovery relationship checks

Validation is performed in SQL and reinforced in Python notebooks before dashboards are built.

---

## SQL analysis

SQL files live in `SQL/` and are organized by workflow:

- `01_Data_Loading.sql` — load & prepare source datasets
- `02_Data_Cleaning_Validation.sql` — validation checks & fixes
- `03_Business_Analysis.sql` — core KPIs and business questions
- `04_Advanced_Business_Analysis.sql` — deeper analytical cuts

Analytical techniques: joins, aggregations, CTEs, date analysis, segmentation, ranking, conditional aggregations, chargeback/recovery calculations.

---

## Python analysis

Notebooks in `Python/` are used for database connections, validation, and exploratory analysis:

- `01_Data_Connection_Cleaning_Validation.ipynb`
- `02_Business_Analysis.ipynb`

Python is used to validate SQL findings, perform EDA, and produce charts used in reports.

---

## Power BI dashboard

The report (`PowerBI/NexaPay_Dashboard.pbix`) and a PDF preview are included in `PowerBI/`.

Dashboard pages:

1. Executive Overview (KPIs and health summary)
2. Customer Analysis (segments, acquisition, activity)
3. Transactions & Merchant Analysis (payment rails, outcomes)
4. Risk & Fraud Analysis (exposure and decomposition)
5. Support Analysis (workload and resolution)
6. Root Cause Analysis (interactive decomposition)

Design principles: executive KPIs separated from diagnostics, semantic color usage, focused charts, and investigation surfaces.

---

## Key findings (summary)

- Strong scale: ~120K customers and ~2M transactions
- Transaction success ~81.4%; UPI largest by value
- Fraud exposure ~₹57.0M (1.17%); chargebacks ~₹47.82M (1.60%)
- Support volume ~90K tickets; Payment Failure largest issue

Refer to SQL and Python analysis for the full numbers and reproducible queries.

---

## Business recommendations (summary)

1. Improve payment reliability — target Payment Failure to reduce support demand
2. Prioritize fraud by financial exposure (value + risk + context)
3. Strengthen chargeback prevention and recovery
4. Use segmentation and digital acquisition for scalable growth
5. Reduce unresolved support workload by tracking Open + In Progress tickets

---

## How to explore / Quick start

1. Review `PowerBI/NexaPay_Dashboard.pdf` for a quick executive tour.
2. Load data into PostgreSQL (`nexapay_analytics`) and run `SQL/01_Data_Loading.sql`.
3. Run validation in `SQL/02_Data_Cleaning_Validation.sql` and `Python/01_Data_Connection_Cleaning_Validation.ipynb`.
4. Run business analyses in SQL or `Python/02_Business_Analysis.ipynb`.

Local config: use environment variables for DB credentials. Do not commit secrets.

---

## Repository structure

```
NexaPay-Digital-Payments-Analytics/
│
├── README.md
├── Data/
├── SQL/
├── Python/
├── PowerBI/
└── images/
```

---

## Author

**Sahil Rege** — Data Analytics / Business Intelligence Portfolio

Contact: https://github.com/sahilrege9673

---

## License

This repository is provided for portfolio and learning purposes. No license is included by default. Add a LICENSE file if you want to set reuse rules.
