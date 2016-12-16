---
layout: post
title: "More amazing ways to visualize mortgage rates"
author: "Len Kiefer"
date: "2016-12-15"
summary: "R rstats dataviz or mortgage rates"
group: navigation
theme :
  name : lentheme
---



IN THIS POST I AM GOING TO share a couple gifs displaying mortgage rate trends. Check my earlier posts [here]({% post_url 2016-12-08-10-ways-to-visualize-rates %}) and [here]({% post_url 2016-12-12-ribbon-rate-chart %}) for other charts.

I don't have time tonight to write up all the code for these, so I'm just sharing the images.  Check back later (message/[tweet at me](https://twitter.com/lenkiefer)) if you'd like to see the code. 

# Standard time series

First we have our standard time series gif, updated through December 15, 2016:

<img src="{{ site.url }}/img/charts_dec_15_2016/rate_12_15_2016.gif" alt="pmms ts"/>

# Compare weekly rates

Another way I like to visualize rates is to look at rates by week of year.

Instead of using date for the x axis, we use the week of the year and plot a separate line for recent years (2013, 2014, 2015 and 2016). By comparing the lines at any point on the x axis, we can see where rates were one or more years ago on this week.

<img src="{{ site.url }}/img/charts_dec_15_2016/rate_compare_dec_15_2016.gif" alt="pmms compare ts"/>


# Distribution of rates by year

Next I wanted to look at the distribution of weekly rates by year: 

<img src="{{ site.url }}/img/charts_dec_15_2016/pmms share bars dec 2016.gif" alt="pmms bars"/>

# Falling time, falling rates

I was feeling a little more emotional about rates, so I put together this whimsical graph that puts time on the vertical axis flowing down.  I also made it so that the alpha transparency fades and the line thickness diminished. I wanted to capture the feeling of ink brush painting.

<img src="{{ site.url }}/img/charts_dec_15_2016/falling time falling rates.gif" alt="falling rates"/>


# Horizontal rates

This was an alternative of the above, with a more traditional left-to-right time orientation.

<img src="{{ site.url }}/img/charts_dec_15_2016/rate stream notvertical 12 15 2016 v2.gif" alt="falling rates"/>

