---
layout: post
title: "Best year for home sales in a decade"
author: "Len Kiefer"
date: "2017-01-30"
summary: "R statistics dataviz plotly housing mortgage data"
group: navigation
theme :
  name : lentheme
---

WE ARE ONE MONTH INTO 2017 AND WITH THIS MONTH'S economic releases we've completed most of the picture of 2016. These data by and large matched our expectations as I [outlined in my 2016 year-in-review]({{ site.url}}/chartbooks/dec2016/index.html).

Let's take a quick look.

# Existing homes sales best in a decade

Last week the National Association of Realtors (NAR) [reported](https://www.nar.realtor/news-releases/2017/01/existing-home-sales-slide-in-december-2016-sales-best-since-2006) on existing home sales for December of 2016.  On a seasonally adjusted basis home sales declined 2.8 percent from November's pace.
Despite the fact that home sales slowed in December home sales finished their best year in a decade.  Lack of inventory on increased mortgage interest rates contributed to the slowdown in existing home sales.  

Nevertheless existing home sales for 2016 outpaced the past 9 years:


![plot of chunk ehs-graph](/img/Rfig/ehs-graph-1.svg)

### As a gif

We can also view these data as an animated gif:

<img src="{{ site.url}}/img/charts_jan_30_2017/ehs 2016.gif" >


### New home sales low by historical standards

On Thursday of last week, the U.S. Census Bureau and HUD [reported](https://www.census.gov/construction/nrs/pdf/newressales.pdf) on new home sales for December 2016. New home sales also dipped a bit in December, though the month-to-month change was not statistically significant. However, sales are still well below the levels we saw last decade, even before the housing boom.

The graph below shows the trend in monthly new home sales, and has a shaded region to account for uncertainty in the monthly estimates.

![plot of chunk new-sales-fig](/img/Rfig/new-sales-fig-1.svg)

For more details about last year check out my 2016 [year-in-review]({{ site.url}}/chartbooks/dec2016/index.html) and also check out the interactive [flexdashboard version]({% post_url 2017-01-14-year-in-review-remix %}).
