# Customer Lifetime Value (CLV) Analytics Project

## 📌 Project Overview
This project involves the end-to-end processing of insurance customer data. It covers database creation, data cleaning, feature engineering using SQL, and the development of an interactive Power BI dashboard to extract actionable business insights.

## 📁 Repository Structure
* **SQL_Scripts/**: Contains queries for data cleaning, handling nulls, and creating views.
* **Dashboard/**: The Power BI (.pbix) file and exported report screenshots.
* **Data/**: (Optional) The raw dataset used for the analysis.

## ⚙️ Data Transformation Process (SQL)
The data underwent several cleaning steps in SQL Server to ensure accuracy:
1.  **Missing Value Imputation:** Replaced NULL values in the `Income` column with the global average.
2.  **Deduplication:** Used Common Table Expressions (CTEs) and `ROW_NUMBER()` to remove duplicate customer records.
3.  **Data Standardization:** Formatted the `Gender` column to proper casing.
4.  **Feature Engineering:** * Created a calculated `Profit` column (`CLV - Total Claim Amount`).
    * Segmented customers into **High**, **Medium**, and **Low** categories based on their Lifetime Value.

## 📊 Dashboard Highlights
The Power BI dashboard provides a bird's-eye view of the company's health:
* **KPI Cards:** Total Profit (69.15M), Total Customers (9K), and Avg CLV (8K).
* **Segmentation:** Breakdown of CLV and Profit by Customer Segment.
* **Policy Analysis:** Comparison of CLV across Special, Personal, and Corporate Auto policies.
* **Top Performers:** A leaderboard of the highest-value customers.

## 🚀 How to Use
1.  Run the scripts in the `SQL_Scripts` folder on your SQL Server instance.
2.  Connect the Power BI file to your SQL database or the provided CSV.
3.  Use the filters on the right side of the dashboard to slice data by **Policy Type**, **Gender**, or **Customer Segment**.

## 🛠 Tools Used
* **SQL Server:** Data cleaning and ETL.
* **Power BI:** Data visualization and DAX.
