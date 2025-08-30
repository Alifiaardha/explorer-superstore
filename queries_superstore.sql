-- DDL: Create table for Superstore 
CREATE TABLE IF NOT EXISTS superstore_cleaned (
    row_id SERIAL PRIMARY KEY,
    order_id TEXT,
    order_date DATE,
    ship_date DATE,
    ship_mode TEXT,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales NUMERIC(12,2),
    quantity INT,
    discount NUMERIC(6,3),
    profit NUMERIC(12,2)
);

-- Import data (gunakan COPY kalau server punya akses file, atau \copy kalau lokal/pgAdmin)
-- Ganti path sesuai lokasi file CSV kamu
-- COPY superstore_cleaned 
-- FROM '/path/to/Cleaned Superstore Dataset.csv' 
-- WITH (FORMAT csv, HEADER true);


-- ===================
-- KPIs
-- ===================
SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units,
    (SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0)) AS avg_order_value
FROM superstore_cleaned;


-- ===================
-- Monthly Sales Trend
-- ===================
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS sales
FROM superstore_cleaned
GROUP BY 1
ORDER BY month;


-- ===================
-- Sales & Profit by Category/Sub-Category
-- ===================
SELECT
    category,
    sub_category,
    SUM(sales) AS sales,
    SUM(profit) AS profit,
    ROUND(100.0 * SUM(profit) / NULLIF(SUM(sales), 0), 2) AS margin_pct,
    RANK() OVER (PARTITION BY category ORDER BY SUM(sales) DESC) AS rank_in_category
FROM superstore_cleaned
GROUP BY 1,2
ORDER BY sales DESC;


-- ===================
-- Top Profit by State 
-- ===================
SELECT
    state,
    SUM(sales) AS sales,
    SUM(profit) AS profit
FROM superstore_cleaned
GROUP BY 1
ORDER BY profit DESC
LIMIT 10;

-- ===================
-- Bottom Profit by State
-- ===================
SELECT
    state,
    SUM(sales) AS sales,
    SUM(profit) AS profit
FROM superstore_cleaned
GROUP BY 1
ORDER BY profit ASC
LIMIT 10;


-- ===================
-- Top 15 Customers by Sales
-- ===================
SELECT
    customer_id,
    customer_name,
    SUM(sales) AS sales,
    SUM(profit) AS profit,
    COUNT(DISTINCT order_id) AS orders
FROM superstore_cleaned
GROUP BY 1,2
ORDER BY sales DESC
LIMIT 15;


-- ===================
-- RFM Segmentation (Recency, Frequency, Monetary)
-- ===================
WITH base AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(sales) AS monetary
    FROM superstore_cleaned
    GROUP BY customer_id
),
scored AS (
    SELECT
        customer_id,
        (CURRENT_DATE - last_order_date) AS recency,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY (CURRENT_DATE - last_order_date) ASC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary DESC) AS m_score
    FROM base
)
SELECT *,
       (r_score::text || f_score::text || m_score::text) AS rfm_cell
FROM scored;


