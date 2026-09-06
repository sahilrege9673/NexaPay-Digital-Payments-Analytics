# NexaPay — Digital Payments Analytics (Recruiter‑ready)

One-line pitch
NexaPay is an end-to-end fintech analytics portfolio project that converts raw payments operations data into decision‑ready executive insights (fraud exposure, chargeback risk, payment reliability, merchant health, and support backlog).

Objective
Demonstrate how to move from raw operational payments data to prioritized, actionable recommendations that a Payments or Risk team can execute to reduce loss and improve merchant/customer experience.

TL;DR / Executive snapshot
- Dataset (synthetic, portfolio): ~120K customers • ~2.0M transactions • ~35K merchants • ~90K support tickets
- Financial scale: ₹4.74B total transaction value
- Performance & risk: 81.4% transaction success rate • ₹57.0M fraud exposure (1.17%) • ₹47.82M chargeback exposure (1.60%)
- Support & experience: ~90K tickets; avg resolution 10.5 hrs; avg satisfaction 3.95/5

Important: this dataset is synthetic for demonstration and hiring purposes only.

What I built (deliverables)
- Fully documented SQL pipeline for data loading, cleaning, validation, and business KPIs (SQL/).
- Jupyter notebooks for validation, EDA, and reproducible analyses (Python/).
- A Power BI report with executive + diagnostic pages (PowerBI/NexaPay_Dashboard.pbix and PDF preview).
- Analytical outputs (CSV) for downstream reporting and model inputs (analytical_data/).
- This README (reworked to be recruiter‑friendly and objective‑driven).

Why this matters (business context)
Payment platforms face three linked priorities:
1. Reduce revenue loss from fraud & chargebacks (financial exposure)
2. Improve payment reliability (reduce failure rate & support load)
3. Keep merchant partners stable (prioritize settlement/risk decisions)

This project answers those questions with measurable KPIs and prioritized recommendations.

How I approached it (pipeline)
1. Raw CSVs → PostgreSQL (SQL/01_Data_Loading.sql)
2. Table‑level validation & data‑quality rules in SQL (SQL/02_Data_Cleaning_Validation.sql)
3. Business metrics and segmentation queries (SQL/03_Business_Analysis.sql & SQL/04_Advanced_Business_Analysis.sql)
4. Python notebooks for chunked ETL, derived analytical tables, EDA and export (Python/*.ipynb)
5. Power BI for executive dashboards, modeled off the analytical tables

Top skills & hiring signals
- Data modelling & pipelines: table design, FK checks, dedup/NULL logic (Postgres SQL).
- Data quality & validation: row‑level checks, orphan checks, distribution tests.
- Analytical SQL: segmentation, conditional aggregations, cohort/time‑series, ranking.
- Python for production‑scale EDA: chunked reads, derived features, exportable artifacts.
- BI & storytelling: executive KPIs, diagnostic pages, interactive root‑cause surfaces (Power BI).
- Domain: payments, fraud metrics, chargeback economics, support SLAs.

Top repository artifacts (what to open first)
- PowerBI/NexaPay_Dashboard.pdf — quick executive tour (visual first).
- SQL/01_Data_Loading.sql — how data was loaded to Postgres.
- SQL/02_Data_Cleaning_Validation.sql — data‑quality checks and failures to watch.
- SQL/03_Business_Analysis.sql & SQL/04_Advanced_Business_Analysis.sql — core business queries.
- Python/01_Data_Connection_Cleaning_Validation.ipynb — reproducible EDA & analytical table creation.

Quick findings (concise, actionable)
1. Payment reliability: overall success rate ~81.4% — significant failure pool concentrated by channel & payment_method. Immediate ROI from improving top failure channels.
2. Fraud & chargebacks: fraud exposure ~₹57M (1.17%) and chargebacks ~₹47.82M (1.60%). Recoveries are partial — prioritize highest unrecovered reasons/merchants.
3. Merchant concentration: a subset of merchant categories/tier contribute disproportionate unrecovered chargeback value — target them for remediation or contract changes.
4. Support burden: ~90K tickets with long‑tail unresolved tickets; Payment Failure is the most frequent driver — fixing reliability reduces operating cost.
5. Customer segmentation: activity and value differ markedly by segment and risk_band — use this to prioritize fraud review vs. customer experience interventions.

Top prioritized recommendations (what to pitch to leadership)
1. Reliability‑first (quick wins): fix the top 2 channel+payment_method combinations that have the highest failure rates — measurable lift in success rate and reduced support load.
2. Chargeback triage: implement a chargeback playbook focused on the top 10% of chargeback value by reason_code and merchant category (better recovery/acceptance rules).
3. Fraud prioritization: adopt value‑weighted fraud reviews (focus on high‑value transactions flagged by fraud_score > 70 and payment methods with high fraud_per).
4. Merchant risk program: renegotiate settlement or impose stricter pre‑onboarding for merchant categories with high unrecovered chargebacks.
5. Support automation: route Payment Failure tickets to a dedicated rapid‑response queue and automate common resolutions to cut resolution time and increase satisfaction.

How to run / reproduce (shortest path)
Prereqs: PostgreSQL, Python 3.10+, Power BI Desktop (to open .pbix). Use environment variables for DB creds (do NOT commit secrets).

1. Create DB and load schema:
   - Open SQL/01_Data_Loading.sql, adjust COPY file paths to local CSV locations, run the script in Postgres.
2. Run validations:
   - SQL/02_Data_Cleaning_Validation.sql — run in psql or pgAdmin; inspect failing checks.
3. Run notebooks (local or in a virtual env):
   - pip install pandas sqlalchemy psycopg2-binary jupyterlab (or use requirements.txt if added)
   - Set POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_HOST, POSTGRES_DB in a .env file
   - Open Python/01_Data_Connection_Cleaning_Validation.ipynb and run cells to produce analytical CSVs in analytical_data/.
4. Open PowerBI/NexaPay_Dashboard.pbix for the executive report (it reads from the analytical CSVs included).

Repository structure (top‑level)
```
README.md
Data/                 # raw (synthetic) CSVs (customers, transactions, etc.)
SQL/                  # data load, cleaning, analysis SQL scripts
Python/               # Jupyter notebooks: validation, EDA, and exports
PowerBI/              # Power BI report .pbix and PDF preview
analytical_data/      # generated CSVs used by the dashboard
images/               # screenshots and visual assets
```

What to show in an interview (30–90s sound bites)
- Explain the business question and metrics first: “We needed to reduce ₹X of exposure and improve an 81% success rate.”
- Describe the pipeline in one line: “CSV -> Postgres -> SQL validation -> Python analytical tables -> Power BI.”
- Walk through one high‑impact analysis you did (e.g., channel+payment_method failure analysis) and the recommended next step + expected business impact.

Limitations & ethics (be explicit)
- Synthetic data — numbers are illustrative; do not present them as production customer data.
- No PII in this dataset; do not attempt to link to real customers.
- Assumptions are documented inline in SQL and notebooks — check the validation notebook before using outputs.

What I recommend you add next (small, high‑value)
- Automated CI check: run SQL validation queries in CI and fail if critical KPIs change unexpectedly.
- A short "How I would productionize" section: propose streaming ingestion + incremental materialized views.
- Add a LICENSE (MIT or Apache‑2.0) so a recruiter knows reuse rules.

Contact / author
**Sahil Rege** — Data Analytics / BI portfolio  
https://github.com/sahilrege9673

License
No license file included — add LICENSE if you want reuse rules.
