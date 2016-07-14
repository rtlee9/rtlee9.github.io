---
title: "NYC yellow cab trips"
subtitle: "Neighborhood by neighborhood"
layout: post
tags: [NYC, taxi, transportation, open data, R, SQL]
permalink: /UAT/Taxi
---


In this post I explore NYC yellow cab data neighborhood-by-neighborhood. I examine NYC taxi rides from a neighborhood-centric perspective through a set of superlatives that highlight the diverse nature of NYC neighborhoods, as defined by [Zillow](http://www.zillow.com/howto/api/neighborhood-boundaries.htm). This post focuses on Manhattan neighborhoods, as neighborhoods in other boroughs have relatively low volumes and differ from the average NYC trip in other fundamental ways (e.g., higher average distance traveled, low outbound:inbound ratio).

This post uses 2014 yellow cab data sourced from [NYC OpenData](https://data.cityofnewyork.us/view/gn7m-em8n). I used PostgreSQL, PostGIS, and R for the data management, mapping, analysis, and visuals (thanks to [Todd Schneider](https://github.com/toddwschneider/nyc-taxi-data) for his instructions). Plots were made with [rCharts NVD3](http://ramnathv.github.io/posts/rcharts-nvd3/), and maps were made with [ggmap](https://cran.r-project.org/web/packages/ggmap/index.html).

### Top routes
Table 1 outlines the top neighborhood-to-neighborhood routes in 2014. The list is dominated by three neighborhoods: the Upper East Side, Midtown, and the Upper West Side.

##### Table 1: top routes

|Pickup neighborhood |Dropoff neighborhood |     Trips|
|:-------------------|:--------------------|---------:|
|Upper East Side     |Upper East Side      | 6,842,026|
|Midtown             |Midtown              | 5,353,220|
|Upper West Side     |Upper West Side      | 3,975,588|
|Upper East Side     |Midtown              | 3,841,041|
|Midtown             |Upper East Side      | 3,674,126|
|Garment District    |Midtown              | 2,325,275|
|Midtown             |Upper West Side      | 2,144,275|
|Midtown             |Gramercy             | 2,123,459|
|Upper West Side     |Midtown              | 2,074,491|
|Gramercy            |Midtown              | 2,031,802|

Each of these three neighborhoods are geographically large, and likely contain more  people available for pickup than other neighborhoods. Additionally, depending on the destination, public transportation from these neighborhoods can be tricky[^1]. Lastly, it's conceivable that people in these neighborhoods may differ from people in other neighborhoods in a way that increases their propensity to take cabs (e.g., disposable income, preponderance of expense accounts, value of time).

Figure 1 shows the same trip volumes split by time of week. It indicates that there are significant differences in the popularity of certain routes based on the time of week. Likely driven by commuter traffic, routes ending in Midtown are far more popular on weekday evenings than on weekday mornings, while the opposite is true for routes originating from Midtown.

##### Figure 1: top 10 routes by time of week
<iframe srcdoc=' &lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;link rel=&#039;stylesheet&#039; href=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.css&#039;&gt;

    &lt;script src=&#039;//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//d3js.org/d3.v3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//nvd3.org/assets/lib/fisheye.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;

    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto;
      margin-right: auto;
      width: 750px;
      height: 600px;
    }  
    &lt;/style&gt;

  &lt;/head&gt;
  &lt;body &gt;

    &lt;div id = &#039;chart17277dc81f6&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart17277dc81f6()
    });
    function drawchart17277dc81f6(){  
      var opts = {
 &quot;dom&quot;: &quot;chart17277dc81f6&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;route&quot;,
&quot;y&quot;: &quot;trips&quot;,
&quot;group&quot;: &quot;tow&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart17277dc81f6&quot;
},
        data = [
 {
 &quot;route&quot;: &quot;Upper East Side -&gt; Upper East Side&quot;,
&quot;trips_t&quot;:        6842026,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:        1631908
},
{
 &quot;route&quot;: &quot;Upper East Side -&gt; Upper East Side&quot;,
&quot;trips_t&quot;:        6842026,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:        1337583
},
{
 &quot;route&quot;: &quot;Upper East Side -&gt; Upper East Side&quot;,
&quot;trips_t&quot;:        6842026,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:        1686178
},
{
 &quot;route&quot;: &quot;Upper East Side -&gt; Upper East Side&quot;,
&quot;trips_t&quot;:        6842026,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:        2186357
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Midtown&quot;,
&quot;trips_t&quot;:        5353220,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:        1208665
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Midtown&quot;,
&quot;trips_t&quot;:        5353220,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:        1377696
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Midtown&quot;,
&quot;trips_t&quot;:        5353220,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:        1174643
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Midtown&quot;,
&quot;trips_t&quot;:        5353220,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:        1592216
},
{
 &quot;route&quot;: &quot;Upper West Side -&gt; Upper West Side&quot;,
&quot;trips_t&quot;:        3975588,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:        1155478
},
{
 &quot;route&quot;: &quot;Upper West Side -&gt; Upper West Side&quot;,
&quot;trips_t&quot;:        3975588,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         566787
},
{
 &quot;route&quot;: &quot;Upper West Side -&gt; Upper West Side&quot;,
&quot;trips_t&quot;:        3975588,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         842112
},
{
 &quot;route&quot;: &quot;Upper West Side -&gt; Upper West Side&quot;,
&quot;trips_t&quot;:        3975588,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:        1411211
},
{
 &quot;route&quot;: &quot;Upper East Side -&gt; Midtown&quot;,
&quot;trips_t&quot;:        3841041,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         774635
},
{
 &quot;route&quot;: &quot;Upper East Side -&gt; Midtown&quot;,
&quot;trips_t&quot;:        3841041,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:        1404131
},
{
 &quot;route&quot;: &quot;Upper East Side -&gt; Midtown&quot;,
&quot;trips_t&quot;:        3841041,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         803334
},
{
 &quot;route&quot;: &quot;Upper East Side -&gt; Midtown&quot;,
&quot;trips_t&quot;:        3841041,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:         858941
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Upper East Side&quot;,
&quot;trips_t&quot;:        3674126,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         806665
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Upper East Side&quot;,
&quot;trips_t&quot;:        3674126,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         597421
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Upper East Side&quot;,
&quot;trips_t&quot;:        3674126,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         779965
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Upper East Side&quot;,
&quot;trips_t&quot;:        3674126,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:        1490075
},
{
 &quot;route&quot;: &quot;Garment District -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2325275,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         522984
},
{
 &quot;route&quot;: &quot;Garment District -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2325275,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         773925
},
{
 &quot;route&quot;: &quot;Garment District -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2325275,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         495281
},
{
 &quot;route&quot;: &quot;Garment District -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2325275,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:         533085
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Upper West Side&quot;,
&quot;trips_t&quot;:        2144275,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         514575
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Upper West Side&quot;,
&quot;trips_t&quot;:        2144275,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         285952
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Upper West Side&quot;,
&quot;trips_t&quot;:        2144275,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         341030
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Upper West Side&quot;,
&quot;trips_t&quot;:        2144275,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:        1002718
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Gramercy&quot;,
&quot;trips_t&quot;:        2123459,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         500335
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Gramercy&quot;,
&quot;trips_t&quot;:        2123459,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         387575
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Gramercy&quot;,
&quot;trips_t&quot;:        2123459,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         413844
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Gramercy&quot;,
&quot;trips_t&quot;:        2123459,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:         821705
},
{
 &quot;route&quot;: &quot;Upper West Side -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2074491,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         493691
},
{
 &quot;route&quot;: &quot;Upper West Side -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2074491,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         666069
},
{
 &quot;route&quot;: &quot;Upper West Side -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2074491,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         393931
},
{
 &quot;route&quot;: &quot;Upper West Side -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2074491,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:         520800
},
{
 &quot;route&quot;: &quot;Gramercy -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2031802,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         477764
},
{
 &quot;route&quot;: &quot;Gramercy -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2031802,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         648359
},
{
 &quot;route&quot;: &quot;Gramercy -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2031802,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         389869
},
{
 &quot;route&quot;: &quot;Gramercy -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2031802,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:         515810
}
]

      if(!(opts.type===&quot;pieChart&quot; || opts.type===&quot;sparklinePlus&quot; || opts.type===&quot;bulletChart&quot;)) {
        var data = d3.nest()
          .key(function(d){
            //return opts.group === undefined ? &#039;main&#039; : d[opts.group]
            //instead of main would think a better default is opts.x
            return opts.group === undefined ? opts.y : d[opts.group];
          })
          .entries(data);
      }

      if (opts.disabled != undefined){
        data.map(function(d, i){
          d.disabled = opts.disabled[i]
        })
      }

      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          .width(opts.width)
          .height(opts.height)

        if (opts.type != &quot;bulletChart&quot;){
          chart
            .x(function(d) { return d[opts.x] })
            .y(function(d) { return d[opts.y] })
        }


        chart
  .stacked(true)
  .margin({
 &quot;left&quot;:    225,
&quot;right&quot;:     50
})





        chart.yAxis
  .tickFormat(function(d) {return d3.format(&#039;,.0&#039;)(d)})
  .axisLabel(&quot;Number of trips&quot;)

       d3.select(&quot;#&quot; + opts.id)
        .append(&#039;svg&#039;)
        .datum(data)
        .transition().duration(500)
        .call(chart);

       nv.utils.windowResize(chart.update);
       return chart;
      });
    };
&lt;/script&gt;

    &lt;script&gt;&lt;/script&gt;    
  &lt;/body&gt;
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart17277dc81f6'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>


## Most / least likely to pay with cash
* __Definition:__ percent of trips paid in cash
* __Scope:__ Manhattan pickups
* __Most likely to pay with cash__: East Harlem pickups
* __Least likely to pay with cash__: Battery Park pickups

According to the [Urban Institute](http://www.urban.org/interactive-map-where-are-unbanked-and-underbanked-new-york-city), households in Harlem are 2.15 times as likely to be unbanked as the average Manhattan household[^2]. This could be a contributing factor, but it's hard to say how much of the cash-card disparity is caused by the underlying household financials.

##### Figure 2: % of trips paid in cash, by pickup neighborhood
<iframe srcdoc=' &lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;link rel=&#039;stylesheet&#039; href=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.css&#039;&gt;

    &lt;script src=&#039;//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//d3js.org/d3.v3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//nvd3.org/assets/lib/fisheye.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;

    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto;
      margin-right: auto;
      width: 750px;
      height: 600px;
    }  
    &lt;/style&gt;

  &lt;/head&gt;
  &lt;body &gt;

    &lt;div id = &#039;chart17242a6d21c&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart17242a6d21c()
    });
    function drawchart17242a6d21c(){  
      var opts = {
 &quot;dom&quot;: &quot;chart17242a6d21c&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;pick_neigh&quot;,
&quot;y&quot;: &quot;Cash share of trips&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart17242a6d21c&quot;
},
        data = [
 {
 &quot;pick_neigh&quot;: &quot;East Harlem&quot;,
&quot;Cash share of trips&quot;: 0.5789806314163
},
{
 &quot;pick_neigh&quot;: &quot;Inwood&quot;,
&quot;Cash share of trips&quot;: 0.555246847617
},
{
 &quot;pick_neigh&quot;: &quot;Harlem&quot;,
&quot;Cash share of trips&quot;: 0.5012193846841
},
{
 &quot;pick_neigh&quot;: &quot;Garment District&quot;,
&quot;Cash share of trips&quot;: 0.4911760996266
},
{
 &quot;pick_neigh&quot;: &quot;Hamilton Heights&quot;,
&quot;Cash share of trips&quot;: 0.4894151465947
},
{
 &quot;pick_neigh&quot;: &quot;Yorkville&quot;,
&quot;Cash share of trips&quot;: 0.4832702981774
},
{
 &quot;pick_neigh&quot;: &quot;Chinatown&quot;,
&quot;Cash share of trips&quot;: 0.476910439184
},
{
 &quot;pick_neigh&quot;: &quot;Washington Heights&quot;,
&quot;Cash share of trips&quot;: 0.4720807657008
},
{
 &quot;pick_neigh&quot;: &quot;Central Park&quot;,
&quot;Cash share of trips&quot;: 0.4684098322094
},
{
 &quot;pick_neigh&quot;: &quot;Carnegie Hill&quot;,
&quot;Cash share of trips&quot;: 0.4575735768608
},
{
 &quot;pick_neigh&quot;: &quot;Midtown&quot;,
&quot;Cash share of trips&quot;: 0.4432412825236
},
{
 &quot;pick_neigh&quot;: &quot;Upper East Side&quot;,
&quot;Cash share of trips&quot;: 0.4425381348996
},
{
 &quot;pick_neigh&quot;: &quot;Clinton&quot;,
&quot;Cash share of trips&quot;: 0.4421271910346
},
{
 &quot;pick_neigh&quot;: &quot;North Sutton Area&quot;,
&quot;Cash share of trips&quot;: 0.4402258020685
},
{
 &quot;pick_neigh&quot;: &quot;Upper West Side&quot;,
&quot;Cash share of trips&quot;: 0.4322967598781
},
{
 &quot;pick_neigh&quot;: &quot;Murray Hill&quot;,
&quot;Cash share of trips&quot;: 0.4051042135057
},
{
 &quot;pick_neigh&quot;: &quot;Morningside Heights&quot;,
&quot;Cash share of trips&quot;: 0.4033972698837
},
{
 &quot;pick_neigh&quot;: &quot;Soho&quot;,
&quot;Cash share of trips&quot;: 0.3744588580908
},
{
 &quot;pick_neigh&quot;: &quot;Greenwich Village&quot;,
&quot;Cash share of trips&quot;: 0.3730170570129
},
{
 &quot;pick_neigh&quot;: &quot;Financial District&quot;,
&quot;Cash share of trips&quot;: 0.3704973684128
},
{
 &quot;pick_neigh&quot;: &quot;Chelsea&quot;,
&quot;Cash share of trips&quot;: 0.3666435552374
},
{
 &quot;pick_neigh&quot;: &quot;Lower East Side&quot;,
&quot;Cash share of trips&quot;: 0.3636845559001
},
{
 &quot;pick_neigh&quot;: &quot;Gramercy&quot;,
&quot;Cash share of trips&quot;: 0.3551168145881
},
{
 &quot;pick_neigh&quot;: &quot;Little Italy&quot;,
&quot;Cash share of trips&quot;: 0.3524578557801
},
{
 &quot;pick_neigh&quot;: &quot;West Village&quot;,
&quot;Cash share of trips&quot;: 0.3523109656912
},
{
 &quot;pick_neigh&quot;: &quot;East Village&quot;,
&quot;Cash share of trips&quot;: 0.3485461699696
},
{
 &quot;pick_neigh&quot;: &quot;Tribeca&quot;,
&quot;Cash share of trips&quot;: 0.3436360685234
},
{
 &quot;pick_neigh&quot;: &quot;Battery Park&quot;,
&quot;Cash share of trips&quot;: 0.3234875877718
}
]

      if(!(opts.type===&quot;pieChart&quot; || opts.type===&quot;sparklinePlus&quot; || opts.type===&quot;bulletChart&quot;)) {
        var data = d3.nest()
          .key(function(d){
            //return opts.group === undefined ? &#039;main&#039; : d[opts.group]
            //instead of main would think a better default is opts.x
            return opts.group === undefined ? opts.y : d[opts.group];
          })
          .entries(data);
      }

      if (opts.disabled != undefined){
        data.map(function(d, i){
          d.disabled = opts.disabled[i]
        })
      }

      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          .width(opts.width)
          .height(opts.height)

        if (opts.type != &quot;bulletChart&quot;){
          chart
            .x(function(d) { return d[opts.x] })
            .y(function(d) { return d[opts.y] })
        }


        chart
  .stacked(true)
  .margin({
 &quot;left&quot;:    140,
&quot;right&quot;:    100
})
  .showControls(false)
  .showLegend(false)





        chart.yAxis
  .tickFormat(function(d) {return d3.format(&#039;,%&#039;)(d)})
  .axisLabel(&quot;% of trips paid in cash&quot;)

       d3.select(&quot;#&quot; + opts.id)
        .append(&#039;svg&#039;)
        .datum(data)
        .transition().duration(500)
        .call(chart);

       nv.utils.windowResize(chart.update);
       return chart;
      });
    };
&lt;/script&gt;

    &lt;script&gt;&lt;/script&gt;    
  &lt;/body&gt;
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart17242a6d21c'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>


Card usage for NYC yellow cabs peaks during morning and evening commuting hours; cash fares are most likely on weekends, mid-day on weekdays, and after work hours on weekdays. Figure 3 shows that a larger share of Harlem's pickups originate during these times, relative to the rest of Manhattan (excluding holidays). However, adjusting for the time of week would only push Harlem's cash payment rate up by 0.1%[^3], so other reasons must be driving Harlem's high cash payment rates.

##### Figure 3: % of trips paid in cash, by time of week
<iframe srcdoc=' &lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;link rel=&#039;stylesheet&#039; href=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.css&#039;&gt;

    &lt;script src=&#039;//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//d3js.org/d3.v3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//nvd3.org/assets/lib/fisheye.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;

    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto;
      margin-right: auto;
      width: 800px;
      height: 600px;
    }  
    &lt;/style&gt;

  &lt;/head&gt;
  &lt;body &gt;

    &lt;div id = &#039;chart17278f3abd2&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script&gt;
 $(document).ready(function(){
      drawchart17278f3abd2()
    });
    function drawchart17278f3abd2(){  
      var opts = {
 &quot;dom&quot;: &quot;chart17278f3abd2&quot;,
&quot;width&quot;:    800,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;wday_hour&quot;,
&quot;y&quot;: &quot;value&quot;,
&quot;group&quot;: &quot;variable&quot;,
&quot;type&quot;: &quot;multiChart&quot;,
&quot;multi&quot;: {
 &quot;% of all Manhattan trips&quot;: {
 &quot;type&quot;: &quot;line&quot;,
&quot;yAxis&quot;:      2
},
&quot;% of all Harlem trips&quot;: {
 &quot;type&quot;: &quot;line&quot;,
&quot;yAxis&quot;:      2
},
&quot;Difference (Harlem - Manhattan)&quot;: {
 &quot;type&quot;: &quot;bar&quot;,
&quot;yAxis&quot;:      2
},
&quot;% of trips paid in cash (left axis)&quot;: {
 &quot;type&quot;: &quot;line&quot;,
&quot;yAxis&quot;:      1
}
},
&quot;id&quot;: &quot;chart17278f3abd2&quot;
},
        data = [
 {
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              1,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3911879940287
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         1.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3721686303419
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         1.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3613222035748
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          1.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3741379860376
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         1.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.445826954146
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         1.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.5056047252431
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           1.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4867529870715
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         1.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4863317536945
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         1.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4779026054561
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          1.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4806062339331
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         1.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4785410741645
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         1.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4619695261283
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            1.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4560709687283
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         1.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4582801356043
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         1.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.467762027773
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          1.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4625671449208
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         1.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4603545302611
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         1.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4544863178374
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           1.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4443395991696
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         1.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4347966262307
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         1.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4307535917153
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          1.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4303847456362
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         1.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4238925945999
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         1.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4377684575434
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              2,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4562929652224
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         2.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4734740020676
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         2.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4868476842343
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          2.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.5079206666033
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         2.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4983132095602
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         2.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4118203215581
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           2.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3943656213741
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         2.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3738848496531
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         2.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3563642668134
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          2.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3843104209459
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         2.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4451409350588
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         2.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4706264960792
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            2.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4727936227715
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         2.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4741441774022
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         2.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4768056847271
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          2.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4805829055313
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         2.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4742081352991
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         2.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4405702011252
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           2.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4068967273968
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         2.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3906218678093
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         2.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3687192048266
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          2.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3649573272904
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         2.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3695392830204
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         2.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3863607033064
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              3,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4055103620696
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         3.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4285361734832
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         3.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4575056433409
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          3.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.490703609187
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         3.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.5035243822788
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         3.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.415878243668
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           3.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3908757929126
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         3.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3655972244773
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         3.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3402524427598
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          3.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3642449746273
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         3.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4188586134673
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         3.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4427783765364
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            3.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4464677015848
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         3.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4494209199057
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         3.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.453606068521
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          3.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4611053826961
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         3.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4610778811598
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         3.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4286218430663
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           3.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3956363142576
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         3.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3685456790952
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         3.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3482058197602
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          3.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3510614729293
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         3.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3474658117652
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         3.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3607137477652
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              4,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.381204127638
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         4.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4050750304802
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         4.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4340126040756
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          4.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4678649879082
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         4.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.493991111775
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         4.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4095172217362
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           4.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;:  0.38541084805
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         4.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3570378512056
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         4.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3321803282346
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          4.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3530708327889
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         4.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4097976484206
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         4.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4336274813118
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            4.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4388478866464
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         4.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4423378513823
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         4.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4402462075852
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          4.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4502706165945
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         4.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4527700591654
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         4.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4248896635568
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           4.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3912696440819
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         4.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3699049262359
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         4.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3501157874702
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          4.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3469215735245
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         4.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.345023369177
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         4.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3574900076394
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3689909774324
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         5.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3956457280914
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         5.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4272621782272
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          5.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4584136460039
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         5.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4860597871981
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         5.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4097776691913
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           5.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3824539753651
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         5.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3562555333945
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         5.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3292414953639
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          5.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3488925205901
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         5.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4053603856027
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         5.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4276851904112
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            5.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4320937672709
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         5.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4361977173047
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         5.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4401427758812
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          5.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4499738893294
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         5.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4528207701447
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         5.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4267315346307
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           5.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3931878443645
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         5.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3713103008628
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         5.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3527033848216
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          5.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3534753848508
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         5.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3464606314492
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         5.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3466438133273
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              6,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.352698763808
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         6.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3686738848961
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         6.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3987944804538
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          6.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4335822434598
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         6.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.476409319874
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         6.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4213662961483
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           6.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3877304948199
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         6.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3560058744108
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         6.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3300678107563
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          6.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.352143785149
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         6.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.412685117335
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         6.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4397927500354
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            6.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4425075338804
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         6.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4490265027163
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         6.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4548869287658
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          6.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4654795705078
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         6.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4664970380744
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         6.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4384721311147
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           6.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4125526937134
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         6.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4001526622578
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         6.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.380729628437
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          6.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3926969193555
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         6.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3970095866206
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         6.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3854991547965
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              7,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.375750018232
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         7.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3614940787431
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         7.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.356393165035
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          7.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3715435464791
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         7.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4465320897485
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         7.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4912645976059
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           7.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4809720826089
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         7.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4572556505141
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         7.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4505616191091
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          7.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4584075203724
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         7.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4664672847789
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         7.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4652109666315
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            7.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4638818427012
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         7.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4735312309416
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         7.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4739496173128
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          7.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4819752903577
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         7.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4903946703268
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         7.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4829313060749
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           7.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4633684252241
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         7.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.450966115169
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         7.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4235370035362
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          7.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4300999579901
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         7.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4264979716947
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         7.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4091624596553
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              1,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01060991841568
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         1.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008922843893327
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         1.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006513746690141
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          1.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005682926071095
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         1.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004951012668601
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         1.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003526748750237
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           1.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003816405598714
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         1.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004881777617014
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         1.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006212786159772
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          1.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009168698974473
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         1.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01064665538182
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         1.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009982564070682
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            1.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009028815911063
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         1.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00902175110988
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         1.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008247448900293
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          1.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006650803833079
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         1.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006236806483792
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         1.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008586559357047
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           1.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008022788222694
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         1.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006752536970105
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         1.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006765253612233
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          1.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006823184981928
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         1.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007025238295744
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         1.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006728516646085
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              2,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005322621210794
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         2.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003395343448245
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         2.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002209869809844
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          2.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001589580266032
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         2.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00194705920586
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         2.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003186225333247
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           2.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006314519296798
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         2.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01113271370317
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         2.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009540307516666
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          2.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004535602359078
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         2.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003143836526152
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         2.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003372736084461
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            2.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003833361121551
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         2.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00420638262398
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         2.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004100410606245
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          2.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003823470399896
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         2.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003569137557331
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         2.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006390819149567
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           2.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006246697205447
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         2.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004905797941034
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         2.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005153065982417
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          2.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005649015025419
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         2.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005507719001772
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         2.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005427180268293
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              3,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004617554052794
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         3.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003258286305307
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         3.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002109549633054
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          3.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001455349043567
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         3.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001742179971571
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         3.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002873961120986
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           3.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006239632404265
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         3.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01195223064033
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         3.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01036123741406
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          3.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004823846247319
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         3.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003157966128517
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         3.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003303501032874
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            3.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003855968485335
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         3.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004029762594421
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         3.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004101823566481
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          3.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003519683949054
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         3.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003492837704561
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         3.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006821772021692
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           3.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006720038884666
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         3.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005243495437551
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         3.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005249147278497
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          3.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005629233582109
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         3.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005735205599844
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         3.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005941497794369
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              4,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004692440945327
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         4.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003287958470273
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         4.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002129331076365
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          4.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001494911930188
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         4.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001719572607788
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         4.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002745381739467
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           4.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006649390872842
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         4.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01260643122981
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         4.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01051948896054
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          4.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005292949045828
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         4.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003512619147872
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         4.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003391104567535
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            4.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003974657145199
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         4.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004178123419251
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         4.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00391813873574
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          4.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003425015613211
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         4.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003441971136048
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         4.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007785410902966
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           4.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008312445071171
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         4.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006441685718081
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         4.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005900521947511
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          4.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.0068104683398
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         4.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006799164657908
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         4.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006560374377944
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004798412963062
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         5.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003283719589563
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         5.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002329971429944
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          5.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001609361709343
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         5.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001794459500321
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         5.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002926240649736
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           5.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006818946101219
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         5.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01305575258501
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         5.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01068763122868
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          5.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005041442123736
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         5.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003403821209664
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         5.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003417950812028
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            5.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003858794405808
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         5.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004093345805062
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         5.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004101823566481
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          5.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003628481887263
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         5.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003634133728209
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         5.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007743022095872
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           5.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00824462297982
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         5.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00634984330271
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         5.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006202895438117
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          5.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006748298089395
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         5.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007162295438682
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         5.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007754325777764
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              6,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006137899267239
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         6.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00428268247675
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         6.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002955912814702
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          6.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002304538145688
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         6.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002411923123659
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         6.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003323282476185
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           6.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006844379385475
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         6.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01315042092085
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         6.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01099141767952
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          6.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00537631369978
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         6.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003742931666417
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         6.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003847490723916
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            6.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00467124654178
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         6.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005247734318261
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         6.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005849655378998
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          6.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004975032992622
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         6.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004569513404754
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         6.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009459768783187
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           6.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01029058940223
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         6.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008924256853564
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         6.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007348806189896
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          6.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007434996764321
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         6.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008212124894381
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         6.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01000517143447
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              7,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01033721709004
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         7.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008361898679447
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         7.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006437446837371
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          7.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005137523419816
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         7.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004635922535868
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         7.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003703368779796
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           7.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004318006482662
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         7.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005585431814778
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         7.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007854645954554
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          7.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008856434762213
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         7.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008484826220021
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         7.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007789649783676
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            7.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008001593819147
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         7.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007822147869115
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         7.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006960242124866
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          7.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006310280416089
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         7.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00539609514309
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         7.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008631774084614
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           7.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008716551698802
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         7.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008327987633772
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         7.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007327611786349
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          7.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007440648605267
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         7.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008908714290962
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         7.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01078371252476
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              1,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007865140834661
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         1.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007088803881462
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         1.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005780127990235
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          1.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004555445062613
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         1.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002863499426497
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         1.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001304031481805
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           1.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001235558233125
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         1.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001639391751672
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         1.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002509543353067
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          1.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003789989470209
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         1.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00516954861657
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         1.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006068432581335
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            1.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006574679263565
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         1.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006521289748742
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         1.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006464957361718
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          1.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006044477843824
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         1.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005525303111901
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         1.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006031985775197
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           1.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006571185359736
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         1.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006179189938216
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         1.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005593413043025
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          1.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005274735104262
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         1.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004837676195239
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         1.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003828858393386
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              2,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002628432967905
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         2.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001628304510928
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         2.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001099659301384
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          2.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0007644928008808
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         2.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0008059170575328
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         2.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00121686554488
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           2.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003110410037408
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         2.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005246081459696
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         2.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006251798951739
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          2.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006158347621099
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         2.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005515862910743
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         2.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005501990235405
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            2.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005776107275951
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         2.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005724534348908
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         2.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006048553055741
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          2.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005936602806219
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         2.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005192994709503
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         2.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006410399175424
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           2.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007844710277441
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         2.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00782360152745
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         2.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007248318454329
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          2.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006891413453404
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         2.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00610107060843
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         2.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00445744015194
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              3,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002862833344312
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         3.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001717565579091
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         3.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001072997848082
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          3.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0007142157064529
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         3.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0007138766100675
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         3.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001169319387413
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           3.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003365907053221
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         3.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006079023288086
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         3.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007284789481637
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          3.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006988976327718
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         3.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006218658335359
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         3.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006112793654896
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            3.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006358462930825
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         3.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006235879587503
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         3.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006560867141152
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          3.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006113344686523
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         3.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004920046340428
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         3.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006314362234845
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           3.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008115842058737
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         3.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008477246142061
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         3.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008046587677312
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          3.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007953657101835
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         3.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007222801451328
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         3.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005547725860385
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              4,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003548407516783
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         4.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002095894205222
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         4.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001316360057532
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          4.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0008738574404644
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         4.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0008107128492691
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         4.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001190543187964
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           4.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003382195790305
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         4.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006170282602806
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         4.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007327939496679
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          4.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007090559916315
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         4.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006402969331408
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         4.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006400147565058
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            4.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006571027922129
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         4.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006397882885627
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         4.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006573552979142
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          4.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006124286600244
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         4.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004940204409481
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         4.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00638531815349
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           4.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008140117726756
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         4.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00877336206061
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         4.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00839883615823
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          4.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008340511579942
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         4.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007781208423983
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         4.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006285654092646
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004063676584982
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         5.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002426137752844
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         5.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001534181042809
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          5.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001002144869412
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         5.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0008963346865822
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         5.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001239215629853
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           5.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003425000653669
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         5.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006114501247408
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         5.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007189588171436
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          5.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0069250324379
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         5.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006288917895355
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         5.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006222527667328
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            5.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006431441317197
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         5.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006248686531345
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         5.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006504177491865
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          5.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005948459069123
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         5.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004658082272122
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         5.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006055171490549
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           5.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007906189663172
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         5.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00862477729088
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         5.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008421325514933
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          5.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008351283945471
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         5.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007941461742546
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         5.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007108077877796
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              6,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005376421632833
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         6.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003549618575303
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         6.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002333673434897
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          6.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001556131478471
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         6.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001206916699144
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         6.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001288354329273
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           6.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003153814374739
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         6.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00562399832593
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         6.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006805319303269
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          6.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006650897231475
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         6.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006065356492696
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         6.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006080712714721
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            6.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006184791083867
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         6.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006016744603732
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         6.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006374134028064
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          6.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005756227750357
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         6.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004604959190174
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         6.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006046300486895
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           6.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007863051758716
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         6.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008662756086044
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         6.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008236735975425
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          6.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008008021518766
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         6.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008149418656185
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         6.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007995359901947
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              7,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007555812267667
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         7.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006515216290268
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         7.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005407000860445
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          7.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00403874089007
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         7.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002556017723745
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         7.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001241849682133
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           7.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001403562326212
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         7.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002093708244595
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         7.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003237250251425
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          7.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004693263522107
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         7.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005681275338599
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         7.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006466410631941
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            7.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006941811653684
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         7.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00699982741205
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         7.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006788104106417
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          7.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006705273758991
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         7.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005761629071353
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         7.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006630999540004
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           7.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00794559750739
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         7.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008424377382402
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         7.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00768523203633
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          7.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007552911782513
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         7.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008123259792168
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         7.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008393713380694
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              1,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002744777581015
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         1.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001834040011865
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         1.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007336186999055
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          1.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001127481008481
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         1.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002087513242104
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         1.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002222717268431
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           1.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002580847365588
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         1.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003242385865343
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         1.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003703242806705
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          1.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.005378709504264
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         1.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.005477106765255
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         1.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003914131489347
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            1.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002454136647498
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         1.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002500461361138
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         1.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001782491538575
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          1.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0006063259892549
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         1.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007115033718911
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         1.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002554573581849
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           1.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001451602862957
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         1.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0005733470318888
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         1.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001171840569208
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          1.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001548449877666
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         1.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002187562100505
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         1.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002899658252699
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              2,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002694188242889
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         2.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001767038937317
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         2.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00111021050846
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          2.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0008250874651514
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         2.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001141142148327
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         2.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001969359788367
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           2.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00320410925939
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         2.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.005886632243475
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         2.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003288508564927
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          2.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001622745262021
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         2.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002372026384591
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         2.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002129254150944
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            2.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0019427461544
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         2.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001518151724927
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         2.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001948142449496
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          2.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002113132406323
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         2.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001623857152172
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         2.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -1.958002585667e-05
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           2.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001598013071994
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         2.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002917803586416
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         2.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002095252471912
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          2.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001242398427985
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         2.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0005933516066578
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         2.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0009697401163525
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              3,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001754720708482
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         3.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001540720726215
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         3.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001036551784972
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          3.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007411333371143
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         3.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001028303361504
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         3.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001704641733573
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           3.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002873725351044
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         3.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.005873207352239
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         3.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00307644793242
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          3.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002165130080399
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         3.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.003060692206842
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         3.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002809292622022
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            3.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00250249444549
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         3.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002206116993082
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         3.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002459043574671
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          3.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002593660737468
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         3.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001427208635866
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         3.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0005074097868465
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           3.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001395803174072
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         3.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00323375070451
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         3.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002797440398815
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          3.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002324423519727
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         3.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001487595851484
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         3.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0003937719339837
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              4,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001144033428543
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         4.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001192064265051
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         4.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0008129710188333
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          4.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0006210544897241
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         4.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0009088597585185
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         4.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001554838551504
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           4.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003267195082537
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         4.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.006436148627006
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         4.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003191549463863
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          4.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001797610870487
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         4.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002890350183536
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         4.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.003009042997523
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            4.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00259637077693
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         4.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002219759466377
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         4.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002655414243402
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          4.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002699270987034
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         4.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001498233273433
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         4.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001400092749476
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           4.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0001723273444144
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         4.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00233167634253
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         4.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002498314210719
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          4.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001530043240142
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         4.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0009820437660744
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         4.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0002747202852985
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007347363780808
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         5.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.000857581836719
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         5.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007957903871347
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          5.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.000607216839931
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         5.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0008981248137385
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         5.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001687025019882
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           5.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00339394544755
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         5.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.006941251337602
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         5.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003498043057246
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          5.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001883590314164
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         5.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002885096685692
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         5.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0028045768553
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            5.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002572646911389
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         5.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002155340726282
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         5.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002402353925383
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          5.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00231997718186
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         5.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001023948543913
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         5.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001687850605323
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           5.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0003384333166478
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         5.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00227493398817
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         5.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002218430076817
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          5.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001602985856076
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         5.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0007791663038646
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         5.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0006462478999677
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              6,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007614776344057
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         6.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.000733063901447
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         6.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0006222393798043
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          6.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007484066672162
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         6.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001205006424515
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         6.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002034928146911
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           6.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003690565010736
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         6.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.007526422594925
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         6.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.004186098376255
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          6.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001274583531696
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         6.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002322424826279
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         6.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002233221990804
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            6.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001513544542088
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         6.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0007690102854713
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         6.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.000524478649066
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          6.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0007811947577357
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         6.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -3.544578542012e-05
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         6.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003413468296292
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           6.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002427537643518
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         6.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0002615007675192
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         6.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0008879297855284
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          6.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0005730247544449
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         6.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 6.27062381967e-05
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         6.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002009811532519
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              7,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00278140482237
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         7.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001846682389179
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         7.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001030445976926
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          7.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001098782529746
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         7.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002079904812123
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         7.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002461519097663
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           7.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002914444156449
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         7.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003491723570183
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         7.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.004617395703129
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          7.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.004163171240106
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         7.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002803550881422
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         7.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001323239151735
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            7.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001059782165462
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         7.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0008223204570642
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         7.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0001721380184489
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          7.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0003949933429026
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         7.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0003655339282627
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         7.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00200077454461
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           7.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007709541914124
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         7.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -9.638974862988e-05
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         7.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0003576202499805
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          7.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0001122631772461
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         7.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007854544987944
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         7.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002389999144068
}
]
      if(!(opts.type===&#039;pieChart&#039;)) {
        var data = d3.nest()
          .key(function(d){
            return opts.group === undefined ? &#039;main&#039; : d[opts.group]
          })
          .entries(data);
      }
      //loop through to give an expected x and y
      //then give the type and yAxis hopefully provided by R
      data.forEach(function(variables) {
        variables.values.forEach(function(values){
                values.x = values[opts.x];
                values.y = values[opts.y];
            });
        variables.type = opts.multi[variables.key].type;
        variables.yAxis = opts.multi[variables.key].yAxis;
        });
      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          //.x(function(d) { return d[opts.x] })
          //.y(function(d) { return d[opts.y] })
          .width(730)
          .height(600)

        chart.xAxis
  .tickFormat(function(d) {
        return d3.format(&#039;,0.0&#039;)(d);
      })
  .showMaxMin(false)
  .axisLabel(&quot;Day of week (Sunday = 1)&quot;)

        chart.yDomain2( [-0.01, 0.03] );
        chart.yAxis2.tickFormat(d3.format(&#039;,.1%&#039;))
        chart.yDomain1 ( [ 0, .52] );
        chart.yAxis1.tickFormat(d3.format(&#039;,.0%&#039;))

       d3.select(&#039;#&#039; + opts.id)
        .append(&#039;svg&#039;)
        .datum(data)
        .transition().duration(350)
        .call(chart);
       nv.utils.windowResize(chart.update);
       return chart;
      });
    };
&lt;/script&gt;

    &lt;script&gt;&lt;/script&gt;    
  &lt;/body&gt;
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart17278f3abd2'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>



### Best / worst tippers

* __Definition:__ average tip percentage
* __Scope:__ Manhattan pickups paid by card[^4]
* __Best tippers:__ Midtown pickups
* __Worst tippers:__ East Harlem pickups

Adjusting the average Harlem tip % for [time of week](http://www.bloomberg.com/news/articles/2014-07-31/heres-how-much-you-should-be-tipping-your-cab-driver), using the same methodology as above, suggests that only 0.1 percentage points of the difference are attributable to the time-of-week distribution of rides.


If you're a taxi driver, this doesn't necessarily mean you'll want to be cruising Midtown for passengers. There are a number of other factors you'd want to consider, such as total expected fare (per minute), supply density, etc. Additionally, this post doesn't assign any _reason_ for these average tips. East Harlem pickups may experience worse service on average, they could tip less on average due to [less disposable income](http://www.wnyc.org/story/174508-blog-census-locates-citys-wealthiest-and-poorest-neighborhoods/), or a host of other reasons.

##### Figure 4: Average tip by neighborhood
<iframe srcdoc=' &lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;link rel=&#039;stylesheet&#039; href=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.css&#039;&gt;

    &lt;script src=&#039;//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//d3js.org/d3.v3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//nvd3.org/assets/lib/fisheye.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;

    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto;
      margin-right: auto;
      width: 750px;
      height: 600px;
    }  
    &lt;/style&gt;

  &lt;/head&gt;
  &lt;body &gt;

    &lt;div id = &#039;chart172732cc9b&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart172732cc9b()
    });
    function drawchart172732cc9b(){  
      var opts = {
 &quot;dom&quot;: &quot;chart172732cc9b&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;pick_neigh&quot;,
&quot;y&quot;: &quot;Average tip %&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart172732cc9b&quot;
},
        data = [
 {
 &quot;pick_neigh&quot;: &quot;Midtown&quot;,
&quot;Average tip %&quot;: 0.2000532064985
},
{
 &quot;pick_neigh&quot;: &quot;Murray Hill&quot;,
&quot;Average tip %&quot;: 0.1999933285313
},
{
 &quot;pick_neigh&quot;: &quot;Garment District&quot;,
&quot;Average tip %&quot;: 0.1986610183925
},
{
 &quot;pick_neigh&quot;: &quot;Chelsea&quot;,
&quot;Average tip %&quot;: 0.1948599291091
},
{
 &quot;pick_neigh&quot;: &quot;Central Park&quot;,
&quot;Average tip %&quot;: 0.1948133802807
},
{
 &quot;pick_neigh&quot;: &quot;Soho&quot;,
&quot;Average tip %&quot;: 0.1947640488463
},
{
 &quot;pick_neigh&quot;: &quot;Gramercy&quot;,
&quot;Average tip %&quot;: 0.1939176073255
},
{
 &quot;pick_neigh&quot;: &quot;Greenwich Village&quot;,
&quot;Average tip %&quot;: 0.1938316435802
},
{
 &quot;pick_neigh&quot;: &quot;Clinton&quot;,
&quot;Average tip %&quot;: 0.1923225932674
},
{
 &quot;pick_neigh&quot;: &quot;Upper West Side&quot;,
&quot;Average tip %&quot;: 0.1917668006756
},
{
 &quot;pick_neigh&quot;: &quot;East Village&quot;,
&quot;Average tip %&quot;: 0.1915905917914
},
{
 &quot;pick_neigh&quot;: &quot;Little Italy&quot;,
&quot;Average tip %&quot;: 0.1913792770122
},
{
 &quot;pick_neigh&quot;: &quot;West Village&quot;,
&quot;Average tip %&quot;: 0.1913003138824
},
{
 &quot;pick_neigh&quot;: &quot;Carnegie Hill&quot;,
&quot;Average tip %&quot;: 0.1904352981879
},
{
 &quot;pick_neigh&quot;: &quot;North Sutton Area&quot;,
&quot;Average tip %&quot;: 0.1902838409952
},
{
 &quot;pick_neigh&quot;: &quot;Tribeca&quot;,
&quot;Average tip %&quot;: 0.1902079243659
},
{
 &quot;pick_neigh&quot;: &quot;Upper East Side&quot;,
&quot;Average tip %&quot;: 0.1895702235166
},
{
 &quot;pick_neigh&quot;: &quot;Financial District&quot;,
&quot;Average tip %&quot;: 0.1878900727477
},
{
 &quot;pick_neigh&quot;: &quot;Lower East Side&quot;,
&quot;Average tip %&quot;: 0.1877114169207
},
{
 &quot;pick_neigh&quot;: &quot;Morningside Heights&quot;,
&quot;Average tip %&quot;: 0.185724460059
},
{
 &quot;pick_neigh&quot;: &quot;Chinatown&quot;,
&quot;Average tip %&quot;: 0.1854796596942
},
{
 &quot;pick_neigh&quot;: &quot;Battery Park&quot;,
&quot;Average tip %&quot;: 0.1852247620234
},
{
 &quot;pick_neigh&quot;: &quot;Yorkville&quot;,
&quot;Average tip %&quot;: 0.1784455706598
},
{
 &quot;pick_neigh&quot;: &quot;Harlem&quot;,
&quot;Average tip %&quot;: 0.1761562660446
},
{
 &quot;pick_neigh&quot;: &quot;Inwood&quot;,
&quot;Average tip %&quot;: 0.1749750162101
},
{
 &quot;pick_neigh&quot;: &quot;Washington Heights&quot;,
&quot;Average tip %&quot;: 0.1739635013795
},
{
 &quot;pick_neigh&quot;: &quot;Hamilton Heights&quot;,
&quot;Average tip %&quot;: 0.1717436154083
},
{
 &quot;pick_neigh&quot;: &quot;East Harlem&quot;,
&quot;Average tip %&quot;: 0.1699779160399
}
]

      if(!(opts.type===&quot;pieChart&quot; || opts.type===&quot;sparklinePlus&quot; || opts.type===&quot;bulletChart&quot;)) {
        var data = d3.nest()
          .key(function(d){
            //return opts.group === undefined ? &#039;main&#039; : d[opts.group]
            //instead of main would think a better default is opts.x
            return opts.group === undefined ? opts.y : d[opts.group];
          })
          .entries(data);
      }

      if (opts.disabled != undefined){
        data.map(function(d, i){
          d.disabled = opts.disabled[i]
        })
      }

      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          .width(opts.width)
          .height(opts.height)

        if (opts.type != &quot;bulletChart&quot;){
          chart
            .x(function(d) { return d[opts.x] })
            .y(function(d) { return d[opts.y] })
        }


        chart
  .stacked(true)
  .margin({
 &quot;left&quot;:    140,
&quot;right&quot;:     50
})
  .showControls(false)
  .showLegend(false)





        chart.yAxis
  .tickFormat(function(d) {return d3.format(&#039;,%&#039;)(d)})
  .axisLabel(&quot;Average tip %&quot;)

       d3.select(&quot;#&quot; + opts.id)
        .append(&#039;svg&#039;)
        .datum(data)
        .transition().duration(500)
        .call(chart);

       nv.utils.windowResize(chart.update);
       return chart;
      });
    };
&lt;/script&gt;

    &lt;script&gt;&lt;/script&gt;    
  &lt;/body&gt;
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart172732cc9b'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>

### Furthest / shortest travelers
* __Definition:__ average distance traveled
* __Scope:__ Manhattan pickups
* __Furthest travelers__: Financial District pickups
* __Shortest travelers__: Gramercy pickups

Where are Financial District and Gramercy pickups going that makes their average trip so long / short, respectively? Midtown. Midtown dropoffs account for 12% of trips from the Financial District and 16% of trips from Gramercy[^5].

##### Figure 5: Average distance traveled by pickup neighborhood
<iframe srcdoc=' &lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;link rel=&#039;stylesheet&#039; href=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.css&#039;&gt;

    &lt;script src=&#039;//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//d3js.org/d3.v3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//nvd3.org/assets/lib/fisheye.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;

    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto;
      margin-right: auto;
      width: 750px;
      height: 600px;
    }  
    &lt;/style&gt;

  &lt;/head&gt;
  &lt;body &gt;

    &lt;div id = &#039;chart17223c50130&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart17223c50130()
    });
    function drawchart17223c50130(){  
      var opts = {
 &quot;dom&quot;: &quot;chart17223c50130&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;pick_neigh&quot;,
&quot;y&quot;: &quot;Average distance&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart17223c50130&quot;
},
        data = [
 {
 &quot;pick_neigh&quot;: &quot;Financial District&quot;,
&quot;Average distance&quot;:            5.6
},
{
 &quot;pick_neigh&quot;: &quot;Little Italy&quot;,
&quot;Average distance&quot;:            4.5
},
{
 &quot;pick_neigh&quot;: &quot;Washington Heights&quot;,
&quot;Average distance&quot;:            4.4
},
{
 &quot;pick_neigh&quot;: &quot;Inwood&quot;,
&quot;Average distance&quot;:            4.4
},
{
 &quot;pick_neigh&quot;: &quot;Battery Park&quot;,
&quot;Average distance&quot;:              4
},
{
 &quot;pick_neigh&quot;: &quot;Soho&quot;,
&quot;Average distance&quot;:            3.5
},
{
 &quot;pick_neigh&quot;: &quot;Hamilton Heights&quot;,
&quot;Average distance&quot;:            3.4
},
{
 &quot;pick_neigh&quot;: &quot;Murray Hill&quot;,
&quot;Average distance&quot;:            3.3
},
{
 &quot;pick_neigh&quot;: &quot;Morningside Heights&quot;,
&quot;Average distance&quot;:              3
},
{
 &quot;pick_neigh&quot;: &quot;Lower East Side&quot;,
&quot;Average distance&quot;:              3
},
{
 &quot;pick_neigh&quot;: &quot;Chinatown&quot;,
&quot;Average distance&quot;:              3
},
{
 &quot;pick_neigh&quot;: &quot;Tribeca&quot;,
&quot;Average distance&quot;:              3
},
{
 &quot;pick_neigh&quot;: &quot;Midtown&quot;,
&quot;Average distance&quot;:            2.9
},
{
 &quot;pick_neigh&quot;: &quot;Harlem&quot;,
&quot;Average distance&quot;:            2.8
},
{
 &quot;pick_neigh&quot;: &quot;East Harlem&quot;,
&quot;Average distance&quot;:            2.8
},
{
 &quot;pick_neigh&quot;: &quot;East Village&quot;,
&quot;Average distance&quot;:            2.7
},
{
 &quot;pick_neigh&quot;: &quot;Yorkville&quot;,
&quot;Average distance&quot;:            2.7
},
{
 &quot;pick_neigh&quot;: &quot;Clinton&quot;,
&quot;Average distance&quot;:            2.6
},
{
 &quot;pick_neigh&quot;: &quot;West Village&quot;,
&quot;Average distance&quot;:            2.5
},
{
 &quot;pick_neigh&quot;: &quot;Garment District&quot;,
&quot;Average distance&quot;:            2.4
},
{
 &quot;pick_neigh&quot;: &quot;Chelsea&quot;,
&quot;Average distance&quot;:            2.4
},
{
 &quot;pick_neigh&quot;: &quot;Greenwich Village&quot;,
&quot;Average distance&quot;:            2.4
},
{
 &quot;pick_neigh&quot;: &quot;Upper West Side&quot;,
&quot;Average distance&quot;:            2.4
},
{
 &quot;pick_neigh&quot;: &quot;Central Park&quot;,
&quot;Average distance&quot;:            2.3
},
{
 &quot;pick_neigh&quot;: &quot;North Sutton Area&quot;,
&quot;Average distance&quot;:            2.3
},
{
 &quot;pick_neigh&quot;: &quot;Gramercy&quot;,
&quot;Average distance&quot;:            2.3
},
{
 &quot;pick_neigh&quot;: &quot;Upper East Side&quot;,
&quot;Average distance&quot;:            2.3
},
{
 &quot;pick_neigh&quot;: &quot;Carnegie Hill&quot;,
&quot;Average distance&quot;:            2.2
}
]

      if(!(opts.type===&quot;pieChart&quot; || opts.type===&quot;sparklinePlus&quot; || opts.type===&quot;bulletChart&quot;)) {
        var data = d3.nest()
          .key(function(d){
            //return opts.group === undefined ? &#039;main&#039; : d[opts.group]
            //instead of main would think a better default is opts.x
            return opts.group === undefined ? opts.y : d[opts.group];
          })
          .entries(data);
      }

      if (opts.disabled != undefined){
        data.map(function(d, i){
          d.disabled = opts.disabled[i]
        })
      }

      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          .width(opts.width)
          .height(opts.height)

        if (opts.type != &quot;bulletChart&quot;){
          chart
            .x(function(d) { return d[opts.x] })
            .y(function(d) { return d[opts.y] })
        }


        chart
  .stacked(true)
  .margin({
 &quot;left&quot;:    140,
&quot;right&quot;:     50
})
  .showControls(false)
  .showLegend(false)





        chart.yAxis
  .tickFormat(function(d) {return d3.format(&#039;,.0&#039;)(d)})
  .axisLabel(&quot;Average distance per pickup (miles)&quot;)

       d3.select(&quot;#&quot; + opts.id)
        .append(&#039;svg&#039;)
        .datum(data)
        .transition().duration(500)
        .call(chart);

       nv.utils.windowResize(chart.update);
       return chart;
      });
    };
&lt;/script&gt;

    &lt;script&gt;&lt;/script&gt;    
  &lt;/body&gt;
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart17223c50130'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>

### Party index
* __Definition:__ ratio of outbound to inbound trips Saturdays and Sundays before 5:00 AM
* __Scope:__ Manhattan outbound neighborhoods, all inbound neighborhoods
* __Biggest party neighborhood:__ Lower East Side

This party index identifies neighborhoods where more more trips leave a given neighborhood than enter that neighborhood early Saturday and Sunday mornings (presumably after a late night out Friday and Saturday, respectively). Todd Schneider uses a slightly different index of late night activity [here](http://toddwschneider.com/posts/analyzing-1-1-billion-nyc-taxi-and-uber-trips-with-a-vengeance/#late-night-taxi-index), which identifies late night hotspots by comparing neighborhood pickup volumes during Friday and Saturday nights to volumes during other times of the week. I created my index in order to better measure neighborhoods with naturally high volumes during non-party hours[^6].

##### Table 2: Top 5 party destinations

|Neighborhood      |Trips out:in ratio |Incoming trips |Outbound trips |
|:-----------------|:------------------|:--------------|:--------------|
|Lower East Side   |2.1                |390,667        |838,364        |
|Little Italy      |2.0                |97,469         |196,477        |
|West Village      |1.8                |291,217        |535,312        |
|East Village      |1.7                |566,563        |981,213        |
|Greenwich Village |1.7                |419,599        |718,556        |


### Most / least diverse
* __Definition:__ [Shannon diversity index](http://www.itl.nist.gov/div898/software/dataplot/refman2/auxillar/shannon.htm)
* __Scope:__ Manhattan dropoffs, all non-missing pickup locations
* __Most diverse:__ Chinatown dropoffs
* __Least diverse:__ Carnegie Hill dropoffs

The Shannon diversity index gives weight to both the abundance and evenness of pickup neighborhoods for any given dropoff neighborhood. The top three pickup neighborhoods for Carnegie Hill dropoffs account for 71% of volume (unsurprisingly 41% is from the Upper East Side) but the top three pickup neighborhoods for Chinatown droppoffs only account for 30% of volume.

##### Figure 6: Diversity of dropoffs by neighborhood
<iframe srcdoc=' &lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;link rel=&#039;stylesheet&#039; href=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.css&#039;&gt;

    &lt;script src=&#039;//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//d3js.org/d3.v3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//cdnjs.cloudflare.com/ajax/libs/nvd3/1.1.15-beta/nv.d3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;//nvd3.org/assets/lib/fisheye.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;

    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto;
      margin-right: auto;
      width: 750px;
      height: 600px;
    }  
    &lt;/style&gt;

  &lt;/head&gt;
  &lt;body &gt;

    &lt;div id = &#039;chart17261b84e63&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart17261b84e63()
    });
    function drawchart17261b84e63(){  
      var opts = {
 &quot;dom&quot;: &quot;chart17261b84e63&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;drop_neigh&quot;,
&quot;y&quot;: &quot;Shannon diversity index&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart17261b84e63&quot;
},
        data = [
 {
 &quot;drop_neigh&quot;: &quot;Chinatown&quot;,
&quot;Shannon diversity index&quot;:           2.94
},
{
 &quot;drop_neigh&quot;: &quot;Financial District&quot;,
&quot;Shannon diversity index&quot;:          2.909
},
{
 &quot;drop_neigh&quot;: &quot;Inwood&quot;,
&quot;Shannon diversity index&quot;:          2.906
},
{
 &quot;drop_neigh&quot;: &quot;Lower East Side&quot;,
&quot;Shannon diversity index&quot;:          2.902
},
{
 &quot;drop_neigh&quot;: &quot;Tribeca&quot;,
&quot;Shannon diversity index&quot;:          2.891
},
{
 &quot;drop_neigh&quot;: &quot;Battery Park&quot;,
&quot;Shannon diversity index&quot;:          2.865
},
{
 &quot;drop_neigh&quot;: &quot;Little Italy&quot;,
&quot;Shannon diversity index&quot;:          2.863
},
{
 &quot;drop_neigh&quot;: &quot;Soho&quot;,
&quot;Shannon diversity index&quot;:          2.829
},
{
 &quot;drop_neigh&quot;: &quot;West Village&quot;,
&quot;Shannon diversity index&quot;:          2.816
},
{
 &quot;drop_neigh&quot;: &quot;Harlem&quot;,
&quot;Shannon diversity index&quot;:          2.806
},
{
 &quot;drop_neigh&quot;: &quot;East Village&quot;,
&quot;Shannon diversity index&quot;:          2.796
},
{
 &quot;drop_neigh&quot;: &quot;Greenwich Village&quot;,
&quot;Shannon diversity index&quot;:           2.79
},
{
 &quot;drop_neigh&quot;: &quot;Washington Heights&quot;,
&quot;Shannon diversity index&quot;:          2.788
},
{
 &quot;drop_neigh&quot;: &quot;Hamilton Heights&quot;,
&quot;Shannon diversity index&quot;:          2.767
},
{
 &quot;drop_neigh&quot;: &quot;Chelsea&quot;,
&quot;Shannon diversity index&quot;:          2.754
},
{
 &quot;drop_neigh&quot;: &quot;Gramercy&quot;,
&quot;Shannon diversity index&quot;:          2.698
},
{
 &quot;drop_neigh&quot;: &quot;Murray Hill&quot;,
&quot;Shannon diversity index&quot;:          2.659
},
{
 &quot;drop_neigh&quot;: &quot;Garment District&quot;,
&quot;Shannon diversity index&quot;:          2.638
},
{
 &quot;drop_neigh&quot;: &quot;Midtown&quot;,
&quot;Shannon diversity index&quot;:          2.621
},
{
 &quot;drop_neigh&quot;: &quot;East Harlem&quot;,
&quot;Shannon diversity index&quot;:          2.615
},
{
 &quot;drop_neigh&quot;: &quot;Clinton&quot;,
&quot;Shannon diversity index&quot;:          2.609
},
{
 &quot;drop_neigh&quot;: &quot;Yorkville&quot;,
&quot;Shannon diversity index&quot;:          2.461
},
{
 &quot;drop_neigh&quot;: &quot;Central Park&quot;,
&quot;Shannon diversity index&quot;:          2.431
},
{
 &quot;drop_neigh&quot;: &quot;North Sutton Area&quot;,
&quot;Shannon diversity index&quot;:          2.401
},
{
 &quot;drop_neigh&quot;: &quot;Morningside Heights&quot;,
&quot;Shannon diversity index&quot;:          2.387
},
{
 &quot;drop_neigh&quot;: &quot;Upper West Side&quot;,
&quot;Shannon diversity index&quot;:          2.331
},
{
 &quot;drop_neigh&quot;: &quot;Upper East Side&quot;,
&quot;Shannon diversity index&quot;:          2.316
},
{
 &quot;drop_neigh&quot;: &quot;Carnegie Hill&quot;,
&quot;Shannon diversity index&quot;:          2.099
}
]

      if(!(opts.type===&quot;pieChart&quot; || opts.type===&quot;sparklinePlus&quot; || opts.type===&quot;bulletChart&quot;)) {
        var data = d3.nest()
          .key(function(d){
            //return opts.group === undefined ? &#039;main&#039; : d[opts.group]
            //instead of main would think a better default is opts.x
            return opts.group === undefined ? opts.y : d[opts.group];
          })
          .entries(data);
      }

      if (opts.disabled != undefined){
        data.map(function(d, i){
          d.disabled = opts.disabled[i]
        })
      }

      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          .width(opts.width)
          .height(opts.height)

        if (opts.type != &quot;bulletChart&quot;){
          chart
            .x(function(d) { return d[opts.x] })
            .y(function(d) { return d[opts.y] })
        }


        chart
  .stacked(true)
  .margin({
 &quot;left&quot;:    140,
&quot;right&quot;:     50
})
  .showControls(false)
  .showLegend(false)





        chart.yAxis
  .tickFormat(function(d) {return d3.format(&#039;0.0&#039;)(d)})
  .axisLabel(&quot;Shannon diversity index&quot;)

       d3.select(&quot;#&quot; + opts.id)
        .append(&#039;svg&#039;)
        .datum(data)
        .transition().duration(500)
        .call(chart);

       nv.utils.windowResize(chart.update);
       return chart;
      });
    };
&lt;/script&gt;

    &lt;script&gt;&lt;/script&gt;    
  &lt;/body&gt;
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart17261b84e63'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>

_Note: This post is best viewed in Chrome, Firefox, or Safari._

-----------------------------------------------------------------------------

### Footnotes

[^1]: As someone who's lived in each of these three neighborhoods I can vouch for this, especially in [Subway deserts](https://team.carto.com/u/chriswhong/viz/e60e7660-3982-11e5-9997-0e853d047bba/public_map)
[^2]: Unbanked defined as no member of the household having a checking or savings account; as of 2013
[^3]: Adjustment calculated as the sum product of the difference in time of week distribution and the cash payment rate
[^4]: Total tip as a fraction of total base fare; figures exclude trips not paid for by card, as tips for these fares are rarely recorded
[^5]: Turns out this is no more than average -- 16% of all yellow cab trips in 2014 ended in Midtown
[^6]: Todd's late night index might fail to identify neighborhoods that have high traffic volumes during non-party hours, and might mistakenly identify neighborhoods that have low traffic volumes during non-party hours; conversely, my index might fail to identify neighborhoods that have a lot of party-goers returning from other areas, and might mistakenly identify neighborhoods where no one gets dropped off
