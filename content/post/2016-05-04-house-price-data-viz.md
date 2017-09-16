---
title: House price data viz
date: 2016-05-04
slug: house-price-data-viz
tags: ["Economy", "Housing","dataviz","house prices"]
categories: ["economy"]
---

TO HELP UNDERSTAND TRENDS in house prices, I have a couple of data visualizations for the <a href="http://www.freddiemac.com/finance/house_price_index.html">Freddie Mac house price index</a>.


## Viz 1: House Price Dynamics

The first compares the quarterly and annual appreciation for house prices across the 50 states plus the District of Columbia.

<img src="../../../../img/charts_may_4_2016/hpi_dots.gif" alt="hairball" style="width: 650px;"/>


In this visualization, each dot represent a state (or D.C.). The horizontal X axis measures the quarter-over-quarter annualized percentage change in the Freddie Mac house price index. The vertical Y axis shows the year-over-year percentage change. Inset to the graphic is a time series plot for the national house price index, which is a weighted average of the state indices.

Values in the upper right quadrant, labeled rising, are experiencing positive annual and quarter-over-quarter house price growth. The upper left quadrant, labeled slipping indicates positive annual growth but negative quarter-over-quarter growth. The lower left quadrant, labeled falling, represents declines in both the quarter-over-quarter and annual house price index. The bottom right, labeled accelerating indicates positive quarter-over-quarter changes, but a decline year-over-year.

Because the data are not seasonally-adjusted there is a regular seesaw pattern as prices rise and fall each year over the season. The vertical motion captures the rise and fall in the index. Examining the time series line charts helps you see how on average house prices are moving.

## Viz 2 Fall and Recovery of House Prices

The next visualization compares each state house price index to its pre-2008 maximum, and post-2007 minimum. This helps us to see which states have recovered most, and which are at a new all-time high in their index. Watch North Dakota (ND) go! Nevada (NV) actually falls off my scale (to the left), but comes roaring back in 2013.


<img src="../../../../img/charts_may_4_2016/hpi_dots2.gif" alt="hairball" style="width: 650px;"/> 

I made these graphics in R, using the animation packaged to create the gifs, ggplot2 to draw the graphics, ggthemes to help style them, and ggrepel to help handle automatic labeling of the points.

