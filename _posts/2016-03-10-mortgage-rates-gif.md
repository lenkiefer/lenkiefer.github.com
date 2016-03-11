---
layout: post
title: "How I make my mortgage rates gif"
summary: "Charting weekly mortgage rates trends with animation"
group: navigation
theme :
  name : lentheme
---
{% include JB/setup %}

## Making a data viz

SOMETIMES ANIMATION CAN BE USEFUL, though it is often misused. I've been tracking the week-to-week changes in <a href="http://www.freddiemac.com/pmms/index.html">mortgage rates</a>, and animating with a GIF.

### Example animated gif with mortgage rates from 1/1/2013 to 3/10/2016

<img src="{{ site.url }}/img/dataviz/rate_3_10_2016_long.gif" alt="Wage growth" style="width: 450px;"/>

I build my gif using the <a href="http://www.r-project.org/">R statistical package</a>.  

Perhaps I'll explain more of the details later, but the R code below uses the ggplot2, ggthemes and animation packages to create the plots, style them, and save the animation.

{% include makingthegif.html %}