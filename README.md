# E-Commerce Customer Analysis — SQL

SQL-based analysis of an e-commerce customer dataset to explore customer behavior, sales performance, payment methods, returns, churn, and customer value.

**Dataset Source:** [Kaggle — E-Commerce Customer Behavior Analysis](https://www.kaggle.com/datasets/shriyashjagtap/e-commerce-customer-for-behavior-analysis)

The dataset used in this project was obtained from **Kaggle**.

The project progresses from **data understanding** to **descriptive analysis** and then to **advanced SQL analysis** using CTEs and Window Functions.

---

# Phase 1: Data Understanding & Data Quality

Before starting the business analysis, I first explored the dataset structure and performed basic data quality checks.

### Dataset Overview

| Metric                      |  Result |
| --------------------------- | ------: |
| Total Rows                  | 250,000 |
| Unique Customers            |  49,661 |
| Product Categories          |       4 |
| Payment Methods             |       3 |
| Missing Values in `Returns` |  47,382 |

### Product Categories

The dataset contains four product categories:

* Books
* Clothing
* Electronics
* Home

### Payment Methods

The dataset contains three payment methods:

* Credit Card
* PayPal
* Cash

### Customer Age

The dataset contains two age columns: `Age` and `Customer Age`.

A validation check confirmed that both columns contain identical values across all records.

| Metric      | Result |
| ----------- | -----: |
| Minimum Age |     18 |
| Maximum Age |     70 |
| Average Age |  43.80 |

### Purchase Amount

| Metric                  |   Result |
| ----------------------- | -------: |
| Minimum Purchase Amount |      100 |
| Maximum Purchase Amount |    5,350 |
| Average Purchase Amount | 2,725.39 |

### Churn Distribution

| Churn Status | Records |
| ------------ | ------: |
| Not Churn    | 199,870 |
| Churn        |  50,130 |

### Key Findings

* The dataset contains **250,000 transactions** from **49,661 unique customers**.
* There are **4 product categories** and **3 payment methods**.
* Missing values were found only in the `Returns` column, with **47,382 missing records**.
* Customer ages range from **18 to 70**, with an average age of **43.80 years**.
* Purchase amounts range from **100 to 5,350**, with an average transaction value of **2,725.39**.
* Approximately **80%** of records are classified as non-churned, while approximately **20%** are classified as churned.
* `Age` and `Customer Age` were validated and found to contain identical values.

---

# Phase 2: Descriptive Analysis

After understanding the dataset, I performed descriptive analysis to answer key business questions related to sales, customers, payment methods, age groups, returns, and churn.

### Sales by Product Category

| Product Category | Total Sales |
| ---------------- | ----------: |
| Home             | 171,138,916 |
| Clothing         | 170,716,122 |
| Electronics      | 170,146,025 |
| Books            | 169,345,236 |

**Insight:**
Home generated the highest total sales. However, sales were relatively balanced across all four product categories.

### Transaction Volume by Product Category

| Product Category | Transactions |
| ---------------- | -----------: |
| Electronics      |       62,630 |
| Clothing         |       62,581 |
| Home             |       62,542 |
| Books            |       62,247 |

**Insight:**
Electronics had the highest number of transactions, while transaction volume was very similar across all categories.

### Payment Method Usage

| Payment Method | Transactions |
| -------------- | -----------: |
| Credit Card    |       83,547 |
| PayPal         |       83,441 |
| Cash           |       83,012 |

**Insight:**
Credit Card was the most frequently used payment method, although the differences between payment methods were small.

### Top Customer by Spending

The highest-spending customer was **Reginald Gonzales**, with total spending of **50,659**.

### Average Customer Spending

The average total spending per customer was approximately **13,719.95** across all transactions.

### Spending by Gender

| Gender | Total Spending |
| ------ | -------------: |
| Male   |    342,786,843 |
| Female |    338,559,456 |

**Insight:**
Male customers generated higher total spending than female customers in this dataset.

### Spending by Age Group

| Age Group | Total Spending |
| --------- | -------------: |
| 56+       |    198,153,447 |
| 46–55     |    128,317,991 |
| 26–35     |    126,847,260 |
| 36–45     |    126,471,620 |
| 18–25     |    101,555,981 |

**Insight:**
The 56+ age group generated the highest total spending, while the 18–25 group generated the lowest. The middle age groups were relatively similar.

### Churn and Returns

| Status               | Records |
| -------------------- | ------: |
| Returned + Churn     |  20,240 |
| No Return + Churn    |  29,890 |
| Returned + No Churn  |  81,236 |
| No Return + No Churn | 118,634 |

**Insight:**
Records with Churn and no Return (29,890) were more common than records with both Return and Churn (20,240).

### Returns by Product Category

| Product Category | Return Count |
| ---------------- | -----------: |
| Electronics      |       25,448 |
| Home             |       25,320 |
| Books            |       25,406 |
| Clothing         |       25,302 |

**Insight:**
Electronics had the highest number of recorded returns, while Clothing had the lowest. The differences were very small.

> **Note:** This analysis measures return count, not return rate.

### Spending by Churn Status

| Churn Status | Average Total Spending |
| ------------ | ---------------------: |
| Churn        |              13,770.31 |
| Not Churn    |              13,707.36 |

**Insight:**
Average total spending was very similar between churned and non-churned customers, with a difference of approximately **63**.

### Key Findings

* **Home** generated the highest total sales, but sales were highly balanced across product categories.
* **Electronics** had the highest transaction volume.
* **Credit Card** was the most frequently used payment method.
* **Reginald Gonzales** was the highest-spending customer.
* The **56+** age group generated the highest total spending.
* Return counts were very similar across product categories.
* Average customer spending was relatively similar between churned and non-churned customers.

---

# Phase 3: Advanced SQL Analysis

This phase focuses on advanced SQL techniques used to perform deeper customer and business analysis.

The analysis includes **CTEs, Window Functions, RANK(), CASE, PARTITION BY, CROSS JOIN, and customer segmentation**.

### 1. Customer Ranking by Total Spending

Customers were ranked from highest to lowest based on their total spending using the `RANK()` Window Function.

### 2. Top 5 Customers by Spending

| Rank | Customer          | Total Spending |
| ---: | ----------------- | -------------: |
|    1 | Reginald Gonzales |         50,659 |
|    2 | Joseph Kaiser     |         50,496 |
|    3 | Katelyn Clark     |         50,179 |
|    4 | Andre Spencer     |         48,499 |
|    5 | Bryan Gonzalez    |         47,015 |

**Insight:**
Reginald Gonzales had the highest total spending at **50,659**.

### 3. Top 3 Customers Within Each Gender

#### Female

| Rank | Customer       | Total Spending |
| ---: | -------------- | -------------: |
|    1 | Andre Spencer  |         48,499 |
|    2 | Patrick Gamble |         46,255 |
|    3 | Jodi Moon      |         46,057 |

#### Male

| Rank | Customer          | Total Spending |
| ---: | ----------------- | -------------: |
|    1 | Reginald Gonzales |         50,659 |
|    2 | Joseph Kaiser     |         50,496 |
|    3 | Katelyn Clark     |         50,179 |

**SQL Technique:**
Used `RANK()` with `PARTITION BY gender` to calculate customer rankings separately within each gender.

### 4. Sales Contribution by Product Category

| Product Category | Total Sales | Contribution |
| ---------------- | ----------: | -----------: |
| Home             | 171,138,916 |       25.12% |
| Clothing         | 170,716,122 |       25.06% |
| Electronics      | 170,146,025 |       24.97% |
| Books            | 169,345,236 |       24.85% |

**Insight:**
Each product category contributes approximately one quarter of total sales, indicating a highly balanced distribution across categories.

### 5. Payment Method Ranking by Total Sales

| Payment Method | Total Sales | Rank |
| -------------- | ----------: | ---: |
| Credit Card    | 228,822,915 |    1 |
| PayPal         | 227,099,530 |    2 |
| Cash           | 225,423,854 |    3 |

**Insight:**
Credit Card generated the highest total sales, followed by PayPal and Cash. However, the differences between the three payment methods were relatively small.

### 6. Customer Value Segmentation

Customers were segmented into three groups based on their total spending:

* **Low Value**
* **Medium Value**
* **High Value**

The segmentation was implemented using a `CASE` statement with spending thresholds derived from `NTILE(3)`.

### 7. Customer Distribution by Value Segment

| Customer Segment | Customers |
| ---------------- | --------: |
| High Value       |    16,555 |
| Low Value        |    16,554 |
| Medium Value     |    16,552 |

**Insight:**
The three segments contain almost the same number of customers because the thresholds were originally derived using `NTILE(3)` to create approximately equal-sized groups.

### 8. Top 20% of Customers by Spending

The dataset contains **49,661 unique customers**.

The top 20% represents approximately **9,932 customers**.

A `RANK()` Window Function was used to identify customers within the top 20% based on total spending.

> **Note:** Because `RANK()` assigns the same rank to tied values, the exact number of returned rows may be slightly different from 9,932 if a tie occurs at the cutoff.

### Key SQL Techniques Used

* **CTEs (`WITH`)** — to structure multi-step analysis.
* **Window Functions** — for customer and payment ranking.
* **`RANK()`** — to rank customers and payment methods.
* **`PARTITION BY`** — to create separate rankings within each gender.
* **`CASE`** — to create customer value segments.
* **`CROSS JOIN`** — to calculate each category's contribution to total sales.

### Key Findings

* The top 5 customers were identified using `RANK()`.
* Customer rankings can be calculated independently within each gender using `PARTITION BY`.
* Product categories contribute almost equally to total sales, with each category representing approximately **25%**.
* Credit Card had the highest total sales among the three payment methods.
* Customers were segmented into **Low, Medium, and High Value** groups based on total spending.
* The three customer segments contain approximately equal numbers of customers.
* The top 20% of customers represents approximately **9,932 customers** out of 49,661.
