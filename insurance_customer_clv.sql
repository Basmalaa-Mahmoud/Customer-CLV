CREATE DATABASE customer_clv


SELECT * INTO customer_clv_backup FROM customer_clv;

DROP TABLE customer_clv;




ALTER VIEW CLV_Cleaned AS
SELECT *,
    ([Customer_Lifetime_Value] - [Total_Claim_Amount]) AS Profit,
    CASE 
        WHEN [Customer_Lifetime_Value] < 5000 THEN 'Low'
        WHEN [Customer_Lifetime_Value] BETWEEN 5000 AND 25000 THEN 'Medium'
        ELSE 'High'
    END AS Profit_Segment
FROM customer_clv;


SELECT TOP 10 Customer, [Customer_Lifetime_Value] FROM CLV_Cleaned ORDER BY [Customer_Lifetime_Value] DESC;

SELECT [Policy_Type], AVG([Customer_Lifetime_Value]) AS Avg_CLV FROM CLV_Cleaned GROUP BY [Policy_Type];

SELECT Profit_Segment, SUM(Profit) AS Total_Profit FROM CLV_Cleaned GROUP BY Profit_Segment;



ALTER VIEW Customer_Segments AS
SELECT
    Customer,
    Income,
    [Monthly_Premium_Auto],
    CASE 
        WHEN Income = 0 OR Income IS NULL THEN 'Zero Income'
        WHEN Income > 0 AND Income <= 30000 THEN 'Low Income'
        WHEN Income > 30000 AND Income <= 70000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS Income_Group,

    CASE   
        WHEN [Monthly_Premium_Auto] < 100 THEN 'Cheap'  
        WHEN [Monthly_Premium_Auto] between 100 and 200 THEN 'Normal'  
        ELSE 'Expensive'  
    END AS Premium_Group,

    CASE 
        WHEN [Total_Claim_Amount] = 0 THEN 'No Claims'
        WHEN [Total_Claim_Amount] < 400 THEN 'Low Severity'
        WHEN [Total_Claim_Amount] BETWEEN 400 AND 800 THEN 'Medium Severity'
        ELSE 'High Severity'
    END AS Claim_Severity
FROM customer_clv;



ALTER VIEW Customer_RFM AS
WITH RFM AS (  
    SELECT 
        Customer,
        [Months_Since_Last_Claim],
        [Number_of_Policies],
        [Customer_Lifetime_Value],

        NTILE(5) OVER (ORDER BY [Months_Since_Last_Claim] DESC) AS R_score,  
        NTILE(5) OVER (ORDER BY [Number_of_Policies]) AS F_score,  
        NTILE(5) OVER (ORDER BY [Customer_Lifetime_Value]) AS M_score  
    FROM customer_clv)

SELECT 
    Customer,
    R_score,
    F_score,
    M_score,
    (R_score + F_score + M_score) as RFM_Total,

    CASE   
        WHEN (R_score + F_score + M_score) >= 12 then 'Champions'  
        WHEN (R_score + F_score + M_score) >= 9 then 'Loyal'  
        WHEN (R_score + F_score + M_score) >= 6 then 'Potential'  
        ELSE 'At Risk'  
    END AS RFM_Segment
FROM RFM;





ALTER VIEW CLV_Outliers AS
SELECT 
    Customer,
    [Customer_Lifetime_Value],
    CASE 
        WHEN [Customer_Lifetime_Value] > (SELECT AVG([Customer_Lifetime_Value]) + 2 * STDEV([Customer_Lifetime_Value]) FROM customer_clv) 
        THEN 'Outlier' 
        ELSE 'Normal' 
    END AS Customer_Status
FROM customer_clv;