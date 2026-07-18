# E-Commerce Margin Optimization & Discounting Strategy Analysis

![Dashboard preview](assets/dashboard-preview.png)

**[View the live interactive dashboard →](#)** *(replace with your published Looker Studio link)*

## Overview

This project analyzes 9,994 retail transactions from a superstore dataset to evaluate overall business health, uncover hidden operational deficits, and diagnose margin leaks caused by promotional discounting. By moving raw transactional data into BigQuery and building an interactive Looker Studio dashboard, the analysis identifies exactly which product subcategories and regional customer segments are structurally unprofitable — and quantifies what fixing it is worth.

**Business question:** The business is profitable overall (12.47% margin), so why do certain product lines lose money on every sale, and what's driving it?

**Answer:** Three subcategories — Tables, Bookcases, and Supplies — are net loss-makers despite meaningful sales volume. The root cause is discounting: the two worst-performing region/segment combinations both carry average discounts above 30%, and profit margin falls in near-lockstep with discount rate.

## Tech stack

| Layer | Tool |
|---|---|
| Data warehouse | Google BigQuery (SQL) |
| BI / dashboard | Looker Studio |
| Data ingestion | Schema auto-detection of raw `.csv` into BigQuery |

## Repository structure

```
├── README.md
├── sql/
│   ├── 01_kpi_summary.sql            -- headline business KPIs
│   ├── 02_subcategory_analysis.sql   -- which subcategories lose money
│   ├── 03_loss_diagnostic.sql        -- where the losses concentrate (region x segment)
│   └── 04_discount_cap_simulation.sql -- quantifies the recommendation
└── assets/
    └── dashboard-preview.png
```

## Analysis walkthrough

### 1. Executive summary (macro view)

A baseline KPI query (`01_kpi_summary.sql`) established the business is healthy on the surface:

- **Total sales:** $2,297,200.86
- **Total profit:** $286,397.02
- **Global profit margin:** 12.47%

### 2. Finding the operational deficits

Aggregating by product hierarchy (`02_subcategory_analysis.sql`) revealed that three subcategories are draining profit despite real sales volume:

| Subcategory | Sales | Profit | Margin |
|---|---|---|---|
| Tables | $206,965.53 | -$17,725.48 | **-8.56%** |
| Bookcases | — | -$3,472.56 | **-3.02%** |
| Supplies | — | -$1,189.10 | **-2.55%** |

### 3. Root cause: the discount trap

Drilling into these subcategories by region and segment (`03_loss_diagnostic.sql`) surfaced a clear pattern — the worst losses are tied to the highest discount rates:

| Segment | Margin | Avg. discount |
|---|---|---|
| East · Corporate · Tables | **-30.19%** | 38.13% |
| Central · Consumer · Tables | **-19.03%** | 31.19% |

Plotting discount rate against profit margin across all region/segment combinations for Tables confirms the relationship — margin declines steadily as discount rate rises, and the two flagged combinations sit as clear outliers at the high-discount, deep-loss end of the curve.

### 4. Quantifying the fix

To move from "this is a problem" to "here's what to do," I simulated capping the discount rate at 20% for all Tables transactions (`04_discount_cap_simulation.sql`), holding unit cost constant and backing out the implied list price from the actual sales and discount figures:

| Scope | Actual profit | Simulated profit (20% cap) | Recovery |
|---|---|---|---|
| Tables (all regions/segments) | -$17,725.48 | +$11,774.95 | **+$29,500.43** |
| East · Corporate · Tables | -$5,299.66 | -$45.59 | +$5,254.07 |
| Central · Consumer · Tables | -$3,964.16 | +$400.51 | +$4,364.66 |

*Note: this simulation assumes cost of goods sold doesn't change with discount depth — a simplification stated here for transparency. It's directionally reliable but would benefit from validation against actual COGS data if this were a live business decision.*

## Recommendations

1. **Cap discounts on Tables at 20%.** At current discount levels (up to 45% on individual orders), Tables loses money on the majority of transactions. A 20% cap would move the subcategory from -8.56% margin to an estimated +4.98% margin — a swing of roughly $29.5K on this dataset alone.
2. **Apply segment-specific discount governance rather than a blanket policy.** East Corporate customers are being discounted more aggressively (38%) than Central Consumer (31%) for the same underlying loss pattern — suggesting sales reps in that segment/region combination may need tighter approval thresholds on discounting.
3. **Extend the same diagnostic to Bookcases and Supplies.** Both are smaller in dollar impact than Tables but follow the same shape (negative margin, above-average discount) and are worth the same cap-and-simulate treatment.
4. **Monitor, don't just fix once.** Add the discount-vs-margin scatter plot to a recurring (e.g. monthly) dashboard review so any subcategory drifting toward the "trap" pattern gets caught before it compounds into a full quarter of losses.

## Dashboard

The Looker Studio dashboard includes:
- KPI scorecards (sales, profit, margin, and a conditional-formatted alert card for Tables)
- A treemap of the full product hierarchy, with loss-making subcategories flagged in red
- A sorted bar chart of profit margin by subcategory
- A discount-vs-margin scatter plot by region/segment, sized by sales volume, isolating the two "discount trap" outliers

## What I'd do next with more time

- Pull in actual product cost/COGS data to replace the list-price-back-out assumption in the simulation
- Test whether the discount-margin relationship holds across other subcategories, or is specific to big-ticket furniture items
- Build a simple "discount threshold" parameter control into the Looker Studio dashboard so stakeholders can test different caps themselves
