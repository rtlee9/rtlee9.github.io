---
title: "The Dow Jones Distortion Index"
subtitle: "Index construction methodology - additional details"
layout: post
tags: [R, finance, index, equity]
permalink: /references/DJDI_methodology
---

## Methodology - Dow Jones Distortion Index
I define the Dow Jones Distortion Index ("DJDI") as half of the sum of the absolute difference between each stock's price-weighted contribution to the Dow Jones Industrial Average ("DJIA") and its market-cap-weighted contribution to the DJIA. Let $$P_n$$ equal the price of stock $$n$$ and $$M_n$$ equal the market capitalization of stock $$n$$ on any given day. The DJDI is calculated as:

$$DJDI = \frac{1}{2}\sum_{n=1}^{N} |P^*_n - M^*_n|$$

where $$P^*_n = \frac{P_n}{\sum_{i=1}^{N} P_i}$$ is the share of the sum price of the DJIA components contributed by stock $$n$$, $$M^*_n = \frac{M_n}{\sum_{i=1}^{N} M_i}$$ is the share of the sum market cap of the DJIA components contributed by stock $$n$$, and $$N$$ is the number of stocks comprising the DJIA (currently $$N = 30$$).

### Real example: all components from May 27, 2016
The following table illustrates how the DJDI is calculated, stock-by-stock, for May 27, 2016:

|Ticker |Market Cap (BN) |[M] Share of sum market cap |Price   |[P] Share of sum price |Absolute difference (P - M) |
|:------|:---------------|:---------------------------|:-------|:----------------------|:---------------------------|
|AAPL   |$549.66         |10.21%                      |$100.35 |3.85%                  |6.37%                       |
|AXP    |$62.31          |1.16%                       |$65.52  |2.51%                  |1.35%                       |
|BA     |$82.31          |1.53%                       |$129.22 |4.95%                  |3.42%                       |
|CAT    |$42.02          |0.78%                       |$71.96  |2.76%                  |1.98%                       |
|CSCO   |$145.46         |2.70%                       |$28.92  |1.11%                  |1.59%                       |
|CVX    |$192.28         |3.57%                       |$102.02 |3.91%                  |0.34%                       |
|DD     |$58.67          |1.09%                       |$67.17  |2.57%                  |1.48%                       |
|DIS    |$162.71         |3.02%                       |$100.29 |3.84%                  |0.82%                       |
|GE     |$276.97         |5.15%                       |$30.12  |1.15%                  |3.99%                       |
|GS     |$66.27          |1.23%                       |$159.53 |6.11%                  |4.88%                       |
|HD     |$166.62         |3.10%                       |$133.94 |5.13%                  |2.04%                       |
|IBM    |$146.72         |2.73%                       |$152.84 |5.86%                  |3.13%                       |
|INTC   |$149.07         |2.77%                       |$31.57  |1.21%                  |1.56%                       |
|JNJ    |$310.99         |5.78%                       |$113.06 |4.33%                  |1.45%                       |
|JPM    |$239.26         |4.45%                       |$65.43  |2.51%                  |1.94%                       |
|KO     |$193.73         |3.60%                       |$44.78  |1.72%                  |1.88%                       |
|MCD    |$108.20         |2.01%                       |$123.25 |4.72%                  |2.71%                       |
|MMM    |$102.43         |1.90%                       |$168.89 |6.47%                  |4.57%                       |
|MRK    |$156.34         |2.91%                       |$56.48  |2.16%                  |0.74%                       |
|MSFT   |$411.26         |7.64%                       |$52.32  |2.00%                  |5.64%                       |
|NKE    |$94.65          |1.76%                       |$56.19  |2.15%                  |0.39%                       |
|PFE    |$209.90         |3.90%                       |$34.61  |1.33%                  |2.57%                       |
|PG     |$216.75         |4.03%                       |$81.43  |3.12%                  |0.91%                       |
|TRV    |$33.39          |0.62%                       |$114.18 |4.37%                  |3.75%                       |
|UNH    |$127.41         |2.37%                       |$134.00 |5.13%                  |2.77%                       |
|UTX    |$84.32          |1.57%                       |$100.76 |3.86%                  |2.29%                       |
|V      |$189.96         |3.53%                       |$79.66  |3.05%                  |0.48%                       |
|VZ     |$206.34         |3.83%                       |$50.62  |1.94%                  |1.89%                       |
|WMT    |$222.07         |4.13%                       |$70.75  |2.71%                  |1.42%                       |
|XOM    |$373.24         |6.94%                       |$90.01  |3.45%                  |3.49%                       |
|DJDI   |                |                            |        |                       |35.9%                       |
