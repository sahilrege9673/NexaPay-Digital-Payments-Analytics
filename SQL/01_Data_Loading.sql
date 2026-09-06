CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY,
    customer_tenure_months INTEGER,
    age INTEGER,
    city VARCHAR(100),
    state VARCHAR(100),
    customer_segment VARCHAR(50),
    income_band VARCHAR(20),
    kyc_status VARCHAR(30),
    acquisition_channel VARCHAR(50),
    signup_date DATE,
    risk_band VARCHAR(20)
);

CREATE TABLE accounts (
    account_id BIGINT PRIMARY KEY,
    customer_id BIGINT,
    account_type VARCHAR(50),
    account_status VARCHAR(30),
    opened_date DATE,
    current_balance_inr NUMERIC(18,2),
    credit_limit_inr NUMERIC(18,2)
);

CREATE TABLE merchants (
    merchant_id BIGINT PRIMARY KEY,
    merchant_name VARCHAR(150),
    merchant_category VARCHAR(100),
    merchant_city VARCHAR(100),
    merchant_state VARCHAR(100),
    merchant_tier VARCHAR(50),
    onboarding_date DATE,
    risk_rating VARCHAR(30),
    settlement_cycle VARCHAR(20)
);



CREATE TABLE transactions (
    transaction_id BIGINT PRIMARY KEY,
    transaction_timestamp TIMESTAMP,
    customer_id BIGINT,
    account_id BIGINT,
    merchant_id BIGINT,
    transaction_type VARCHAR(50),
    channel VARCHAR(50),
    payment_method VARCHAR(50),
    amount_inr NUMERIC(18,2),
    transaction_status VARCHAR(30),
    fraud_score NUMERIC(5,2),
    fraud_flag SMALLINT,
    fee_inr NUMERIC(18,2),
    currency CHAR(3),
    device_type VARCHAR(30),
    customer_initiated SMALLINT
);

CREATE TABLE chargebacks (
    chargeback_id BIGINT PRIMARY KEY,
    transaction_id BIGINT,
    chargeback_date TIMESTAMP,
    reason_code VARCHAR(100),
    chargeback_amount_inr NUMERIC(18,2),
    chargeback_status VARCHAR(30),
    recovery_amount_inr NUMERIC(18,2),
    merchant_response_days INTEGER
);



CREATE TABLE support_tickets (
    ticket_id BIGINT PRIMARY KEY,
    customer_id BIGINT,
    created_at TIMESTAMP,
    issue_category VARCHAR(100),
    priority VARCHAR(30),
    channel VARCHAR(30),
    ticket_status VARCHAR(50),
    resolution_hours NUMERIC(10,2),
    customer_satisfaction NUMERIC(3,1),
    agent_team VARCHAR(50)
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;


COPY customers
FROM 'D:/Projects/EndToEnd/NexaPay_End_to_End_Fintech_Dataset/customers.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"'
);

SELECT COUNT(*) AS customers_loaded
FROM customers;


COPY accounts
FROM 'D:/Projects/EndToEnd/NexaPay_End_to_End_Fintech_Dataset/accounts.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"'
);


SELECT COUNT(*) 
FROM accounts;


COPY merchants
FROM 'D:/Projects/EndToEnd/NexaPay_End_to_End_Fintech_Dataset/merchants.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"'
);

SELECT COUNT(*) 
FROM merchants;

COPY transactions
FROM 'D:/Projects/EndToEnd/NexaPay_End_to_End_Fintech_Dataset/transactions.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"'
);

SELECT COUNT(*) 
FROM transactions;

COPY chargebacks
FROM 'D:/Projects/EndToEnd/NexaPay_End_to_End_Fintech_Dataset/chargebacks.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"'
);

COPY support_tickets
FROM 'D:/Projects/EndToEnd/NexaPay_End_to_End_Fintech_Dataset/support_tickets.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"'
);
