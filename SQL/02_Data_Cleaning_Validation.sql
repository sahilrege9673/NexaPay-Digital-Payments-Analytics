--DATA VALIDATION & DATA CLEANING

select * from customers;
select * from accounts;
select * from merchants;
select *from transactions;
select*from chargebacks;
select * from support_tickets;

-- Is the data complete at the table level

SELECT 'customers' AS table_name,
       COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'accounts',
       COUNT(*)
FROM accounts

UNION ALL

SELECT 'merchants',
       COUNT(*)
FROM merchants

UNION ALL

SELECT 'transactions',
       COUNT(*)
FROM transactions

UNION ALL

SELECT 'chargebacks',
       COUNT(*)
FROM chargebacks

UNION ALL

SELECT 'support_tickets',
       COUNT(*)
FROM support_tickets

ORDER BY table_name;

--MODIFY THE TRANSACTION TABLE

CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE analytics.transactions_clean AS
SELECT
    t.transaction_id,
    t.transaction_timestamp,

    -- Account ownership is treated as authoritative
    a.customer_id AS customer_id,

    t.account_id,
    t.merchant_id,
    t.transaction_type,
    t.channel,
    t.payment_method,
    t.amount_inr,
    t.transaction_status,
    t.fraud_score,
    t.fraud_flag,
    t.fee_inr,
    t.currency,
    t.device_type,
    t.customer_initiated,

    CASE
        WHEN t.customer_id = a.customer_id
            THEN 'VALID'
        ELSE 'CUSTOMER_ACCOUNT_MISMATCH'
    END AS customer_account_quality

FROM transactions t
JOIN accounts a
    ON t.account_id = a.account_id;

--DUPLICATES [ARE ALL ID'S UNIQUE]

SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


SELECT account_id, COUNT(*)
FROM accounts
GROUP BY account_id
HAVING COUNT(*) > 1;

SELECT merchant_id, COUNT(*)
FROM merchants
GROUP BY merchant_id
HAVING COUNT(*) > 1;

SELECT transaction_id, COUNT(*)
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

select chargeback_id ,count(*)
from chargebacks
group by chargeback_id
having count(*)>1;

SELECT ticket_id, COUNT(*)
FROM support_tickets
GROUP BY ticket_id
HAVING COUNT(*) > 1;

--NULL VALUES
--customer fields

SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE age IS NULL) AS age_nulls,
    COUNT(*) FILTER (WHERE city IS NULL) AS city_nulls,
    COUNT(*) FILTER (WHERE state IS NULL) AS state_nulls,
    COUNT(*) FILTER (WHERE customer_segment IS NULL) AS segment_nulls,
    COUNT(*) FILTER (WHERE income_band IS NULL) AS income_nulls,
    COUNT(*) FILTER (WHERE kyc_status IS NULL) AS kyc_nulls,
    COUNT(*) FILTER (WHERE acquisition_channel IS NULL) AS acquisition_nulls,
    COUNT(*) FILTER (WHERE signup_date IS NULL) AS signup_nulls,
    COUNT(*) FILTER (WHERE risk_band IS NULL) AS risk_nulls
FROM customers;

-- transaction fields

SELECT
    COUNT(*) FILTER (WHERE transaction_id IS NULL) AS transaction_id_nulls,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE account_id IS NULL) AS account_id_nulls,
    COUNT(*) FILTER (WHERE merchant_id IS NULL) AS merchant_id_nulls,
    COUNT(*) FILTER (WHERE amount_inr IS NULL) AS amount_nulls,
    COUNT(*) FILTER (WHERE transaction_status IS NULL) AS status_nulls,
    COUNT(*) FILTER (WHERE transaction_timestamp IS NULL) AS timestamp_nulls
FROM transactions;

-- chargebacks
SELECT
    COUNT(*) FILTER (WHERE transaction_id IS NULL) AS transaction_nulls,
    COUNT(*) FILTER (WHERE chargeback_date IS NULL) AS date_nulls,
    COUNT(*) FILTER (WHERE chargeback_amount_inr IS NULL) AS amount_nulls,
    COUNT(*) FILTER (WHERE recovery_amount_inr IS NULL) AS recovery_nulls
FROM chargebacks;

--INVALID ANALYSIS

--AGE
select count(*) as invalid_age_records
from customers
where age<18 or age>100;

--CustomerTenure
SELECT COUNT(*) AS invalid_tenure
FROM customers
WHERE customer_tenure_months < 0;

-- Transaction amounts
SELECT COUNT(*) AS invalid_amounts
FROM transactions
WHERE amount_inr <= 0;

--FEES
SELECT COUNT(*) AS invalid_fees
FROM transactions
WHERE fee_inr < 0;

--FraudScores
SELECT COUNT(*) AS invalid_fraud_scores
FROM transactions
WHERE fraud_score < 0
   OR fraud_score > 100;

-- payment methods
SELECT
    payment_method,
    COUNT(*) AS records
FROM transactions
GROUP BY payment_method
ORDER BY payment_method;

-- transaction statuses
select DISTINCT transaction_status
from transactions
group by transaction_status
order by transaction_status;

--CustomerSegement
SELECT DISTINCT customer_segment
FROM customers
ORDER BY customer_segment;

--KYCStatus
SELECT DISTINCT kyc_status
FROM customers
ORDER BY kyc_status;


-- all accounts linked to valid customers
SELECT COUNT(*) AS orphan_accounts
FROM accounts a
LEFT JOIN customers c
    ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- transaction customer equal account owner
SELECT COUNT(*) AS mismatches
FROM transactions t
JOIN accounts a
    ON t.account_id = a.account_id
WHERE t.customer_id <> a.customer_id;

--Multiple customers to single account
SELECT
    account_id,
    COUNT(DISTINCT customer_id) AS customer_count
FROM accounts
GROUP BY account_id
HAVING COUNT(DISTINCT customer_id) > 1;

-- How many transactions are flagged as fraud

SELECT
    fraud_flag,
    COUNT(*) AS transaction_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM transactions
GROUP BY fraud_flag
ORDER BY fraud_flag;


-- Transaction channels standardized

select channel,count(*)
from transactions
group by channel;

-- fraud rate by transaction status

SELECT
    transaction_status,
    COUNT(*) AS transactions,
    SUM(fraud_flag) AS fraud_transactions,
    ROUND(
        SUM(fraud_flag) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate_pct
FROM transactions
GROUP BY transaction_status
ORDER BY fraud_rate_pct DESC;

-- fraud rate by payment method

select payment_method,count(*) as Transactions,sum(fraud_flag) as Fraudtransactions,
round(sum(fraud_flag)*100.0/count(*),2) as Fraud_per
from transactions
group by payment_method
order by Fraud_per DESC;
