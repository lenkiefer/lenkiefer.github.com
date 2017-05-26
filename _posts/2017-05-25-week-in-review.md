---
layout: post
title: "Housing market recap"
author: "Len Kiefer"
date: "2017-05-25"
summary: "R statistics dataviz ggplot2 housing mortgage data"
group: navigation
theme :
  name : lentheme
---

QUITE A LOT OF HOUSING DATA CAME OUT THIS WEEK. Let's recap with some graphs.

# Mortgage rates back below 4 percent

The 30-year fixed rate mortgage fell back below 4 percent [this week](http://freddiemac.mwnewsroom.com/press-releases/mortgage-rates-drop-to-lowest-of-2017-otcqb-fmcc-1310392).

<img src="{{ site.url}}/img/charts_may_25_2017/rate_05_25_2017 v3.gif" >

# New home sales

New home sales data [was released](https://www.census.gov/construction/nrs/index.html) and came in weaker than expected for April 2017. March has been an extremely strong number, so a decline was anticipated, but the drop was bigger than most expected. 

![plot of chunk 05-25-2017-new-plot-1](/img/Rfig/05-25-2017-new-plot-1-1.svg)

Despite the drop in April, new home sales are trending higher over the long run; the year-to-date sum of monthly sales was up 11.3% (+/- 6.7%).  But it remains a long road back to recovery for new home sales.

<img src="{{ site.url}}/img/charts_may_25_2017/tween test new sales 05 25 2017.gif" >

# Existing home sales on pace for best year in a decade

Existing home sales data were [also released](https://www.nar.realtor/topics/existing-home-sales). And like new home sales, existing home sales declined.  However, the first four months of 2017 are the best year-to-date total for existing home sales since 2007.

<img src="{{ site.url}}/img/charts_may_25_2017/ehs mar 24 2017.gif" >

## House prices

The FHFA [released](https://www.fhfa.gov/DataTools/Downloads/pages/house-price-index.aspx) updated house prices through the first quarter of 2017. House price growth remains strong, rising 6.0 percent from the first quarter of 2016 to the first quarter of 2017.

They also released quarterly data on state house price trends.  The plot below compares the four-quarter percentage change in house prices by state.



![plot of chunk 05-25-2017-plot2](/img/Rfig/05-25-2017-plot2-1.svg)

We can use [geofacet](https://github.com/hafen/geofacet) like we did [earlier this month]({% post_url 2017-05-22-geo-my-facet %}) to try an alternate layout for the plot. The plot below focuses on the four-quarter percent change in house prices since 2005. It's the same data as above, just arranged differently.

![plot of chunk 05-25-2017-plot3](/img/Rfig/05-25-2017-plot3-1.svg)


# Coming soon

It's about time to update my hairball.

The Census [released](https://www.census.gov/newsroom/press-releases/2017/cb17-81-population-estimates-subcounty.html) updated population and housing unit estimates. We can use that data to update some analysis we did [last year]({% post_url 2016-03-30-real-house-prices-and-population-growth %}).  

I'll get you the updated analysis and code sometime soon. In the meanwhile, here's a plot we'll be exploring and explaining. It should make at least 5 percent more sense after we talk about it!

<img src="{{ site.url}}/img/charts_may_25_2017/tween hairball 05 25 2017.gif" >





