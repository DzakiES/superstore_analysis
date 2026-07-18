SELECT 
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT customer_id) AS total_customers,
  ROUND(SUM(sales), 2) AS total_revenue,
  ROUND(SUM(profit), 2) AS total_profit,
  -- Calculate overall profit margin percentage
  ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct,
  -- Average Order Value (AOV)
  ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM 
  `Superstore.orders`;