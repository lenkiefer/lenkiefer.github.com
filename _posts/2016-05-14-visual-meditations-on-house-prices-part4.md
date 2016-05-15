---
layout: post
title: "Visual meditations on house prices, Part 4: graph gallery"
author: "Len Kiefer"
date: "2016-05-14"
summary: "Charts and graphs exploring house price trends"
group: navigation
theme :
  name : lentheme
---




# Introduction

IN THIS POST we'll collect several visualizations of house prices I've shared on Twitter the past few days and have a little discussion.  In [*prior posts*]({% post_url 2016-05-08-visual-meditations-on-house-prices %}) I've also included code for some of these graphs, and the others are mostly straightforward extensions of the earlier examples.  

This is Part 4 of my series of posts on visualizing house prices.  Below are the earlier posts that have data and R code for generating plots:

* [Part 1: data wrangling ]({% post_url 2016-05-08-visual-meditations-on-house-prices-part1 %})
* [Part 2: sparklines and dots (animated) ]({% post_url 2016-05-08-visual-meditations-on-house-prices-part2 %})
* [Part 3: bubbles and bounce ]({% post_url 2016-05-10-visual-meditations-on-house-prices-part3 %})

There are some cases where I blended unemployment data from the [U.S. Bureau of Labor Statistics (BLS)](http://www.bls.gov/) with the house price data. I've got some code that downloads BLS data directly from their webpage and merges it with the house price data. As that involves some additional data wrangling considerations we'll cover that in a future post.



Let's get to the graphs.

## The data

Throughout, we'll be looking at the [Freddie Mac House Price Index (FMHPI)](http://www.freddiemac.com/finance/house_price_index.html) for the 50 states plus the District of Columbia and over 300 metros areas. The history of the U.S. index vs the 50 states plus D.C. and the history of the U.S. index vs over 300 metros are contained in the plots below:

### U.S. vs States:

<img src="{{ site.url }}/img/charts_may_14_2016/hpigif1.gif" alt="Swoosh"/>

And here's an individual line plot for each of the 50 states:

<img src="{{ site.url }}/img/charts_may_14_2016/hpiviz1.PNG" alt="Swoosh"/>

And and animated gif version:

<img src="{{ site.url }}/img/charts_may_14_2016/hpi_lines3.gif" alt="Swoosh"/>


### U.S. vs Metros:

<img src="{{ site.url }}/img/charts_may_14_2016/hpigif2.gif" alt="Swoosh"/>

We'll be manipulating these series to create a variety of views on house prices.




# House price lollipop

A lollipop chart ([link for R code](https://rud.is/b/2016/04/07/geom_lollipop-by-the-chartettes/)) is a special type of chart that connect a line segment to a dot. They combine the feature of dot plot that allows you to compare position with bar charts which allow you to compare length. We can use this chart to compare the position of house prices (their level) vs their change (their percent difference).
Here is one for the 50 states plus D.C. for March of 2016:


<img src="{{ site.url }}/img/charts_may_14_2016/hpi1.PNG" alt="FMHPI dot 1"/>

This chart shows the [Freddie Mac House Price Index (FMHPI)](http://www.freddiemac.com/finance/house_price_index.html) for the 50 states plus the District of Columbia.  The dot corresponds to the value of the index in March of 2016.  The tail extends to the range of the minimum and maximum value in the last 12 months for the house price index in that state. Each state is color coded according to the percentage change in the house price index over the past 12 months.

Here's an animated version of this chart, rolling through each month since January of 2000. Because the index is normalized at 100 in December of 2000 the dots all line up 12 frames. Then as we roll forward through the last decade and a half, we see states rise and fall through motion, the length of the tail, and color.


<img src="{{ site.url }}/img/charts_may_8_2016/hpi_dots_state_redblue2.gif" alt="FMHPI Gif"/>

Here's another version of the chart, where I've added a pink box corresponding to the pre-2008 maximum in the FMHPI and the post-2008 minimum.

<img src="{{ site.url }}/img/charts_may_14_2016/hpi2.jpg" alt="FMHPI 2"/>

## Swirly pop

After I created this chart I realized that the y axis, where I've encoded state, doesn't add any information. What if we added another dimension to the chart? Because the FMHPI is displayed on a log scale, the length of the segments corresponds to annual percentage changes (if the endpoints are the current month and 12 months ago). In the following chart, I encoded the percentage change in the y axis for over 300 metro areas:

![plot of chunk fig-hpi-scatter-w-marginal](/img/Rfig/fig-hpi-scatter-w-marginal-1.svg)

Here the vertical distance measures the annual percentage change in index, while the x axis measures the level of the index.  I've also added histograms to the x and y axis, capturing the relative frequency of observations.

After I created this chart I realized I was missing an opportunity.  I could extend the tail to the value from a year ago in both the x and y axis. Here's the modified version, for March of each year since 2005: 


![plot of chunk fig-rbswirl3](/img/Rfig/fig-rbswirl3-1.svg)

Animated version:

<img src="{{ site.url }}/img/charts_may_10_2016/rbswirl2.gif" alt="Swoosh"/>


# Seasonality in house prices

If you study housing markets, you'll quickly learn that seasonality is a big deal. Housing market activity varies widely throughout the year, be it home purchases or housing construction.  The chart below [which I blogged about last time]({% post_url 2016-05-10-visual-meditations-on-house-prices-part3 %}) shows seasonal patterns in metro house prices.

<img src="{{ site.url }}/img/charts_may_10_2016/metro_season.gif" alt="redblue dots"/>

# House Price and Unemployment

I've made several graphs recently comparing the unemployment rate for a state or metro to house prices.

This one shows states and was compared to a bug:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/lenkiefer">@lenkiefer</a> I love that it looks like a bug crawling around!</p>&mdash; Mara Averick (@dataandme) <a href="https://twitter.com/dataandme/status/730725574776229888">May 12, 2016</a></blockquote>

<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<img src="{{ site.url }}/img/charts_may_14_2016/hpi_ur2.gif" alt="data pede"/>

This one compares metros:

<img src="{{ site.url }}/img/charts_may_14_2016/hpi_ur_metro3.gif" alt="tadpole"/>

And here's a panel version of the metro chart:

<img src="{{ site.url }}/img/charts_may_14_2016/hpi_ur_metro_panel.gif" alt="tad panel"/>

# Correlation of metro house prices and U.S. index

Correlation of house price movements is an active area of research, with many researchers studying in depth the relationships between house price movements across areas. Here are some visualizations that demonstrate the correlations.

### Metro house price index and U.S. index

<img src="{{ site.url }}/img/charts_may_14_2016/metro_us_corr.gif" alt="hpi corr"/>

This gif compares each metro area (grouped by principal state) to the U.S. in terms of the index.  I've plotted the U.S. index on the x axis (using a log scale) and the metro index (using a log scale) on the y axis.  In general there's fairly strong correlation, but some markets seem to permanently depart from the regression line.

Let's consider Dallas and Los Angeles:

![plot of chunk fig-hpi-corr](/img/Rfig/fig-hpi-corr-1.svg)

In Dallas, there seem to be permanent departures from the solid regression line. Los Angeles on the other hand, seems to follow the national trend very closely (though the slope of the Los Angles line is well above the 45 degree line).

Let's try to estimate it using the monthly percent change (at an annualized rate):

<img src="{{ site.url }}/img/charts_may_14_2016/metro_us_hpa_corr.gif" alt="hpa corr"/>

Again we can focus in on just Dallas and Los Angeles:

![plot of chunk fig-hpa-corr](/img/Rfig/fig-hpa-corr-1.svg)

Here we see that the points tend to cluster around the regression loan, but with very different slopes.  Dallas, which lies below the 45 degree line tends to experience house price growth that is subdued with respect to national trends.  Los Angeles, seems more responsive. Let's examine these relationships across all the metros.

## Regressions

In the plots below we compare the slope coefficient from each scatterplot.  We can quickly notice some regularities:

![plot of chunk fig-hpa-reg1](/img/Rfig/fig-hpa-reg1-1.svg)



Focus in on a four large states:

![plot of chunk fig-hpa-reg2](/img/Rfig/fig-hpa-reg2-1.svg)


All the metros in California and all but two in Florida have a coefficient greater than one, while all the metros in Pennsylvania and Texas have a coefficient less than one. This means that on average when house prices rise (fall) 3 percent for the U.S., California and Florida tend to rise (fall) more than 3 percent, while Pennsylvania and Texas tend to rise (fall) less than 3 percent.

# *Update* Dot plot distribution

This plot shows the distribution of house price appreciaton (month-over-month percent change) across each metro area compared to the U.S. index.  Values that are aprpeciating (depreciating) are colored blue (red) and the orange line corresponds to the U.S. index for that month.  I've written up indstructions on how to make such a plot [in an earlier post]({% post_url 2016-04-06-dot-plots-and-distributions%}).

<img src="{{ site.url }}/img/charts_may_14_2016/metro_hpi_dots5.gif" alt="hpa dots"/>


# Conclusion

There's a lot of different visualization hers, but I wanted to collect them all in one place.  I've got several more ideas for visualizations of house price trends, and we'll see them in a sequel.



