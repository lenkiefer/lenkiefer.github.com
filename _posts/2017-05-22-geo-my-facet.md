---
layout: post
title: "Facet my geo"
author: "Len Kiefer"
date: "2017-05-22"
summary: "R statistics dataviz ggplot2 housing mortgage data"
group: navigation
theme :
  name : lentheme
---

TIME TO TRY OUT ANOTHER HOUSE PRICE VISUALIZATION.

In this post I'll new way to visualize recent house price trends with [R](https://www.r-project.org/). 

Saw a new package [geofacet](https://github.com/hafen/geofacet) for organizing ggplot2 facets along a geographic grid.  It allows use to construct a small multiple graph that roughly looks like the United States. (Thanks to [@yoniceedee](https://twitter.com/yoniceedee) for recommending geofacet). 

Let's try it out using the same house price data we [visualized recently]({% post_url 2017-05-18-state-hpa %}). Details about the data are in that post, but we'll be using the [Freddie Mac House Price Index](http://www.freddiemac.com/finance/house_price_index.html) to once again visualize state house price trends.

Let's get to it.

# Data

We'll start this post with our data in hand. Just follow along [here]({% post_url 2017-05-18-state-hpa %}) to get the data.  We'll begin with a data frame called `df.state` that looks like so.

<!--html_preserve--><table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='13' style='text-align: left;'>
Our data frame
df.state</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>date</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>geo</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>hpi</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>type</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>hpa</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>hpilag12</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>hpimax12</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>hpimin12</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>us.hpa</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>us.hpi</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>up</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>down</th>
</tr>
</thead>
<tbody>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>1</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>2017-03-01</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>WY</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>185.378</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>state</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.005</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>184.419</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>188.57</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>184.419</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.064</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>170.711</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.064</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.005</td>
</tr>
</tbody>
<tfoot><tr><td colspan='13'>
Source: Freddie Mac House Price Index</td></tr></tfoot>
</table><!--/html_preserve-->

The key variable we'll need is `hpa` which captures the 12-month percent change in the house price index. Conveniently, we already have a state identifier to use with `facet_geo` (though we'll have to rename it state).

## Facet my geo

With our data in hand, it's pretty easy to create our plot.  Our data goes from 1975 to March 2017, so we'll subset it to focus on more recent trends.  We'll plot 12-month percent changes in house prices (variable `hpa` in our data) since 2000. We'll also restrict our attention to March of each year (so we can end with the latest data in March 2017).


{% highlight r %}
### Run this to get library: 
# devtools::install_github("hafen/geofacet")
library(ggplot2)
library(viridis)
library(scales)
library(geofacet)

## Subset data and drop US averages
df.state2<-filter(df.state, 
                  year(date)>1999 & month(date)==3 & 
                    !(geo %in% c("United States not seasonally adjusted",
                                        "United States seasonally adjusted" )))

# set up date limits for plot
xlim<-c(min(df.state2$date),max(df.state2$date))

# create state variable
df.state2$state<-df.state2$geo

# create plot:
ggplot(df.state2, aes(x=date, y=hpa,fill=hpa)) +
  
  # geom col for little bars
  geom_col()+
  
  # use facet_geo
  facet_geo(~ state, grid = "us_state_grid2")+
  
  # my go to theme
  theme_minimal()+

  # the colors!
  scale_fill_viridis(option="C",limits=c(-0.35,0.35),
                     label=percent,name="12-month\n% change")+

  # set up x (date) and y (HPA) axes
  scale_x_date(limits=xlim,breaks=xlim,date_labels="%y")+
    
  scale_y_continuous(label=percent,limits=c(-0.35,0.35),
                     breaks=seq(-0.3,.3,.3))+
  
  # labels, title, caption
  labs(x="",y="",
       title="House Price Appreciation",
       subtitle="12-month percent change in March",
       caption="@lenkiefer Source: Freddie Mac House Price Index")+
  
  # adjust theme
  theme(plot.caption=element_text(hjust=0),
        # need to shrink axis text
        axis.text.x=element_text(size=7), 
        plot.subtitle=element_text(face="italic"),
        legend.position="top")
{% endhighlight %}

![plot of chunk 05-22-2017-plot1](/img/Rfig/05-22-2017-plot1-1.svg)

Pretty neat.  I think I'll be trying this more in the future.

It also works pretty great for an animation. Here's an animated version of our plot:

<img src="{{ site.url}}/img/charts_may_22_2017/geo facet hpa 05 22 2017.gif" >

