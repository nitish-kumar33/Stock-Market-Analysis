# 📈 Stock Market Analysis Dashboard

## 🧭 Project Overview
This project analyzes stock price movements, volatility, and trading volumes for **AAPL, GOOG, MSFT, and NFLX** using **PostgreSQL** and **Power BI**.  
It demonstrates how to convert raw historical data into interactive dashboards to derive insights into **returns, moving averages, and risk–reward metrics**.

---

## 🛠 Tools and Technologies
- **PostgreSQL** – Data cleaning, transformation, and metric creation  
- **Power BI** – Visualization, KPI dashboards, and insights generation  
- **Excel/CSV** – Raw data storage and manual import  

---

## 🧮 Data Preparation (SQL)
- Removed duplicates and handled nulls  
- Replaced missing `Adj_Close` with `Close`  
- Created **analytical view `v_stock_metrics`** calculating:
  - Daily Returns (%)
  - 7-day & 30-day Moving Averages
  - 30-day Volatility (stddev)
  - Cumulative Volume  

---

## 📊 Power BI Dashboard
**Key Visuals:**
- Line Chart: Price Trend  
- Combo Chart: MA7 vs MA30  
- Volume Chart: Trading Volume Spikes  
- Scatter Plot: Risk vs Reward  
- KPI Cards: Total Stocks, Avg Volume, Daily Return  

**Insights:**
- **AAPL** & **MSFT** outperform with stable growth  
- **NFLX**: Volatile but opportunity-rich  
- **GOOG**: Consistent but moderate returns  
- Average Daily Return: **0.07%**

---

## 🔁 Analytical Workflow
1. Raw Data (CSV)  
2. SQL Cleaning & Metrics Calculation  
3. Power BI Data Model  
4. Dashboard Creation & Insights  

---

## 📈 Results
- Trend analysis across 4 tech giants  
- Moving average-based trend detection  
- Risk–reward evaluation for investment strategy  

---

## 🚀 Challenges & Learnings
- Efficient use of SQL window functions  
- Performance tuning and DAX optimization  
- Designing intuitive dashboards  

---

## 🏁 Conclusion
This project highlights **data-driven decision making** through a full data pipeline using SQL and Power BI — a strong portfolio project for roles in **Data Analysis, Financial Analytics, and BI Development**.
