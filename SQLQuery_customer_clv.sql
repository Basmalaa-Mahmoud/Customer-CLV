create database customer_clv


select * from customer_clv 
where Customer is null or Income is null or [Customer_Lifetime_Value] is null

update customer_clv
set Income = (select avg(Income) from customer_clv where Income is not null)
where Income IS NULL;

with CTE AS (
    select Customer, 
           ROW_NUMBER() OVER (PARTITION BY Customer ORDER BY Customer) AS RowNum
    FROM customer_clv)
DELETE FROM CTE WHERE RowNum > 1

UPDATE customer_clv
SET Gender = UPPER(LEFT(Gender, 1)) + LOWER(SUBSTRING(Gender, 2, LEN(Gender)));





create view vw_CLV_Cleaned AS
select *,
    ([Customer_Lifetime_Value] - [Total_Claim_Amount]) AS Profit,
    case 
        when [Customer_Lifetime_Value] > 15000 then 'High'
        when [Customer_Lifetime_Value] BETWEEN 5000 AND 15000 then 'Medium'
        else 'Low'
    end AS Customer_Segment
from customer_clv;


select top 10 Customer, [Customer_Lifetime_Value] from vw_CLV_Cleaned order by [Customer_Lifetime_Value] DESC;


select [Policy_Type], avg([Customer_Lifetime_Value]) as Avg_CLV from vw_CLV_Cleaned group by [Policy_Type];


select Customer_Segment, sum(Profit) as Total_Profit from vw_CLV_Cleaned group by Customer_Segment;

