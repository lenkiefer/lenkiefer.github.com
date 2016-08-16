---
layout: post
title: "Consumer Credit Trends Part 2: Data doesn't drive, it's lucky to be in the car"
author: "Len Kiefer"
date: "2016-08-15"
summary: "rstats data visualizations of housing data, consumer credit"
group: navigation
theme :
  name : lentheme
---
<style>
  .col2 {
    columns: 2 200px;         /* number of columns and width in pixels*/
    -webkit-columns: 2 200px; /* chrome, safari */
    -moz-columns: 2 200px;    /* firefox */
  }
  .col3 {
    columns: 3 100px;
    -webkit-columns: 3 100px;
    -moz-columns: 3 100px;
  }
</style>

A FEW DAYS AGO I [POSTED]({% post_url 2016-08-09-trends-in-credit %}) on trends in household debt using data from the the New York Federal Reserve Bank's [Consumer Credit Panel](https://www.newyorkfed.org/microeconomics/data.html).  The post got many responses, some observing that while student debt has grown a lot the absolute level of it is small relative to mortgage debt.  

I had made that point in my post, but the pictures caught the attention of many who didn't read the post or catch the point. The image of exploding student debt resonated with experience. Especially when animated in a gif.

But let me post another graph using the same data that seems to make a different point.



The original graph (in levels without mortgages) is below:

![plot of chunk debt-2016q2-levels](/img/Rfig/debt-2016q2-levels-1.svg)

Here I compare the graph in levels without mortgages to the graph with mortgages.



![plot of chunk debt-2016q2-levels-compare-1](/img/Rfig/debt-2016q2-levels-compare-1-1.svg)

Once you include mortgages the dramatic increase in student loan debt has a little more context.

And the gifs below show debt indexed so 2003 Q1 =100 on the left or in log dollars on the right.

<div class="columns-2">

<img src="{{ site.url }}/img/charts_aug_15_2016/debt balances 2016Q2 v4.gif" alt="credit gif" style="width: 350px;"/>

<img src="{{ site.url }}/img/charts_aug_15_2016/debt balances v3 2016Q2.gif" alt="credit gif v2" style="width: 350px;"/>

</div>

## Data doesn't drive, it's lucky to be in the car

I think both graphs are informative, but they seem to tell a different story.  The one on the left speaks of exploding student debt, while the one on the right makes clear that mortgage debt is still vastly larger.  Both are valid observations.

In fact, these charts are only the beginning point for any analysis.  They raise interesting questions, which are currently areas of active research. The recent *growth rate* of student debt looks unsustainable, but the *level* of student debt is still small relative to mortgages.

What this example makes clear is that as a data analyst it's important to look at data from a variety of perspectives. 

Of course, this throws into question the whole concept of data-driven analysis.  It's incredibly unlikely that in almost any circumstance data alone overwhelming supports one position unless you're able to arrive at data through rigorous scientific procedures. And that is incredibly unlikely in most economic studies. In most circumstances, data is lucky to be in the car let alone be behind the wheel.


