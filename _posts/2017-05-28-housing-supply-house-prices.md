---
layout: post
title: "Housing supply, population, and house prices: The macro view"
author: "Len Kiefer"
date: "2017-05-28"
summary: "R statistics dataviz ggplot2 housing mortgage data"
group: navigation
theme :
  name : lentheme
---






I travel around the United States giving talks, usually updates on recent trends in housing and mortgage markets.  Often I get the chance to speak with real estate and mortgage professionals. For over two years, since at least 2015, I’ve heard one common theme: housing supply is tight.  It’s difficult to find a home, particularly for first time homebuyers.

It doesn’t matter if I’m in Cincinnati or Detroit, Denver or Dallas, Las Vegas or Los Angeles.  It’s the same thing.  We can’t find enough homes to buy.  

You know what I tell folks?  Same thing I said back in 2015: if you think housing markets are tight this year, wait until next year.  The market’s likely to be even tighter next year, and the year after tighter still. What’s going on?

### *Quick note on code* 

Often in this space I provide links to [R](https://www.r-project.org/) code for wrangling data and creating plots. In this post, I will not be sharing the code. That will come in a sequel. Where I have already included code I will supply links. Look for code on new and interesting plots in a future post. 

# The macro view

It helps to start with the big picture. The United States is a vast nation, with over 300 million people, 125 million households, and 130 million housing units.  The U.S. population and housing stock are slow moving.  Houses are durable, lasting decades, centuries in some cases. People too. It takes a while for things to change.

But they do change. Over time, the next generation comes of age and begins forming households. To meet the needs of a growing population the housing stock needs to expand.

Let's talk a bit about how things move.  Per estimates from the National Association of Home Builders (NAHB) it takes about seven months to build a single-family home. ([See report]( http://eyeonhousing.org/2016/07/time-to-build-a-single-family-home-in-2015/)). An apartment takes longer, around a year. The long lag between a housing start and completion means new supply only can respond gradually to changes in demand. 

Demand on the other hand, is in certain respects even slower moving. Demographic forces drive a shifting U.S. population, but over decades. Young adults start forming households in their early 20s, but the current crop of young adults are taking longer to reach many important life milestones. See this [Census report]( https://www.census.gov/content/dam/Census/library/publications/2017/demo/p20-579.pdf) for a comparison of today's young adults with prior generations. One of the key differences between young adults today and prior generations is delayed marriage. Per the report, in the 1970s 8 in 10 people were married by the time they turned 30, today it's not until the age of 45 that 8 in 10 have married.

Although young adults have been slow to form households they are starting to show up in the market.  When we look at estimates of recent building activity and demographic trends what do we see?

The U.S. Census Bureau and Department of Housing and Urban Development (HUD) publish monthly estimates of new residential construction. See their [latest report]( https://www.census.gov/construction/nrc/pdf/newresconst.pdf). The report tells us how many privately owned housing units were completed in a given month.  For example, the latest report (released May 16, 2017) tells us that privately-owned housing completions in April 2017 were at a seasonally adjusted annual rate of 1,106,000. 

A 1.1 million annual rate of completions is well below what we need to match long-run demand.  Here’s why.

First, completions are only a gross measure, they don’t account for demolitions and other losses to the housing stock.  Per the Components of Inventory Change report from HUD ([see report]( https://www.huduser.gov/portal/datasets/cinch/cinch13/cinch11-13.pdf)) over a two-year period from 2011 to 2013 the U.S. housing stock lost over 700,000 housing units permanently.  The report indicates that the housing stock lost 1.1 million units over that period, but about 400,000 of those were temporary losses.  Temporary losses include conversions to commercial use and badly damaged/condemned units that can be restored.  Roughly, the U.S. is losing about 350,000 units each year permanently and another 200,000 temporarily. 

Second, you have to supply new units for net new households.
Out of the 1.1 million housing units completed, 350,000 need to cover permanent losses. That leaves us with approximately 750,000 net completions. According to the latest population estimates from the U.S. Census ([LINK]( https://www.census.gov/programs-surveys/popest/data/tables.html))  the U.S. population ages 18 and over increased 0.9% from 2015 to 2016.  There are about 125 million households. Roughly, we should expect to see about 1.1 million (0.9% x 125 million) new households formed each year. They'll be looking for a place to live.  

Third and finally, you also have to figure second home demand.  See again the [NAHB]( http://eyeonhousing.org/2016/12/top-posts-of-2016-where-are-the-nations-second-homes/).  Per the NAHB calculations, second homes account for about 5.6 percent of the total U.S. housing stock, increasing by about 0.6 million from 2009 to 2014. That figure suggests that second home demand is between 100,000 and 200,000 units per year.  

Adding it all up suggests you need around 1.65 million housing units each year to meet long-run demand. But the U.S. is only building at a 1.1 million housing units per year rate. If current trends continue, we’ll end up half a million housing units short of long-run demand this year.  Consider the graph below.


![plot of chunk 05-28-2017-comp-plot-1](/img/Rfig/05-28-2017-comp-plot-1-1.svg)

And that is after several years of low levels of home building.  In 2011, less than 600,000 housing units were completed in the United States.  Since then, construction has picked up, but is nowhere near long-run demand.  Each year, the number of additional housing units fails to keep pace with underlying demand, housing markets get tighter and tighter. For more, including a discussion of vacancies, see my post [vacant housing: from surplus to shortage]({% post_url 2016-04-30-vacant-housing-from-surplus-to-shortage%}). That post is from last year, but the major themes are still true today.

House prices reflect these trends.  Nationally, prices are increasing over 6 percent annually. The rate of house price growth is well above rent growth, income growth, and the rate of increase of non-housing prices. The graph below plots trends in these metrics since 1991. (See [this post]({% post_url 2017-04-11-Fred-plot%})  for R code to get data and generate the graph below).

![plot of chunk fig-05-028-2017-1](/img/Rfig/fig-05-028-2017-1-1.svg)

The graph shows the trends in house prices, rents, per capita disposable income, and a measure of non-housing consumer prices.  What we see is that since 1991, income has grown fastest.  For a time last decade house prices rose well above incomes, but fell back down during the Great Recession.  Since 2012, house prices have been growing fastest, though they haven’t caught up to income yet. Non-housing prices (things like food, apparel and services) have been rising slowest. Though you’d find interesting patterns looking at various components, see [this post]({% post_url 2017-05-21-consumer-price-household-debt%}) for more on consumer price trends.

# Population and housing unit trends

Here we will dig into some [recently released](https://www.census.gov/newsroom/press-releases/2017/cb17-81-population-estimates-subcounty.html) Census data on population and housing unit growth. 

## Some basic population and housing unit trends

Let us begin by looking at some basic information on population and housing units. The Census data provides estimates down to the county level of the resident population and housing units in July of each year from 2010 through 2016. 

![plot of chunk fig-05-028-2017-pop-1](/img/Rfig/fig-05-028-2017-pop-1-1.svg)

The plot above shows that while the U.S. population expanded by 14 million from 2010 to 2016 (from 309 to 323 million) the U.S. housing stock only expanded by 4 million units from 2010 to 2016 (132 to 136 million). Another way of looking at these data is to consider the ratio of people to housing units. The graph below plots that relationship.

![plot of chunk fig-05-028-2017-pop-2](/img/Rfig/fig-05-028-2017-pop-2-1.svg)

In 2010 there were 2.347 people for every housing unit in the United States.  That expanded to 2.381 people for every housing unit by 2016. Fixing the 2016 population at 323 million, to keep the ratio of people per housing units at the 2010 level the housing stock would need to expand by 2 million units. And based on our calculations above, we are falling behind by about a half million additional units every year.

That tight inventory story we heard about to start? We're going to be hearing a lot more about it.

# Regional story

The national view obscures some important regional trends.

As we have documented in a variety of ways, local housing markets differ.  See for example:

* [State house prices relative to national prices]({% post_url 2017-05-18-state-hpa%})

* [Metro house prices, dot chart and geo tour]({% post_url 2017-05-02-house-price-viz
%})

* [Bivariate choropleth maps of employment and house prices]({% post_url 2017-04-25-bivariate-animate
%})

* [Horizon charts]({% post_url 2017-04-23-horizon
%})

* [Comparing the distribution household income to house values by metro area]({% post_url 2017-04-16-house-price-to-income-acs-2015
%})

* [An interactive flexdashboard]({% post_url 2017-01-22-build-flex
%})

In my next post, we'll dig into the regional data, exploring in depth some of the key trends. To do so, we'll need to explore (and explain) this figure.


![plot of chunk fig-05-028-2017-bivariate-map-1](/img/Rfig/fig-05-028-2017-bivariate-map-1-1.svg)

See you next time.
