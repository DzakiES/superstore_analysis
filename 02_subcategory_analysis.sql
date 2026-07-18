SELECT 
  category,
  subcategory,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct,
  ROUND(AVG(discount) * 100, 2) AS avg_discount_pct
FROM 
  `Superstore.orders`
GROUP BY 
  category, subcategory
ORDER BY 
  total_profit ASC;
