
-- Business Analysis

-- NexPay Performance Overall

select count(*) as TotalTransactions,
sum(amount_inr) as TotalTransactionsValue,
avg(amount_inr) as AvgTransactionsValue,
sum(
	case
		when transaction_status ='Success'
		then 1 
		else 0
		End
) as SuccessFulTransactions,
Sum(
	case 
		when transaction_status='Failed'
		then 1
		else 0
		end 
) as FailedTransactions
from transactions;


--What % of Transactions Are Failed and Success

SELECT
    transaction_status,
    COUNT(*) AS transactions,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY transaction_status
ORDER BY transactions DESC;


--Which Transactions Channel Performs The Best

update 
select channel,
	count(*) as Transactions,
	sum(amount_inr) as Amt
from transactions
group by channel
order by Amt DESC;

--Which Channel has Highest Transaction Failure Rate

SELECT channel,
    COUNT(*) AS total_transactions,
    SUM(
        CASE
            WHEN transaction_status = 'Failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_transactions,
    ROUND(
        SUM(
            CASE
                WHEN transaction_status = 'Failed'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS failure_rate

from Transactions
GROUP BY channel
ORDER BY failure_rate DESC;

--Payment Method with Highest Failure Rate

select payment_method,
	Count(*) as Total_Transactions,
	Sum(
		Case 
			when transaction_status='Failed'
			then 1
			else 0
		end 
	) as Failed_Transactions,
   	Round(
	   Sum(
		Case 
			when transaction_status='Failed'
			then 1
			else 0
		end 
	)*100.0/Count(*),
	2) as Failure_Rate
from transactions
group by Payment_method
order by Failure_Rate DESC;

--Payment Method With Most Transaction Value

select payment_method,
	sum(Amount_inr) as Transaction_Value,
	Round(Avg(amount_inr),2) as Avg_TransactionValue
from transactions
group by payment_method
order by Transaction_Value;

--Customer Segment with Most Transactions Value

Select c.customer_segment,count(*) as Transactions,
		sum(t.amount_inr) as TransactionValue,round(avg(t.amount_inr),2)as AvgTransActionsValue
from customers as c
join transactions as t
on c.customer_id = t.customer_id
group by c.customer_segment
order by TransactionValue;

--Customer Segment with Failure Rate

SELECT c.customer_segment,
    Count(*) AS transactions,
    Sum(
        CASE
            When t.transaction_status = 'Failed'
            Then 1
            Else 0
        End
    ) as failed_transactions,
    ROUND(
        SUM(
            CASE
                WHEN t.transaction_status = 'Failed'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS failure_rate

from transactions as t
JOIN customers as c
ON t.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY failure_rate DESC;

--Customer Risk Bands having Higher Fraud Rate

select c.risk_band,
		Count(*) as Transactions,
		Sum(t.fraud_flag) as FraudTransactions,
		round(
			sum(t.fraud_flag)*100.0 /count(*),2
		) as FraudRate
from customers as c
join transactions as t
on c.customer_id=t.customer_id
group by c.risk_band
order by FraudRate DESC;

--Which Merchant Generates Higher Transactions Value

select m.merchant_id,
		m.merchant_name,
		m.merchant_category,
count(t.transaction_id) as Transactions,
sum(t.amount_inr) as TransactionValue
from merchants as m
join transactions as t
on t.merchant_id=m.merchant_id
group by m.merchant_id,
		m.merchant_name,
		m.merchant_category;

--Is NEXAPAY GROWTH HEALTHY

Select
    Date_trunc('month',transaction_timestamp)::date AS month,
    Count(*) AS transactions,
    Sum(amount_inr) AS transaction_value

from transactions

Group by month
Order by month;

--Percentage of Nexpay Customers Are Active

select 
	count(distinct t.customer_id) as active_customers,
	count(distinct c.customer_id) as TotalCustomers,
	Round(	
		count(distinct t.customer_id)*100.0/
		count(distinct c.customer_id),2
		)
from customers as c
left join transactions as t
on c.customer_id=t.transaction_id;

--Are high-value customers also exposed to higher risk

Select
    c.risk_band,
    Count(DISTINCT c.customer_id) AS customers,
    Sum(t.amount_inr) AS transaction_value,
    Sum(t.fraud_flag) AS fraud_transactions
from customers as c
JOIN transactions as  t
ON c.customer_id = t.customer_id
Group by c.risk_band
Order by transaction_value DESC;



-- transaction types with the highest failure rate

select 
	transaction_type,
	count(*) as Transactions,
	sum(	
		Case
			when transaction_status='Failed'
			then 1
			else 0
			end
		) as FailedTransactions,
	Round(
			sum(
				Case
					when transaction_status='Failed'
					then 1
					else 0
				end
			) *100/count(*),2

	) as FailureRate
from transactions 
group by transaction_type
order by FailureRate DESC;

--Are the HIGH VALUE Transactions More likely to Fail

Select
    Case
        When amount_inr < 1000 THEN 'Below 1K'
        When amount_inr < 10000 THEN '1K - 10K'
        When amount_inr < 50000 THEN '10K - 50K'
        When amount_inr < 100000 THEN '50K - 100K'
        Else '100K+'
    End as  transaction_band,

    Count(*) as transactions,

    Sum(
        Case
            When transaction_status = 'Failed'
            Then 1
            Else 0
        End
		) as failed_transactions,

    Round(
        Sum(
            Case
                When transaction_status = 'Failed'
                Then 1
                Else 0
            End
        ) * 100.0 / Count(*),
        2
    ) AS failure_rate

FROM transactions
GROUP BY transaction_band
Order By failure_rate DESC;

--Which channel + payment method combination performs poorly

Select channel,payment_method,
    Count(*) as transactions,
    Sum(
        Case
            When transaction_status = 'Failed'
            Then 1
            Else 0
        End
    ) as failed_transactions,
    Round(
        Sum(
            Case
                When transaction_status = 'Failed'
                Then 1
                Else 0
            End
        ) * 100.0 / Count(*),
        2
    ) as failure_rate

From transactions
Group By
    channel,
    payment_method
Order By failure_rate DESC;

--Which account types are actually being used

select a.account_type,
		count(distinct a.account_id) as Accounts,
		count(t.transaction_id) as Transactions,
		sum(t.amount_inr) as TotalTransactionValue
from accounts as a
left join transactions as t
on a.account_id=t.account_id
group by a.account_type;

--Which account types have the highest utilization

select a.account_type,
	count(Distinct a.account_id) as Accounts,
	COUnt(t.transaction_id) as Transactions,
	round(
			count(t.transaction_id)*1.0/
			count(Distinct a.account_id),2
	) as Transaction_Per_Account

from accounts as a
left join transactions as t
on a.account_id=t.account_id

group by a.account_type
order by Transaction_Per_Account DESC;

--How Many Accounts Are INACTIVE

Select account_status,count(*) as NumberOfAccounts
from accounts
group by account_status
order by  NumberOfAccounts DESC;

-- Which account types have the highest dormant rate

Select
	account_type,
	count(*) as total_accounts,
	sum(
		Case
			when account_status='Dormant'
			then 1
			else 0
			End
	) as Dormant_accounts,
	Round(
		Sum(
			Case 
				When account_status='Dormant'
				Then 1
				Else 0
				End
		)*100.0/count(*),2)
		as DormantRate
From accounts
group by account_type
order by DormantRate DESC;
	
--Are Close d Dormant still Generating Transactions

Select
    a.account_status,
    COUNT(t.transaction_id) as transactions,
    SUM(t.amount_inr) as transaction_value
From accounts  as a
JOIN transactions as t
On a.account_id = t.account_id
Where a.account_status IN ('Closed', 'Dormant', 'Frozen')
Group by a.account_status;

--Merchant Categories with Transaction Failure

select m.merchant_category,
		count(*) as Transactions,
		sum(
			Case
				when t.transaction_status='Failed'
				then 1
				else 0
				End
			) as Failed_transactions,
Round(
		sum(
			Case
				when t.transaction_status='Failed'
				then 1
				else 0
				End
			)*100.0/count(*),2
) as FailureRate
				
from transactions as t
join merchants as m
on t.merchant_id=m.merchant_id
group by m.merchant_category
order by FailureRate DESC;

--Merchants Which are strategically important because they have both high volume and high transaction value

SELECT m.merchant_id,m.merchant_name,
    Count(t.transaction_id) as transactions,
    Sum(t.amount_inr) as transaction_value

From merchants as m
Join transactions t
On m.merchant_id = t.merchant_id

Group by
    m.merchant_id,
    m.merchant_name

Order by transactions DESC, transaction_value DESC
LIMIT 20;

--Does high-risk merchants have higher transaction failure rates

select
	m.risk_rating,
	count(*) as Transactions,
	sum(
		Case
			when t.transaction_status='Failed'
			then 1
			else 0
			end 
	) as Failed_Transaction,
Round(
	Sum(
		Case
			When t.transaction_status='Failed'
			then 1
			else 0
			end 
	) *100.0/count(*),2
) as FailureRate

from Transactions as t
join merchants as m
on t.merchant_id=m.merchant_id

group by m.risk_rating
order by failurerate DESC;


--Which are the Merchant Tiers Imp to NEXPAY

select m.merchant_tier,
		count(*) as Transaction,
		sum(t.amount_inr) as TransactionValue,
		round(avg(t.amount_inr),2) as AvgTransactionValue
from merchants as m
join transactions as t
on m.merchant_id=t.merchant_id
group by m.merchant_tier;


--Merchants With Greatest ChargeBacks Exposure

Select
    m.merchant_category,

    Count(cb.chargeback_id) as chargebacks,

    Sum(cb.chargeback_amount_inr) as chargeback_value

From merchants as m

JOIN transactions as t
on m.merchant_id = t.merchant_id

join chargebacks as cb
on t.transaction_id = cb.transaction_id

group by m.merchant_category
order by chargeback_value DESC;
