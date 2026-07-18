-- ============================================================
-- 04_discount_cap_simulation.sql
-- Purpose: Quantify the profit recovery opportunity IF discounts
--          on Tables were capped at 20% instead of running as
--          high as 38-45%.
--
-- Method:  Back out the implied list price from sales/discount,
--          hold unit cost constant, and recompute sales/profit
--          at a capped discount rate. This assumes cost of goods
--          does not change with discount (a simplification -
--          real-world validation would need actual COGS data).
-- ============================================================

WITH base AS (
  SELECT
    order_id,
    subcategory,
    region,
    segment,
    sales,
    profit,
    discount,
    sales / (1 - discount) AS list_price,      -- implied undiscounted price
    sales - profit AS cost_of_goods,           -- back out unit cost
    LEAST(discount, 0.20) AS capped_discount    -- cap at 20%
  FROM
    `Superstore.orders`
  WHERE
    subcategory = 'Tables'
),

simulated AS (
  SELECT
    *,
    list_price * (1 - capped_discount) AS new_sales,
    (list_price * (1 - capped_discount)) - cost_of_goods AS new_profit
  FROM
    base
)

SELECT
  ROUND(SUM(sales), 2) AS actual_sales,
  ROUND(SUM(profit), 2) AS actual_profit,
  ROUND(SUM(profit) / SUM(sales) * 100, 2) AS actual_margin_pct,

  ROUND(SUM(new_sales), 2) AS simulated_sales_at_20pct_cap,
  ROUND(SUM(new_profit), 2) AS simulated_profit_at_20pct_cap,
  ROUND(SUM(new_profit) / SUM(new_sales) * 100, 2) AS simulated_margin_pct,

  ROUND(SUM(new_profit) - SUM(profit), 2) AS estimated_profit_recovery

FROM
  simulated;

-- Result:
-- Tables (all regions/segments), discount capped at 20%:
--   actual profit:     -$17,725.48  (margin -8.56%)
--   simulated profit:  +$11,774.95  (margin +4.98%)
--   estimated recovery: +$29,500.43
--
-- East / Corporate / Tables specifically:
--   actual profit:     -$5,299.66   (margin -30.19%)
--   simulated profit:  -$45.59      (margin -0.2%)
--   estimated recovery: +$5,254.07
--
-- Central / Consumer / Tables specifically:
--   actual profit:     -$3,964.16   (margin -19.03%)
--   simulated profit:  +$400.51     (margin +1.59%)
--   estimated recovery: +$4,364.66
