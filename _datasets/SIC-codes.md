---
title: SIC codes
subtitle: Standard Industrial Classification codes scraped from government websites
date: 2017-03-11
layout: page-wide
overlay: 50,120,190,0.7
bigimg: /img/sides-of-a-skyscraper.jpg
custom_css:
  - https://cdn.datatables.net/1.10.13/css/dataTables.bootstrap.min.css
  - https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css
tags: [SIC, industry classification, webscraping, python]
---

The Standard Industrial Classification (SIC) is a system used to classify businesses by their primary business activity, or industry. The SIC system was created in the 1930's and has since been [replaced](https://www.census.gov/eos/www/naics/faqs/faqs.html#q8) as the industry classification system of choice for Federal statistical agencies; however, it is still widely used by many businesses and by some other government agencies.

There are a number of online sources that provide SIC codes and descriptions, though I've found none that make their data downloadable, provide the source of their data, and also provide any code used to obtain their data. I've written web scrapers to fill this gap by providing a transparent and open-source list of machine-readable SIC codes -- one for the [Occupational Safety & Health Administration (OSHA)](https://www.osha.gov/pls/imis/sic_manual.html) and one for the [U.S. Securities and Exchange Commission (SEC)](https://www.sec.gov/info/edgar/siccodes.htm)[^1].

The SIC codes provided by the SEC generally align with those provided by OSHA; however, OSHA's SIC manual is more comprehensive -- it contains more SIC codes and a more detailed classification hierarchy than does the SEC's list. [Table 1](#table-1), below, provides a searchable, sortable table of the OSHA SIC codes. The SIC codes and descriptions from both the SEC and OSHA can be downloaded at the bottom of the page. A link to the scraper source code can also be found at the bottom of the page.

#### Table 1: OSHA SIC codes {#table-1}

<script src="/js/jquery-1.11.2.min.js"></script>
<script src="https://cdn.datatables.net/1.10.13/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.13/js/dataTables.bootstrap.min.js"></script>
<script>
$(document).ready(function() {
    $('#osha-sic').DataTable();
} );
</script>

<div class="table-responsive">
{% include osha_combined.htm %}
</div>

-----------------------------------------------------------------------------

### Learn more
<ul class="list-inline dataset" style="margin: 20px 0 40px 0;">
<li>
<a href="https://raw.githubusercontent.com/rtlee9/SIC-list/master/data/osha_combined.csv" download>
  <button type="button" class="btn btn-primary btn-lg">
    <i class="fa fa-lg fa-download"></i>
      Download OSHA SIC codes
  </button>
</a>
</li>

<li>
<a href="https://raw.githubusercontent.com/rtlee9/SIC-list/master/data/sec_combined.csv" download>
  <button type="button" class="btn btn-primary btn-lg">
    <i class="fa fa-lg fa-download"></i>
      Download SEC SIC codes
  </button>
</a>
</li>

<li>
<a href="https://github.com/rtlee9/SIC-list">
  <button type="button" class="btn btn-primary btn-lg">
    <i class="fa fa-lg fa-github"></i>
      View project on GitHub
  </button>
</a>
</li>

<li>
<a href="/datasets">
  <button type="button" class="btn btn-primary btn-lg">
    <i class="fa fa-lg fa-database"></i>
      View other datasets
  </button>
</a>
</li>
</ul>

-----------------------------------------------------------------------------

### Footnotes
[^1]: These are the only two government agencies I'm aware of that currently publish a list of SIC codes and descriptions
