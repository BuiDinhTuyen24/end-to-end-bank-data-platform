# 🏦 End to  Bank Data Analytics Project

## 📌 Overview
This project is an end-to-end data analytics pipeline built on the Czech Bank dataset. It covers:

- Data Warehouse (SQL Server)
- Data Analytics (SQL)
- Dashboard (BI)
- Econometric Modeling (R)

The goal is to transform raw banking data into insights and build a model to predict loan default risk.

---

## 🏗️ Project Structure
```│
├── dashboard/ # BI dashboard (Power BI)
├── datasets_sample/ # Sample datasets (for demo / preview)
├── docs/ # Final reports (PDF - econometrics, analysis)
├── scripts/ # SQL scripts + R scripts
├── source/ # Raw source data (original Czech bank dataset)
├── README.md
└── LICENSE
```

---

## 🧱 Data Warehouse

Built using a **layered architecture**:

- **Bronze layer**: raw data
- **Silver Layer**: cleaned data  
- **Gold Layer**: analytical model (star schema)

### ⭐ Gold Schema

**Dimensions**
- dim_client  
- dim_account  
- dim_district  
- dim_card  
- dim_date
- dim_disp

**Facts**
- fact_transaction  
- fact_loan  
- fact_order  

---

## 📊 Data Analytics

SQL is used to generate insights:

- Transaction overview  
- Cash flow (income vs spending)  
- Customer behavior  
- Geographic analysis  
- Time series trends  
- Loan risk segmentation  

---

## 📉 Econometric Model

Logistic Regression in R

### Objective
Predict loan default probability

### Features
- amount  
- duration  
- spending_income_ratio  

### Key Insight
Financial pressure (spending vs income) is the strongest driver of default risk.

---

## 📊 Dashboard

Dashboard provides visual insights:

- KPI overview (transactions, cash flow)
- Customer analysis
- Loan risk distribution
- Time series
- Transaction analysis
- Geographic analysis

---

## 🛠️ Tech Stack

- SQL Server  
- R  
- Power BI  
- LaTeX  
- GitHub  

---

## 📄 Outputs

- Data warehouse (SQL)
- Analytics queries (SQL)
- Dashboard (BI)
- Econometric model (R)
- Final report (PDF)

---

## 🚀 Key Takeaways

- Built full data pipeline (raw → warehouse → insight → model)
- Designed star schema for analytics
- Identified financial behavior as key risk factor
- Applied econometrics to real banking data

## 👤 About Me

Hi! My name is Bui Dinh Tuyen. I'm a student with a strong interest in **Data Analytics, Data Science, and Data Engineering**.  
I enjoy working with data to design efficient data models, build data pipelines, and generate insights through analytical queries.

This repository documents my journey in learning and applying **data warehousing concepts**, including data modeling, ETL processes, and analytical data structures. Through these projects, I aim to strengthen my technical skills and build practical experience in working with real-world data systems.

