---
layout: post
title: "House price growth and employment trends"
author: "Len Kiefer"
date: "2017-05-03"
summary: "R statistics dataviz housing mortgage data"
group: navigation
theme :
  name : lentheme
---

IN THIS POST I WANT TO REVIEW RECENT EMPLOYMENT AND HOUSE PRICE TRENDS at the metropolitan statistical area.  No [R](https://www.r-project.org/) code here, but you can recreate the graphs we'll explore today by following the code [in this post]({% post_url 2017-02-20-house-price-tour %}).

This week the U.S. Bureau of Labor Statistics (BLS) released updated metro employment data ([LINK](https://www.bls.gov/news.release/metro.nr0.htm)) and Freddie Mac released its [Freddie Mac House Price Index](http://www.freddiemac.com/finance/house_price_index.html) for over 300 metro areas as well as the 50 states, the District of Columbia and the United States. Let's see how employment and house price growth relate.



First, let's consider annual house price growth in the Washington, D.C. metro area.
![plot of chunk 05-03-2017-dc-plot1](/img/Rfig/05-03-2017-dc-plot1-1.svg)

Let's consider employment growth for the Washington D.C. area:

![plot of chunk 05-03-2017-dc-plot2](/img/Rfig/05-03-2017-dc-plot2-1.svg)

Let's compare employment and house price growth in the Washington D.C. metro area:

![plot of chunk 05-03-2017-dc-plot3](/img/Rfig/05-03-2017-dc-plot3-1.svg)

Periods of high (low) employment growth correspond to periods of high (low) house price growth.

How do these trends vary across metro areas?  

Let's look at 12 large metro areas:

![plot of chunk 05-03-2017-all-plot4](/img/Rfig/05-03-2017-all-plot4-1.svg)

While in general the scatterplots follow an upward trend, there's quite a bit of variation across markets.

Let's take a tour:

<img src="{{ site.url}}/img/charts_may_03_2017/geo tour emp hpi tween 05 03 2017.gif" >

**BONUS: Let's add an animated scatterplot**

<img src="{{ site.url}}/img/charts_may_03_2017/emp hpa scatter 05 03 2017.gif" >



