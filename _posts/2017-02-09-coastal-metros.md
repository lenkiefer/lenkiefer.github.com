---
layout: post
title: "House prices are highest in coastal metros"
author: "Len Kiefer"
date: "2017-02-09"
summary: "R statistics dataviz housing mortgage data"
group: navigation
theme :
  name : lentheme
---
  



TODAY THE NATIONAL ASSOCIATION OF REALTORS (NAR) released ([press release](https://www.nar.realtor/news-releases/2017/02/swift-gains-in-fourth-quarter-push-home-prices-to-peak-levels-in-majority-of-metro-areas)) data on metro area median sales prices of existing single-family homes (the U.S. Census and HUD report data on new home sales prices in a joint release).  NAR makes the data available ([Excel file](https://www.nar.realtor/sites/default/files/reports/2016/embargoes/2016-q4-metro-home-prices/metro-home-prices-q4-2016-single-family-2017-02-09.xls)).

Let's take a look at the data:

![plot of chunk feb-9-2017-graph1](/img/Rfig/feb-9-2017-graph1-1.svg)

We can see a lot of variation in median sales prices of existing single-family homes.  The median price in San Francisco was over \$800,000 while in Atlanta it was only \$184,000.  

# Compare house prices to longitude.

The map below plots median sales prices by metro area (color coded by housing value).  Immediately below the map is a scatterplot comparing longitude on the x axis to median house prices on the y axis.  Basically, each metro is being "dropped" down from the map to the plot preserving its latitude.

![plot of chunk feb-9-2017-map1](/img/Rfig/feb-9-2017-map1-1.svg)

This figure shows that house prices are highest in the west, but also high on the east coast as well.  Most of the metro areas in the central United States, with Denver as a notable exception, tend to have low house prices.

## Animated chart:

The plot might make more sense if we animate it:

<img src="{{ site.url}}/img/charts_feb_9_2017/nar2016q4.gif">

Creating this plot took a little bit of data wrangling.  I started to write it up, but am running out of gas today.  Perhaps I'll write the data wrangling and plot creation later.  Basically I am extending the code from [this post: *populous metros are heavy!*]({% post_url 2016-12-23-populous-metros-are-heavy %}).

