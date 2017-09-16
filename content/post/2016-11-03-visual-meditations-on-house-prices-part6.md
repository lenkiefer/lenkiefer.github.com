---
title: 'Visual meditations on house prices, Part 6: state recovery'
author: Len Kiefer
date: '2016-11-03'
slug: 2016-11-03-visual-meditations-on-house-prices-part6
categories: ["dataviz"]
tags: ["dataviz","house prices", "R"]
---
# Introduction

HOUSE PRICES HAVE NOW RECOVERED BACK TO THEIR PRE-RECESSION PEAK, at least according to some indices.  The [Freddie Mac House Price Index](http://www.freddiemac.com/finance/house_price_index.html), for example, surpassed its pre-2008 peak in the latest release for data through September 2016. In this post I'll be exploring trends in house prices and exploring different ways of showing how far house prices have come, and in some cases, how far they still have to go.

Time for some new visual meditations on house prices.

For reference, the prior meditation are listed below, and I'll keep an updated list of all of them [here](../../../../2016/05/08/visual-meditations-on-house-prices ).


* [Part 1: data wrangling ](../../../../2016/05/08/visual-meditations-on-house-prices-part1 )
* [Part 2: sparklines and dots (animated) ](../../../../2016/05/08/visual-meditations-on-house-prices-part2 )
* [Part 3: bubbles and bounce ](../../../../2016/05/10/visual-meditations-on-house-prices-part3 )
* [Part 4: graph gallery ](../../../../2016/05/14/visual-meditations-on-house-prices-part4 )
* [Part 5: distributions ](../../../../2016/08/13/visual-meditations-on-house-prices-part5 )

These visualizations will be made in R, and I'll post code for some of the graphs at the bottom.

## The data

As [before](../../../../2016/05/08/visual-meditations-on-house-prices-part1 ), we'll be using the Freddie Mac House Price Index for many of these visualizations.  We're going to need a text file organized as described in that post. Just follow those examples to set up the data.  Or you can download the two text files below:

1. [*state and national called fmhpi.txt*](../../../../img/charts_nov_3_2016/fmhpi2016q3.txt)
2. [*metro called fmhpi2.txt*](../../../../img/charts_nov_3_2016/fmhpi2016q3metro.txt)






![plot of chunk fig-hpimed6-viz1](/img/Rfig/fig-hpimed6-viz1-1.svg)

This plot shows the seasonally-adjusted index for the United States. In September of 2016 the index was at 165.25, just above (0.1%) the pre-2008 peak of 165.06.

The story varies quite a bit across the country. While the national average is just abvoe the pre-2008 peak, some states are above and some are below.

## State trends

### Maps

First, let's look at a map of annual house price appreciation by state, September 2015 to September 2016:

![plot of chunk fig-hpimed6-viz2](/img/Rfig/fig-hpimed6-viz2-1.svg)

We can contrast this with a map showing the percentage difference between the September 2016 index and that state's pre-2008 peak.


![plot of chunk fig-hpimed6-viz3](/img/Rfig/fig-hpimed6-viz3-1.svg)

This map reveals that North Dakota, Colorado, and Texas have had the fastest house price appreciation relative to their pre-2008 peak (45%, 38%, and 35% respectively). On the other end, Nevada, Connecticut  and Arizona are the lowest relative to their pre-2008 peak at -24%, -20%, and -18% respectively.

It would be interesting to compare the rank of states in terms of year-over-year house price appreciation.

![plot of chunk fig-hpimed6-viz3b](/img/Rfig/fig-hpimed6-viz3b-1.svg)

We can also construct a panel plot comparing the last few years:

![plot of chunk fig-hpimed6-viz3c](/img/Rfig/fig-hpimed6-viz3c-1.svg)

Early in the housing recovery the central United States, pretty much a straight path from Texas up to North Dakota had the fastest house price growth (or least decline).  But as the recovery has progressed, growth has accelerated in the West and in Florida.

The animated gif below shows how the rankings have changed each September from 1980-2016:

<img src="../../../../img/charts_nov_3_2016/fmhpi map 2016q3 v4.gif" alt="hpa rank map gif"/>

## Dot plot

In an [earlier post](../../../../2016/05/08/visual-meditations-on-house-prices-part2 ) I described how to make the following dotplot: 

![plot of chunk fig-hpimed6-viz4](/img/Rfig/fig-hpimed6-viz4-1.svg)

The plot shows the value of the house price index in September 2016 relative to the past 12 months.  The color corresponds to the pace of house price appreciation, and the tail represents the range of the index over the past 12 months.

Hawaii has the highest index value (meaning that house prices have grown most in HI relative to December 2000), but the fastest year-over-year growth has been in Washington state.  You can see that in the graph by the blueness of the dot and in the length of the tail.

This is a fun graph to animate:

<img src="../../../../img/charts_nov_3_2016/redbluedot 2016q3.gif" alt="red blue gif"/>

## Metro trends

We can also look at trends at the metro level, which will be the topic of a future post.

# Code for these plots

Here is the code I used, using the data files I linked to above, to create these graphics.  Note that I'm use R and the development version of ggplot2.



{% highlight r 
#Load some packages
library(data.table, warn.conflicts = FALSE, quietly=TRUE)
library(ggplot2, warn.conflicts = FALSE, quietly=TRUE)
library(dplyr, warn.conflicts = FALSE, quietly=TRUE)
library(zoo, warn.conflicts = FALSE, quietly=TRUE)
library(ggrepel, warn.conflicts = FALSE, quietly=TRUE)
library(ggthemes, warn.conflicts = FALSE, quietly=TRUE)
library(scales, warn.conflicts = FALSE, quietly=TRUE)
library(animation, warn.conflicts = FALSE, quietly=TRUE)
library(grid, warn.conflicts = FALSE, quietly=TRUE)
library(tidyr, warn.conflicts = FALSE, quietly=TRUE)
library(rgeos, warn.conflicts = FALSE, quietly=TRUE)
library(maptools, warn.conflicts = FALSE, quietly=TRUE)
library(albersusa, warn.conflicts = FALSE, quietly=TRUE)

#load data
statedata <- fread("data/fmhpi2016q3.txt")
statedata$date<-as.Date(statedata$date, format="%m/%d/%Y")

#Now uses some data table calculations to compute percent changes in house prices by state/metro
statedata<-statedata[,hpa:=c(NA,((1+diff(hpi)/hpi))^12)-1,by=state]  
statedata<-statedata[,hpa12:=c(rep(NA,12),((1+diff(hpi,12)/hpi))^1)-1,by=state]  

#compute pre-2008 peak
statedata[,hpi.max08:=max(ifelse(year<2009,hpi,0),na.rm=T),by=state]

#compute post-2008 trough
statedata[,hpi.min08:=min(ifelse(year>2008,hpi,1000),na.rm=T),by=state]


#do map stuff
states<-usa_composite()
statedata[,iso_3166_2:=state]  #rename state to match usa_composite
statedata[,hpi.comp:=hpi/hpi.max08-1]  #compute house price growth relative to pre-2008 peak
statedata<-statedata[!(state %in% c("US.SA","US.NSA"))]
statedata[,hparank:=rank(-hpa12),by=date]

#create an indicator for house price appreciation relative to pre-2008 peak
statedata[,hpi.compd:=ifelse(hpi.comp< -0.25,"<-25%",
                             ifelse(hpi.comp< -0.05,"-25% to -5%",
                                    ifelse(hpi.comp<0,"-5% to 0%",
                                           ifelse(hpi.comp<0.05,"0% to +5%",
                                                  ifelse(hpi.comp<0.25,"+5% to +25%",
                                                         ">+25%")))))     ]
statedata$hpi.compd<-factor(statedata$hpi.compd, levels=unique(statedata$hpi.compd))
smap<-fortify(states,region="fips_state")
states@data <- left_join(states@data, statedata, by = "iso_3166_2")



#make annual percent change map:
ggplot() +
  geom_map(data = smap, map = smap,
           aes(x = long, y = lat, map_id = id),
           color = "#2b2b2b", size = 0.05, fill = NA) +
  geom_map(data =subset(states@data,year==2016 & month==9), map = smap,
           aes( map_id = fips_state,fill=hpa12),
           color = "gray", size = .25) +
  theme_map( base_size = 12) + 
  theme(plot.title=element_text( size = 16, margin=margin(b=10))) +
  theme(plot.subtitle=element_text(size = 14, margin=margin(b=-20))) +
  theme(plot.caption=element_text(size = 9, margin=margin(t=-15))) +
  coord_proj(us_laea_proj) +   labs(title="",subtitle="" ) +
  scale_fill_viridis(name = "", discrete=F,option="D",end=0.95, 
                     direction=1,limits=c(0,0.12),
                     label=percent
                     )+
  theme(legend.position = "top") +theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  labs(title="Annual House Price Growth (Y/Y %)",

       caption="@lenkiefer Source: Freddie Mac House Price Index (Not Seasonally adjusted)")
{% endhighlight 

![plot of chunk unnamed-chunk-2](/img/Rfig/unnamed-chunk-2-1.svg)

{% highlight r 
#make comparison to pre-2008 peak map

ggplot() +
  geom_map(data = smap, map = smap,
           aes(x = long, y = lat, map_id = id),
           color = "#2b2b2b", size = 0.05, fill = NA) +
  geom_map(data =subset(states@data,year==2016 & month==9), map = smap,
           aes( map_id = fips_state,fill=hpi.compd),
           color = "gray", size = .25) +
  theme_map( base_size = 12) + 
  theme(plot.title=element_text( size = 16, margin=margin(b=10))) +
  theme(plot.subtitle=element_text(size = 14, margin=margin(b=-20))) +
  theme(plot.caption=element_text(size = 9, margin=margin(t=-15))) +
  coord_proj(us_laea_proj) +   labs(title="",subtitle="" ) +
  scale_fill_viridis(name = "", discrete=T,option="D",end=0.95 )+
  theme(legend.position = "top") +theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  labs(title="House Prices in September 2016 relative to pre-2008 peak",
             caption="@lenkiefer Source: Freddie Mac House Price Index (Not Seasonally adjusted)")
{% endhighlight 

![plot of chunk unnamed-chunk-2](/img/Rfig/unnamed-chunk-2-2.svg)

{% highlight r 
# State annual house price appreciation rank map

ggplot() +
    geom_map(data = smap, map = smap,
             aes(x = long, y = lat, map_id = id),
             color = "#2b2b2b", size = 0.05, fill = NA) +
    geom_map(data =subset(states@data,year>2015 & month==mm), map = smap,
             aes( map_id = fips_state,fill=hparank),
             color = "gray", size = .25) +
  
    theme_map( base_size = 12) + 
    theme(plot.title=element_text( size = 16, margin=margin(b=10))) +
    theme(plot.subtitle=element_text(size = 14, margin=margin(b=-20))) +
    theme(plot.caption=element_text(size = 9, margin=margin(t=-15))) +
    coord_proj(us_laea_proj) +   labs(title="",subtitle="" ) +
    scale_fill_viridis(name = "", discrete=F,option="D",end=0.95, 
                       direction=-1)+
    theme(legend.position = "top") +theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    labs(title="Rank for state + D.C. annual house price growth (1 to 51)",
         subtitle="September of 2016",
         caption="@lenkiefer Source: Freddie Mac House Price Index (Not Seasonally adjusted)")
{% endhighlight 

![plot of chunk unnamed-chunk-2](/img/Rfig/unnamed-chunk-2-3.svg)

{% highlight r 
# State annual house price appreciation rank map, panel 2008-2016

ggplot() +
    geom_map(data = smap, map = smap,
             aes(x = long, y = lat, map_id = id),
             color = "#2b2b2b", size = 0.05, fill = NA) +
    geom_map(data =subset(states@data,year>2007 & month==mm), map = smap,
             aes( map_id = fips_state,fill=hparank),
             color = "gray", size = .25) +
  
    theme_map( base_size = 12) + facet_wrap(~year,ncol=3)+
    theme(plot.title=element_text( size = 16, margin=margin(b=10))) +
    theme(plot.subtitle=element_text(size = 14, margin=margin(b=-20))) +
    theme(plot.caption=element_text(size = 9, margin=margin(t=-15))) +
    coord_proj(us_laea_proj) +   labs(title="",subtitle="" ) +
    scale_fill_viridis(name = "", discrete=F,option="D",end=0.95, 
                       direction=-1 )+
    theme(legend.position = "top") +theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    labs(title="Rank for state + D.C. annual house price growth (1 to 51)",
         subtitle="September of year",
         caption="@lenkiefer Source: Freddie Mac House Price Index (Not Seasonally adjusted)")
{% endhighlight 

![plot of chunk unnamed-chunk-2](/img/Rfig/unnamed-chunk-2-4.svg)

