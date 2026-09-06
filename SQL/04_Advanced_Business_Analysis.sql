
--Merchant & Settlement Performance

--Which merchant settlement cycles handle the most transaction value

select m.settlement_cycle,
		count(t.transaction_id) as transactions,
		sum(t.amount_inr) as transaction_value
from merchants as m
join transactions as t
on m.merchant_id=t.merchant_id
group by m.settlement_cycle
order by transaction_value DESC;


--Which Merchant tiers have the Highest Average Transaction Values

Select
    m.merchant_tier,
    Count(t.transaction_id) as transactions,
   round(Avg(t.amount_inr),2)as average_transaction_value,
    Sum(t.amount_inr) as transaction_value
from merchants  as m
JOIN transactions  as t
ON m.merchant_id = t.merchant_id
group by m.merchant_tier
order by average_transaction_value DESC;


--merchant categories have the weakest successful transaction rate

select 
	m.merchant_category,
	count(*) as Transactions,
	sum(
		Case
			when t.transaction_status='Success'
			then 1
			else 0
		end 
	) as SuccessFull_Transactions,
	round(
		sum(
			Case 
				when t.transaction_status='Success'
				then 1
				else 0
			end
		) *100.0/count(*),2) as success_rate

from merchants as m
join transactions as t
on m.merchant_id=t.merchant_id
Group by m.merchant_category
order by success_rate DESC;

--NexaPay Overall ChargeBack Rate

select 
	count(Distinct cb.chargeback_id) as chargebacks,
	count(Distinct t.transaction_id) as transactions,
	round(
		count(Distinct cb.chargeback_id)*100.0/
		count(Distinct t.transaction_id),2
	) as chargeback_rate
from transactions as t
left join chargebacks as cb
on t.transaction_id=cb.transaction_id;

--How much money is tied up in chargebacks

Select
    Sum(chargeback_amount_inr) as total_chargeback_value,
    Sum(recovery_amount_inr) as recovered_value,

    Sum(
        chargeback_amount_inr - recovery_amount_inr
    ) as unrecovered_value

from chargebacks;
	

--NexaPay ChargeBack Recovery Rate

Select
    Sum(recovery_amount_inr) as recovered_amount,
    Sum(chargeback_amount_inr) as chargeback_amount,
    Round(
        Sum(recovery_amount_inr) * 100.0 /
        Sum(chargeback_amount_inr),
        2
    ) as recovery_rate

from chargebacks;

--Which chargeback reasons create the greatest financial loss

select 
	reason_code,
	count(*) as chargebacks,
	Sum(chargeback_amount_inr) as chargeback_value,
	Sum(recovery_amount_inr) as recovered_value,
	sum(
		chargeback_amount_inr-recovery_amount_inr
	) as unrecovered_value
from chargebacks 
group by reason_code
order by unrecovered_value DESC;

--Merchant Category having the most highest unrecovered chargeback value

select 
m.merchant_category,
Sum(cb.chargeback_amount_inr) as chargeback_value,
	Sum(cb.recovery_amount_inr) as recovered_value,
	sum(
		cb.chargeback_amount_inr-cb.recovery_amount_inr
	) as unrecovered_value
from chargebacks as cb
join transactions as t
on t.transaction_id=cb.transaction_id
join merchants as m
on m.merchant_id=t.merchant_id
group by m.merchant_category
order by unrecovered_value DESC;

--Which Support Issue Generates Most Tickets

select issue_category,
		count(*) as tickets
from support_tickets 
group by issue_category
order by tickets DESC;

--Which suppot tickets take longest to Resolve 

select issue_category,
		count(*) as tickets,
		round(
			Avg(resolution_hours),2
		) as Avg_ResolutionHours
from support_tickets
group by issue_category
order by Avg_ResolutionHours DESC;

--Issue Category with lowest customer Satisfaction

select 
	issue_category,
	count(*) as tickets,
	round(
		Avg(customer_satisfaction),2
	) as average_satisfaction
from support_tickets 
where customer_satisfaction Is NOT NULL
group by issue_category
order by average_satisfaction DESC;

-- Does higher resolution time correspond with lower customer satisfaction

select 
    Case
        When resolution_hours < 4 Then 'Under 4 Hours'
        When resolution_hours < 24 Then '4-24 Hours'
        When resolution_hours < 72 Then '1-3 Days'
        Else '3+ Days'
    End as resolution_group,

    Count(*) as tickets,

    Round(
        Avg(customer_satisfaction),
        2
    ) as average_satisfaction

From support_tickets

Where customer_satisfaction is Not NULL
Group by resolution_group
Order by average_satisfaction;

--customers with more failed transactions generate more support tickets

select 
	t.customer_id,
	count(s.ticket_id) as supportTickets,
	sum(
		Case
			when t.transaction_status='Failed'
			then 1
			else 0
		End	
	) as FailedTransactions

from transactions as t
left join support_tickets as s
on s.customer_id=t.customer_id
group by t.customer_id
order by FailedTransactions DESC;

-- Customers Contacting Support AFTER The Transaction Failures

Select
    Case
        When t.failed_transactions > 0
        Then 'Had Failed Transaction'
        Else 'No Failed Transaction'
    End as customer_group,

    Count(*) as customers
From(
    Select
        customer_id,
        Sum(
            Case
                When transaction_status = 'Failed'
                Then 1 else 0
            End
        ) as failed_transactions
    From transactions
    Group by customer_id
) t
join support_tickets s
on t.customer_id = s.customer_id
group by customer_group
order by customers DESC;

--Do merchants with high transaction value also have high chargeback exposure

Select
    m.merchant_id,
    m.merchant_name,

    Sum(t.amount_inr) AS transaction_value,

    Count(cb.chargeback_id) AS chargebacks,

    Sum(cb.chargeback_amount_inr) AS chargeback_value

from merchants as  m

join transactions as t
on m.merchant_id = t.merchant_id
left join chargebacks as cb
on t.transaction_id = cb.transaction_id
group by
    m.merchant_id,
    m.merchant_name
order by chargeback_value DESC;
--NO

--Are high-risk merchants responsible for a disproportionate share of chargebacks

Select
    m.risk_rating,

    count(cb.chargeback_id) as chargebacks,

    sum(cb.chargeback_amount_inr) as chargeback_value

FROM merchants as m

join transactions as t
on m.merchant_id = t.merchant_id

join chargebacks as cb
on t.transaction_id = cb.transaction_id
group by m.risk_rating
order by chargeback_value DESC;

--Yes
