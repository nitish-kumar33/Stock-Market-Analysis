---Create table
create table stock_market_analysis
(
Ticker varchar (20),
Date DATE,
Open decimal (10,2),
High decimal (10,2),
Low decimal (10,2),
Close decimal (10,2),
Adj_Close decimal (10,2),
Volume int
);

---show all table

select * from stock_market_analysis;

--- imported manual (done)

----Verify & Explore Raw Data

-- Check total rows
SELECT COUNT(*) FROM stock_market_analysis;

-- Check number of tickers
SELECT DISTINCT ticker FROM stock_market_analysis;

-- Check date range per ticker
SELECT ticker, MIN(date) AS start_date, MAX(date) AS end_date, COUNT(*) AS days
FROM stock_market_analysis
GROUP BY ticker
ORDER BY ticker;

-- Null checks
SELECT
  SUM(CASE WHEN open IS NULL THEN 1 ELSE 0 END) AS null_open,
  SUM(CASE WHEN close IS NULL THEN 1 ELSE 0 END) AS null_close,
  SUM(CASE WHEN volume IS NULL THEN 1 ELSE 0 END) AS null_volume
FROM stock_market_analysis;

---- Data Cleaning and standardization (sql)

-- 1️⃣ Remove duplicate records (same Ticker + Date)
DELETE FROM stock_market_analysis a
USING stock_market_analysis b
WHERE a.ctid < b.ctid
  AND a.ticker = b.ticker
  AND a.date = b.date;

-- 2️⃣ Replace null Adj_Close with Close
UPDATE stock_market_analysis
SET adj_close = close
WHERE adj_close IS NULL;

-- 3️⃣ Set negative or zero volumes to NULL
UPDATE stock_market_analysis
SET volume = NULL
WHERE volume <= 0;

-- 4️⃣ Verify cleanup
SELECT COUNT(*) FROM stock_market_analysis WHERE volume IS NULL;

----Create Analytical View with Metrics
----We now calculate Daily Returns, 7-day & 30-day Moving Averages, Volatility, and Cumulative Volume.

CREATE OR REPLACE VIEW v_stock_metrics AS
WITH base AS (
    SELECT
        ticker,
        date,
        open,
        high,
        low,
        close,
        adj_close,
        volume,
        -- Daily return
        (close / LAG(close) OVER (PARTITION BY ticker ORDER BY date) - 1) * 100 AS daily_return_pct
    FROM stock_market_analysis
)
SELECT
    ticker,
    date,
    open,
    high,
    low,
    close,
    adj_close,
    volume,
    ROUND(daily_return_pct, 4) AS daily_return_pct,
    -- 7-day moving average
    ROUND(AVG(close) OVER (PARTITION BY ticker ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS ma_7,
    -- 30-day moving average
    ROUND(AVG(close) OVER (PARTITION BY ticker ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS ma_30,
    -- 30-day volatility (stddev of daily returns)
    ROUND(
        STDDEV_POP(daily_return_pct)
        OVER (PARTITION BY ticker ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW),
        4
    ) AS vol_30,
    -- Cumulative trading volume
    SUM(volume) OVER (PARTITION BY ticker ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_volume
FROM base
ORDER BY ticker, date;

---Validate the View

SELECT * FROM v_stock_metrics LIMIT 10;

-- Check that moving averages and returns look correct
SELECT ticker, date, close, daily_return_pct, ma_7, ma_30, vol_30
FROM v_stock_metrics
WHERE ticker = 'AAPL'
ORDER BY date DESC
LIMIT 10;



