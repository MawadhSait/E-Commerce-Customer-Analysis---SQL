
-- =========================================================
-- Phase 1: Data Understanding & Data Quality
-- =========================================================


-- 1. Dataset Size
-- How many rows are in the dataset?

SELECT COUNT(*)
FROM ecommerce;

-- Result:
-- 250,000 rows


-- ---------------------------------------------------------


-- 2. Unique Customers
-- How many unique customers are in the dataset?

SELECT COUNT(DISTINCT `Customer ID`)
FROM ecommerce;

-- Result:
-- 49,661 unique customers


-- ---------------------------------------------------------


-- 3. Product Categories
-- What product categories are available?

SELECT DISTINCT `Product Category`
FROM ecommerce;

-- Result:
-- Books
-- Clothing
-- Electronics
-- Home

-- Insight:
-- The dataset contains 4 product categories.


-- ---------------------------------------------------------


-- 4. Payment Methods
-- What payment methods are available?

SELECT DISTINCT `Payment Method`
FROM ecommerce;

-- Result:
-- Credit Card
-- PayPal
-- Cash

-- Insight:
-- The dataset contains 3 payment methods.


-- ---------------------------------------------------------


-- 5. Missing Values
-- Checked using Pandas

-- Result:
-- Returns: 47,382 missing values
-- Other columns: 0 missing values

-- Insight:
-- Missing values exist only in the Returns column.


-- ---------------------------------------------------------


-- 6. Customer Purchase Frequency
-- How many transactions does each customer have?

SELECT
    `Customer ID`,
    COUNT(*) AS transaction_count
FROM ecommerce
GROUP BY `Customer ID`;

-- Insight:
-- Customer transaction frequency can be used later to analyze purchasing behavior.


-- ---------------------------------------------------------


-- 7. Age Validation
-- Are Age and Customer Age identical?

SELECT COUNT(*)
FROM ecommerce
WHERE Age != `Customer Age`;

-- Result:
-- 0

-- Insight:
-- Age and Customer Age contain identical values across all records.


-- ---------------------------------------------------------


-- 8. Customer Age Range
-- What is the age distribution?

SELECT
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    AVG(Age) AS avg_age
FROM ecommerce;

-- Result:
-- Minimum Age: 18
-- Maximum Age: 70
-- Average Age: 43.80

-- Insight:
-- Customer ages range from 18 to 70 years,
-- with an average age of approximately 44 years.


-- ---------------------------------------------------------


-- 9. Purchase Amount Range
-- What is the purchase amount distribution?

SELECT
    MIN(`Total Purchase Amount`) AS min_amount,
    MAX(`Total Purchase Amount`) AS max_amount,
    AVG(`Total Purchase Amount`) AS avg_amount
FROM ecommerce;

-- Result:
-- Minimum Purchase Amount: 100
-- Maximum Purchase Amount: 5,350
-- Average Purchase Amount: 2,725.39

-- Insight:
-- Purchase amounts vary between 100 and 5,350,
-- with an average transaction value of 2,725.39.


-- ---------------------------------------------------------


-- 10. Churn Overview
-- How many records belong to each churn status?

SELECT
    Churn,
    COUNT(*) AS churn_count
FROM ecommerce
GROUP BY Churn;

-- Result:
-- Not Churn (0): 199,870
-- Churn (1): 50,130

-- Insight:
-- Approximately 80% of records belong to non-churned customers,
-- while around 20% belong to churned customers.


-- =========================================================
-- Phase 2: Descriptive Analysis
-- =========================================================
-- After understanding the dataset, the analysis focuses
-- on answering business questions.
-- =========================================================


-- 1. Sales by Product Category
-- Which Product Category generated the highest sales?

SELECT
    `Product Category`,
    SUM(`Total Purchase Amount`) AS total_amount
FROM ecommerce
GROUP BY `Product Category`
ORDER BY total_amount DESC;

-- Result:
-- Home:        171,138,916
-- Clothing:    170,716,122
-- Electronics: 170,146,025
-- Books:       169,345,236

-- Insight:
-- Home generated the highest total sales.
-- Sales were relatively similar across all four categories.


-- ---------------------------------------------------------


-- 2. Transaction Volume by Product Category
-- Which Product Category had the highest number of transactions?

SELECT
    `Product Category`,
    COUNT(`Customer ID`) AS transaction_count
FROM ecommerce
GROUP BY `Product Category`
ORDER BY transaction_count DESC;

-- Result:
-- Electronics: 62,630
-- Clothing:    62,581
-- Home:        62,542
-- Books:       62,247

-- Insight:
-- Electronics had the highest number of transactions.
-- Transaction volumes were very similar across all categories.


-- ---------------------------------------------------------


-- 3. Payment Method Usage
-- What is the most commonly used payment method?

SELECT
    `Payment Method`,
    COUNT(`Payment Method`) AS payment_method_count
FROM ecommerce
GROUP BY `Payment Method`
ORDER BY payment_method_count DESC;

-- Result:
-- Credit Card: 83,547
-- PayPal:      83,441
-- Cash:        83,012

-- Insight:
-- Credit Card was the most frequently used payment method.
-- However, usage was relatively similar across all three methods.


-- ---------------------------------------------------------


-- 4. Top 10 Customers by Spending
-- Who are the top 10 customers by total spending?

SELECT
    `Customer ID` AS customer_id,
    `Customer Name`,
    SUM(`Total Purchase Amount`) AS total_amount
FROM ecommerce
GROUP BY `Customer ID`
ORDER BY total_amount DESC
LIMIT 10;

-- Result:
-- Top customer:
-- Customer ID: 39895
-- Customer Name: Reginald Gonzales
-- Total Spending: 50,659

-- Insight:
-- Reginald Gonzales had the highest total spending
-- among all customers, with 50,659.


-- ---------------------------------------------------------


-- 5. Average Customer Spending
-- What is the average total spending per customer?

WITH sum_amount AS (
    SELECT
        `Customer ID`,
        SUM(`Total Purchase Amount`) AS total_amount
    FROM ecommerce
    GROUP BY `Customer ID`
)
SELECT
    AVG(total_amount) AS avg_customer_spending
FROM sum_amount;

-- Result:
-- Average Customer Spending: 13,719.95

-- Insight:
-- The average customer spent approximately 13,719.95
-- across all of their transactions.


-- ---------------------------------------------------------


-- 6. Spending by Gender
-- Do male or female customers generate more total spending?

SELECT
    gender,
    SUM(`Total Purchase Amount`) AS total_amount
FROM ecommerce
GROUP BY gender;

-- Result:
-- Female: 338,559,456
-- Male:   342,786,843

-- Insight:
-- Male customers generated higher total spending than
-- female customers in this dataset.


-- ---------------------------------------------------------


-- 7. Spending by Age Group
-- How does spending vary across age groups?

SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18 - 25'
        WHEN age BETWEEN 26 AND 35 THEN '26 - 35'
        WHEN age BETWEEN 36 AND 45 THEN '36 - 45'
        WHEN age BETWEEN 46 AND 55 THEN '46 - 55'
        ELSE '56+'
    END AS age_range,
    SUM(`Total Purchase Amount`) AS total_amount
FROM ecommerce
GROUP BY age_range
ORDER BY total_amount DESC;

-- Result:
-- 56+:       198,153,447
-- 46 - 55:   128,317,991
-- 26 - 35:   126,847,260
-- 36 - 45:   126,471,620
-- 18 - 25:   101,555,981

-- Insight:
-- The 56+ age group generated the highest total spending,
-- while the 18-25 age group generated the lowest.
-- The 26-35, 36-45, and 46-55 groups were relatively similar.


-- ---------------------------------------------------------


-- 8. Churn and Returns
-- How are Churn and Returns distributed together?

SELECT
    CASE
        WHEN `Returns` = 1 AND Churn = 1
            THEN 'Returned + Churn'
        WHEN `Returns` = 0 AND Churn = 1
            THEN 'No Return + Churn'
        WHEN `Returns` = 1 AND Churn = 0
            THEN 'Returned + No Churn'
        WHEN `Returns` = 0 AND Churn = 0
            THEN 'No Return + No Churn'
        ELSE 'No Churn + No Return'
    END AS status,
    COUNT(`Customer ID`) AS count
FROM ecommerce
GROUP BY status
ORDER BY count;

-- Result:
-- Returned + Churn:       20,240
-- No Return + Churn:      29,890
-- Returned + No Churn:    81,236
-- No Return + No Churn:  118,634

-- Insight:
-- Churn records without a Return (29,890) were more common
-- than records with both Return and Churn (20,240).


-- ---------------------------------------------------------


-- 9. Return Count by Product Category
-- Which Product Category has the highest number of returns?

SELECT
    `Product Category`,
    COUNT(`Returns`) AS return_count
FROM ecommerce
WHERE `Returns` != 0
GROUP BY `Product Category`;

-- Result:
-- Electronics: 25,448
-- Home:        25,320
-- Books:       25,406
-- Clothing:    25,302

-- Insight:
-- Electronics had the highest number of recorded returns,
-- while Clothing had the lowest.
-- The differences between categories were very small.
--
-- Note:
-- This analysis measures the number of returns, not the return rate.
-- A return rate would require comparing returns with total
-- transactions within each category.


-- ---------------------------------------------------------


-- 10. Customer Spending by Churn Status
-- How does average spending differ between churned
-- and non-churned customers?

WITH customer_purchase AS (
    SELECT
        `Customer ID`,
        CASE
            WHEN Churn = 1 THEN 'Churn'
            WHEN Churn = 0 THEN 'Not Churn'
            ELSE 'Not Churn'
        END AS churn_status,
        SUM(`Total Purchase Amount`) AS total_spending
    FROM ecommerce
    GROUP BY `Customer ID`
)
SELECT
    churn_status,
    AVG(total_spending) AS avg_spending
FROM customer_purchase
GROUP BY churn_status
ORDER BY churn_status;

-- Result:
-- Churn:     13,770.31
-- Not Churn: 13,707.36

-- Insight:
-- Average total spending was approximately 13,770 for churned
-- customers compared with 13,707 for non-churned customers.
-- The difference was relatively small.


-- =========================================================
-- Phase 3: Advanced SQL Analysis
-- =========================================================
-- This phase focuses on advanced SQL techniques including
-- Window Functions, CTEs, ranking, segmentation,
-- and contribution analysis.
-- =========================================================


-- 1. Rank Customers by Total Spending
-- Using RANK()

WITH customer_count AS (
    SELECT
        `Customer ID`,
        `Customer Name`,
        SUM(`Total Purchase Amount`) AS total_purchases
    FROM ecommerce
    GROUP BY `Customer ID`
)
SELECT
    `Customer ID`,
    `Customer Name`,
    total_purchases,
    RANK() OVER (
        ORDER BY total_purchases DESC
    ) AS customer_rank
FROM customer_count;

-- Insight:
-- Customers were ranked from highest to lowest
-- according to their total spending.


-- ---------------------------------------------------------
-- 2. Top 5 Customers

WITH customer_count AS (
    SELECT
        `Customer ID`,
        `Customer Name`,
        SUM(`Total Purchase Amount`) AS total_purchases
    FROM ecommerce
    GROUP BY `Customer ID`
),
rank_customer AS (
    SELECT
        `Customer ID`,
        `Customer Name`,
        total_purchases,
        RANK() OVER (
            ORDER BY total_purchases DESC
        ) AS customer_rank
    FROM customer_count
)
SELECT
    `Customer ID`,
    `Customer Name`,
    total_purchases,
    customer_rank
FROM rank_customer
WHERE customer_rank <= 5;

-- Result:
-- Rank 1: Reginald Gonzales - 50,659
-- Rank 2: Joseph Kaiser     - 50,496
-- Rank 3: Katelyn Clark     - 50,179
-- Rank 4: Andre Spencer     - 48,499
-- Rank 5: Bryan Gonzalez    - 47,015

-- Insight:
-- The top customer, Reginald Gonzales, had total spending
-- of 50,659.


-- ---------------------------------------------------------
-- 3. Top 3 Customers Within Each Gender

WITH gender_top AS (
    SELECT
        `Customer ID`,
        `Customer Name`,
        gender,
        SUM(`Total Purchase Amount`) AS total_purchases
    FROM ecommerce
    GROUP BY `Customer ID`
),
rank_customer AS (
    SELECT
        `Customer ID`,
        `Customer Name`,
        total_purchases,
        gender,
        RANK() OVER (
            PARTITION BY gender
            ORDER BY total_purchases DESC
        ) AS customer_rank
    FROM gender_top
)
SELECT
    `Customer ID`,
    `Customer Name`,
    total_purchases,
    gender,
    customer_rank
FROM rank_customer
WHERE customer_rank <= 3;

-- Result:
-- Female:
-- Andre Spencer  - 48,499
-- Patrick Gamble  - 46,255
-- Jodi Moon       - 46,057
--
-- Male:
-- Reginald Gonzales - 50,659
-- Joseph Kaiser     - 50,496
-- Katelyn Clark     - 50,179

-- Insight:
-- RANK() with PARTITION BY gender allows customer rankings
-- to be calculated separately within each gender.


-- ---------------------------------------------------------
-- 4. Sales Contribution by Product Category
-- What percentage of total sales comes from each category?

WITH total_cat_sales AS (
    SELECT
        `Product Category`,
        SUM(`Total Purchase Amount`) AS total_purchases
    FROM ecommerce
    GROUP BY `Product Category`
),
total_cats_sales AS (
    SELECT
        SUM(total_purchases) AS total_purchases_cats
    FROM total_cat_sales
)
SELECT
    tc.`Product Category`,
    tc.total_purchases,
    (tc.total_purchases * 1.0 /
        tcs.total_purchases_cats) * 100 AS sales_percentage
FROM total_cat_sales tc
CROSS JOIN total_cats_sales tcs;

-- Result:
-- Home:        25.12%
-- Clothing:    25.06%
-- Electronics: 24.97%
-- Books:       24.85%

-- Insight:
-- Each product category contributes approximately one quarter
-- of total sales, indicating a highly balanced sales distribution.


-- ---------------------------------------------------------
-- 5. Rank Payment Methods by Total Sales

WITH sales_by_payment AS (
    SELECT
        `Payment Method`,
        SUM(`Total Purchase Amount`) AS total_sales
    FROM ecommerce
    GROUP BY `Payment Method`
)
SELECT
    `Payment Method`,
    total_sales,
    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS payment_rank
FROM sales_by_payment;

-- Result:
-- Credit Card: 228,822,915 - Rank 1
-- PayPal:      227,099,530 - Rank 2
-- Cash:        225,423,854 - Rank 3

-- Insight:
-- Credit Card generated the highest total sales.
-- However, total sales were relatively close across
-- all three payment methods.


-- ---------------------------------------------------------
-- 6. Customer Value Segmentation
-- Divide customers into Low, Medium, and High Value segments.

WITH customer_spending AS (
    SELECT
        `Customer ID`,
        `Customer Name`,
        SUM(`Total Purchase Amount`) AS total_sales
    FROM ecommerce
    GROUP BY `Customer ID`
)
SELECT
    `Customer ID`,
    `Customer Name`,
    total_sales,
    CASE
        WHEN total_sales < 10199 THEN 'Low Value'
        WHEN total_sales BETWEEN 10199 AND 16117 THEN 'Medium Value'
        ELSE 'High Value'
    END AS customer_value
FROM customer_spending;

-- Result:
-- Customers are classified into:
-- Low Value
-- Medium Value
-- High Value

-- Insight:
-- Customers were segmented based on their total spending.


-- ---------------------------------------------------------
-- 7. Number of Customers in Each Value Segment

WITH customer_spending AS (
    SELECT
        `Customer ID`,
        `Customer Name`,
        SUM(`Total Purchase Amount`) AS total_sales
    FROM ecommerce
    GROUP BY `Customer ID`
),
segmented_spending AS (
    SELECT
        `Customer ID`,
        total_sales,
        CASE
            WHEN total_sales < 10199 THEN 'Low Value'
            WHEN total_sales BETWEEN 10199 AND 16117 THEN 'Medium Value'
            ELSE 'High Value'
        END AS customer_value
    FROM customer_spending
)
SELECT
    customer_value,
    COUNT(*) AS customer_count
FROM segmented_spending
GROUP BY customer_value;

-- Result:
-- High Value:   16,555
-- Low Value:    16,554
-- Medium Value: 16,552

-- Insight:
-- The three segments contain almost the same number of customers.
-- This is expected because the thresholds were originally derived
-- using NTILE(3) to divide customers into approximately equal groups.



-- ---------------------------------------------------------
-- 9. Top 20% of Customers by Spending

WITH customer_spending AS (
    SELECT
        `Customer ID`,
        SUM(`Total Purchase Amount`) AS total_sales
    FROM ecommerce
    GROUP BY `Customer ID`
),
rank_customer AS (
    SELECT
        `Customer ID`,
        total_sales,
        RANK() OVER (
            ORDER BY total_sales DESC
        ) AS customer_rank
    FROM customer_spending
)
SELECT
    `Customer ID`,
    total_sales,
    customer_rank
FROM rank_customer
WHERE customer_rank <= 9932;

-- Result:
-- Total unique customers: 49,661
-- Top 20%: approximately 9,932 customers
--
-- Note:
-- Because RANK() assigns the same rank to tied values,
-- the exact number of returned rows can be slightly different
-- from 9,932 if a tie occurs at the cutoff.




-- =========================================================
-- END
-- =========================================================



