Where Is This Retailer Losing Money?

A profitability analysis of 9,994 order line items from a US retail "Superstore" dataset (2017–2020), built as a data analyst portfolio project.

Business question

The company looks healthy on paper — $2.30M in sales and $286K in profit over four years. But almost 1 in 5 order line items actually lose money. This project digs into which products, regions, and pricing decisions are driving those losses, and what a data-driven fix would look like.

Key findings


Discounting is the main driver of losses, not cost or demand. Once a line item's discount exceeds ~20%, its average profit turns negative. Loss-making lines carry an average discount of ~48%, versus ~8% on profitable lines.
Tables are the single biggest loss-maker at –$17.7K in total profit, more than any other subcategory. Bookcases and Supplies are also net-negative.
Binders is net-profitable overall but has the worst per-transaction margin (~–20% on average), driven by a long tail of heavily discounted sales — a different failure mode from Tables (high volume of thin losses vs. a few big ones).
Central region has the thinnest profit margin of the four regions, despite not being the smallest by sales.


Recommendations


Cap discounts at ~20% on Tables and Bookcases, where deep discounts are the main cause of losses.
Review Binders' discounting/promo policy separately — high volume, small consistent losses, likely unmanaged discount creep rather than a strategic loss-leader.
Investigate whether Central's thin margin comes from product mix or a regional discounting habit, and align it with West/East practice.
Set a discount approval threshold around 20–25%, since that's the inflection point where the average line item flips from profit to loss.
Re-run this analysis quarterly to track whether discount discipline improves subcategory-level margins.


Repo contents

FileDescriptionsuperstore_analysis.ipynbFull analysis: data cleaning checks, EDA, discount-vs-profit deep dive, regional breakdown, and recommendationsorders.csvSource data (9,994 rows, 20 columns: order/customer/product IDs, sales, quantity, discount, profit, category/subcategory, dates, shipping, geography)

Tools


Python: pandas for cleaning and aggregation, matplotlib/seaborn for charts
(Planned) SQL version of the same analysis for query-writing practice
(Planned) Tableau/Power BI dashboard for an interactive version of sections 4–8

Data source

This is the well-known "Sample Superstore" retail dataset, commonly used for BI/analytics practice
