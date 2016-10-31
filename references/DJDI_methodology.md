---
title: "The Dow Jones Distortion Index"
subtitle: "Index construction methodology - additional details"
layout: default
tags: [R, finance, index, equity]
permalink: /references/DJDI_methodology
---

# Dow Jones Distortion Index - additional details
_The following provides additional details for my original post on the Dow Jones Distortion Index [here](https://eightportions.com/2016-06-15-Dow-Jones-Distortion-Index)._

## Methodology details
The Dow Jones Distortion Index ("DJDI") is defined as half of the sum of the absolute difference between each stock's price-weighted contribution to the Dow Jones Industrial Average ("DJIA") and its share of the DJIA total market cap. Let $$P_n$$ equal the price of stock $$n$$ and $$M_n$$ equal the market capitalization of stock $$n$$ on any given day. The DJDI is calculated as:

$$DJDI = \frac{1}{2}\sum_{n=1}^{N} |P^*_n - M^*_n|$$

where $$P^*_n = \frac{P_n}{\sum_{i=1}^{N} P_i}$$ is the share of the sum price of the DJIA components contributed by stock $$n$$, $$M^*_n = \frac{M_n}{\sum_{i=1}^{N} M_i}$$ is the share of the total market cap of the DJIA components contributed by stock $$n$$, and $$N$$ is the number of stocks comprising the DJIA (currently $$N = 30$$).

### Real example: May 27, 2016
The following table illustrates how the DJDI is calculated, stock-by-stock, for May 27, 2016:

<div class="table-responsive">
<table>
  <thead>
    <tr>
      <th style="text-align: left">Ticker</th>
      <th style="text-align: left">Market Cap (BN)</th>
      <th style="text-align: left">[M] Share of sum market cap</th>
      <th style="text-align: left">Price</th>
      <th style="text-align: left">[P] Share of sum price</th>
      <th style="text-align: left">Absolute difference (P - M)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: left">AAPL</td>
      <td style="text-align: left">$549.66</td>
      <td style="text-align: left">10.21%</td>
      <td style="text-align: left">$100.35</td>
      <td style="text-align: left">3.85%</td>
      <td style="text-align: left">6.37%</td>
    </tr>
    <tr>
      <td style="text-align: left">AXP</td>
      <td style="text-align: left">$62.31</td>
      <td style="text-align: left">1.16%</td>
      <td style="text-align: left">$65.52</td>
      <td style="text-align: left">2.51%</td>
      <td style="text-align: left">1.35%</td>
    </tr>
    <tr>
      <td style="text-align: left">BA</td>
      <td style="text-align: left">$82.31</td>
      <td style="text-align: left">1.53%</td>
      <td style="text-align: left">$129.22</td>
      <td style="text-align: left">4.95%</td>
      <td style="text-align: left">3.42%</td>
    </tr>
    <tr>
      <td style="text-align: left">CAT</td>
      <td style="text-align: left">$42.02</td>
      <td style="text-align: left">0.78%</td>
      <td style="text-align: left">$71.96</td>
      <td style="text-align: left">2.76%</td>
      <td style="text-align: left">1.98%</td>
    </tr>
    <tr>
      <td style="text-align: left">CSCO</td>
      <td style="text-align: left">$145.46</td>
      <td style="text-align: left">2.70%</td>
      <td style="text-align: left">$28.92</td>
      <td style="text-align: left">1.11%</td>
      <td style="text-align: left">1.59%</td>
    </tr>
    <tr>
      <td style="text-align: left">CVX</td>
      <td style="text-align: left">$192.28</td>
      <td style="text-align: left">3.57%</td>
      <td style="text-align: left">$102.02</td>
      <td style="text-align: left">3.91%</td>
      <td style="text-align: left">0.34%</td>
    </tr>
    <tr>
      <td style="text-align: left">DD</td>
      <td style="text-align: left">$58.67</td>
      <td style="text-align: left">1.09%</td>
      <td style="text-align: left">$67.17</td>
      <td style="text-align: left">2.57%</td>
      <td style="text-align: left">1.48%</td>
    </tr>
    <tr>
      <td style="text-align: left">DIS</td>
      <td style="text-align: left">$162.71</td>
      <td style="text-align: left">3.02%</td>
      <td style="text-align: left">$100.29</td>
      <td style="text-align: left">3.84%</td>
      <td style="text-align: left">0.82%</td>
    </tr>
    <tr>
      <td style="text-align: left">GE</td>
      <td style="text-align: left">$276.97</td>
      <td style="text-align: left">5.15%</td>
      <td style="text-align: left">$30.12</td>
      <td style="text-align: left">1.15%</td>
      <td style="text-align: left">3.99%</td>
    </tr>
    <tr>
      <td style="text-align: left">GS</td>
      <td style="text-align: left">$66.27</td>
      <td style="text-align: left">1.23%</td>
      <td style="text-align: left">$159.53</td>
      <td style="text-align: left">6.11%</td>
      <td style="text-align: left">4.88%</td>
    </tr>
    <tr>
      <td style="text-align: left">HD</td>
      <td style="text-align: left">$166.62</td>
      <td style="text-align: left">3.10%</td>
      <td style="text-align: left">$133.94</td>
      <td style="text-align: left">5.13%</td>
      <td style="text-align: left">2.04%</td>
    </tr>
    <tr>
      <td style="text-align: left">IBM</td>
      <td style="text-align: left">$146.72</td>
      <td style="text-align: left">2.73%</td>
      <td style="text-align: left">$152.84</td>
      <td style="text-align: left">5.86%</td>
      <td style="text-align: left">3.13%</td>
    </tr>
    <tr>
      <td style="text-align: left">INTC</td>
      <td style="text-align: left">$149.07</td>
      <td style="text-align: left">2.77%</td>
      <td style="text-align: left">$31.57</td>
      <td style="text-align: left">1.21%</td>
      <td style="text-align: left">1.56%</td>
    </tr>
    <tr>
      <td style="text-align: left">JNJ</td>
      <td style="text-align: left">$310.99</td>
      <td style="text-align: left">5.78%</td>
      <td style="text-align: left">$113.06</td>
      <td style="text-align: left">4.33%</td>
      <td style="text-align: left">1.45%</td>
    </tr>
    <tr>
      <td style="text-align: left">JPM</td>
      <td style="text-align: left">$239.26</td>
      <td style="text-align: left">4.45%</td>
      <td style="text-align: left">$65.43</td>
      <td style="text-align: left">2.51%</td>
      <td style="text-align: left">1.94%</td>
    </tr>
    <tr>
      <td style="text-align: left">KO</td>
      <td style="text-align: left">$193.73</td>
      <td style="text-align: left">3.60%</td>
      <td style="text-align: left">$44.78</td>
      <td style="text-align: left">1.72%</td>
      <td style="text-align: left">1.88%</td>
    </tr>
    <tr>
      <td style="text-align: left">MCD</td>
      <td style="text-align: left">$108.20</td>
      <td style="text-align: left">2.01%</td>
      <td style="text-align: left">$123.25</td>
      <td style="text-align: left">4.72%</td>
      <td style="text-align: left">2.71%</td>
    </tr>
    <tr>
      <td style="text-align: left">MMM</td>
      <td style="text-align: left">$102.43</td>
      <td style="text-align: left">1.90%</td>
      <td style="text-align: left">$168.89</td>
      <td style="text-align: left">6.47%</td>
      <td style="text-align: left">4.57%</td>
    </tr>
    <tr>
      <td style="text-align: left">MRK</td>
      <td style="text-align: left">$156.34</td>
      <td style="text-align: left">2.91%</td>
      <td style="text-align: left">$56.48</td>
      <td style="text-align: left">2.16%</td>
      <td style="text-align: left">0.74%</td>
    </tr>
    <tr>
      <td style="text-align: left">MSFT</td>
      <td style="text-align: left">$411.26</td>
      <td style="text-align: left">7.64%</td>
      <td style="text-align: left">$52.32</td>
      <td style="text-align: left">2.00%</td>
      <td style="text-align: left">5.64%</td>
    </tr>
    <tr>
      <td style="text-align: left">NKE</td>
      <td style="text-align: left">$94.65</td>
      <td style="text-align: left">1.76%</td>
      <td style="text-align: left">$56.19</td>
      <td style="text-align: left">2.15%</td>
      <td style="text-align: left">0.39%</td>
    </tr>
    <tr>
      <td style="text-align: left">PFE</td>
      <td style="text-align: left">$209.90</td>
      <td style="text-align: left">3.90%</td>
      <td style="text-align: left">$34.61</td>
      <td style="text-align: left">1.33%</td>
      <td style="text-align: left">2.57%</td>
    </tr>
    <tr>
      <td style="text-align: left">PG</td>
      <td style="text-align: left">$216.75</td>
      <td style="text-align: left">4.03%</td>
      <td style="text-align: left">$81.43</td>
      <td style="text-align: left">3.12%</td>
      <td style="text-align: left">0.91%</td>
    </tr>
    <tr>
      <td style="text-align: left">TRV</td>
      <td style="text-align: left">$33.39</td>
      <td style="text-align: left">0.62%</td>
      <td style="text-align: left">$114.18</td>
      <td style="text-align: left">4.37%</td>
      <td style="text-align: left">3.75%</td>
    </tr>
    <tr>
      <td style="text-align: left">UNH</td>
      <td style="text-align: left">$127.41</td>
      <td style="text-align: left">2.37%</td>
      <td style="text-align: left">$134.00</td>
      <td style="text-align: left">5.13%</td>
      <td style="text-align: left">2.77%</td>
    </tr>
    <tr>
      <td style="text-align: left">UTX</td>
      <td style="text-align: left">$84.32</td>
      <td style="text-align: left">1.57%</td>
      <td style="text-align: left">$100.76</td>
      <td style="text-align: left">3.86%</td>
      <td style="text-align: left">2.29%</td>
    </tr>
    <tr>
      <td style="text-align: left">V</td>
      <td style="text-align: left">$189.96</td>
      <td style="text-align: left">3.53%</td>
      <td style="text-align: left">$79.66</td>
      <td style="text-align: left">3.05%</td>
      <td style="text-align: left">0.48%</td>
    </tr>
    <tr>
      <td style="text-align: left">VZ</td>
      <td style="text-align: left">$206.34</td>
      <td style="text-align: left">3.83%</td>
      <td style="text-align: left">$50.62</td>
      <td style="text-align: left">1.94%</td>
      <td style="text-align: left">1.89%</td>
    </tr>
    <tr>
      <td style="text-align: left">WMT</td>
      <td style="text-align: left">$222.07</td>
      <td style="text-align: left">4.13%</td>
      <td style="text-align: left">$70.75</td>
      <td style="text-align: left">2.71%</td>
      <td style="text-align: left">1.42%</td>
    </tr>
    <tr>
      <td style="text-align: left">XOM</td>
      <td style="text-align: left">$373.24</td>
      <td style="text-align: left">6.94%</td>
      <td style="text-align: left">$90.01</td>
      <td style="text-align: left">3.45%</td>
      <td style="text-align: left">3.49%</td>
    </tr>
    <tr>
      <td style="text-align: left">DJDI</td>
      <td style="text-align: left"> </td>
      <td style="text-align: left"> </td>
      <td style="text-align: left"> </td>
      <td style="text-align: left"> </td>
      <td style="text-align: left">35.9%</td>
    </tr>
  </tbody>
</table>
</div>
