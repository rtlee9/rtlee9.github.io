---
title: "NYC yellow cab trips"
subtitle: "Neighborhood by neighborhood"
layout: post
tags: [NYC, taxi, transportation, open data, R, SQL]
---

In this post I explore NYC yellow cab data neighborhood-by-neighborhood. I examine NYC taxi rides from a neighborhood-centric perspective through a set of superlatives that highlight the diverse nature of NYC neighborhoods, as defined by [Zillow](http://www.zillow.com/howto/api/neighborhood-boundaries.htm). This post focuses on Manhattan neighborhoods, as neighborhoods in other boroughs have relatively low volumes and differ from the average yellow cab trip in other fundamental ways (e.g., higher average distance traveled, low outbound:inbound ratio).

This post uses 2014 yellow cab data sourced from [NYC OpenData](https://data.cityofnewyork.us/view/gn7m-em8n). I used PostgreSQL, PostGIS, and R for the data management, mapping, analysis, and visuals (thanks to [Todd Schneider](https://github.com/toddwschneider/nyc-taxi-data) for his instructions). The charts in this post were made with [rCharts NVD3](http://ramnathv.github.io/posts/rcharts-nvd3/), and the maps were made with [ggmap](https://cran.r-project.org/web/packages/ggmap/index.html).

[![Create droplet]({{ site.url }}/img/Taxi_pick_by_drop.gif)]({{ site.url }}/img/Taxi_pick_by_drop.gif)

## Table of contents

* [Top routes](#routes)
* [Most / least likely to pay in cash](#cash)
* [Best / worst tippers](#tips)
* [Furthest / nearest travelers](#distance)
* [Top party neighborhoods](#party)
* [ Most / least diverse](#diversity)

### Top routes {#routes}
[Table 1](#tab1) outlines the top neighborhood-to-neighborhood routes in 2014. The list is dominated by three neighborhoods: the Upper East Side, Midtown, and the Upper West Side.

#### Table 1: top routes {#tab1}

|Pickup neighborhood |Dropoff neighborhood |     Trips|
|:-------------------|:--------------------|---------:|
|Upper East Side     |Upper East Side      | 6,842,026|
|Midtown             |Midtown              | 5,353,220|
|Upper West Side     |Upper West Side      | 3,975,588|
|Upper East Side     |Midtown              | 3,841,041|
|Midtown             |Upper East Side      | 3,674,126|
|Garment District    |Midtown              | 2,325,547|
|Midtown             |Upper West Side      | 2,144,275|
|Midtown             |Gramercy             | 2,124,474|
|Upper West Side     |Midtown              | 2,074,491|
|Gramercy            |Midtown              | 2,032,735|

Each of these three neighborhoods are geographically large, and likely contain more  people available for pickup than other neighborhoods. Additionally, depending on the destination, public transportation from these neighborhoods can be tricky[^1]. Lastly, it's conceivable that people in these neighborhoods may differ from people in other neighborhoods in a way that increases their propensity to take cabs (e.g., disposable income, preponderance of expense accounts, value of time).

[Figure 1](#fig1) shows the same trip volumes split by time of week. It indicates that there are significant differences in the popularity of certain routes based on the time of week. Likely driven by commuter traffic, routes ending in Midtown are far more popular on weekday mornings than on weekday evenings, while the opposite is true for routes originating from Midtown.

#### Figure 1: top 10 routes by time of week {#fig1}
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

    &lt;div id = &#039;chart1ab5eaf88f6&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart1ab5eaf88f6()
    });
    function drawchart1ab5eaf88f6(){  
      var opts = {
 &quot;dom&quot;: &quot;chart1ab5eaf88f6&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;route&quot;,
&quot;y&quot;: &quot;trips&quot;,
&quot;group&quot;: &quot;tow&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart1ab5eaf88f6&quot;
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
&quot;trips_t&quot;:        2325547,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         523076
},
{
 &quot;route&quot;: &quot;Garment District -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2325547,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         773986
},
{
 &quot;route&quot;: &quot;Garment District -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2325547,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         495326
},
{
 &quot;route&quot;: &quot;Garment District -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2325547,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:         533159
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
&quot;trips_t&quot;:        2124474,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         500598
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Gramercy&quot;,
&quot;trips_t&quot;:        2124474,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         387761
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Gramercy&quot;,
&quot;trips_t&quot;:        2124474,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         414076
},
{
 &quot;route&quot;: &quot;Midtown -&gt; Gramercy&quot;,
&quot;trips_t&quot;:        2124474,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:         822039
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
&quot;trips_t&quot;:        2032735,
&quot;weekend&quot;: &quot;Weekend&quot;,
&quot;tow&quot;: &quot;Weekend&quot;,
&quot;trips&quot;:         478014
},
{
 &quot;route&quot;: &quot;Gramercy -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2032735,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday morning&quot;,
&quot;trips&quot;:         648585
},
{
 &quot;route&quot;: &quot;Gramercy -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2032735,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday midday&quot;,
&quot;trips&quot;:         390045
},
{
 &quot;route&quot;: &quot;Gramercy -&gt; Midtown&quot;,
&quot;trips_t&quot;:        2032735,
&quot;weekend&quot;: &quot;Weekday&quot;,
&quot;tow&quot;: &quot;Weekday evening&quot;,
&quot;trips&quot;:         516091
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
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart1ab5eaf88f6'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>


## Most / least likely to pay in cash {#cash}
* __Definition:__ percent of trips paid in cash
* __Scope:__ Manhattan pickups
* __Most likely to pay in cash__: East Harlem pickups
* __Least likely to pay in cash__: Battery Park pickups

According to the [Urban Institute](http://www.urban.org/interactive-map-where-are-unbanked-and-underbanked-new-york-city), households in Harlem are 2.15 times as likely to be unbanked as the average Manhattan household[^2]. This could be a contributing factor, but it's hard to say how much of the cash-card disparity is caused by underlying household financials.

#### Figure 2: % of trips paid in cash by pickup neighborhood
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

    &lt;div id = &#039;chart1ab2235e611&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart1ab2235e611()
    });
    function drawchart1ab2235e611(){  
      var opts = {
 &quot;dom&quot;: &quot;chart1ab2235e611&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;pick_neigh&quot;,
&quot;y&quot;: &quot;Cash share of trips&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart1ab2235e611&quot;
},
        data = [
 {
 &quot;pick_neigh&quot;: &quot;East Harlem&quot;,
&quot;Cash share of trips&quot;: 0.5789806285938
},
{
 &quot;pick_neigh&quot;: &quot;Inwood&quot;,
&quot;Cash share of trips&quot;: 0.555246847617
},
{
 &quot;pick_neigh&quot;: &quot;Harlem&quot;,
&quot;Cash share of trips&quot;: 0.5012122273901
},
{
 &quot;pick_neigh&quot;: &quot;Garment District&quot;,
&quot;Cash share of trips&quot;: 0.4911659591139
},
{
 &quot;pick_neigh&quot;: &quot;Hamilton Heights&quot;,
&quot;Cash share of trips&quot;: 0.4894092284956
},
{
 &quot;pick_neigh&quot;: &quot;Yorkville&quot;,
&quot;Cash share of trips&quot;: 0.4832644673053
},
{
 &quot;pick_neigh&quot;: &quot;Chinatown&quot;,
&quot;Cash share of trips&quot;: 0.4767610403801
},
{
 &quot;pick_neigh&quot;: &quot;Washington Heights&quot;,
&quot;Cash share of trips&quot;: 0.4720373778848
},
{
 &quot;pick_neigh&quot;: &quot;Central Park&quot;,
&quot;Cash share of trips&quot;: 0.4684059484883
},
{
 &quot;pick_neigh&quot;: &quot;Carnegie Hill&quot;,
&quot;Cash share of trips&quot;: 0.4575706967363
},
{
 &quot;pick_neigh&quot;: &quot;Midtown&quot;,
&quot;Cash share of trips&quot;: 0.4432374310023
},
{
 &quot;pick_neigh&quot;: &quot;Upper East Side&quot;,
&quot;Cash share of trips&quot;: 0.4425295195824
},
{
 &quot;pick_neigh&quot;: &quot;Clinton&quot;,
&quot;Cash share of trips&quot;: 0.4421229793011
},
{
 &quot;pick_neigh&quot;: &quot;North Sutton Area&quot;,
&quot;Cash share of trips&quot;: 0.4402151378723
},
{
 &quot;pick_neigh&quot;: &quot;Upper West Side&quot;,
&quot;Cash share of trips&quot;: 0.4322919508732
},
{
 &quot;pick_neigh&quot;: &quot;Murray Hill&quot;,
&quot;Cash share of trips&quot;: 0.405097815963
},
{
 &quot;pick_neigh&quot;: &quot;Morningside Heights&quot;,
&quot;Cash share of trips&quot;: 0.4033889306623
},
{
 &quot;pick_neigh&quot;: &quot;Soho&quot;,
&quot;Cash share of trips&quot;: 0.3744691193885
},
{
 &quot;pick_neigh&quot;: &quot;Greenwich Village&quot;,
&quot;Cash share of trips&quot;: 0.3729887375508
},
{
 &quot;pick_neigh&quot;: &quot;Financial District&quot;,
&quot;Cash share of trips&quot;: 0.3705016949133
},
{
 &quot;pick_neigh&quot;: &quot;Chelsea&quot;,
&quot;Cash share of trips&quot;: 0.3666546499528
},
{
 &quot;pick_neigh&quot;: &quot;Lower East Side&quot;,
&quot;Cash share of trips&quot;: 0.363683339559
},
{
 &quot;pick_neigh&quot;: &quot;Gramercy&quot;,
&quot;Cash share of trips&quot;: 0.3551375268576
},
{
 &quot;pick_neigh&quot;: &quot;Little Italy&quot;,
&quot;Cash share of trips&quot;: 0.3524758068817
},
{
 &quot;pick_neigh&quot;: &quot;West Village&quot;,
&quot;Cash share of trips&quot;: 0.3523011003574
},
{
 &quot;pick_neigh&quot;: &quot;East Village&quot;,
&quot;Cash share of trips&quot;: 0.3485508636344
},
{
 &quot;pick_neigh&quot;: &quot;Tribeca&quot;,
&quot;Cash share of trips&quot;: 0.3436376219813
},
{
 &quot;pick_neigh&quot;: &quot;Battery Park&quot;,
&quot;Cash share of trips&quot;: 0.3234921494472
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
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart1ab2235e611'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>

Card usage for NYC yellow cabs peaks during weekday commuting hours; cash fares are most likely on weekends, mid-day on weekdays, and late at night on weekdays. [Figure 3](#fig3) shows that a larger share of Harlem's pickups originate during times associated with high cash payment rates, relative to the rest of Manhattan. However, adjusting for the time of week would only push Harlem's cash payment rate down by 0.1 percentage points[^3], so other reasons must be driving Harlem's high cash payment rates.

#### Figure 3: % of trips paid in cash by time of week, excluding holidays {#fig3}
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

    &lt;div id = &#039;chart1ab2643f437&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script&gt;
 $(document).ready(function(){
      drawchart1ab2643f437()
    });
    function drawchart1ab2643f437(){  
      var opts = {
 &quot;dom&quot;: &quot;chart1ab2643f437&quot;,
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
&quot;id&quot;: &quot;chart1ab2643f437&quot;
},
        data = [
 {
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              1,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3911568158997
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         1.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3721207765058
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         1.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3613016638817
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          1.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3740922058534
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         1.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4458844266349
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         1.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.5056022278951
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           1.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4867727459779
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         1.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4863429746726
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         1.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.477868698224
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          1.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.480605420739
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         1.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4785539459662
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         1.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4619708024828
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            1.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4560567446931
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         1.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4582703287747
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         1.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4677429624414
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          1.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4625520527668
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         1.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4603378250309
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         1.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.454459518178
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           1.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4443042253936
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         1.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4348007942175
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         1.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4307530649502
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          1.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4303696367895
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         1.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4238999470758
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         1.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4377420650102
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              2,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.456291274834
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         2.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4734800059462
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         2.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.486837977512
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          2.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.5079410320967
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         2.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.498283671216
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         2.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4118525078736
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           2.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3943576706558
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         2.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3738769254561
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         2.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3563559773399
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          2.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3843030737364
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         2.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4451326986859
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         2.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4706259703591
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            2.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4728119379708
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         2.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4741498648984
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         2.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4767877250139
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          2.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4805955781352
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         2.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4741940071623 
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         2.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4405720869179
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           2.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.406884785707
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         2.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3906148093648
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         2.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3687137262107
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          2.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3649404161166
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         2.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3695185011747
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         2.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3863638523821
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              3,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4055107788331
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         3.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4285029686922
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         3.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4574825711256
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          3.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4907412900328
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         3.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.5035152440317
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         3.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4159318611334
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           3.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3908677195381
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         3.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3655855078844
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         3.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3402459729594
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          3.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3642259394292
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         3.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4188432899388
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         3.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.442783827788
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            3.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4464742213467
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         3.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4493993272465
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         3.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.453600951482
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          3.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4610815623029
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         3.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4610611716591
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         3.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4286204589075
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           3.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.395640762296
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         3.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3685042945898
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         3.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3481812683731
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          3.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.351037104403
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         3.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3474654393328
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         3.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.360705207231
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              4,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3812114648269
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         4.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4050931540709
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         4.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4340290547996
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          4.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4678747826569
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         4.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4940672207412
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         4.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4095124778815
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           4.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3854192772292
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         4.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3570224482066
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         4.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3321546742233
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          4.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3530760226728
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         4.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4097902785539
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         4.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.433616950836
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            4.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4388366061846
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         4.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4423393731909
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         4.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4402311150731
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          4.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4502491053953
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         4.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4527636485283
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         4.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.424872917429
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           4.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3912502547033
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         4.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3698753660884
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         4.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3501004629656
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          4.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3469120123084
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         4.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3450049394432
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         4.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3574679585625
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3689884568244
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         5.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3956646663574
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         5.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4272775327616
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          5.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4584428056316
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         5.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4860234080057
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         5.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.409839669373
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           5.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3824463712778
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         5.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3562539730319
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         5.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3292289737529
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          5.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3488762438947
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         5.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4053535297141
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         5.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.427659268109
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            5.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4320756404162
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         5.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4361784167644
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         5.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4401482483924
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          5.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4499714518055
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         5.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4528108169928
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         5.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4267266372612
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           5.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3931703896072
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         5.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3712886955704
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         5.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3526899557544
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          5.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3534466076063
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         5.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3464641945537
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         5.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3466349919962
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              6,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3526995754337
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         6.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3686230860096
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         6.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3987890888347
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          6.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4335528081235
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         6.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4764326482301
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         6.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4213781209322
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           6.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3877197630264
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         6.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.355988528688
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         6.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3300875264763
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          6.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3521270853756
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         6.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4126804310983
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         6.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4397826060985
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            6.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4424903240205
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         6.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4490211111581
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         6.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4548937483676
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          6.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4654690627159
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         6.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4664846439712
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         6.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4384587891487
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           6.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4125379131961
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         6.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4001159821276
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         6.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3807344977332
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          6.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3926872754784
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         6.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3970106576553
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         6.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3854818883143
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              7,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3757218906146
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         7.0417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3614801041003
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         7.0833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3563502277331
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          7.125,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.3715128863856
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         7.1667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4464774828307
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         7.2083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4912769017037
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           7.25,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4809914218805
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         7.2917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4572536500308
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         7.3333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4505538070848
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          7.375,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4583890141528
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         7.4167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4664480126674
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         7.4583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.465174320309
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            7.5,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4638608326807
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         7.5417,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.473510704078
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         7.5833,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4739433316509
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          7.625,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4819866546412
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         7.6667,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;:   0.4904053144
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         7.7083,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4829297280422
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           7.75,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4633526480102
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         7.7917,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4509778139904
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         7.8333,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4235058317648
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          7.875,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4300588799036
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         7.9167,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.4264800984646
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         7.9583,
&quot;variable&quot;: &quot;% of trips paid in cash (left axis)&quot;,
&quot;value&quot;: 0.409147932919
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              1,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01060910894223
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         1.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008924988838466
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         1.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006513249730145
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          1.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005682492497754
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         1.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004950634935885
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         1.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003526479680356
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           1.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003816114429744
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         1.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004884230871391
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         1.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006212312161269
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          1.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009167999457465
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         1.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01064584310556
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         1.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009981802460624
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            1.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009030952771169
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         1.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009021062804116
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         1.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008246819669166
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          1.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006653122121313
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         1.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006236330652681
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         1.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008585904253816
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           1.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008022176131836
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         1.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006752021791836
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         1.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00676473746376
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          1.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006828315823382
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         1.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007024702311992
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         1.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006728003300423
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              2,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005325040831435
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         2.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003397910108677
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         2.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002209701209967
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          2.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001589458990545
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         2.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001949736361735
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         2.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003185982243271
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           2.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006314037536664
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         2.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01113186434356
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         2.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009539579648143
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          2.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004535256319689
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         2.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003143596670189
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         2.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003372478764828
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            2.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003833068658977
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         2.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004206061702092
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         2.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004100097769389
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          2.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003823178691925
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         2.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003568865253437
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         2.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00639033156821
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           2.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006246220619734
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         2.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004905423657931
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         2.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005152672834239
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          2.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005648584039289
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         2.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005507298795685
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         2.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00542676620683
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              3,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004617201760979
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         3.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003258037717509
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         3.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002109388687008
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          3.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001455238009121
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         3.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001742047053638
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         3.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002873741854906
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           3.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006239156357553
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         3.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01195131875646
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         3.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01036044691348
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          3.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004823478216641
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         3.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00315772519455
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         3.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003303248995462
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            3.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003855674297954
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         3.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004029455147587
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         3.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004101510621825
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          3.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003519415418176
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         3.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003492571221891
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         3.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006821251561202
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           3.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006728003300423
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         3.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005243095390145
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         3.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005254398209633
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          3.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005628804105184
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         3.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005734768037887
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         3.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005941044493549
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              4,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004692082940089
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         4.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003287707618665
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         4.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002129168621113
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          4.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001497623582203
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         4.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001719441414661
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         4.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002745172283226
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           4.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006648883564005
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         4.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01260546943435
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         4.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01051868638632
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          4.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005292545225406
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         4.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003512351155996
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         4.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003390845846496
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            4.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003974353902581
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         4.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004177804653371
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         4.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003917839805139
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          4.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003424754304961
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         4.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003441708534194
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         4.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007784816922581
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           4.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008311810881224
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         4.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006444019960779
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         4.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005900071772904
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          4.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006809948741714
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         4.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006798645922225
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         4.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006559873860535
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004798046872792
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         5.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003283469061357
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         5.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00232979366703
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          5.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00160923892465
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         5.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.001794322593771
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         5.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002926017395039
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           5.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00681842585633
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         5.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01305475650901
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         5.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01068681582621
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          5.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005043883196663
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         5.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003403561518421
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         5.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003417690042781
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            5.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003858500002826
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         5.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004093033507208
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         5.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004101510621825
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          5.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003628205055751
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         5.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003633856465495
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         5.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.0077424313495
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           5.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008243993964294
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         5.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006349358847565
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         5.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006202422194216
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          5.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006747783234528
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         5.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007161748998288
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         5.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007753734168988
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              6,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006137430982158
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         6.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004282355733638
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         6.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002955687296196
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          6.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002304362323182
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         6.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.002411739108321
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         6.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003323028929566
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           6.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006843857200179
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         6.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01314941762223
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         6.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01099057909996
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          6.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005375903519133
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         6.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003745471807942
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         6.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003847197183337
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            6.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004670890153549
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         6.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005247333947453
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         6.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005849209085206
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          6.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004974653427297
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         6.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004569164778154
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         6.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.009459047059289
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           6.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01028980429168
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         6.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00892357598603
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         6.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007348245519845
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          6.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007434429518443
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         6.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008214324063138
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         6.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.0100044080996
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              7,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01033925412694
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         7.0417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.00836691212623
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         7.0833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006436955698599
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          7.125,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005139957162314
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         7.1667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004635568842648
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         7.2083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.003705911939733
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           7.25,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.004317677044539
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         7.2917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005585005679667
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         7.3333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007854046691947
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          7.375,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.0088557590691
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         7.4167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008487004583293
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         7.4583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007789055479889
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            7.5,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008003809050168
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         7.5417,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007821551085918
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         7.5833,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006962536804806
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          7.625,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.006309798979355
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         7.6667,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.005395683453237
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         7.7083,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008631115531769
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           7.75,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008715886677932
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         7.7917,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008327352258021
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         7.8333,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007327052733304
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          7.875,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.007440080928188
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         7.9167,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.008908034609233
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         7.9583,
&quot;variable&quot;: &quot;% of all Harlem trips&quot;,
&quot;value&quot;: 0.01078288979186
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              1,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007866798955381
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         1.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007090848067494
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         1.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005781352254707
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          1.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004557476646839
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         1.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002864018553478
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         1.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001304126769185
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           1.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001235570074881
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         1.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001639241043134
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         1.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002509141114519
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          1.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00378966709339
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         1.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00516874861673
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         1.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006067648787215
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            1.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006574372706247
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         1.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006520954656871
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         1.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006464546407337
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          1.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00604399351957
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         1.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005524733761415
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         1.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006031905605168
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           1.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00657119486195
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         1.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006179418110923
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         1.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005593472046822
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          1.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005274755449446
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         1.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004837931998878
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         1.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003829017885344
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              2,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002628737014753
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         2.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001628751130435
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         2.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001099818619543
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          2.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0007645348605645
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         2.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0008058589425011
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         2.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001216581698576
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           2.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003109590254688
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         2.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005244853447869
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         2.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006250668406584
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          2.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006157336632836
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         2.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005515297077112
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         2.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005501078493771
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            2.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005775396066538
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         2.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005723660761381
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         2.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006047619288588
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          2.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005935771275401
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         2.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005192440202595
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         2.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006409742212544
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           2.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007844487461897
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         2.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007823834500484
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         2.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007248450985523
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          2.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006891255233486
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         2.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006101073656184
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         2.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004457873927011
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              3,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002862868476494
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         3.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001717821566307
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         3.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001073154992631
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          3.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0007142401781549
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         3.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0007137438291409
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         3.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001169053253964
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           3.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0033651252544
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         3.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006077714987341
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         3.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007283637288188
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          3.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00698793433656
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         3.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006217927530768
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         3.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006111944910199
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            3.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006357546876593
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         3.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006235202897671
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         3.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006560178335053
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          3.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006112459418323
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         3.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004919678260274
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         3.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006313837898175
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           3.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008115542447852
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         3.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008477175075832
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         3.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00804683442763
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          3.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007953660032837
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         3.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00722287085219
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         3.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005548274021361
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              4,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003548986245878
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         4.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002096215053065
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         4.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001316656555271
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          4.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0008737982270558
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         4.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0008106045233181
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         4.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001190438632824
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           4.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003381395817201
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         4.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006168928198224
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         4.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0073266864856
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          4.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007089734308731
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         4.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006401939848165
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         4.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006399119133037
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            4.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006570238482142
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         4.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006396927933731
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         4.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006572786810617
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          4.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006123373043595
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         4.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004939744077122
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         4.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006384900549696
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           4.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008139530632518
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         4.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008773543861503
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         4.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008399048530416
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          4.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008340600407495
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         4.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007781602463034
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         4.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00628654475544
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004064487068208
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         5.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002426892451071
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         5.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001534432711695
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          5.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001002183136661
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         5.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.0008962670994959
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         5.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001239068730126
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           5.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00342417262796
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         5.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006113167623624
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         5.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007188580398964
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          5.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006923990056265
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         5.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006288294083062
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         5.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006221662254447
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            5.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006430715984905
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         5.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006247884009676
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         5.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006503461380645
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          5.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005947405212047
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         5.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004657545450498
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         5.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006054658970335
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           5.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007906089216968
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         5.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008625196036675
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         5.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008421735312179
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          5.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00835148982062
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         5.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007941880823309
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         5.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007108928488286
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              6,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005377735763784
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         6.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003551116914817
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         6.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002334414155506
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          6.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001556411288158
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         6.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001206890786728
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         6.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00128806806267
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           6.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.003153038952526
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         6.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005622823222054
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         6.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006804321519589
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          6.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00665024752199
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         6.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006064573844542
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         6.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00607993645183
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            6.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006183794456498
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         6.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006016004277608
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         6.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006373393726822
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          6.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005755487628646
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         6.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004604611644062
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         6.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006046081817251
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           6.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007863015807409
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         6.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008663439122902
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         6.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008237759313003
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          6.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008008718455174
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         6.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008150111340769
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         6.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007996884768315
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              7,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007558009338286
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         7.0417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006517026236016
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         7.0833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005408933115227
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          7.125,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004040795482343
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         7.1667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002556869309343
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         7.2083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001241750225409
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           7.25,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.001403511579689
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         7.2917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.002093255118091
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         7.3333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00323687956464
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          7.375,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.004692628851538
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         7.4167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005680587351821
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         7.4583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006465890181497
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            7.5,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006941053566881
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         7.5417,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00699933825781
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         7.5833,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006787887524795
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          7.625,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006704652216357
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         7.6667,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.005761455922888
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         7.7083,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.006631107819766
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           7.75,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007945494486253
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         7.7917,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008424483390867
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         7.8333,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.007685964482281
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          7.875,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.00755397196277
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         7.9167,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008124434358848
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         7.9583,
&quot;variable&quot;: &quot;% of all Manhattan trips&quot;,
&quot;value&quot;: 0.008395440920509
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              1,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002742309986844
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         1.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001834140770972
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         1.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007318974754386
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          1.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001125015850914
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         1.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002086616382407
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         1.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002222352911172
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           1.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002580544354864
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         1.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003244989828257
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         1.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00370317104675
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          1.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.005378332364075
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         1.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.005477094488833
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         1.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003914153673409
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            1.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002456580064922
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         1.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002500108147245
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         1.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001782273261829
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          1.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0006091286017427
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         1.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007115968912659
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         1.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002553998648648
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           1.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001450981269886
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         1.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0005726036809127
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         1.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001171265416938
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          1.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001553560373936
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         1.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002186770313114
},
{
 &quot;dayofweek&quot;:              1,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         1.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00289898541508
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              2,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002696303816682
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         2.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001769158978242
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         2.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001109882590424
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          2.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0008249241299806
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         2.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001143877419234
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         2.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001969400544695
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           2.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003204447281975
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         2.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.005887010895691
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         2.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003288911241559
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          2.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001622080313147
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         2.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002371700406923
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         2.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002128599728943
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            2.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001942327407561
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         2.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001517599059289
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         2.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001947521519199
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          2.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002112592583477
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         2.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001623574949157
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         2.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -1.941064433456e-05
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           2.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001598266842163
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         2.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002918410842552
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         2.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002095778151284
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          2.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001242671194197
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         2.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0005937748604995
},
{
 &quot;dayofweek&quot;:              2,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         2.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0009688922798188
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              3,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001754333284485
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         3.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001540216151202
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         3.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001036233694377
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          3.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007409978309665
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         3.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001028303224497
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         3.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001704688600942
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           3.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002874031103153
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         3.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.005873603769123
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         3.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003076809625294
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          3.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002164456119919
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         3.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.003060202336218
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         3.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002808695914737
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            3.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002501872578639
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         3.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002205747750084
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         3.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002458667713229
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          3.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002593044000147
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         3.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001427107038383
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         3.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0005074136630274
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           3.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001387539147429
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         3.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.003234079685687
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         3.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002792436217996
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          3.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002324855927653
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         3.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001488102814303
},
{
 &quot;dayofweek&quot;:              3,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         3.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0003927704721876
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              4,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001143096694211
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         4.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001191492565601
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         4.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.000812512065842
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          4.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0006238253551467
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         4.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0009088368913427
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         4.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001554733650402
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           4.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003267487746804
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         4.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.006436541236126
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         4.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003191999900719
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          4.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001797189083324
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         4.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002889588692169
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         4.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00300827328654
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            4.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002595884579561
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         4.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00221912328036
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         4.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002654947005478
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          4.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002698618738634
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         4.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001498035542928
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         4.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001399916372886
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           4.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.000172280248706
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         4.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002329523900724
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         4.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002498976757512
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          4.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001530651665782
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         4.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0009829565408086
},
{
 &quot;dayofweek&quot;:              4,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         4.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.000273329105095
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007335598045849
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         5.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0008565766102859
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         5.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007953609553349
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          5.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0006070557879889
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         5.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0008980554942751
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         5.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001686948664913
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           5.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00339425322837
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         5.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.006941588885388
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         5.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003498235427243
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          5.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001880106859602
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         5.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002884732564641
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         5.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002803972211666
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            5.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00257221598208
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         5.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002154850502467
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         5.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00240195075882
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          5.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002319200156296
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         5.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001023688985002
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         5.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001687772379165
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           5.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0003379047473266
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         5.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.00227583718911
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         5.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002219313117963
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          5.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001603706586092
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         5.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0007801318250213
},
{
 &quot;dayofweek&quot;:              5,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         5.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0006448056807027
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              6,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007596952183743
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         6.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007312388188212
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         6.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0006212731406902
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          6.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007479510350234
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         6.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001204848321592
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         6.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002034960866897
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           6.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003690818247652
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         6.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.007526594400172
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         6.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.004186257580367
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          6.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001274344002857
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         6.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0023191020366
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         6.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.002232739268493
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            6.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.001512904302949
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         6.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0007686703301552
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         6.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0005241846416153
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          6.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0007808342013487
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         6.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -3.544686590826e-05
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         6.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003412965242038
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           6.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002426788484272
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         6.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0002601368631273
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         6.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0008895137931577
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          6.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0005742889367306
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         6.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 6.421272236884e-05
},
{
 &quot;dayofweek&quot;:              6,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         6.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002007523331285
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              0,
&quot;wday_hour&quot;:              7,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002781244788656
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              1,
&quot;wday_hour&quot;:         7.0417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001849885890214
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              2,
&quot;wday_hour&quot;:         7.0833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001028022583372
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              3,
&quot;wday_hour&quot;:          7.125,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001099161679971
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              4,
&quot;wday_hour&quot;:         7.1667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002078699533304
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              5,
&quot;wday_hour&quot;:         7.2083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002464161714324
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              6,
&quot;wday_hour&quot;:           7.25,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002914165464849
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              7,
&quot;wday_hour&quot;:         7.2917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.003491750561576
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              8,
&quot;wday_hour&quot;:         7.3333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.004617167127307
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:              9,
&quot;wday_hour&quot;:          7.375,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.004163130217562
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             10,
&quot;wday_hour&quot;:         7.4167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002806417231472
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             11,
&quot;wday_hour&quot;:         7.4583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001323165298392
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             12,
&quot;wday_hour&quot;:            7.5,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.001062755483286
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             13,
&quot;wday_hour&quot;:         7.5417,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0008222128281087
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             14,
&quot;wday_hour&quot;:         7.5833,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0001746492800106
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             15,
&quot;wday_hour&quot;:          7.625,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0003948532370015
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             16,
&quot;wday_hour&quot;:         7.6667,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0003657724696506
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             17,
&quot;wday_hour&quot;:         7.7083,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.002000007712004
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             18,
&quot;wday_hour&quot;:           7.75,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007703921916793
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             19,
&quot;wday_hour&quot;:         7.7917,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -9.713113284588e-05
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             20,
&quot;wday_hour&quot;:         7.8333,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.0003589117489771
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             21,
&quot;wday_hour&quot;:          7.875,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: -0.000113891034582
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             22,
&quot;wday_hour&quot;:         7.9167,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.0007836002503856
},
{
 &quot;dayofweek&quot;:              7,
&quot;pick_hour&quot;:             23,
&quot;wday_hour&quot;:         7.9583,
&quot;variable&quot;: &quot;Difference (Harlem - Manhattan)&quot;,
&quot;value&quot;: 0.00238744887135
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
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart1ab2643f437'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>




### Best / worst tippers {#tips}

* __Definition:__ mean tip percentage
* __Scope:__ Manhattan pickups paid by card[^4]
* __Best tippers:__ Midtown pickups
* __Worst tippers:__ East Harlem pickups

One striking feature of [Figure 4](#fig4) is that tips are noticeably smaller for neighborhoods in the north of Manhattan. Adjusting the average Harlem tip % for [time of week](http://www.bloomberg.com/news/articles/2014-07-31/heres-how-much-you-should-be-tipping-your-cab-driver), using the same methodology as above, suggests that only 0.1 percentage points of the difference are attributable to the time-of-week distribution of rides.



If you're a taxi driver, this doesn't necessarily mean you'll want to be cruising Midtown for passengers. There are a number of other factors you'd want to consider, such as total expected fare (per minute), supply density, etc. Additionally, this post doesn't assign any _reason_ for these average tips. East Harlem pickups may experience worse service on average, they could tip less on average due to [less disposable income](http://www.wnyc.org/story/174508-blog-census-locates-citys-wealthiest-and-poorest-neighborhoods/), they could be more likely to give cash tips on card fares (cash tips would likely not be recorded), or a host of other reasons.

#### Figure 4: Mean tip % by pickup neighborhood {#fig4}
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

    &lt;div id = &#039;chart1ab70ff4b8a&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart1ab70ff4b8a()
    });
    function drawchart1ab70ff4b8a(){  
      var opts = {
 &quot;dom&quot;: &quot;chart1ab70ff4b8a&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;pick_neigh&quot;,
&quot;y&quot;: &quot;Average tip %&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart1ab70ff4b8a&quot;
},
        data = [
 {
 &quot;pick_neigh&quot;: &quot;Midtown&quot;,
&quot;Average tip %&quot;: 0.2000523521233
},
{
 &quot;pick_neigh&quot;: &quot;Murray Hill&quot;,
&quot;Average tip %&quot;: 0.1999978612038
},
{
 &quot;pick_neigh&quot;: &quot;Garment District&quot;,
&quot;Average tip %&quot;: 0.1986590331118
},
{
 &quot;pick_neigh&quot;: &quot;Chelsea&quot;,
&quot;Average tip %&quot;: 0.1948605477794
},
{
 &quot;pick_neigh&quot;: &quot;Central Park&quot;,
&quot;Average tip %&quot;: 0.1948084680502
},
{
 &quot;pick_neigh&quot;: &quot;Soho&quot;,
&quot;Average tip %&quot;: 0.1947645039997
},
{
 &quot;pick_neigh&quot;: &quot;Gramercy&quot;,
&quot;Average tip %&quot;: 0.1939218674258
},
{
 &quot;pick_neigh&quot;: &quot;Greenwich Village&quot;,
&quot;Average tip %&quot;: 0.1938432828448
},
{
 &quot;pick_neigh&quot;: &quot;Clinton&quot;,
&quot;Average tip %&quot;: 0.1923231264996
},
{
 &quot;pick_neigh&quot;: &quot;Upper West Side&quot;,
&quot;Average tip %&quot;: 0.1917663480823
},
{
 &quot;pick_neigh&quot;: &quot;East Village&quot;,
&quot;Average tip %&quot;: 0.1916004611915
},
{
 &quot;pick_neigh&quot;: &quot;Little Italy&quot;,
&quot;Average tip %&quot;: 0.1913801473227
},
{
 &quot;pick_neigh&quot;: &quot;West Village&quot;,
&quot;Average tip %&quot;: 0.1913011378587
},
{
 &quot;pick_neigh&quot;: &quot;Carnegie Hill&quot;,
&quot;Average tip %&quot;: 0.1904346919471
},
{
 &quot;pick_neigh&quot;: &quot;North Sutton Area&quot;,
&quot;Average tip %&quot;: 0.1902814028893
},
{
 &quot;pick_neigh&quot;: &quot;Tribeca&quot;,
&quot;Average tip %&quot;: 0.1902089050856
},
{
 &quot;pick_neigh&quot;: &quot;Upper East Side&quot;,
&quot;Average tip %&quot;: 0.1895710555058
},
{
 &quot;pick_neigh&quot;: &quot;Financial District&quot;,
&quot;Average tip %&quot;: 0.1878911811849
},
{
 &quot;pick_neigh&quot;: &quot;Lower East Side&quot;,
&quot;Average tip %&quot;: 0.187714543406
},
{
 &quot;pick_neigh&quot;: &quot;Morningside Heights&quot;,
&quot;Average tip %&quot;: 0.1857257255392
},
{
 &quot;pick_neigh&quot;: &quot;Chinatown&quot;,
&quot;Average tip %&quot;: 0.1854703968705
},
{
 &quot;pick_neigh&quot;: &quot;Battery Park&quot;,
&quot;Average tip %&quot;: 0.1852237776707
},
{
 &quot;pick_neigh&quot;: &quot;Yorkville&quot;,
&quot;Average tip %&quot;: 0.178446674663
},
{
 &quot;pick_neigh&quot;: &quot;Harlem&quot;,
&quot;Average tip %&quot;: 0.1761484799067
},
{
 &quot;pick_neigh&quot;: &quot;Inwood&quot;,
&quot;Average tip %&quot;: 0.1749750162101
},
{
 &quot;pick_neigh&quot;: &quot;Washington Heights&quot;,
&quot;Average tip %&quot;: 0.1739780715367
},
{
 &quot;pick_neigh&quot;: &quot;Hamilton Heights&quot;,
&quot;Average tip %&quot;: 0.1717361883717
},
{
 &quot;pick_neigh&quot;: &quot;East Harlem&quot;,
&quot;Average tip %&quot;: 0.1699666189801
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
  .tickFormat(function(d) {return d3.format(&#039;,.1%&#039;)(d)})
  .axisLabel(&quot;Mean tip %&quot;)

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
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart1ab70ff4b8a'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>

### Furthest / nearest travelers {#distance}
* __Definition:__ mean distance traveled
* __Scope:__ Manhattan pickups
* __Furthest travelers__: Financial District pickups
* __Nearest travelers__: Carnegie Hill pickups

Where are Financial District and Carnegie Hill pickups going that makes their average trip so long / short, respectively? Midtown. Midtown dropoffs account for 12% of trips from the Financial District and 17% of trips from Carnegie Hill[^5].

#### Figure 5: Mean distance traveled by pickup neighborhood
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

    &lt;div id = &#039;chart1ab642f5e36&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart1ab642f5e36()
    });
    function drawchart1ab642f5e36(){  
      var opts = {
 &quot;dom&quot;: &quot;chart1ab642f5e36&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;pick_neigh&quot;,
&quot;y&quot;: &quot;Average distance&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart1ab642f5e36&quot;
},
        data = [
 {
 &quot;pick_neigh&quot;: &quot;Financial District&quot;,
&quot;Average distance&quot;:  5.61861835843
},
{
 &quot;pick_neigh&quot;: &quot;Little Italy&quot;,
&quot;Average distance&quot;: 4.461923538092
},
{
 &quot;pick_neigh&quot;: &quot;Washington Heights&quot;,
&quot;Average distance&quot;: 4.443841301304
},
{
 &quot;pick_neigh&quot;: &quot;Inwood&quot;,
&quot;Average distance&quot;: 4.389391607893
},
{
 &quot;pick_neigh&quot;: &quot;Battery Park&quot;,
&quot;Average distance&quot;: 3.983361475823
},
{
 &quot;pick_neigh&quot;: &quot;Soho&quot;,
&quot;Average distance&quot;: 3.513179742097
},
{
 &quot;pick_neigh&quot;: &quot;Hamilton Heights&quot;,
&quot;Average distance&quot;: 3.419421668288
},
{
 &quot;pick_neigh&quot;: &quot;Murray Hill&quot;,
&quot;Average distance&quot;: 3.343021324413
},
{
 &quot;pick_neigh&quot;: &quot;Morningside Heights&quot;,
&quot;Average distance&quot;: 3.033302411673
},
{
 &quot;pick_neigh&quot;: &quot;Lower East Side&quot;,
&quot;Average distance&quot;: 2.998610959361
},
{
 &quot;pick_neigh&quot;: &quot;Chinatown&quot;,
&quot;Average distance&quot;: 2.986833582955
},
{
 &quot;pick_neigh&quot;: &quot;Tribeca&quot;,
&quot;Average distance&quot;: 2.983215237762
},
{
 &quot;pick_neigh&quot;: &quot;Midtown&quot;,
&quot;Average distance&quot;: 2.877922125301
},
{
 &quot;pick_neigh&quot;: &quot;Harlem&quot;,
&quot;Average distance&quot;: 2.829829949081
},
{
 &quot;pick_neigh&quot;: &quot;East Harlem&quot;,
&quot;Average distance&quot;:  2.78633057556
},
{
 &quot;pick_neigh&quot;: &quot;East Village&quot;,
&quot;Average distance&quot;: 2.699890888258
},
{
 &quot;pick_neigh&quot;: &quot;Yorkville&quot;,
&quot;Average distance&quot;: 2.662742404133
},
{
 &quot;pick_neigh&quot;: &quot;Clinton&quot;,
&quot;Average distance&quot;: 2.587233850053
},
{
 &quot;pick_neigh&quot;: &quot;West Village&quot;,
&quot;Average distance&quot;: 2.515445202965
},
{
 &quot;pick_neigh&quot;: &quot;Garment District&quot;,
&quot;Average distance&quot;: 2.413791948357
},
{
 &quot;pick_neigh&quot;: &quot;Chelsea&quot;,
&quot;Average distance&quot;: 2.382626638566
},
{
 &quot;pick_neigh&quot;: &quot;Greenwich Village&quot;,
&quot;Average distance&quot;: 2.382468779561
},
{
 &quot;pick_neigh&quot;: &quot;Upper West Side&quot;,
&quot;Average distance&quot;: 2.373281362831
},
{
 &quot;pick_neigh&quot;: &quot;Central Park&quot;,
&quot;Average distance&quot;: 2.327048990111
},
{
 &quot;pick_neigh&quot;: &quot;North Sutton Area&quot;,
&quot;Average distance&quot;: 2.290314584736
},
{
 &quot;pick_neigh&quot;: &quot;Gramercy&quot;,
&quot;Average distance&quot;: 2.287731662593
},
{
 &quot;pick_neigh&quot;: &quot;Upper East Side&quot;,
&quot;Average distance&quot;: 2.277637405318
},
{
 &quot;pick_neigh&quot;: &quot;Carnegie Hill&quot;,
&quot;Average distance&quot;: 2.164282339865
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
  .tickFormat(function(d) {return d3.format(&#039;,.1f&#039;)(d)})
  .axisLabel(&quot;Mean distance traveled (miles)&quot;)

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
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart1ab642f5e36'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>



### Top party neighborhood(s) {#party}
* __Definition:__ ratio of outbound to inbound trips Saturdays and Sundays before 5 AM
* __Scope:__ outbound trips from Manhattan neighborhoods, inbound trips from all neighborhoods
* __Top party neighborhood:__ Lower East Side

This party index identifies neighborhoods where more trips leave a given neighborhood than enter early Saturday and Sunday mornings (presumably after a late night out Friday and Saturday, respectively). Todd Schneider uses a slightly different index of late night activity [here](http://toddwschneider.com/posts/analyzing-1-1-billion-nyc-taxi-and-uber-trips-with-a-vengeance/#late-night-taxi-index), which identifies late night hotspots by comparing neighborhood pickup volumes during Friday and Saturday nights to volumes from the same neighborhoods during other times of the week. I created my index in order to better measure neighborhoods with naturally high volumes during non-party hours[^6].

#### Table 2: Top 5 party neighborhoods

|Neighborhood      |Trips out:in ratio |Outbound trips |Inbound trips |
|:-----------------|:------------------|:--------------|:-------------|
|Lower East Side   |2.1                |839,262        |391,248       |
|Little Italy      |2.0                |196,526        |97,543        |
|West Village      |1.8                |535,476        |291,365       |
|East Village      |1.7                |982,791        |567,391       |
|Greenwich Village |1.7                |719,606        |420,152       |


### Most / least diverse {#diversity}
* __Definition:__ [Shannon diversity index](http://www.tiem.utk.edu/~gross/bioed/bealsmodules/shannonDI.html)
* __Scope:__ Manhattan dropoffs, all non-missing pickup locations
* __Most diverse:__ Chinatown dropoffs
* __Least diverse:__ Carnegie Hill dropoffs

The Shannon diversity index gives weight to both the abundance and evenness of pickup neighborhoods for any given dropoff neighborhood. The top three pickup neighborhoods for Carnegie Hill dropoffs account for 70% of its volume (unsurprisingly 40% is from the Upper East Side) but the top three pickup neighborhoods for Chinatown dropoffs only account for 29% of its volume.

#### Figure 6: Diversity of pickup neighborhoods by dropoff neighborhood
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

    &lt;div id = &#039;chart1ab521c853c&#039; class = &#039;rChart nvd3&#039;&gt;&lt;/div&gt;    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart1ab521c853c()
    });
    function drawchart1ab521c853c(){  
      var opts = {
 &quot;dom&quot;: &quot;chart1ab521c853c&quot;,
&quot;width&quot;:    750,
&quot;height&quot;:    600,
&quot;x&quot;: &quot;drop_neigh&quot;,
&quot;y&quot;: &quot;Shannon diversity index&quot;,
&quot;type&quot;: &quot;multiBarHorizontalChart&quot;,
&quot;id&quot;: &quot;chart1ab521c853c&quot;
},
        data = [
 {
 &quot;drop_neigh&quot;: &quot;Chinatown&quot;,
&quot;Shannon diversity index&quot;: 2.939709707675
},
{
 &quot;drop_neigh&quot;: &quot;Financial District&quot;,
&quot;Shannon diversity index&quot;: 2.909162543377
},
{
 &quot;drop_neigh&quot;: &quot;Inwood&quot;,
&quot;Shannon diversity index&quot;: 2.905885439089
},
{
 &quot;drop_neigh&quot;: &quot;Lower East Side&quot;,
&quot;Shannon diversity index&quot;: 2.902229617757
},
{
 &quot;drop_neigh&quot;: &quot;Tribeca&quot;,
&quot;Shannon diversity index&quot;: 2.891416405451
},
{
 &quot;drop_neigh&quot;: &quot;Battery Park&quot;,
&quot;Shannon diversity index&quot;: 2.864824734702
},
{
 &quot;drop_neigh&quot;: &quot;Little Italy&quot;,
&quot;Shannon diversity index&quot;: 2.863026595316
},
{
 &quot;drop_neigh&quot;: &quot;Soho&quot;,
&quot;Shannon diversity index&quot;: 2.828963667786
},
{
 &quot;drop_neigh&quot;: &quot;West Village&quot;,
&quot;Shannon diversity index&quot;: 2.815887652224
},
{
 &quot;drop_neigh&quot;: &quot;Harlem&quot;,
&quot;Shannon diversity index&quot;: 2.806398284409
},
{
 &quot;drop_neigh&quot;: &quot;East Village&quot;,
&quot;Shannon diversity index&quot;: 2.796226889715
},
{
 &quot;drop_neigh&quot;: &quot;Greenwich Village&quot;,
&quot;Shannon diversity index&quot;: 2.789626031107
},
{
 &quot;drop_neigh&quot;: &quot;Washington Heights&quot;,
&quot;Shannon diversity index&quot;: 2.787902497113
},
{
 &quot;drop_neigh&quot;: &quot;Hamilton Heights&quot;,
&quot;Shannon diversity index&quot;: 2.766972799965
},
{
 &quot;drop_neigh&quot;: &quot;Chelsea&quot;,
&quot;Shannon diversity index&quot;: 2.753530317838
},
{
 &quot;drop_neigh&quot;: &quot;Gramercy&quot;,
&quot;Shannon diversity index&quot;: 2.698133884523
},
{
 &quot;drop_neigh&quot;: &quot;Murray Hill&quot;,
&quot;Shannon diversity index&quot;: 2.658672287497
},
{
 &quot;drop_neigh&quot;: &quot;Garment District&quot;,
&quot;Shannon diversity index&quot;: 2.637665563786
},
{
 &quot;drop_neigh&quot;: &quot;Midtown&quot;,
&quot;Shannon diversity index&quot;: 2.620688431614
},
{
 &quot;drop_neigh&quot;: &quot;East Harlem&quot;,
&quot;Shannon diversity index&quot;: 2.615543433029
},
{
 &quot;drop_neigh&quot;: &quot;Clinton&quot;,
&quot;Shannon diversity index&quot;: 2.609242728726
},
{
 &quot;drop_neigh&quot;: &quot;Yorkville&quot;,
&quot;Shannon diversity index&quot;: 2.461199717676
},
{
 &quot;drop_neigh&quot;: &quot;Central Park&quot;,
&quot;Shannon diversity index&quot;: 2.431013963426
},
{
 &quot;drop_neigh&quot;: &quot;North Sutton Area&quot;,
&quot;Shannon diversity index&quot;: 2.400695993107
},
{
 &quot;drop_neigh&quot;: &quot;Morningside Heights&quot;,
&quot;Shannon diversity index&quot;: 2.387290926881
},
{
 &quot;drop_neigh&quot;: &quot;Upper West Side&quot;,
&quot;Shannon diversity index&quot;: 2.331257232695
},
{
 &quot;drop_neigh&quot;: &quot;Upper East Side&quot;,
&quot;Shannon diversity index&quot;: 2.316586718358
},
{
 &quot;drop_neigh&quot;: &quot;Carnegie Hill&quot;,
&quot;Shannon diversity index&quot;: 2.098611859981
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
  .tickFormat(function(d) {return d3.format(&#039;0.2f&#039;)(d)})
  .axisLabel(&quot;Shannon diversity index (diversity of pickup neighborhoods per dropoff neighborhood)&quot;)

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
&lt;/html&gt; ' scrolling='no' frameBorder='0' seamless class='rChart  nvd3  ' id='iframe-chart1ab521c853c'> </iframe>
 <style>iframe.rChart{ width: 100%; height: 600px;}</style>

_Note: This post is best viewed in Chrome, Firefox, or Safari._

-----------------------------------------------------------------------------

### Footnotes

[^1]: As someone who's lived in each of these three neighborhoods I can vouch for this, especially in [Subway deserts](https://team.carto.com/u/chriswhong/viz/e60e7660-3982-11e5-9997-0e853d047bba/public_map)
[^2]: Unbanked defined as no member of the household having a checking or savings account; as of 2013
[^3]: Adjustment calculated as the sum product of the difference in time of week distribution and the overall cash payment rate
[^4]: Total tip as a fraction of total base fare; figures exclude trips not paid for by card, as tips for these fares are rarely recorded
[^5]: This is roughly in line with average: 16% of all yellow cab trips in 2014 ended in Midtown
[^6]: Todd's late night index might fail to identify neighborhoods that have high traffic volumes during non-party hours, and might mistakenly identify neighborhoods that have low traffic volumes during non-party hours; conversely, my index might fail to identify neighborhoods that have a lot of party-goers returning from other areas, and might mistakenly identify neighborhoods where no one gets dropped off
