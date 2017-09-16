---
title: 'Data Viz: Occupation Wages and Regional Cost of Living'
slug: data-viz-occupation-wages-and-regional-cost-of-living
tags: ["economy", "housing","dataviz","Tableau"]
category: :economics"
date: 2016-04-14
---

## A new data viz

TODAY THE BLS <a href="http://www.bls.gov/opub/mlr/2016/article/purchasing-power-using-wage-statistics-with-regional-price-parities-to-create-a-standard-for-comparing-wages-across-us-areas.htm">released data</a> on metro level wages, employment concentration and regional costs of living.

I put together a quick plot and sent out the following tweet:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Today <a href="https://twitter.com/BLS_gov">@BLS_gov</a> released data combining price-adjusted wages and employment concentration. I looked at economists... <a href="https://t.co/NkL3q9r5ID">pic.twitter.com/NkL3q9r5ID</a></p>&mdash; Leonard Kiefer (@lenkiefer) <a href="https://twitter.com/lenkiefer/status/720736175892402176">April 14, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

This post provides a link to interactive versions of the same plot and a discussion.

## The data

The BLS data is quite interesting. It combines estimates of the average annual wages by occupation in metro areas with estimates of the relative price level in those areas. Workers in the same profession living in different areas might earn different salaries, but also face different prices for goods and services. These data help you make comparisons to earnings across areas with very different costs of living.

## Employment concentration and cost of living

The first plot (below) compares the regional price parity (RPP) to the location quotient for individual metro areas and particular observations. Regional price parity is a measure of the cost of goods and services normalized so that the national average is 100. Values above 100 indicate that goods and services are generally more expensive than the national average in that location. The location quotient is a measure of employment concentration, normalized so that the national average is 1.

Take for example, economists in the Washington, D.C. metro area. The RPP measure for metro Washington D.C. is 120.4, meaning that goods and services in the D.C. area are generally 20% more expensive than the national average. The location quotient for economists is 18.3, indicating that there are about 18.3 times as many economists per capita as in the nation as a whole.
In the graphic below, you can use the drop box to explore and compare different occupations.

<script type='text/javascript' src='https://public.tableau.com/javascripts/api/viz_v1.js'></script><div class='tableauPlaceholder' style='width: 544px; height: 719px;'><noscript><a href='http:&#47;&#47;lenkiefer.com&#47;'><img alt='Industry concentration and regional cost of living ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Oc&#47;OccupationsandRelativePurchasingPower&#47;CompareRegionalPricestoLocationQuotient&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz' width='544' height='719' style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='site_root' value='' /><param name='name' value='OccupationsandRelativePurchasingPower&#47;CompareRegionalPricestoLocationQuotient' /><param name='tabs' value='no' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Oc&#47;OccupationsandRelativePurchasingPower&#47;CompareRegionalPricestoLocationQuotient&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='showTabs' value='y' /></object></div>

## Wages and cost of living

The next plot, compares the average annual nominal salary by occupation to the RPP measure. In Washington D.C. the average annual salary for economists was $121,140. But accounting for higher cost of living, this is roughly equivalent to $100,615 (121.140/120.4). Hovering your mouse over the dots will reveal the purchasing power equivalent for each average nominal salary.

<script type='text/javascript' src='https://public.tableau.com/javascripts/api/viz_v1.js'></script><div class='tableauPlaceholder' style='width: 544px; height: 719px;'><noscript><a href='http:&#47;&#47;lenkiefer.com&#47;'><img alt='Nominal annual earnings and regional cost of living ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Oc&#47;OccupationsandRelativePurchasingPower&#47;CompareAvgWagetoRegionalPrices&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz' width='544' height='719' style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='site_root' value='' /><param name='name' value='OccupationsandRelativePurchasingPower&#47;CompareAvgWagetoRegionalPrices' /><param name='tabs' value='no' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Oc&#47;OccupationsandRelativePurchasingPower&#47;CompareAvgWagetoRegionalPrices&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='showTabs' value='y' /></object></div>

## Explore

I find exploring the two graphs above to be fascinating. For example, you can see where brickmasons (or any other occupation you're interested in) earn most and how purchasing power-adjusted earnings compares to the cost of living across areas.


{% include JB/setup 
