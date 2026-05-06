# 🏦 End to  Bank Data Analytics Project

## 📌 Overview
This project is an end-to-end data analytics pipeline built on the Czech Bank dataset. It covers the full workflow from data warehousing to analytics and econometric modeling.

The objective is to transform raw banking data into actionable insights, with a focus on understanding customer behavior and predicting loan default risk.

---

## 🏗️ Project Structure


---

## 🧱 Data Warehouse

The data warehouse is built using a **multi-layer architecture**:

- **Bronze Layer**: raw data
- **Silver Layer**: cleaned and standardized data  
- **Gold Layer**: analytical data model (star schema)

### ⭐ Gold Layer Schema

- **Dimensions**
  - `dim_client`
  - `dim_account`
  - `dim_district`
  - `dim_card`
  - `dim_date`
  - `dim_disp`

- **Facts**
  - `fact_transaction`
  - `fact_loan`
  - `fact_order`

This structure enables efficient querying and supports downstream analytics and modeling.

---

## 📊 Data Analytics

SQL is used to perform exploratory and business analytics, including:

- Transaction overview (volume, amount, averages)
- Cash flow analysis (income vs spending)
- Customer behavior analysis
- Geographic analysis (by district)
- Time-series trends
- Loan risk segmentation

---

## 📉 Econometric Modeling

A logistic regression model is built in R to estimate the probability of loan default.

### 🎯 Objective
Predict whether a customer will default on a loan.

### 🔑 Key Features
- Loan amount
- Loan duration
- Spending-to-income ratio (engineered feature)

### 📌 Key Insight
Customer **financial pressure**, measured by the spending-to-income ratio, is the strongest predictor of default risk.

---

## 🛠️ Tools & Technologies

- **SQL Server** – Data warehouse & analytics  
- **R** – Econometric modeling  
- **R Markdown / LaTeX** – Reporting  
- **GitHub** – Version control  

---

## 📄 Outputs

- Data warehouse schema (SQL)
- Analytical queries (SQL)
- Econometric model (R)
- Final report (PDF)

---

## 🚀 Key Takeaways

- Built a complete data pipeline from raw data to insights  
- Designed a star schema for analytical efficiency  
- Identified financial behavior as a key driver of credit risk  
- Applied econometric modeling to real-world banking data  

---
