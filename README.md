# NexaPay | Digital Payments Analytics

> End-to-end fintech analytics case study analyzing 1.5M+ transactions across customer behavior, payment performance, fraud exposure, chargebacks, and support operations using SQL, Python, and Power BI

---

## Executive Summary

NexaPay is a fictional but realistic digital payments platform operating in the consumer and merchant payments sector. The product provides transaction processing, settlement, and merchant services across web and mobile channels, supporting card rails, UPI-like instant payments, bank transfers, and third-party wallet integrations. The business historically excels in volume-driven, low-ticket digital payments (strong market presence in consumer P2P and retail micro-payments) while facing operational and financial stress in higher-value merchant segments and dispute resolution workflows. Key operational challenges include uneven reliability across specific channel+payment-method combinations, concentrated chargeback exposure among a small set of merchants, and a support function stretched by transaction-failure driven ticket volumes.

This repository documents a full analytics lifecycle to quantify those issues, connect them to financial impact, and produce prioritized, implementable actions that reduce revenue leakage, lower fraud and chargeback losses, and improve customer experience and operational efficiency.

---

## Business Problem (Reframed as Real, Strategic Problems)

1. Acquisition Channel ROI & Quality: Marketing and acquisition spend is optimized for volume (new signups) rather than value (active, transacting customers). The business lacks precise, data-driven visibility into which channels acquire high-LTV customers. This creates wasted spend, high churn among acquired cohorts, and missed opportunities to scale profitable channels.

2. Payment Reliability & Revenue Leakage: Certain channel + payment-method combinations exhibit materially higher failure rates. This creates direct revenue leakage, double-processing risk, and elevated operational cost from retries and refunds. Without targeted remediation, the business will continue to lose net transaction value and suffer lower customer trust.

3. Merchant Concentration & Systemic Exposure: A small number of merchants contribute a disproportionate share of transaction value. Any disruption (technical, operational, or fraud-related) at these merchants would cause outsized revenue impact and operational complexity.

4. Fraud & Chargeback Financial Risk: Chargebacks and fraud are concentrated in specific payment methods and merchant categories. Low recovery rates on certain dispute reasons magnify unrecovered losses and compress margins. The current controls and monitoring are not fine-grained enough to isolate high-loss pathways quickly.

5. Operational Pressure & Customer Experience Degradation: Failed transactions drive support volume and prolonged resolution times, lowering customer satisfaction and increasing churn risk. Support resource allocation is reactive rather than predictive, creating a cyclical escalation of operational cost and customer dissatisfaction.

Each of these is framed as a measurable business risk (revenue at risk, cost to serve, NPS/retention impact) and forms the basis for prioritized analytics and remediation activity.

---

## Business Objectives (Business-focused, Measurable, and Strategic)

- Maximize Customer Lifetime Value (LTV) through optimized acquisition: identify and prioritize acquisition channels that deliver high-frequency, high-value transacting customers, and reduce cost-per-active-customer by 15–30%.
- Recover lost revenue and reduce transaction failure rate: identify top failure pathways and reduce failure rates in target pathways by 30% within the next quarter, recovering direct transaction value and reducing support costs.
- Reduce net chargeback exposure: increase chargeback recovery rate and reduce unrecovered chargeback value by 25% through targeted merchant controls, dispute prioritization, and merchant education.
- De-risk merchant concentration: quantify top-merchant exposure and implement monitoring/contingency plans for top 20 merchants to minimize single points of failure.
- Strengthen fraud detection & prevention: convert transaction-level fraud signals into financial-risk prioritization — focus controls where monetary exposure is largest, not just where flag counts are highest.
- Improve operational efficiency and customer satisfaction: reduce average support resolution time for transaction-related tickets by 20% and increase satisfaction (CSAT/NPS proxies) by addressing root technical causes.
- Deliver executive-grade intelligence: produce a 6-page Power BI suite providing top-level KPIs, drillable root cause analysis, and automated periodic insights to inform product, risk, finance, and merchant operations.

Each objective maps to measurable KPIs (failure rate, chargeback $ unrecovered, LTV by channel, average resolution time, CSAT) and serves as a target for both analytics and implementation work.

---

## 📋 Dataset & Data Model

**Core Tables:**

| Table | Records | Business Meaning |
|-------|---------|------------------|
| **Customers** | 120,000 | Customer profiles with segment, income, risk band, KYC status, acquisition source |
| **Accounts** | 200,000+ | Customer accounts with type, status, balance, and credit limits |
| **Merchants** | 50,000+ | Merchant profiles with category, tier, risk rating, settlement cycle |
| **Transactions** | 1,500,000 | Payment events with channel, method, amount, status, fraud score |
| **Chargebacks** | 30,000+ | Disputed transactions with reason, amount, recovery status |
| **Support Tickets** | 100,000+ | Customer support cases with category, priority, resolution time, satisfaction |

**Key Relationships:**
```
Customers → Accounts → Transactions ← Merchants
                            ↓
                      Chargebacks
                            
Customers → Support Tickets
```

---

## Data Quality & Validation

We performed an enterprise-grade data validation program before any business analysis. This section summarizes the validation methodology, the tests run, outcomes, and business implications.

What we validated (method + rationale):

- Structural Integrity
  - Primary key uniqueness checks (COUNT vs COUNT DISTINCT) to detect duplicates — ensures row-level identity for joins and event tracing.
  - Foreign key referential checks to ensure there are no orphaned records across Customers, Accounts, Transactions, Chargebacks, and Support Tickets — critical for accurate cross-table joins.
  - Data type validation and casting tests to ensure numeric/date/text columns are usable for aggregations and time-series analysis.

- Value & Range Validation
  - Domain checks for categorical fields (transaction status, account status, KYC status) against an approved dictionary to avoid category drift.
  - Range checks for numeric fields (fraud_score within 0–100, transaction amounts > 0, age between 18–100) to protect against skewed aggregations.

- Completeness & Missingness
  - Column-level null analyses and critical-column completeness gates (e.g., account_id on transactions cannot be NULL).
  - Investigated and documented columns with expected-but-missing values and applied business-default strategies where appropriate.

- Referential & Cross-Table Consistency
  - Verified Customer → Account → Transaction chain for 100% consistency.
  - Cross-checked chargeback records to ensure they map to valid transactions and merchant records.

- Anomaly Detection & Distributional Checks
  - Statistical profiling (percentiles, standard deviation) to detect outliers in transaction amounts, fee distributions, and resolution times.
  - Time-series sanity checks for sudden ingestion spikes indicating batch duplicates or reprocessing.

Tools & Approach
- SQL-based validation scripts (see 02_Data_Cleaning_Validation.sql) for deterministic checks.
- Python notebooks (01_Data_Connection_Cleaning_Validation.ipynb) to reproduce checks, produce profiles, and store artifacts for audit.
- Unit checks and summary reports exported for dashboard integration.

Outcomes (summary)
- No duplicate primary keys across core tables.
- Referential integrity confirmed: no orphaned transactions or chargebacks.
- No NULLs in business-critical columns after cleaning; documented edge-case columns retained with guardrails.
- Fraud score, age, amount ranges validated and within expected bounds.

Business implication: The dataset is production-ready for downstream analytics and BI consumption. High-integrity data enables accurate KPI computation and reliable root-cause analysis.

---

## SQL Analysis (Detailed file-level breakdown & techniques)

### 01_Data_Loading.sql
- Created a normalized schema with explicit PK/FK constraints and partitioning strategies for large tables (transactions) to improve query performance.
- Bulk-load optimizations (COPY or optimized INSERT batching) and index creation to accelerate downstream aggregations.
- Row-count and checksum validations to confirm ingestion completeness.
- Produced audit tables capturing load timestamps and file-level provenance for traceability.

Why this matters: A performant, auditable data foundation enables reproducible analytics and supports frequent refreshes for BI.

### 02_Data_Cleaning_Validation.sql
- Deduplication logic using windowing (ROW_NUMBER() over partition by id ORDER BY ingestion_ts DESC) to keep canonical rows.
- Categorical normalization (standardizing payment_method, channel, and status values) and mapping tables for consistent joins.
- Referential integrity enforcement queries and creation of a cleaned `analytics.transactions_clean` table as the single source of truth for analysis.
- Null-handling strategies and derived flags (e.g., `is_high_value`, `is_retry`) to simplify downstream queries.

Business outcome: Clean, standardized tables reduced downstream join complexity and ensured that business metrics reflect reality rather than ingestion artifacts.

### 03_Business_Analysis.sql
- Business questions addressed: transaction health, customer segmentation, merchant performance, account utilization, growth trends, and risk correlations.
- SQL techniques emphasized (glorified for robustness):
  - Common Table Expressions (CTEs) to structure complex multi-step logic and make queries readable and maintainable.
  - Window functions (ROW_NUMBER, RANK, SUM() OVER(PARTITION BY ...)) for cohorting, top-N merchants, and moving-window trend calculations.
  - CASE expressions for business-rule encoding (e.g., high-risk vs low-risk labeling, tenure buckets).
  - Date-truncation and time-bucketing for monthly/weekly trends and seasonality checks.
  - Ratio and weighted-average calculations for accurate rate computation (fraud rate, success rate, chargeback per $ value).
  - Efficient joins and semi-joins to avoid over-counting in multi-join scenarios.

What we produced: Executive-ready aggregates and drillable views that feed into the Power BI pages for KPIs and trend monitoring.

### 04_Advanced_Business_Analysis.sql
- Advanced analyses performed:
  - Fraud concentration metrics by multidimensional slices (payment method × merchant category × customer risk band) with monetary-weighted impact.
  - Chargeback financial modeling: exposure, recovery rate calculations, and unrecovered value decomposed by reason codes and merchant tiers.
  - Cross-domain analyses linking failed transactions to support-ticket volumes and customer satisfaction measures.
  - Multi-level aggregations and cohort survival-style analyses to quantify persistent risk across customer and merchant cohorts.
- Advanced SQL patterns used: multi-level CTE pipelines, lateral joins for top-k breakdowns, sophisticated windowing for lag/lead analyses, and pivoted aggregations for dashboard-friendly feeding tables.

Business outcome: Prioritized list of risk pathways with dollar-impact estimates enabling focused operational and product interventions.

---

## Python Analysis (Detailed notebooks and engineering practices)

### `01_Data_Connection_Cleaning_Validation.ipynb`
- Engineered robust PostgreSQL connections using SQLAlchemy with environment-driven configuration (python-dotenv) for credentials and connection pooling.
- Extracted datasets incrementally (chunked reads for large transaction tables) to avoid memory issues while ensuring reproducible snapshots for analysis.
- Re-ran validation logic in Python to produce profiling artifacts, histograms, and a set of reproducible data quality reports exported as CSV/JSON to support audit and BI ingestion.
- Implemented helper functions for common checks and applied unit-test-like assertions to fail fast if critical integrity checks regress.

### `02_Business_Analysis.ipynb`
- Performed exploratory analysis: segment-level revenue concentration, failure pattern discovery, correlation matrices (fraud score vs transaction amount vs risk band), and anomaly detection.
- Built visualizations (Matplotlib/Seaborn) to validate trends and prepare narrative slides for stakeholders.
- Exported analytical datasets and summarized tables to a folder consumed by Power BI for visualization and storytelling.

Engineering practices and libraries: pandas for ETL-like transformations, numpy for numeric operations, SQLAlchemy for DB interaction, and modular notebook functions to support reusability.

---

## Power BI Dashboard (6 pages) — meaning, purpose, and a short insight for each page

### Page 1: Executive Overview
*Business health at a glance. KPI scoreboard for leaders.*

Key Insight: This page shows overall platform stability: total transactions, transaction value, average ticket, and net success rate. It highlights month-over-month momentum and quickly surfaces any regressions in success rate or sudden value drops that require executive attention.

### Page 2: Customer Analysis
*Segmentation, acquisition quality, and LTV signals.*

Key Insight: Reveals which customer segments and acquisition channels deliver disproportionate transaction value and sustained engagement. It identifies high-LTV cohorts and channels with poor retention so marketing and growth can reallocate investment to higher-quality sources.

### Page 3: Transactions & Merchant Analysis
*Payment reliability, method/channel performance, and merchant contribution.*

Key Insight: Exposes the weakest channel + payment-method combinations and the merchant categories with the largest value concentration and failure rates. This page is used to prioritize engineering remediations and merchant engagement strategies.

### Page 4: Fraud & Risk Analysis
*Monetary exposure, fraud concentration, and chargeback trends.*

Key Insight: Surfaces where fraud is producing the greatest financial harm (not just highest flag counts). It shows payment methods and merchant categories that drive net loss and helps prioritize fraud-detection tuning and merchant-level controls.

### Page 5: Support Tickets & Customer Experience
*Operational workload, resolution efficiency, and satisfaction correlations.*

Key Insight: Correlates failed transactions to support volume and tracks resolution time vs satisfaction. It identifies high-effort ticket types for automation or self-service and quantifies the customer impact of slow resolutions.

### Page 6: Root Cause Analysis
*Drillable, dimensional decomposition for remediation planning.*

Key Insight: Enables rapid drill-down from KPI regressions to root causes by decomposing failed transaction value across payment method, merchant category, customer segment, channel, and risk band — enabling precise operational tickets to engineering, product, or merchant ops teams.

---

## Key Business Findings (Business-oriented framing)

(Kept concise and business focused — findings map directly to financial and operational impact.)

### Customer Insights
- Affluent customers contribute outsized transaction value though they are a smaller population — opportunity for targeted engagement and cross-sell.
- Mass segment drives volume but lower average ticket size — potential to grow revenue via product nudges and promotions.
- Acquisition channel quality varies: some channels acquire customers who seldom transact, wasting marketing dollars.

### Transaction Insights
- Overall platform is stable but failures concentrate in specific payment-method + channel pathways — targeted fixes expected to yield high ROI.
- Large-ticket transactions show slightly higher failure propensity, leading to higher per-incident revenue risk.

### Merchant Insights
- Top merchants drive substantial value concentration, creating a need for merchant-level monitoring and contingency planning.
- Merchant categories differ in risk and performance; treating them uniformly is inefficient.

### Fraud & Risk Insights
- Fraud is not evenly distributed; specific methods and merchant categories account for disproportionate dollar exposure.
- Risk banding for customers and merchants is predictive and should be used to prioritize controls.

### Chargeback Insights
- Chargeback rate is low in count but high in financial impact; certain reason codes and merchant categories produce more unrecovered losses.

### Support Insights
- Support load is highly concentrated in transaction-related issues; reducing failures directly reduces support cost and improves customer satisfaction.

---

## 🚀📌 Strategic Recommendations & व्यवस्थापन (Business Implementation)

(Kept the original recommendations and prioritized them. Added concise business-implementation focus and emphasized the next steps.)

### 🔴 High Priority — Financial Impact & Risk Mitigation
- Implement tiered chargeback monitoring and prevention for high-exposure merchants; establish SLA-driven escalation paths and special handling for top-20 merchants.
- Conduct targeted technical audits of the highest-failure channel+payment-method combinations and allocate engineering sprints to resolve root causes.
- Create a merchant-education and dispute-prevention program for the reason codes with the worst recovery rates.
- Reduce failed transaction-driven support tickets by implementing proactive error-handling and clear end-user messaging.

### 🟡 Medium Priority — Growth & Efficiency
- Reallocate acquisition spend to channels with best cost-per-active-customer and highest LTV; run controlled experiments to validate uplift.
- Promote low-risk, high-volume payment methods (e.g., UPI-like rails) with incentives to shift mix toward lower fraud exposure.
- Expand merchant programs in categories demonstrating stable risk and high value; diversify revenue concentration.
- Launch engagement campaigns for affluent customers to increase transaction frequency.

### 🟢 Low Priority — Incremental Optimization
- Develop a loyalty and premium offering for low-risk high-engagement customers.
- Document best-practice resolution workflows and replicate across support teams to compress resolution time.

Business Implementation notes (व्यवस्थापन)
- Assign an owner for each high-priority recommendation (Product/Engineering, Risk/Payments, Merchant Ops, Support) and define KPIs (failure rate reduction, recovery rate improvement, LTV uplift, support MTTR) and timelines (30/60/90 day milestones).
- Establish a cross-functional steering committee that reviews the BI outputs weekly and drives implementation tickets to engineering and merchant operations.

---

## Project Workflow

```
Raw CSV Data
    ↓
PostgreSQL Data Loading
    ↓
Data Validation & Cleaning (0 data quality issues found)
    ↓
SQL Business Analysis
├─ Transaction Performance Analysis
├─ Customer Segmentation Analysis
├─ Merchant & Category Analysis
├─ Fraud & Risk Analysis
├─ Chargeback Financial Analysis
└─ Support Operations Analysis
    ↓
Python Exploratory Data Analysis
├─ Pattern Discovery
├─ Correlation Analysis
├─ Outlier Detection
└─ Business Validation
    ↓
Power BI Data Modeling & Visualization
├─ Executive Overview Dashboard
├─ Customer Analysis Dashboard
├─ Transaction & Merchant Dashboard
├─ Fraud & Risk Dashboard
├─ Support Tickets Dashboard
└─ Root Cause Analysis Dashboard
    ↓
Root Cause Decomposition
└─ Multi-dimensional Problem Drilling
    ↓
Business Insights & Recommendations
```

---

## 🛠️ Tools & Technologies

| Category | Technology |
|----------|-----------|
| **Database** | PostgreSQL (data modeling, schema design, complex joins) |
| **Data Validation** | SQL (UNION, CASE statements, aggregate functions, window functions) |
| **Data Analysis** | Python 3.x (pandas, numpy for exploratory analysis) |
| **Visualization** | Power BI (multi-page dashboards, interactive filters, drill-through analysis) |
| **Connection** | SQLAlchemy (Python ↔ PostgreSQL integration) |
| **Environment** | Python virtual environment, .env configuration |

---

## 📁 Repository Structure

```
NexaPay-Digital-Payments-Analytics/
├── DataSet_Files/
│   ├── customers.csv              (120,000 customer profiles)
│   ├── accounts.csv               (200,000+ accounts)
│   ├── merchants.csv              (50,000+ merchant profiles)
│   ├── transactions.zip           (1.5M+ transaction records)
│   ├── chargebacks.csv            (30,000+ chargeback disputes)
│   └── support_tickets.csv        (100,000+ support cases)
│
├── SQL/
│   ├── 01_Data_Loading.sql        (Schema creation & data import)
│   ├── 02_Data_Cleaning_Validation.sql (Data quality checks)
│   ├── 03_Business_Analysis.sql   (Core business queries)
│   └── 04_Advanced_Business_Analysis.sql (Advanced insights)
│
├── Python/
│   ├── 01_Data_Connection_Cleaning_Validation.ipynb (Data validation)
│   └── 02_Business_Analysis.ipynb (Exploratory analysis)
│
├── PowerBi/
│   ├── 01_OverView.png            (Executive dashboard screenshot)
│   ├── 02_CustomerAnalysis.png    (Customer segmentation dashboard)
│   ├── 03_Transaction&Merchant.png (Transaction & merchant performance)
│   ├── 04_FraudAnalysis.png       (Fraud & risk exposure dashboard)
│   ├── 05_SupportTickets.png      (Support operations dashboard)
│   ├── 06_RootCause.png           (Root cause decomposition dashboard)
│   └── NexaPay DashBoard (Pdf).pdf (Full dashboard PDF export)
│
└── README.md                        (This file)
```

---

## 🎓 Key Analytical Techniques Demonstrated

- SQL Mastery: complex JOINs, CTE pipelines, window functions, cohort analysis, conditional business logic, and performance-aware aggregation.
- Data Quality Rigor: deterministic SQL checks and reproducible Python validation producing audit-ready artifacts.
- Business Intelligence: multi-dimensional analysis, drill-to-root-cause, and financial impact modeling.
- Python Data Analysis: scalable extraction, reproducible notebooks, and visualization-ready outputs for BI consumption.
- Executive Communication: concise dashboards and prioritized recommendations tied to business KPIs.

---

(Removed License & Use and Project Completed lines as requested.)
